(function() {
  var ptpApp;

  ptpApp = angular.module('ptpApp', ['ngRoute', 'geolocation']);

  ptpApp.controller('MainCtrl', [
    '$scope', '$http', 'geolocation', function($scope, $http, geolocation) {
      var i, latTab, lngTab;
      latTab = [];
      lngTab = [];
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
          var featuresOpts, iconUrl, input, mapOptions, marker, markerIcon, searchBox;
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
            marker = new google.maps.Marker({
              position: new google.maps.LatLng(latTab[i], lngTab[i]),
              icon: markerIcon,
              map: $scope.map
            });
            i++;
          }
          input = document.getElementById('searchbox-input');
          searchBox = new google.maps.places.SearchBox(input);
          console.log('hello');
          return google.maps.event.addListener(searchBox, "places_changed", function() {
            var bounds, places;
            console.log('hello');
            places = searchBox.getPlaces();
            bounds = new google.maps.LatLngBounds();
            
				for (var i = 0, place; place = places[i]; i++) {
					bounds.extend(place.geometry.location);
				}
				;
            console.log('hello');
            console.log('places');
            $scope.map.fitBounds(bounds);
            return $scope.map.setZomm(15);
          });
        });
      });
    }
  ]);

  ptpApp.controller('BarDetailCtrl', [
    '$scope', '$routeParams', '$rootScope', '$http', function($scope, $routeParams, $rootScope, $http) {
      return $http.get('bars.json').success(function(data) {
        var bar, currentLoc, featuresOpts, iconUrl, mapOptions, marker, markerIcon, _i, _len, _results;
        iconUrl = 'http://payetapinte.fr/assets/img/icons/marker.png';
        markerIcon = new google.maps.MarkerImage(iconUrl, null, null, null, new google.maps.Size(34, 44));
        _results = [];
        for (_i = 0, _len = data.length; _i < _len; _i++) {
          bar = data[_i];
          if (parseInt(bar.id) === parseInt($routeParams.barId)) {
            $scope.bar = bar;
            currentLoc = new google.maps.LatLng(bar.latitude, bar.longitude);
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
              zoom: 15,
              center: currentLoc,
              mapTypeId: google.maps.MapTypeId.ROAD,
              styles: featuresOpts,
              panControl: false,
              zoomControl: false,
              mapTypeControl: false,
              scaleControl: false,
              streetViewControl: false,
              overviewMapControl: false
            };
            $scope.map = new google.maps.Map(document.getElementById('map-bar'), mapOptions);
            _results.push(marker = new google.maps.Marker({
              position: currentLoc,
              icon: markerIcon,
              map: $scope.map
            }));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      });
    }
  ]);

  ptpApp.config([
    '$routeProvider', function($routeProvider) {
      return $routeProvider.when('/bars', {
        templateUrl: 'partials/bars.html',
        controller: 'MainCtrl'
      }).when('/bars/:barId', {
        templateUrl: 'partials/bar-detail.html',
        controller: 'BarDetailCtrl'
      }).otherwise({
        redirectTo: '/bars'
      });
    }
  ]);

}).call(this);

//# sourceMappingURL=main.js.map
