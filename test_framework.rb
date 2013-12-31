require 'io'
require 'boolean'

Title = -> text { print "\n\e[33m" + text.ljust(20) + "\e[0m" }

Pass = -> { Print["\e[32m.\e[0m"] }
Fail = -> { Print["\e[31m.\e[0m"] }


Assert      = -> bool { If[bool][Pass][Fail] }
AssertEqual = -> a { Assert.~ Equal[a] }

Refute      = Assert.~ Not
RefuteEqual = -> a { Refute.~ Equal[a] }
