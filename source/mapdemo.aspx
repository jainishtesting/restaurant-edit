<%@ Page Language="C#" AutoEventWireup="true" CodeFile="mapdemo.aspx.cs" Inherits="mapdemo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=true&libraries=places&key=AIzaSyD62IxHK3Ews3H2fs9Pww97oTLB46t3srs"></script>
    <script type="text/javascript">
        var map;
        var marker;
        var placeSearch, autocomplete;
        var geocoder = new google.maps.Geocoder();

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

        function updateMarkerStatus(str) {
            document.getElementById('markerStatus').innerHTML = str;
        }

        function updateMarkerPosition(latLng) {
            document.getElementById('info').innerHTML = [
              latLng.lat(),
              latLng.lng()
            ].join(', ');
        }

        function updateMarkerAddress(str) {
            document.getElementById('address').innerHTML = str;
        }

        function geocode() {
            var address = document.getElementById("autocomplete").value;
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
                alert("Geocode was not successful for the following reason: " + status);
            }
        }

        function initialize() {
            var latLng = new google.maps.LatLng(-34.397, 150.644);

            autocomplete = new google.maps.places.Autocomplete(document.getElementById('autocomplete'), { types: ['geocode'] });
            google.maps.event.addListener(autocomplete, 'place_changed', function () {
                //fillInAddress();
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
                updateMarkerAddress('Dragging...');
            });

            google.maps.event.addListener(marker, 'drag', function () {
                updateMarkerStatus('Dragging...');
                updateMarkerPosition(marker.getPosition());
            });

            google.maps.event.addListener(marker, 'dragend', function () {
                updateMarkerStatus('Drag ended');
                geocodePosition(marker.getPosition());
            });
        }

        // Onload handler to fire off the app.
        google.maps.event.addDomListener(window, 'load', initialize);
</script>
</head>
<body>
    <style>
        #mapCanvas {
            width: 500px;
            height: 400px;
            float: left;
        }

        #infoPanel {
            float: left;
            margin-left: 10px;
        }

            #infoPanel div {
                margin-bottom: 5px;
            }
    </style>

    Find Place:
    <div id="locationField">
        <input id="autocomplete" placeholder="Enter your address" type="text"></input>
        <input type="button" value="Go" onclick="geocode()">
    </div>
    <div style="height: 25px;"></div>
    <div id="mapCanvas"></div>
    <div id="infoPanel">
        <b>Marker status:</b>
        <div id="markerStatus"><i>Click and drag the marker.</i></div>
        <b>Current position:</b>
        <div id="info"></div>
        <b>Closest matching address:</b>
        <div id="address"></div>
    </div>

</body>
</html>
