def title(text)
  puts "\n" + "*"*10 + "\e[32m#{text}\e[0m"
end
Equal = -> value1 {
          -> value2 {
              (value1 == value2) ? True : False }}

Print = -> (x) { puts x.inspect }

True = -> (x) {
  -> (y) {
    x
  }
}

False = -> (x) {
  -> (y) {
    y
  }
}

Not = -> condition {
  If.(condition).(-> { False }).(-> { True })
}

Pass   = -> { Print.("P")}
Fail   = -> { Print.("FAIL!!")}
AssertEqual = -> a { -> b { If.(Equal.(a).(b)).(Pass).(Fail) } }
RefuteEqual = -> a { -> b { If.(Equal.(a).(b)).(Fail).(Pass) } }

If = -> conditional {
       -> true_case {
         -> false_case {
           conditional.(true_case).(false_case).()}}}

title "Assertions"
AssertEqual.(1).(1)
RefuteEqual.(2).(1)


title "Boolean"
If.(True).(Pass).(Fail)
If.(False).(Fail).(Pass)
If.(Not.(True)).(Fail).(Pass)
If.(Not.(False)).(Pass).(Fail)


title "VALUES" #################
AssertEqual.(1).(1)
RefuteEqual.(2).(1)

Cons = -> head {
  -> tail {
    -> f {
      f.(head).(tail)}}}

Car = ->list {
  list.(-> first {
          -> second {
            first }})}

Cdr = -> list {
  list.(-> first {
          -> second {
            second }})}

title "LISTS" #################
MyCons = Cons.(1).(Cons.(2).(nil))
AssertEqual.(Car.(MyCons)).(1)
RefuteEqual.(Car.(MyCons)).(2)

AssertEqual.(Car.(Cdr.(MyCons))).(2)
RefuteEqual.(Car.(Cdr.(MyCons))).(1)

title "CELLS" #################

Cell = -> x {
         -> y {
           Cons.(x).(y) }}

CellEqual = -> cell1 {
  -> cell2 {
    Equal.(Car.(cell1))
    .(Car.(cell2)).(
      Equal.(Cdr.(cell1)).(Cdr.(cell2)).(True).(False)
    ).(
      False
    )
  }
}

Cell1 = Cell.(1).(1)
Cell2 = Cell.(1).(1)
Cell3 = Cell.(2).(2)
If.(CellEqual.(Cell1).(Cell2)).(Pass).(Fail)
If.(Not.(CellEqual.(Cell1).(Cell3))).(Pass).(Fail)

title "LISTS"

EmptyList = -> x=nil {
  raise "Should not call EmptyList"
}

List2 = -> half_cons {
  -> successor {
    # (1...
    # 2
    If.(Equal.(successor).(EmptyList))
      .(-> { half_cons.(EmptyList) })

  }
}

List = -> element {
  If.(Equal.(element).(EmptyList))
    .(-> { EmptyList })
    .(
      -> {
        List2.(Cons.(element))
      }
    )
}

AssertEqual.(Car.(Cons.(1).(EmptyList))).(1)
AssertEqual.(List.(EmptyList)).(EmptyList)
AssertEqual.(Car.(EmptyList)).(EmptyList)
AssertEqual.(Cdr.(EmptyList)).(EmptyList)


# AssertEqual.(Car.(List.(1).(EmptyList))).(1)

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
