import Foundation

extension Array {
  mutating public func clean() { self.removeAll() }
  public func peek() -> Element? { self.last }
  public func size() -> Int { self.count }
}
