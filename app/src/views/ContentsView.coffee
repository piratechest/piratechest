{_, $, Backbone, Marionette } = require( '../common.coffee' )
{ OverlayView } = require( './OverlayView.coffee' )

class module.exports.ContentsView extends OverlayView
	template: _.template """
		<div class="overlay contents">
			<div class="content">

				<img src="images/lodestones.svg" alt="Lodestones">
				<p class="welcome">Inside you find a stash of <strong>Lodestones</strong> and a mysterious set of <strong>blank playing cards</strong> otherwise the box is empty save for a small <strong>note</strong>.</p>

				<img class="note" src="images/note.svg" alt="A Small Note">

				<button class="button">Ok</button>
			</div>
		</div>
	"""
	events: 
		'click button': 'handleClickOpen'

	handleClickOpen: ->
		@trigger('close')