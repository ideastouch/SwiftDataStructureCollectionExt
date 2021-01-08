//
//  ListTest.swift
//  
//
//  Created by GustavoHalperin on 12/3/20.
//

import XCTest
@testable import DataStructureCollection

class ListTest: XCTestCase {
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testList() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct
    // results.
    var list = Dictionary<String, ListNode<Int> >()
    list.addLast(5) //5
    list.addLast(2) //5,2
    list.addFirst(8) //8,5,2
    list.addLast(3) //8,5,2,3
    XCTAssertEqual(list.removeFirst(), 8) //5,2,3
    XCTAssertEqual(list.removeLast(), 3) //5,2
    list.addLast(9) //5,2,9
    list.addFirst(4) //4,5,2,9
    XCTAssertEqual(list.removeFirst(), 4) //5,2,9
    XCTAssertEqual(list.removeFirst(), 5) //2,9
    XCTAssertEqual(list.removeFirst(), 2) //9
    XCTAssertEqual(list.removeFirst(), 9)
    XCTAssertEqual(list.removeFirst(), nil)
  }
  
  func testQueuePerformance() {
    // This is an example of a performance test case.
    self.measure {
      var queue = Dictionary<String, ListNode<Int> >()
      
      
      for value in 1...100_000 { queue.addLast(value) }
      for _ in 1...100_000 { _ = queue.removeFirst() }
    }
  }
}
