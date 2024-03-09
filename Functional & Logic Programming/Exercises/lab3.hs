main = print(filter odd [1,2,3])
mapfilter :: (a -> b) -> (a -> Bool) -> [a] ->[b]
mapfilter f p l = (map f . filter p) l

dec2int :: (Integral a) => [a] -> a
dec2int d = foldl (\acc x -> 10 * acc + x) 0 d

myreverse :: [a] -> [a]
myreverse l = foldl (\acc x -> x : acc) [] l

myreversepf :: [a] -> [a]
myreversepf = foldl (flip (:)) []

myreverse1 :: [a] -> [a]
myreverse1 l = foldr (\x acc -> acc ++ [x]) [] l