//
//  Test.swift
//  
//
//  Created by GustavoHalperin on 12/2/20.
//

import XCTest
@testable import DataStructureCollection

class QueueTest: XCTestCase {
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testQueue() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct
    // results.
    var queue = Dictionary<String, ListNode<Int> >()
    queue.enque(5)
    queue.enque(2)
    queue.enque(8)
    queue.enque(3)
    XCTAssertEqual(queue.deque(), 5)
    XCTAssertEqual(queue.deque(), 2)
    queue.enque(5)
    queue.enque(2)
    XCTAssertEqual(queue.deque(), 8)
    XCTAssertEqual(queue.deque(), 3)
    XCTAssertEqual(queue.deque(), 5)
    XCTAssertEqual(queue.deque(), 2)
    XCTAssertEqual(queue.deque(), nil)
  }
  
  func testQueuePerformance() {
    // This is an example of a performance test case.
    self.measure {
      var queue = Dictionary<String, ListNode<Int> >()
      
      
      for value in 1...100_000 { queue.enque(value) }
      for _ in 1...100_000 { _ = queue.deque() }
    }
  }
}
