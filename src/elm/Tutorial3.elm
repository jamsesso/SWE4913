import Html exposing (Html, article, text)
import Html.App as App
import Array exposing (Array)
import Components.Expand exposing (expand)
import Util exposing (..)

main : Program Never
main = App.beginnerProgram { model = model
                           , view = view
                           , update = update
                           }

-- Model
type alias Model = Array Bool

model : Model
model = Array.fromList [False]

-- Update
type Msg = ToggleSoln Int

update : Msg -> Model -> Model
update msg model =
  let
    nextValue : Int -> Bool
    nextValue soln = not (getOrDefault soln model True)
  in
    case msg of
      ToggleSoln soln -> Array.set soln (nextValue soln) model

-- View
solnExpander : Model -> Int -> String -> Html Msg
solnExpander model i soln =
  expand (ToggleSoln i) (getOrDefault i model False) soln

view : Model -> Html Msg
view model = article []
  [ markdown p1
  , solnExpander model 0 soln
  , markdown p2
  ]

p1 : String
p1 = """
# The Elm Architecture

The Elm architecture is the main selling point of the Elm language. Though it is not required that you use it, the Elm architecture is a highly opinionated way of organizing data and UI components in your application that is supported out of the box - no special frameworks or libraries to install.

## What is the Elm Architecture?

The Elm architecture is a way of expressing the UI components in your application, the state of your application, and each state change that can occur in your application in a structured way. Elm programs typically involve 3 things:

- **Model**: Typically a record object (but not required) that contains the state of the entire application. Refer to tutorial 2 for a refresher on records if needed. It's not required to define your model as a record, however it is beneficial to do so because it makes tracking more state easier in the future.
- **View**: The buttons, headers, paragraphs, forms, etc... that are displayed on the screen. In Elm, these are simply functions that accept the current state and return `Html`.
- **Update** function: The update function accepts 2 arguments (the current state and a message) and returns the new state. It's signature is always of the form `update : Msg -> Model -> Model` where `Msg` is some indication of what is being changed in the state, and `Model` is the model record.

Elm comes with modules that glue these 3 pieces of your application together for you, as we'll see.

## Your First Elm Application

Let's dive in an create our first Elm application. Our application will be a simple counter. Initially set to 0, there will be a increment and decrement button that updates the counter and a reset button that sets the value back to 0.

### Model

Let's first consider our model. What do we need to keep track of? For this application, it's pretty easy. All we need to keep track of is the count. Let's create our model in Elm:

```elm
type alias Model = Int
model : Model
model = 0
```

Notice how our `Model` type is just an alias for an `Int` and isn't a record. Remember, the model doesn't have to be a record - it can be any type.

### Update

Next, let's consider our update function. This function is supposed to accept the current state and a message that tells the function how to update the state. Putting that in the context of our counter application, we know that our state is just a counter and that a user can perform specific actions on that counter. What actions can a user perform? They could increment, decrement and reset the counter. Our update function, then, will just be a function that can do all of those things. Let's create our update function in Elm:

```elm
type Msg = Increment | Decrement | Reset

update : Msg -> Model -> Model
update msg model =
  if msg == Increment then
    model + 1
  else if msg == Decrement then
    model - 1
  else
    0
```

Having a large `if` statement is not the common pattern you'll find if you look at other Elm programs. Usually the `update` function is written using a `case` statement. I'll rewrite the `update` function above using `case` instead - make sure you understand how the two are related.

```elm
type Msg = Increment | Decrement | Reset

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment -> model + 1
    Decrement -> model - 1
    Reset -> 0
```

### View

Lastly, we need to create our view. Our `view` function will have the following type definition: `view : Model -> Html Msg` (remember we defined `Msg` in the update section). This type definition means that we're returning `Html` that can produce `Msg`s. `Msg`s will be produced when we interact with the application; in our case when we click the buttons.

```elm
import Html exposing (Html, div, button, text)
import Html.Events exposing (onClick)

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , text (toString model)
    , button [ onClick Increment ] [ text "+" ]
    , button [ onClick Reset ] [ text "Reset" ]
    ]
```

### Tying Everything Together

As mentioned above, Elm does all of the work when it comes to tying our model, view, and update function together to create a functioning application. Inside of the `Html.App` package are 2 functions: `Html.App.program` and `Html.App.beginnerProgram`. As you might imagine, `beginnerProgram` is a version of `program` that makes opinionated decisions about your application in order to make setup easier. We are going to use `beginnerProgram` to demonstrate tying your application together.

```elm
import Html exposing (Html, div, button, text)
import Html.Events exposing (onClick)

-- Model
type alias Model = Int
model : Model
model = 0

-- Update
type Msg = Increment | Decrement | Reset

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment -> model + 1
    Decrement -> model - 1
    Reset -> 0

-- View
view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , text (toString model)
    , button [ onClick Increment ] [ text "+" ]
    , button [ onClick Reset ] [ text "Reset" ]
    ]

-- Tie it all together
main = Html.App.beginnerProgram { model = model
                                , view = view
                                , update = update
                                }
```

Using `elm-reactor`, we get the following output:

![Counter example GIF](./static/img/counter-example.gif)

## Your Turn

Before we wrap up this tutorial, it's your turn to build an application on your own using Elm. Here are the requirements:

- Display a text input that the user can type into.
- Display the reverse value of the input as the user types.
- If the value of the input is a palindrome, display "That's a palindrome!"
- Display the total number of distinct palindromes found by the user.

Here's some Elm documentation to help you out:

- `input`: http://package.elm-lang.org/packages/evancz/elm-html/4.0.2/Html#input
- The `onInput` event: http://package.elm-lang.org/packages/elm-lang/html/1.1.0/Html-Events#onInput
- `Set` data structure: http://package.elm-lang.org/packages/elm-lang/core/5.0.0/Set

*Hint*: You can use the following function to determine if a `String` is a palindrome:

```elm
isPalindrome : String -> Bool
isPalindrome s = String.length s >= 2 && String.reverse s == s
```
"""

soln : String
soln = """
```elm
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
```
"""

p2 : String
p2 = """
## Functionally Reactive UI

Reflect for a moment on what we've built in this tutorial. We've constructed 2 different UI applications. Do you notice anything about the way we've constructed these applications?

If you remember the first tutorial, our ultimate goal was to model our UI as a function of our application state: `UI = f(state)`. Have we accomplished that using Elm?

Consider our type definiton on the function that renders our UI: `view : Model -> Html Msg`. That type definition satisfies our goal! Our state is the input, and our UI is the output. The only difference is that our UI produces *side-effects* called *events* when the user interacts with the UI (such as `onClick` and `onInput`).

Using Elm, we've successfully modelled our UI in a functionally reactive way. That is, we've described *what* the UI should do, not *how* the UI should be constructed and modified. We describe the state, actions that can be performed on the state, and our UI; Elm takes care of re-rendering the UI everytime the state changes. This is similar to how Microsoft Excel takes care of re-calculating dependent cells when others are updated. You might also see this style of programming referred to as *declarative* programming (what) as opposed to traditional, Java style *imperative* programming (how).
"""
