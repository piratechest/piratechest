
{_, $, Backbone, Marionette, win, nw } = require( '../common.coffee' )


{ TitlebarView  } = require './TitlebarView.coffee'

{ MenuView  } = require './MenuView.coffee'
{ LodestoneView  } = require './LodestoneView.coffee'
{ CardsView  } = require './CardsView.coffee'
{ SettingsView  } = require './SettingsView.coffee'
{ BodyView } = require './BodyView.coffee'


class module.exports.AppView extends Marionette.LayoutView
    className: 'app-view'
    template: _.template """
        <div class="header"></div>
        <div class="menu"></div>
        <div class="overlay"></div>
        <div class="body-region"></div>
    """
    regions:
        header: '.header'
        menu: '.menu'
        body: '.body-region'
        overlay: '.overlay'

    initialize: ({@collection}) ->
        @menuView = new MenuView()
        @listenTo @menuView, 'show:menuItem', @handleShowMenuItem

    onShow: ->
        @header.show( new TitlebarView() )
        @menu.show( @menuView )
        @handleShowMenuItem( 'collection' )

    handleShowMenuItem: (item) ->
        switch item
            when 'collection' then @body.show( new BodyView( collection: @collection ) )
            when 'search' then @body.show( new LodestoneView() )
            when 'cards' then @body.show( new CardsView() )
            when 'settings' then @body.show( new SettingsView() )
            else @body.empty()

    showOverlay: (view) ->
        view.on 'close', => @overlay.empty()
        @overlay.show( view )
