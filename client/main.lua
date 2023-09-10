lib.locale()

---@type number[]
Blips = {}

---@type CPoint[]
Points = {}

---@type number[]
ShopNpcs = {}

local vehiclePreview = nil
local playerLoaded = false
local _playerInShop = false
local lastCoords = vector3(0)
local loadingVehicle = false
local _inv = exports.ox_inventory
local vehicleInvData = {}

if Config.LoadVehicleShopInterior then
    local interiorID = 7170

    RequestIpl("shr_int")
    LoadInterior(interiorID)
    EnableInteriorProp(interiorID, "csr_beforeMission")
    RefreshInterior(interiorID)
end

local function hex2rgb(hex)
    local hex = hex:gsub("#", "")
    return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
end

local function loadData()
    local file = "data/vehicles.lua"
    local import = LoadResourceFile("ox_inventory", file)
    local chunk = assert(load(import, ('@@ox_inventory/%s'):format(file)))

    if not chunk then
        return
    end

    local vehData = chunk()

    vehicleInvData.trunk = vehData.trunk
    vehicleInvData.glovebox = vehData.glovebox
end

local function groupDigs(number, separator)
    local left, num, right = string.match(number, '^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)', '%1' .. (separator or ',')):reverse()) .. right
end

local function notification(title, msg, _type)
    lib.notify({
        title = title or '[_ERROR_]',
        duration = Config.notifDuration,
        description = msg,
        position = Config.menuPosition == 'right' and 'top-left' or 'top-right',
        type = _type or 'info'
    })
end

local function DeleteVehiclePreview()
    if not vehiclePreview then return end
    if not DoesEntityExist(vehiclePreview) then return end

    SetEntityAsMissionEntity(vehiclePreview, true, true)
    DeleteVehicle(vehiclePreview)
    vehiclePreview = nil
end

local function _spawnLocalVehicle(_shopIndex, _selected, _scrollIndex)
    DeleteVehiclePreview()

    if loadingVehicle or vehiclePreview then return end

    local _data = Config.vehicleShops[_shopIndex]
    local _model = Config.vehicleList[_data.vehicleList][_selected].values[_scrollIndex].vehicleModel

    loadingVehicle = true
    -- 10000 ticks timeout for some high quality models
    if not lib.requestModel(_model, 10000) then
        loadingVehicle = false
        return
    end
    loadingVehicle = false

    vehiclePreview = CreateVehicle(_model, _data.previewCoords.x, _data.previewCoords.y, _data.previewCoords.z,
        _data.previewCoords.w, false, false)
    SetPedIntoVehicle(cache.ped, vehiclePreview, -1)
    if GetVehicleDoorLockStatus(vehiclePreview) ~= 4 then
        SetVehicleDoorsLocked(vehiclePreview, 4)
    end

    SetVehicleEngineOn(vehiclePreview, false, true, true)
    SetVehicleHandbrake(vehiclePreview, true)
    SetVehicleInteriorlight(vehiclePreview, true)
    FreezeEntityPosition(vehiclePreview, true)

    if GetVehicleClass(vehiclePreview) == 14 then
        SetBoatAnchor(vehiclePreview, true)
    end

    if GetVehicleClass(vehiclePreview) == 15 or GetVehicleClass(vehiclePreview) == 16 then
        SetHeliMainRotorHealth(vehiclePreview, 0)
    end

    return vehiclePreview
end



