///
///  AVLTreeTests.swift
///
///  Copyright (c) 2016 Tony Stone
///
///  Licensed under the Apache License, Version 2.0 (the "License");
///  you may not use this file except in compliance with the License.
///  You may obtain a copy of the License at
///
///  http://www.apache.org/licenses/LICENSE-2.0
///
///  Unless required by applicable law or agreed to in writing, software
///  distributed under the License is distributed on an "AS IS" BASIS,
///  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
///  See the License for the specific language governing permissions and
///  limitations under the License.
///
///  Created by Tony Stone on 11/26/2016.
///


import XCTest
import DataStructureCollection

//@testable import avltree_swift

///
/// Test AVL Trees
///
/// AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25)
///
/// 1)         8
///          /   \
/// 2)      5     15
///        / \    / \
/// 3)    1   7  10  20
///                 /  \
/// 4)             17  25
///
///
/// AVLTree<String>(arrayLiteral: "A", "B", "C")
/// AVLTree<String>(arrayLiteral: "C", "B", "A")
/// AVLTree<String>(arrayLiteral: "C", "A", "B")
///
/// 1)      B
///        /  \
/// 2)    A    C
///

///
/// Main Test class
///

import XCTest
@testable import DataStructureCollection


//typealias AVLTree<T:Comparable&Hashable> = Dictionary< T, AVLTreeNode<T> >
//extension AVLTree
//where Key: Comparable, Value: AVLTreeNodeProtocol, Key == Value.Key, Value.Key == Value.Value
//{
//  var balanced:Bool { true }
//}

class AVLTreeTonystoneTests: XCTestCase {

    // MARK: Rotation func Tests

    func testLeftRotation() {
      var input = AVLTree<String>()
      ["A", "B", "C"].forEach { input.insert($0) }
        let expected = (height: 2, balanced: true)

        XCTAssertEqual(input.height, expected.height)
        XCTAssertEqual(input.balanced, expected.balanced)
    }

    func testRightRotation() {
        var input = AVLTree<String>()
      ["C", "B", "A"].forEach { input.insert($0) }
        let expected = (height: 2, balanced: true)

        XCTAssertEqual(input.height, expected.height)
        XCTAssertEqual(input.balanced, expected.balanced)
    }

    func testLeftRightRotation() {
        var input = AVLTree<String>()
      ["C", "A", "B"].forEach { input.insert($0) }
        let expected = (height: 2, balanced: true)

        XCTAssertEqual(input.height, expected.height)
        XCTAssertEqual(input.balanced, expected.balanced)
    }

    func testRightLeftRotation() {
        var input = AVLTree<String>()
      ["A", "C", "B"].forEach { input.insert($0) }
        let expected = (height: 2, balanced: true)

        XCTAssertEqual(input.height, expected.height)
        XCTAssertEqual(input.balanced, expected.balanced)
    }

    // MARK: Height Tests

    func testHeightEmptyTree() {
        let input = AVLTree<Int>()
        let expected = 0

        XCTAssertEqual(input.height, expected)
    }

