{_, $, Backbone, Marionette } = require( '../common.coffee' )

class module.exports.OverlayView extends Marionette.ItemView
    className: 'overlay-view'
    template: _.template """
        <div class="overlay">
            <div class="content">
                <h1>Hi</h1>
                <p>I'm an overlay!</p>
            </div>
        </div>
    """
    events:
        'click .overlay': 'handleClickOverlay'
        'click .content': 'handleClickContent'

    handleClickContent: (ev) ->
        ev.preventDefault()
        false

    handleClickOverlay: ->
        @destroy()