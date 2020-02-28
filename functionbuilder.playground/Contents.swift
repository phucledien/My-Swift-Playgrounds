/*: Opaque type
 
 # Opaque type
 
 Let’s say I have a function that returns some value of type S (where S: T) but the user doesn’t need to know it’s S.
 
 The fact that it is S is an implementation detail so I which to return it as T.
 
 If I write this function as returning -> T the issue is, when this return value of my function is used, other functions won’t know that two return values of my function are actually the same concrete type or subclass/implementation.
 
 Instead they’ll just see T. So a way to think about it is:
 
 *some T let’s Swift know what specific subclass of T something is but it does not let the user*
 */

protocol Animal {
    func isSibling(with animal: Self) -> Bool
}

class Dog: Animal {
    func isSibling(with animal: Dog) -> Bool {
        return true
    }
}

func animalFromAnimalFamily() -> some Animal {
    return Dog()
}



/// Function builder
protocol Task {}

struct Build: Task {}
struct Test: Task {}

@_functionBuilder
struct TaskBuilder {
    
}

func run(@TaskBuilder builder: () -> [Task]) {
   print
}

