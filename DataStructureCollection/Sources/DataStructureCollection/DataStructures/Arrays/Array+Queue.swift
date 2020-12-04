import Foundation


extension Array: QueueProtocol {
  public mutating func enque(_ elm: Element) { self.append(elm) }
  public mutating func deque() -> Element? { self.isEmpty ? nil : self.removeFirst() }
}

typealias Queue = Array
