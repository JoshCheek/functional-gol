# Set     = List[EmptyList]
# SetSize = ListSize
# SetAdd = -> set {
#   -> element {
#     If.(ListContainsInt[set][element])
#       .(-> { set })
#       .(-> { Cons[element][set] })}}
