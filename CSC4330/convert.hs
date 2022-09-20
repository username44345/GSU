import Data.Char

convertNum2Binary :: Int -> String
convertNum2Binary 0 = ""
convertNum2Binary n = convertNum2Binary(n `div` 2) ++ show (n `mod` 2)

convertFraction2Binary :: Float -> String
convertFraction2Binary 0 = ""
convertFraction2Binary n = convertNum2Binary(truncate n) ++ "." ++ convertFract (snd(properFraction n)) ""

convertFract :: Float -> (String -> String)
convertFract n m
    | length m == 23 = m
    | n == 0 = m
    | otherwise = convertFract (snd(properFraction(n * 2))) (m ++ show (fst(properFraction(n * 2))))