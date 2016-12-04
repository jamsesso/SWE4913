import Html exposing (Html, div)
import Html.App
import Html.Attributes exposing (style)
import Keyboard exposing (KeyCode)

main : Program Never
main = Html.App.program { init = init
                        , update = update
                        , subscriptions = subscriptions
                        , view = view
                        }

-- Update
type Msg = KeyPress KeyCode

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let
    (x, y) = model
  in
    case msg of
      KeyPress keycode ->
        case keycode of
          37 -> ((x - 1, y), Cmd.none) -- Left
          38 -> ((x, y - 1), Cmd.none) -- Up
          39 -> ((x + 1, y), Cmd.none) -- Right
          40 -> ((x, y + 1), Cmd.none) -- Down
          _  -> (model, Cmd.none) -- Ignore all other key presses

-- Model
type alias Model = (Int, Int)

-- Init
init : (Model, Cmd Msg)
init = ((0, 0), Cmd.none)

-- Subscriptions
subscriptions : Model -> Sub Msg
subscriptions model = Keyboard.downs KeyPress

-- View
view : Model -> Html Msg
view model =
  let
    (x, y) = model
    pos = style [ ("backgroundColor", "blue")
                , ("width", "10px")
                , ("height", "10px")
                , ("position", "fixed")
                , ("top", toString y ++ "px")
                , ("left", toString x ++ "px")
                ]
  in
    div [ pos ] []
