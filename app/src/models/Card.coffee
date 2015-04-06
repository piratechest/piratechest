{_, $, Backbone, Marionette, nw } = require( '../common.coffee' )
 
Logger = require './Logger.coffee'
log = new Logger( verbose: false )

class Card extends Backbone.Model

    TYPES =
        TEXT: 'text'
        DATA: 'data'
        GRAPHIC: 'graphic'

    DEFAULT_TYPE = TYPES.DATA

    initialize: (input) ->
        log.info "Initializing card", arguments
        @set( 'type', input.type or DEFAULT_TYPE )

    @fromInput: (input) =>
        return new Card( input ) if typeof input is 'object'

        try
            data = JSON.parse( input )
            return new Card( data )
        catch err
            log.error err
            if typeof input is 'string'
                return new Card( text: input, type: TYPES.TEXT )
            else
                throw new Error( 'Invalid input for Card Model' )

    getContent: =>
        log.info "Card #getContent", @
        type = @get( 'type' )
        if type is TYPES.TEXT
            @get('text')
        else if type is TYPES.GRAPHIC
            @get('content')
        else
            JSON.stringify( JSON.stringify( @attributes ) )



class CardCollection extends Backbone.Collection
    model: Card
    initialize: ->





module.exports = { Card, CardCollection }