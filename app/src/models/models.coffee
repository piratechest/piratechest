{_, $, Backbone, Marionette } = require( '../common.coffee' )
 
hashcash = window.hc = require( 'hashcashgen')
magnetUri = require( 'magnet-uri' )
parseTorrent = require( 'parse-torrent' )



class Magnet extends Backbone.Model 
    initialize: ({@infoHash, favorite, title, tags}) ->
        @set 'favorite', if favorite then true else false
        @set 'status', false
        @set 'title', undefined
        @set 'peers', 0
        @set 'uri', @getUri()

    getUri: => magnetUri.encode
        infoHash: @get('infoHash')

    updateMetadata: (torrent) =>
        @torrent = torrent
        @set( 'title', torrent.name )
        @set( 'peers', torrent.swarm.numPeers )
        @set( 'status', true )
        # FIXME: Destroying this torrent as soon as we have metadata
        # this may not be the best way to prevent downloading
        # when all we want is the metadata (by default at least)
        @torrent.destroy()

class MagnetCollection extends Backbone.Collection
    initialize: (models, {torrentClient}) ->
        @torrentClient = torrentClient

    add: (model) =>
        hash = model.get?( 'infoHash')
        return false unless hash
        isDupe = @any (m) -> m.get('infoHash') is hash
        try
            parsedTorrent = (hash && hash.parsedTorrent) || parseTorrent(hash)
        catch err
            console.error( "Invalid torrent cannot add. " )
            console.log 'couldnt add:', model.get( 'hash' )
            return false
        
        torrent = @torrentClient.add( model.getUri(), model.updateMetadata )

        # Up to you either return false or throw an exception or silently ignore
        # NOTE: DEFAULT functionality of adding duplicate to collection is to IGNORE and RETURN. Returning false here is unexpected. ALSO, this doesn't support the merge: true flag.
        # Return result of prototype.add to ensure default functionality of .add is maintained. 
        return if isDupe then false else Backbone.Collection.prototype.add.call( this, model ) 

module.exports = { Magnet, MagnetCollection }