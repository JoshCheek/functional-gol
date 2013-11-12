def title(text)
  puts "\e[33m" + text.center(30, ?*) + "\e[0m"
end

Print = -> x { puts x }
P     = -> x { Print.(x.inspect) }
True  = -> x { -> y { x }     }
False = -> x { -> y { y }     }

Equal = -> value1 {
          -> value2 {
              (value1 == value2) ? True : False }}

If    = -> conditional {
          -> true_case {
            -> false_case {
              conditional.(true_case).(false_case).()}}}

Not   = -> condition {
          If.(condition)
            .(-> { False })
            .(-> { True })}

title "Boolean" #################
Pass = -> { Print["\e[32mPass\e[0m"] }
Fail = -> { Print["\e[31mFAIL\e[0m"] }

If[True][Pass][Fail]
If[False][Fail][Pass]
If[Not[True]][Fail][Pass]
If[Not[False]][Pass][Fail]

title "Assertions" #################
AssertEqual = -> a { -> b { If[Equal[a][b]][Pass][Fail] } }
RefuteEqual = -> a { -> b { If[Equal[a][b]][Fail][Pass] } }

AssertEqual[1][1]
RefuteEqual[2][1]


title "VALUES" #################
AssertEqual[1][1]
RefuteEqual[2][1]

Cons = -> head {
         -> tail {
           -> f {
             f[head][tail]}}}

Car = ->list {
  list[
    -> first {
      -> second {
        first }}]}

Cdr = -> list {
  list[
    -> first {
      -> second {
        second }}]}

title "LISTS" #################
MyCons = Cons[1][Cons[2][nil]]
AssertEqual[Car[MyCons]][1]
RefuteEqual[Car[MyCons]][2]

AssertEqual[Car[Cdr[MyCons]]][2]
RefuteEqual[Car[Cdr[MyCons]]][1]

title "CELLS" #################

Cell = -> x {
         -> y { Cons[x][y] }}

CellEqual = -> cell1 {
              -> cell2 {
                # car(cell1) == car(cell2) && cdr(cell1) == cdr(cell2)
                Equal.(Car[cell1])
                     .(Car[cell2])
                     .(Equal[Cdr[cell1]][Cdr[cell2]])
                     .(False)}}

Cell1 = Cell[1][1]
Cell2 = Cell[1][1]
Cell3 = Cell[2][2]
If[     CellEqual[Cell1][Cell2]  ][Pass][Fail]
If[ Not[CellEqual[Cell1][Cell3]] ][Pass][Fail]

title "CONSTRUCTING LISTS" #################

EmptyList = -> * { raise "Should not call EmptyList" }

List2 = -> previous {
  -> current {
    If.(Equal[current][EmptyList])
      .(-> { previous[EmptyList] })
      .(-> { List2.(
               -> successor {
                 previous[Cons[current][successor]]})})}}

List = -> element {
  If.(Equal[element][EmptyList])
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

__END__
AssertEqual.(List.(EmptyList)).(EmptyList)

OneElementList = List.(1).(EmptyList)
AssertEqual.(Car.(OneElementList)).(1)
AssertEqual.(Cdr.(OneElementList)).(EmptyList)

TwoElementList = List.(1).(2).(EmptyList)
AssertEqual.(Car.(TwoElementList)).(1)
AssertEqual.(Car.(Cdr.(TwoElementList))).(2)
AssertEqual.(Car.(Cdr.(Cdr.(TwoElementList)))).(EmptyList)




#MyList = List.(1).(2).(EmptyList)
#AssertEqual.(Car.(MyList)).(1)
#AssertEqual.(Car.(Cdr.(MyList))).(2)

#Size = -> list { }
#AssertEqual.(Size.(MyList)).(2)
