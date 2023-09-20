
fx_version "cerulean"
author 'Blake'
description 'Atm Robbery'
game "gta5"
lua54 "yes"


data_file "DLC_ITYP_REQUEST" "stream/loq_atm.ytyp"


dependencies {

    'PolyZone',
    'qb-target',
    
}
    
shared_scripts {
    
    'shared/*.lua',
    
}
    
client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/*.lua',
}
    
server_scripts {
    'server/*.lua',
    '@oxmysql/lib/MySQL.lua',
    'sv_escrowed.lua',
}
    
escrow_ignore {
        'client/*.lua',
        'server/*.lua',
        'shared/*.lua',
        '*.*'
}
    

dependency '/assetpacks'