-- PFL 2023/24 - Haskell practical assignment quickstart
-- Updated on 15/12/2023

-- Part 1

-- Do not modify our definition of Inst and Code
import Data.List (intercalate)
import Data.List (sort)
import Data.Char (isAlpha, isDigit, isSpace)
import Debug.Trace
data Inst =
  Push Integer | Add | Mult | Sub | Tru | Fals | Equ | Le | And | Neg | Fetch String | Store String | Noop |
  Branch Code Code | Loop Code Code
  deriving Show
type Code = [Inst]
type StackElem = Either Bool Integer
type Stack = [StackElem]

type VarValue = (String, StackElem)
type State = [VarValue]

createEmptyStack :: Stack
createEmptyStack = []

--use like stack2Str [Right 1,Right 2,Right 5,Left True]
stack2Str :: Stack -> String
stack2Str stack = intercalate "," (concatMap showElem stack)
  where showElem (Left bool) = [show bool]
        showElem (Right int) = [show int]

createEmptyState :: State
createEmptyState = []

--use like state2Str [("x",Left True),("y",Right 3)]
state2Str :: State -> String
state2Str state = intercalate "," (concatMap showVarValue (sort state))
  where showVarValue (var, Left bool) = [var ++ "=" ++ show bool]
        showVarValue (var, Right int) = [var ++ "=" ++ show int]

--all functionalities go here
run :: (Code, Stack, State) -> (Code, Stack, State)
run ([],stack,state)= ([],stack,state)
run ((Push n):rest,stack,state)= run (rest,[Right n]++stack,state)--push implementation
run ((Tru):rest, stack, state) = run (rest, [Left True]++stack, state)
run ((Fals):rest, stack, state) = run (rest, [Left False]++stack, state)
run ((Add):rest, (Right x:Right y:stack), state) = run (rest, [Right (x+y)]++stack, state)
run ((Add):rest, stack, state) = error "Run-time error"
run ((Mult):rest, (Right x:Right y:stack), state) = run (rest, [Right (x*y)]++stack, state)
run ((Mult):rest, stack, state) = error "Run-time error"
run ((Sub):rest, (Right x:Right y:stack), state) = run (rest, [Right (x-y)]++stack, state)
run ((Sub):rest, stack, state) = error "Run-time error"
run ((Le):rest, (Right x:Right y:stack), state) = run (rest, [Left (x<=y)]++stack, state)
run ((Le):rest, stack, state) = error "Run-time error"
run ((Equ):rest, (Right x:Right y:stack), state) = run (rest, [Left (x==y)]++stack, state) --Equ for ints
run ((Equ):rest, (Left x:Left y:stack), state) = run (rest, [Left (x==y)]++stack, state) --Equ for bools
run ((Equ):rest, stack, state) = error "Run-time error"
run ((Neg):rest, (Left x:stack), state) = run (rest, [Left (not x)]++stack, state)
run ((Neg):rest, stack, state) = error "Run-time error"
run ((And):rest, (Left x:Left y:stack), state) = run (rest, [Left (x && y)]++stack, state)
run ((And):rest, stack, state) = error "Run-time error"
run ((Store var):rest, val:stack, state) =
  case lookup var state of
    Just _ -> run (rest, stack, updateState var val state)
    Nothing -> run (rest, stack, (var, val) : state)
  where
    updateState :: String -> StackElem -> State -> State
    updateState _ _ [] = []
    updateState var newVal ((name, oldVal):rest)
      | var == name = (name, newVal) : rest
      | otherwise = (name, oldVal) : updateState var newVal rest
run ((Fetch var):rest, stack, state) = case lookup var state of
    Just val -> run (rest, val:stack, state)
    Nothing -> error "Run-time error"
run ((Branch c1 c2):rest, (Left cond:stack), state) =
  if cond then run (c1 ++ rest, stack, state)
  else run (c2 ++ rest, stack, state)
run ((Noop):rest, stack, state) = run (rest, stack, state)
run ((Loop c1 c2):rest, stack, state) =
  run (c1 ++ c2 ++ [Branch [Loop c1 c2] []] ++ rest, stack, state)

-- To help you test your assembler
testAssembler :: Code -> (String, String)
testAssembler code = (stack2Str stack, state2Str state)
  where (_,stack,state) = run(code, createEmptyStack, createEmptyState)
  

