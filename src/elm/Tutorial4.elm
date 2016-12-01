import Html exposing (article)
import Markdown

main = article []
  [ Markdown.toHtml [] p1
  ]

p1 = """
# Asynchronous Behaviour in Elm

Asynchronous programming, regardless of the application, is the concept of submitting some work to be performed elsewhere, and being notified when the work has been completed. It's very common in UI development, as UIs usually communicate with some backend.

## Side Effects & Elm Commands

*Side effects* are things that happen inside of a function that modify some external state or interact with components outside of the scope of the function. Things like IO and networking are side effects. Because asynchronous programs inherently produce side effects, meaning that our functions are impure, we need a way to model such side effects. It's not that side effects are *bad*, it is just common to see side effects mismanaged in programs.

Elm has a way of modelling side effects created by functions called **commands**. A command can be thought of as an intention to modify the state of the Elm program, as commands are handled by the `update` function that we're already familiar with. In fact, you've already seen commands in action when you handled events produced by your view in the previous tutorial.

As the application programmer, you don't generally synthesize your own commands. Commands are typically created and dispatched internally by Elm. The only interaction with commands you'll use directly is the `Cmd.none` value to indicate that no command is being performed.

## Subscriptions

Subscriptions are the basis of asynchronous Elm programs. Subscriptions connect an Elm program to events that are generated asynchronously.
"""
