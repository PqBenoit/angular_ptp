payetapinteApp = angular.module('payetapinteApp', ['ngRoute', 'ngAnimate', 'geolocation'])

payetapinteApp.controller 'MainCtrl', ['$scope', '$http', 'geolocation', '$routeParams', '$rootScope',($scope, $http, geolocation, $routeParams, $rootScope) ->

	latTab = []
	lngTab = []
	i = 0

	$http.get('bars.json').success((data) ->
		$scope.bars = data

		while i < data.length
			latTab[i] = data[i].latitude
			lngTab[i] = data[i].longitude
			i++

		i = 0

		geolocation.getLocation().then (data) ->
			$scope.coords =
				lat:data.coords.latitude
				lng:data.coords.longitude

			featuresOpts = [
				{
					featureType: "water"
					stylers: [color: "#8bc6fd"]
				}
				{
					featureType: "landscape"
					stylers: [
						color: "#ffffff"
					]
				}
			]

			mapOptions =
				zoom: 14
				center: new google.maps.LatLng(data.coords.latitude, data.coords.longitude)
				mapTypeId: google.maps.MapTypeId.TERRAIN
				styles: featuresOpts
				panControl: false
				zoomControl: false
				mapTypeControl: false
				scaleControl: false
				streetViewControl: false
				overviewMapControl: false

			$scope.map = new google.maps.Map(document.getElementById('map'), mapOptions)

			iconUrl = 'http://payetapinte.fr/assets/img/icons/marker.png'

			markerIcon =
				new google.maps.MarkerImage(
					iconUrl, null, null, null, new google.maps.Size(34, 44)
				)

			while i < $scope.bars.length
				marker = 
					new google.maps.Marker(
						position: new google.maps.LatLng(latTab[i], lngTab[i])
						icon: markerIcon
						map: $scope.map
				)
				i++

			input = document.getElementById('searchbox-input')

			searchBox = new google.maps.places.SearchBox(input)

			google.maps.event.addListener searchBox, "places_changed", ->
				places = searchBox.getPlaces()
				bounds = new google.maps.LatLngBounds()

				`
				for (var i = 0, place; place = places[i]; i++) {
					bounds.extend(place.geometry.location);
				}
				`

				$scope.map.fitBounds(bounds)
				$scope.map.setZomm(15)

		# for bar in data
		# 	if parseInt(bar.id) == parseInt($routeParams.barId)
		# 		$scope.bar = bar

		# console.log bar

	$scope.class = 'list-down'

	$scope.changeListClass = ->
		if $scope.class == 'list-up'
			$scope.class = 'list-down'
		else
			$scope.class = 'list-up'
	)
]

# payetapinteApp.controller 'BarListCtrl', ['$scope', '$http', ($scope, $http) ->

# 	$scope.pageClass = 'page-barlist'
# 	$http.get('bars.json').success((data) ->
# 		$scope.bars = data
# 	)
# ]
# ptpApp = angular.module('ptpApp', ['ngRoute', 'geolocation'])

# ptpApp.controller 'MainCtrl', ['$scope', '$http', 'geolocation', ($scope, $http, geolocation) ->

# 	latTab = []
# 	lngTab = []
# 	i = 0

# 	$http.get('bars.json').success((data) ->
# 		$scope.bars = data

# 		while i < data.length
# 			latTab[i] = data[i].latitude
# 			lngTab[i] = data[i].longitude
# 			i++

# 		i = 0

# 		geolocation.getLocation().then (data) ->
# 			$scope.coords =
# 				lat:data.coords.latitude
# 				lng:data.coords.longitude

# 			featuresOpts = [
# 				{
# 					featureType: "water"
# 					stylers: [color: "#8bc6fd"]
# 				}
# 				{
# 					featureType: "landscape"
# 					stylers: [
# 						color: "#ffffff"
# 					]
# 				}
# 			]

