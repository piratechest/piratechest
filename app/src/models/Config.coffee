
fs = require 'fs'
path = require 'path'
_ = require 'underscore'

defaultConfig =
    __DELETE_THIS_FILE_TO_RESET_CONFIG_TO_DEFAULT: 'handy'
    defaultView: "collection"
    flags:
        clearLocalStorageOnStartup: false
        clearDatastoreOnStartup: false
        showInspectorOnStartup: false # crashes with multiple instances
        loadFromDatastore: true
        getPeersFromSeed: true
        connectLodestoneOnStartup: true
        runTracker: true
    customSeeds: [
        { id: 'example', transport: { host: 'localhost', port: 9001 } }
    ]

localPath = path.join( __dirname, '../../config.json' )
hasLocalConfig = fs.existsSync( localPath )

if hasLocalConfig
    console.log "Loading local config."
    localConfig = require( localPath )
    mergedConfig = localConfig or {}
    for own key, value of defaultConfig
        mergedConfig[key] = _.extend( value, localConfig[key] or {} ) if typeof value is 'object'


mergedConfig ?= defaultConfig

fs.writeFileSync( localPath, JSON.stringify( mergedConfig, null, '\t' ) )

module.exports = mergedConfig