{_, $, Backbone, Marionette, nw } = require( '../common.coffee' )

http = require 'http'
url = require 'url'

class module.exports.Raid extends Backbone.Model
    initialize: ({url} = {}) ->
        @set( 'url', url or 'http://example.com' )
        @set( 'peers', 0 )
        @set( 'loot', [] )
        @_createServer()
        @_launchBrowser()

    close: ->
        @server.close()

    _createServer: =>
        @server = http.createServer( @_handleRaidUpdates )
        @server.listen(1337, '127.0.0.1')
        console.log('Raid Server running at http://127.0.0.1:1337/')

    _launchBrowser: =>
        @win = nw.Window.open 'http://en.wikipedia.org/wiki/Magnet_URI_scheme',
            position: 'center'
            width: 800
            height: 600
            focus: true
            'inject-js-end': './raid.js'
            'new-instance': true
        @_attachWindowListeners()

    _attachWindowListeners: =>
        @win.on 'loaded', -> console.log "Window Loaded"
        @win.on 'close', -> console.log "Window Closed"

    _handleRaidUpdates: (req, res) =>
        host = req.headers.host
        console.log( "Recieved Raid Update from: ", host, @ )

        console.log "sending headers"
        res.setHeader('Access-Control-Allow-Origin', '*')
        res.setHeader('Access-Control-Allow-Methods', 'GET')
        res.setHeader('Access-Control-Allow-Headers', 'Content-Type')

        console.log "Headers sent."
        
        url_parts = url.parse( req.url, true )
        query = url_parts.query

        console.log "Handling raid loot update."
        loot = @get( 'loot' )
        console.log( "loot", loot, @ )
        loot.push
            uri: query.uri
            host: host
        @set( 'loot', loot )
        @trigger( 'new:loot', loot )
        
        res.writeHead( 200, {'Content-Type': 'text/plain'} )
        res.end('Arg!!!!')