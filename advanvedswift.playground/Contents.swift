/*:
 # Built-in collections
 ## Arrays
*/

/*:
 **Arrays and Mutability**
 */

import Foundation

// Immutable array
var x = [1,2,3]
var y = x
y.append(4)
x

// Mutable array
let a = NSMutableArray(array: [1,2,3])
let b: NSArray = a


a.insert(4, at: 3)
b

/*:
 **Arrays and Optionals**
 */
    
/// → Want to iterate over the array?
//for x in array
    
/// → Want to iterate over all but the first element of an array?
//for x in array.dropFirst()

/// → Want to iterate over all but the last 5 elements?
//for x in array.dropLast(5)

/// → Want to number all the elements in an array?
//for (num, element) in collection.enumerated()

/// → Want to find the location of a specific element?
//if let idx = array.index { someMatchingLogic($0) }

/// → Want to transform all the elements in an array?
//array.map { someTransformation($0) }

/// → Want to fetch only the elements matching a specific criterion?
//array.filter { someCriteria($0) }

/*:
 Fetch the element at index 3, and you’d better be sure the array has at least four elements in it. Otherwise, your program will trap, i.e. abort with a fatal error.
 
 The reason for this is mainly driven by how array indices are used. It’s pretty rare in Swift to actually need to calculate an index
 
 Another sign that Swift wants to discourage you from doing index math is the removal of traditional C-style for loops from the language in Swift 3.
 
 But sometimes you do have to use an index. And with array indices, the expectation is that when you do, you’ll have thought very carefully about the logic behind the index calculation. So to have to unwrap the value of a subscript operation is probably overkill
 — it means you don’t trust your code. But chances are you do trust your code, so you’ll probably resort to force-unwrapping the result, because you know that the index must be valid. This is (a) annoying, and (b) a bad habit to get into. When force-unwrapping becomes routine, eventually you’re going to slip up and force-unwrap something you don’t mean to. So to avoid this habit becoming routine, arrays don’t give you the option.
 */

/*:
 **Arrays and Mutability**
 */

/// Map

let fibs = [0, 1, 1, 2, 3, 5]

// Imperative way
var squared: [Int] = []
for fib in fibs {
    squared.append(fib * fib)
}
squared // [0, 1, 1, 4, 9, 25]

// Declarative way (functional)
let squares = fibs.map { fib in fib*fib }
squares // [0, 1, 1, 4, 9, 25]

/*: map function
 ```
extension Array {
    func map<T>(_ transform: (Element) -> T) -> [T] {
        var result: [T] = [] result.reserveCapacity(count)
        for x in self {
            result.append(transform(x))
        }
        return result
    }
}
 ```
*/
fibs.reduce("") { (str, num) in str + "\(num), "}



