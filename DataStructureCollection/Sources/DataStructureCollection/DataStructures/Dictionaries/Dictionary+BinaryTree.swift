import Foundation

/**
 Getters extensions low height
 */
extension Dictionary
where Value: BinaryTreeNodeProtocol, Key == Value.Key, Value.Key == Value.Value, Key: Comparable {
  var list:[Key] { self.keys.map { $0 } }
  func nodeOf(_ node:Value?) -> Value? { node?.value != nil  ? self[node!.value!] : nil }
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
  func findNode(_ root:Value?, value:Key) -> Value? {
    guard let root = root, let rootValue = root.value else { return  nil }
    if rootValue > value { return self.findNode(self.leftOf(root), value:value) }
    if rootValue < value { return self.findNode(self.rightOf(root), value: value) }
    return root
  }
  mutating func insert(_ root:Value, value:Key, keyPath:WritableKeyPath<Value, Value.Key?>) -> Value? {
    guard let next = self.nodeOf(root, keyPath: keyPath) else {
      self[value] = Value(value: value)
      self.link(root, to: self[value], keyPath: keyPath)
      return self[value]
    }
    return self.insert(next, value: value)
  }
  mutating func insert(_ root:Value, value:Key) -> Value? {
    guard let rootValue = root.value else { return  nil }
    guard rootValue != value else { return root }
    let keyPath:WritableKeyPath<Value, Value.Key?> = rootValue > value ? \.left : \.right
    guard let next = self.nodeOf(root, keyPath: keyPath) else {
      return self.insert(root, value: value, keyPath: keyPath)
    }
    return self.insert(next, value: value)
  }
  
  func parentOf(_ root:Value?, value:Key) -> Value? {
    self.parentOf(self.findNode(root, value: value))
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
  mutating func replaceChild(_ node:Value, with:Value?) {
    self.linkWithParentOf(node, to: node)
    self.link(with, to:self.leftOf(node), keyPath: \.left)
    self.link(with, to:self.rightOf(node), keyPath: \.right)
  }
  
  /**
   if the bigger of left exist: switch to MRofL and buble up the left of the MRofL.
   if left exist: bubble up the left.
   if right exist: Bubble up the right
   */
  mutating func remove(_ root:Value, value:Key?) -> Value? {
    guard let value = value else { return nil }
    defer { self[value] = nil }
    guard let node = self.findNode(root, value: value) else { return nil }
    if let parent = self.leftOf(node), let next =  self.theBiggerOf(parent) {
      self.setValueFor(parent, value: nil, keyPath:\.right)
      self.replaceChild(node, with: next)
      return self[value]
    }
    if let next = self.leftOf(node) {
      self.linkWithParentOf(node, to: next)
      self.setValueFor(next, value:self.rightOf(node), keyPath:\.right)
      return self[value]
    }
    if let next = self.rightOf(node) {
      self.linkWithParentOf(node, to: next)
      return self[value]
    }
    return self[value]
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
    guard let parent = self.parentOf(node) else { return node }
    return self.root(parent)
  }
  var root: Value? {
    guard let node = self.first?.value  else { return nil }
    return self.root(node)
  }
  func findNode(_ value:Key) -> Value? {
    return self.findNode(self.root, value: value)
  }
  mutating public func insert(_ elm: Key) {
    guard self.isEmpty == false else {
      self[elm] = Value(value: elm)
      return
    }
    guard let root = self.root else { return }
    _ = self.insert(root, value: elm)
  }
  mutating public func remove(_ elm: Key) -> Key? {
    guard let root = self.root else { return nil }
    return self.remove(root, value: elm)?.value
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
    if let node = node, let key = node.value { queue.enque(key) }
    while let key = queue.deque() {
      //if let value = node.value {
      result.append(key) //}
      guard let value = self[key] else { continue }
      if let left = self.leftOf( value ), let value = left.value { queue.enque(value) }
      if let right = self.rightOf( value ), let value = right.value { queue.enque(value) }
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
