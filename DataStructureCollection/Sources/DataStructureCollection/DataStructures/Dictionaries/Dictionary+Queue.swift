//
//  File.swift
//  
//
//  Created by GustavoHalperin on 12/1/20.
//

import Foundation

extension Dictionary
where Value: ListNodeProtocol, Key == String, Key == Value.Key, Value.Value: Equatable {
  mutating public func enque(_ elm:Value.Value)  {
    self.addLast(elm)
  }
  mutating public func deque() -> Value.Value? {
    self.removeFirst()
  }
  public func peek() -> Value.Value? { self.root?.value }
  public func size() -> Int { self.count }
}

extension Dictionary: QueueProtocol
where Value: ListNodeProtocol, Key == String, Key == Value.Key, Value.Value: Equatable {
  public typealias QueueValue = Value.Value
}
