{_, $, Backbone, Marionette, nw } = require( '../common.coffee' )
{ Card, CardCollection } = require '../models/Card.coffee'
{ OverlayView } = require './OverlayView.coffee'

class module.exports.CardsView extends Marionette.LayoutView
    className: 'cards-view'
    template: _.template """
        <div class="content">
            <img src="images/cards.png" alt="">
            <p>The chest contains a mysterious set of blank <strong>Playing Cards</strong>. For the curious, you can find out more information at: <a href="http://github.com/piratechest/piratechest-cards">http://github.com/piratechest/piratechest-cards</a>.</p>

            <button>Draw a Card</button>
        </div>
        <div class="cards"></div>
    """
    regions:
        cards: '.cards'

    events:
        'click a': '_handleOpenLink'
        'click button': '_handleClickButton'

    initialize: ->
        @collection = new CardCollection()

    _handleOpenLink: (ev) ->
        nw.Shell.openExternal( ev.currentTarget.href );
        ev.preventDefault()
        false

    onShow: ->
        @cards.show( new CardCollectionView( collection: @collection ) )

    _handleClickButton: ->
        @trigger( 'show:overlay', new CreateCardView( collection: @collection ) )

    _noop: ->
        card1 = new Card( "TEST" )
        card2 = new Card( '{"type":"graphic","img":"data:image/gif;base64,R0lGODlhAQABAIAAAP7//wAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw==","title":"a test card","description":"a test description"}' )
        card3 = new Card( type: "data", infoHash: 'asdasdasdasdasd' )
        console.log 'created test cards', 'this:', this, '@:', @
        @collection.add( card1 )
        @collection.add( card2 )
        @collection.add( card3 )

class CreateCardView extends OverlayView
    template: _.template """
        <div class="overlay create-card">
            <div class="content">
                <textarea name="" id="" cols="30" rows="10"></textarea>
                <button>Write to Card</button>
            </div>
        </div>
    """
    ui:
        input: 'textarea'

    events:
        'click button': '_handleClickButton'
        'click .overlay': '_handleClickOverlay'
        'click .content': '_handleClickContent'


    initialize: ({@collection}) ->

    _handleClickContent: (ev) ->
        ev.preventDefault()
        false

    _handleClickOverlay: ->
        @destroy()

    _handleClickButton: (ev) ->
        input = @ui.input.val()
        @collection.add( Card.fromInput( input ) )
        @destroy()


class CardView extends Marionette.ItemView
    className: => "card-view #{ @model.get( 'type' ) }-card"
    template: _.template """
        <%- content %>
    """
    serializeData: ->
        type: @model.get( 'type' )
        content: @model.getContent()

class CardCollectionView extends Marionette.CollectionView
    className: 'card-collection-view'
    childView: CardView