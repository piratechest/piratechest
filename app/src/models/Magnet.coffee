{_, $, Backbone, Marionette, nw } = require( '../common.coffee' )
 
hashcash = window.hc = require( 'hashcashgen')
magnetUri = require( 'magnet-uri' )
parseTorrent = require( 'parse-torrent' )

Logger = require './Logger.coffee'
log = new Logger( verbose: true )

class module.exports.Magnet extends Backbone.Model

    initialize: ({infoHash, favorite, dn, tr, tags}) ->
        log.info "Creating Magnet:", arguments
        @set 'infoHash', infoHash
        @set 'favorite', if favorite then true else undefined
        @set 'status', undefined
        @set 'dn', dn or undefined
        @set 'tr', tr or []
        @set 'peers', 0
        @set 'tags', []
        log.info "Created Magnet: ", @toJSON()
        @listenTo @, 'change', -> @save()

    getUri: ->
        trackers = @get( 'tr' ) or []
        base = "magnet:?"
        base += "xt=urn:btih:#{ @get( 'infoHash' ) }"
        if @get( 'dn' )
            base += "&dn=#{ window.encodeURIComponent( @get( 'dn' ) ) }"
        if trackers
            for i, val in trackers
                base += "&tr=#{ window.encodeURIComponent( val ) }"
        base

    sync: (method, model, options) ->
        @collection?.store.sync( method, model, options ) if @collection?.store

    getTags: ->
        name = @get( 'dn' )
        tags = @get( 'tags' )
        tags.concat( name?.split?( /\W+/ ) or [] )

    updateMetadata: (torrent) =>
        @torrent ?= torrent
        log.info "Updating Magnet from torrent metadata:", torrent
        @set( 'dn', torrent.dn or torrent.name or @get( 'dn' ) or undefined )
        @set( 'peers', torrent?.swarm?.numPeers or 0 )
        @set( 'tr', torrent.tr )
        @set( 'status', true )
        log.info('updated magnet', @, torrent)
        # FIXME: Destroying this torrent as soon as we have metadata
        # this may not be the best way to prevent downloading
        # when all we want is the metadata (by default at least)
        # @torrent.swarm?.pause?()
        # torrent.swarm?.pause?()

    @fromTorrent: (torrent) ->
        log.info "Magnet from torrent: ", torrent
        new Magnet
            infoHash: torrent.infoHash
            dn: torrent.dn or torrent.name or undefined
            tr: torrent.tr

    @fromUri: (uri) =>
        log.info "Magnet from uri: ", uri
        torrent = null
        try
            torrent = parseTorrent( uri )
        catch err
            log.error "Unable to parse magnet uri: ", uri
            return undefined
        @fromTorrent( torrent )