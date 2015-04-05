
// I wish! 
// This code will not be run in the node context so no require/coffeescript
// require('coffee-script/register')
// require('./src/raid.coffee')
console.log( "Preparing for Raid.", document.readyState, window );




var done = function () {
	console.log('Piratehcest Raiding party. Go!');

	var links = document.getElementsByTagName('a');
	try{
		console.log( "Links: ", links );
	} catch(err) {

	}

	var magnetRegex = /^magnet:\?/
	var magnets = [];

	for ( var i=links.length; i--; i<0 ) {
		try {
			var href = links[i].href;
			var isMagnetUri = magnetRegex.test( href );
			if (isMagnetUri) {
				console.log( 'magnet: ', isMagnetUri, ' link: ', href )
				magnets.push( href )

				function reqListener () {
					console.log("Raid success reported!", this.responseText);
				}

				var oReq = new XMLHttpRequest();
				oReq.onload = reqListener;
				oReq.open("get", "http://localhost:1337/raid?uri=" + window.encodeURIComponent( href ), true);
				oReq.send();
			}
		} catch(err) {

		}
	}

	if (magnets.length > 0) {
		alert("Raid Success!");
	}
}

var wait = function(){
	if (document.readyState === 'complete' ) done();
	else window.setTimeout( wait, 1000 );	
}

wait();