local function proceedPayment(useBank, _shopIndex, _selected, _secondary)
    if not useBank then
        local count = _inv:Search('count', 'money')
        if count < Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_secondary].vehiclePrice then
            notification(Config.vehicleShops[_shopIndex]?.shopLabel,
                locale('not_enough_money',
                    Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_secondary]
                    .vehiclePrice), 'error')
            lib.showMenu('vehicleshop')
            return
        end
    end

    local success = lib.callback.await('lsrp_vehicleShop:server:payment', false, useBank, _shopIndex, _selected,
        _secondary)
    print(success)
    if not success then
        notification(Config.vehicleShops[_shopIndex]?.shopLabel or '[_ERROR_]', locale('transaction_error'), 'error')
        lib.showMenu('vehicleshop')
        return
    end

    if success == 'license' then
        notification(Config.vehicleShops[_shopIndex]?.shopLabel or '[_ERROR_]', locale('license'), 'error')
        lib.showMenu('vehicleshop')
        return
    end

    if success and vehiclePreview then
        local vehicleAdded, vehiclePlate, spotTaken, netId = lib.callback.await('lsrp_vehicleShop:server:addVehicle', 500,
            lib.getVehicleProperties(vehiclePreview),
            #lib.getNearbyVehicles(Config.vehicleShops[_shopIndex].vehicleSpawnCoords.xyz, 3, true), _shopIndex,
            _selected, _secondary)
        if vehicleAdded then
            local data = Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_secondary]
            DoScreenFadeOut(500)
            while not IsScreenFadedOut() do
                Wait(10)
            end

            DeleteVehiclePreview()

            PlaySoundFrontend(-1, 'Pre_Screen_Stinger', 'DLC_HEISTS_FAILED_SCREEN_SOUNDS', false)
            notification(Config.vehicleShops[_shopIndex]?.shopLabel,
                locale('success_bought',
                    Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_secondary].label,
                    vehiclePlate), 'success')

            SetEntityCoords(cache.ped, lastCoords.x, lastCoords.y, lastCoords.z, false, false, false, false)
            SetEntityVisible(cache.ped, true, false)
            DoScreenFadeIn(500)
            notification(Config.vehicleShops[_shopIndex]?.shopLabel or '[_ERROR_]',
                not spotTaken and locale('vehicle_pick_up', data.label, vehiclePlate) or
                locale('added_to_garage', data.label, vehiclePlate), 'success')

            for i = -1, 0 do
                local ped = GetPedInVehicleSeat(NetToVeh(netId), i)

                if ped ~= cache.ped and ped > 0 and NetworkGetEntityOwner(ped) == cache.playerId then
                    DeleteEntity(ped)
                end
            end

            return
        end

        notification(Config.vehicleShops[_shopIndex]?.shopLabel or '[_ERROR_]', locale('error_while_saving'), 'error')
    end
end

local function openVehicleSubmenu(_shopIndex, _selected, _scrollIndex)
    if not vehiclePreview then return end
    local subMenu = { _shopIndex, _selected, _scrollIndex }
    local vData = Config.vehicleList[Config.vehicleShops[subMenu[1]].vehicleList][subMenu[2]].values[subMenu[3]]
    local vClass = GetVehicleClass(vehiclePreview)
    local options = {
        {
            close = false,
            icon = 'info',
            label = locale('vehicle_info'),
            values = {
                {
                    label = locale('trunk'),
                    description = vehicleInvData.trunk[vClass] and
                        ('%s %s - %s kg'):format(vehicleInvData.trunk[vClass][1], locale('slots'),
                            groupDigs(vehicleInvData.trunk[vClass][2], '.')) or locale('notrunk'),
                },
                {
                    label = locale('glovebox'),
                    description = vehicleInvData.glovebox[vClass] and
                        ('%s %s - %s kg'):format(vehicleInvData.glovebox[vClass][1], locale('slots'),
                            groupDigs(vehicleInvData.glovebox[vClass][2], '.')) or locale('noglove'),
                },
                {
                    label = locale('est_speed'),
                    description = ('%.2f kmh'):format(GetVehicleModelEstimatedMaxSpeed(vData.vehicleModel) * 3.6),
                },
                {
                    label = locale('seats'),
                    description = GetVehicleModelNumberOfSeats(vData.vehicleModel),
                },
                {
                    label = locale('plate'),
                    description = GetVehicleNumberPlateText(vehiclePreview),
                },
            }
        }
    }

    if Config.vehicleColors.primary == true then
        options[#options + 1] = {
            close = false,
            icon = 'droplet',
            label = locale('primary_color'),
            description = locale('primary_color_desc'),
            menuArg = 'primary'
        }
    end

    if Config.vehicleColors.secondary == true then
        options[#options + 1] = {
            close = false,
            icon = 'fill-drip',
            label = locale('secondary_color'),
            description = locale('secondary_color_desc'),
            menuArg = 'secondary'
        }
    end

    options[#options + 1] = {
        label = 'Platba',
        icon = 'credit-card',
        menuArg = 'payment',
        description = locale('pay_in_cash', vData.vehiclePrice)
    }

    lib.registerMenu({
        id = 'openVehicleSubmenu',
        title = vData.label,
        position = Config.menuPosition == 'right' and 'top-right' or 'top-left',
        onSideScroll = function(selected, scrollIndex, args)
            if not options[selected].menuArg then
                return
            end
        end,
        onClose = function(keyPressed)
            lib.showMenu('vehicleshop')
        end,
        options = options
    }, function(selected, scrollIndex, args)
        if not selected then return end
        if options[selected].menuArg == 'payment' then
            local alert = lib.alertDialog({
                header = Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_scrollIndex]
                    .label,
                content = locale('confirm_purchase',
                    Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_scrollIndex]
                    .label,
                    groupDigs(Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values
                        [_scrollIndex].vehiclePrice)),
                centered = true,
                cancel = true,
                labels = { confirm = locale('confirm'), cancel = locale('cancel') }
            })

            if alert ~= 'confirm' then
                lib.showMenu('vehicleshop')
                return
            end

            proceedPayment(false, _shopIndex, _selected, _scrollIndex)
            return
        end

        if options[selected].menuArg == 'primary' or options[selected].menuArg == 'secondary' then
            lib.hideMenu(false)
            Wait(100)
            local input = lib.inputDialog(locale('colorize_vehicle'), {
                { label = 'Color', type = 'color', default = '#eb4034' },
            })
            if input then
                local r, g, b = hex2rgb(input[1])
                if options[selected].menuArg == 'primary' then
                    SetVehicleCustomPrimaryColour(vehiclePreview, r or 255, g or 0, b or 0)
                else
                    SetVehicleCustomSecondaryColour(vehiclePreview, r or 255, g or 0, b or 0)
                end
            end
            openVehicleSubmenu(subMenu[1], subMenu[2], subMenu[3])
            return
        end
    end)
    lib.showMenu('openVehicleSubmenu')
