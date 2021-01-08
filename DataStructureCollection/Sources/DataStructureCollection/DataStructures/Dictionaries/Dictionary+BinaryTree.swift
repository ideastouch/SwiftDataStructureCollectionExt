import Foundation

/**
 Getters extensions low height
 */
extension Dictionary
where Value: BinaryTreeNodeProtocol, Key == Value.Key, Value.Key == Value.Value, Key: Comparable {
  var list:[Key] { self.keys.map { $0 } }
  func nodeOf(_ node:Value?) -> Value? { node != nil ? self[node!.value] : nil }
  func nodeOf(_ node:Value?, keyPath:KeyPath<Value, Value.Key?>) -> Value? {
    guard let node = self.nodeOf(node), let key = node[keyPath: keyPath] else { return nil }
    return self[key] }
  
  func parentOf(_ node:Value?) -> Value? { self.nodeOf(node, keyPath: \.parent) }
  func leftOf(_ node:Value?) -> Value? { self.nodeOf(node, keyPath: \.left) }
  func rightOf(_ node:Value?) -> Value? { self.nodeOf(node, keyPath: \.right) }
  
  func parentWritebleKeyPath(_ node:Value) -> WritableKeyPath<Value, Key?>? {
    switch node.value {
    case self.parentOf(node)?.left: return \.left
    case self.parentOf(node)?.right: return \.right
    default: return nil
    }
  }
}

/**
 Setters extensions
 */
extension Dictionary
where Value: BinaryTreeNodeProtocol, Key == Value.Key, Value.Key == Value.Value, Key: Comparable {
  mutating func setValueFor(_ node:Value?, value:Value?, keyPath: WritableKeyPath<Value, Key?>) {
    guard let key = node?.value else { return }
    self[key]?[keyPath: keyPath] = value?.value
  }
}

extension Dictionary
where Value: BinaryTreeNodeProtocol, Key == Value.Key, Value.Key == Value.Value, Key: Comparable {
  func findNode(_ node:Value?, value:Key) -> Value? {
    guard let nodeValue = node?.value else { return nil }
    if nodeValue > value, let left = node?.left { return self.findNode(self[left], value:value) }
    if nodeValue < value, let right = node?.right { return self.findNode(self[right], value: value) }
    return node
  }
  @discardableResult mutating
  func insert(_ root:Value, value:Key, keyPath:WritableKeyPath<Value, Value.Key?>) -> Value? {
    guard let next = self.nodeOf(root, keyPath: keyPath) else {
      self[value] = Value(value: value)
      self.link(root, to: self[value], keyPath: keyPath)
      return self[value]
    }
    return self.insert(next, value: value)
  }
  @discardableResult mutating
  func insert(_ node:Value, value:Key) -> Value? {
    let root = node
    guard root.value != value else { return root }
    let keyPath:WritableKeyPath<Value, Value.Key?> = root.value > value ? \.left : \.right
    guard let next = self.nodeOf(root, keyPath: keyPath) else {
      self[value] = Value(value: value)
      self.link(root, to: self[value], keyPath: keyPath)
      return self[value]
    }
    return self.insert(next, value: value)
  }
  func lowerWithKeyPath(_ node:Value?, keyPath:KeyPath<Value, Key?>) -> Value? {
    guard let lower = self.nodeOf(node, keyPath: keyPath) else { return nil }
    return self.lowerWithKeyPath(lower, keyPath: keyPath) ?? lower
  }
  public func theSmallerOf(_ node:Value?) -> Value? {
    guard let node = node else { return  nil }
    guard let next = self.leftOf(node) else { return nil }
    return self.theSmallerOf(next) ?? next
  }
  public func theBiggerOf(_ node:Value?) -> Value? {
    guard let node = node else { return  nil }
    guard let next = self.rightOf(node) else { return nil }
    return self.theBiggerOf(next) ?? next
  }
  
  /**
   Link two nodes togethes in bothe ways.
   */
  mutating func link(_ node:Value?, to:Value?, keyPath: WritableKeyPath<Value, Key?>?) {
    self.setValueFor(to, value:node, keyPath:\.parent)
    if let keyPath = keyPath {
      self.setValueFor(node, value: to, keyPath: keyPath)
    }
  }
  mutating func linkWithParentOf(_ node:Value?, to:Value?) {
    let parent = self.parentOf(node)
    self.setValueFor(to, value: parent, keyPath: \.parent)
    if let node = node, let keyPath = self.parentWritebleKeyPath(node) {
      self.setValueFor(parent, value: to, keyPath: keyPath)
    }
  }
  /**
   We link together:
   1. parent of 'node' with 'with'
   2. 'with' with left of parent of 'node'
   3. 'with' with right of parent of 'node'
   */
  mutating func replace(_ node:Value, with:Value?) {
    self.linkWithParentOf(node, to: with)
    self.link(with, to:self.leftOf(node), keyPath: \.left)
    self.link(with, to:self.rightOf(node), keyPath: \.right)
  }
  
  /**
   if the bigger of left exist: switch to MRofL and buble up the left of the MRofL.
   if left exist: bubble up the left.
   if right exist: Bubble up the right
   return the parent of the lower node removed.
   */
  @discardableResult mutating
  func remove(_ node:Value?) -> Value? {
    guard let root = node else { return nil }
    defer { self[root.value] = nil }
    if root.isLeaf {
      let parent = self.parentOf(root)
      self.linkWithParentOf(root, to: nil)
      return self.nodeOf(parent)
    }
    if let childPath = root.singleParentChildKeyPath,
       let child =  self.nodeOf(root, keyPath: childPath) {
      let parent = self.parentOf(root)
      self.linkWithParentOf(root, to: child)
      return self.nodeOf(parent)
    }
    guard let right = self.rightOf(root), // never can be nil
          let lower = self.lowerWithKeyPath(right, keyPath: \.left) else {
      let right = self.rightOf(root)
      return self.remove(right)
    }
    let parent = self.remove(lower)
    self.replace(root, with: lower)
    return self.nodeOf(parent)
  }
}

