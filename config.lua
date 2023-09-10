Config = {}
--[[ Main section ]]
Config.menuPosition = 'right'
Config.textDistance = 1.0
Config.notifDuration = 10000
Config.usePEFCL = false               -- if false it will use ox/esx default money logic
Config.LoadVehicleShopInterior = true -- Load default vehicle shop interior if not using ipl loader
Config.oxTarget = true
Config.logging = false                -- 'oxlogger' or 'YOUR_DISCORD_WEBHOOK' or false
Config.vehicleColors = {              -- Allow custom RGB Colors for primary and secondary? Currently without any money take
    primary = true,
    secondary = true
}



---@class VehicleShopsConfig
---@field shopLabel string This is label of the shop
---@field shopIcon? string Default 'car'
---@field shopCoords vector3 Shop point coords (also for blip)
---@field previewCoords vector4 Where will the vehicle spawn?
---@field vehicleSpawnCoords vector4 When you buy the vehicle, where should it spawn?
---@field vehicleList string String 'car, boats, airplane' to be compatible with your garages
---@field blipData? {color: number, sprite: number, scale: number} Example: {color = 5, sprite = 755, scale = 0.8},
---@field npcData? {model: number, position: vector4} Example: {model = joaat('A_M_M_HasJew_01'), position = vec4(-331.8239, -2792.7698, 4.0002, 90.6536)},
---@field showcaseVehicle? {vehicleModel: number, coords: vector4, color: {[1]:number, [2]: number, [3]:number}}
---@field license? string|false String 'dmv', 'boat' whatever you have for your license system (look in db)

--[[ Vehicle shops configuration ]]
---@type VehicleShopsConfig[]
Config.vehicleShops = {
    {
        shopLabel = 'Deluxe Motorsport',
        shopIcon = 'fa-solid fa-car',
        shopCoords = vec3(-32.7748, -1095.4304, 27.2744),
        previewCoords = vec4(-47.6072, -1092.1250, 26.7543, 90.0),
        vehicleSpawnCoords = vec4(-23.6204, -1094.3016, 27.0452, 339.1980),
        vehicleList = 'vehicles',
        blipData = { color = 5, sprite = 810, scale = 0.8 },
        npcData = { model = joaat('IG_Avon'), position = vec4(-30.7224, -1096.5004, 26.2744, 68.4467) },
        showcaseVehicle = {
            {
                vehicleModel = joaat('kanjo'),
                coords = vec4(-49.8157, -1083.6610, 26.23, 199.9693),
                color = { 255, 128, 32 }
            },
            {
                vehicleModel = joaat('tenf2'),
                coords = vec4(-54.7802, -1096.9150, 26.1577, 297.9555),
                color = { 255, 0, 32 }
            },
            {
                vehicleModel = joaat('rhinehart'),
                coords = vec4(-42.3705, -1101.3069, 26.5423, 350.3064),
                color = { 255, 0, 32 }
            },
            {
                vehicleModel = joaat('ztype'),
                coords = vec4(-36.6870, -1093.3662, 26.2255, 153.1380),
                color = { 255, 0, 32 }
            },
        }
    },
    {
        shopLabel = 'Port of LS',
        shopIcon = 'fa-solid fa-anchor',
        shopCoords = vec3(-332.4889, -2792.6875, 5.0002),
        previewCoords = vec4(-315.2095, -2811.3174, -1.4862, 236.3378),
        vehicleSpawnCoords = vec4(-295.9564, -2763.7126, -1.0662, 73.7579),
        vehicleList = 'boats',
        blipData = { color = 5, sprite = 755, scale = 0.8 },
        npcData = { model = joaat('A_M_M_HasJew_01'), position = vec4(-331.8239, -2792.7698, 4.0002, 90.6536) },
        license = 'flight'
    },
    {
        shopLabel = 'Elitás Travel',
        shopIcon = 'fa-solid fa-plane-departure',
        shopCoords = vec3(1746.7318, 3296.3875, 41.1424),
        previewCoords = vec4(1728.4298, 3313.7102, 41.2235, 195.8193),
        vehicleSpawnCoords = vec4(1770.8486, 3238.9597, 42.1628, 32.3031),
        vehicleList = 'planes',
        blipData = { color = 5, sprite = 755, scale = 0.8 },
        npcData = { model = joaat('A_M_M_HasJew_01'), position = vec4(1746.7318, 3296.3875, 40.1424, 166.0) },
        license = 'flight'
    },
}

