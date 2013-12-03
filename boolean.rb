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
