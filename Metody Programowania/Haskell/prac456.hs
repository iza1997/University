{-# LANGUAGE Safe #-}
module IzabelaStrumecka (typecheck, eval) where
import AST
import DataTypes

data MyValue p = MInt Integer | MBool Bool | MPair (MyValue p, MyValue p) | MList [MyValue p] |  MUnit
                | MCFun ([FunctionDef p], (Var, Expr p)) | MCFn ([(Var, MyValue p)], (Var, Expr p)) deriving Show

eval1 ::  [(Var,MyValue p)] -> Expr p -> Maybe (MyValue p)

eval1 env (ENum p num) = return $ MInt num

eval1 env (EVar p var) = lookup var env

eval1 env (EBool p True)  = return $ MBool True
eval1 env (EBool p False) = return $ MBool False

eval1 env (EBinary p BDiv e1 e2) =
  case (eval1 env e1, eval1 env e2) of
    (Just (MInt n1), Just (MInt 0))  -> Nothing
    (Just (MInt n1), Just (MInt n2)) -> Just $ MInt (n1 `div` n2)
    _ -> Nothing

eval1 env (EBinary p BMod e1 e2) =
  case (eval1 env e1, eval1 env e2) of
    (Just (MInt n1), Just (MInt 0))  -> Nothing
    (Just (MInt n1), Just (MInt n2)) -> Just $ MInt (n1 `mod` n2)
    _ -> Nothing

eval1 env (EBinary p binary e1 e2) = do
  eval1 env e1
  eval1 env e2
  case binary of
                    BAdd -> return  $ MInt (val1 + val2)
                    BSub -> return  $ MInt (val1 - val2)
                    BMul -> return  $ MInt (val1 * val2)
                    BEq  -> return  $ MBool (val1 == val2)
                    BNeq -> return  $ MBool (val1 /= val2)
                    BLt  -> return  $ MBool (val1 < val2)
                    BGt  -> return  $ MBool (val1 > val2)
                    BLe  -> return  $ MBool (val1 <= val2)
                    BGe  -> return  $ MBool (val1 >= val2)
                    BOr  -> return  $ MBool (val3 || val4)
                    BAnd -> return  $ MBool (val3 && val4)
                    where
                      Just (MInt val1) = eval1 env e1
                      Just (MInt val2) = eval1 env e2
                      Just (MBool val3) = eval1 env e1
                      Just (MBool val4) = eval1 env e2


eval1 env (EUnary p UNot e) = do
  (MBool val) <- eval1 env e
  return $ MBool (not val)

eval1 env (EUnary p UNeg e) = do
  MInt val <- eval1 env e
  return $ MInt (-(val))

eval1 env (ELet p var e1 e2) = do
  val <- eval1 env e1
  eval1 ((var, val):env) e2

eval1 env (EIf p e1 e2 e3) = do
  MBool b <- eval1 env e1
  case b of
    True -> eval1 env e2
    False -> eval1 env e3

eval1 env (EUnit p) = return MUnit

eval1 env (EPair p e1 e2) = do
  val1 <- eval1 env e1
  val2 <- eval1 env e2
  return $ MPair (val1, val2)

eval1 env (EFst p e) = do
  MPair (val1, val2) <- eval1 env e
  return val1

eval1 env (ESnd p e) = do
  MPair (val1, val2) <- eval1 env e
  return val2

eval1 env (ENil p t) = return $ MList []

eval1 env (ECons p e1 e2) = do
  val0 <- eval1 env e1
  MList list <- eval1 env e2
  return $ MList (val0 : list)

eval1 env (EMatchL p e e1 (x1,x2,e2)) = do
  MList l <- eval1 env e
  case l of
    [] -> eval1 env e1
    (h:t) -> eval1 ((x1,h):((x2,MList t):env)) e2

eval1 env (EApp p e1 e2) = do
  cl <- eval1 env e1
  v <- eval1 env e2
  case cl of
    MCFn (env1,(var,e)) -> eval1 ((var, v) : env1) e
    MCFun (fenv, (var, body)) -> eval1 ((var,v) : rozszerzenie1 fenv fenv) body
    _ -> Nothing

eval1 env (EFn p var t e) = return $ MCFn (env,(var,e))

typowanie :: [(Var, Integer)] -> [(Var, MyValue p)]
typowanie [] = []
typowanie ((var, n):xs) = (var, MInt n):typowanie xs

rozszerzenie1 :: [FunctionDef p] -> [FunctionDef p] -> [(Var, MyValue p)]
rozszerzenie1 fenv [] = []
rozszerzenie1 fenv (x:xs) = (funcName x, MCFun (fenv, (funcArg x, funcBody x))) : (rozszerzenie1 fenv xs)

eval::[FunctionDef p] -> [(Var, Integer)] -> Expr p -> EvalResult
eval fenv env e =
  case eval1 env1 e of
    Just (MInt n) -> Value n
    Nothing -> RuntimeError
  where
    env1 = ((typowanie env) ++ (rozszerzenie1 fenv fenv))

-- TYPECHECK

typecheck1 ::  [(Var,Type)] -> Expr p -> Either (MError p) Type

data MError p =  MError p ErrorMessage

typecheck1 env (ENum p num) = return TInt

typecheck1 env (EBool p True) = return TBool
typecheck1 env (EBool p False) = return TBool

typecheck1 env (EVar p var) =
  case lookup var env of
    Just t -> return t
    Nothing -> Left $ MError p "Nie znaleziono zmiennej w srodowisku"

typecheck1 env (EBinary p binary e1 e2) = do
  t1 <- typecheck1 env e1
  t2 <- typecheck1 env e2
  if  binary `elem` [BAdd, BSub, BMod, BDiv, BMul] then
    if ((t1 == TInt) && (t1 == t2)) then return TInt else Left $ MError p "Wymagane wyrazenia typu Int po obu stronach operatora "
  else
    if binary `elem` [BEq, BNeq, BLt, BGt, BLe, BGe] then
      if ((t1 == TInt) && (t1 == t2)) then return TBool else Left $ MError p "Wymagane wyrazenia typu Int po obu stronach operatora "
    else
      if ((t1 == TBool) && (t2 == TBool)) then return TBool else Left $ MError p "Wymagane wyrazenia typu Int po obu stronach operatora "

typecheck1  env (EUnary p UNot e) = do
  case typecheck1  env e of
    Right TBool -> return TBool
    _ -> Left $ MError p "Wymagane wyrazenie typu Bool przy operatorze not"

typecheck1  env (EUnary p UNeg e) = do
  case typecheck1  env e of
    Right TInt -> return TInt
    _ -> Left $ MError p "Wymagane wyrazenie typu Int  przy operatorze -"

typecheck1  env (ELet p var e1 e2) = do
      t <- typecheck1  env e1
      typecheck1  ((var, t):env) e2

typecheck1  env (EIf p e1 e2 e3) =
    case typecheck1  env e1 of
        Right TBool -> do
                     t1 <- typecheck1  env e2
                     t2 <- typecheck1  env e3
                     if t1 == t2 then return t1
                                 else Left $ MError p "Wymagane takie same typy po then i else"
        _ -> Left $ MError p "Po If wymagane wyrazenie typu Bool"

typecheck1  env (EFn p var t e) = do
  t1 <- typecheck1 ((var,t):env) e
  return $ TArrow t t1

typecheck1 env (EApp p e1 e2) = do
  t1 <- typecheck1  env e1
  t2 <- typecheck1  env e2
  case t1 of
    TArrow tin tout -> if t2 == tin then return tout
                                    else Left $ MError p "Złe otypowanie w funkcji"
    otherwise -> Left $ MError p "Zła aplikacja funkcji"

typecheck1  env (EUnit p) = return TUnit

typecheck1  env (EPair p e1 e2) = do
  t1 <- typecheck1  env e1
  t2 <- typecheck1  env e2
  return $ TPair t1 t2

typecheck1  env (EFst p e1) = do
  case typecheck1  env e1  of
    Right (TPair t1 t2) -> return t1
    _ -> Left $ MError p "Po fst wymagana para"

typecheck1  env (ESnd p e1) = do
  case typecheck1  env e1 of
    Right (TPair t1 t2) -> return t2
    _ -> Left $ MError p "Po snd wymagana para"

typecheck1  env (ENil p t )= do
  case t of
    TList t1 -> return $ TList t1
    _ -> Left $ MError p "Zle otypowana lista"


typecheck1  env (ECons p e1 e2) = do
  case (typecheck1  env e1, typecheck1  env e2) of
    (Right t1, Right (TList t2)) -> case t1 == t2 of
                                  True -> return $ TList t1
                                  False -> Left $ MError p "Inne typy głowy i ogona listy"
    (_,_) -> Left $ MError p "Ogon nie jest lista"

typecheck1  env (EMatchL p e nc (x1, x2, e2)) = do
  case (typecheck1  env e, typecheck1  env nc) of
    ((Right (TList t1)),  Right t2) -> do
                                         t3 <- typecheck1 ((x1, t1):(x2, TList t1):env) e2
                                         if t3 == t2
                                            then return t2
                                            else Left $ MError p "Inne typy w rekurencji"
    (_, _) -> Left $ MError p "Wyrazenie po match nie jest lista"

rozszerzenie :: [FunctionDef p] -> [(Var,Type)]
rozszerzenie [] = []
rozszerzenie (x:xs) = (funcName x, TArrow (funcArgType x) (funcResType x)) : rozszerzenie xs

checkFunctionTypes ::  [FunctionDef p] -> [FunctionDef p] -> Either (MError p ) Type
checkFunctionTypes _ [] = return TUnit
checkFunctionTypes fenv (x:xs) = do
  t <- typecheck1 ((rozszerzenie (fenv)) ++ [(funcArg x, funcArgType x)]) (funcBody x)
  if t == (funcResType x)
                then checkFunctionTypes fenv xs
                else Left $ MError (getData (funcBody x)) "Typy w funkcji niezgodne"

typowanie2 :: [Var] -> [(Var, Type)]
typowanie2 [] = []
typowanie2 (var:xs) = (var, TInt) : typowanie2 xs

typowanie3 :: [FunctionDef p] -> [(Var, FunctionDef p)]
typowanie3 [] = []
typowanie3 (x:xs) = ((funcName x,x) : typowanie3 xs)

extractResult :: Either (MError p) Type -> Expr p-> TypeCheckResult p
extractResult mtr e = case mtr of
            Right TInt -> Ok
            Left (MError p message) -> Error p message
            _ -> Error (getData e) "Wymagane aby caly program byl typu Int"

typecheck :: [FunctionDef p] -> [Var] -> Expr p -> TypeCheckResult p
typecheck fenv env e =
  case checkFunctionTypes fenv fenv of
    Right TUnit -> extractResult (typecheck1 ((typowanie2 env) ++ (rozszerzenie fenv)) e) e
    Left (MError p message) -> Error p message