Config.vehicleList = {
    ['vehicles'] = {
        {
            label = 'compacts',
            defaultIndex = 2,
            dbData = 'car',
            values = {
                { label = 'Brioso',  vehicleModel = joaat('brioso'),  vehiclePrice = 3400 },
                { label = 'BriosoB', vehicleModel = joaat('brioso2'), vehiclePrice = 3100 },
                { label = 'Club',    vehicleModel = joaat('club'),    vehiclePrice = 2800 },
                { label = 'Issi',    vehicleModel = joaat('issi2'),   vehiclePrice = 2900 },
                { label = 'IssiB',   vehicleModel = joaat('issi4'),   vehiclePrice = 3600 },
                { label = 'IssiC',   vehicleModel = joaat('issi5'),   vehiclePrice = 4200 },
            }
        },
        {
            label = 'coupes',
            defaultIndex = 2,
            dbData = 'car',
            values = {
                { label = 'Felon',    vehicleModel = joaat('felon'),    vehiclePrice = 60000 },
                { label = 'FelonB',   vehicleModel = joaat('felon2'),   vehiclePrice = 65000 },
                { label = 'Oracle',   vehicleModel = joaat('oracle2'),  vehiclePrice = 70000 },
                { label = 'Windsor',  vehicleModel = joaat('windsor'),  vehiclePrice = 100000 },
                { label = 'WindsorB', vehicleModel = joaat('windsor2'), vehiclePrice = 100000 },
                { label = 'Zion',     vehicleModel = joaat('zion2'),    vehiclePrice = 85000 },
                { label = 'Ocelot',   vehicleModel = joaat('f620'),     vehiclePrice = 72000 },
            }
        },
        {
            label = 'muscles',
            defaultIndex = 2,
            dbData = 'car',
            values = {
                { label = 'Buccaneer', vehicleModel = joaat('buccaneer'), vehiclePrice = 1200 },
                { label = 'Phoenix',   vehicleModel = joaat('phoenix'),   vehiclePrice = 1400 },
                { label = 'Faction',   vehicleModel = joaat('faction'),   vehiclePrice = 1600 },
                { label = 'Gauntlet',  vehicleModel = joaat('gauntlet'),  vehiclePrice = 1800 },
                { label = 'Moonbeam',  vehicleModel = joaat('moonbeam'),  vehiclePrice = 2000 },
                { label = 'Sabre',     vehicleModel = joaat('sabregt'),   vehiclePrice = 2200 },
                { label = 'Dominator', vehicleModel = joaat('dominator'), vehiclePrice = 2400 },
                { label = 'Tampa',     vehicleModel = joaat('tampa'),     vehiclePrice = 2600 },
                { label = 'Virgo',     vehicleModel = joaat('virgo'),     vehiclePrice = 1000 },
                { label = 'Voodoo',    vehicleModel = joaat('voodoo'),    vehiclePrice = 1000 },
                { label = 'VoodooB',   vehicleModel = joaat('voodoo2'),   vehiclePrice = 1000 },
                { label = 'Vamos',     vehicleModel = joaat('vamos'),     vehiclePrice = 1000 },
                { label = 'Hermes',    vehicleModel = joaat('hermes'),    vehiclePrice = 1000 },
                { label = 'Tahoma',    vehicleModel = joaat('tahoma'),    vehiclePrice = 1000 },
            }
        },
        {
            label = 'offroads',
            defaultIndex = 2,
            dbData = 'car',
            values = {
                {
                    label = 'Bfinjection',
                    vehicleModel = joaat('bfinjection'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Bifta',
                    vehicleModel = joaat('bifta'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Bodhi',
                    vehicleModel = joaat('bodhi2'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Caracara',
                    vehicleModel = joaat('caracara2'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Dubsta 6x6',
                    vehicleModel = joaat('dubsta3'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Everon',
                    vehicleModel = joaat('everon'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Hellion',
                    vehicleModel = joaat('hellion'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Kamacho',
                    vehicleModel = joaat('kamacho'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Rebel',
                    vehicleModel = joaat('Rebel'),
                    vehiclePrice = 1000
                },
                {
                    label = 'RancherXL',
                    vehicleModel = joaat('rancherxl'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Sandking',
                    vehicleModel = joaat('sandking'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Trophytruck',
                    vehicleModel = joaat('trophytruck'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Vagrant',
                    vehicleModel = joaat('vagrant'),
                    vehiclePrice = 1000
                },
            }
        },
        {
            label = 'suvs',
            defaultIndex = 2,
            dbData = 'car',
            values = {
                {
                    label = 'Baller',
                    vehicleModel = joaat('baller'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Cavalcade',
                    vehicleModel = joaat('cavalcade'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Contender',
                    vehicleModel = joaat('contender'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Dubsta',
                    vehicleModel = joaat('dubsta'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Granger',
                    vehicleModel = joaat('granger'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Gresley',
                    vehicleModel = joaat('gresley'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Huntley',
                    vehicleModel = joaat('huntley'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Landstalker',
                    vehicleModel = joaat('landstalker'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Novak',
                    vehicleModel = joaat('novak'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Mesa',
                    vehicleModel = joaat('mesa'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Patriot',
                    vehicleModel = joaat('patriot'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Rebla',
                    vehicleModel = joaat('rebla'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Rocoto',
                    vehicleModel = joaat('rocoto'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Seminole',
                    vehicleModel = joaat('seminole'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Serrano',
                    vehicleModel = joaat('serrano'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Toros',
                    vehicleModel = joaat('toros'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Benefactor XLS',
                    vehicleModel = joaat('xls'),
                    vehiclePrice = 1000
                },
            }
        },
        {
            label = 'sedans',
            defaultIndex = 2,
            dbData = 'car',
            values = {
                {
                    label = 'Emperor',
                    vehicleModel = joaat('emperor'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Emperor',
                    vehicleModel = joaat('emperor2'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Asea',
                    vehicleModel = joaat('asea'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Asterope',
                    vehicleModel = joaat('asterope'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Cognoscenti',
                    vehicleModel = joaat('cognoscenti'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Glendale',
                    vehicleModel = joaat('glendale'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Intruder',
                    vehicleModel = joaat('intruder'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Premier',
                    vehicleModel = joaat('premier'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Primo',
                    vehicleModel = joaat('primo'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Regina',
                    vehicleModel = joaat('regina'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Stanier',
                    vehicleModel = joaat('stanier'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Stratum',
                    vehicleModel = joaat('stratum'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Tailgater',
                    vehicleModel = joaat('tailgater'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Warrener',
                    vehicleModel = joaat('warrener'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Washington',
                    vehicleModel = joaat('washington'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Surge',
                    vehicleModel = joaat('surge'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Super Diamond',
                    vehicleModel = joaat('superd'),
                    vehiclePrice = 1000
                },
            }
        },
        {
            label = 'sports',
            defaultIndex = 2,
            dbData = 'car',
            values = {
                {
                    label = 'Alpha',
                    vehicleModel = joaat('alpha'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Banshee',
                    vehicleModel = joaat('banshee'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Bestia GTS',
                    vehicleModel = joaat('bestiagts'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Buffalo',
                    vehicleModel = joaat('buffalo'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Carbonizzare',
                    vehicleModel = joaat('carbonizzare'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Coquette',
                    vehicleModel = joaat('coquette'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Drafter',
                    vehicleModel = joaat('drafter'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Deveste',
                    vehicleModel = joaat('deveste'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Elegy',
                    vehicleModel = joaat('elegy'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Flash GT',
                    vehicleModel = joaat('flashgt'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Fusilade',
                    vehicleModel = joaat('fusilade'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Furore GT',
                    vehicleModel = joaat('furoregt'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Karin Futo',
                    vehicleModel = joaat('futo'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Komoda',
                    vehicleModel = joaat('komoda'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Imorgon',
                    vehicleModel = joaat('imorgon'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Jugular',
                    vehicleModel = joaat('jugular'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Jester',
                    vehicleModel = joaat('jester'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Kuruma',
                    vehicleModel = joaat('kuruma'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Lynx',
                    vehicleModel = joaat('lynx'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Neon',
                    vehicleModel = joaat('neon'),
                    vehiclePrice = 1000
                },
                {
                    label = 'NineF',
                    vehicleModel = joaat('ninef'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Omnis',
                    vehicleModel = joaat('omnis'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Schwarzer',
                    vehicleModel = joaat('schwarzer'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Specter',
                    vehicleModel = joaat('specter'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Italirsx',
                    vehicleModel = joaat('italirsx'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Zr350',
                    vehicleModel = joaat('zr350'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Calico',
                    vehicleModel = joaat('calico'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Euros',
                    vehicleModel = joaat('euros'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Growler',
                    vehicleModel = joaat('growler'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Cypher',
                    vehicleModel = joaat('cypher'),
                    vehiclePrice = 1000
                },
                {
                    label = 'RT3000',
                    vehicleModel = joaat('rt3000'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Vectre',
                    vehicleModel = joaat('vectre'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Sultan',
                    vehicleModel = joaat('sultan'),
                    vehiclePrice = 1000
                },
            }
        },
        {
            label = 'classics',
            defaultIndex = 2,
            dbData = 'car',
            values = {
                { label = 'Ardent',   vehicleModel = joaat('ardent'),   vehiclePrice = 1000 },
                { label = 'Casco',    vehicleModel = joaat('casco'),    vehiclePrice = 1000 },
                { label = 'Michelli', vehicleModel = joaat('michelli'), vehiclePrice = 1000 },
                { label = 'Nebula',   vehicleModel = joaat('nebula'),   vehiclePrice = 1000 },
                { label = 'Manana',   vehicleModel = joaat('manana'),   vehiclePrice = 1000 },
                { label = 'Mamba',    vehicleModel = joaat('mamba'),    vehiclePrice = 1000 },
                { label = 'Retinue',  vehicleModel = joaat('retinue'),  vehiclePrice = 1000 },
                { label = 'Stinger',  vehicleModel = joaat('stinger'),  vehiclePrice = 1000 },
                { label = 'Tornado',  vehicleModel = joaat('tornado'),  vehiclePrice = 1000 },
                { label = 'Torero',   vehicleModel = joaat('torero'),   vehiclePrice = 1000 },
                { label = 'Viseris',  vehicleModel = joaat('viseris'),  vehiclePrice = 1000 },
            }
        },
        {
            label = 'supers',
            defaultIndex = 2,
            dbData = 'car',
            values = {
                {
                    label = 'Addert',
                    vehicleModel = joaat('adder'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Cheetah',
                    vehicleModel = joaat('cheetah'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Emerus',
                    vehicleModel = joaat('emerus'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Krieger',
                    vehicleModel = joaat('krieger'),
                    vehiclePrice = 1000
                },
                {
                    label = 'ItaliGTB',
                    vehicleModel = joaat('italigtb'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Infernus',
                    vehicleModel = joaat('infernus'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Penetrator',
                    vehicleModel = joaat('penetrator'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Sheava',
                    vehicleModel = joaat('sheava'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Turismor',
                    vehicleModel = joaat('turismor'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Visione',
                    vehicleModel = joaat('visione'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Vacca',
                    vehicleModel = joaat('vacca'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Tyrus',
                    vehicleModel = joaat('tyrus'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Tempesta',
                    vehicleModel = joaat('tempesta'),
                    vehiclePrice = 1000
                },
                {
                    label = 'Reaper',
                    vehicleModel = joaat('reaper'),
                    vehiclePrice = 1000
                },
            }
        },
        {
            label = 'vans',
            defaultIndex = 2,
            dbData = 'car',
            values = {
                { label = 'Burrito',  vehicleModel = joaat('burrito'),  vehiclePrice = 1000 },
                { label = 'GBurrito', vehicleModel = joaat('gburrito'), vehiclePrice = 1000 },
                { label = 'Journey',  vehicleModel = joaat('journey'),  vehiclePrice = 1000 },
                { label = 'Pony',     vehicleModel = joaat('pony'),     vehiclePrice = 1000 },
                { label = 'Minivan',  vehicleModel = joaat('minivan'),  vehiclePrice = 1000 },
                { label = 'Rumpo',    vehicleModel = joaat('rumpo'),    vehiclePrice = 1000 },
                { label = 'Speedo',   vehicleModel = joaat('speedo'),   vehiclePrice = 1000 },
                { label = 'Surfer',   vehicleModel = joaat('surfer'),   vehiclePrice = 1000 },
            }
        },

    },
    ['boats'] = {
        {
            label = 'Skůtry',
            defaultIndex = 2,
            dbData = 'boat',
            values = {
                { label = 'Seashark', vehicleModel = joaat('seashark'),  vehiclePrice = 1000 },
                { label = 'Seashark', vehicleModel = joaat('seashark2'), vehiclePrice = 1000 },
                { label = 'Seashark', vehicleModel = joaat('seashark3'), vehiclePrice = 1000 },
            }
        },
        {
            label = 'Čluny',
            defaultIndex = 2,
            dbData = 'boat',
            values = {
                { label = 'Dinghy',  vehicleModel = joaat('dinghy'),  vehiclePrice = 1000 },
                { label = 'DinghyB', vehicleModel = joaat('dinghy2'), vehiclePrice = 1000 },
                { label = 'DinghyC', vehicleModel = joaat('dinghy3'), vehiclePrice = 1000 },
                { label = 'DinghyD', vehicleModel = joaat('dinghy4'), vehiclePrice = 1000 },
            }
        },
        {
            label = 'Výletní čluny',
            defaultIndex = 2,
            dbData = 'boat',
            values = {
                { label = 'Jetmax',   vehicleModel = joaat('jetmax'),   vehiclePrice = 1000 },
                { label = 'Speeder',  vehicleModel = joaat('speeder'),  vehiclePrice = 1000 },
                { label = 'SpeederB', vehicleModel = joaat('speeder2'), vehiclePrice = 1000 },
                { label = 'Squalo',   vehicleModel = joaat('squalo'),   vehiclePrice = 1000 },
                { label = 'Suntrap',  vehicleModel = joaat('suntrap'),  vehiclePrice = 1000 },
                { label = 'Toro',     vehicleModel = joaat('toro'),     vehiclePrice = 1000 },
                { label = 'ToroB',    vehicleModel = joaat('toro2'),    vehiclePrice = 1000 },
                { label = 'Tropic',   vehicleModel = joaat('tropic'),   vehiclePrice = 1000 },
                { label = 'TropicB',  vehicleModel = joaat('tropic2'),  vehiclePrice = 1000 },
                { label = 'Longfin',  vehicleModel = joaat('longfin'),  vehiclePrice = 1000 },
            }
        },
    },
    ['planes'] = {
        {
            label = 'Helikoptéry',
            defaultIndex = 2,
            dbData = 'plane',
            values = {
                { label = 'havok',  vehicleModel = joaat('havok'),  vehiclePrice = 1000 },
                { label = 'nokota', vehicleModel = joaat('nokota'), vehiclePrice = 1000 },
            }
        },
    },

}
