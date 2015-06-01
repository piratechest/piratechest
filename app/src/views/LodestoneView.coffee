{_, $, Backbone, Marionette, localStorage } = require( '../common.coffee' )

{ MagnetCollectionView  } = require './MagnetCollectionView.coffee'
{ Magnet } = require '../models/Magnet.coffee'
{ MagnetCollection } = require '../models/MagnetCollection.coffee'


Logger = require '../models/Logger.coffee'
log = new Logger( verbose: false )

class module.exports.LodestoneView extends Marionette.LayoutView
    className: 'lodestone-view'
    template: _.template """
        <div class="content">
            <form class="search" action="">
                <i class="icon-search"></i><input type="text" placeholder="Search">
            </form>
            <div class="searches"></div>
        </div>
    """
    events:
        'submit form': '_handleSearch'
    ui:
        input: 'input'

    noop: (ev) ->
        ev.preventDefault()
        false

    regions:
        searchesRegion: '.searches'
        output: '.output'

    initialize: ({@torrentClient, @config, collection, @lodestone}) ->
        log.info "LodestoneView init.", @torrentClient, @lodestone

    onShow: ->
        log.info "LodestoneView show."
        @searches = new Backbone.Collection()
        @searchesRegion.show( new LodestoneSearchCollectionView( collection: @searches ) )

    _handleSearch: (ev) ->
        ev.preventDefault()
        input = @ui.input.val()
        search = @lodestone.newSearch( input )
        console.log( "Search:", search )
        @searches.add( search )
        false



class LodestoneEmptyView extends Marionette.ItemView
    className: 'lodestone-empty-view'
    template: _.template """
        <img src="images/lodestones.svg" alt="">
        <p><strong>Lodestone Search</strong> is a <em>work in progress</em> private distributed search engine for magnets.</p>
    """

class LodestoneSearchView extends Marionette.ItemView
    className: 'lodestone-search-view'
    template: _.template """
        <div class="input">
            <% for (var tag in tags) { %><span class="tag"><%- tags[tag] %></span><% } %><i class="icon-remove remove-search"></i>
        </div>
        <div class="results"></div>
    """
    events:
        'click .remove-search': '_handleRemoveSearch'

    templateHelpers: =>
        tags: @model.get( 'input' ).split( /\W+/ )

    initialize: ({@model, @torrentClient}) ->
    onShow: ->
        @output = new Marionette.Region( el: @$('.results')[0] )
        @searchResults = new MagnetCollection([], { @torrentClient } )
        @resultsView = new MagnetCollectionView( collection: @searchResults )
        @output.show( @resultsView )
        @model.on 'result', (infoHash) =>
            @searchResults.add( Magnet.fromUri( infoHash ) )

    _handleRemoveSearch: ->
        @model.destroy()

class LodestoneSearchCollectionView extends Marionette.CollectionView
    className: 'lodestone-search-collection-view'
    childView: LodestoneSearchView
    emptyView: LodestoneEmptyView

    initialize: ({@torrentClient})->

    childViewOptions: (model, index)->
        torrentClient: @torrentClient
        model: model




