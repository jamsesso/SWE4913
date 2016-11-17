module Tutorial2 exposing (tutorial)

import Html exposing (article)
import Components.Expand exposing (expand)
import Markdown

tutorial = article []
  [ Markdown.toHtml [] p1
  , expand True soln1
  , Markdown.toHtml [] p2
  , expand True soln2
  , Markdown.toHtml [] p3
  , expand True soln3
  , Markdown.toHtml [] p4
  , expand True soln4
  ]

p1 = """
# An Introduction to Elm

Elm is a relatively new programming language meant for building web applications. It interfaces with Javascript but focuses on bringing functional reactive programming to UI development. Remember, our overall goal is to define our application UI as a function of our application state.

Before we can dive into building functionally reactive interfaces, we need to understand the tools we're working with. This tutorial will introduce the Elm language to the reader.

## Primitive Types

This section should be pretty familiar. Launch `elm-repl` in your terminal to follow along. Elm, like every language, distinguishes data by types. Primitive types are those that are built into the language. In Java, primitive types are `int`, `char`, `byte`, `boolean`, etc...

Elm has many of those same primitives that we can see while using the REPL:

```elm
> 1
1 : number

> 1.2
1.2 : Float

> "Hello!"
"Hello!" : String

> \\x -> x + 1
<function> : number -> number

> 'a'
'a' : Char

> True
True : Bool

> False
False : Bool

> [1, 2, 3, 4]
[1,2,3,4] : List number
```

In Elm, a `number` represents either an `Int` or `Float`. We'll talk more about the function notation `\\x -> x + 1` in the next section.

## Constants

Constants are quite easily defined in Elm and are cannot be changed. (Note: In the REPL, values can be changed) Attempting to modify the value of a constant will cause the compiler to throw an error notifying you that it cannot be done.

```elm
> x = 1
1 : number

> x
1 : number
```

In Elm, you can also add types to your variable definitions. If you leave the type out, Elm will infer what type it should be. Even though Elm may not always look it, it is a statically typed language.

```elm
x : Int
x = 4
```

## Lists

An important data structure in Elm, a `List` is akin to arrays in other langauges. Lists, like arrays in many other languages, can only contain elements of the same type. There are a number of utility functions built into the language used to traverse and manipulate lists. I won't go over the whole API, but it is important to be aware of lists.

You can find more information at http://package.elm-lang.org/packages/elm-lang/core/1.0.0/List

## Named & Anonymous Functions

As mentioned in the last tutorial, functions are first class values in Elm. Here's how we would define a function to repeat a string `n` times.

```elm
repeat s n =
  if n == 1 then
    s
  else
    s ++ repeat s (n-1)
```

You can define the `repeat` function in the Elm REPL in the following way:

```elm
> repeat s n = \\
|  if n == 1 then \\
|    s \\
|  else \\
|    s ++ repeat s (n-1) \\
<function> : appendable -> number -> appendable

> repeat "lol" 10
"lollollollollollollollollollol" : String
```
What exactly is going on with the function type `<function> : appendable -> number -> appendable`? This is thanks to Elm's type inference. Because we haven't specified a type, Elm does it's best to infer what types could be used. In this case, the `++` operator is used for concatenation just like `+` is used for concatenation in Java. The difference here is that Elm allows concatenation on any type declared `appendable`.

Just as defining types on constants, we can define the type of a function as well. In this case, I wanted to only repeat strings. Also consider that it is not possible to repeat a string 2.3 times.

**Your turn:** try adding a type definition to the repeat function so that the first parameter is a `String`, the second parameter is an `Int`, and the return value is also a `String`.
"""

soln1 = """
```elm
repeat : String -> Int -> String
repeat s n =
  if n == 1 then
    s
  else
    s ++ repeat s (n-1)
```
"""

p2 = """
The `repeat` function is known as a named function because it can be referenced by name. Elm has the concept of anonymous functions which cannot be referenced by name. Such functions are useful in one-off use cases.

### Anonymous Functions

Anonymous functions are simply functions without a name. Let's take a look:

```elm
> \\x -> x + 1
<function> : number -> number

> (\\x -> x + 1) 6
7 : number
```

Don't get too hung up on the syntax. `\\` identifies that the following expression is an anonymous function. Next comes the list of parameters that our function accepts, in this case `x`. `->` signifies the beginning of the function body. Finally, we return `x + 1`.

**Your turn:** define and call an anonymous function that accepts two parameters and returns their sum.
"""

