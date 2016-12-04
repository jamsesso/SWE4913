import Html exposing (Html, div, button, text)
import Html.App
import Html.Events exposing (onClick)

-- Model
type alias Model = Int

-- Init
init : (Model, Cmd Msg)
init = (0, Cmd.none)

-- Update
type Msg = Increment | Decrement | Reset

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Increment -> (model + 1, Cmd.none)
    Decrement -> (model - 1, Cmd.none)
    Reset -> init

-- View
view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , text (toString model)
    , button [ onClick Increment ] [ text "+" ]
    , button [ onClick Reset ] [ text "Reset" ]
    ]

-- Subscriptions (we'll talk about this in the next section)
subscriptions : Model -> Sub Msg
subscriptions model = Sub.none -- We have no subscriptions yet!

-- Tie it all together
main : Program Never
main = Html.App.program { init = init
                        , view = view
                        , update = update
                        , subscriptions = subscriptions
                        }
