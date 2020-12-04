//
//  File.swift
//  
//
//  Created by GustavoHalperin on 12/2/20.
//

import Foundation

extension Dictionary
where Value: ListNodeProtocol, Key == String, Key == Value.Key, Value.Value: Equatable {
  private static var rootKey: String { "ListProtocolRoot" }
  private static var tailKey: String { "ListProtocolTail" }
  internal var root:Value? { self[Self.rootKey] }
  internal var tail:Value? { self[Self.tailKey] }
  private func keyOf(_ value:Value.Value) -> String { String(describing: value) }
  private func keyOf(_ value:Value.Value?) -> String? { value != nil ? String(describing: value!) : nil }
  private mutating func linkFrom(_ from:Value?, to:Value?) {
    if let key = self.keyOf(from?.value) {
      let next = self.keyOf(to?.value)
      self[key]?.next = next
      if let root = self.root, root.value == from?.value
      { self[Self.rootKey] = self[key] }
    }
    if let key = self.keyOf(to?.value) {
      let prev = self.keyOf(from?.value)
      self[key]?.prev = prev
      if let tail = self.tail, tail.value == to?.value
      { self[Self.tailKey] = self[key] }
    }
  }
  mutating public func addFirst(_ elm:Value.Value)  {
    let node = Value(value:elm)
    self[String(describing: elm)] = node
    switch (self.root, self.tail) {
    case (nil,nil):
      break
    case (let root,nil):
      self[Self.tailKey] = root
      self.linkFrom(self.root, to: self.tail)
    case (let root, _):
      self.linkFrom(node, to: root)
    }
    self[Self.rootKey] = self[self.keyOf(elm)]
  }
  mutating public func addLast(_ elm:Value.Value)  {
    let node = Value(value:elm)
    self[String(describing: elm)] = node
    switch (self.root, self.tail) {
    case (nil,nil):
      self[Self.rootKey] = node
    case ( let root,nil):
      self[Self.tailKey] = node
      self.linkFrom(root, to: node)
    case ( _, let tail):
      self[Self.tailKey] = node
      self.linkFrom(tail, to: node)
    }
  }
  mutating public func removeFirst() -> Value.Value? {
    switch (self.root, self.tail) {
    case (nil,nil):
      return nil
    case ( _,nil):
      let value = self.root?.value
      if let key = self.keyOf(self.root?.value) { self[key] = nil }
      self[Self.rootKey] = nil
      return value
    case ( _, _):
      guard let root = self.root, let value = root.value,
            let next = root.next, let nextNode = self[next]
      else { return nil } // We should never be here
      self[self.keyOf(value)] = nil
      self.linkFrom(nil, to: nextNode)
      self[Self.rootKey] = self[next]
      if self.root?.value == self.tail?.value {
        self[Self.tailKey] = nil
        self.linkFrom(nextNode, to: nil)
      }
      return value
    }
  }
  mutating public func removeLast() -> Value.Value? {
    switch (self.root, self.tail) {
    case (nil,nil):
      return nil
    case ( _,nil):
      let value = self.root?.value
      if let key = self.keyOf(self.root?.value) { self[key] = nil }
      self[Self.rootKey] = nil
      return value
    case ( _, _):
      guard let tail = self.tail, let value = tail.value,
            let prev = tail.prev, let prevNode = self[prev]
      else { return nil } // We should never be here
      self.linkFrom(prevNode, to: nil)
      self[Self.tailKey] = self[prev]
      return value
    }
  }
}

extension Dictionary
where Value: ListNodeProtocol, Key == String, Key == Value.Key, Value.Value: Equatable {
  public mutating func clean() { self.removeAll() }
}

extension Dictionary: ListProtocol
where Value: ListNodeProtocol, Key == String, Key == Value.Key, Value.Value: Equatable {
  public typealias ListElement = Value.Value
}
