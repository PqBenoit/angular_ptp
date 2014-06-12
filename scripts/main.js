(function() {
  var payetapinteApp;

  payetapinteApp = angular.module('payetapinteApp', ['ngRoute', 'ngAnimate', 'geolocation']);

  payetapinteApp.controller('MainCtrl', [
    '$scope', '$http', 'geolocation', '$routeParams', '$rootScope', function($scope, $http, geolocation, $routeParams, $rootScope) {
      var deg2rad, distance, getDistanceFromLatLonInKm, i, infoWindow, latTab, lngTab, markers;
      latTab = [];
      lngTab = [];
      markers = [];
      distance = [];
      infoWindow = [];
      i = 0;
      return $http.get('bars.json').success(function(data) {
        $scope.bars = data;
        while (i < data.length) {
          latTab[i] = data[i].latitude;
          lngTab[i] = data[i].longitude;
          infoWindow[i] = new google.maps.InfoWindow({
            content: data[i].name
          });
          i++;
        }
        i = 0;
        return geolocation.getLocation().then(function(data) {
          var featuresOpts, iconUrl, infowindow, input, mapOptions, marker, markerIcon, searchBox, userMarker;
          $scope.coords = {
            lat: data.coords.latitude,
            lng: data.coords.longitude
          };
          featuresOpts = [
            {
              "featureType": "road",
              "elementType": "labels.text.stroke",
              "stylers": [
                {
                  "visibility": "on"
                }, {
                  "color": "#ffffff"
                }
              ]
            }, {
              "featureType": "water",
              "stylers": [
                {
                  "visibility": "on"
                }, {
                  "color": "#73b6e6"
                }
              ]
            }, {
              "featureType": "road.highway",
              "stylers": [
                {
                  "visibility": "on"
                }, {
                  "color": "#ffffff"
                }
              ]
            }, {
              "featureType": "poi",
              "stylers": [
                {
                  "visibility": "simplified"
                }
              ]
            }, {
              "featureType": "road",
              "elementType": "labels.text.fill",
              "stylers": [
                {
                  "visibility": "on"
                }, {
                  "color": "#808080"
                }
              ]
            }, {
              "elementType": "labels.text.stroke",
              "stylers": [
                {
                  "visibility": "on"
                }, {
                  "color": "#ffffff"
                }
              ]
            }, {
              "elementType": "labels.icon",
              "stylers": [
                {
                  "visibility": "off"
                }
              ]
            }, {
              "elementType": "labels.text.fill",
              "stylers": [
                {
                  "color": "#808080"
                }, {
                  "visibility": "on"
                }, {
                  "weight": 0.9
                }
              ]
            }, {
              "featureType": "landscape.natural",
              "stylers": [
                {
                  "visibility": "on"
                }, {
                  "color": "#c8df9f"
                }
              ]
            }, {
              "featureType": "landscape",
              "stylers": [
                {
                  "visibility": "on"
                }, {
                  "color": "#e8e0d8"
                }
              ]
            }
          ];
          mapOptions = {
            zoom: 14,
            center: new google.maps.LatLng(data.coords.latitude, data.coords.longitude),
            mapTypeId: google.maps.MapTypeId.ROAD,
            styles: featuresOpts,
            panControl: false,
            zoomControl: false,
            mapTypeControl: false,
            scaleControl: false,
            streetViewControl: false,
            overviewMapControl: false
          };
          $scope.map = new google.maps.Map(document.getElementById('map'), mapOptions);
          iconUrl = 'https://dl.dropboxusercontent.com/u/107483353/assets/picker%402x.png';
          markerIcon = new google.maps.MarkerImage(iconUrl, null, null, null, new google.maps.Size(34, 44));
          while (i < $scope.bars.length) {
            markers[i] = new google.maps.Marker({
              position: new google.maps.LatLng(latTab[i], lngTab[i]),
              icon: markerIcon,
              map: $scope.map,
              name: $scope.bars[i].name,
              price: $scope.bars[i].price,
              address: $scope.bars[i].address
            });
            $scope.bars[i].distance = getDistanceFromLatLonInKm(data.coords.latitude, data.coords.longitude, latTab[i], lngTab[i]);
            i++;
          }
          $scope.distances = distance;
          i = 0;
          infowindow = new google.maps.InfoWindow();
          while (i < markers.length) {
            marker = markers[i];
            google.maps.event.addListener(marker, "click", function() {
              var content;
              $scope.map.panTo(this.getPosition());
              infowindow.close;
              content = '<div id="window-container"> <div id="price-container"> <span>' + this.price + '€</span> </div> <div id="details-container"> <span id="name">' + this.name + '</span></br> <span id="address">foofoofoofoo</span> </div> <div id="window-arrow"> <span> > </span> </div> </div>';
              infowindow.setContent(content);
              return infowindow.open($scope.map, this);
            });
            i++;
          }
          userMarker = new google.maps.Marker({
            position: new google.maps.LatLng(data.coords.latitude, data.coords.longitude),
            icon: 'https://dl.dropboxusercontent.com/u/107483353/assets/location%402x.png',
            animation: google.maps.Animation.DROP,
            map: $scope.map
          });
          google.maps.event.addListener(userMarker, "click", function() {
            return $scope.map.panTo(userMarker.getPosition());
          });
          input = document.getElementById('searchbox-input');
          searchBox = new google.maps.places.SearchBox(input);
          google.maps.event.addListener(searchBox, "places_changed", function() {
            var bounds, places;
            places = searchBox.getPlaces();
            bounds = new google.maps.LatLngBounds();
            
				for (var i = 0, place; place = places[i]; i++) {
					bounds.extend(place.geometry.location);
				}
				;
            return $scope.map.fitBounds(bounds);
          });
          return $scope.centerMap = function() {
            return $scope.map.panTo(userMarker.getPosition());
          };
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
