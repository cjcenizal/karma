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
  "$attrs"
  (
    $http
    $scope
    $location
    $window
    $attrs
  ) ->

    payload = JSON.parse $attrs.homeJson
    user    = payload.user

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

    $scope.signOut = (url) ->
      $http
        method: "DELETE"
        url: url
      .success (data, status, headers, config) ->
        $window.location = "/"
      , (data, status, headers, config) ->
        console.error "sign out error", data, status, headers, config

    $scope.goToNote = (noteId) ->
      $window.location = "/note/#{noteId}"

    $scope.goToSettings = ->
      $window.location = "/users/#{user._id}/edit"

]

# SETTINGS CONTROLLER.

TF.controller "SettingsController", [
  "$http"
  "$scope"
  "$location"
  "$window"
  "$attrs"
  (
    $http
    $scope
    $location
    $window
    $attrs
  ) ->

    $scope.goToHome = ->
      $window.location = "/"

]

# NOTE CONTROLLER.

TF.controller "NoteController", [
  "$scope"
  "$attrs"
  "$http"
  "$window"
  "$location"
  (
    $scope
    $attrs
    $http
    $window
    $location
  ) ->

    payload    = JSON.parse $attrs.notesJson
    notes      = payload.notes
    collection = payload.collection
    config     = payload.config
    user       = payload.user

    # TEST DATA.
    notes.push _.clone(notes[0])
    notes[1].note_index = 1
    notes[1]._id = "a"
    notes.push _.clone(notes[0])
    notes[2].note_index = 2
    notes[2]._id = "b"

    console.log notes

    $scope.state =
      hasPreviousNote:       false
      hasNextNote:           false
      isNextNoteTheSendForm: false
      showSendForm:            false
      isSendingNote:         false
      isSendNoteSuccess:     false
      isSendNoteError:       false

    $scope.currentNote = null

    # View API.

    $scope.showPreviousNote = ->
      if $scope.state.showSendForm
        hideSendForm()
      else
        showNoteAtIndex $scope.currentNote.note_index - 1

    $scope.showNextNote = ->
      if $scope.state.isNextNoteTheSendForm
        showSendForm()
      else
        showNoteAtIndex $scope.currentNote.note_index + 1

    $scope.sendNote = ->
      sendData = {}
      $scope.state.isSendingNote = true
      $http
        method: "POST"
        url:    "/prelaunch_signups"
        data:   sendData
      .success (data, status, headers, config) ->
        $scope.state.isSendingNote    = false
        $scope.state.isSendNoteSuccess = true
      , (data, status, headers, config) ->
        $scope.state.isSendingNote   = false
        $scope.state.isSendNoteError = true

    $scope.goToHome = ->
      $window.location = "/"

    # Internal.

    showNoteAtIndex = (index) ->
      if getNoteAtIndex index
        $scope.currentNote = getNoteAtIndex index
        console.log "assign note", index, $scope.currentNote
        updateButtonStates()
        $location.path "/#{$scope.currentNote._id}"

    showNoteWithId = (id) ->
      note = getNoteWithId id
      return showNoteAtIndex note?.note_index

    hideSendForm = ->
      console.log "hide send"
      $scope.state.showSendForm = false
      updateButtonStates()

    showSendForm = ->
      console.log "show send"
      $scope.state.showSendForm = true
      updateButtonStates()

    updateButtonStates = ->
      $scope.state.hasPreviousNote = getNoteAtIndex $scope.currentNote.note_index - 1
      $scope.state.hasNextNote = getNoteAtIndex $scope.currentNote.note_index + 1
      $scope.state.isNextNoteTheSendForm =
        not $scope.state.hasNextNote and
        not $scope.state.showSendForm and
        $scope.currentNote.user_receiver_id is user._id
    
    getNoteAtIndex = (index) ->
      return notes[index]

    getNoteWithId = (id) ->
      _.find notes, (note) -> note._id is id

    # Init.
    do ->
      noteId = $location.path().replace("/", "")
      return if noteId? and showNoteWithId noteId
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