end

local function openMenu(_shopIndex)
    local hintShown = false
    lastCoords = GetEntityCoords(cache.ped)

    local options = {}
    local _vehicleClassCFG = Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList]

    for classIndex, classInfo in pairs(_vehicleClassCFG) do
        for i = 1, #classInfo.values do
            classInfo.values[i].description = locale('priceTag', groupDigs(classInfo.values[i].vehiclePrice))
        end

        options[#options + 1] = {
            label = locale(classInfo.label),
            description = classInfo.description,
            icon = classInfo.icon or 'car',
            arrow = true,
            values = classInfo.values,
            classIndex = classIndex
        }
    end

    lib.registerMenu({
        id = 'vehicleshop',
        title = Config.vehicleShops[_shopIndex].shopLabel,
        position = Config.menuPosition == 'right' and 'top-right' or 'top-left',
        onSideScroll = function(selected, scrollIndex, args)
            _spawnLocalVehicle(_shopIndex, selected, scrollIndex)
        end,
        onSelected = function(selected, scrollIndex, args)
            if not hintShown then
                notification('TIP', locale('tip'), 'inform')
                hintShown = true
            end
            _spawnLocalVehicle(_shopIndex, selected, scrollIndex)
        end,
        onClose = function(keyPressed)
            DoScreenFadeOut(500)
            while not IsScreenFadedOut() do
                Wait(50)
            end

            DeleteVehiclePreview()

            SetEntityCoords(cache.ped, lastCoords.x, lastCoords.y, lastCoords.z, false, false, false, false)
            Wait(500)
            SetEntityVisible(cache.ped, true, false)
            DoScreenFadeIn(500)
            Wait(1000)
        end,
        options = options
    }, function(selected, scrollIndex, args)
        if not selected or not scrollIndex then return end
        while not cache.vehicle and vehiclePreview do
            SetPedIntoVehicle(cache.ped, vehiclePreview, -1)
            Wait(5)
        end

        openVehicleSubmenu(_shopIndex, selected, scrollIndex)
    end)

    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(50)
    end

    SetEntityVisible(cache.ped, false, false)
    local coords = Config.vehicleShops[_shopIndex].previewCoords
    SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, false, false, false, false)
    --local selfInstance = lib.callback.await('lsrp_vehicleshop:setInstance', 5000, true)
    Wait(500)
    DoScreenFadeIn(500)
    lib.showMenu('vehicleshop')
end

