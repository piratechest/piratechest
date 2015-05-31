fs = require 'fs'
path = require 'path'
WebTorrent = require 'webtorrent'
web3 = require 'web3'

{_, $, Backbone, Marionette, nw, win, localStorage } = require './common.coffee'
Logger = require './models/Logger.coffee'
log = new Logger( verbose: true )

nw.App.setCrashDumpDir("logs")

CONFIG = require( './models/Config.coffee')
Store = require './models/PersistantModel.coffee'

{ Magnet } = require './models/Magnet.coffee'
{ MagnetCollection } = require './models/MagnetCollection.coffee'

{ AppView } = require './views/AppView.coffee'
{ LoadingView } = require './views/LoadingView.coffee'
{ IntroView } = require './views/IntroView.coffee'
{ ContentsView } = require './views/ContentsView.coffee'


window.app = app = {}


nativeMenuBar = new nw.Menu( type: "menubar" )
nativeMenuBar.createMacBuiltin("Pirate Chest") if process.platform is 'darwin'
win.menu = nativeMenuBar;

log.info 'CONFIG: ', CONFIG

if CONFIG?.flags?.clearDatastoreOnStartup
    datastorePath = path.join( __dirname, '../data/magnets.db' )
    log.info "Removing Datastore on startup: #{ fs.exists( datastorePath ) }"
    fs.unlinkSync( datastorePath ) if fs.exists( datastorePath )

if CONFIG?.flags?.clearLocalStorageOnStartup
    localStorage.clear()

if CONFIG?.flags?.showInspectorOnStartup
    win.showDevTools()

app.client = client = new WebTorrent
    tracker: CONFIG?.flags?.runTracker


client.on 'error', (error) ->
    log.error "WEBTORRENT ERR: #{ error.msg or error.toString?() or JOSN.stringify( error ) }"

client.on 'torrent', (torrent) ->
    log.info "WEBTORRENT: #{ torrent.name or torrent.infoHash }"


window.app.magnetCollection = magnetCollection =  new MagnetCollection [],
    torrentClient: client
    store: new Store('magnets')


if CONFIG?.flags?.loadFromDatastore
    magnetCollection.fetch()

if CONFIG?.flags?.connectLodestoneOnStartup
    window.web3 = web3
    httpProvider = new web3.providers.HttpProvider( "http://localhost:8545" )
    window.web3.setProvider( httpProvider )

if CONFIG?.flags?.getPeersFromSeed
    # Use The Map, to find bootstrap/seed peers.
    client.seed "#{ __dirname }/../images/map.svg", { name: 'PiratechestSeedMap.svg', comment: 'This map is designed to be seeded as a torrent by the piratechest application in order to bootstrap peer discovery.' }, (torrent) ->
        log.info "Seeding the map. Stored at: window.seedMap"
        app.seedMap = torrent
        magnet = Magnet.fromTorrent( torrent )
        app.seeds = torrent.swarm._peers

        torrent.swarm.resume()

$ ->
    appRegion = new Marionette.Region( el: $('body').get(0) )
    appRegion.show( new LoadingView() )
    # TODO: Actually load stuff not just setTimeout
    appView = new AppView
        config: CONFIG
        collection: magnetCollection
        torrentClient: client
        #lodestone: lodestone

    setTimeout ( ->
        appRegion.show( appView )
        introView = new IntroView()
        appView.showOverlay( introView ) unless localStorage.introShown
        introView.on 'open', ->
            appView.showOverlay( new ContentsView() )
            
    ), 1000
    win.show()

process.on 'uncaughtException', (err) ->
    window.alert('uncaughtException')
    window.console.error(err, err.stack)
