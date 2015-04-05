
global.document = window.document
localStorage = window.localStorage

{ nw, win } = window.nwin

_ = require 'underscore'
$ = require 'jquery'
Backbone = require 'backbone'
Backbone.$ = $
Marionette = require 'backbone.marionette'


module.exports = { _, $, Backbone, Marionette, nw, win, localStorage }
