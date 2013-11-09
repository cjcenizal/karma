window.Neon = Neon = angular.module "Neon", []
Neon.controller "RootController", [
  "$http"
  "$scope"
  ($http, $scope) ->

    retinafy = (path) ->
      if window.devicePixelRatio > 1
        pieces = path.split "."
        return pieces.join "_@2X."
      return path

    prependPath = (filename) ->
      return "http://cdn.neon-lab.com/website/carousel/#{filename}"

    $scope.carouselSlides = [
        title:    "We explore the digital world through images."
        subtitle: "Neon connects images with people."
        image:    prependPath retinafy "horses.jpg"
      ,
        title:    "Images influence how we respond to content."
        subtitle: "Neon images drive traffic."
        image:    prependPath retinafy "fashion.jpg"
      ,
        title:    "Individuals see the world differently."
        subtitle: "Neon selects the best image for your target audience."
        image:    prependPath retinafy "football.jpg"
    ]
    
    $scope.videoDemos = [
        name:     "Media video"
        title:    "These sample thumbnails were auto-selected from real videos."
        subtitle: "Neon for Video works for a wide range of video types."
        prompt:   "Watch the story of travelers in Malaysia"
        images:   [
          retinafy "images/video-demos/malaysia-1.jpg"
          retinafy "images/video-demos/malaysia-2.jpg"
          retinafy "images/video-demos/malaysia-3.jpg"
        ]
        video:  "Malaysia"
      ,
        name:     "Product video"
        title:    "A 60-second video contains 1,800 possible thumbnails."
        subtitle: "Neon for Video picks for you."
        prompt:   "Watch the \"LittleBits\" instructional video"
        images:   [
          retinafy "images/video-demos/littlebits-1.jpg"
          retinafy "images/video-demos/littlebits-2.jpg"
          retinafy "images/video-demos/littlebits-3.jpg"
        ]
        video:  "LittleBits"
      ,
        name:     "Advertisement video"
        title:    "The thumbnail is the gateway to your content."
        subtitle: "Capture more video views with better thumbnails."
        prompt:   "Watch the \"Bluetooth Dice\" ad video"
        images:   [
          retinafy "images/video-demos/dice-1.jpg"
          retinafy "images/video-demos/dice-2.jpg"
          retinafy "images/video-demos/dice-3.jpg"
        ]
        video:  "BluetoothDice"
    ]

    $scope.scrollToSignUpForm = ->
      pos = angular.element("#js-signup").offset().top + "px"
      angular.element("body, html").animate {scrollTop: pos}, "slow"

    $scope.signupFields =
      name:  null
      email: null

    $scope.isSubmittingSignup        = false
    $scope.isSignupSubmissionError   = false
    $scope.isSignupSubmissionSuccess = false

    $scope.submitSignupForm = ->
      $scope.isSubmittingSignup = true
      $http
        method: "POST"
        url:    "/prelaunch_signups"
        data:   $scope.signupFields
      .success (data, status, headers, config) ->
        $scope.isSubmittingSignup        = false
        $scope.isSignupSubmissionSuccess = true
      ,
      (data, status, headers, config) ->
        $scope.isSubmittingSignup      = false
        $scope.isSignupSubmissionError = true
]
