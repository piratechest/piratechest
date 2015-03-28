{_, $, Backbone, Marionette, nw } = require( '../common.coffee' )


class module.exports.CardsView extends Marionette.LayoutView
	className: 'cards-view'
	template: _.template """
		<div class="content">
			<img src="images/cards.png" alt="">
			<p>The chest contains a mysterious set of blank <strong>Playing Cards</strong>. For the curious, you can find out more information at: <a href="http://github.com/piratechest/piratechest-cards">http://github.com/piratechest/piratechest-cards</a>.</p>
		</div>
	"""
	events:
		'click a': 'openLink'

	openLink: (ev) ->
		nw.Shell.openExternal( ev.currentTarget.href );
		ev.preventDefault()
		false