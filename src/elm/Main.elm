import Html exposing (Html, text, a, ul, li)
import Html.Attributes exposing (href)

main : Html a
main = ul []
  [ li [] [ a [ href "./tutorial1.html" ] [ text "What is Functional Reactive Programming?" ] ]
  , li [] [ a [ href "./tutorial2.html" ] [ text "An Introduction to Elm" ] ]
  , li [] [ a [ href "./tutorial3.html" ] [ text "The Elm Architecture" ] ]
  ]
