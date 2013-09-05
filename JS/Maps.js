var map, markers = [], mycenter;
// var lat = 28.6100;
//var lng = 77.2300;

var lat = "<%=lat%>";
var lng = "<%=lng%>";
var zoom1 = parseInt("<%=zoomcs%>",10);


mycenter = new google.maps.LatLng(lat, lng);

        

function initialize()
{
    var mapOptions = {
        center: mycenter,
        zoom: zoom1,
        zoomControl: true,
        mapTypeControl: false,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };

    map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
    google.maps.event.addListener(map, 'click', function (event) {    placeMarker(event.latLng);     });
}

function placeMarker(location)
{

    clearOverlays();
    var marker = new google.maps.Marker({
        position: location,
        map: map,
    });
    markers.push(marker);
    var infowindow = new google.maps.InfoWindow({     content: 'Latitude: ' + location.lat() + '<br>Longitude: ' + location.lng()     });
    infowindow.open(map, marker);
}

function setAllMap(map) {
    for (var i = 0; i < markers.length; i++) {
        markers[i].setMap(map);
    }
}

function clearOverlays() {
    setAllMap(null);
}

google.maps.event.addDomListener(window, 'load', initialize);
