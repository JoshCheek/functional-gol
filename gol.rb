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

Or = -> cond1 {
  If.(cond1.())
    .(-> { True })}

And = -> cond1 {
  If.(Not.(cond1.()))
    .(-> { False })}

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

At = -> list {
  -> index {
    If.(Equal[index][0])
      .(-> { Car[list] } )
      .(-> { At[Cdr[list]][index-1] })}}

ListSize = -> list {
  If.(IsEmpty[list])
    .(-> { 0 })
    .(-> { 1 + ListSize[Cdr[list]] }) }

ListContains = -> equals {
  -> list {
    -> element {
      If.(IsEmpty.(list))
        .(-> { False })
        .(-> { Or.(-> { equals.(Car.(list)).(element) })
                 .(-> { ListContains[equals].(Cdr.(list)).(element) })})}}
}

ListContainsInt = ListContains[Equal]

Set     = List[EmptyList]
SetSize = ListSize
SetAdd = -> set {
  -> element {
    If.(ListContainsInt[set][element])
      .(-> { set })
      .(-> { Cons[element][set] })}}

SetContainsInt = ListContainsInt


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

#Board = Set
