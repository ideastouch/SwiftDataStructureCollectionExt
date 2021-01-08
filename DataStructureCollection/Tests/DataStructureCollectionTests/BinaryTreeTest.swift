//
//  BinaryTreeTest.swift
//  
//
//  Created by GustavoHalperin on 12/2/20.
//

import XCTest
@testable import DataStructureCollection

class BinaryTreeTest: XCTestCase {
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  /**
              11 (4)
        6 (2))                  15 (3)
     3 (1)      8 (0)        13 (1)    17 (2)
   1 (0)  5 (0)           12(0)  14 (0)        19(1)
                             22 (0)
  */
  func testBinaryTree() {
    var binaryTreeTest = Dictionary< Int, BinaryTreeNode<Int> >()
    [11,6,3,1,5,8,15,13,12,14,17,19,22].forEach { binaryTreeTest.insert($0) }
    let inorder =  binaryTreeTest.inorder().map { "\($0)" }.joined(separator: ",")
    XCTAssertEqual(inorder, "1,3,5,6,8,11,12,13,14,15,17,19,22")
    let levelOrder:[Int] = binaryTreeTest.levelorder()
    let levelOrderStr = levelOrder.map { "\($0)" }.joined(separator: ",")
    XCTAssertEqual(levelOrderStr, "11,6,15,3,8,13,17,1,5,12,14,19,22")
  }
  
  func testQueuePerformance() {
    // This is an example of a performance test case.
    self.measure {
    }
  }
}