-- Examples:
-- testAssembler [Push 10,Push 4,Push 3,Sub,Mult] == ("-10","")
-- testAssembler [Fals,Push 3,Tru,Store "var",Store "a", Store "someVar"] == ("","a=3,someVar=False,var=True")
-- testAssembler [Fals,Store "var",Fetch "var"] == ("False","var=False")
-- testAssembler [Push (-20),Tru,Fals] == ("False,True,-20","")
-- testAssembler [Push (-20),Tru,Tru,Neg] == ("False,True,-20","")
-- testAssembler [Push (-20),Tru,Tru,Neg,Equ] == ("False,-20","")
-- testAssembler [Push (-20),Push (-21), Le] == ("True","")
-- testAssembler [Push 5,Store "x",Push 1,Fetch "x",Sub,Store "x"] == ("","x=4")
-- testAssembler [Push 10,Store "i",Push 1,Store "fact",Loop [Push 1,Fetch "i",Equ,Neg] [Fetch "i",Fetch "fact",Mult,Store "fact",Push 1,Fetch "i",Sub,Store "i"]] == ("","fact=3628800,i=1")
-- If you test:
-- testAssembler [Push 1,Push 2,And]
-- You should get an exception with the string: "Run-time error"
-- If you test:
-- testAssembler [Tru,Tru,Store "y", Fetch "x",Tru]
-- You should get an exception with the string: "Run-time error"

-- Part 2

-- TODO: Define the types Aexp, Bexp, Stm and Program
data Aexp =
  Var String | Const Integer | Addi Aexp Aexp | Mul Aexp Aexp | Subs Aexp Aexp
  deriving Show 

data Bexp =
  Tr | Fal | Eqb Bexp Bexp | Andi Bexp Bexp | Negi Bexp | Eq Aexp Aexp | Leq Aexp Aexp 
  deriving Show

data Stm =
  Assign String Aexp | Seq [Stm] | If Bexp Program Program | While Bexp Program
  deriving Show

type Program = [Stm] 

compA :: Aexp -> Code
compA (Var x) = [Fetch x] 
compA (Const a) = [Push a] 
compA (Addi ae2 ae1) = compA ae1 ++ compA ae2 ++ [Add] 
compA (Mul ae2 ae1) = compA ae1 ++ compA ae2 ++ [Mult] 
compA (Subs ae2 ae1) = compA ae1 ++ compA ae2 ++ [Sub] 

compB :: Bexp -> Code
compB Tr = [Fetch "tt"] -- [Tru]
compB Fal = [Fetch "ff"] -- [Fals]
compB (Eq ae2 ae1) = compA ae1 ++ compA ae2 ++ [Equ]  
compB (Eqb be2 be1) = compB be1 ++ compB be2 ++ [Equ]  
compB (Leq ae2 ae1) = compA ae1 ++ compA ae2 ++ [Le] 
compB (Andi be2 be1) = compB be1 ++ compB be2 ++ [And]  
compB (Negi be1) = compB be1 ++ [Neg] 

compile :: Program -> Code
compile [] =[]
compile ((Assign x n):rest) =  compA n ++ [Store x] ++ compile rest
compile (Seq s:xs) = compile s ++ compile xs
compile ((If bexp seq1 seq2):rest) =
  let s1 = compile seq1
      s2 = compile seq2
  in compB bexp ++ [Branch s1 s2] ++ compile rest
compile ((While exp s):rest) = [Loop (compB exp) (compile s)] ++ compile rest

parse :: String -> Program
parse tokens = parseTokens (lexer tokens)

parseTokens :: [String] -> Program
parseTokens tokens = case tokens of
  (var : ":=" : rest) -> --parsing for value assignment
    case parseAexp rest of
      (aexp, ";" : remainingTokens) -> Assign var aexp : parseRest remainingTokens
      _ -> error "Syntax error in assignment statement"
  ("if" : rest) -> -- parsing for if clause
      case parseBexp rest of
       (bexp, "then" : trueBranch : trueBranch1 : trueBranch2 : ";" : "else" : falseBranch :falseBranch1 :falseBranch2 : ";" : remainingTokens) ->
        If bexp (parseTokens (trueBranch : trueBranch1 : trueBranch2 : [";"])) (parseTokens (falseBranch :falseBranch1 :falseBranch2 : [";"])) : parseRest remainingTokens
  ("while" : rest) -> -- parsing while if clause
    case parseBexp rest of
      (bexp,";" : "do" : whileBody :whileBody1 :whileBody2 : ";" : remainingTokens) ->
        While bexp (parseTokens (whileBody:whileBody1 :whileBody2:[";"])) : parseRest remainingTokens
  -- Add more cases for other statements
  _ -> error "Syntax error"


