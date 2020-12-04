//
//  File.swift
//  
//
//  Created by GustavoHalperin on 11/30/20.
//

import Foundation

/**
 AVL Tree
 */
private
extension Dictionary
where Value: AVLTreeNodeProtocol, Key == Value.Key, Value.Key == Value.Value, Key: Comparable//, ListNode<Value>.Value: Equatable
{
  var isBalanced:Bool { self.root?.height != nil }
  func heightOf(_ node:Value?) -> Int {
    guard let node = self.nodeOf(node) else { return -1 }
    return node.height ?? -1
  }
  mutating func setHeightFor(_ node:Value?, height:Int?) {
    guard let nodeKey = node?.value else { return }
    self[nodeKey]?.height = height
  }
  mutating func updateHeightUpward(_ node:Value?) {
    guard let node = node else { return }
    let left = self.heightOf( self.leftOf(node) )
    let right = self.heightOf( self.rightOf(node) )
    let height = Swift.max(left, right) + 1
    self.setHeightFor(node, height: height)
    self.updateHeightUpward(self.parentOf(node))
  }
  func isBalancedFor(_ node:Value) -> Bool {
    guard let _ = self.nodeOf(node)?.height else { return false }
    let left = self.heightOf( self.leftOf(node) )
    let right = self.heightOf( self.rightOf(node) )
    return [-1,0,1].contains(left - right)
  }
  func rotationNeeded(_ node:Value) -> AVLTreeRotation? {
    let left = self.leftOf(node)
    let right = self.rightOf(node)
    switch self.heightOf( left ) - self.heightOf( right ) {
    case let delta where delta > 1:
      guard let left = left else { return nil }
      if self.heightOf( self.leftOf(left) ) >= self.heightOf( self.rightOf(left) )
      { return .left } else
      { return .leftRight }
    case let delta where delta < -1:
      guard let right = right else { return nil }
      if self.heightOf( self.rightOf(right) ) >= self.heightOf( self.leftOf(right) )
      { return .right } else
      { return .rightLeft }
    default:
      return nil
    }
  }
  func checkForUnvalancedAbove(_ node:Value?) -> (Value, AVLTreeRotation)? {
    guard let node = self.nodeOf(node) else { return nil }
    if let rotation = self.rotationNeeded(node) { return (node,rotation) }
    return self.checkForUnvalancedAbove(self.parentOf(node))
  }
  /**
      n                                       R
    L          R                         n            RR
       RL      RR       ->  L     RL   RRL  RRR
          RRL RRR
   */
  mutating func rightRotation(_ node:Value) -> Value? {
    guard let right = self.rightOf(node) else { return nil }
    self.linkWithParentOf(node, to:right)
    self.link(node, to: self.leftOf(right), keyPath: \.right)
    self.link(right, to: node, keyPath: \.left)
    self.updateHeightUpward(node)
    return right
  }
  /**
   T: Tree, L: Left, R: Right
        n                              RL
    L               R                   n          R
        RL          RR -> L        RLR RR
     RLLT   RLRT
   */
  mutating func rightLeftRotation(_ node:Value) -> Value? {
    guard let right = self.rightOf(node) else { return nil }
    guard let leftOfRight = self.leftOf(right) else { return nil }
    self.linkWithParentOf(node, to:leftOfRight)
    self.link(node, to: self.leftOf(leftOfRight), keyPath: \.right)
    self.link(leftOfRight, to: node, keyPath: \.left)
    self.link(right, to: self.rightOf(leftOfRight), keyPath: \.left)
    self.updateHeightUpward(self.nodeOf(right))
    return leftOfRight
  }
  /*
          n             L
       L     R       LL    n
     LL LR      -> LLL   LR R
   LLL
   */
  mutating func leftRotation(_ node:Value) -> Value? {
    guard let left = self.leftOf(node) else { return nil }
    self.linkWithParentOf(node, to:left)
    self.link(node, to: self.rightOf(left), keyPath: \.left)
    self.link(left, to: node, keyPath: \.right)
    self.updateHeightUpward(node)
    return left
  }
  /*
    T: Tree, L: Left, R: Right
           n            LR
       L      R      L         n
    LT   LR     -> LL LRLT  LRRT   R
      LRLT LRRT
   */
  mutating func leftRightRotation(_ node:Value) -> Value? {
    guard let left = self.leftOf(node) else { return nil }
    guard let rightOfLeft = self.rightOf(left) else { return nil }
    self.linkWithParentOf(node, to:rightOfLeft)
    self.link(node, to: rightOfLeft, keyPath: \.left)
    self.link(left, to: self.leftOf(rightOfLeft), keyPath: \.right)
    self.link(rightOfLeft, to: node, keyPath: \.right)
    self.updateHeightUpward(left)
    return rightOfLeft
  }
  mutating func revalanceUpward(_ node:Value?) {
    self.updateHeightUpward(node)
    guard let (root,rotation) = self.checkForUnvalancedAbove(node) else {
      return
    }
    switch rotation {
    case .left:
      self.revalanceUpward( self.leftRotation(root) )
    case .right:
      revalanceUpward( self.rightRotation(root) )
    case .leftRight:
      revalanceUpward( self.leftRightRotation(root) )
    case .rightLeft:
      revalanceUpward( self.rightLeftRotation(root) )
    }
  }
}

