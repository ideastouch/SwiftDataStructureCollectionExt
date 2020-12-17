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
  // O(1)
  public func peek(_ order:PriorityQueueOrder) -> Element? { self.first }
  // O(log(n)) == O(log(n))
  public mutating func insert(_ elm: Element, _ order:PriorityQueueOrder) {
    self.append(elm)
    self.bubbleUp(self.count - 1, order)
  }
  // O(log(n))
  public mutating func pull(_  order:PriorityQueueOrder) -> Element? {
    let first = self.first
    if count >= 2 {
      self[0] = self[count - 1]
      self.remove(at: count - 1)
      self.bubbleDown(0, order)
    } else { self.clean() }
    return first
  }
  private mutating func bubbleUp(_ index:Int, _ order:PriorityQueueOrder) {
    guard let father = self.getFather(index) else { return }
    let child = (self[index], index)
    if child.1 == order.prioritize(left: child, right: father).0?.1 {
      // child is the best, so we should bubblue child up
      self[father.1] = child.0
      self[child.1] = father.0
      self.bubbleUp(father.1, order)
    }
  }
  private mutating func bubbleDown(_ index:Int, _ order:PriorityQueueOrder) {
    let father = (self[index], index)
    let childrens = getChildrens(index)
    let touple = order.prioritize(left: childrens.0, right: childrens.1)
    if let best = touple.0,
       father.1 != order.prioritize(left: father, right: touple.0).0?.1 {
      // Best isn't father therefore we should buble father down.
      self[father.1] = best.0
      self[best.1] = father.0
      return self.bubbleDown(best.1, order)
    }
    if let worse = touple.1,
       father.1 != order.prioritize(left: father, right: worse).0?.1 {
      // Best isn't father therefore we should buble father down.
      self[father.1] = worse.0
      self[worse.1] = father.0
      return self.bubbleDown(worse.1, order)
    }
  }
  private func getChildrens(_ index:Int) -> ((Element,Int)?, (Element,Int)?) {
    let index = (index + 1) * 2
    return ( (index <= self.count ? (self[index - 1],index - 1) : nil),
             (index < self.count ? (self[index], index) : nil) )
  }
  private func getFather(_ index:Int) -> (Element,Int)? {
    if index == 0 { return nil }
    let index = ( (index + 1 ) / 2 ) -  1
    return (self[index], index)
  }
}
public
typealias PriorityQueue = Array
