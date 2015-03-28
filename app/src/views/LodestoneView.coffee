{_, $, Backbone, Marionette } = require( '../common.coffee' )


class module.exports.LodestoneView extends Marionette.LayoutView
	className: 'lodestone-view'
	template: _.template """
		<div class="content">
			<img src="images/lodestones.svg" alt="">
			<p><strong>Lodestone Search</strong> is a <em>work in progress</em> private distributed search engine for magnets.</p>
		</div>
	"""