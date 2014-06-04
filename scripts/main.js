(function() {
  var payetapinteApp;

  payetapinteApp = angular.module('payetapinteApp', ['ngRoute', 'ngAnimate', 'geolocation']);

  payetapinteApp.controller('MainCtrl', [
    '$scope', '$http', 'geolocation', '$routeParams', '$rootScope', function($scope, $http, geolocation, $routeParams, $rootScope) {
      var deg2rad, distance, getDistanceFromLatLonInKm, i, latTab, lngTab, markers;
      latTab = [];
      lngTab = [];
      markers = [];
      distance = [];
      i = 0;
      $scope.centerMap = function(bar) {
        return new google.maps.LatLng(bar.lattitude, bar.longitude);
      };
      return $http.get('bars.json').success(function(data) {
        $scope.bars = data;
        while (i < data.length) {
          latTab[i] = data[i].latitude;
          lngTab[i] = data[i].longitude;
          i++;
        }
        i = 0;
        return geolocation.getLocation().then(function(data) {
          var featuresOpts, iconUrl, input, mapOptions, marker, markerIcon, searchBox, userMarker;
          $scope.coords = {
            lat: data.coords.latitude,
            lng: data.coords.longitude
          };
          featuresOpts = [
            {
              featureType: "water",
              stylers: [
                {
                  color: "#8bc6fd"
                }
              ]
            }, {
              featureType: "landscape",
              stylers: [
                {
                  color: "#ffffff"
                }
              ]
            }
          ];
          mapOptions = {
            zoom: 14,
            center: new google.maps.LatLng(data.coords.latitude, data.coords.longitude),
            mapTypeId: google.maps.MapTypeId.TERRAIN,
            styles: featuresOpts,
            panControl: false,
            zoomControl: false,
            mapTypeControl: false,
            scaleControl: false,
            streetViewControl: false,
            overviewMapControl: false
          };
          $scope.map = new google.maps.Map(document.getElementById('map'), mapOptions);
          iconUrl = '../www/img/picker.png';
          markerIcon = new google.maps.MarkerImage(iconUrl, null, null, null, new google.maps.Size(34, 44));
          while (i < $scope.bars.length) {
            markers[i] = new google.maps.Marker({
              position: new google.maps.LatLng(latTab[i], lngTab[i]),
              icon: markerIcon,
              map: $scope.map
            });
            $scope.bars[i].distance = getDistanceFromLatLonInKm(data.coords.latitude, data.coords.longitude, latTab[i], lngTab[i]);
            i++;
          }
          $scope.distances = distance;
          i = 0;
          while (i < markers.length) {
            marker = markers[i];
            google.maps.event.addListener(marker, "click", function() {
              return $scope.map.panTo(this.getPosition());
            });
            i++;
          }
          $('.bar-item').click(function() {
            var lat;
            lat = $('.bar-item').attr("data-lat");
            return console.log(lat);
          });
          userMarker = new google.maps.Marker({
            position: new google.maps.LatLng(data.coords.latitude, data.coords.longitude),
            icon: 'http://payetapinte.fr/assets/img/icons/userMarker.png',
            animation: google.maps.Animation.DROP,
            map: $scope.map
          });
          google.maps.event.addListener(userMarker, "click", function() {
            return $scope.map.panTo(userMarker.getPosition());
          });
          input = document.getElementById('searchbox-input');
          searchBox = new google.maps.places.SearchBox(input);
          return google.maps.event.addListener(searchBox, "places_changed", function() {
            var bounds, places;
            places = searchBox.getPlaces();
            bounds = new google.maps.LatLngBounds();
            
				for (var i = 0, place; place = places[i]; i++) {
					bounds.extend(place.geometry.location);
				}
				;
            return $scope.map.fitBounds(bounds);
          });
        });
      }, $scope["class"] = 'list-down', $scope.changeListClass = function() {
        if ($scope["class"] === 'list-up') {
          return $scope["class"] = 'list-down';
        } else {
          return $scope["class"] = 'list-up';
        }
      }, getDistanceFromLatLonInKm = function(lat1, lon1, lat2, lon2) {
        var R, a, c, d, dLat, dLon;
        R = 6371;
        dLat = deg2rad(lat2 - lat1);
        dLon = deg2rad(lon2 - lon1);
        a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
        c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        d = R * c * 1000;
        return parseInt(d);
      }, deg2rad = function(deg) {
        return deg * (Math.PI / 180);
      });
    }
  ]);

}).call(this);

//# sourceMappingURL=main.js.map
