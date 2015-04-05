{_, $, Backbone, Marionette } = require( '../common.coffee' )
{ OverlayView } = require( './OverlayView.coffee' )
Logger = require '../models/Logger.coffee'
log = new Logger()

class module.exports.MenuView extends Marionette.LayoutView
    className: 'menu-view'
    template: _.template """
        <div class="content">
            <ul>
                <li data-item="collection"><i class="icon-magnet"></i><span>Magnet Collection</span></li>
                <li data-item="cards"><i class="icon-tags"></i><span>Card Deck</span></li>
                <li data-item="search" class="search"><i class="icon-search"></i>
                    <span>Lodestone Search</span>
                </li>
                <li data-item="raids" class="raids"><i class="icon-flag"></i><span>Raids</span></li>
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

    initialize: ({@defaultItem}) ->

    onShow: ->
        log.info 'show menuView ', @defaultItem
        el = @$( "li[data-item=\"#{ @defaultItem }\"]" )
        log.info  'default Item', el, @defaultItem
        el.addClass( 'active' )

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