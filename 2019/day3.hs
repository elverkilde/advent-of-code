{-# LANGUAGE NoImplicitPrelude, FlexibleContexts #-}

module Day3 where

import Protolude

import qualified Text.ParserCombinators.ReadP as P
import Text.Read (readPrec, ReadPrec, look)
import Data.Char (isDigit)
import Text.Read.Lex (readDecP)

data Direction = U Int | D Int | L Int | R Int
  deriving (Show)

type Point = (Int, Int)

data Line = H Point Point | V Point Point
  deriving (Eq, Show)

parseDirection :: P.ReadP Direction
parseDirection = do
  c <- P.get
  case c of
    'U' -> U <$> readDecP
    'D' -> D <$> readDecP
    'L' -> L <$> readDecP
    'R' -> R <$> readDecP
    _ -> P.pfail

parseLine :: P.ReadP [Direction]
parseLine = parseDirection `P.sepBy` P.char ',' 

readLine s = head [ x | (x,"") <- P.readP_to_S parseLine (toS s) ]

origin :: Point
origin = (0,0)

follow :: (Point, [Line]) -> [Direction] -> [Line]
follow (_, acc) [] = acc
follow acc@(_, ls) (d:ds) = follow (next, l:ls) ds
  where (next, l) = (add d acc)
        add (U z) ((x,y), acc) = ((x,y+z), V (x,y) (x,y+z))
        add (D z) ((x,y), acc) = ((x,y-z), V (x,y-z) (x,y))
        add (L z) ((x,y), acc) = ((x+z,y), H (x,y) (x+z,y))
        add (R z) ((x,y), acc) = ((x-z,y), H (x-z,y) (x,y))

intersect :: Line -> Line -> [Point]
intersect l1@(V _ _) l2@(H _ _) = intersect l2 l1
intersect (H (x1,y1) (x2,_)) (V (x3,y3) (_,y4)) =
  if x3 > x1 && x2 > x3 && y1 > y3 && y4 > y1
  then [(x3,y1)]
  else []
intersect _ _ = []

intersections :: [Line] -> [Line] -> [Point]
intersections ls1 ls2 = [x | l1 <- ls1,
                             l2 <- ls2,
                             x <- intersect l1 l2]

distance (x,y) = abs x + abs y

part1 input1 input2 = do
  ls1 <- follow (origin, []) <$> readLine input1
  ls2 <- follow (origin, []) <$> readLine input2
  let ps = intersections ls1 ls2
  return $ minimum $ map distance ps

steps (H (x1, _) (x2, _)) = abs $ x1 - x2
steps (V (_, y1) (_, y2)) = abs $ y1 - y2

contains (H (x1,y1) (x2, _)) (xp,yp) = y1 == yp && xp > x1 && x2 > xp
contains (V (x1,y1) (_, y2)) (xp,yp) = x1 == xp && yp > y1 && y2 > yp

walkTo [] acc _ = Nothing
walkTo (l:ls) (l2, acc) p = if l `contains` p
                      then Just $ acc + (connection l2 l p)
                      else walkTo ls (l, steps l + acc) p

connection prev@(H p1 p2) next@(V p3 p4) p =
  if (p1 == p3) || (p2 == p3)
  then steps (V p3 p)
  else steps (V p4 p)
connection prev@(V p1 p2) next@(H p3 p4) p =
  if (p1 == p3) || (p2 == p3)
  then steps (H p3 p)
  else steps (H p4 p)


part2 input1 input2 = do
  ls1 <- follow (origin, []) <$> readLine input1
  ls2 <- follow (origin, []) <$> readLine input2
  let ps = intersections ls1 ls2
  let f p = do
        s1 <- walkTo (reverse ls1) ((H origin origin), 0) p
        s2 <- walkTo (reverse ls2) ((H origin origin), 0) p
        return $ s1 + s2

  ss <- mapM f ps

  return $ minimum ss
