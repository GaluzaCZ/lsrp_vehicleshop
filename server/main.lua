local _inv = exports.ox_inventory

-- Do not rename resource or touch this part of code!
local function initializedThread()
    if GetCurrentResourceName() ~= 'lsrp_vehicleshop' then
        print('^1It is required! to keep the resource name original. Please rename the resource back.^0')
        StopResource(GetCurrentResourceName())
        return
    end

    print('^2LSRP Vehicleshop initialized^0')
end

lib.callback.register('lsrp_vehicleShop:server:payment', function(source, useBank, _shopIndex, _selected, _secondary)
    if not _shopIndex or not _selected or not _secondary then
        return false
    end


    local vehiclePrice = Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_secondary]
        .vehiclePrice

    if not tonumber(vehiclePrice) or vehiclePrice < 1000 then return false end

    if Config.vehicleShops[_shopIndex].license then
        local OxPlayer = Ox.GetPlayer(source)
        if not OxPlayer then return end
        local license = OxPlayer.getLicense(Config.vehicleShops[_shopIndex].license)
        if not license then
            return 'license'
        end
    end

    if not useBank then
        local money = _inv:GetItem(source, 'money', nil, true)
        if money < vehiclePrice then
            return false
        end

        return _inv:RemoveItem(source, 'money', vehiclePrice)
    end

    local bankMoney = Config.usePEFCL and exports.pefcl:getDefaultAccountBalance(source).data or getBankMoney(source)
    if bankMoney < vehiclePrice then
        return false
    end

    if Config.usePEFCL then
        local result = exports.pefcl:removeBankBalance(source,
            {
                amount = vehiclePrice,
                message = ('Zakoupení vozidla %s'):format(Config.vehicleList
                    [Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_secondary].label)
            })
        return result.status == 'ok' or false
    else
        removeBankMoney(source, vehiclePrice)
        return true
    end
end)

lib.callback.register('lsrp_vehicleShop:server:generateplate', function(source)
    return Ox.GeneratePlate()
end)

lib.callback.register('lsrp_vehicleShop:server:addVehicle',
    function(source, vehProperties, vehicleSpot, _shopIndex, _selected, _secondary)
        local OxPlayer = Ox.GetPlayer(source)
        if not OxPlayer then return false end

        local data = Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_secondary]

        if vehProperties.model ~= data.vehicleModel then
            return false
        end

        local model = nil
        for vehModel, _ in pairs(Ox.GetVehicleData()) do
            if joaat(vehModel) == data.vehicleModel then
                model = vehModel
                break
            end
        end
        if not model then return false end

        local vehicle = Ox.CreateVehicle({
            model = model,
            owner = OxPlayer.charid,
            properties = vehProperties,
            stored = vehicleSpot > 0 and 'stored' or nil
        }, Config.vehicleShops[_shopIndex].vehicleSpawnCoords.xyz, Config.vehicleShops[_shopIndex].vehicleSpawnCoords.w)

        if not vehicle then return false end
        local success = true

        log({
            ['Vehicle model'] = data.label,
            ['Price'] = data.vehiclePrice,
            ['Plate'] = vehicle.plate,
            ['Buyer'] = GetPlayerName(source),
            ['Player charid'] = OxPlayer.charid
        })
        return success, vehicle.plate, vehicleSpot > 0, vehicle.netid
    end)

MySQL.ready(initializedThread)
