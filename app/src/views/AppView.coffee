
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

    initialize: ({@collection, config, @torrentClient}) ->
        @defaultItem = config?.defaultView
        @menuView = new MenuView( { @defaultItem } )
        @bodyView = new BodyView( collection: @collection )
        @searchView = new LodestoneView( collection: @collection, torrentClient: @torrentClient )
        @cardsView = new CardsView()
        @settingsView = new SettingsView()

    onShow: ->
        @header.show( new TitlebarView() )
        @menu.show( @menuView )
        @listenTo @menuView, 'show:menuItem', @handleShowMenuItem
        @handleShowMenuItem( @defaultItem or 'collection' )

    handleShowMenuItem: (item) ->
        view = switch item
            when 'collection' then @bodyView
            when 'search' then @searchView
            when 'cards' then @cardsView
            when 'settings' then @settingsView

        @listenTo view, 'show:overlay', @showOverlay
        console.log "AppView: showing #{ item } view.", view    
        @body.show( view, preventDestroy: true )

    showOverlay: (view) ->
        console.log "Showing overlay: ", view
        @overlay.show( view )
