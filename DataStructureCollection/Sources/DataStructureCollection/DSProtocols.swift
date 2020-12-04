import Foundation

/**
 LIFO: Last In First out.
 Used to implement/replace tail recursion
 For example to JSON, HTML validation.
 */
public
protocol StackProtocol {
  associatedtype Elm
  mutating func push(_ elm:Elm)
  mutating func pop(_ elm:Elm) -> Elm?
  func peek() -> Elm?
  func size() -> Int
}


/*
 FIFO: First In First Out.
 USES: Breadth First Search (BFS) graph traversal, similiar to Binary tree level order.
 */
public
protocol QueueProtocol {
  associatedtype QueueValue
  mutating func enque(_ elm:QueueValue)
  mutating func deque() -> QueueValue?
  func peek() -> QueueValue?
  func size() -> Int
  init()
}

public
protocol ListProtocol {
  associatedtype ListElement
  mutating func clean()
  func size() -> Int
  
  mutating func addFirst(_ elm:ListElement)
  mutating func addLast(_ elm:ListElement)
  mutating func removeFirst() -> ListElement? // Same as for Array, it must be at least one element
  mutating func removeLast() -> ListElement?  // Same as for Array, it must be at least one element
}

public
protocol ListNodeProtocol {
  associatedtype Key:Hashable
  associatedtype Value
  var value:Value? { get set }
  var next:Key? { get set }
  var prev:Key? { get set }
  init()
}
extension ListNodeProtocol {
  init(value:Value) {
    self.init()
    self.value = value
  }
  init(value:Value, prev:Key?) {
    self.init()
    self.value = value
    self.prev = prev
  }
}
/**
 BinaryTree:
 insert, delete, remove, search: average O(log(n)), worst O(n)
 
 Preorder, Inorder, and Postorder: print value before children, in-between children, after children
 Preorder is also result in a sorter order.
 */

/**
 Key and Value can be the same type, in this case the value of the node will also the key of the node at the Hashtable.
 Value can be Comparable, if this is the situation, the dictionary can use default function to insert and search for nodes.
 */
public
protocol BinaryTreeNodeProtocol {
  associatedtype Key:Hashable
  associatedtype Value
  var value:Value? { get set }
  var parent:Key? { get set }
  var left:Key? { get set }
  var right:Key? { get set }
  init()
}

public
protocol AVLTreeNodeProtocol: BinaryTreeNodeProtocol {
  var height:Int? { get set }
 init()
}

public
enum AVLTreeRotation: String {
  case left = "Left"
  case right = "Right"
  case leftRight = "LeftRight"
  case rightLeft = "RightLeft"
}


public
extension BinaryTreeNodeProtocol {
  init(value:Value) {
    self.init()
    self.value = value
  }
  init(value:Value, parent:Key?) {
    self.init(value:value)
    self.parent = parent
  }
}
public
extension AVLTreeNodeProtocol {
  init(value:Value, height:Int) {
    self.init(value:value)
    self.height = height
  }
}

public
protocol BinaryTreeProtocol {
  associatedtype Elm
  mutating func insert(_ elm:Elm)
  mutating func remove(_ elm:Elm) -> Elm?
  
  /// Extractors
  func preorder() -> [Elm]
  func inorder() -> [Elm]
  func inorderRight() -> [Elm]
  func postorder() -> [Elm]
//  func levelorder() -> [Elm]
}

public
protocol AVLTreeProtocol: BinaryTreeProtocol {
  mutating func insert(_ elm:Elm)
  mutating func remove(_ elm:Elm) -> Elm?
  
  /// Extractors
//  func levelorder() -> [(Elm,Int)]
}


/**
 Union Find
 Disjoint Set - William Fiset
 
 Keeps track of elements wich are split into one or more disjoint sets
 Goals: find and union
 Find: given one element return the group containing it , O -> Alpha(n)
 Union: Merges two groups , O -> Alpha(n)
 And Component Size and Check if Connected has also Alpha(n)
 Construction O(n), count : O (1)
 Alpha(n) - Amortized constant time.
 Uses:
 1. Minimum Spanning Tree, given a graph of of vertices and weight edges, find
 the minum tree that connected all, and the response is not necessary unique
 2. Find islands in a grid, eg by numerate the grids ocupied and then check incrementally
 if there is any right or bottom grid ocupied, and using this condition as a union condition.
 */

public
protocol FindUnionProtocol {
  associatedtype Elm
  func find(_ elm:Elm) -> Elm?
  func connected(elm1:Elm, elm2:Elm) -> Bool
  mutating func union(elm1:Elm, elm2:Elm)
}

public
protocol PriorityQueueProtocol {
  associatedtype Elm where Elm: Comparable
  mutating func poll() -> Elm?
  mutating func add(_ elm:Elm)
}