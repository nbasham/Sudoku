## Sudoku
### An experiment with Combine and SwiftUI

Having written iOS and tvOS Sudoku apps in Obj-C and Swift I wanted to see how a Combine/SwiftUI implementation would compare.

### The Plan
* A rudimentary SwiftUI implementation that publishes events (e.g. cell click) and reacts to view model changes.
* A simple state object that publishes property changes and a view model that subscribes to those changes.


![Sudoku Workflow](https://user-images.githubusercontent.com/2135673/118908494-6449c380-b8d6-11eb-8a23-290ed7c8980c.jpg)


### The Results
Combine is going to change the way I program and even more, the way I think about coding. The data binding really makes it easy to reason about a single source of truth. Natural usage of Combine results in small encapsulated pieces of code that are independent and fit together in a consistent fashion. This consistency is very comfortable as it guides you towards Apple's WWDC promise (image below). I'll bet coding this way will reduce complexity as well as bugs, can't wait to find out!

As someone new to Combine, and reactive thinking in general, any suggestions or pull requests would be welcomed.

![Apple Image](https://pbs.twimg.com/media/Ed4LCKRU0AAmdv5?format=jpg&name=900x900)
