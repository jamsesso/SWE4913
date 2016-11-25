import Html exposing (Html, div, input, text)
import Html.App
import Html.Events exposing (onInput)
import Html.Attributes exposing (value)
import Set exposing (Set)
import String

-- Model
type alias Model = { value: String, palindromes: Set String }

model : Model
model = Model "" Set.empty

-- Update
type Msg = UpdateValue String

update : Msg -> Model -> Model
update msg model =
  case msg of
    UpdateValue newValue ->
      if isPalindrome newValue then
        { model | value = newValue, palindromes = Set.insert newValue model.palindromes }
      else
        { model | value = newValue }

isPalindrome : String -> Bool
isPalindrome s = String.length s >= 2 && String.reverse s == s

-- View
view : Model -> Html Msg
view model = div []
  [ input
    [ onInput UpdateValue, value model.value ] []
  , div []
    [ text (String.reverse model.value) ]
  , div []
    (if isPalindrome model.value then
      [ text "That's a palindrome!" ]
    else
      [])
  , div []
    [ text ("Palindromes found: " ++ toString (Set.size model.palindromes)) ]
  ]

-- Main
main = Html.App.beginnerProgram { model = model
                                , view = view
                                , update = update
                                }