extension Dictionary
where Value: BinaryTreeNodeProtocol, Key == Value.Key, Value.Key == Value.Value, Key: Comparable//, ListNode<Value>.Value: Equatable
{
  /// Extractors
  func preorder(_ node:Value?) -> [Value.Value] {
    guard let value = node?.value else { return [Value.Value]() }
    return
      [value] +
      self.preorder(self.leftOf(node)) +
      self.preorder(self.rightOf(node))
  }
  func inorder(_ node:Value?) -> [Value.Value] {
    guard let value = node?.value else { return [Value.Value]() }
    return
      self.inorder(self.leftOf(node)) +
      [value] +
      self.inorder(self.rightOf(node))
  }
  func inorderRight(_ node:Value?) -> [Value.Value] {
    guard let value = node?.value else { return [Value.Value]() }
    return
      self.inorderRight(self.rightOf(node)) +
      [value] +
      self.inorderRight(self.leftOf(node))
  }
  func postorder(_ node:Value?) -> [Value.Value] {
    guard let value = node?.value else { return [Value.Value]() }
    return
      self.postorder(self.leftOf(node)) +
      self.postorder(self.rightOf(node)) +
      [value]
  }
}

extension Dictionary
where Value: BinaryTreeNodeProtocol, Key == Value.Key, Value.Key == Value.Value, Key: Comparable {
  public typealias Elm = Key
  func root(_ node:Value) -> Value {
    //guard let parent = self.parentOf(node) else { return node } // this optiomization means 10 times faster
    guard let key = node.parent, let parent = self[key] else { return node }
    return self.root(parent)
  }
  public
  var root: Value? {
    guard let node = self.first?.value  else { return nil }
    return self.root(node)
  }
  // Find node is not required here since each this is a dictionary
  // where each node has access in o(1)
  public
  func findNode(_ value:Key) -> Value? {
    return self.findNode(self.root, value: value)
  }
  mutating
  public func insert(_ elm: Key) {
    guard self.isEmpty == false else {
      self[elm] = Value(value: elm)
      return
    }
    guard let root = self.root else { return }
    self.insert(root, value: elm)
  }
  mutating public func remove(_ elm: Key) -> Key? {
    guard let root = self[elm] else { return nil }
    return self.remove(root)?.value
  }
}

extension Dictionary
where Value: BinaryTreeNodeProtocol, Key == Value.Key, Value.Key == Value.Value, Key: Comparable
{
  public func preorder() -> [Key] { self.preorder(self.root) }
  public func inorder() -> [Key] { self.inorder(self.root) }
  public func inorderRight() -> [Key] { self.inorderRight(self.root) }
  public func postorder() -> [Key] { self.postorder(self.root) }
}

extension Dictionary
where Value: BinaryTreeNodeProtocol, Key == Value.Key, Value.Key == Value.Value, Key: Comparable
{
  func levelorder<Q:QueueProtocol>(_ node:Value?, q:Q.Type) -> [Value.Value] where Q.QueueValue == Value.Value {
    var queue = Q()
    var result = Array<Value.Value>()
    if let node = node { queue.enque(node.value) }
    while let key = queue.deque() {
      result.append(key)
      guard let node = self[key] else { continue }
      if let left = self.leftOf( node ) { queue.enque(left.value) }
      if let right = self.rightOf( node ) { queue.enque(right.value) }
    }
    return result
  }
  public func levelorder() -> [Key] { self.levelorder(self.root, q: Dictionary<String, ListNode<Value.Value> >.self) }
}

extension Dictionary: BinaryTreeProtocol
where Value: BinaryTreeNodeProtocol, Key == Value.Key, Value.Key == Value.Value, Key: Comparable//, ListNode<Value>.Value: Equatable
{
}

/**
 Right Rotation:
 right becomes child of parent of root.
 left of right becomes right of root
 root becomes left child of righ
 
 Right Left Rotation:
 r_of_l becomes son of parent of root.
 right of l_of_r becomes left of right
 right becomes right of l_of_r
 left of r_of_l becomes right of root
 root becomes left of r_of_l
 
 Remove (Replace)
 ================
 Check bigger child height
 if Left: Do Left-Bigger or Left
 else Do Right
 
 Remove and Raplace with Left:
 set parent of left to toBalance
 parent of root becomes parent of Left
 right of root becomes right of left
 | remove root.
 | check Balance for toBalance
 
 Remove and Raplace with Left-Bigger (Right):
 set parent of Left-Bigger to toBalance
 parent of Left-Bigger becomes parent of Left of Left-Bigger
 parent of root becomes parent of Left-Bigger
 left of root becomes left of Left-Bigger
 right root becomes right of Left-Bigger
 | remove root.
 | check Balance for toBalance
 
 Remove and Raplace with Right:
 set Right to toBalance
 parent of root becomes parent of Right
 left of root becomes left of RIght
 | remove root.
 | check Balance for toBalance

 
 */