    func testHeight() {
        var input = AVLTree<Int>()
      [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { input.insert($0) }
        let expected = 4

        XCTAssertEqual(input.height, expected)
    }

    func testBalancedEmptyTree() {
        let input = AVLTree<Int>()
        let expected = true

        XCTAssertEqual(input.balanced, expected)
    }

    func testBalanced9NodeTree() {
        var input = AVLTree<Int>()
      [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { input.insert($0) }
        let expected = true

        XCTAssertEqual(input.balanced, expected)
    }

    func testBalanced1NodeTree() {
        var input = AVLTree<Int>()
      [1].forEach { input.insert($0) }
        let expected = true

        XCTAssertEqual(input.balanced, expected)
    }

    func testBalanced2NodeTree() {
        var input = AVLTree<Int>()
      [1, 5].forEach { input.insert($0) }
        let expected = true

        XCTAssertEqual(input.balanced, expected)
    }

    func testBalanced3NodeRightHeavyTree() {
        var input = AVLTree<Int>()
      [1, 5, 8].forEach { input.insert($0) }
        let expected = true

        XCTAssertEqual(input.balanced, expected)
    }

    func testHeight3NodeRightHeavyTree() {
        var input = AVLTree<Int>()
      [1, 5, 8].forEach { input.insert($0) }
        let expected = 2

        XCTAssertEqual(input.height, expected)
    }

    func testBalanced3NodeLeftHeavyTree() {
        var input = AVLTree<Int>()
      [8, 5, 1].forEach { input.insert($0) }
        let expected = true

        XCTAssertEqual(input.balanced, expected)
    }

    func testHeight3NodeLeftHeavyTree() {
        var input = AVLTree<Int>()
      [8, 5, 1].forEach { input.insert($0) }
        let expected = 2

        XCTAssertEqual(input.height, expected)
    }

    func testBalanced3NodeLeftRightHeavyTree() {
        var input = AVLTree<Int>()
      [8, 1, 5].forEach { input.insert($0) }
        let expected = true

        XCTAssertEqual(input.balanced, expected)
    }

    func testHeight3NodeLeftRightHeavyTree() {
        var input = AVLTree<Int>()
      [8, 1, 5].forEach { input.insert($0) }
        let expected = 2

        XCTAssertEqual(input.height, expected)
    }

    func testBalanced3NodeOrderedTree() {
        var input = AVLTree<Int>()
      [5, 1, 8].forEach { input.insert($0) }
        let expected = true

        XCTAssertEqual(input.balanced, expected)
    }

    func testInsertNonExisting30() {
        var tree = AVLTree<Int>()
      [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert($0) }
        let input = 30
        let expected = 30

        tree.insert(input)

        XCTAssertEqual(tree[input]?.value, expected)
    }

    func testInsertLeftA() {
        var tree = AVLTree<String>()
      ["X", "Y", "Z"].forEach { tree.insert($0) }
        let input = ["A", "B", "C"]
        let expected = (height: 3, balanced: true, present: ["A", "B", "C", "X", "Y", "Z"])

        for value in input {
            tree.insert(value)
        }

        XCTAssertEqual(tree.balanced, expected.balanced)
        XCTAssertEqual(tree.height, expected.height)
        for value in expected.present {
            XCTAssertNotNil(tree[value])
        }
    }

    func testInsertLeftnegative1() {
      var tree = AVLTree<String>(); ["A", "B", "C"].forEach { tree.insert($0) }
        let input = "-1"
        let expected = "-1"

        tree.insert(input)

        XCTAssertEqual(tree[input]?.value, expected)
    }

    func testInsertExisting8() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert($0) }
        let input = 8
        let expected = 8

        tree.insert(input)

        XCTAssertEqual(tree[input]?.value, expected)
    }

