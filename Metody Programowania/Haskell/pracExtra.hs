{-# LANGUAGE Safe #-}
module IzabelaStrumeckaCompiler(compile) where
import AST
import MacroAsm
import Control.Monad.State
import Data.List

-- Wariant zadania: Pracownia nr 5

compile :: [FunctionDef p] -> [Var] -> Expr p ->  [MInstr]
compile fenv env e =
  fst(runState (compile1 functions stack e) j) ++ [MRet] ++ fst (runState (kompilacjafunkcji functions fenv) i)
  where
    stack = stos env
    functions = fst (runState(funkcje fenv) 0)
    i = snd (runState(funkcje fenv) 0) + 1
    j = snd (runState (kompilacjafunkcji functions fenv) i) + 1

stos :: [Var] -> Stack
stos [] = []
stos (x:xs) = (Var x):(stos xs)

kompilacjafunkcji :: Env -> [FunctionDef p] -> St [MInstr]
kompilacjafunkcji _ [] = return []
kompilacjafunkcji env (x:xs)  = do
      glowa <- compile1 env  [Var (funcArg x)] (funcBody x)
      body <- kompilacjafunkcji env xs
      return ([MLabel lb] ++ glowa ++ [MRet] ++ body)
      where lb = getlabel env (funcName x)

funkcje :: [FunctionDef p] -> St Env
funkcje [] = return []
funkcje (x:xs) = do
  lb <- freshlabel
  ogon <- funkcje xs
  return ((funcName x, lb):(ogon))

type Env  = [(FSym, Label)]
data StackElem = Var Var | Tmp deriving Eq
type Stack = [StackElem]
type St = State Label

freshlabel :: St Label
freshlabel = do
  l <- get
  put (l+1)
  return l

compile1 :: Env  -> Stack -> Expr p ->  St [MInstr]

compile1 env s (ENum _ num) = return [MConst num]
compile1 env s (EBool _ b) = return [MConst (if b then -1 else 0)]
compile1 env s (EUnary _ UNeg e) = do
  l1 <- compile1 env s e
  return (l1 ++ [MNeg])

compile1 env s (EUnary _ UNot e) = do
  l1 <- compile1 env s e
  return (l1 ++ [MNot])

compile1 env s (EVar _ var) =
  return [MGetLocal pos]
  where   pos = getvarpos s var

compile1 env s (ELet _ var e1 e2) = do
  l1 <- compile1 env s e1
  l2 <- compile1 env ((Var var):s) e2
  return (l1 ++ [MPush] ++ l2 ++ [MPopN 1])

compile1 env s (EIf _ e1 e2 e3) = do
  lb1 <- freshlabel
  lb2 <- freshlabel
  l1 <- compile1 env s e1
  l2 <- compile1 env s e2
  l3 <- compile1 env s e3
  return (l1 ++ [MBranch MC_Z lb1] ++ l2 ++ [MJump lb2, MLabel lb1] ++ l3 ++ [MLabel lb2])

compile1 env s (EBinary _ op e1 e2) = do
  l1 <- compile1 env s e1
  l2 <- compile1 env (Tmp:s) e2
  l3 <- compileop op
  return (l1 ++ [MPush] ++ l2 ++ l3)

compile1 env s (EUnit _) = return []

compile1 env s (ENil _ _) = return [MConst 0]

compile1 env s (ECons _ e1 e2) = do
  l1 <- compile1 env s1 e1
  l2 <- compile1 env s1 e2
  return ([MAlloc 2, MPush] ++ l1 ++ [MSet 0] ++ l2 ++ [MSet 1, MPopAcc])
  where s1 = Tmp:s

compile1 env s (EPair _ e1 e2) = do
  l1 <- compile1 env (Tmp:s) e1
  l2 <- compile1 env (Tmp:s) e2
  return ([MAlloc 2, MPush] ++ l1 ++ [MSet 0] ++ l2 ++ [MSet 1, MPopAcc])


compile1 env s (EFst _ e) = do
  l <- compile1 env s e
  return (l ++ [MGet 0])

compile1 env s (ESnd _ e) = do
  l <- compile1 env s e
  return (l ++ [MGet 1])

compile1 env s (EApp _ name e) = do
  l1 <- compile1 env s e
  return (l1 ++ [MPush, MCall lb, MPopN 1] )
  where lb = getlabel env name

compile1 env s (EMatchL _ e e1 (x1,x2, e2)) = do
  l1 <- compile1 env s e
  l2 <- compile1 env s1 e1
  l3 <- compile1 env ((Var x2):((Var x1):s1)) e2
  lb1 <- freshlabel
  lb2 <- freshlabel
  return (l1 ++ [MPush, MBranch MC_NZ lb1] ++ l2 ++ [MPopN 1, MJump lb2, MLabel lb1, MGetLocal 0, MGet 0, MPush, MGetLocal 1, MGet 1, MPush] ++ l3 ++ [MPopN 3, MLabel lb2] )
  where
    s1 = Tmp:s

getlabel:: Env -> FSym -> Label
getlabel env name = case lookup name env of
                      Just l -> l
                      Nothing -> 0

getvarpos :: Stack -> Var -> Int
getvarpos s var = case findIndex (==(Var var)) s of
                      Just i -> i
                      Nothing -> 0



compileop :: BinaryOperator -> St [MInstr]
compileop BAnd = return [MAnd]
compileop BOr = return [MOr]
compileop BAdd = return [MAdd]
compileop BMul = return [MMul]
compileop BSub = return [MSub]
compileop BDiv = return [MDiv]
compileop BMod = return [MMod]
compileop BEq = compileopwar MC_EQ
compileop BNeq = compileopwar MC_NE
compileop BLt = compileopwar MC_LT
compileop BGt = compileopwar MC_GT
compileop BLe = compileopwar MC_LE
compileop BGe = compileopwar MC_GE

compileopwar :: MCondition -> St [MInstr]
compileopwar op = do
  lb1 <- freshlabel
  lb2 <- freshlabel
  return ([MBranch op lb1, MConst 0, MJump lb2, MLabel lb1, MConst (-1), MLabel lb2])
