require 'boolean'
require 'func_helpers'
require 'simple_list'

# a fancy list is a list whose elements have the following properties:
#   the car is the equality function for the cdr

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
    W[elementStructEquality[struct1].(elementStructData[struct1])
                                    .(elementStructData[struct2])]
  }
}

FancyListContains =
  -> list {
    -> element {
      If.(IsEmpty.(list))
        .(W[False])
        .(-> { Or.(elementStructEquals[Car[list]][element])
                 .(W[FancyListContains.(Cdr.(list)).(element)])})}}

FancyListEquals =
  -> list1 {
    -> list2 {
      If.(And.(->{IsEmpty[list1]})
             .(->{IsEmpty[list2]}))
        .(->{ True })
        .(->{ If.(Or.(->{IsEmpty[list1]})
                    .(->{IsEmpty[list2]}))
                .(-> { False })
                .(-> {
                  # If.(elementStructEquals[Car[list1]][Car[list2]])
                  If.(elementStructEquality[Car[list1]][elementStructData[Car[list1]]][elementStructData[Car[list2]]])
                    .(-> { FancyListEquals[Cdr[list1]][Cdr[list2]]})
                    .(-> { False }) })})}}

require 'test_framework'

Num = FancyElementStruct.(
  -> int1 {
    -> int2 {
      int1 == int2 ? True : False }})

one = Num[1]
two = Num[2]

Title["FancyListContains"]

Refute[FancyListContains[List.(EmptyList)            ][one]]
Refute[FancyListContains[List.(two).(EmptyList)      ][one]]
Assert[FancyListContains[List.(one).(EmptyList)      ][one]]
Assert[FancyListContains[List.(one).(two).(EmptyList)][two]]


Title['FancyListEquals']

Assert[FancyListEquals[EmptyList][EmptyList]]
Assert[FancyListEquals[List.(EmptyList)][List.(EmptyList)]]
Refute[FancyListEquals[List.(one).(EmptyList)][List.(EmptyList)]]
Refute[FancyListEquals[List.(EmptyList)][List.(one).(EmptyList)]]

Assert[FancyListEquals[List.(one).(EmptyList)][List.(one).(EmptyList)]]
Assert[FancyListEquals[List.(one).(two).(EmptyList)][List.(one).(two).(EmptyList)]]
Refute[FancyListEquals[List.(two).(one).(EmptyList)][List.(one).(two).(EmptyList)]]
