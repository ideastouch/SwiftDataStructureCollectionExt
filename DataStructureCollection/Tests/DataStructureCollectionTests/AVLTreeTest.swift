//
//  AVLTreeTest.swift
//  
//
//  Created by GustavoHalperin on 12/2/20.
//

import XCTest
@testable import DataStructureCollection

class AVLTreeTest: XCTestCase {
  
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
  func testAVLTree() {
    var avlTreeTest = Dictionary< Int, AVLTreeNode<Int> >()
    [11,6,3].forEach { avlTreeTest.insert($0) }
    var levelOrder:[(Int,Int)] = avlTreeTest.levelorder()
    var levelOrderStr = levelOrder.map { "\($0.0)(\($0.1))" }.joined(separator: ",")
    XCTAssertEqual(levelOrderStr, "6(1),3(0),11(0)")
    [1,5,8,15].forEach { avlTreeTest.insert($0) }
    /**
        6
      3      11
     1  5  8  15
     */
    levelOrder = avlTreeTest.levelorder()
    levelOrderStr = levelOrder.map { "\($0.0)(\($0.1))" }.joined(separator: ",")
    XCTAssertEqual(levelOrderStr, "6(2),3(1),11(1),1(0),5(0),8(0),15(0)")
    [13,12].forEach { avlTreeTest.insert($0) }
    /**
        6                              6
      3        11               3              11
     1  5    8     15  ->  1   5       8      13
            13                            12  15
           12
     */
    levelOrder = avlTreeTest.levelorder()
    levelOrderStr = levelOrder.map { "\($0.0)(\($0.1))" }.joined(separator: ",")
    XCTAssertEqual(levelOrderStr, "6(3),3(1),11(2),1(0),5(0),8(0),13(1),12(0),15(0)")
    [14,17].forEach { avlTreeTest.insert($0) }
    /**
        6                              6                                   6                                6
      3        11               3              11                 3          11                  3              13
     1  5    8     15  ->  1   5       8      13     ->   1  5     8      13     ->  1   5      11        15
            13                            12  15                         12  15                   8  12   14  17
           12                                                                      14
     */
    levelOrder = avlTreeTest.levelorder()
    levelOrderStr = levelOrder.map { "\($0.0)(\($0.1))" }.joined(separator: ",")
    XCTAssertEqual(levelOrderStr, "6(3),3(1),13(2),1(0),5(0),11(1),15(1),8(0),12(0),14(0),17(0)")
     
    [19,22].forEach { avlTreeTest.insert($0) }
    /**
        6                              6                                   6                                6                                                13
      3        11               3              11                 3          11                  3              13                            6                 15
     1  5    8     15  ->  1   5       8      13     ->   1  5     8      13     ->  1   5      11        15       ->     3        11        14    19
            13                            12  15                         12  15                   8  12   14  17         1   5    8  12            17  22
           12                                                                      14                                        19
     */
    levelOrder = avlTreeTest.levelorder()
    levelOrderStr = levelOrder.map { "\($0.0)(\($0.1))" }.joined(separator: ",")
    XCTAssertEqual(levelOrderStr, "13(3),6(2),15(2),3(1),11(1),14(0),19(1),1(0),5(0),8(0),12(0),17(0),22(0)")
    
  }
  
  func queuePerformance() {
    // This is an example of a performance test case.
    self.measure {
    }
  }
}
