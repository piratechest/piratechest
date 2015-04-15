{_, $, Backbone, Marionette, win, nw } = require( '../common.coffee' )
{ PeerGraph } = require './PeerGraph.coffee' 

class module.exports.SettingsView extends Marionette.LayoutView
    className: 'settings-view'
    template: _.template """
        <div class="content">
            
            <p><strong>Pirate Chest</strong> is still a  work in progress so many settings are hardcoded, with time they will be extracted to this view to give users more fine grained control.</p>
            <p>For <strong>Documentation</strong> or to <strong>Report Bugs</strong> you can go to our github repo at: <a href="http://github.com/piratechest/piratechest">http://github.com/piratechest/piratechest</a>.</p>
            <div>
                <div class="localstorage">LocalStorage: <a href="#">Clear All</a></div>
            </div>
            <p class="local-node">Local node:
                <span class="local-id">???</span>@<span class="local-host">???</span>:<span class="local-port">???</span>
            </p>
            <h3>Seeds</h3>
            <div class="seeds"></div>
            <h3>Peers</h3>
            <div class="peers"></div>
            <div class="graph"></div>
        </div>
    """
    ui:
        localId: '.local-id'
        localHost: '.local-host'
        localPort: '.local-port'

    regions:
        peers: '.peers'
        seeds: '.seeds'
        graph: '.graph'

    events:
        'click a': 'openLink'
        'click .localstorage a': '_handleClearLocalStorage'

    initialize: ({@config, @torrrentClient, @lodestone}) ->

    onShow: ->
        @peerCollection = new Backbone.Collection()
        @peers.show( new PeerCollectionView( collection: @peerCollection ) )
        @seedCollection = new Backbone.Collection()
        @seeds.show( new PeerCollectionView( collection: @seedCollection ) )
        @lodestone.on 'update-peers', @_handlePeerChanges
        @_handlePeerChanges()
        @_handleSetSeeds()
        @lodestone.ping()

        @ui.localId.text( @lodestone.gossip.localPeer.id )
        @ui.localHost.text( @lodestone.gossip.localPeer.transport.host )
        @ui.localPort.text( @lodestone.gossip.localPeer.transport.port )


    onClose: ->
        @lodestone.off 'update-peers', @_handlePeerChanges

    _handleSetSeeds: =>
        for peer in @lodestone.gossip.seeds
            @seedCollection.add new Backbone.Model
                id: peer.id
                host: peer.transport.host
                port: peer.transport.port
                live: false

    _handlePeerChanges: =>
        console.log "Handle lodestone peer changes"
        @peerCollection.reset([])
        for peer in @lodestone.gossip.storage.livePeers()
            @peerCollection.add new Backbone.Model
                id: peer.id
                host: peer.transport.host
                port: peer.transport.port
                live: true

        for peer in @lodestone.gossip.storage.deadPeers()
            @peerCollection.add new Backbone.Model
                id: peer.id
                host: peer.transport.host
                port: peer.transport.port
                live: false

        if @peerCollection.length > 0

            # # peersPeers = {}
            # # @peerCollection.each (p) ->
            # #     peersPeers[key] = { name: key, group: 2 } for key, value in p.data?.graph?[0]

            # # peerLinks = @peerCollection.map (p) ->
            # #     { source: p.id, target: key, value: 1 } for key, value in p.data?.graph?[0]

            console.log @lodestone.gossip.localPeer.data.graph[0]
            nodes = [{ name: @lodestone.gossip.localPeer.id, group: 0 }]
            links = []
            decend = (sourceIndex, input, depth) ->
                for own key, value of input
                    index = _.findIndex(nodes, (n) -> n.name is key )
                    nodes.push { name: key, group: depth } if index is -1
                    index = _.findIndex(nodes, (n) -> n.name is key )
                    links.push { source: sourceIndex, target: index }
                    decend( index, value, depth++ )

            decend( 0, @lodestone.gossip.localPeer.data.graph[0], 1 )

            console.log nodes, links

            @graph.show new PeerGraph
                nodes: nodes
                links: links


    openLink: (ev) ->
        nw.Shell.openExternal( ev.currentTarget.href );
        ev.preventDefault()
        false

    _handleClearLocalStorage: ->
        confirm = window.confirm "Are you sure you want to clear your localStorage?"
        window.localStorage.clear() if confirm


class PeerView extends Marionette.ItemView
    className: => "peer-view #{ if @model.get('live') then 'live' else '' }"
    template: _.template """
        <i class="icon-<%= live ? 'circle' : 'circle-blank' %>"></i>
        <span class="id"><%- id %></span> - <span class="host"><%- host %></span>:<span class="port"><%- port %></span>
    """


class PeerCollectionView extends Marionette.CollectionView
    className: 'peer-collection-view'
    childView: PeerView