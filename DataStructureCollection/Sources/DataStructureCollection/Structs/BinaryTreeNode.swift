import Foundation

public
struct BinaryTreeNode<T:Hashable & Comparable>: BinaryTreeNodeProtocol
{
  public typealias Key = T
  public typealias Value = T
  public var value:Value
  public var parent:Key?
  public var left:Key?
  public var right:Key?
  public init(value:Value) { self.value = value}
}
