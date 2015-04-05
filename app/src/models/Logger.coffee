

class Logger
    constructor: ({@verbose} = {})->

    info: (args...) ->
        return unless @verbose
        window.console.log.apply( window.console, args )

    error: (args...) ->
        window.console.error.apply( window.console, args )

module.exports = Logger