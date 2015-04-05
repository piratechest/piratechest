{_, $, Backbone, Marionette, nw } = require( '../common.coffee' )
 
Logger = require './Logger.coffee'
log = new Logger()

class Card extends Backbone.Model

    TYPES =
        TEXT: 'text'
        DATA: 'data'

    DEFAULT_TYPE = TYPES.DATA

    initialize: (input) ->
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
        type = @get( 'type' )
        log.info @
        if type is TYPES.TEXT
            @get('text')
        else
            JSON.stringify( JSON.stringify( @attributes ) )



class CardCollection extends Backbone.Collection
    model: Card
    initialize: ->





module.exports = { Card, CardCollection }