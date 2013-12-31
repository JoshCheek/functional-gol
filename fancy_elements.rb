require 'boolean'
require 'func_helpers'
require 'simple_list'

# a fancy list is a list whose elements (cars) have the following properties:
#   they are cons whose car is the equality function for the cdr

# wrap (a nicer way to say -> { value })
W = -> i {
  -> { i }
}

FancyElementStruct = -> equality {
  -> data {
    Cons[equality][data]
  }
}

elementStructEquality = Car
elementStructData     = Cdr
elementStructEquals   = -> struct1 {
  -> struct2 {
    elementStructEquality[struct1].(elementStructData[struct1])
                                       .(elementStructData[struct2])
  }
}

FancyElementListContains =
  -> list {
    -> element {
      If.(IsEmpty.(list))
        .(W[False])
        .(-> { Or.(-> {elementStructEquals[Car[list]][element]})
                 .(-> {FancyElementListContains.(Cdr.(list)).(element)})})}}

FancyElementListEquals =
  -> list1 {
    -> list2 {
      If.(And.(->{IsEmpty[list1]})
             .(->{IsEmpty[list2]}))
        .(->{ True })
        .(->{ If.(Or.(->{IsEmpty[list1]})
                    .(->{IsEmpty[list2]}))
                .(-> { False })
                .(-> { If.(elementStructEquals[Car[list1]][Car[list2]])
                         .(-> { FancyElementListEquals[Cdr[list1]][Cdr[list2]]})
                         .(-> { False }) })})}}
