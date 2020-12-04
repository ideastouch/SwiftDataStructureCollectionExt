import Foundation

/**
 Breadth First Search (BFS) graph traversal, similiar to Binary tree level order.
 */
extension Dictionary
where Key: Comparable, Value == [Key]//, Key: CustomStringConvertible
{
  public init (edges:[(Key,Key)], reverse:Bool = false) {
    self.init()
    edges.forEach {
      let key = reverse ? $0.1 : $0.0
      let value = reverse ? $0.0 : $0.1
      let list = ( self[key] ?? [Key]() ) + [value]
      self[key] = list
    }
  }
  public init (edges:[(Key,[Key])]) {
    self.init()
    edges.forEach { self[$0.0] = $0.1 }
  }
  public init(edges:[Key:[Key]]) {
    self = edges
  }
  
  public func bfsConnectedElms(root:Key) -> ([Key], [Key]) {
    var unvisited = Set<Key>( Array(self.keys) )
    var visited = Set<Key>()
    var visitedFirst = [Key]()
    var onTheFrontier = Dictionary<String, ListNode<Key> >()
    onTheFrontier.enque(root)
    while let node = onTheFrontier.deque() {
      if visited.contains(node) == false { visitedFirst.append(node) }
      visited.insert(node)
      unvisited.remove(node)
      self[node]?.filter { visited.contains($0) == false }.forEach {  onTheFrontier.enque($0) }
    }
    return ( visitedFirst,
             Array(unvisited) )
  }
  
  /**
   Improvement: Check when we visitied all the neighbours or end
   */
  public func bfsShorterPath(start:Key, end:Key? = nil) -> [Key:[Key]] {
    var paths = [Key:[Key]]()
    var visited = Set<Key>()
    var onTheFrontier = Dictionary<String, ListNode<Key> >()
    onTheFrontier.enque(start)
    visited.insert(start)
    while let node = onTheFrontier.deque() {
      guard let neigbours = self[node] else {
        continue
      }
      neigbours.filter { visited.contains($0) == false }.forEach {
        onTheFrontier.enque($0)
        visited.insert($0)
        guard let path = paths[$0] else {
          paths[$0] = [node] + (paths[node] ?? [Key]())
          return
        }
        guard path.count >= 1 + (paths[node]?.count ?? 0) else { return }
        paths[$0] = [node] + (paths[node] ?? [Key]())
      }
    }
    if let end = end, let path = paths[end] { return [end:path] }
    return paths
  }
}
