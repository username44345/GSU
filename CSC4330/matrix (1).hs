type Matrix = [[Int]]
type Column = [Int]
type Row = [Int]

removeColumn :: Matrix -> Int -> Matrix
removeColumn m n = map (\row -> take (n-1) row ++ drop n row) m

determinant :: Matrix -> Int
determinant []         = 0
determinant [[x]]      = x
-- uses the foldable sum function to find determinant
determinant n = sum [((-1) ^ m) * (head n !! m) * determinant (removeColumn (drop 1 n) (m+1)) | m <- [0 .. l]]
  where
    l = length (head n) - 1