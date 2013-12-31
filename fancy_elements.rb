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
        .(-> { Or.(W[elementStructEquals[Car[list]][element]])
                 .(W[FancyElementListContains.(Cdr.(list)).(element)])})}}

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

require 'test_framework'

Num = FancyElementStruct.(
  -> int1 {
    -> int2 {
      int1 == int2 ? True : False }})

one = Num[1]
two = Num[2]


Title["FancyElementListContains"]

Refute[FancyElementListContains[List.(EmptyList)            ][one]]
Refute[FancyElementListContains[List.(two).(EmptyList)      ][one]]
Assert[FancyElementListContains[List.(one).(EmptyList)      ][one]]
Assert[FancyElementListContains[List.(one).(two).(EmptyList)][two]]


Title['FancyElementListEquals']

Assert[FancyElementListEquals[EmptyList][EmptyList]]
Assert[FancyElementListEquals[List.(EmptyList)][List.(EmptyList)]]
Refute[FancyElementListEquals[List.(one).(EmptyList)][List.(EmptyList)]]
Refute[FancyElementListEquals[List.(EmptyList)][List.(one).(EmptyList)]]

Assert[FancyElementListEquals[List.(one).(EmptyList)][List.(one).(EmptyList)]]
Assert[FancyElementListEquals[List.(one).(two).(EmptyList)][List.(one).(two).(EmptyList)]]
Refute[FancyElementListEquals[List.(two).(one).(EmptyList)][List.(one).(two).(EmptyList)]]
Refute[FancyElementListEquals[List.(one).(two).(EmptyList)][List.(two).(one).(EmptyList)]]

ReversableText = FancyElementStruct.(
  -> txt1 {
    -> txt2 {
      (txt1 == txt2 || txt1.reverse == txt2) ? True : False
    }
  }
)

josh = ReversableText["josh"]
hsoj = ReversableText["hsoj"]

Assert[FancyElementListEquals[List.(josh).(EmptyList)][List.(hsoj).(EmptyList)]]
