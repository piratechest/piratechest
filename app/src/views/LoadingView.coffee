{_, $, Backbone, Marionette } = require( '../common.coffee' )

class module.exports.LoadingView extends Marionette.ItemView
    className: 'loading-view'
    template: _.template """
        <img src="images/logo.svg" alt="Pirate Chest" />
        <p>Loading...</p>
    """
