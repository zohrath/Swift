import Foundation

//Binary Search Tree implementation
class Node {
    
    var value: Int?
    var left : Node?
    var right: Node?
    
    init(value: Int) {
        self.value = value
    }
    
    func insert(node: Node) {
        if self.value == nil {
            self.value = node.value
        }
        if node.value! < self.value! {
            insert(node: self.left!)
        }
        if node.value == self.value {
            self.value! += node.value!
        }
        if node.value! > self.value! {
            insert(node: self.right!)
        }
    }
    
    func read(node: Node) {
        if (self.left != nil) {
            self.read(node: self.left!)
        }
        
    }
    
}
