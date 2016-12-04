import Html exposing (Html, article)
import Markdown

main : Html a
main = article [] [ Markdown.toHtml [] content ]

content : String
content = """
# What is Functional Reactive Programming?

This series is meant to teach a typically object-oriented programmer how to develop graphical user interface (UI) applications in a functional reactive way, while demonstrating the benefits of doing so. The background assumed for the series is…

- Familiarity with C-like syntax and languages such as Java.
- Some experience developing UIs using procedural/object-oriented languages.

I'd like to begin this series by dissecting it's very name. Much like the dissection of the keywords involved in the `main` method in our introductory Java courses. The goal of this series is to guide traditionally procedural or object-oriented programmers towards both functional and reactive, and a combination thereof, thinking.

So, what is functional reactive programming? In the simplest terms possible, it is a combination of both functional and reactive programming. Normally, this means using functional programming to achieve reactive programming. Not a great explanation if you don’t know what functional or reactive programming are, so let's dive into each one.

## Reactive Programming

I’ll start with reactive programming as it is much easier to describe. In fact, there aren't any practical reactive programming environments for production systems available. The easiest way to describe reactive programming is to consider how changes to data in our program effect other data in our program. If you come from a procedural or object-oriented background, what do you expect the output of the following program to be?

```cpp
int m = 2;
int x = 3;
int b = 1;
int y = m * x + b;
printf("y = %d\\n", y);
b++;
printf("y = %d\\n", y);
```

If you answered `y = 7`, followed by `y = 7`, you’d be correct. However, in a reactive programming environment, the output might be `y = 7`, followed by `y = 8`.

With the traditional model of program execution, how can we achieve the output of `y = 7` followed by `y = 8`? Consider defining `y` as a function. Because functions can be evaluated at different points in time, it's evaluation will give a result that implicitly considers time when running.

```cpp
int m = 2;
int x = 3;
int b = 1;

int y() {
  return m * x + b;
}

printf("y = %d\\n", y());
b++;
printf("y = %d\\n", y());
```

### The Microsoft Excel Analogy

The best analogy I’ve found that demonstrates the concept of reactive programming is the Microsoft Excel analogy. It explains that the value of a cell `A` in Excel can depend on the value of another cell `B`. When cell `B` is updated, the value in cell `A` will also be updated. Let’s try our calculation in Excel.

![Excel GIF](./static/img/excel.gif)

As we expect, our value of `y` is initially 7. When the value of `b` is incremented, the value of `y` is updated as a result. In other words, `y` reacted to a change in `b`. If you think of each cell as a function of the other cells (Cell `B4` in this case being a function of cells `B1`, `B2`, and `B3` or `B4(B1, B2, B3) = B1() * B2() + B3()` in this case) then you can see how the reactive environment is achieved at a conceptual level in Excel.

## Functional Programming

Functional programming is a style of programming based heavily on mathematics. In the ideal functional programming environment, every value is constant, also known as immutable, meaning that it doesn't change (unlike a variable in procedural programs) and every function is pure meaning that a function only ever returns a single value for a combination of argument values.

To better understand pure functions, consider a function `add(x, y)`. Our `add(x, y)` function takes two numbers and adds them together, thus `add(x, y)` is pure: `add(5, 6)` will always be 11. Now consider a random number generator such as `rand()` in C. Random number generators are inherently impure as they always return a different value.
It's difficult to define, and a lot to take in, but the big things to remember are:

- Keep your functions pure.
- Don’t change data, create new data.

### Side Effects

*Side effects* are things that happen inside of a function that modify some external state or interact with components outside of the scope of the function. Things like IO and networking are side effects (yes, that means even logging is a side effect!). If your function has a side effect it means that the function is impure because it's output depends on the external world. For example, if we consider logging as a side effect, the `log` function might write your debugging statements to a file, `stdout`, or to some socket (such as over a JTAG connection when debugging remote devices). This external influence on the function makes it impure.

### First Class Functions

One of the most important concepts of functional programming is first-class functions. You know about int, char, byte, float, and others. In a functional environment, functions are also values that can be passed around as arguments, or even returned from other functions, just as an int might be, for example. Consider the following C-like program:

```cpp
int multiplyBy2(int x) {
  return x * 2;
}

int[] map(int[] list, function operation) {
  int[] result;
  for(int i = 0; i < length(list); i++) {
    result[i] = operation(list[i]);
  }
  return result;
}

int[] numbers = {1, 2, 3};
int[] doubled = map(numbers, multiplyBy2);

// Content of doubled is 2, 4, 6
```

The majority should look pretty familiar. There is a `multiplyBy2` function that takes some integer, and returns twice the value of that integer. The next function, map, looks almost normal except for the second parameter: function operation. The idea is that we can pass the operation (being a function) that we want to apply to each element in the array. Let’s look at what this program might look like in a functional language like Elm:

```elm
multiplyBy2 x = x * 2
numbers = [1, 2, 3]
doubled = List.map multiplyBy2 numbers

-- Content of doubled is 2, 4, 6
```

### Currying & Partial Application

Another important concept is known as currying. A curried function is typically a version of a function that, instead of accepting n arguments, returns a function that accepts the next argument until n calls are completed. Let’s see an example in our hypothetical C-like language:

```cpp
string greet(string greeting, string name) {
  return sprintf("%s, %s!", greeting, name);
}

function curriedGreet(string greeting) {
  string greet(string name) {
    return sprintf("%s, %s!", greeting, name);
  }
  return greet;
}

printf("%s\\n", greet("Hello", "Sam")); // Non-curried greet function.
printf("%s\\n", curriedGreet("Hello")("Sam")); // A curried greeting.

function sayHello = curriedGreet("Hello"); // Partially applying curriedGreet.

printf("%s\\n", sayHello("Sam")); // Completing the application.
```

Let’s tear down our `curriedGreet` function. Instead of accepting 2 parameters like our `greet` function, it accepts the first parameter and returns a function that accepts the second parameter. This allows us to perform partial application of the function.

Why is this important? Because in many functional programming languages (such as Elm), functions are curried by default and can therefore by partially applied. Try to grasp this Elm program that uses partial application:

```elm
multiplyBy2 x = x * 2
multiplyAllBy2 = List.map multiplyBy2
numbers = [1, 2, 3]
doubled = multiplyAllBy2 numbers
```

## Functional Reactive Programming

At this point you have an understanding of both functional and reactive programming, so how can we combine these concepts? This is a question that we will investigate and discuss throughout this series.

It turns out that FRP is very useful in the development of user interfaces. You can see this with the proliferation of languages like Elm and frameworks like React, both of which provide the programmer with an FRP interface for developing user interfaces. How exactly are these frameworks different from other UI frameworks? It comes from their functional background in immutable data structures. Instead of mutating the objects in the view in response to a user interaction or data change, these frameworks present the programmer with an API that redraws the entire view, treating the view as an immutable data structure. Under the covers, these frameworks don’t actually redraw the entire view on every state change, rather they abstract the mutable details from the programmer.

Modelling a UI in a reactive manor has many benefits. First, your UI becomes a function of your application state: `UI = f(state)` where `f` is your rendering logic. Second, the programmer need only describe the UI for any given state and not worry about mutating objects on the view leading to indeterminate states in the UI. Third, each object in your view is simply a function so you can compose simple functions to create complex UIs. Finally, because your UI can be expressed as a pure function, unit testing your UI becomes trivial  - no need for mocking or other complicated unit testing patterns that are common in object oriented UI development (such as MVC).

## Elm

This series will use the Elm language exclusively to demonstrate FRP concepts in the context of UI development. Elm is a language that compiles into Javascript, and is targeted at building web UIs. 
Before starting the subsequent tutorials, make sure you have Elm installed on your computer. Resources and guides can be found at http://elm-lang.org/
"""
