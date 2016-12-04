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
model = Array.fromList [False, False, False, False]

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
  , solnExpander model 0 soln1
  , markdown p2
  , solnExpander model 1 soln2
  , markdown p3
  , solnExpander model 2 soln3
  , markdown p4
  , solnExpander model 3 soln4
  , markdown p5
  ]

p1 : String
p1 = """
# Asynchronous Behaviour in Elm

Asynchronous programming, regardless of the application, is the concept of submitting some work to be performed elsewhere, and being notified when the work has been completed. It's very common in UI development, as UIs usually communicate with some backend.

## Elm Commands

Elm has a way of modelling side effects created by functions called **commands**. A command can be thought of as an intention to modify the state of the Elm program, as commands are handled by the `update` function that we're already familiar with. In fact, you've already seen commands in action when you handled events produced by your view in the previous tutorial.

As the application programmer, you don't generally synthesize your own commands. Commands are typically created and dispatched internally by Elm. The only interaction with commands you'll use directly is the `Cmd.none` value to indicate that no command is being performed. Functions that generate commands declare so in their type definitions, and also name the type of commands that are generated. Typically, commands generate `Msg`s (as we saw in the last tutorial).

### Using Commands in Elm Programs

The first step to using commands in Elm is to use `Html.App.program` rather than `Html.App.beginnerProgram` like we did in the last tutorial. The difference is:

- `program` accepts an `init` value to create the initial model, instead of accepting a `model` value.
- `program` must define the subscriptions that the program has (more on this later).
- The `update` function we write returns `(Model, Cmd Msg)` instead of just `Model`

Here's how we would use `program` to tie together the counter example from the last tutorial:

```elm
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
```

## Subscriptions

Subscriptions are the basis of asynchronous Elm programs. Subscriptions connect an Elm program to events that are generated asynchronously such as mouse clicks, keyboard interactions, or network events. Let's start with an example program that shows you how to use subscriptions step by step.

### Example Application

This example application will place two dots on the screen and allow the user to move one around using the arrow keys on their keyboard - not entirely practical, but a light introduction to subscriptions.

First, let's think about the model. What data do we need to track? How do we initialize the data?

**Your turn**: Try to figure out how you would model the position of the dot on the screen before continuing.
"""

soln1 : String
soln1 = """
```elm
-- Model to track coordinates of the dot.
type alias Model = (Int, Int)

init : (Model, Cmd Msg)
init = ((0, 0), Cmd.none)
```
"""

p2 : String
p2 = """
Second, let's think about the actions that can be performed in our app. What do you think the actions we need to respond to are? How do we write our `update` function to modify our model in response to these actions?

**Your turn**: Try to figure out how you would update your model based on the actions that can be performed.
"""

soln2 : String
soln2 = """
```elm
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
```
"""

p3 : String
p3 = """
As always, we'll also need to create a `view` to draw our dot on the screen at the position defined by our model:

```elm
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
```

We've created the `view`, `update`, and `init` functions. Lastly, we need to define our `subscriptions`. Remember, subscriptions connect asynchronous effects to our application. Our subscription will subscribe to the keyboard `downs` effect (documented here: http://package.elm-lang.org/packages/elm-lang/keyboard/1.0.1/Keyboard#downs).

Notice that the type definition for the `subscriptions` function we need to write is `Model -> Sub msg` and the type definition for `Keyboard.downs` is `(KeyCode -> msg) -> Sub msg` - `Keyboard.downs` will return a subscription for us to use (`Sub`)!

```elm
subscriptions : Model -> Sub Msg
subscriptions model = Keyboard.downs KeyPress
```

What we're telling Elm here is that we want the `KeyPress` action to be fired whenever a key is pressed down on the keyboard. That's all we have to do! Finally, we wire everything together using Elm's `Html.App.program` utility.

**Your turn:** Try tying this application together. *Hint*: here are the `import`s you'll need:

```elm
import Html exposing (Html, div)
import Html.App
import Html.Attributes exposing (style)
import Keyboard exposing (KeyCode)
```
"""

soln3 : String
soln3 = """
```elm
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
```
"""

