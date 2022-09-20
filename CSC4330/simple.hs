singleDigit :: Int -> Int
singleDigit 0 = 0; singleDigit n = case mod n 9 of 0 -> 9; m -> m