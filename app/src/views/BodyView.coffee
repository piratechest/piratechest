readTorrent = require 'read-torrent'
file = require 'file'

{_, $, Backbone, Marionette, win, nw } = require( '../common.coffee' )

{ MagnetCollectionView  } = require './MagnetCollectionView.coffee'
{ Magnet } = require '../models/Magnet.coffee'
{ DetailsView  } = require './DetailsView.coffee'

Logger = require '../models/Logger.coffee'
log = new Logger()

class module.exports.BodyView extends Marionette.LayoutView
    className: 'body-view'
    template: _.template """
        <ul class="actions">
            <li class="paste-btn">
                <i class="icon-magnet"></i>
                <span>Paste from clipboard</span>
            </li>
            <li class="import-btn">
                <i class="icon-folder-open"></i>
                <span>Import folder</span>
                <input class="input-overlay" type="file" webkitdirectory />
            </li>
        </ul>
        <div class="magnets-region"></div>
        <div class="details-region"></div>
    """
    ui:
        dirInput: '.import-btn input'
    
    regions:
        magnets: '.magnets-region'
        details: '.details-region'

    events:
        'click .paste-btn': '_handlePasteMagnet'
        'change .import-btn input': '_handleImportFolder' 
    
    initialize: ({@collection}) ->

    onShow: ->
        @collectionView = new MagnetCollectionView( collection: @collection )
        @listenTo @collectionView, 'show:details', @_handleShowDetails
        @magnets.show( @collectionView )

    _handlePasteMagnet: ->
        clipboard = nw.Clipboard.get()
        contents = clipboard.get('text')
        magnet = Magnet.fromUri( contents )
        @collection.create( magnet ) if magnet

    _handleImportFolder: (ev) ->
        path = @ui.dirInput?.get(0)?.files[0]?.path
        log.info "Importing torrents from: ", path
        collection = @collection
        file.walk path, (err, dirPath, dirs, files) ->
            return if err
            for file in files
                log.info "Checking file: ", file
                if /\.torrent$/.test( file )
                    log.info "Found .torrent. "
                    torrent = readTorrent file, (err, torrent) ->
                        return if err
                        log.info "Read torrent successfully: ", torrent
                        magnet = Magnet.fromTorrent( torrent )
                        collection.create( magnet )

    _handleAddMagnet: (ev) ->
        ev.preventDefault()
        magnet = new Magnet
            infoHash: @ui.input.val()
            favorite: false
        @collection.add( magnet )
        @ui.input.val( '' )

    _handleShowDetails: (magnet) ->
        detailsView = new DetailsView( model: magnet )
        @details.show( detailsView )
        detailsView.on 'close', => @details.empty()