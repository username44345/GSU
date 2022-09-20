--Type definition
type Element = (Int,Int)
type BinaryRelation = Element -> Bool
bound = 99
--emptyBinaryRelation
emptyBinaryRelation :: BinaryRelation
emptyBinaryRelation e = False
--Universal binary relation
universalBinaryRelation :: BinaryRelation
universalBinaryRelation e = True
--Add
add :: Element -> BinaryRelation -> BinaryRelation
add x n = \m -> if x == m then True else n m
--contains
contains :: Element -> BinaryRelation -> Bool
contains e r =  (r e)
--addMultiple
addMultiple :: [Element] -> BinaryRelation -> BinaryRelation
addMultiple n m = foldr add m n
--returns if the first is a subset of the second
subRelation :: BinaryRelation -> BinaryRelation -> Bool
subRelation r1 r2 = subRelationHelper1 r1 r2 0

subRelationHelper1 :: BinaryRelation -> BinaryRelation -> Int -> Bool
subRelationHelper1 r1 r2 n 
  | n > bound = True
  | otherwise = subRelationHelper2 r1 r2 n 0 && subRelationHelper1 r1 r2 (n+1)

subRelationHelper2 :: BinaryRelation -> BinaryRelation -> Int -> Int-> Bool
subRelationHelper2 r1 r2 n m 
  | m > bound                                    = True
  | contains (n,m) r1 && not (contains (n,m) r2) = False
  | otherwise                                    = subRelationHelper2 r1 r2 n (m+1)
--checks if binary relations are equal
equal :: BinaryRelation -> BinaryRelation -> Bool
equal n m
    | (subRelation n m) && (subRelation m n) = True
    | otherwise = False
--reflexive
reflexive :: BinaryRelation -> Bool
reflexive n = foldr (\x acc -> n (x,x) && acc) True [0..bound]
--returns union of the binary relations
union :: BinaryRelation -> BinaryRelation -> BinaryRelation
union n m = foldr add m [(x,y) | x <- [0..bound], y <- [0..bound], n (x,y)]
--returns the inverse of the binary relation
inverse :: BinaryRelation -> BinaryRelation
inverse n = foldr add emptyBinaryRelation [(y,x) | x <- [0..bound], y <- [0..bound], n (x,y)]
--returns true if relation is symmetric
symmetric :: BinaryRelation -> Bool
symmetric n
    | equal n (union n (inverse n)) = True
    | otherwise = False
--returns true if relation is antisymmetric
antiSymmetric :: BinaryRelation -> Bool
antiSymmetric n 
    | equal n emptyBinaryRelation = False
    | not (foldl antiHelper False (map (reverseContains n) ([(x,y) | x <- [0..bound], y <- [0..bound], (inverse n) (x,y)]))) || (foldl antiHelper2 True (map (antiHelper3) ([(x,y) | x <- [0..bound], y <- [0..bound], (n) (x,y)]))) = True
    | otherwise = False
reverseContains:: BinaryRelation -> Element -> Bool
reverseContains n m = contains m n
antiHelper:: Bool -> Bool -> Bool
antiHelper n m
    | n || m == True = True
    | otherwise = False
antiHelper2:: Bool -> Bool -> Bool
antiHelper2 n m
    | n && m == True = True
    | otherwise = False
antiHelper3 :: Element -> Bool
antiHelper3 n = equal (add n emptyBinaryRelation) (inverse (add n emptyBinaryRelation))
--returns whether relation is transitive
transitive :: BinaryRelation -> Bool
transitive n = and [n (x, z) | x <- [0..bound], y <- [0..bound], z <- [0..bound], n (x, y) && n (y, z)]
--returns whether relation is an equivalence
equivalence :: BinaryRelation -> Bool
equivalence r = reflexive r && symmetric r && transitive r
-- finds the reflexive closure
reflexiveClosure :: BinaryRelation -> BinaryRelation
reflexiveClosure n = foldr add n [(x,x) | x<- [0..bound]]
--find the symmetricClosure
symmetricClosure :: BinaryRelation -> BinaryRelation
symmetricClosure n = union n (inverse n)
--self join
selfJoin :: BinaryRelation -> BinaryRelation
selfJoin n = (foldr add emptyBinaryRelation [(x,z) | x <- [0..bound], y <- [0..bound], z <- [0..bound], z <- [0..bound], n (x, y) && n (y, z)])
--returns the Transitive Closure
transitiveClosure :: BinaryRelation -> BinaryRelation
transitiveClosure n
    | equal n (union n (selfJoin n)) = n
    | otherwise = transitiveClosure (union n (selfJoin n))
--returns BR as string
toString :: BinaryRelation -> String
toString r = show [(x,y) | x <- [0..bound], y <- [0..bound], r (x,y)]