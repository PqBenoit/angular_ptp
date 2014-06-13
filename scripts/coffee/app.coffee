payetapinteApp = angular.module('payetapinteApp', ['ngRoute', 'ngAnimate', 'geolocation'])

payetapinteApp.controller 'MainCtrl', ['$scope', '$http', 'geolocation', '$routeParams', '$rootScope',($scope, $http, geolocation, $routeParams, $rootScope) ->

	latTab = []
	lngTab = []
	markers = []
	distance = []
	infoWindow = []
	$scope.shortName = []
	i = 0

	$http.get('bars.json').success((data) ->
		$scope.bars = data

		while i < data.length
			latTab[i] = data[i].latitude
			lngTab[i] = data[i].longitude
			
			if $scope.bars[i].name.length >= 23
				$scope.bars[i].name = $scope.bars[i].name.substring(0, 20) + '...'
			else
				$scope.bars[i].name = $scope.bars[i].name

			console.log $scope.shortName[i]
			
			infoWindow[i] =
				new InfoBubble (
						content: data[i].name
					)
			i++

		i = 0

		geolocation.getLocation().then (data) ->
			$scope.coords =
				lat:data.coords.latitude
				lng:data.coords.longitude

			featuresOpts = [
				{
					"featureType": "road",
					"elementType": "labels.text.stroke",
					"stylers": [
						{ "visibility": "on" },
						{ "color": "#ffffff" }
					]
				},{
					"featureType": "water",
					"stylers": [
						{ "visibility": "on" },
						{ "color": "#73b6e6" }
					]
				},{
					"featureType": "road.highway",
					"stylers": [
						{ "visibility": "on" },
						{ "color": "#ffffff" }
					]
				},{
					"featureType": "poi",
					"stylers": [
						{ "visibility": "simplified" }
					]
				},{
					"featureType": "road",
					"elementType": "labels.text.fill",
					"stylers": [
						{ "visibility": "on" },
						{ "color": "#808080" }
					]
				},{
					"elementType": "labels.text.stroke",
					"stylers": [
						{ "visibility": "on" },
						{ "color": "#ffffff" }
					]
				},{
					"elementType": "labels.icon",
					"stylers": [
						{ "visibility": "off" }
					]
				},{
					"elementType": "labels.text.fill",
					"stylers": [
						{ "color": "#808080" },
						{ "visibility": "on" },
						{ "weight": 0.9 }
					]
				},{
					"featureType": "landscape.natural",
					"stylers": [
						{ "visibility": "on" },
						{ "color": "#c8df9f" }
					]
				},
				{
					"featureType": "landscape",
					"stylers": [
						{ "visibility": "on" },
						{ "color": "#e8e0d8" }
					]
				}
			]

			mapOptions =
				zoom: 13
				center: new google.maps.LatLng(data.coords.latitude, data.coords.longitude)
				mapTypeId: google.maps.MapTypeId.ROAD
				styles: featuresOpts
				panControl: false
				zoomControl: false
				mapTypeControl: false
				scaleControl: false
				streetViewControl: false
				overviewMapControl: false

			$scope.map = new google.maps.Map(document.getElementById('map'), mapOptions)

			iconUrl = 'https://dl.dropboxusercontent.com/u/107483353/assets/picker%402x.png'

			markerIcon =
				new google.maps.MarkerImage(
					iconUrl, null, null, null, new google.maps.Size(34, 44)
				)

			while i < $scope.bars.length

				if getDistanceFromLatLonInKm(data.coords.latitude, data.coords.longitude, latTab[i], lngTab[i]) > 1000
					$scope.bars[i].distance = Number((getDistanceFromLatLonInKm(data.coords.latitude, data.coords.longitude, latTab[i], lngTab[i]) / 1000).toFixed(1)).toString() + " km"
				else
					$scope.bars[i].distance = (getDistanceFromLatLonInKm(data.coords.latitude, data.coords.longitude, latTab[i], lngTab[i])).toString() + " m"

				markers[i] = 
					new google.maps.Marker (
						position: new google.maps.LatLng(latTab[i], lngTab[i])
						icon: markerIcon
						map: $scope.map
						name: $scope.bars[i].name
						price: $scope.bars[i].price
						address: $scope.bars[i].address
						distance: $scope.bars[i].distance
					)

				i++

			i = 0

			infowindow = new InfoBubble()

			while i < markers.length
				marker = markers[i]
				google.maps.event.addListener marker, "click", ->

					if this.name.length >= 15 
						this.name = (this.name).substring(0, 15) + '...'
					else
						this.name = this.name

					$scope.map.panTo this.getPosition()
					infowindow.close
					content = 
						'<div id="window-container">
							<div id="price-div">
								<span id="price">' + this.price + '€</span>
							</div>
							<div id="details">
								<div id="vertical">
									<p id="name">' + this.name + '</p>
									<p id="address">à ' + this.distance + ' - ' + this.address.split(",")[0] + '</p>
								</div>
							</div>
							<div id="arrow">
								<p id="img"><img src="https://dl.dropboxusercontent.com/u/107483353/assets/arrow%402x.png" width="9" height="13"></p>
							</div>
						</div>'
					infowindow.setMinHeight(30)
					infowindow.setMaxHeight(50)
					infowindow.setMinWidth(220)
					infowindow.setMaxWidth(220)
					# infowindow.setBackgroundColor("transparent")
					infowindow.setContent(content)
					infowindow.open($scope.map, this)
				i++

			userMarker =
				new google.maps.Marker (
					position: new google.maps.LatLng(data.coords.latitude, data.coords.longitude)
					icon: 'https://dl.dropboxusercontent.com/u/107483353/assets/location%402x18x18.png'
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
				$scope.map.setZoom(13)

			$scope.centerMap = () ->
				$scope.map.panTo userMarker.getPosition()

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