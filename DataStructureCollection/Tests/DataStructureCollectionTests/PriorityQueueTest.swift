//
//  PriorityQueueTest.swift
//  
//
//  Created by GustavoHalperin on 12/14/20.
//
//

import XCTest
@testable import DataStructureCollection

class PriorityQueueTest: XCTestCase {
  
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
    var priorityQueue = PriorityQueue<Int>()
    
    priorityQueue.insert(1,.max)
    priorityQueue.insert(2,.max)
    XCTAssertEqual(priorityQueue, [2,1])
    priorityQueue.insert(3,.max)
    XCTAssertEqual(priorityQueue, [3,1,2])
    priorityQueue.insert(4,.max)
    XCTAssertEqual(priorityQueue, [4,3,2,1])
    XCTAssertEqual(priorityQueue.pull(.max), 4)
    XCTAssertEqual(priorityQueue.pull(.max), 3)
    XCTAssertEqual(priorityQueue.pull(.max), 2)
    XCTAssertEqual(priorityQueue.pull(.max), 1)
    XCTAssertEqual(priorityQueue, [])
    
    priorityQueue.insert(1,.min)
    priorityQueue.insert(2,.min)
    XCTAssertEqual(priorityQueue, [1,2])
    priorityQueue.insert(3,.min)
    XCTAssertEqual(priorityQueue, [1,2,3])
    priorityQueue.insert(4,.min)
    XCTAssertEqual(priorityQueue, [1,2,3,4])
    XCTAssertEqual(priorityQueue.pull(.min), 1)
    XCTAssertEqual(priorityQueue.pull(.min), 2)
    XCTAssertEqual(priorityQueue.pull(.min), 3)
    XCTAssertEqual(priorityQueue.pull(.min), 4)
    XCTAssertEqual(priorityQueue, [])
    
    priorityQueue.insert(1,.min)
    priorityQueue.insert(10,.min)
    XCTAssertEqual(priorityQueue, [1,10])
    priorityQueue.insert(4,.min)
    XCTAssertEqual(priorityQueue, [1, 10,4])
    priorityQueue.insert(5,.min)
    XCTAssertEqual(priorityQueue, [1, 5,4, 10])
    priorityQueue.insert(12,.min)
    XCTAssertEqual(priorityQueue, [1, 5,4, 10,12])
    priorityQueue.insert(11,.min)
    XCTAssertEqual(priorityQueue, [1, 5,4, 10,12,11])
    priorityQueue.insert(15,.min)
    XCTAssertEqual(priorityQueue, [1, 5,4, 10,12,11,15])
    priorityQueue.insert(8,.min)
    XCTAssertEqual(priorityQueue, [1, 5,4, 8,12,11,15, 10])
    priorityQueue.insert(9,.min)
    XCTAssertEqual(priorityQueue, [1, 5,4, 8,12,11,15, 10,9])
    priorityQueue.insert(2,.min)
    XCTAssertEqual(priorityQueue, [1, 2,4, 8,5,11,15, 10,9,12])
    XCTAssertEqual(priorityQueue.pull(.min), 1)
    XCTAssertEqual(priorityQueue, [2, 5,4, 8,12,11,15, 10,9])
    XCTAssertEqual(priorityQueue.pull(.min), 2)
    XCTAssertEqual(priorityQueue, [4, 5,9, 8,12,11,15, 10])
    XCTAssertEqual(priorityQueue.pull(.min), 4)
    XCTAssertEqual(priorityQueue, [5, 8,9, 10,12,11,15])
    XCTAssertEqual(priorityQueue.pull(.min), 5)
    XCTAssertEqual(priorityQueue, [8, 10,9, 15,12,11])
    XCTAssertEqual(priorityQueue.pull(.min), 8)
    XCTAssertEqual(priorityQueue, [9, 10,11, 15,12])
  }
  
  func testQueuePerformance() {
    // This is an example of a performance test case.
//    self.measure {
//      var queue = Dictionary<String, ListNode<Int> >()
//
//
//      for value in 1...100_000 { queue.addLast(value) }
//      for _ in 1...100_000 { _ = queue.removeFirst() }
//    }
  }
}