local function onEnter(point)
    lib.showTextUI(locale('open_shop', point.shopLabel or '_ERROR'),
        { icon = point.shopIcon or 'car', position = "top-center" })
end

local function onExit(_)
    lib.hideTextUI()
end

local function nearby(point)
    if point.currentDistance <= 2 then
        if IsControlJustPressed(0, 38) and _playerInShop == false then
            lib.hideTextUI()
            openMenu(point.shopIndex)
        end
    end
end

local function createPoint(data)
    return lib.points.new({
        coords = data.shopCoords,
        distance = Config.textDistance,
        nearby = nearby,
        onEnter = onEnter,
        onExit = onExit,
        shopIcon = data.shopIcon,
        shopLabel = data.shopLabel,
        shopIndex = data.index
    })
end

local function createNpc(model, coords)
    lib.requestModel(model)
    local npcHandle = CreatePed(5, model, coords.x, coords.y, coords.z, coords.w, false, true)
    FreezeEntityPosition(npcHandle, true)
    SetEntityInvincible(npcHandle, true)
    SetBlockingOfNonTemporaryEvents(npcHandle, true)
    SetPedCanBeTargetted(npcHandle, false)
    SetEntityAsMissionEntity(npcHandle, true, true)
    TaskStartScenarioInPlace(npcHandle, 'WORLD_HUMAN_GUARD_STAND', -1, false)
    return npcHandle
end


