import XCTest
@testable import DataStructureCollection

final class DataStructureCollectionTests: XCTestCase {
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
  
  static var allTests = [
    ("testQueue", testQueue),
  ]
}
