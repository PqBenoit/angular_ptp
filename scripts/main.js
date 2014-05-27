(function() {
  var payetapinteApp;

  payetapinteApp = angular.module('payetapinteApp', ['ngRoute', 'ngAnimate', 'geolocation']);

  payetapinteApp.controller('MainCtrl', [
    '$scope', '$http', 'geolocation', '$routeParams', '$rootScope', function($scope, $http, geolocation, $routeParams, $rootScope) {
      var i, latTab, lngTab, markers;
      latTab = [];
      lngTab = [];
      markers = [];
      i = 0;
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
          iconUrl = 'http://payetapinte.fr/assets/img/icons/marker.png';
          markerIcon = new google.maps.MarkerImage(iconUrl, null, null, null, new google.maps.Size(34, 44));
          while (i < $scope.bars.length) {
            markers[i] = new google.maps.Marker({
              position: new google.maps.LatLng(latTab[i], lngTab[i]),
              icon: markerIcon,
              map: $scope.map
            });
            i++;
          }
          i = 0;
          while (i < markers.length) {
            marker = markers[i];
            google.maps.event.addListener(marker, "click", function() {
              return $scope.map.panTo(this.getPosition());
            });
            i++;
          }
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
      });
    }
  ]);

}).call(this);

//# sourceMappingURL=main.js.map
