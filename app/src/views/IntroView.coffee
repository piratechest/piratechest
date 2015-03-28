{_, $, Backbone, Marionette } = require( '../common.coffee' )
{ OverlayView } = require( './OverlayView.coffee' )

class module.exports.IntroView extends OverlayView
	template: _.template """
		<div class="overlay intro">
			<div class="content">
				<p class="welcome">It would seem you have found a pirate chest.</p>
				<img src="images/logo.svg" alt="">
				<code>
					<pre>DISCLAIMER</pre>
				</code>
				<button class="button">Open</button>
			</div>
		</div>
	"""
	events: 
		'click button': 'handleClickOpen'

	handleClickOpen: ->
		@trigger('close')

	handleClickOverlay: (ev) ->
		ev.preventDefault()
		false