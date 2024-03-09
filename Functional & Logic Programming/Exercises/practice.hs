import Data.List (sort)

newlast :: [Integer] -> Integer
newlast a = head $ reverse a

mediana :: Integer -> Integer -> Integer -> Integer
mediana a b c = (a+b+c) - maximum [a,b,c] - minimum [a,b,c]

curta :: [a] -> Bool
curta x = (length x) < 4

curta1 :: [a] -> Bool
curta1 a
  | (length a == 3) = True
  | (length a == 1) = True
  | (length a == 2) = True
  | otherwise = False

curta2 :: [a] -> Bool
curta2 a = if(length a < 4) then True else False

ands :: [Bool] -> Bool
ands [] = True
ands a = if(head a == True) then ands $ tail a else False

interperse :: a -> [a] -> [a]
interperse a [] = []
interperse c l = (head l) : c : (interperse c (tail l))

ins :: Ord a => a -> [a] -> [a]
ins n [] = [n]
ins n l = if ((head l) >= n) then n:l else (head l) : (ins n (tail l))

isort :: Ord a => [a] -> [a]
isort [] = []
isort l = ins (head l) (isort(tail l))

divprop :: Integer -> [Integer]
divprop a = [x | x <- [1..(a-1)],(a `mod` x) == 0]

primo :: Integer -> Bool
primo a = if (length (divprop a) == 1) then True else False

forte:: String ->Bool
forte s = if (((length s) > 7) && (or [(elem x ['A'..'Z']) | x <- s])&& (or [(elem x ['0'..'9']) | x <- s])) then True else False

fromBits :: [Int] -> Int
fromBits [] = 0
fromBits l = ((head l) * (2 ^ ((length l)-1))) + (fromBits (tail l))

dec2int :: [Int] -> Int
dec2int l = foldl (\acc x -> 10*acc + x) 0 l

pp :: [a] ->[a]->[a]
pp l1 l2 = foldr (:) l2 l1

reverse1 :: [a] -> [a]
reverse1 l = foldl (\acc x -> x:acc) [] l

reverse2 :: [a] -> [a]
reverse2 l = foldr (\x acc -> acc++ [x]) [] l

palavras :: String -> [String] -- nao e feito
palavras s = foldl (\acc x -> if (x == ' ') then acc else acc ++ [[x]]) [] s

data Arv a = Vazia | No a (Arv a) (Arv a) deriving Show

sumArv :: Num a => Arv a -> a
sumArv Vazia = 0
sumArv (No a b c) = a+ (sumArv b) + (sumArv c)

listar :: Ord a => Arv a -> [a]
listar Vazia = []
listar (No a b c) = reverse (sort ( a : (listar b) ++ (listar c)))

mapArv :: (a -> b) -> Arv a -> Arv b
mapArv f Vazia = Vazia
mapArv f (No a b c) = ( No (f a) (mapArv f b) (mapArv f c))  

substring :: (Integral a) => String -> a -> a -> String
substring s a b = [ s !! fromIntegral x | x <- [a..b] ]

data Dendrogram = Leaf String | Node Dendrogram Int Dendrogram
myDendro :: Dendrogram
myDendro = Node (Node (Leaf "dog") 3 (Leaf "cat")) 5 (Leaf "octopus")

dendroWidth :: Dendrogram -> Int
dendroWidth (Leaf f) = 0
dendroWidth (Node d1 i d2) = (2*i) + (dendroAux d1) + (dendroAux d2)

dendroAux :: Dendrogram -> Int
dendroAux (Leaf f) = 0
dendroAux (Node d1 i d2) = i + (dendroAux d1) + (dendroAux d2)

dendroInBounds :: Dendrogram -> Int -> [String]--precisa de aux
dendroInBounds (Leaf f) l = [f]
dendroInBounds (Node d1 i d2) l = if i > l then [] else ((dendroInBounds d1 (l-i)) ++ (dendroInBounds d2 (l-i)))

invs :: IO()
invs = do
       x <- getLine
       putStrLn (reverse x)
elefantes :: Int -> IO()
elefantes x= elefantesaux x 2

elefantesaux:: Int -> Int -> IO()
elefantesaux x y
 | x == y = putStr " "
 |otherwise = do
  putStrLn ("Se " ++ (show y)++" elefantes incomodam muita gente,")
  putStrLn ((show (y+1)) ++" elefantes incomodam muito mais!")
  elefantesaux x (y+1)
  

maxpos :: [Int] -> Int
maxpos a = if (a == []) then 0 else (maximum a)

dups :: [a] -> [a]
dups a = daux a True

daux :: [a] -> Bool -> [a]
daux [] _ = []
daux (x:xs) b = if b then ([x] ++ [x] ++ (daux xs (not b))) else ([x] ++ (daux xs (not b)))

transforma :: String -> String
transforma a = taux a 

taux :: String -> String
taux [] = []
taux (x:xs) = if ((x == 'a') || (x == 'u') ||(x == 'o') ||(x == 'i') ||(x == 'e')) then ([x] ++ ['p'] ++ [x] ++ (taux xs)) else ([x] ++ (taux xs))

type Vector = [Int]
type Matriz = [[Int]]

transposta :: Matriz -> Matriz
transposta [] = []
transposta m = [x | y <- m, x <- (head y)] ++ transposta ([x |y <- m, x <- (tail y)])