//
//  AVLTreeNode.swift
//  
//
//  Created by GustavoHalperin on 11/30/20.
//

import Foundation

public
struct AVLTreeNode<T:Hashable & Comparable>: AVLTreeNodeProtocol {
  public typealias Key = T
  public typealias Value = T
  public var value:Value
  public var height: Int = 0
  public var parent:Key?
  public var left:Key?
  public var right:Key?
  public init(value:Value) { self.value = value }
}
