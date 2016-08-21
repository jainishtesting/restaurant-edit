
var map;
var marker;
var placeSearch, autocomplete;
var geocoder = new google.maps.Geocoder();
var mapLoad = false;

function geocodePosition(pos) {
    geocoder.geocode({
        latLng: pos
    }, function (responses) {
        if (responses && responses.length > 0) {
            updateMarkerAddress(responses[0].formatted_address);
        } else {
            updateMarkerAddress('Cannot determine address at this location.');
        }
    });
}

function geocodePosition1(pos) {
    geocoder.geocode({
        latLng: pos
    }, function (responses) {
        if (responses && responses.length > 0) {
            console.log(responses[0].formatted_address);
            updateMarkerAddress1(responses[0].formatted_address);
        } else {
            updateMarkerAddress1('Cannot determine address at this location.');
        }
    });
}

function updateMarkerAddress1(str) {
    document.getElementById("txtLocation").value = str;
}

function updateMarkerStatus(str) {
    //document.getElementById('markerStatus').innerHTML = str;
}

function updateMarkerPosition(latLng) {
    //document.getElementById('info').innerHTML = [
    //  latLng.lat(),
    //  latLng.lng()
    //].join(', ');
}

function updateMarkerAddress(str) {
    document.getElementById("txtLocation").value = "";
}

function geocode() {
    var address = document.getElementById("txtLocation").value;
    geocoder.geocode({
        'address': address,
        'partialmatch': true
    }, geocodeResult);
}

function geocodeResult(results, status) {
    if (status == 'OK' && results.length > 0) {
        map.fitBounds(results[0].geometry.viewport);

        var latLng = new google.maps.LatLng(results[0].geometry.location.lat(), results[0].geometry.location.lng());

        // Update current position info.
        updateMarkerPosition(latLng);
        geocodePosition(latLng);
        marker.setPosition(latLng);
    } else {
        //alert("Geocode was not successful for the following reason: " + status);
    }
}

function initialize() {
    var latLng = new google.maps.LatLng(-34.397, 150.644);

    autocomplete = new google.maps.places.Autocomplete(document.getElementById('txtLocation'), { types: ['geocode'] });
    google.maps.event.addListener(autocomplete, 'place_changed', function () {
        //fillInAddress();
        geocode();
    });

    map = new google.maps.Map(document.getElementById('mapCanvas'), {
        zoom: 8,
        center: latLng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    });

    marker = new google.maps.Marker({
        position: latLng,
        title: 'Point A',
        map: map,
        draggable: true
    });

    // Update current position info.
    updateMarkerPosition(latLng);
    geocodePosition(latLng);

    // Add dragging event listeners.
    google.maps.event.addListener(marker, 'dragstart', function () {
        //updateMarkerAddress('Dragging...');
    });

    google.maps.event.addListener(marker, 'drag_changed', function () {
        //updateMarkerStatus('Dragging...');
        //console.log(marker);
        //document.getElementById("txtLocation").value = marker.formatted_address;
        geocodePosition1(marker.getPosition());
        //updateMarkerPosition(marker.getPosition());
    });

    google.maps.event.addListener(marker, 'dragend', function () {
        updateMarkerStatus('Drag ended');
        geocodePosition(marker.getPosition());
    });
    mapLoad = true;
}

// Onload handler to fire off the app.
//google.maps.event.addDomListener(window, 'load', initialize);
