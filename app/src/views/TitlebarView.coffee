
{ _, $, Backbone, Marionette } = require( '../common.coffee' )
{ nw, win } = window.nwin
Logger = require '../models/Logger.coffee'
log = new Logger()

class module.exports.TitlebarView extends Marionette.ItemView
    className: 'titlebar-view'
    template: _.template """
        <div class="controls">
            <div class="close">
                <i class="icon-remove"></i>
            </div>
            <div class="min">
                <i class="icon-minus"></i>
            </div>
            <div class="max">
                <i class="icon-plus"></i>
            </div>
        </div>
        <div class="debug">
            <i class="icon-code"></i>
        </div>
        <div class="title">Pirate Chest</div>
    """
    events:
        'click .close': 'handleClose'
        'click .max': 'handleFullscreen'
        'click .min': 'handleMinify'
        'click .debug': 'handleDebug'

    handleMinify: ->
        log.info 'Minify App'
        win.minimize()

    handleFullscreen: ->
        log.info 'Fullscreen App'
        win.toggleFullscreen()

    handleClose: ->
        log.info 'Close App'
        win.close()

    handleDebug: ->
        log.info 'Debug App'
        win.showDevTools()