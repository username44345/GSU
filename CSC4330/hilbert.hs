type Canvas = ([(Int,Int)],Int,Int)
-- makes adds driectional segment
east  :: Canvas -> Canvas
east (a, b, c) = (([(b+20,c)] ++ a),(b+20),c)
west  :: Canvas -> Canvas
west (a,b,c) = (([(b-20,c)] ++ a),(b-20),c)
north :: Canvas -> Canvas
north (a,b,c) = (([(b,c-20)] ++ a),b,(c-20))
south :: Canvas -> Canvas
south (a,b,c) = (([(b,c+20)] ++ a),b,(c+20))
-- makes hcurve
hcurve :: Int -> Canvas -> Canvas
hcurve n x
    | n == 0 = x
    | otherwise = bcurve (n-1) (north (hcurve (n-1) (east (hcurve (n-1)(south (acurve (n-1) x))))))
-- makes acurve
acurve :: Int -> Canvas -> Canvas
acurve n x
    | n == 0 = x
    | otherwise = ccurve (n-1) (west (acurve (n-1) (south (acurve (n-1)(east (hcurve (n-1) x))))))
-- makes bcurve
bcurve :: Int -> Canvas -> Canvas
bcurve n x
    | n == 0 = x
    | otherwise = hcurve (n-1) (east (bcurve (n-1) (north (bcurve (n-1)(west (ccurve (n-1) x))))))
--makes ccurve
ccurve :: Int -> Canvas -> Canvas
ccurve n x
    | n == 0 = x
    | otherwise = acurve (n-1) (south (ccurve (n-1) (west (ccurve (n-1)(north (bcurve (n-1) x))))))
-- returns needed canvas size
canvasSize :: Int -> Int
canvasSize n
      | n == 0 = 0
      |otherwise = 20 + (2*canvasSize (n-1))