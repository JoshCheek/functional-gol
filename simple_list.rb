# this cheats

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
