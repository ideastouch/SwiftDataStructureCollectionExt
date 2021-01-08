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
  var value:Value { get set }
  var parent:Key? { get set }
  var left:Key? { get set }
  var right:Key? { get set }
  init(value:Value)
}

public
protocol AVLTreeNodeProtocol: BinaryTreeNodeProtocol {
  var height:Int { get set }
}

public
enum AVLTreeRotation {
  case left
  case right
  case leftRight
  case rightLeft
}
public protocol AVLBalanced {
  var balanced:Bool { get }
}
public protocol AVLRotationNeeded {
  var rotationNeedeed:Bool { get }
}
public
enum AVLBalanceFactor {
  case balanced
  case leftHeavy(Int)
  case rightHeavy(Int)
}

extension AVLBalanceFactor: AVLBalanced, AVLRotationNeeded {
  public var balanced: Bool {
    guard case .balanced = self else { return false }
    return true
  }
  public var rotationNeedeed:Bool {
    switch self {
    case .leftHeavy(let factor) where factor == -2:
      return true
    case .rightHeavy(let factor) where factor == 2:
      return true
    default:
      return false
    }
  }
}
extension AVLBalanceFactor {
  init(factor:Int) {
    switch factor {
    case _ where factor < 0: self = .leftHeavy(factor)
    case _ where factor > 0: self = .rightHeavy(factor)
    default: self = .balanced
    }
  }
}


public
extension BinaryTreeNodeProtocol {
  init(value:Value, parent:Key?) {
    self.init(value:value)
    self.parent = parent
  }
  var isRoot:Bool { self.parent != nil }
  var isLeaf:Bool { self.left == nil && self.right == nil }
  var singleParentChildKeyPath: WritableKeyPath<Self, Key?>? {
    switch (self.left, self.right) {
    case (let child,nil) where child != nil:
      return \.left
    case (nil,let child) where child != nil:
      return \.right
    default:
      return nil
    }
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
}

public
protocol AVLTreeProtocol: BinaryTreeProtocol {
  mutating func insert(_ elm:Elm)
  mutating func remove(_ elm:Elm) -> Elm?
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
enum PriorityQueueOrder {
  case min
  case max
}
public
protocol PriorityQueueProtocol {
  associatedtype Elm where Elm: Comparable
  func peek(_ order:PriorityQueueOrder) -> Elm?
  mutating func insert(_ elm:Elm, _ order:PriorityQueueOrder)
  mutating func pull(_ order:PriorityQueueOrder) -> Elm?
}

public
extension PriorityQueueOrder {
  /**
   Compare two element given as a pair of element and his index and return the pair in order according if self is min or max.
   The pairs can be both of them nil, any of them or none of them.
   This function will allows save one if when the PriorityQueue compare a node with his children, check on
   Array+PriorityQueue func Array.bubbleDown.
   */
  func prioritize<Elm:Comparable> (left:(Elm,Int)?, right:(Elm,Int)?) -> ((Elm,Int)?,(Elm,Int)?) {
    let completionLeft = { ((left!.0,left!.1), (right!.0,right!.1)) }
    let completionRight = { ((right!.0,right!.1), (left!.0,left!.1)) }
    switch (left?.0, right?.0) {
    case (nil,nil):
      return (nil,nil)
    case (_,nil):
      return ((left!.0,left!.1),nil)
    case (nil,_):
      return ((right!.0,right!.1),nil)
    default:
      switch self {
      case .min: return left!.0 <= right!.0 ? completionLeft() : completionRight()
      case .max: return left!.0 >= right!.0 ? completionLeft() : completionRight()
      }
    }
  }
}
