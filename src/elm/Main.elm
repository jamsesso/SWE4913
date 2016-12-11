import Html exposing (Html, article)
import Html.Attributes exposing (href)
import Util exposing (..)

main : Html a
main = article [] [ markdown intro ]

intro : String
intro = """
# Functionally Reactive User Interfaces

*Functionally Reactive User Interfaces* is a set of tutorials and exercises meant to introduce a typical UNB undergraduate student to the benefits of developing user interfaces (UIs) in a functionally reactive way. These tutorials and exercises were completed as an independent project by [Sam Jesso](https://twitter.com/jamsesso) for [SWE4913](http://www.unb.ca/academics/calendar/undergraduate/current/frederictoncourses/softwareengineering/swe-4913.html) at the [University of New Brunswick](http://www.unb.ca/)

## Table of Contents

1. [What is Functional Reactive Programming?](./tutorial1.html)
2. [An Introduction to Elm](./tutorial2.html)
3. [The Elm Architecture](./tutorial3.html)
4. [Asynchronous Behaviour in Elm](./tutorial4.html)

## The Pitch

In 2016, the Software Engineering department made the decision to drop the *Programming Languages (CS3613)* course from the core requirements for the Software Engineering degree for all incoming students. CS3613 is the only course available at UNB that has students dive into functional programming using [Typed Racket](https://docs.racket-lang.org/ts-guide/). As this course was not required for the Computer Science degree and was more theoretical, the logic behind removing the course requirement may have been that it could be replaced with something more practical.

To be blunt, I disagree with the department's decision. Though theoretical, CS3613 has the potential to alter the way that students approach software development. In my opinion, CS3613 was among the most valuable learning experiences I had. If you look at the landscape of Software Engineering today, you'll see functional programming language concepts making their way out of acedemia and into the industry. Examples are Java 8 with it's `Stream` and other new asychronously driven APIs, as well as the increasingly important language Javascript.

Having talked with faculty and students, it seems that some students are not fans of CS3613 - though I found the course to be fun and engaging, others found it complicated and diverged from practical application. However, it is not the time to ignore these ideas, rather it is time to embrace them and perhaps teach them in different ways. This project is meant to start the development of an experimental alternative approach to introducing functional programming to undergraduate students (at approximately the second year level).

#### Procedurally Doubling Numbers in a List

```java
List<Integer> nums = Arrays.asList(1, 2, 3);
List<Integer> doubled = new ArrayList<>();

for(int i = 0; i < nums.length; i++) {
  doubled.add(nums.get(i) * 2);
}
```

#### Functionally Doubling Numbers in a List

```java
List<Integer> nums = Arrays.asList(1, 2, 3);
List<Integer> doubled = nums.stream().map(x -> x * 2).collect(toList());
```

## How is this Different than other Tutorials?

These tutorials are the result of combining a number of online tutorials, examples, and some open source code in order to (hopefully) create a comprehensive mini-course to get a student using functional programming concepts and ideas in order to complete the exercises presented in this series. Many (if not all) of the tutorials online do not incorporate exercises for the reader.

As I mentioned above, these tutorials are also meant to be read by a typical UNB undergraduate SWE or CS student at approximately the second year level. This series does not assume that the reader has had any prior exposure to functional programming or any of the tooling available to get started. It aims to be a gentle yet practical introduction.

None of this is to say that this tutorial set is in any way *better* or *more comprehensive* than other tutorials - it is a starting point for experiementing with new ways to teach this material. I would strongly encourage any student to experiment beyond the material presented in this series.

## Experiences with Elm

These tutorials use [Elm](http://elm-lang.org/) language. Elm is a relatively young functional language built for the web which made it a great candidate for introducing students to functional programming with an immediately practical application - building web apps. It was also of my personal interest to learn the language.

### Upsides

For a pre-1.0 language, the tooling for running simple applications is good. The `elm-repl` and `elm-reactor` packages are great tools for quick sanity-checks and low fidelity prototyping. Elm also has some of the best compile time error messages I have ever seen, a wonderful feature for beginners.

Above all, the biggest reason that Elm was selected for this project was it's embedded framework for building applications called *the Elm Architecture*. Without the hassle of dealing with projects environments or dependencies, a programmer can very quickly set up a **functionally reactive** application with Elm doing all of the heavy lifting. With the boilerplate taken care of by the built-in libraries of the language itself, it allows me to focus on concepts and content.

### Downsides

During the course of writing these tutorials, a new version of Elm (0.18) was released. Elm is relatively new and the language designers are experimenting with different ways to do things. Because of this, the APIs are relatively unstable and backwards compatibility is not of great importance. These tutorials are only guaranteed to be compatible with **Elm 0.17**.

Another downside is that while Elm advertises itself as a language without runtime exceptions, I found that not to be the case. There were several occasions where the compiler would successfully build the code, but I would be presented with a blank webpage only to find Javascript errors in the developer console. These errors are difficult to solve because they are related to the Javascript code that was produced by the compiler, and not by the code you had directly written. Source maps might help to solve this issue, but I am not aware of any source map tooling available for Elm.

The final downside to Elm is, though the out-of-the-box tools like the REPL and Reactor are great, tools and tutorials for putting together real applications are scarce. The tutorial set (including this page) are written in Elm, and setting up the environment to build these tutorials was frustruating to say the least.

### The Final Verdict

I do believe that Elm was a good choice to introduce functional and reactive programming concepts to students. However, I wouldn't use the language to build production/enterprise-level applications until the language becomes more stable, the tooling improves, and the documentation gets better.

## Challenges

I faced two major challenges while working on this project. The first challenge was succinctly defining functional programming. I found reactive programming to be a much easier concept to explain. With reactive programming, it was easy to show examples related to procedural programming, but describing functional programming was not as easy. Using words like *declarative*, *immutable*, or *pure* are not beginner friendly and don't describe the benefits of functional programming.

The second issue was coming up with exercises for the reader. Coming up with an exercise to challenge the user to consider what they've learned while simultaneously keeping the task at a level that is understandable to a beginner is more difficult than it seems. This might simply be a symptom of choosing Elm as the language for this project as a fair amount of background information is required in order to get even simple programs running.
"""
