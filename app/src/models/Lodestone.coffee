{_, $, Backbone, Marionette, nw } = require( '../common.coffee' )

Web3 = require 'web3'
web3 = new Web3('http://localhost:8545')

LODESTONE_REQUEST_TOPIC = "lodestone_search"


class LodestoneSearch extends Backbone.Model
    initialize: ({input}) ->
        @set( 'input', input )
        @_createFilter()
        @_sendSearch()

    _sendSearch: ->
        web3.shh.post
            topics: [LODESTONE_REQUEST_TOPIC]
            ttl: 100
            priority: 1000
            payload: [ @get( 'input' ) ]

    _createFilter: ->
        @filter = web3.shh.filter
            topics: [ @get( 'input' ) ]
        @filter.watch( @_handleFilterResponse )

    _handleFilterResponse: (err, resp) =>
        if err
            @filter.stopListening()
        else
            console.log( resp )
            @trigger( 'result', resp.payload[0] )

class module.exports.Lodestone
    constructor: ({@host, @port, @magnetCollection})->
        endpoint = "http://#{ @host }:#{ @port }"
        # somewhere here provide better error handling of failed ethnode connection
        console.log "Lodestone Ethererum RPC Node endpoint: ", endpoint
        httpProvider = new web3.providers.HttpProvider( endpoint ) if web3? and web3.providers?
        web3.setProvider( httpProvider ) if web3?
        @searches = []
        @_listenForSearches()

    _listenForSearches: ->
        @filter = web3.shh.filter( topics: [ LODESTONE_REQUEST_TOPIC ] ) if web3? and web3.shh?
        @filter.watch (err, resp) =>
            search = resp.payload[0]
            console.log( "Incomming search: ", search ) unless err
            console.error( err ) if err
            @magnetCollection.search( search ).each (magnet) ->
                if magnet.get('searchscore') > 0.5
                    console.log "Responding to search with result: ", magnet
                    web3.shh.post
                        topics: [search]
                        ttl: 100
                        priority: 1000
                        payload: [ magnet.get('infoHash') ]

    newSearch: (input) ->
        search = new LodestoneSearch( input: input )
        @searches.push( search )
        search

    stopSearches: ->
        search.filter.stopListening() for search in @searches
