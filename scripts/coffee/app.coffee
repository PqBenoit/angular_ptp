payetapinteApp = angular.module('payetapinteApp', ['ngRoute', 'ngAnimate', 'geolocation'])

payetapinteApp.controller 'MainCtrl', ['$scope', '$http', 'geolocation', '$routeParams', '$rootScope',($scope, $http, geolocation, $routeParams, $rootScope) ->

	latTab = []
	lngTab = []
	markers = []
	distance = []
	i = 0

	$scope.centerMap = (bar) ->
		new google.maps.LatLng(bar.lattitude, bar.longitude)
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

			iconUrl = '../www/img/picker.png'

			markerIcon =
				new google.maps.MarkerImage(
					iconUrl, null, null, null, new google.maps.Size(34, 44)
				)

			while i < $scope.bars.length
				markers[i] = 
					new google.maps.Marker(
						position: new google.maps.LatLng(latTab[i], lngTab[i])
						icon: markerIcon
						map: $scope.map
					)
				$scope.bars[i].distance = getDistanceFromLatLonInKm(data.coords.latitude, data.coords.longitude, latTab[i], lngTab[i])
				i++

			$scope.distances = distance

			i = 0

			while i < markers.length
				marker = markers[i]
				google.maps.event.addListener marker, "click", ->
					$scope.map.panTo this.getPosition()
				i++


			# google.maps.event.addListener markers[1], "click", ->
			# 	while i < markers.length
			# 		$scope.map.panTo markers[i].getPosition()
			# 		i++

			# i = 0
			# bounds = new google.maps.LatLngBounds()

			# while i < markers.length
			# 	console.log markers[i].getPosition()
			# 	i++

			# $scope.map.fitBounds(bounds)
			
			$('.bar-item').click ->
				lat = $('.bar-item').attr("data-lat")
				console.log lat

			userMarker =
				new google.maps.Marker(
					position: new google.maps.LatLng(data.coords.latitude, data.coords.longitude)
					icon: 'http://payetapinte.fr/assets/img/icons/userMarker.png'
					animation: google.maps.Animation.DROP
					map: $scope.map
				)

			google.maps.event.addListener userMarker, "click", ->
				$scope.map.panTo userMarker.getPosition()

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

	$scope.class = 'list-down'

	$scope.changeListClass = ->
		if $scope.class == 'list-up'
			$scope.class = 'list-down'
		else
			$scope.class = 'list-up'


	getDistanceFromLatLonInKm = (lat1, lon1, lat2, lon2) ->
		R = 6371
		dLat = deg2rad(lat2 - lat1)
		dLon = deg2rad(lon2 - lon1)
		a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.sin(dLon / 2) * Math.sin(dLon / 2)
		c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
		d = R * c * 1000
		parseInt(d)

	deg2rad = (deg) ->
		deg * (Math.PI / 180)

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