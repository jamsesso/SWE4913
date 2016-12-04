import Html exposing (Html, div, text, button)
import Html.Events exposing (onClick)
import Html.App
import Http
import Task exposing (Task)

main : Program Never
main = Html.App.program { view = view
                        , init = init
                        , subscriptions = \_ -> Sub.none
                        , update = update
                        }

-- Loading a quote
url : String
url = "http://cors-anywhere.herokuapp.com/http://api.forismatic.com/api/1.0/?method=getQuote&lang=en&format=text"

getNewQuote : Cmd Msg
getNewQuote = Task.perform FailedToGetQuote GotNewQuote (Http.getString url)

-- Model
type alias Model = { loading : Bool
                   , error : Bool
                   , quote : String
                   }

init : (Model, Cmd Msg)
init = (Model True False "", getNewQuote)

-- Update
type Msg = GetNewQuote | GotNewQuote String | FailedToGetQuote Http.Error

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GetNewQuote -> init
    GotNewQuote newQuote -> (Model False False newQuote, Cmd.none)
    FailedToGetQuote _ -> (Model False True "", Cmd.none)

-- View
view : Model -> Html Msg
view model =
  if model.loading then
    text "Loading a random quote..."
  else if model.error then
    div []
      [ text "Unable to load a quote! :("
      , div[] [ button [ onClick GetNewQuote ] [ text "Try again" ] ]
      ]
  else
    div []
      [ text model.quote
      , div [] [ button [ onClick GetNewQuote ] [ text "Get another quote!" ] ]
      ]
