:- module(izabela_strumecka, [parse/3]).


lexer(Tokens) -->
    comment, white_space,
   (  (  "def",     !, { Token = tokDef }
      ;  "else",    !, { Token = tokElse }
      ;  "if",      !, { Token = tokIf }
      ;  "in",      !, { Token = tokIn }
      ;  "let",     !, { Token = tokLet }
      ;  "then",    !, { Token = tokThen }
      ;  "_",       !, { Token = tokPodkreslenie }
      ;  "(",       !, { Token = tokLNawias }
      ;  ")",       !, { Token = tokRNawias }
      ;  "[",       !, { Token = tokLKwadratowy }
      ;  "]",       !, { Token = tokRKwadratowy }
      ;  "..",      !, { Token = tokKropki }
      ;  ",",       !, { Token = tokPrzecinek }
      ;  "=",       !, { Token = tokRownosc }
      ;  "<>",      !, { Token = tokRomb }
      ;  "<",       !, { Token = tokMniejsze }
      ;  ">",       !, { Token = tokWieksze }
      ;  "<=",      !, { Token = tokLImplikacja }
      ;  ">=",      !, { Token = tokPImplikacja }
      ;  "^",       !, { Token = tokPotega }
      ;  "|",       !, { Token = tokKreska }
      ;  "+",       !, { Token = tokPlus }
      ;  "-",       !, { Token = tokMinus }
      ;  "&",       !, { Token = tokAnd }
      ;  "*",       !, { Token = tokGwiazdka }
      ;  "/",       !, { Token = tokDiv }
      ;  "%",       !, { Token = tokProcent }
      ;  "@",       !, { Token = tokMalpa }
      ;  "#",       !, { Token = tokKrzyzyk }
      ;  "~",       !, { Token = tokNegacja }
      ;  digit(D),  !,
            number(D, N),
            { Token = tokNumber(N) }
      ;  letter(L), !, identifier(L, Id),
            { Token = tokIdentyfikator(Id)}
      ;  "_",       !, { Token = toUnder }


      ),
      !,
         { Tokens = [Token | TokList] },
      lexer(TokList)
   ;  [],
         { Tokens = [] }
   ).


white_space -->
   [Char], { code_type(Char, space) }, !, white_space.
white_space -->
   [].


wszystko -->
    [Char], {code_type(Char,ascii),
             \+ code_type(Char, to_lower(40)),
             \+ code_type(Char,to_lower(41)),
             \+ code_type(Char,to_lower(42))},!, wszystko.
wszystko -->
   [].

comment -->
    [Znak],[Znak1], wszystko ,[Znak1],[Znak2],
    { code_type(Znak, to_lower(40)),
      code_type(Znak1, to_lower(42)),
      code_type(Znak2, to_lower(41)) }.
comment --> [].

digit(D) -->
   [D],
      { code_type(D, digit) }.

digits([D|T]) -->
   digit(D),
   !,
   digits(T).
digits([]) -->
   [].

number(D, N) -->
   digits(Ds),
      { number_chars(N, [D|Ds]) }.

letter(L) -->
   [L], { code_type(L, csym);
          code_type(L, to_lower(39))}.

alphanum([A|T]) -->
   [A], { code_type(A, alnum);
          code_type(A, to_lower(95));
          code_type(A, to_lower(39))},
          !, alphanum(T).

alphanum([]) -->
   [].

identifier(L, Id) -->
   alphanum(As),
      { atom_codes(Id, [L|As]) }.

