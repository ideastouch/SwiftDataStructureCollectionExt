//
//  File.swift
//  
//
//  Created by GustavoHalperin on 12/1/20.
//

import Foundation

public
struct ListNode<Value>: ListNodeProtocol
{
  public typealias Value = Value
  public var value:Value?
  public var next:String?
  public var prev:String?
  public var key:String? { self.value != nil ? String(describing:self.value!) : nil }
  public init() {}
}
