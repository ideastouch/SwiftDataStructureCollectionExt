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
  func heightOf(_ node:Value?) -> Int {
    guard let node = self.nodeOf(node) else { return -1 }
    return node.height
  }
  mutating func setHeightFor(_ node:Value?, height:Int) {
    guard let root = self.nodeOf(node) else { return }
    self[root.value]?[keyPath: \.height] = height
  }
  func calculateHeight(_ node:Value?) -> Int {
    guard let node = self.nodeOf(node) else { return -1}
    let left = self.heightOf( self.leftOf(node) )
    let right = self.heightOf( self.rightOf(node) )
    return Swift.max(left, right) + 1
  }
  mutating func updateHeigh(_ node:Value?) {
    let height = self.calculateHeight(node)
    self.setHeightFor(node, height: height)
  }
  
  // MARK: Rotations
  func balanceFactor(_ node: Value?) -> AVLBalanceFactor? {
    guard let root = self.nodeOf(node) else { return nil }
    let right:Int = self.heightOf(self.rightOf(root))
    let left = self.heightOf(self.leftOf(root))
    return AVLBalanceFactor(factor: right - left)
  }
  func smallAndBigKeyPath(_ node:Value) -> (WritableKeyPath<Value, Key?>, WritableKeyPath<Value, Key?>)? {
    switch self.balanceFactor(node) {
    case .leftHeavy: return (\.right, \.left)
    case .rightHeavy: return (\.left, \.right)
    default: return nil
    }
  }
  /**
   - If we here we assume that balance factor isn't .balanced.
   Rotate bigger child toward smaller child
   Update Heights
   We succeed in this task by working with keyPath. Once we found the keyPath
   of the smaller child of root we can use this keyPath in order to determine that
   the bigger root's child and also then use the his inner child in the same side
   of the root, which we call closerToRoot.
   */
  mutating
  func rotateFinal(_ node:Value) -> Value {
    guard let root = self.nodeOf(node) else { return node }
    guard let (small,big) = self.smallAndBigKeyPath(root) else { return root }
    guard let bigger = self.nodeOf(root, keyPath: big) else { return root }
    let closerToRoot = self.nodeOf(bigger, keyPath: small)
    self.linkWithParentOf(root, to: bigger)
    self.link(root, to: closerToRoot, keyPath: big)
    self.link(bigger, to: root, keyPath: small)
    self.updateHeigh(root)
    self.updateHeigh(bigger)
    return self.nodeOf(bigger) ?? bigger
  }
  /**
   Go to lower child of node, save keyPath (.left or .right)
   Check A & B below
    A. lower child isn't balanced
    B. lower inner lower child keyPath isn't the same
   If A & B are true: Call rotateFinal with inner lower child.
   Call to rotateFinal with node
   */
  mutating
  func rotate(_ node:Value) -> Value {
    guard let root = self.nodeOf(node),
          let balanceFactor = self.balanceFactor(node),
          balanceFactor.balanced == false,
          let (small,big) = self.smallAndBigKeyPath(root) else {
      return node
    }
    if let bigger = self.nodeOf(root, keyPath: big), // always should go ok
       let (innerSmall,_) = self.smallAndBigKeyPath(bigger),
       small != innerSmall {
      _ = self.rotateFinal(bigger)
    }
    return self.rotateFinal(root)
  }
  /**
   Insert-Retracing:
   1. Update height.
   2. Check Balance Factor
   2.1 If 0 go to End
   2.2 if +/-1, move up in the tree and go back to 1
   2.3 Apply rotation (includeing height's update)
   3. End
   */
  mutating func insertRetracing(_ node:Value?) {
    guard let root = self.nodeOf(node) else { return }
    self.updateHeigh(root) // root is not longer hoding the real height
    switch self.balanceFactor(root) { // 2
    case .balanced: // 2.1
      return
    case let bf where bf?.rotationNeedeed == false: // 2.1
      let parent = self.parentOf(root)
      return self.insertRetracing(parent)
    default: // 2.3
      let pivot = self.rotate(root)
      let parent = self.parentOf(pivot)
      return self.insertRetracing(parent)
    }
  }
  
  /**
   Delete-Retracting
   1. Get previous Balance Factor (pBF)
   2. Save current Parent Balance Factor (PBF) and Current Height (pH, p for previous)
   3. Update height
   4. Calculate BF
   4.1 If pBF is 0 and BF is +/-1 go to End. // Meaning the height remains the same.
   4.2 If BF is +/-2 apply rotation (includeing height's update)
   5. If Height is equal to pH go to End // Tree is balanced and unchange upward.
   6. Move up in the tree and go back to 1 (use saved PBF)
   5. End
   */
  @discardableResult mutating
  func removeRetracing(_ node:Value?, _ prevBF:AVLBalanceFactor?) -> Value? {
    guard var root = self.nodeOf(node) else { return nil }
    let parentBF = self.balanceFactor(self.parentOf(root)) // 2
    let prevHeight = root.height // 2
    self.updateHeigh(root) // 3, root is not longer hoding the real height
    let balanceFactor = self.balanceFactor(root)
    if case .balanced = prevBF,
       balanceFactor?.balanced == false,
       balanceFactor?.rotationNeedeed == false { // 4.1
        return root
       }
    if balanceFactor?.rotationNeedeed == true { // 4.2
      root = self.rotate(root)
    }
    guard prevHeight !=  self.heightOf(root) else { return root }
    return self.removeRetracing(self.parentOf(root), parentBF)
  }
}

