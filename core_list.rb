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
