class Node:
    def __init__(self, value):
        self.value = value 
        self.count = 1 
        self.l = None
        self.r = None

class BST:
    def __init__(self):
        self.root = None

    def insert(self, value):
        self.root = self.insert_rec(self.root, value)

    def insert_rec(self, root, value):
        if root is None:
            return Node(value)
        if value == root.value:
            root.count += 1
        elif value < root.value:
            root.l = self.insert_rec(root.l, value)
        else:
            root.r = self.insert_rec(root.r, value)
        return root

    def inorder_traversal_print(self):
        self.inorder_recursive_print_(self.root)

    def inorder_recursive_print_(self, root):
        if root is not None:
            self.inorder_recursive_print_(root.l)
            print(f"{root.value} : {root.count}")
            self.inorder_recursive_print_(root.r)