module Tutorial3 exposing (tutorial)

import Html exposing (article, text)
import Components.Expand exposing (expand)
import Markdown

tutorial = article []
  [ Markdown.toHtml [] content
  ]

content = """
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

As mentioned above, Elm does all of the work when it comes to tying our model, view, and update function together to create a functioning application.
"""
