{_, $, Backbone, Marionette, win, nw } = require( '../common.coffee' )


class module.exports.SettingsView extends Marionette.LayoutView
	className: 'settings-view'
	template: _.template """
		<div class="content">
			<img src="images/map.svg" alt="">
			<p><strong>Pirate Chest</strong> is still a  work in progress so many settings are hardcoded, with time they will be extracted to this view to give users more fine grained control.</p>
			<p>For <strong>Documentation</strong> or to <strong>Report Bugs</strong> you can go to our github repo at: <a href="http://github.com/piratechest/piratechest">http://github.com/piratechest/piratechest</a>.</p>
			<div>
				<div class="localstorage">LocalStorage: <a>Clear All</a></div>
			</div>
		</div>
	"""
	events:
		'click a': 'openLink'
		'click .localstorage a': '_handleClearLocalStorage'

	openLink: (ev) ->
		nw.Shell.openExternal( ev.currentTarget.href );
		ev.preventDefault()
		false

	_handleClearLocalStorage: ->
		confirm = window.confirm "Are you sure you want to clear your localStorage?"
		window.localStorage.clear() if confirm