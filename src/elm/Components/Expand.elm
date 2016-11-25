module Components.Expand exposing (..)

import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Markdown

expand : a -> Bool -> String -> Html a
expand click showing content =
  if showing then
    div []
      [ button [ onClick click ] [ text "Hide Solution" ]
      , div [ class "soln" ] [ Markdown.toHtml [] content ]
      ]
  else
    button [ onClick click ] [ text "Show Solution" ]
