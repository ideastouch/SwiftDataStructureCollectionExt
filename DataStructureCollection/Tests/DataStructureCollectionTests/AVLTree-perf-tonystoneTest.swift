//
//  Test.m
//  
//
//  Created by GustavoHalperin on 12/27/20.
//

import XCTest
@testable import DataStructureCollection


typealias AVLTree<T:Comparable&Hashable> = Dictionary< T, AVLTreeNode<T> >
extension AVLTree
where Key: Comparable, Value: AVLTreeNodeProtocol, Key == Value.Key, Value.Key == Value.Value
{
  var balanced:Bool { true }
}


class AVLTreePerfTonystoneTests: XCTestCase {
  // MARK: - Performance measurements

  func testSearchPerformance() {

    let tree = { () -> Dictionary< Int, AVLTreeNode<Int> > in //AVLTree<Int> in
          var tree = Dictionary< Int, AVLTreeNode<Int> >() //AVLTree<Int>()

          /// Prime the tree with initial values
          for i in stride(from: 0, to: 64000, by: 2) {    /// 32,000 initial values in tree
              tree.insert(i) //value: i)
          }
          return tree
      }()
      let input = stride(from: 0, to: 20000, by: 2) /// 10,000 iterations for the test matching stride of tree

    // Time: 0.001 ~ 0.003 sec dictionary O(1)
    // Time: 0.049 vs 0.062 sec vs 0.024 sec
    // insertRetracingCounter called 159_860 vs Balance counter 447_232
      measure {
          for value in input {
            let _ = tree.findNode(value)
          }
      }
  }

  func testInsertPerformance() {

      var tree = { () -> Dictionary< Int, AVLTreeNode<Int> > in // AVLTree<Int> in
          var tree = Dictionary< Int, AVLTreeNode<Int> >() //AVLTree<Int>()
          ///
          /// Prime the tree with initial values
          /// Increment by 2 to allow room to insert using a stride starting at 1 for the input
          ///
          for i in stride(from: 0, to: 64000, by: 2) {    /// 32,000 initial values in tree
              tree.insert(i) //value: i)
          }
          return tree
      }()
      let input = stride(from: 1, to: 20001, by: 2) /// 10,000 iterations for the test
    // Time: 0.132 ~ 0.196~0.333 sec vs 0.276 sec, 0.335 sec
    // Wikipedia, Time: 0.070 ~ 0.102 sec
    // insertRetracingCounter called 179_870 vs Balance counter 1_947_232
      measure {
          for value in input {
              tree.insert(value) //value: value)
          }
      }
  }

  func testDeletePerformance() {

      var tree = { () -> Dictionary< Int, AVLTreeNode<Int> > in //AVLTree<Int> in
          var tree = Dictionary< Int, AVLTreeNode<Int> >() //AVLTree<Int>()
          ///
          /// Prime the tree with initial values
          /// Increment by 2 to allow room to insert using a stride starting at 1 for the input
          ///
          for i in stride(from: 0, to: 64000, by: 2) {    /// 32,000 initial values in tree
              tree.insert(i) //value: i)
          }
          return tree
      }()
    // insertRetracingCounter called 159860 vs Balance counter 447232
      let input = stride(from: 0, to: 20000, by: 2) /// 10,000 iterations for the test
    // Time: 0.074~0.284  sec vs 0.213 sec, 0.256 sec
    // Wikipedia, Time: 0.101 ~ 0.112 sec
    // removeRetracingCounter called 0 vs
      measure {
          for value in input {
              tree.remove(value) //delete(value: value)
          }
      }
  }

  func testInsertDeleteBestTimePerformance() {

      var tree = { () -> Dictionary< Int, AVLTreeNode<Int> > in //AVLTree<Int> in
          return Dictionary< Int, AVLTreeNode<Int> >() //AVLTree<Int>()
      }()
      let input = (iterations: 0..<5000, values: [2, 1])  /// We have a total of 20,000 operations 5,000 x (2 inserts + 2 deletes)

      // Time:  0.365~0.417  sec vs 0.025 sec,  0.408 sec
    // Wikipedia, Time: 0.276 ~ 0.407 sec
    // insertRetracingCounter called 99_999 vs Balance counter 199_999
      measure {
          for _ in input.iterations {
              for value in input.values {
                  tree.insert(value) //value: value)
              }
              for value in input.values.reversed() {
                  tree.remove(value) //delete(value: value)
              }
          }
      }
  }

  func testInsertDeleteWorstTimePerformance() {

      var tree = { () -> Dictionary< Int, AVLTreeNode<Int> > in //AVLTree<Int> in
          var tree = Dictionary< Int, AVLTreeNode<Int> >() //AVLTree<Int>()
          ///
          /// Prime the tree with initial values
          /// Increment by 2 to allow room to insert using a stride starting at 1 for the input
          ///
          for i in stride(from: 0, to: 64000, by: 2) {    /// 32,000 initial values in tree
              tree.insert(i) //value: i)
          }
          return tree
      }()
      let input = (iterations: 0..<5_000, values: [63987, 63989])  /// We have a total of 20,000 operations 5,000 x (2 inserts + 2 deletes)

    // Time: 1.871 ~ 3.077 ~ 3.136 ~ 5.156 sec vs 0.512 sec
    // Wikipedia, Time: 1.110 vs 1.359 sec
    // insertRetracingCounter called 359_860 vs Balance counter 199_999
    measure {
        for _ in input.iterations {
            for value in input.values {
                tree.insert(value) //value: value)
            }
            for value in input.values.reversed() {
                tree.remove(value) //delete(value: value)
            }
        }
    }
  }
  
  func testSmallTreeInsertDeleteWorstTimePerformance() {

      var tree = { () -> Dictionary< Int, AVLTreeNode<Int> > in //AVLTree<Int> in
          var tree = Dictionary< Int, AVLTreeNode<Int> >() //AVLTree<Int>()
          ///
          /// Prime the tree with initial values
          /// Increment by 2 to allow room to insert using a stride starting at 1 for the input
          ///
          for i in stride(from: 0, to: 2_000, by: 2) {    /// 1_000 initial values in tree
              tree.insert(i) //value: i)
          }
          return tree
      }()
      let input = (iterations: 0..<5_000, values: [1_987, 1_989])  /// We have a total of 20,000 operations 5,000 x (2 inserts + 2 deletes)

    // Wikipedia, Time: 0.796 ~ 1.195 vs 0.354 sec
    measure {
        for _ in input.iterations {
            for value in input.values {
                tree.insert(value) //value: value)
            }
            for value in input.values.reversed() {
                tree.remove(value) //delete(value: value)
            }
        }
    }
  }
}
