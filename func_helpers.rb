Compose = -> op1 {
  -> op2 {
    -> operand {
      op1[op2[operand]] }}}

class Proc
  def ~(op)
    Compose[self][op]
  end
end
