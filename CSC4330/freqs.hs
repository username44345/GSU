import Data.List
frequencies :: String -> [(Char,Int)]
frequencies n = map (\x -> (head x, length x)) $ group $ sort n