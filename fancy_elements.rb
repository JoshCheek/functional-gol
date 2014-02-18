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

FancyElementEquals = -> elem1 {
  -> elem2 {
    And.(-> { Car[elem1][Cdr[elem1]][Cdr[elem2]] })
       .(-> { Car[elem2][Cdr[elem2]][Cdr[elem1]] })
  }
}

FancyElementListContains =
  -> list {
    -> element {
      If.(IsEmpty.(list))
        .(W[False])
        .(-> { Or.(-> {FancyElementEquals[Car[list]][element]})
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
                .(-> { If.(FancyElementEquals[Car[list1]][Car[list2]])
                         .(-> { FancyElementListEquals[Cdr[list1]][Cdr[list2]]})
                         .(-> { False }) })})}}

FancyElementListMap =
  -> map {
    -> list {
      If.(IsEmpty.(list))
        .(-> { list })
        .(-> { Cons.(map[Car[list]])
                   .(FancyElementListMap[map][Cdr[list]])})}}

# find, map, take, drop
