require 'test_framework'
require 'fancy_elements'

RubyPrimitiveEquals = -> prim1 {
    -> prim2 {
      prim1 == prim2 ? True : False }}

RubyPrimitive = FancyElementStruct.(RubyPrimitiveEquals)


one   = RubyPrimitive[1]
two   = RubyPrimitive[2]
three = RubyPrimitive[3]
four  = RubyPrimitive[4]
five  = RubyPrimitive[5]
six   = RubyPrimitive[6]

corey     = RubyPrimitive['corey']
not_corey = RubyPrimitive['not_corey']

Title["FancyElementEquality"]
Assert[FancyElementEquals[one][one]]
Refute[FancyElementEquals[one][two]]


Title["FancyElementListContains"]

Refute[FancyElementListContains[List.(EmptyList)            ][one]]
Refute[FancyElementListContains[List.(two).(EmptyList)      ][one]]
Assert[FancyElementListContains[List.(one).(EmptyList)      ][one]]
Assert[FancyElementListContains[List.(one).(two).(EmptyList)][two]]

Assert[FancyElementListContains[List.(corey).(EmptyList)    ][corey]]
Refute[FancyElementListContains[List.(corey).(EmptyList)    ][not_corey]]


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
jOsh = ReversableText["jOsh"]

Assert[FancyElementListEquals[List.(josh).(EmptyList)][List.(hsoj).(EmptyList)]]
Refute[FancyElementListEquals[List.(josh).(EmptyList)][List.(jOsh).(EmptyList)]]
Refute[FancyElementListEquals[List.(jOsh).(EmptyList)][List.(hsoj).(EmptyList)]]


Title['FancyElementListMap']

double_num = -> fancy_num {
  RubyPrimitive[Cdr[fancy_num] * 2]
}

Assert[FancyElementEquals[double_num[one]][two]]


list     = List.(one).(two).(three).(EmptyList)
expected = List.(two).(four).(six).(EmptyList)
mapper = FancyElementListMap[double_num]
actual   = mapper[list]

Assert[FancyElementListEquals[EmptyList][mapper[EmptyList]]]
Assert[FancyElementListEquals[expected][actual]]