extension Dictionary
where Value: AVLTreeNodeProtocol, Key == Value.Key, Value.Key == Value.Value, Key: Comparable
{
  mutating func insertBalanced(_ elm: Key) {
    defer {
      self.revalanceUpward(self[elm])
    }
    guard let root = self.root else {
      self[elm] = Value(value: elm, height:0)
      return
    }
    _ = self.insert(root, value:elm)
  }
  /**
   set left to toBalance
   parent of root becomes parent of Left
   right of root becomes right of left
   | remove root.
   | check Balance for toBalance
   */
  mutating func removeAndRaplaceWithLeft(_ root:Value) {
    var toBalance:Value? = nil
    defer { self.removeBalancedCompletion(root, toBalance:toBalance) }
    guard let left = self.leftOf(root) else { return }
    toBalance = left
    self.linkWithParentOf(root, to: left)
    self.link(left, to: self.rightOf(root), keyPath: \.right)
  }
  /**
   set parent of Left-Bigger to toBalance
   parent of Left-Bigger becomes parent of Left of Left-Bigger
   parent of root becomes parent of Left-Bigger
   left of root becomes left of Left-Bigger
   right root becomes right of Left-Bigger
   | remove root.
   | check Balance for toBalance
   */
  mutating func removeAndRaplaceWithLeftBigger(_ root:Value) {
    var toBalance:Value? = nil
    defer { self.removeBalancedCompletion(root, toBalance:toBalance) }
    guard let left = self.leftOf(root),
          let leftBigger = self.theBiggerOf(left) else { return }
    toBalance =  self.parentOf(leftBigger)
    self.linkWithParentOf(leftBigger, to: self.leftOf(leftBigger))
    self.linkWithParentOf(root, to: leftBigger)
    self.link(leftBigger, to: self.leftOf(root), keyPath: \.left)
    self.link(leftBigger, to: self.rightOf(root), keyPath: \.right)
  }
  /**
   set Right to toBalance
   parent of root becomes parent of Right
   left of root becomes left of RIght
   | remove root.
   | check Balance for toBalance
   */
  mutating func removeAndRaplaceWithRight(_ root:Value) {
    var toBalance:Value? = nil
    defer { self.removeBalancedCompletion(root, toBalance:toBalance) }
    guard let right = self.rightOf(root) else { return }
    toBalance = right
    self.linkWithParentOf(root, to: right)
    self.link(right, to: self.leftOf(root), keyPath: \.left)
  }
  mutating func removeAndRaplaceWithRightSmaller(_ root:Value) {
    var toBalance:Value? = nil
    defer { self.removeBalancedCompletion(root, toBalance:toBalance) }
    guard let right = self.rightOf(root),
          let rightSmaller = self.theSmallerOf(right) else { return }
    toBalance =  self.parentOf(rightSmaller)
    self.linkWithParentOf(rightSmaller, to: self.rightOf(rightSmaller))
    self.linkWithParentOf(root, to: rightSmaller)
    self.link(rightSmaller, to: self.leftOf(root), keyPath: \.left)
    self.link(rightSmaller, to: self.rightOf(root), keyPath: \.right)
  }
  private mutating func removeBalancedCompletion(_ root:Value, toBalance:Value?) {
    if let elm = root.value { self[elm] = nil }
    self.revalanceUpward(toBalance)
  }
  mutating func removeBalanced(_ elm: Key) -> Key?  {
    guard let root = self[elm] else { return nil }
    if self.heightOf(self.rightOf(root)) >= self.heightOf(self.leftOf(root)) {
      guard let right = self.leftOf(root) else {
        self.removeBalancedCompletion(root, toBalance:self.parentOf(root))
        return elm
      }
      guard let _ = self.theSmallerOf(right) else {
        self.removeAndRaplaceWithRight(root)
        return elm
      }
      self.removeAndRaplaceWithRightSmaller(root)
    }
    else {
      guard let left = self.leftOf(root) else {
        self.removeBalancedCompletion(root, toBalance:self.parentOf(root))
        return elm
      }
      guard let _ = self.theBiggerOf(left) else {
        self.removeAndRaplaceWithLeft(root)
        return elm
      }
      self.removeAndRaplaceWithLeftBigger(root)
    }
    return elm
  }
}

extension Dictionary
where Value: AVLTreeNodeProtocol, Key == Value.Key, Value.Key == Value.Value, Key: Comparable//, ListNode<Value>.Value: Equatable
{
  public func levelorder() -> [(Key,Int)] {
    //self.levelorder(root, q: Dictionary<String, ListNode<Value.Value> >.self)
    
    let values:[Value.Value] = self.levelorder()
    return values.map { ($0, self[$0]?.height ?? -1) }
  }
  public mutating func insert(_ elm:Elm) {
    self.insertBalanced(elm)
  }
  public mutating func remove(_ elm:Elm) -> Elm? {
    self.removeBalanced(elm)
  }
}

extension Dictionary:AVLTreeProtocol
where Value: AVLTreeNodeProtocol, Key == Value.Key, Value.Key == Value.Value, Key: Comparable//, ListNode<Value>.Value: Equatable
{
}
