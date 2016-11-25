module Util exposing (..)

import Html exposing (Html)
import Array exposing (Array)
import Markdown

getOrDefault : Int -> Array a -> a -> a
getOrDefault i arr def =
  case Array.get i arr of
    Just x -> x
    Nothing -> def

markdown : String -> Html a
markdown paragraph = Markdown.toHtml [] paragraph
