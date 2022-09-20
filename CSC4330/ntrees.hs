data NTree a = Nil | Tree a [NTree a] deriving Show
--sums the elements of the Ntree
sumElements :: NTree Int -> Int
sumElements Nil = 0
sumElements ( Tree a b ) = foldr (+) a (map sumElements b)
-- finds the height of the nTree
heightNTree :: NTree Int -> Int
heightNTree Nil = -1
heightNTree (Tree a []) = 0
heightNTree (Tree a b) = foldr max minBound (map (\n -> (heightNTree n) + 1) b)
-- returns list of values in preorder
preOrder :: NTree Int -> [Int]
preOrder Nil = []
preOrder (Tree a b) = foldl (++) [a] (map preOrder b)