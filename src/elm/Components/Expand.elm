module Components.Expand exposing (..)

import Html exposing (button, div, text)
import Markdown

expand showing content =
  if showing then
    div []
      [ button [] [ text "Hide Solution" ]
      , Markdown.toHtml [] content
      ]
  else
    button [] [ text "Show Solution" ]
