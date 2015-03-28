{_, $, Backbone, Marionette } = require( '../common.coffee' )
{ OverlayView } = require( './OverlayView.coffee' )

class module.exports.MenuView extends Marionette.LayoutView
	className: 'menu-view'
	template: _.template """
		<div class="content">
			<ul>
				<li class="active" data-item="collection"><i class="icon-magnet"></i>Magnet Collection</li>
				<li data-item="cards"><i class="icon-tags"></i>Card Deck</li>
				<li data-item="search" class="search">
					<form action="">
						<i class="icon-search"></i>
						Lodestone
						<input placeholder="Search" type="text">
					</form>
				</li>
				<li class="settings" data-item="settings"><i class="icon-cog"></i></li>
			</ul>
		</div>
	"""
	ui:
		items: 'li'

	events:
		'click li': 'handleClickItem'
		'click .search input': 'noop'
		'submit .search form': 'noop'

	noop: (ev) ->
		el = ev.currentTarget
		false

	handleClickItem: (ev) ->
		el = ev.currentTarget
		item = @$( el ).attr( 'data-item' )
		@ui.items.removeClass( 'active' )
		@$( el ).addClass( 'active' )

		ev.preventDefault()
		@trigger( 'show:menuItem', item )
		false