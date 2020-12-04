//
//  BFSTest.swift
//  
//
//  Created by GustavoHalperin on 12/3/20.
//

/**
 
 let connections: [(Int, [Int])] = [ (0, [1,9]), (1,[8]), (9,[8]), (8,[7]), (7, [10,11,6,3]), (3, [2,4]), (6,[5]) ]
 let bfs = Dictionary(edges:connections)
 let result = bfs.bfsConnectedElms(root:0)
 print("\nbfs.connectedElms()")
 print("using bfsD: \(result)")

 print("path between 0 to 4")
 print("pathD: \(bfs.bfsShorterPath(start: 0, end: 4))")
 let connections2: [(Int, [Int])] = [ (0, [1,9]), (1,[8,4]), (9,[8]), (8,[7]), (7, [10,11,6,3]), (3, [2,4]), (6,[5]) ]
 print("pathD 2: \(Dictionary(edges:connections2).bfsShorterPath(start: 0, end: 4))")

 */

import XCTest
@testable import DataStructureCollection

class BFSTest: XCTestCase {
  
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
    /**
              0 ------ 1------8------7-------10
              |                      |          |-------11
              9---------------|          |------- 6------5
                             |------- 3-------4
                                   |-------2
     */
    
    let connections: [(Int, [Int])] = [ (0, [1,9]), (1,[8]), (9,[8]), (8,[7]), (7, [10,11,6,3]), (3, [2,4]), (6,[5]) ]
    let bfs = Dictionary(edges:connections)
    let connected = bfs.bfsConnectedElms(root:0)
    let elements = connections.reduce(into: Set<Int>()){ $0.insert($1.0); $0 = $0.union($1.1)}.sorted()
    XCTAssertEqual(connected.0.sorted(), elements)
    XCTAssertEqual(connected.1, [Int]())

    let start = 0
    let end = 4
    let shorterPath = bfs.bfsShorterPath(start: start, end: end)
    XCTAssertEqual(shorterPath.keys.first, end)
    XCTAssertEqual(shorterPath[end]?.reversed(), [0,1,8,7,3])
  }
  
  func queuePerformance() {
    // This is an example of a performance test case.
    self.measure {
      var queue = Dictionary<String, ListNode<Int> >()
      
      
      for value in 1...100_000 { queue.addLast(value) }
      for _ in 1...100_000 { _ = queue.removeFirst() }
    }
  }
}
