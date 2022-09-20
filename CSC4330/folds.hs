import Data.Char
--returns the factorial of an int
factorial :: Int -> Int
factorial n = foldr (*) 1 [1..n]
--returns the value of inputed string
wordValue :: String -> Int
wordValue n = foldr (+) 0 (toInt (map toLower n))
toInt :: String -> [Int]
toInt = foldr (\ n -> (++) [ord n - 96]) []
--returns the longest string in a list
longest :: [String] -> String
longest = foldr (>>>) ""
(>>>) :: String -> String -> String
(>>>) n m 
    | (length n) > (length m) = n
    | otherwise = m
--removes adjacent duplicates
rmdups :: [Int] -> [Int]
rmdups = foldl (+++) [] 
(+++) :: [Int] -> Int -> [Int]
(+++) m n
    | null m = m ++ [n]
    | n == last m = m
    | otherwise = m ++ [n]
--returns a pair holding the min and the max of a list
minmax :: [Int] -> (Int,Int)
minmax n = ((foldr min maxBound n),(foldr max minBound n))