    func testDeleteNonExisting30() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert($0) }
        let input = 30
        let expected: Int? = nil

        _ = tree.remove(input)

        XCTAssertEqual(tree[input]?.value, expected)
    }

    func testDeleteRoot1NodeTree() {
      var tree = AVLTree<Int>(); tree.insert(1)
        var input = (tree: tree, value: 1)
        let expected: (height: Int, balanced: Bool, value: Int?) = (0, true, nil)

        _ = input.tree.remove(input.value)

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)
        XCTAssertEqual(input.tree[input.value]?.value, expected.value)
    }

    func testDeleteRoot3NodeTree() {
      var tree = AVLTree<String>(); ["C", "B", "A"].forEach { tree.insert($0) }
        var input = (tree: tree, value: "B")
        let expected: (height: Int, balanced: Bool, value: String?) = (2, true, nil)

        input.tree.remove(input.value)

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)
        XCTAssertEqual(input.tree[input.value]?.value, expected.value)
    }

    func testDeleteExisting1() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach {tree.insert( $0 )}
      var input = (tree:tree, values: [1])
        let expected = (height: 4, balanced: true, present: [5, 8, 7, 10, 15, 20, 17, 25], missing: [1])

        for value in input.values {
            _ = input.tree.remove(value)
        }

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)

        for value in expected.present {
            XCTAssertNotNil(input.tree[value], "Expected value \(value) to be present but was missing.")
        }
        for value in expected.missing {
            XCTAssertNil(input.tree[value], "Expected value \(value) to be missing but was present.")
        }
    }

    func testDeleteExisting5() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
      var input = (tree: tree, values: [5])
        let expected = (height: 4, balanced: true, present: [1, 8, 7, 10, 15, 20, 17, 25], missing: [5])

        for value in input.values {
            input.tree.remove(value)
        }

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)

        for value in expected.present {
            XCTAssertNotNil(input.tree[value], "Expected value \(value) to be present but was missing.")
        }
        for value in expected.missing {
            XCTAssertNil(input.tree[value], "Expected value \(value) to be missing but was present.")
        }
    }

    func testDeleteExisting7() {
    var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
      var input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), values: [7])
        let expected = (height: 4, balanced: true, present: [1, 5, 8, 10, 15, 20, 17, 25], missing: [7])

        for value in input.values {
            input.tree.remove(value)
        }

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)

        for value in expected.present {
            XCTAssertNotNil(input.tree[value], "Expected value \(value) to be present but was missing.")
        }
        for value in expected.missing {
            XCTAssertNil(input.tree[value], "Expected value \(value) to be missing but was present.")
        }
    }

    func testDeleteExisting8() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
      var input = (tree: tree, values: [8])
        let expected = (height: 4, balanced: true, present: [1, 5, 7, 10, 15, 20, 17, 25], missing: [8])

        for value in input.values {
            input.tree.remove(value)
        }

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)

        for value in expected.present {
            XCTAssertNotNil(input.tree[value], "Expected value \(value) to be present but was missing.")
        }
        for value in expected.missing {
            XCTAssertNil(input.tree[value], "Expected value \(value) to be missing but was present.")
        }
    }

    func testDeleteExisting10() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
      var input = (tree: tree, values: [10])
        let expected = (height: 4, balanced: true, present: [1, 5, 8, 7, 15, 20, 17, 25], missing: [10])

        for value in input.values {
            input.tree.remove(value)
        }

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)

        for value in expected.present {
            XCTAssertNotNil(input.tree[value], "Expected value \(value) to be present but was missing.")
        }
        for value in expected.missing {
            XCTAssertNil(input.tree[value], "Expected value \(value) to be missing but was present.")
        }
    }

    func testDeleteExistingLeafNodesForceReBalance() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
      var input = (tree: tree, values: [1, 7, 10, 17, 25])
        let expected = (height: 3, balanced: true, present: [5, 8, 15, 20], missing: [1, 7, 10, 17, 25])

        for value in input.values {
            input.tree.remove(value)
        }

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)

        for value in expected.present {
            XCTAssertNotNil(input.tree[value], "Expected value \(value) to be present but was missing.")
        }
        for value in expected.missing {
            XCTAssertNil(input.tree[value], "Expected value \(value) to be missing but was present.")
        }
    }

    func testDeleteExistingLeafNodesNoReBalance() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
      var input = (tree: tree, values: [25, 17, 10, 7, 1])
        let expected = (height: 3, balanced: true, present: [5, 8, 15, 20], missing: [25, 17, 10, 7, 1])

        for value in input.values {
            input.tree.remove(value)
        }

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)

        for value in expected.present {
            XCTAssertNotNil(input.tree[value], "Expected value \(value) to be present but was missing.")
        }
        for value in expected.missing {
            XCTAssertNil(input.tree[value], "Expected value \(value) to be missing but was present.")
        }
    }

    func testDeleteExistingInnerNodes() {
      var tree =  AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
      var input = (tree:tree, values: [5, 8, 20])
        let expected = (height: 3, balanced: true, present: [1, 7, 10, 15, 17, 25], missing: [5, 8, 20])

        for value in input.values {
            input.tree.remove(value)
        }

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)

        for value in expected.present {
            XCTAssertNotNil(input.tree[value], "Expected value \(value) to be present but was missing.")
        }
        for value in expected.missing {
            XCTAssertNil(input.tree[value], "Expected value \(value) to be missing but was present.")
        }
    }

    func testDeleteExistingSingleLeftNode() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
      var input = (tree: tree, values: [7, 5])
        let expected = (height: 3, balanced: true, present: [1, 8, 10, 15, 20, 17, 25], missing: [7, 5])

        for value in input.values {
            input.tree.remove(value)
        }

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)

        for value in expected.present {
            XCTAssertNotNil(input.tree[value], "Expected value \(value) to be present but was missing.")
        }
        for value in expected.missing {
            XCTAssertNil(input.tree[value], "Expected value \(value) to be missing but was present.")
        }
    }

    func testDeleteExistingAllBut3() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
      var input = (tree: tree, values: [5, 8, 7, 15, 20, 17])
        let expected = (height: 2, balanced: true, present: [1, 10, 25], missing: [5, 8, 7, 15, 20, 17])

        for value in input.values {
            input.tree.remove(value)
        }

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)

        for value in expected.present {
            XCTAssertNotNil(input.tree[value], "Expected value \(value) to be present but was missing.")
        }
        for value in expected.missing {
            XCTAssertNil(input.tree[value], "Expected value \(value) to be missing but was present.")
        }
    }

    func testDeleteExistingAllBut1() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
      var input = (tree: tree, values: [1, 5, 8, 7, 10, 15, 20, 17])
        let expected = (height: 1, balanced: true, present: [25], missing: [1, 5, 8, 7, 10, 15, 20, 17])

        for value in input.values {
            input.tree.remove(value)
        }

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)

        for value in expected.present {
            XCTAssertNotNil(input.tree[value], "Expected value \(value) to be present but was missing.")
        }
        for value in expected.missing {
            XCTAssertNil(input.tree[value], "Expected value \(value) to be missing but was present.")
        }
    }

    func testDeleteExistingAll() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
      var input = (tree: tree, values: [1, 5, 8, 7, 10, 15, 20, 17, 25])
        let expected = (height: 0, balanced: true, present: [] as [Int], missing: [1, 5, 8, 7, 10, 15, 20, 17, 25])

        for value in input.values {
            input.tree.remove(value)
        }

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)

        for value in expected.present {
            XCTAssertNotNil(input.tree[value], "Expected value \(value) to be present but was missing.")
        }
        for value in expected.missing {
            XCTAssertNil(input.tree[value], "Expected value \(value) to be missing but was present.")
        }
    }

    func testSearchExisting1() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
      var input = (tree: tree, value: 1)
        let expected = 1

        XCTAssertEqual(input.tree[input.value]?.value, expected)
    }

    func testSearchExisting8() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
      var input = (tree: tree, value: 8)
        let expected = 8

        XCTAssertEqual(input.tree[input.value]?.value, expected)
    }

    func testSearchExisting25() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
        let input = (tree: tree, value: 25)
        let expected = 25

        XCTAssertEqual(input.tree[input.value]?.value, expected)
    }

    func testSearchNonExisting0() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
      var input = (tree: tree, value: 0)
        let expected: Int? = nil

        XCTAssertEqual(input.tree[input.value]?.value, expected)
    }

    func testSearchNonExisting30() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
      var input = (tree: tree, value: 30)
        let expected: Int? = nil

        XCTAssertEqual(input.tree[input.value]?.value, expected)
    }

    func testNextOf1() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
      var input = (tree: tree, value: 1)
        let expected = 5

      let inorder = tree.inorder()
      if let index = inorder.firstIndex(of:input.value), index+1 < inorder.count {
        XCTAssertEqual(inorder[index+1], expected)
//        if let node = input.tree[input.value] {
//            XCTAssertEqual(input.tree.next(node: node)?.value, expected)
        } else {
            XCTFail("Expected value '\(expected)' not found in tree \(input.tree).")
        }
    }

    func testNextOf7() {
      var tree =  AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
      var input = (tree: tree, value: 7)
        let expected = 8
      
      let inorder = tree.inorder()
      if let index = inorder.firstIndex(of:input.value), index+1 < inorder.count {
        XCTAssertEqual(inorder[index+1], expected)
//        if let node = input.tree[input.value] {
//            XCTAssertEqual(input.tree.next(node: node)?.value, expected)
        } else {
            XCTFail("Expected value '\(expected)' not found in tree \(input.tree).")
        }
    }

    func testNextOf8() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
        var input = (tree: tree, value: 8)
        let expected = 10
      
      let inorder = tree.inorder()
      if let index = inorder.firstIndex(of:input.value), index+1 < inorder.count {
        XCTAssertEqual(inorder[index+1], expected)
//        if let node = input.tree.search(value: input.value) {
//            XCTAssertEqual(input.tree.next(node: node)?.value, expected)
        } else {
            XCTFail("Expected value '\(expected)' not found in tree \(input.tree).")
        }
    }

    func testNextOf10() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
        var input = (tree: tree, value: 10)
        let expected = 15
      
      let inorder = tree.inorder()
      if let index = inorder.firstIndex(of:input.value), index+1 < inorder.count {
        XCTAssertEqual(inorder[index+1], expected)
//        if let node = input.tree.search(value: input.value) {
//            XCTAssertEqual(input.tree.next(node: node)?.value, expected)
        } else {
            XCTFail("Expected value '\(expected)' not found in tree \(input.tree).")
        }
    }

    func testNextOf15() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
        let input = (tree: tree, value: 15)
        let expected = 17
      
      let inorder = tree.inorder()
      if let index = inorder.firstIndex(of:input.value), index+1 < inorder.count {
        XCTAssertEqual(inorder[index+1], expected)
//        if let node = input.tree.search(value: input.value) {
//            XCTAssertEqual(input.tree.next(node: node)?.value, expected)
        } else {
            XCTFail("Expected value '\(expected)' not found in tree \(input.tree).")
        }
    }

    func testNextOf25() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
        let input = (tree: tree, value: 25)
        let expected: Int? = nil
      
      let inorder = tree.inorder()
      if let index = inorder.firstIndex(of:input.value) {
        XCTAssertEqual(index, inorder.count - 1)
//        if let node = input.tree.search(value: input.value) {
//            XCTAssertEqual(input.tree.next(node: node)?.value, expected)
        } else {
            XCTFail("Expected value '\((expected != nil) ? String(describing: expected) : "nil")' not found in tree \(input.tree).")
        }
    }

    func testPreviousOf1() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
        let input = (tree: tree, value: 1)
        let expected: Int? = nil
      
      let inorder = tree.inorder()
      if let index = inorder.firstIndex(of:input.value) {
        XCTAssertEqual(index, 0)
//        if let node = input.tree.search(value: input.value) {
//            XCTAssertEqual(input.tree.previous(node: node)?.value, expected)
        } else {
            XCTFail("Expected value '\((expected != nil) ? String(describing: expected) : "nil")' not found in tree \(input.tree).")
        }
    }

    func testPreviousOf8() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
        var input = (tree: tree, value: 8)
        let expected = 7
      
      let inorder = tree.inorder()
      if let index = inorder.firstIndex(of:input.value), index-1 >= 0 {
        XCTAssertEqual(inorder[index-1], expected)
//        if let node = input.tree.search(value: input.value) {
//            XCTAssertEqual(input.tree.previous(node: node)?.value, expected)
        } else {
            XCTFail("Expected value '\(expected)' not found in tree \(input.tree).")
        }
    }

    func testPreviousOf10() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
        var input = (tree: tree, value: 10)
        let expected = 8
      
      let inorder = tree.inorder()
      if let index = inorder.firstIndex(of:input.value), index-1 >= 0 {
        XCTAssertEqual(inorder[index-1], expected)
//        if let node = input.tree.search(value: input.value) {
//            XCTAssertEqual(input.tree.previous(node: node)?.value, expected)
        } else {
            XCTFail("Expected value '\(expected)' not found in tree \(input.tree).")
        }
    }

    func testPreviousOf15() {
      var tree =  AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
        var input = (tree: tree, value: 15)
        let expected = 10
      
      let inorder = tree.inorder()
      if let index = inorder.firstIndex(of:input.value), index-1 >= 0 {
        XCTAssertEqual(inorder[index-1], expected)
//        if let node = input.tree.search(value: input.value) {
//            XCTAssertEqual(input.tree.previous(node: node)?.value, expected)
        } else {
            XCTFail("Expected value '\(expected)' not found in tree \(input.tree).")
        }
    }

    func testPreviousOf17() {
      var tree = AVLTree<Int>(); [1, 5, 8, 7, 10, 15, 20, 17, 25].forEach { tree.insert( $0) }
        var input = (tree: tree, value: 17)
        let expected = 15
      
      let inorder = tree.inorder()
      if let index = inorder.firstIndex(of:input.value), index-1 >= 0 {
        XCTAssertEqual(inorder[index-1], expected)
//        if let node = input.tree.search(value: input.value) {
//            XCTAssertEqual(input.tree.previous(node: node)?.value, expected)
        } else {
            XCTFail("Expected value '\(expected)' not found in tree \(input.tree).")
        }
    }
  
  func testInsertMultipleRotations() {
    var tree = AVLTree<Int>(); [11,6,3,1,5,8,15,13,12,12,17,19,22].forEach { tree.insert( $0) }
    let input = (tree: tree, value:17)
    let root = 13
    
    if let node = input.tree.findNode(root) {
      XCTAssertEqual(node.height+1, input.tree.height)
    } else {
        XCTFail("Expected value '\(root)' not found in tree \(input.tree).")
    }
  }
}

