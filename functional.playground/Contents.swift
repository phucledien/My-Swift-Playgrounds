/*
 * Ref: https://www.pointfree.co/episodes/ep1-functions
 */

import Foundation

func incr(_ x: Int) -> Int {
    return x + 1
}

incr(2) // 3

func square(_ x: Int) -> Int {
    return x * x
}

square(2) // 4


// Nest call
// Bad: Need to see inside-out
square(incr(2)) // 9

// This is pretty simple, but it’s not very common in Swift.
// Top-level, free functions are generally avoided in favor of methods.

extension Int {
    func incr() -> Int {
        return self + 1
    }
    
    func square() -> Int {
        return self * self
    }
}

2.incr() // 3

// Nice: Read from left-to-right
2.incr().square() // 9

// Introducing |>

//infix operator |>

func |> <A, B>(a: A, f: (A) -> B) -> B {
    return f(a)
}

2 |> incr // 3

// ERROR: 2 |> incr |> square
// Adjacent operators are in non-associative precedence group 'DefaultPrecedence'
// When our operator is used multiple times in a row, Swift doesn’t know which side of the operator to evaluate first. On the lefthand side, we have:

// Fix this with parentheses
(2 |> incr) |> square // 9

precedencegroup ForwardApplication {
    associativity: left
}

// We gave it a left associativity to ensure that the lefthand expression evaluates first.
infix operator |>: ForwardApplication

// It works now
2 |> incr |> square // 9

// Introducing >>>

precedencegroup ForwardComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator >>>: ForwardComposition

func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> ((A) -> C) {
    return { a in
        g(f(a))
    }
}

2 |> incr >>> square // 9

// What does function composition look like in the method world?

extension Int {
    func incrAndSquare() -> Int {
        return self.incr().square()
    }
}

2.incrAndSquare() // 9


2 |> incr >>> square >>> String.init // "9"

[1, 2, 3].map { ($0 + 1) * ($0 + 1) } // [4, 9, 16]

[1, 2, 3]
    .map(incr)
    .map(square)
// [4, 9, 16]


[1, 2, 3].map(incr >>> square) // [4, 9, 16]

