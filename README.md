# DataStructureCollection

This package intentions are mainly two:
* Explore ways to implement Data Strucutures and pure algorithms but using type value only elements as structs and collections.
* Implement all the Data Strucutures by extending exisiting Swift Collection as Array, Set, and Dictionaries.

This package is in developement, there is not enought tests yet, neither documentation. There is even a lot of places for improvement, I like the code, but nobody is perfect :-(.

This project has one main file DSProtocols wich tries to define all the protocols needed and used in the Data Structures implemented here. Then there is a one directory called Strutcs with the implementations of the elements required by the Data Structs, and two directrories called Arrays and Dictionaries with extensions of the struct Array and the struct Dictionary that implement several Data Strucutures. For example, there is an implementation of the Data Struct List with an Dictionary extension that requires to conform with ListProtocols together with be using an object that conforms with ListProtocol.

At some point this package may have performance test, my guees is that implement Data Structures with type values objects instead of reference type object the algorithms should be faster. Because is chipper to create a type value than a reference value, and because I trust Swift will not create new type value objects when this object doesn't change, eventhough when it passed as parameter in a function.

Please enjoy and fell free to request be a collaborator, fork, use this package, and ask questions, report bugs, and make sugestions. 
