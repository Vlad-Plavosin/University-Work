type String = [Char]
type Pair a b = (a,b)

data BinaryTree a = Empty | Node a (BinaryTree a) (BinaryTree a) deriving Show

treeMap :: BinaryTree a -> (a -> b) => BinaryTree BinaryTree
treeMap Empty _ = Empty
treeMap (Node v l r) f = Node (f v) (treeMap l f) (treeMap r f)

myTree :: BinaryTree Int
myTree = (Node 3 (Node 2 Empty Empty) (Node 4 Empty Empty))