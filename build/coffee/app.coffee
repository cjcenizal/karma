window.TF = TF = angular.module "TF", []

# HOME.

TF.controller "HomeController", [
  "$http"
  "$scope"
  ($http, $scope) ->

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

]

