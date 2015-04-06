Datastore = require 'nedb'
path = require 'path'
_ = require 'underscore'
Logger = require './Logger.coffee'
log = new Logger( verbose: false )


class Store
    constructor: (name) ->
        #@_store = new Datastore( filename: path.join( __dirname, "./data/#{ name }.db" ), autoload: true )
        @_store = new Datastore( filename: "./data/#{ name }.db", autoload: true )
        @_store.ensureIndex
            fieldName: 'infoHash'
            unique: true
    
    sync: (method, model, options) =>
        log.info "Syncing model to database: ", arguments, model
        switch method
            when 'create' then @_handleCreate( model, options )
            when 'update' then @_handleUpdate( model, options )
            when 'read' then @_handleRead( model, options )
            when 'delete' then @_handleDelete( model, options )
            else throw new Error( "Unkown method (#{ method }) for model sync.", model, options )

    _handleComplete: (options) ->
        (err, resp) ->
            log.info "DB returned:", [err, resp]
            if err
                log.error( err )
                options.error( err, resp )
            else
                options.success( resp )

    _handleCreate: (model, options) =>
        log.info "_handleCreate:", model.toJSON()
        @_store.update {infoHash: model.get('infoHash')},  model.toJSON(), {upsert: true}, @_handleComplete( options )


    _handleUpdate: (model, options) =>
        log.info "_handleUpdate:", arguments
        @_store.update { infoHash: model.get('infoHash') }, model.toJSON(), @_handleComplete( options )


    _handleRead: (model, options) =>
        log.info "_handleRead:", arguments
        @_store.find {}, @_handleComplete( options )


    _handleDelete: (model, options) =>
        log.info "_handleDelete:", arguments
        @_store.remove { infoHash: model.get('infoHash') }, @_handleComplete( options )

module.exports = Store
