{_, $, Backbone, Marionette, localStorage } = require( '../common.coffee' )
{ OverlayView } = require( './OverlayView.coffee' )

class module.exports.LodestoneIntroView extends OverlayView
	template: _.template """
		<div class="overlay lodestone">
			<div class="content">
				<img src="images/lodestones.svg" alt="">
				<p><strong>Lodestone Search</strong> is a <em>work in progress</em> private distributed search engine for magnets.</p>
				<button>Continue</button>
			</div>
		</div>
	"""
	events: 
		'click button': 'handleClick'

	handleClick: ->
		@destroy()

	onShow: =>
		localStorage.introLodestoneShown = true