p4 : String
p4 = """
## Tasks

In Elm, tasks represent units of work that can be *performed* to produce a **result** or an **error**. Additionally, asynchronous tasks do not block the UI - this means that while an expensive asynchronous task is executing, the UI will still respond to interactions from the user (such as mouse clicks, scrolling, keyboard interactions, etc...).

Unlike commands, you can synthesize tasks yourself:

```elm
> Task.succeed 4
<task> : Task a number

> Task.fail "File not found!"
<task> : Task String a
```

We can also `perform` tasks. The type definition for `perform` is `(err -> msg) -> (ok -> msg) -> Task err ok -> Cmd msg`. This might look a little hairy, so let's break it down.

- `(err -> msg)`: A function that is called with the error after the task is performed and produces a `Msg`.
- `(ok -> msg)`: A function that is called with the result after the task is performed and produces a `Msg`.
- `Task err ok`: The task to be performed with variable error type `err` and variable result type `ok`.
- `Cmd msg`: The return value of `Task.perform`. The performed task is handled by a command (meaning we can respond to the task being completed in the `update` function)

### Random Quote Application

To see an example, let's build a simple application that displays a random quote with a button to load a different quote. To do this, we'll use the following web service to provide us with random quotes: http://cors-anywhere.herokuapp.com/http://api.forismatic.com/api/1.0/?method=getQuote&lang=en&format=text

Elm has an `Http` library that can be used to make HTTP requests. We'll use `Http.getString` to load the contents of that webpage. `Http.getString` has the type definition: `String -> Task Http.Error String` - we supply the URL to load, and we get a task that can be executed to actually do that work. Note that a `Task` represents a unit of work, it does not begin executing the work until you say.

### Getting a Quote over HTTP

```elm
type Msg = GotNewQuote String | FailedToGetQuote Http.Error

url : String
url = "http://cors-anywhere.herokuapp.com/http://api.forismatic.com/api/1.0/?method=getQuote&lang=en&format=text"

getNewQuote : Cmd Msg
getNewQuote = Task.perform FailedToGetQuote GotNewQuote (Http.getString url)
```

The `getNewQuote` value is a name we assigned to the logic that performs our task. Performed tasks produce `Cmd`s, so they can be handled by our `update` function. Here, the `FailedToGetQuote Http.Error` message will be passed to `update` if we cannot load the webpage for whatever reason. The `GotNewQuote String` message will be passed to `update` if we successfully load the webpage.

### Model

```elm
type alias Model = { loading : Bool
                   , error : Bool
                   , quote : String
                   }

init : (Model, Cmd Msg)
init = (Model True False "", getNewQuote)
```

Our `init` function doesn't return `Cmd.none` this time. Instead, we immediately call `getNewQuote` so that the task is performed when our application is initialized.

### Update

```elm
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GotNewQuote newQuote -> (Model False False newQuote, Cmd.none)
    FailedToGetQuote _ -> (Model False True "", Cmd.none)
```

This function responds to either the `GotNewQuote` or `FailedToGetQuote` message. If we receive `GotNewQuote`, then the task must have been successful, so we update the quote in our state. If `FailedToGetQuote` is received, then the task must have failed, so we store that in our state so we can notify the user that there was a problem.

### View

```elm
view : Model -> Html Msg
view model =
  if model.loading then
    text "Loading a random quote..."
  else if model.error then
    text "Unable to load a quote! :("
  else
    text model.quote
```

**Your turn**: Tie all of these pieces together to create the application *but* modify it to include a button to load a new quote and a button to retry the task if it fails.
"""

soln4 : String
soln4 = """
```elm
import Html exposing (Html, div, text, button)
import Html.Events exposing (onClick)
import Html.App
import Http
import Task exposing (Task)

main : Program Never
main = Html.App.program { view = view
                        , init = init
                        , subscriptions = \\_ -> Sub.none
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
```
"""

p5 : String
p5 = """
![Random quote example GIF](./static/img/random-quote-example.gif)

## Reacting to Asynchronous Events

To wrap up this final tutorial, let's reflect back to our goal: creating FRP UIs using Elm. In web applications, it's common to deal with asynchronous events. Elm helps the programmer model these events using commands, subscriptions, and tasks.

- Commands tell Elm that you intend to do something.
- Subscriptions tell Elm what external events you want to listen to.
- Tasks represent units of work that can be performed.

If you recall the last tutorial, you were already using the asynchronous features of Elm without realizing it. This tutorial was meant to act as a deep-dive into taking advantage of these features to build richer applications. Most importantly, our UIs stay functionally reactive: the UI is re-rendered (from the programmers point of view) when external events notify the application of changes (subscriptions) and when tasks are performed.
"""
