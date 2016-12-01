import Html exposing (Html, text)
import Html.App as App
import Time exposing (Time)

main : Program Never
main = App.program { init = init
                   , view = view
                   , update = update
                   , subscriptions = subscriptions
                   }

-- Initializer
init : (Model, Cmd Msg)
init = (0, Cmd.none)

-- Model
type alias Model = Int

-- Update
type Msg = TickTock Time

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    TickTock time -> (model + 1, Cmd.none)

-- Subscriptions
subscriptions : Model -> Sub Msg
subscriptions model = Time.every Time.second TickTock

-- View
view : Model -> Html Msg
view model = text (toString model)
