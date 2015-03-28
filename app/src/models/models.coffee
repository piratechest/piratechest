{_, $, Backbone, Marionette } = require( '../common.coffee' )
 
hashcash = window.hc = require( 'hashcashgen')
magnetUri = require( 'magnet-uri' )


class Magnet extends Backbone.Model	
	initialize: ({@infoHash, favorite, title, tags}) ->
		@set 'favorite', if favorite then true else false
		@set 'status', false
		@set 'title', undefined
		@set 'peers', 0
		@set 'uri', @getUri()

	getUri: => magnetUri.encode
		infoHash: @get('infoHash')

	updateMetaData: (torrent) =>
		@torrent = torrent
		@set( 'title', torrent.name )
		@set( 'peers', torrent.swarm.numPeers )
		@set( 'status', true )
		# FIXME: Destroying this torrent as soon as we have metadata
		# this may not be the best way to prevent downloading
		# when all we want is the metadata (by default at least)
		@torrent.destroy()

class MagnetCollection extends Backbone.Collection
	initialize: (models, {@torrentClient, @gm}) ->
		@listenTo @gm, 'update', @handleGossipUpdate
		@listenTo this, 'add', @handleCollectionAdd

	handleCollectionAdd: (model, collection, options) ->
		@torrentClient.add( model.getUri(), model.updateMetaData )
		hash = model.get('infoHash')
		@gm.update( hash, hashcash( hash, 4 ) )

	handleGossipUpdate: (peerId, key, value) =>
		if hashcash.check( key, value )
			magnet = new Magnet
				infoHash: key
				favorite: false
			@add( magnet ) unless @where( infoHash: key ).length > 0
		else
			console.log "Gossip hash with invalid hashcash stamp.", key, value

module.exports = { Magnet, MagnetCollection }