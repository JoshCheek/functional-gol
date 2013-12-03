require 'gol'

Title = -> text { print "\n\e[33m" + text.ljust(20) + "\e[0m" }

Pass = -> { Print["\e[32m.\e[0m"] }
Fail = -> { Print["\e[31m.\e[0m"] }


Title["Boolean"]

If[True][Pass][Fail]
If[False][Fail][Pass]
If[Not[True]][Fail][Pass]
If[Not[False]][Pass][Fail]


Title["Assertions"]

Assert      = -> bool { If[bool][Pass][Fail] }
AssertEqual = -> a { Assert.~ Equal[a] }

Refute      = Assert.~ Not
RefuteEqual = -> a { Refute.~ Equal[a] }

AssertEqual[1][1]
RefuteEqual[2][1]
Assert[True]


Title["Boolean operators"]

Assert[Or[-> { True  }][-> { True  }]]
Assert[Or[-> { False }][-> { True  }]]
Assert[Or[-> { True  }][-> { False }]]
Refute[Or[-> { False }][-> { False }]]

Assert[And[-> { True  }][-> { True  }]]
Refute[And[-> { False }][-> { True  }]]
Refute[And[-> { True  }][-> { False }]]
Refute[And[-> { False }][-> { False }]]


Title["Test Composition"]

Assert[Compose[Not][Not][True]]
Refute[Compose[Not][Not][False]]

Assert[Not.~(Not)[True]]
Refute[Not.~(Not)[False]]


Title["VALUES"]

AssertEqual[1][1]
RefuteEqual[2][1]


Title["LISTS"]

MyCons = Cons[1][Cons[2][nil]]

AssertEqual[Car[MyCons]][1]
RefuteEqual[Car[MyCons]][2]

AssertEqual[Car[Cdr[MyCons]]][2]
RefuteEqual[Car[Cdr[MyCons]]][1]


Title["CONSTRUCTING LISTS"]

AssertEqual[Car[Cons[1][EmptyList]]][1]
AssertEqual[List[EmptyList]][EmptyList]
AssertEqual[Car[List[1][EmptyList]]][1]
AssertEqual[Cdr[List[1][EmptyList]]][EmptyList]
AssertEqual[Car[List[1][2][EmptyList]]][1]
AssertEqual[Car[Cdr[List[1][2][EmptyList]]]][2]
AssertEqual[Cdr[Cdr[List[1][2][EmptyList]]]][EmptyList]
AssertEqual[Car[Cdr[Cdr[List[1][2][3][EmptyList]]]]][3]


Title["ACCESSING LISTS"]

list = List['a']['b']['c'][EmptyList]
AssertEqual['a'][At[list][0]]
AssertEqual['b'][At[list][1]]
AssertEqual['c'][At[list][2]]


Title['LIST SIZE']

AssertEqual[ListSize[EmptyList]][0]
AssertEqual[ListSize[List[2][EmptyList]]][1]
AssertEqual[ListSize[List[2][3][EmptyList]]][2]

AssertEqual[
  SetSize[
    SetAdd[
      SetAdd[Set][100]
    ][100]
  ]
][1]


Title["ListContains"]

Refute[ListContainsInt[List.(EmptyList)        ][1]]
Refute[ListContainsInt[List.(2).(EmptyList)    ][1]]
Assert[ListContainsInt[List.(1).(EmptyList)    ][1]]
Assert[ListContainsInt[List.(1).(2).(EmptyList)][2]]


Title["SET"]

AssertEqual[SetSize[Set]][0]
AssertEqual[SetSize[SetAdd[Set][100]]][1]
AssertEqual[SetSize[SetAdd[SetAdd[Set][100]][200]]][2]


Title["SetContains"]

Refute[SetContainsInt[Set][1]]
Assert[SetContainsInt[SetAdd[Set][1]][1]]
Refute[SetContainsInt[SetAdd[Set][1]][2]]
Assert[SetContainsInt[SetAdd[SetAdd[Set][1]][2]][1]]
Assert[SetContainsInt[SetAdd[SetAdd[Set][1]][2]][2]]
Refute[SetContainsInt[SetAdd[SetAdd[Set][1]][2]][3]]


Title["CELLS"]

Cell1 = Cell[1][2]
AssertEqual[X[Cell1]][1]
AssertEqual[Y[Cell1]][2]

Cell2 = Cell[1][2]
Cell3 = Cell[2][2]
Assert[CellEqual[Cell1][Cell2]]
Refute[CellEqual[Cell1][Cell3]]

Title["BOARD"]


