import Foundation

/**
 Priority Queue (PQs) with an interlude on heaps.
 Heap: is a tree based DS that satisfies the heap invariant
 PQs on certain implementations of Dijkstra's Shortest Path algorithm.
   Best First Search (BFS) algorithms, grab the next most promising node
   Minimiun Spanning Tree (MST) algorithms.
 Big O: Construction O(n), Polling O(log(n)), Peeking O(1), Adding O(log(n))
   Removing and Contain O(n), with hash table O(log(n)) and O(1) 
 */
extension Array: PriorityQueueProtocol where Element: Comparable {
  // O(1) < O(log(n))
  public func poll() -> Element? {
    self.isEmpty ? nil : self.first
  }
  // O(log(n)) == O(log(n))
  public mutating func add(_ elem: Element) {
    self.append(elem)
    self.sort()
  }
  // O(n) = O(n)
  // With binary search O can be O(log(n))
  public mutating func remove(_ elem: Element) {
    guard let index = self.firstIndex(where: {$0 == elem} ) else {
      return
    }
    self.remove(at: index)
  }
  // O(n) = O(n)
  // With binary search O can be O(log(n))
  public func contain(elem:Element) -> Bool {
    return self.contains(elem)
  }
}
typealias PriorityQueue = Array
