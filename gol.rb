def title(text)
  print "\n\e[33m" + text.ljust(20) + "\e[0m"
end

Compose = -> op1 {
  -> op2 {
    -> operand {
      op1[op2[operand]] }}}

class Proc
  def ~(op)
    Compose[self][op]
  end
end



Print = -> x { print x          }
P     = -> x { Print[x.inspect] }
True  = -> x { -> y { x }       }
False = -> x { -> y { y }       }

Equal = -> value1 {
          -> value2 {
              (value1 == value2) ? True : False }}

If    = -> bool {
          -> true_case {
            -> false_case {
              bool.(true_case).(false_case).()}}}

Not   = -> bool { bool[False][True] }

title "Boolean" #################
Pass = -> { Print["\e[32m.\e[0m"] }
Fail = -> { Print["\e[31m.\e[0m"] }

If[True][Pass][Fail]
If[False][Fail][Pass]
If[Not[True]][Fail][Pass]
If[Not[False]][Pass][Fail]

title "Assertions" #################
Assert      = -> bool { If[bool][Pass][Fail] }
AssertEqual = -> a { Assert.~ Equal[a] }

Refute      = Assert.~ Not
RefuteEqual = -> a { Refute.~ Equal[a] }

AssertEqual[1][1]
RefuteEqual[2][1]
Assert[True]

title "Boolean operators" #################

Or = -> cond1 {
  If.(cond1.())
    .(-> { True })}

And = -> cond1 {
  If.(Not.(cond1.()))
    .(-> { False })}

Assert[Or[-> { True  }][-> { True  }]]
Assert[Or[-> { False }][-> { True  }]]
Assert[Or[-> { True  }][-> { False }]]
Refute[Or[-> { False }][-> { False }]]

Assert[And[-> { True  }][-> { True  }]]
Refute[And[-> { False }][-> { True  }]]
Refute[And[-> { True  }][-> { False }]]
Refute[And[-> { False }][-> { False }]]

title "Test Composition" #################
Assert[Compose[Not][Not][True]]
Refute[Compose[Not][Not][False]]

Assert[Not.~(Not)[True]]
Refute[Not.~(Not)[False]]

title "VALUES" #################
AssertEqual[1][1]
RefuteEqual[2][1]

Cons = -> head {
         -> tail {
           -> f {
             f[head][tail]}}}

Car = -> list {
  list[
    -> head {
      -> tail {
        head }}]}

Cdr = -> list {
  list[
    -> head {
      -> tail {
        tail }}]}

title "LISTS" #################
MyCons = Cons[1][Cons[2][nil]]
AssertEqual[Car[MyCons]][1]
RefuteEqual[Car[MyCons]][2]

AssertEqual[Car[Cdr[MyCons]]][2]
RefuteEqual[Car[Cdr[MyCons]]][1]

title "CONSTRUCTING LISTS" #################

EmptyList = -> * { raise "Should not call EmptyList" }
IsEmpty = -> list { Equal[list][EmptyList] }

List2 = -> previous {
  -> current {
    If.(IsEmpty[current])
      .(-> { previous[EmptyList] })
      .(-> { List2.(
               -> successor {
                 previous[Cons[current][successor]]})})}}

List = -> element {
  If.(IsEmpty[element])
    .(-> { EmptyList })
    .(-> { List2[Cons[element]] })}

AssertEqual[Car[Cons[1][EmptyList]]][1]
AssertEqual[List[EmptyList]][EmptyList]
AssertEqual[Car[List[1][EmptyList]]][1]
AssertEqual[Cdr[List[1][EmptyList]]][EmptyList]
AssertEqual[Car[List[1][2][EmptyList]]][1]
AssertEqual[Car[Cdr[List[1][2][EmptyList]]]][2]
AssertEqual[Cdr[Cdr[List[1][2][EmptyList]]]][EmptyList]
AssertEqual[Car[Cdr[Cdr[List[1][2][3][EmptyList]]]]][3]

title "ACCESSING LISTS"

At = -> list {
  -> index {
    If.(Equal[index][0])
      .(-> { Car[list] } )
      .(-> { At[Cdr[list]][index-1] })}}

list = List['a']['b']['c'][EmptyList]
AssertEqual['a'][At[list][0]]
AssertEqual['b'][At[list][1]]
AssertEqual['c'][At[list][2]]

ListSize = -> list {
  If.(IsEmpty[list])
    .(-> { 0 })
    .(-> { 1 + ListSize[Cdr[list]] }) }

AssertEqual[ListSize[EmptyList]][0]
AssertEqual[ListSize[List[2][EmptyList]]][1]
AssertEqual[ListSize[List[2][3][EmptyList]]][2]

title "ListContains"

ListContains = -> list {
  -> element {
    If.(IsEmpty.(list))
      .(-> { False })
      .(-> { Or.(-> { Equal.(Car.(list)).(element) })
               .(-> { ListContains.(Cdr.(list)).(element) })})}}

Refute[ListContains[List.(EmptyList)        ][1]]
Refute[ListContains[List.(2).(EmptyList)    ][1]]
Assert[ListContains[List.(1).(EmptyList)    ][1]]
Assert[ListContains[List.(1).(2).(EmptyList)][2]]

title "SET" #################
Set     = List[EmptyList]
SetSize = ListSize
SetAdd = -> set {
  -> element {
    If.(ListContains[set][element])
      .(-> { set })
      .(-> { Cons[element][set] })}}

AssertEqual[SetSize[Set]][0]
AssertEqual[SetSize[SetAdd[Set][100]]][1]
AssertEqual[SetSize[SetAdd[SetAdd[Set][100]][200]]][2]

AssertEqual[
  SetSize[
    SetAdd[
      SetAdd[Set][100]
    ][100]
  ]
][1]

title "SetContains" ##########

SetContains = ListContains

Refute[SetContains[Set][1]]
Assert[SetContains[SetAdd[Set][1]][1]]
Refute[SetContains[SetAdd[Set][1]][2]]
Assert[SetContains[SetAdd[SetAdd[Set][1]][2]][1]]
Assert[SetContains[SetAdd[SetAdd[Set][1]][2]][2]]
Refute[SetContains[SetAdd[SetAdd[Set][1]][2]][3]]


title "CELLS" #################

Cell = -> x {
         -> y { List[x][y][EmptyList] }}

X = -> cell { At[cell][0] }
Y = -> cell { At[cell][1] }

# if we had list equality, we could just delegate to that
# and then this function would go away
CellEqual = -> cell1 {
              -> cell2 {
                Equal.(X[cell1])
                     .(X[cell2])
                     .(Equal[Y[cell1]][Y[cell2]])
                     .(False)}}

Cell1 = Cell[1][2]
AssertEqual[X[Cell1]][1]
AssertEqual[Y[Cell1]][2]

Cell2 = Cell[1][2]
Cell3 = Cell[2][2]
Assert[CellEqual[Cell1][Cell2]]
Refute[CellEqual[Cell1][Cell3]]


title "BOARD" #################

#Board = Set


