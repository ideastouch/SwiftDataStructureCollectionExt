import Foundation

extension Array: StackProtocol {
  public mutating func push(_ elm:Element) { self.append(elm) }
  public mutating func pop(_ elm:Element) -> Element? { self.isEmpty ? nil : self.removeLast() }
}
typealias Stack = Array