extension Dictionary
where Value: AVLTreeNodeProtocol, Key == Value.Key, Value.Key == Value.Value, Key: Comparable
{
  public var height:Int {
    guard let root = self.root else { return 0 }
    return self.heightOf(root) + 1
  }
  public func levelorder() -> [(Key,Int)] {
    let values:[Value.Value] = self.levelorder()
    return values.map { ($0, self[$0]?.height ?? -1) }
  }
  public mutating
  func insert(_ elm:Elm) {
    guard self[elm] == nil else { return }
    guard let root = self.root else {
      self[elm] = Value(value: elm, height:0)
      return
    }
    let node = self.insert(root, value:elm)
    let parent = self.parentOf(node)
    self.insertRetracing(parent)
  }
  /**
   find small & Big keyPath
   find the lower in the small direction of Big ( lSB )
   save parent of lSB ( plSB )
   save Balance Factor ( plBF )
   remove plSB
   replace root with plSB
   call to removeRetracing with plSB and plBF
   */
  mutating
  func updateHeightUpward(_ node:Value?) {
    guard let root = node else { return }
    self.updateHeigh(root)
    guard root.height != self.nodeOf(root)?.height else { return }
    let parent = self.parentOf(root)
    self.updateHeigh(parent)
  }
  @discardableResult public mutating
  func remove(_ elm: Key) -> Key? {
    guard let root = self[elm] else { return nil }
    guard root.isLeaf == false else {
      let parentLowerSB = self.parentOf(root)
      let parentLowerBF = self.balanceFactor(parentLowerSB)
      _ = self.remove(root)
      return self.removeRetracing(parentLowerSB, parentLowerBF)?.value
    }
    let (small, big) = self.smallAndBigKeyPath(root) ?? (\.left, \.right)
    guard let bigger = self.nodeOf(root, keyPath: big) else { // if isn't leaf always it will be a bigger
      assertionFailure("bigger should always exists")
      _ = self.remove(root);
      return nil
    }
    // bigger hasn't lower child, therefore bigger will be removed using the standard remove
    // bigger may have a brother
    let lowerSB = self.lowerWithKeyPath(bigger, keyPath: small) ?? bigger
    var parentLowerSB = self.parentOf(lowerSB)
    let parentLowerBF = self.balanceFactor(parentLowerSB)
    _ = self.remove(lowerSB)
    self[lowerSB.value] = lowerSB  // lower was remove just above
    self.replace(root, with: lowerSB)
    self.setHeightFor(lowerSB, height: root.height)
    self[root.value] = nil // We done with root
    if parentLowerSB?.value == elm { parentLowerSB = lowerSB }
    return self.removeRetracing(parentLowerSB, parentLowerBF)?.value
  }
}

extension Dictionary
where Value: AVLTreeNodeProtocol, Key == Value.Key, Value.Key == Value.Value, Key: Comparable
{
  public init(arrayLiteral values: Key...) {
      self.init()
      for value in values {
          self.insert(value)
      }
  }

}

extension Dictionary:AVLTreeProtocol
where Value: AVLTreeNodeProtocol, Key == Value.Key, Value.Key == Value.Value, Key: Comparable
{
}