soln2 = """
```elm
(\\a b -> a + b) 1 2
```
"""

p3 = """
**Your turn:** To wrap up this section on functions, define a function called `factorial` that calculates the factorial of a given number. Add a type definition to your function to restrict input to `Int`s.
"""

soln3 = """
```elm
factorial : Int -> Int
factorial n =
  if n == 0 then
    1
  else
    n * factorial (n-1)
```
"""

p4 = """
## Records

Records are another important data structure in Elm, and as you'll see, are used heavily. They're like `struct`s in C. Records are a set of key-value pairs, much like the `Map` data structure in Java. Unlike Java, the values don't have to be the same type.

```elm
> me = { name = "Sam", age = 22 }
{ name = "Sam", age = 22 } : { age : number, name : String }

> me.name
"Sam" : String

> me.age
22 : number
```

Records are not modified, you can only create new records. Because it would be cumbersome to copy each key-value pair to a new record when you want to update a single value, Elm offers the pipe operator `|` that can be used to create new records based on old ones.

```elm
> older = { me | age = 30 }
{ name = "Sam", age = 30 } : { name : String, age : number }

> older.name
"Sam" : String

> older.age
30 : number

> me.age
22 : number
```

Notice how we didn't update the record values in `me`, we created an entirely new record `older` with a new value for `age`.

## Type Aliases

Records are great, but what if we want to create a number of records with the same structure? Type aliases allow us to do that. We just define each key's type and assign it to a special identifier called a type alias. It makes our code more condense and easier to read.

```elm
> type alias Person = { name : String, age : Int }

> me = Person "Sam" 22
{ name = "Sam", age = 22 } : Person

> me.name
"Sam" : String

> me.age
22 : Int
```

Our type alias also allows us to shorten our type definitions as well. You can think of a type alias as a substitution for the type definition.

```elm
-- Without type aliases
greet : { name : String, age : Int } -> String
greet p = "Hello " ++ p.name ++ "! You are " ++ (toString p.age) ++ " years old."

-- With type aliases
type alias Person = { name : String, age : Int }
greet : Person -> String
greet p = "Hello " ++ p.name ++ "! You are " ++ (toString p.age) ++ " years old."
```

Finally, you can also type alias non-record data types in Elm such as `type alias MyBooleanAlias = Bool`

## Types

Types are a bit more complicated because they introduce the idea of symbols. All you'll need to understand about symbols is that they are just like strings except they don't require quotations. Symbols allow you to essentially define your own keywords in Elm. Let's see an example:

```elm
type Language = English | French

getGreeting : Language -> String
getGreeting lang =
  case lang of
    English -> "Hello"
    French -> "Bonjour"
```

We can now use our `getGreeting` function as:

```elm
> getGreeting English
"Hello" : String

> getGreeting French
"Bonjour" : String
```

Types might remind you of `enum`s from languages like Java. They are very similar to an enum.

## The `main` Function

Like many other languages, the entry point to your programs are through a function called `main`. Because Elm is a web application language, it works on HTML. This means that your `main` function has to return HTML, not `void`, not `Int`, or anything else.

The most basic HTML element available in Elm is the `text` element. `text` represents an element on the page that contains, as you might guess, text. A "hello world" Elm program would look something like:

```elm
import Html exposing (text)

main = text "Hello, world!"
```

### Imports

Imports are a new concept, so let's break it down. `import Html exposing (text)` is going to import the `Html` module - which is built into the language. Importing means that the functions defined by that module are available for us to use. The `Html` module is quite large, and we're only interested in using the `text` function, so we add `exposing (text)` to our `import` statement. To import all functions from the `Html` module, we would do `import Html exposing (..)`. To import the `Html` module without interferring with the current namespace, we could simply `import Html` and call `Html.text "Hello, world!"` instead of `text "Hello, world!"`.

**Your turn**: Using the documentation at http://package.elm-lang.org/packages/elm-lang/html/latest/ create a main function (with a type definition) that returns a `div` containing an `h1` title containing the text "Hello world" and a `button` containing the text "Click me!". *Hint*: You can use `elm-reactor` to view your application in a web browser.
"""

soln4 = """
```elm
import Html exposing (Html, div, button, h1, text)

main : Html a
main =
  div []
    [ h1 [] [ text "Hello world" ]
    , button [] [ text "Click me!" ]
    ]
```
"""
