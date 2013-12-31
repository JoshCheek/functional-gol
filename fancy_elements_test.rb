require 'test_framework'
require 'fancy_elements'

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
