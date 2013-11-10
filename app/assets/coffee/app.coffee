window.TF = TF = angular.module "TF", []

# FILTERS.

TF.filter "true", ->
  return (boolean, value) ->
    if boolean
      return value
    return ""

TF.filter "false", ->
  return (boolean, value) ->
    if !boolean
      return value
    return ""

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

    payload    = JSON.parse $attrs.notesJson
    notes      = payload.notes
    collection = payload.collection
    config     = payload.config
    user       = payload.user

    # TEST DATA.
    notes.push _.clone(notes[0])
    notes[1].note_index = 1
    notes.push _.clone(notes[0])
    notes[2].note_index = 2

    console.log notes

    $scope.state =
      hasPreviousNote: false
      hasNextNote: false
      isNextNoteTheSendForm: false
      isSendForm: false

    $scope.currentNote = null

    $scope.showPreviousNote = ->
      if $scope.state.isSendForm
        hideSendForm()
      else
        showNoteAtIndex $scope.currentNote.note_index - 1

    $scope.showNextNote = ->
      if $scope.state.isNextNoteTheSendForm
        showSendForm()
      else
        showNoteAtIndex $scope.currentNote.note_index + 1

    showNoteAtIndex = (index) ->
      if getNoteAtIndex index
        $scope.currentNote = getNoteAtIndex index
        console.log "assign note", index, $scope.currentNote
        updateButtonStates()

    hideSendForm = ->
      console.log "hide send"
      $scope.state.isSendForm = false
      updateButtonStates()

    showSendForm = ->
      console.log "show send"
      $scope.state.isSendForm = true
      updateButtonStates()

    updateButtonStates = ->
      $scope.state.hasPreviousNote = getNoteAtIndex $scope.currentNote.note_index - 1
      $scope.state.hasNextNote = getNoteAtIndex $scope.currentNote.note_index + 1
      $scope.state.isNextNoteTheSendForm =
        not $scope.state.hasNextNote and
        not $scope.state.isSendForm and
        $scope.currentNote.user_receiver_id is user._id
    
    getNoteAtIndex = (index) ->
      return notes[index]

    # Init.
    showNoteAtIndex config.default_note_index

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