parseAexp :: [String] -> (Aexp, [String]) -- parsing for all operations that evaluate to int
parseAexp tokens = case tokens of
  

  (tok1 : "-" : tok2 : rest) ->
    let (aexp1, rest1) = parseAexp [tok1]
        (aexp2, rest2) = parseAexp (tok2 : rest)
    in (Subs aexp1 aexp2, rest2)
  (tok1 : "*" : tok2 : rest) ->
    let (aexp1, rest1) = parseAexp [tok1]
        (aexp2, rest2) = parseAexp (tok2 : rest)
    in (Mul aexp1 aexp2, rest2)
  (tok1 : "+" : tok2 : rest) ->
    let (aexp1, rest1) = parseAexp [tok1]
        (aexp2, rest2) = parseAexp (tok2 : rest)
    in (Addi aexp1 aexp2, rest2)
  (tok : rest) | isVar tok -> (Var tok, rest)
  (tok : rest) | isConst tok -> (Const (read tok), rest)
parseBexp :: [String] -> (Bexp, [String]) -- parsing for all operations that evaluate to bool
parseBexp tokens = case tokens of
  ("true" : rest) -> (Tr, rest)
  ("false" : rest) -> (Fal, rest)
  (tok1 : "==" : tok2 : rest) ->
    let (aexp1, rest1) = parseAexp [tok1]
        (aexp2, rest2) = parseAexp (tok2 : rest)
    in (Eq aexp1 aexp2, rest2)
  (tok1 : "<=" : tok2 : rest) ->
    let (aexp1, rest1) = parseAexp [tok1]
        (aexp2, rest2) = parseAexp (tok2 : rest)
    in (Leq aexp1 aexp2, rest2)
  _ -> error "Syntax error in boolean expression"

-- Helper function for parsing
isVar :: String -> Bool 
isVar = isAlpha . head

isConst :: String -> Bool
isConst = all isDigit

parseRest :: [String] -> Program
parseRest [] = []
parseRest tokens = parseTokens tokens


lexer :: String -> [String]
lexer [] = []
lexer (c:cs) -- lexer with branches depending on character encountered
  | isSpace c = lexer cs
  | c == ';' = [c]:(lexer cs)
  | isAlpha c = lexVar (c:cs)
  | isDigit c = lexInt (c:cs)
  | otherwise = lexOp (c:cs)

-- Helper functions for lexer
lexVar :: String -> [String]
lexVar s = var : lexer rest
  where (var, rest) = span isAlpha s

lexInt :: String -> [String]
lexInt s = num : lexer rest
  where (num, rest) = span isDigit s

lexOp :: String -> [String]
lexOp s = op : lexer rest
  where (op, rest) = span (\c -> not (isAlpha c) && not (c==';') && not (isDigit c) && not (isSpace c)) s
-- imported functions isAlpha, isDigit, isSpace used to check character

buildData:: String -> Inst
buildData s
  | s == "+" = Add
  | s == "-" = Sub
  | s == "<" = Le
  | s == "==" = Equ
  | s == "*" = Mult
  | s == "¬" = Neg



-- To help you test your parser
--testParser :: String -> (String, String)
--testParser programCode = (stack2Str stack, store2Str store)
  --where (_,stack,store) = run(compile (parse programCode), createEmptyStack, createEmptyStore)

-- Examples:
-- testParser "x := 5; x := x - 1;" == ("","x=4")
-- testParser "if (not True and 2 <= 5 = 3 == 4) then x :=1; else y := 2;" == ("","y=2")
-- testParser "x := 42; if x <= 43 then x := 1; else (x := 33; x := x+1;)" == ("","x=1")
-- testParser "x := 42; if x <= 43 then x := 1; else x := 33; x := x+1;" == ("","x=2")
-- testParser "x := 42; if x <= 43 then x := 1; else x := 33; x := x+1; z := x+x;" == ("","x=2,z=4")
-- testParser "x := 2; y := (x - 3)*(4 + 2*3); z := x +x*(2);" == ("","x=2,y=-10,z=6")
-- testParser "i := 10; fact := 1; while (not(i == 1)) do (fact := fact * i; i := i - 1;);" == ("","fact=3628800,i=1")
