import Data.Char

toInt :: String -> [Int]
toInt [] = []
toInt (n:m) = [ord n - 96] ++ toInt m

sumWord :: [Int] -> Int
sumWord [] = 0
sumWord (n:m) = n + sumWord m

wordValue :: String -> Int
wordValue inp
    | (inp == []) = 0
    | otherwise = sumWord(toInt(map toLower inp))