# 			mapOptions =
# 				zoom: 14
# 				center: new google.maps.LatLng(data.coords.latitude, data.coords.longitude)
# 				mapTypeId: google.maps.MapTypeId.TERRAIN
# 				styles: featuresOpts
# 				panControl: false
# 				zoomControl: false
# 				mapTypeControl: false
# 				scaleControl: false
# 				streetViewControl: false
# 				overviewMapControl: false

# 			$scope.map = new google.maps.Map(document.getElementById('map'), mapOptions)

# 			iconUrl = 'http://payetapinte.fr/assets/img/icons/marker.png'

# 			markerIcon =
# 				new google.maps.MarkerImage(
# 					iconUrl, null, null, null, new google.maps.Size(34, 44)
# 				)

# 			while i < $scope.bars.length
# 				marker = 
# 					new google.maps.Marker(
# 						position: new google.maps.LatLng(latTab[i], lngTab[i])
# 						icon: markerIcon
# 						map: $scope.map
# 				)
# 				i++

# 			input = document.getElementById('searchbox-input')

# 			searchBox = new google.maps.places.SearchBox(input)

# 			console.log 'hello'

# 			google.maps.event.addListener searchBox, "places_changed", ->
# 				console.log 'hello'
# 				places = searchBox.getPlaces()
# 				bounds = new google.maps.LatLngBounds()

# 				`
# 				for (var i = 0, place; place = places[i]; i++) {
# 					bounds.extend(place.geometry.location);
# 				}
# 				`

# 				console.log 'hello'
# 				console.log 'places'

# 				$scope.map.fitBounds(bounds)
# 				$scope.map.setZomm(15)
# 	)
# ]


# payetapinteApp.controller 'BarDetailCtrl', ['$scope', '$routeParams', '$rootScope', '$http', ($scope, $routeParams, $rootScope, $http) ->
# 	$http.get('bars.json').success((data) ->

# 		# iconUrl = 'http://payetapinte.fr/assets/img/icons/marker.png'

# 		# markerIcon =
# 		# 	new google.maps.MarkerImage(
# 		# 		iconUrl, null, null, null, new google.maps.Size(34, 44)
# 		# 	)

		# for bar in data
		# 	if parseInt(bar.id) == parseInt($routeParams.barId)
		# 		$scope.bar = bar 
# 				# currentLoc = new google.maps.LatLng(bar.latitude, bar.longitude)

# 				# featuresOpts = [
# 				# 	{
# 				# 		featureType: "water"
# 				# 		stylers: [color: "#8bc6fd"]
# 				# 	}
# 				# 	{
# 				# 		featureType: "landscape"
# 				# 		stylers: [
# 				# 			color: "#ffffff"
# 				# 		]
# 				# 	}
# 				# ]

# 				# mapOptions =
# 				# 	zoom: 15
# 				# 	center: currentLoc
# 				# 	mapTypeId: google.maps.MapTypeId.ROAD
# 				# 	styles: featuresOpts
# 				# 	panControl: false
# 				# 	zoomControl: false
# 				# 	mapTypeControl: false
# 				# 	scaleControl: false
# 				# 	streetViewControl: false
# 				# 	overviewMapControl: false

# 				# $scope.map = new google.maps.Map(document.getElementById('map-bar'), mapOptions)

# 				# marker = 
# 				# 	new google.maps.Marker(
# 				# 		position: currentLoc
# 				# 		icon: markerIcon
# 				# 		map: $scope.map
# 				# 	)
# 	)
# ]

# payetapinteApp.config ['$routeProvider',
# 	($routeProvider) ->
# 		$routeProvider.when('/',
# 			templateUrl: 'partials/home.html'
# 			controller: 'MainCtrl'
# 			).when('/:barId',
# 				templateUrl: 'partials/bars.html'
# 				controller: 'BarDetailCtrl'
# 			)
# ]

# ptpApp.config ['$routeProvider',
# 	($routeProvider) ->
# 		$routeProvider.when('/bars',
# 			templateUrl: 'partials/bars.html'
# 			controller: 'MainCtrl'
#  		).when('/bars/:barId',
# 			templateUrl: 'partials/bar-detail.html'
# 			controller: 'BarDetailCtrl'
# 		).otherwise redirectTo: '/bars'
# ]