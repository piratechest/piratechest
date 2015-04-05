{_, $, Backbone, Marionette, nw } = require( '../common.coffee' )
 
parseTorrent = require( 'parse-torrent' )

{ Magnet } = require './Magnet.coffee'
Logger = require './Logger.coffee'
log = new Logger( verbose: true )

class module.exports.MagnetCollection extends Backbone.Collection

    model: Magnet
    initialize: (models, {@torrentClient, @store} = {}) ->
        @listenTo @, 'add', @_handleAdd

    _handleAdd: (model, collection, options) ->
        log.info "_handleAdd", model.toJSON()
        #collection._getTorrentData(model)

    sync: (method, model, options) ->
        @store.sync( method, model, options ) if @store

    _getTorrentData: (model) =>
        return unless @torrentClient
        return if model.get('dn')

        torrent = @torrentClient.get( model.get('infoHash') )
        if !torrent
            torrent = @torrentClient.add( model.getUri(), @_recieveTorrentData(model) )
        else
            @_recieveTorrentData( model )(torrent)

    _recieveTorrentData: (model) ->
        (torrent) ->
            model.updateMetadata(torrent) unless model.get( 'dn' )
            torrent.destroy()
        
    add: (model) =>
        log.info "Adding to MagnetCollection", model
        hash = model.get?( 'infoHash')
        return false unless hash
        try
            parsedTorrent = (hash && hash.parsedTorrent) || parseTorrent(hash)
        catch err
            log.error( "Invalid torrent cannot add. " )
            log.info 'couldnt add:', model.get( 'infoHash' )
            return false

        isDupe = @any (m) -> m.get('infoHash') is hash
        log.info( "Added magnet id a DUPE? #{ isDupe }" )
        return false if isDupe

        @_getTorrentData( model )

        # Up to you either return false or throw an exception or silently ignore
        # NOTE: DEFAULT functionality of adding duplicate to collection is to IGNORE and RETURN. Returning false here is unexpected. ALSO, this doesn't support the merge: true flag.
        # Return result of prototype.add to ensure default functionality of .add is maintained. 
        return Backbone.Collection.prototype.add.call( this, model ) 
