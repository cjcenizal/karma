window.TF = TF = angular.module "TF", []

# HOME CONTROLLER.

TF.controller "HomeController", [
  "$http"
  "$scope"
  "$location"
  "$window"
  (
    $http
    $scope
    $location
    $window
  ) ->

    COLORS =
      PURPLE:  "#8857f9"
      VIOLET:  "#b439b9"
      MAGENTA: "#f95d7e"
      ORANGE:  "#f97b43"
      GOLD:    "#f9b627"
      GREEN:   "#c0f927"
      TEAL:    "#5ff992"
      CYAN:    "#45cdf9"
      BLUE:    "#448df9"

    $scope.colors = [
      COLORS.PURPLE,
      COLORS.VIOLET,
      COLORS.MAGENTA,
      COLORS.ORANGE,
      COLORS.GOLD,
      COLORS.GREEN,
      COLORS.TEAL,
      COLORS.CYAN,
      COLORS.BLUE
    ]

    $scope.goToNote = (noteId) ->\
      $window.location = "/notes/#{noteId}"

]

# NOTE CONTROLLER.

TF.controller "NoteController", [
  "$scope"
  "$attrs"
  (
    $scope
    $attrs
  ) ->


    notes = $attrs.dataNotes

    currentNoteIndex = null

    $scope.showPreviousNote = ->
      showNoteAtIndex currentNoteIndex - 1

    $scope.showNextNote = ->
      showNoteAtIndex currentNoteIndex + 1

    currentNoteIndex = (index) ->
      if index >= 0 and index < notes.length
        currentNoteIndex = index
    
]

# MAP DIRECTIVE.

TF.directive "tfMap", [
  "$timeout"
  ($timeout) ->

    link: (scope, element, attrs) ->
      
      mapOptions =
        center: new google.maps.LatLng -34.397, 150.644
        zoom: 8
        disableDefaultUI: true
        scrollwheel: false
        draggable: false
        mapTypeId: google.maps.MapTypeId.ROADMAP

      map = new google.maps.Map element[0], mapOptions

]