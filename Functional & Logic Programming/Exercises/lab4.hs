module lab4 (empty, insert, lab4.lookup) where
--type String = [Char]
--type Pair a b = (a,b)

data BinaryTree a = Empty | Node a (BinaryTree a) (BinaryTree a) deriving Show

treeMap :: BinaryTree a -> (a -> b) -> BinaryTree b
treeMap Empty _ = Empty
treeMap (Node v l r) f = Node (f v) (treeMap l f) (treeMap r f)

myTree :: BinaryTree Int
myTree = (Node 3 (Node 2 Empty Empty) (Node 4 Empty Empty))

--needs new file
data Map k v = Empty | Node (k,v) (Map k v) (Map k v) deriving Show

empty :: Map k v
empty = Empty

insert :: (Ord k) => k -> v -> Map k v -> k v
insert k v Empty = Node (k,v) Empty Empty
insert k v (Node (k1,v1) l r) 
	|k < k1 = Node (k1,v1) (insert k v l) r
	|k > k1 = Node (k1,v1) l (insert k v l)
	| otherwise Node (k,v) l r
	
lookup : (Ord k) => k -> v -> Map k v -> Maybe v
lookup _ Empty = Nothing
lookup k (Node (k1,v) l r)
	| k < k1 = lab4.lookup k l
	| k > k1 = lab4.lookup k r
	| otherwise = Just v