:- op(5, xfy, &).
:- op(5, xfy, *).
:- op(5, xfy, /).
:- op(5, xfy, '%').
:- op(4, xfy, '|').
:- op(4, xfy, +).
:- op(4, xfy, -).
:- op(3, yfx, @).
:- op(2, xfx, =).
:- op(2, xfx, <>).
:- op(2, xfx, <).
:- op(2, xfx, <=).
:- op(2, xfx, >=).
:- op(1, yfx, ,).
:- op(6, fx, ~).
:- op(6, fx, -).
:- op(6, fx, #).

zmienna(Var) -->
    [tokIdentyfikator(Id)],!,
    { Var = var(no,Id) }.


operatorbinarny('=') -->
    [tokRownosc],!.

operatorbinarny('<>') -->
    [tokRomb],!.

operatorbinarny('<') -->
    [tokMniejsze],!.

operatorbinarny('>') -->
    [tokWieksze],!.

operatorbinarny('<=') -->
    [tokLImplikacja],!.

operatorbinarny('>=') -->
    [tokPImplikacja],!.

operatorbinarny('^') -->
    [tokPotega],!.

operatorbinarny('|') -->
    [tokKreska],!.

operatorbinarny('+') -->
    [tokPlus],!.

operatorbinarny('-') -->
    [tokMinus],!.

operatorbinarny('&') -->
    [tokAnd],!.

operatorbinarny('*') -->
    [tokGwiazdka],!.

operatorbinarny('/') -->
    [tokDiv],!.

operatorbinarny('%') -->
    [tokProcent],!.

operatorbinarny('@') -->
    [tokMalpa].

operatorunarny('-') -->
    [tokMinus],!.

operatorunarny('~') -->
    [tokNegacja],!.

operatorunarny('#') -->
    [tokKrzyzyk].


wzorzec(Wzor) -->
    [tokLNawias],!, wzorzec(Wzor), [tokRNawias].

wzorzec(Wzor) -->
    [tokPodkreslenie],!,
    { Wzor = wildcard(no) }.

wzorzec(Wzor) -->
    zmienna(Var),
    { Wzor = Var }.


wzorzec(Wzor) -->
    wzorzec(Wzor1),[tokPrzecinek],wzorzec(Wzor2),
    { Wzor = pair(no, Wzor1, Wzor2) }.

wyrazenie(Wyr) -->
    wyrazenie2(Wyr1), [tokPrzecinek],!, wyrazenie(Wyr2),
    { Wyr = pair(no, Wyr1, Wyr2) }.

wyrazenie(Wyr) --> wyrazenie2(Wyr).


wyrazenie2(Wyr) -->
    [tokIf],!, wyrazenie(Wyr1), [tokThen], wyrazenie(Wyr2), [tokElse], wyrazenie(Wyr3),
    { Wyr = if(no, Wyr1, Wyr2, Wyr3) }.

wyrazenie2(Wyr) -->
    [tokLet],!, wzorzec(Wzor), [tokRownosc], wyrazenie(Wyr1), [tokElse], wyrazenie(Wyr2),
    { Wyr = let(no, Wzor, Wyr1, Wyr2) }.


wyrazenie2(Wyr) --> wyrazenieop(Wyr).

wyrazenieop2(Wyrop) -->
    operatorunarny(Op),!, wyrazenieop(Wyrop1),
    { Wyrop = op(no, Op, Wyrop1) }.

wyrazenieop2(Wyrop) --> simplewyrazenie(Wyrop).



wyrazenieop(Wyrop) -->
    wyrazenieop2(Wyrop1), operatorbinarny(Op),!, wyrazenieop(Wyrop2),
    { Wyrop = op(no,Op ,Wyrop1, Wyrop2) }.

wyrazenieop(Wyr) --> wyrazenieop2(Wyr).


simplewyrazenie2(Wyr) -->  [tokLNawias],!, wyrazenie(Wyr), [tokPNawias].

simplewyrazenie2(Wyr) --> wyrazenieatomowe(Wyr).


simplewyrazenie(Wyr) --> simplewyrazenie2(Wyr).

simplewyrazenie(Wyr) -->
    simplewyrazenie2(Wyr1),!,[tokLKwadratowy], wyrazenie(Wyr2), [tokRKwadratowy],
    { Wyr = bitsel(no, Wyr1, Wyr2) }.

simplewyrazenie(Wyr) -->
    simplewyrazenie2(Wyr1),!,[tokLKwadratowy], wyrazenie(Wyr2), wyrazenie(Wyr3), [tokRKwadratowy],
    { Wyr = bitsel(no, Wyr1, Wyr2, Wyr3) }.


wyrazenieatomowe(WyrA) -->
    zmienna(Var),!,
    {WyrA = var(no,Var)}.

wyrazenieatomowe(WyrA) -->
    [tokIdentyfikator(Id)],!,[tokLNawias],wyrazenie(Wyr),[tokRNawias],
    {WyrA = call(no,Id,Wyr)}.

wyrazenieatomowe(WyrA) -->
    [tokNumber(N)],!,
    {WyrA = num(no,N)}.

wyrazenieatomowe(WyrA) -->
    [tokLKwadratowy],[tokPKwadratowy],!,
    {WyrA = empty(no)}.

wyrazenieatomowe(WyrA) -->
    [tokLKwadratowy],wyrazenie(Wyr),!,[tokRKwadratowy],
    {WyrA = bit(no,Wyr)}.



definicja(Def) -->
    [tokDef],!, [tokIdentyfikator(Id)], wzorzec(Wzor), [tokRownosc], wyrazenie(Wyr),
    { Def = def(Id, Wzor, Wyr) }.

program(Prog) -->
    {Prog = []}.


program(Prog) -->
    definicja(Def), program(Prog1),
    { Prog = [ Def|Prog1 ] },!.



parse(Path,Codes,Program) :-
    lexer(Tokens, Codes, []),
    program(Program,Tokens, []).
