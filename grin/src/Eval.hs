module Eval where

import Text.Megaparsec

import Grin
import ParseGrin
import qualified STReduceGrin
import qualified ReduceGrin


data Reducer
  = PureReducer
  | STReducer
  deriving (Eq, Show)

eval' :: Reducer -> String -> IO Val
eval' reducer fname = do
  result <- parseGrin fname
  case result of
    Left err -> error $ show err
    Right e  -> return $ 
      case reducer of
        PureReducer -> ReduceGrin.reduceFun e "main"
        STReducer   -> STReduceGrin.reduceFun e "main"

evalProgram :: Reducer -> Program -> Val
evalProgram reducer (Program defs) =
  case reducer of
    PureReducer -> ReduceGrin.reduceFun defs "main"
    STReducer   -> STReduceGrin.reduceFun defs "main"