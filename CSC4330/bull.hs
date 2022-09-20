import Data.Char
import Data.List
extractDigits :: Int -> [Int]
extractDigits n
    | n < 10 = [n]
    | otherwise = extractDigits(n `div` 10) ++ [n `rem` 10]

checkRepeat :: (Ord n) => [n] -> Bool
checkRepeat m = (length (nub m) == length m)

noRepeatingDigits :: Int -> Bool
noRepeatingDigits n
    | (n < 0 && n >= -10) = True
    | n < 0 = False
    | (n >= 0 && n <= 10) = True
    | otherwise =  checkRepeat(extractDigits(n))

numBulls :: Int -> Int -> Int
numBulls n m
    | (noRepeatingDigits n && noRepeatingDigits m && length (extractDigits n) == length (extractDigits m)) = checkPos (extractDigits n) (extractDigits m)
    | otherwise = -1

checkPos :: [Int] -> [Int] -> Int
checkPos [] [] = 0
checkPos (n:m) (x:y)
    | n == x    = 1 + (checkPos m y)
    | otherwise = (checkPos m y)

numCows :: Int -> Int -> Int
numCows n m
    | noRepeatingDigits n && noRepeatingDigits m && length (extractDigits n) == length (extractDigits m) = eval (extractDigits n) (extractDigits m) 0
    | otherwise = -1

checkInStr :: [Int] -> Int -> Bool
checkInStr [] n = False
checkInStr (x:y) n
    | n == x = True || checkInStr y n
    | otherwise = False || checkInStr y n

checkSamePos :: [Int] -> Int -> Int -> Int -> Int
checkSamePos [] x yInd xInd = 0
checkSamePos (y:ys) x yInd xInd
    | y == x && yInd /= xInd = 1
    | otherwise = 0 + checkSamePos ys x (yInd + 1) xInd

eval :: [Int] -> [Int] -> Int -> Int
eval [] x _ = 0
eval (n:m) y xInd
    | checkInStr y n == True = eval m y (xInd+1) + checkSamePos y n 0 xInd
    | otherwise = 0 + eval m y (xInd+1)