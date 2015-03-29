
global.document = window.document
{ nw, win } = window.nwin
localStorage = window.localStorage

_ = require 'underscore'
$ = require 'jquery'
Backbone = require 'backbone'
Backbone.$ = $
Marionette = require 'backbone.marionette'


module.exports = { _, $, Backbone, Marionette, nw, win, localStorage }
