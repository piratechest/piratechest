{_, $, Backbone, Marionette, nw } = require( '../common.coffee' )
{ Card, CardCollection } = require '../models/Card.coffee'
{ OverlayView } = require './OverlayView.coffee'

class module.exports.CardsView extends Marionette.LayoutView
    className: 'cards-view'
    template: _.template """
        <div class="draw-card">
            Draw a Card
        </div>
        <div class="cards"></div>
    """
    regions:
        cards: '.cards'

    events:
        'click a': '_handleOpenLink'
        'click .draw-card': '_handleClickButton'

    initialize: ->
        @collection = new CardCollection()
        # @_noop()

    _handleOpenLink: (ev) ->
        nw.Shell.openExternal( ev.currentTarget.href );
        ev.preventDefault()
        false

    onShow: ->
        @cards.show( new CardCollectionView( collection: @collection ) )

    _handleClickButton: ->
        @trigger( 'show:overlay', new CreateCardView( collection: @collection ) )

    _noop: ->
        card1 = Card.fromInput( "TEST" )
        card2 = Card.fromInput( '{"type":"graphic","content":{"img":"data:image/gif;base64,R0lGODlhAQABAIAAAP7//wAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw==","title":"a test card","description":"a test description"}}' )
        card3 = Card.fromInput( type: "data", infoHash: 'asdasdasdasdasd' )
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

class GraphicCardView extends CardView
    template: _.template  """
        <div class="content">
            <div class="rating"><i class="icon-star"></i></div>
            <div class="title"><%= content.title %></div>
            <div class="main-image" style="background-image:url(<%= content.img %>);"></div>
            <div class="set"><%= content.set %></div>
            <div class="type"><%= content.type %></div>
            <div class="tags">
                <% for (var t in content.tags) { %>
                    <span class="tag"><%= content.tags[t] %></span>
                <% } %>
            </div>
            <div class="description"><%= content.description %></div>
            <div class="creator">Creator: asdasdouahdasjdh</div>
        </div>
    """
    serializeData: ->
        type: @model.get 'type'
        content: _.extend( @model.get('content'),
            title: 'title'
            set: 'Custom'
            img: 'image-url'
            type: 'Beta'
            tags: ['Test', 'test2']
            description: 'a good description' )

class EmptyCardCollectionView extends Marionette.ItemView
    className: 'empty-cards-view'
    template: _.template """
    <img src="images/cards.png" alt="">
    <p>The chest contains a mysterious set of blank <strong>Playing Cards</strong>. For the curious, you can find out more information at: <a href="http://github.com/piratechest/piratechest-cards">http://github.com/piratechest/piratechest-cards</a>.</p>

    """
class CardCollectionView extends Marionette.CollectionView
    className: 'card-collection-view'
    getChildView: (card) ->
        if card.get('type') is 'graphic'
            GraphicCardView
        else
            CardView
    emptyView: EmptyCardCollectionView