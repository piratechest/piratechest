{_, $, Backbone, Marionette, localStorage } = require( '../common.coffee' )

Lodestone = require( '../lib/lodestone')

{ MagnetCollectionView  } = require './MagnetCollectionView.coffee'
{ Magnet, MagnetCollection } = require '../models/models.coffee'
{ LodestoneIntroView } = require './LodestoneIntroView.coffee'

class module.exports.LodestoneView extends Marionette.LayoutView
	className: 'lodestone-view'
	template: _.template """
		<div class="content">
			<div class="about">
				<form action=""><input type="text"></form>
			</div>
			<div class="output"></div>
		</div>
	"""
	events:
		'submit form': '_handleSearch'
	ui:
		input: 'input'

	noop: (ev) ->
		ev.preventDefault()
		false

	regions:
		output: '.output'

	initialize: ({@torrentClient}) ->
		console.log "INIT LodestoneView", @torrentClient
		@lodestone = window.lodestone = new Lodestone()
		@listenTo @lodestone, 'peer', @_handleAddPeer
		@listenTo @lodestone, 'data', @_handleData

	onShow: ->
		@trigger( 'show:overlay', new LodestoneIntroView() ) unless localStorage.introLodestoneShown
		@collection = new MagnetCollection([], { @torrentClient } )
		@collectionView = new MagnetCollectionView( collection: @collection )
		@output.show( @collectionView )

	_handleSearch: (ev) ->
		ev.preventDefault()
		@lodestone.addSearch( @ui.input.val() )
		false

	_handleData: (data) =>
		for infoHash in data.hashes
			magnet = new Magnet( infoHash: infoHash )
			@collection.add( magnet )

	_handleAddPeer: =>
		console.log 'new peer', arguments

