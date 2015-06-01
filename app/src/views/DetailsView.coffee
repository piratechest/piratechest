{_, $, Backbone, Marionette } = require( '../common.coffee' )

class module.exports.DetailsView extends Marionette.ItemView
    className: 'details-view'
    template: _.template """
        <div class="overlay">
            <div class="content">
            <div class="close">
                <i class="icon-remove"></i>
            </div>
            <p>Magnet Details</p>
            <ul>
                <li><strong>Title:</strong> <%- dn %></li>
                <li><strong>Info Hash:</strong> <%- infoHash %></li>
                <li><strong>Favorite:</strong> <%- favorite %></li>
                <li><strong>Status:</strong> <%- status ? 'ok' : 'unknown' %></li>
                <li>
                    <strong>Trackers:</strong>
                    <ol>
                        <% for ( t in tr ) { %>
                            <li><%- tr[t] %></li>
                        <% } %>
                    </ol>
                </li>
                <li><strong>Peers:</strong> <%- peers %></li>
                <li>
                    <a class="uri" href="<%- uri %>"><%- uri %></a>
                </li>
                <li>
                    <strong>Tags:</strong>
                    <ol>
                        <%for ( tag in tags ) { %>
                            <li><%- tags[tag] %></li>
                        <% } %>
                    </ol>
                </li>
            </ul>
        </div></div>
    """
    events:
        'click .close': 'handleClose'

    serializeData: ->
        uri: @model.getUri()
        tags: @model.getTags()
        infoHash: @model.get('infoHash')
        dn: @model.get('dn')
        tr: @model.get('tr')
        favorite: @model.get('favorite')
        status: @model.get('status')
        peers: @model.get('peers')

    initialize: ->
        @listenTo @model, 'change', @render

    onShow: ->
        console.log( "Showing details for: ", @model)
        window.Mousetrap.bind('del', @_deleteMagnet )
        @_updateDetails()

    _updateDetails: ->
        console.log @model
        @model.torrent?.discovery?.tracker?.scrape?()
        @model.torrent?.discovery?.tracker?.on 'scrape', (data) =>
            console.log "Got Scrape event for torrent: #{ @model.torrent.infoHash }"
            @model.set('peers', data.complete )

    _deleteMagnet: =>
        @model.destroy()
        @handleClose()

    handleClose: ->
        window.Mousetrap.reset()
        @trigger( 'close' )