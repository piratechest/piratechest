fs = require 'fs'
WebTorrent = require 'webtorrent'


{_, $, Backbone, Marionette, nw, win, localStorage } = require './common.coffee'
{ AppView } = require './views/AppView.coffee'
{ LoadingView } = require './views/LoadingView.coffee'
{ IntroView } = require './views/IntroView.coffee'
{ ContentsView } = require './views/ContentsView.coffee'

{ MagnetCollection, Magnet } = require './models/models.coffee'

nativeMenuBar = new nw.Menu( type: "menubar" )
nativeMenuBar.createMacBuiltin("Pirate Chest") if process.platform is 'darwin'
win.menu = nativeMenuBar;

Config = require( '../config.json')
console.log 'CONFIG: ', Config

client = new WebTorrent()
client.on 'error', (error) ->
    console.error "Webtorrent Error:", error

magnetCollection = new MagnetCollection( null, torrentClient: client)

# Use The Map, to find bootstrap/seed peers.
client.seed "#{ __dirname }/../images/map.svg", { name: 'PiratechestSeedMap.svg', comment: 'This map is designed to be seeded as a torrent by the piratechest application in order to bootstrap peer discovery.' }, (torrent) ->
    console.log "Seeding the map. Stored at: window.seedMap"
    window.seedMap = torrent


$ ->
    appRegion = new Marionette.Region( el: $('body').get(0) )
    appRegion.show( new LoadingView() )
    # TODO: Actually load stuff not just setTimeout
    appView = new AppView( config: Config, collection: magnetCollection, torrentClient: client )
    setTimeout ( ->
        appRegion.show( appView )
        introView = new IntroView()
        appView.showOverlay( introView ) unless localStorage.introShown
        introView.on 'open', ->
            appView.showOverlay( new ContentsView() )
            
    ), 1000
    win.show()

    # test magnet TODO: Remove this.
    setTimeout ( -> 
        magnetCollection.add new Magnet
            infoHash: '546cf15f724d19c4319cc17b179d7e035f89c1f4'
            favorite: false
    ), 3000