local function mainThread()
    loadData()

    for index, shopData in pairs(Config.vehicleShops) do
        -- Setup blips
        if shopData.blipData then
            local blip = AddBlipForCoord(shopData.shopCoords.x, shopData.shopCoords.y, shopData.shopCoords.z)
            SetBlipSprite(blip, shopData.blipData.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, shopData.blipData.scale)
            SetBlipColour(blip, shopData.blipData.color)
            SetBlipSecondaryColour(blip, 255, 0, 0)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(shopData.shopLabel)
            EndTextCommandSetBlipName(blip)
            Blips[#Blips + 1] = blip
        end

        if Config.oxTarget and shopData.npcData then
            -- Setup npcs
            local npc = createNpc(shopData.npcData.model, shopData.npcData.position)
            local npcOptions = {
                {
                    name = 'vehicleshop',
                    icon = shopData.shopIcon or 'car',
                    label = locale('open_shop', shopData.shopLabel or '_ERROR'),
                    distance = 2.5,
                    onSelect = function(_)
                        openMenu(index)
                    end
                }
            }

            exports.ox_target:addLocalEntity(npc, npcOptions)
            ShopNpcs[#ShopNpcs + 1] = npc
        else
            -- Setup Points
            Points[#Points + 1] = createPoint({
                shopCoords = shopData.shopCoords,
                shopIcon = shopData.shopIcon,
                index = index,
                shopLabel = shopData.shopLabel
            })
        end
    end

    while playerLoaded do
        local playerCoords = GetEntityCoords(cache.ped)
        for _, shopData in pairs(Config.vehicleShops) do
            if not shopData.showcaseVehicle then goto continue end

            if #(playerCoords - shopData.shopCoords) > 150.0 then
                for i = 1, #shopData.showcaseVehicle do
                    if shopData.showcaseVehicle[i].handle then
                        if DoesEntityExist(shopData.showcaseVehicle[i].handle) then
                            SetEntityAsMissionEntity(shopData.showcaseVehicle[i].handle, true, true)
                            DeleteEntity(shopData.showcaseVehicle[i].handle)
                            shopData.showcaseVehicle[i].handle = nil
                        end
                    end
                end

                goto continue
            end


            if #(playerCoords - shopData.shopCoords) < 125.0 then
                for i = 1, #shopData.showcaseVehicle do
                    if shopData.showcaseVehicle[i].handle then goto continue2 end

                    local ModelHash = shopData.showcaseVehicle[i].vehicleModel
                    if not IsModelInCdimage(ModelHash) then return end
                    RequestModel(ModelHash)
                    while not HasModelLoaded(ModelHash) do
                        Wait(0)
                    end

                    local coords = shopData.showcaseVehicle[i].coords
                    shopData.showcaseVehicle[i].handle = CreateVehicle(ModelHash, coords.x, coords.y, coords.z, coords.w,
                        false, false)
                    SetEntityAsMissionEntity(shopData.showcaseVehicle[i].handle, true, true)
                    SetVehicleDoorsLocked(shopData.showcaseVehicle[i].handle, 2)
                    SetVehicleUndriveable(shopData.showcaseVehicle[i].handle, true)
                    SetVehicleDoorsLockedForAllPlayers(shopData.showcaseVehicle[i].handle, true)
                    SetVehicleDirtLevel(shopData.showcaseVehicle[i].handle, 0)
                    SetVehicleNumberPlateText(shopData.showcaseVehicle[i].handle, ('SHWCS%s'):format(i))
                    SetVehicleWindowTint(shopData.showcaseVehicle[i].handle, 3)
                    SetEntityInvincible(shopData.showcaseVehicle[i].handle, true)
                    SetVehicleDirtLevel(shopData.showcaseVehicle[i].handle, 0.0)
                    SetVehicleOnGroundProperly(shopData.showcaseVehicle[i].handle)
                    FreezeEntityPosition(shopData.showcaseVehicle[i].handle, true)
                    SetVehicleCustomPrimaryColour(shopData.showcaseVehicle[i].handle,
                        shopData.showcaseVehicle[i].color[1] or math.random(0, 255),
                        shopData.showcaseVehicle[i].color[2] or math.random(0, 255),
                        shopData.showcaseVehicle[i].color[3] or math.random(0, 255))

                    ::continue2::
                end
            end
            ::continue::
        end

        Wait(1500)
    end
end

AddEventHandler('onResourceStart', function(resource)
    if cache.resource ~= resource then return end

    if playerLoaded then
        return
    end
    playerLoaded = true
    CreateThread(mainThread)
end)

AddEventHandler('ox:playerLoaded', function()
    if playerLoaded then
        return
    end
    playerLoaded = true
    CreateThread(mainThread)
end)

AddEventHandler('ox:playerLogout', function()
    playerLoaded = false
    for i = 1, #Blips do
        if DoesBlipExist(Blips[i]) then
            RemoveBlip(Blips[i])
        end
    end
    Blips = {}

    for i = 1, #Points do
        local point = Points[i]
        point:remove()
    end
    Points = {}

    for i = 1, #ShopNpcs do
        local npc = ShopNpcs[i]
        DeletePed(npc)
    end
    ShopNpcs = {}

    for _, shopData in pairs(Config.vehicleShops) do
        if shopData.showcaseVehicle then
            for i = 1, #shopData.showcaseVehicle do
                if shopData.showcaseVehicle[i].handle then
                    while DoesEntityExist(shopData.showcaseVehicle[i].handle) do
                        SetEntityAsMissionEntity(shopData.showcaseVehicle[i].handle, true, true)
                        DeleteEntity(shopData.showcaseVehicle[i].handle)
                        Wait(100)
                    end
                end
            end
        end
    end

    lib.closeAlertDialog()
    lib.hideTextUI()

    SetEntityVisible(cache.ped, true, false)

    DeleteVehiclePreview()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (cache.resource ~= resourceName) then return end

    for i = 1, #Blips do
        if DoesBlipExist(Blips[i]) then
            RemoveBlip(Blips[i])
        end
    end
    Blips = {}

    for i = 1, #Points do
        local point = Points[i]
        point:remove()
    end
    Points = {}

    for i = 1, #ShopNpcs do
        local npc = ShopNpcs[i]
        DeletePed(npc)
    end
    ShopNpcs = {}

    for _, shopData in pairs(Config.vehicleShops) do
        if shopData.showcaseVehicle then
            for i = 1, #shopData.showcaseVehicle do
                if shopData.showcaseVehicle[i].handle then
                    CreateThread(function()
                        while DoesEntityExist(shopData.showcaseVehicle[i].handle) do
                            SetEntityAsMissionEntity(shopData.showcaseVehicle[i].handle, true, true)
                            DeleteEntity(shopData.showcaseVehicle[i].handle)
                            Wait(100)
                        end
                    end)
                end
            end
        end
    end

    lib.closeAlertDialog()
    lib.hideTextUI()

    SetEntityVisible(cache.ped, true, false)

    DeleteVehiclePreview()
end)

local function GeneratePlate()
    return lib.callback.await('lsrp_vehicleShop:server:generateplate', false)
end
exports('GeneratePlate', GeneratePlate)
