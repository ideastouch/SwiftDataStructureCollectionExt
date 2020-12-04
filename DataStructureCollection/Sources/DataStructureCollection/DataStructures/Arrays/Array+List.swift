import Foundation

extension Array {
  mutating public func addFirst(_ elm:Element) { self.insert(elm, at: 0) }
  mutating public func addLast(_ elm:Element) { self.append(elm) }
  public mutating func removeFirst() -> Element? { self.first != nil ? self.removeFirst() : nil }
  public mutating func removeLast() -> Element? { self.last != nil ? self.removeLast() : nil }
}

extension Array: ListProtocol  {
  public typealias ListElement = Element
}

