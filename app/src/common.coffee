
global.document = window.document
localStorage = window.localStorage

{ nw, win } = window.nwin

_ = require 'underscore'
$ = require 'jquery'
Backbone = require 'backbone'
Backbone.$ = $
Marionette = require 'backbone.marionette'

window.Backbone = Backbone
window._ = _
window.Marionette = Marionette
window.jQuery = window.$ = $


module.exports = { _, $, Backbone, Marionette, nw, win, localStorage }
