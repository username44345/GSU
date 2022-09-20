
type Matrix = [[Int]]
type Column = [Int]
type Row = [Int]

transpose :: Matrix -> Matrix
transpose [] = []
transpose n = [extractColumn n m | m <- [0 .. l]] where l = length (head n) - 1

matrixMultiply :: Matrix -> Matrix -> Matrix
matrixMultiply n m = [rowMul row m | row <- n]

determinant :: Matrix -> Int
determinant [] = 0
determinant [[k]] = k
determinant n = sum [((-1) ^ m) * (head n !! m) * determinant (removeColumn (drop 1 n) m) | m <- [0 .. l]]
  where
    l = length (head n) - 1

extractColumn :: Matrix -> Int -> Column
extractColumn n m = [x !! m | x <- n]

removeColumn :: Matrix -> Int -> Matrix
removeColumn n m = transpose (take m x ++ drop (1+m) x) where x = transpose n

scalarProduct :: Row -> Row -> Int
scalarProduct x y = sum [n * m | (n, m) <- zip x y]

rowMul :: Row -> Matrix -> Row
rowMul n m = [scalarProduct n x | x <- transpose m]