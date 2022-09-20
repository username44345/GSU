--Definition
data BST a = Nil | Tree a (BST a) (BST a) deriving Show
-- returns the size of the bst
sizeBST :: BST Int -> Int
sizeBST Nil = 0
sizeBST (Tree _ a b) = 1 + sizeBST a + sizeBST b
--returns the height of the tree
heightBST :: BST Int -> Int
heightBST Nil = -1
heightBST (Tree _ a b)
    | heightBST a > heightBST b = heightBST a + 1
    | otherwise = heightBST b + 1
--returns the minimum element in the BST
minBST :: BST Int -> Int
minBST Nil = 0
minBST (Tree t Nil _) = t
minBST (Tree t a _) = minBST a
--returns the makimum element in the BST
maxBST :: BST Int -> Int
maxBST Nil = 0
maxBST (Tree t _ Nil) = t
maxBST (Tree t _ b) = minBST b
--returns whether the talue is in the BST or not
memberBST :: Int -> BST Int -> Bool
memberBST _ Nil = False
memberBST k (Tree t a b) 
    | k == t = True
    | k  < t = memberBST k a
    | k  > t = memberBST k b
--inserts a talue into the BST
insertBST :: Int -> BST Int -> BST Int
insertBST k Nil = Tree k Nil Nil
insertBST k (Tree t a b)
  | t == k = Tree t a b
  | t  < k = Tree t a (insertBST k b)
  | t  > k = Tree t (insertBST k a) b
--deletes a node from the BST
deleteBST :: Int -> BST Int -> BST Int
deleteBST _ Nil = Nil
deleteBST k (Tree t a b)
  | k == t = delete (Tree t a b)
  | k  < t = Tree t (deleteBST k a) b
  | k  > t = Tree t a (deleteBST k b)
-- deletes root node
delete :: BST Int -> BST Int
delete (Tree t Nil b) = b
delete (Tree t a Nil) = a
delete (Tree t a b) = (Tree t2 a (deleteBST t2 b))
  where
    t2 = leftMost b
--returns left most node
leftMost :: BST a -> a
leftMost (Tree t Nil _) = t
leftMost (Tree _ a _) = leftMost a
-- returns Bst as a string
toString:: BST Int -> Int -> String
toString t n = case t of
  Nil                 -> "Nil\n" 
  (Tree k left right) -> replicate n ' ' ++ show k ++ "\n" ++ 
                         toString left  (n+2) ++ 
                         toString right (n+2)