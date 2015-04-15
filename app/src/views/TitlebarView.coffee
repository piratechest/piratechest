
{ _, $, Backbone, Marionette } = require( '../common.coffee' )
{ nw } = window.nwin
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
        @_getWin().minimize()

    handleFullscreen: ->
        log.info 'Fullscreen App'
        @_getWin().toggleFullscreen()

    handleClose: ->
        log.info 'Close App'
        @_getWin().close()

    handleDebug: ->
        log.info 'Debug App'
        @_getWin().showDevTools()

    _getWin: ->
        nw.Window.get()