--Definition
data Date = Date 
  { month :: Int, 
    day   :: Int,
    year  :: Int
  } 
  deriving (Show, Eq)
-- Function to find if date is a Leap Year
leapYear :: Date -> Bool
leapYear n
    | ((year(n) `mod` 4 == 0) && ((year(n) `mod` 100 /= 0) || (year(n) `mod` 400 == 0))) = True
    | otherwise = False
--returns number of days in month
daysMonth :: Date -> Int
daysMonth n 
    | month(n) == 1 || month(n) == 3 || month(n) == 5 || month(n) == 7 || month(n) == 8 || month(n) == 10 || month(n) == 12 = 31
    | month(n) == 4 || month(n) == 6 || month(n) == 9 || month(n) == 11 = 30
    | (month(n) == 2 && leapYear n == False) = 28
    | otherwise =29
--Function that returns the date of the next day
tomorrow :: Date -> Date
tomorrow n
    | day(n) < daysMonth n = Date (month(n)) (day(n)+1) (year(n))
    | (day(n) == daysMonth n) && (month(n) < 12) = Date (month(n)+1) (1) (year(n))
    | otherwise = Date 1 1 (year(n)+1)
--Function that returns the date of the previous day
yesterday :: Date -> Date
yesterday n
    | day(n) > 1 = Date (month(n)) (day(n)-1) (year(n))
    | (day(n) == 1) && (month(n) > 1) = Date (month(n)-1) (daysMonth(firstOfPreviousMonth(n))) (year(n))
    | otherwise = Date 12 31 (year(n)-1)
--Function that returns the date first day of the next month
firstOfNextMonth :: Date -> Date
firstOfNextMonth n
    | month(n) < 12 = Date (month(n)+1) 1 (year(n))
    | otherwise = Date 1 1 (year(n)+1)
--Function that returns the date first day of the previous month
firstOfPreviousMonth :: Date -> Date
firstOfPreviousMonth n
    | month(n) > 1 = Date (month(n)-1) 1 (year(n))
    | otherwise = Date 12 1 (year(n)-1)
--adds n number of days to the date
add :: Int -> Date -> Date
add n d
    | (day(d)+n) <= daysMonth d = Date (month(d)) (day(d)+n) (year(d))
    | otherwise = add (n-(daysMonth d + 1 - day(d))) (firstOfNextMonth(d))
-- subtracts n number of days from the date
sub :: Int -> Date -> Date
sub n d
    | (day(d)-n) > 1 = Date (month(d)) (day(d)-n) (year(d))
    | otherwise = sub (n - (day(d))) (Date (month(firstOfPreviousMonth(d))) (daysMonth(firstOfPreviousMonth(d))) (year(firstOfPreviousMonth(d))))
-- returns whether d1 is after d2 or not
(>>>) :: Date -> Date -> Bool
(>>>) d1 d2
    | year(d1) > year(d2) = True
    | (month(d1) > month(d2)) && (year(d1) == year(d2)) = True
    | (day(d1) > day(d2)) && (month(d1) == month(d2)) && (year(d1) == year(d2)) = True
    | otherwise = False
--returns whether the dates are the same
(===) :: Date -> Date -> Bool
(===) d1 d2
    | (day(d1) == day(d2)) && (month(d1) == month(d2)) && (year(d1) == year(d2)) = True
    | otherwise = False
-- returns whether d2 is after d1 or not
(<<<) :: Date -> Date -> Bool
(<<<) d1 d2
    | year(d1) < year(d2) = True
    | (month(d1) < month(d2)) && (year(d1) == year(d2)) = True
    | (day(d1) < day(d2)) && (month(d1) == month(d2)) && (year(d1) == year(d2)) = True
    | otherwise = False
-- Returns the number of days between the dates
daysBetween :: Date -> Date -> Int
daysBetween d1 d2
    | ((>>>) d1 d2) = daysBetween d2 d1
    | otherwise = ((numDays d2)-(numDays d1))
--returns the number of days in a date
numDays :: Date -> Int
numDays d = ((year(d) * 365) +(prevMonths (d) (0) (month(d))) + (day(d))+(numLeap d))
-- returns total number of days in previous months
prevMonths :: Date -> Int -> Int -> Int
prevMonths d n m
  |month(d) == m = prevMonths (Date (month(d)-1) (day(d)) (year(d))) (n) (m)
  | month(d) > 1 && month(d) < m = prevMonths (Date (month(d)-1) (day(d)) (year(d))) (n+daysMonth d) (m)
  | m == 1 = 0
  | otherwise = (n + daysMonth d)
-- returns number of leap Years
numLeap :: Date -> Int
numLeap d 
    | month(d) > 2 = (year(d) `div` 4) - (year(d) `div` 100) + (year(d) `div` 400)
    | otherwise = ((year(d)-1) `div` 4) - ((year(d)-1) `div` 100) + ((year(d)-1) `div` 400)