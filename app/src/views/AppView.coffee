
{_, $, Backbone, Marionette, win, nw } = require( '../common.coffee' )


{ TitlebarView  } = require './TitlebarView.coffee'

{ MenuView  } = require './MenuView.coffee'
{ LodestoneView  } = require './LodestoneView.coffee'
{ CardsView  } = require './CardsView.coffee'
{ SettingsView  } = require './SettingsView.coffee'
{ BodyView } = require './BodyView.coffee'
{ RaidsView } = require './RaidsView.coffee'

Logger = require '../models/Logger.coffee'
log = new Logger()

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

    initialize: ({collection, config, torrentClient, lodestone}) ->
        @collection = collection
        @config = config
        @torrentClient = torrentClient

        @defaultItem = config?.defaultView
        @menuView = new MenuView( { @defaultItem } )
        
        @views = {}
        @views['collection'] = new BodyView( {collection } )
        @views['search'] = new LodestoneView( {config, collection, torrentClient, lodestone} )
        @views['cards'] = new CardsView()
        @views['settings'] = new SettingsView( {config, torrentClient, lodestone} )
        @views['raids'] = new RaidsView( {collection} )

    onShow: ->
        @header.show( new TitlebarView() )
        @menu.show( @menuView )
        @listenTo @menuView, 'show:menuItem', @_handleShowMenuItem
        @_handleShowMenuItem( @defaultItem or 'collection' )

    _handleShowMenuItem: (item) ->
        view = @views[item]
        @listenTo view, 'show:overlay', @showOverlay
        log.info "AppView: showing #{ item } view.", view    
        @body.show( view, preventDestroy: true )

    showOverlay: (view) ->
        log.info "Showing overlay: ", view
        @overlay.show( view )
