
{_, $, Backbone, Marionette, win, nw } = require( '../common.coffee' )

{ MagnetCollectionView  } = require './MagnetCollectionView.coffee'
{ Magnet } = require '../models/models.coffee'
{ DetailsView  } = require './DetailsView.coffee'

class module.exports.BodyView extends Marionette.LayoutView
    className: 'body-view'
    template: _.template """
        <form class="add-new">
            Add new magnet <input placeholder="infoHash" type="text" class="infoHash"/> <button><i class="icon-plus"></i></button>
        </form>
        <div class="magnets-region"></div>
        <div class="details-region"></div>
    """
    ui:
        input: '.add-new input'
    
    regions:
        magnets: '.magnets-region'
        details: '.details-region'

    events:
        'submit form': 'handleAddMagnet'
        'click .add-new button': 'handleAddMagnet' 
    
    initialize: ({@collection}) ->
        @collectionView = new MagnetCollectionView( collection: @collection )
        @listenTo @collectionView, 'show:details', @handleShowDetails

    handleAddMagnet: (ev) ->
        ev.preventDefault()
        magnet = new Magnet
            infoHash: @ui.input.val()
            favorite: false
        @collection.add( magnet )
        @ui.input.val( '' )

    onShow: ->
        @magnets.show( @collectionView )

    handleShowDetails: (magnet) ->
        detailsView = new DetailsView( model: magnet )
        @details.show( detailsView )
        detailsView.on 'close', => @details.empty()