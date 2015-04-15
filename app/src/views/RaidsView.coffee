{_, $, Backbone, Marionette, nw } = require( '../common.coffee' )
{ Raid } = require '../models/Raid.coffee'
{ Magnet } = require '../models/Magnet.coffee'
{ MagnetCollection } = require '../models/MagnetCollection.coffee'
Logger = require '../models/Logger.coffee'
log = new Logger( verbose: true )

{ OverlayView } = require './OverlayView.coffee'
{ MagnetCollectionView  } = require './MagnetCollectionView.coffee'

class module.exports.RaidsView extends Marionette.LayoutView
    className: 'raids-view'
    template: _.template """
        <div class="content">
            <img class="main-img" src="images/map.svg" alt="">
            <p>Start raiding to gather loot.</p>
            <button class="start-raid">Start</button>
        </div>
    """
    ui:
        loot: '.loot'
        content: '.content'

    events:
        'click a': 'openLink'
        'click .start-raid': '_handleStartRaid'

    initialize: ({@collection}) ->

    openLink: (ev) ->
        nw.Shell.openExternal( ev.currentTarget.href );
        ev.preventDefault()
        false

    _handleStartRaid: ->
        raid = new Raid()
        raidDetailsView = new RaidDetailsView( model: raid )
        @trigger( 'show:overlay', raidDetailsView )
        @listenTo raidDetailsView, 'loot', (collection) =>
            log.info "saving loot", collection, @collection
            @collection.create( model ) for model in collection.models
            log.info "saved loot", collection, @collection



class RaidDetailsView extends OverlayView
    template: _.template """
        <div class="overlay raid">
            <div class="content">
                <h2>Current Raid</h2>
                <div class="url">url: <%- url %></div>
                <div class="brethren">Brethren: <%- peers %></div>
                <div class="loot-amount">
                    <img src="images/coins.svg" alt=""><span class="count">0</span>
                </div>
                <div class="loot">...</div>
                <button class="cancel-loot">Discard loot and Cancel Raid</button>
                <button class="save-loot">Save Loot</button>
            </div>
        </div>
    """
    ui:
        lootCount: '.loot-amount .count'

    events:
        'click .cancel-loot': '_discardLoot'
        'click .save-loot': '_saveLoot'

    regions:
        lootRegion: '.loot'

    onShow: ->
        log.info "Started Raid: ", @model
        @listenTo @model, 'new:loot', @_handleUpdates
        log.info "Listening for Raid Loot Updates..."
        @lootCollection = new MagnetCollection()
        @lootRegion.show( new MagnetCollectionView( collection: @lootCollection ) )


    _saveLoot: ->
        @trigger 'loot', @lootCollection
        @_endRaid()

    _discardLoot: ->
        @_endRaid()

    _endRaid: ->
        @model.close()
        @destroy()

    _handleUpdates: (updates) ->
        log.info "Raid loot updates from model:", updates
        @lootCollection.add( new Magnet.fromUri(update.uri) ) for update in updates
        @ui.lootCount.text( @lootCollection.length )