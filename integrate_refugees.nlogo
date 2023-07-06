breed [migrant migrants]
breed [local locals]
turtles-own [
  language cultural religious integration_acceptance
]
migrant-own[
  number_integrated
  factor_migration
  learning_language
]

to  setup
 clear-all

  create-migrant number_migrant [
    set xcor 2 + random 14
    set ycor random-ycor
    set shape "person"
    set color green
    set factor_migration random-float 1
    set learning_language random-float 1
    set language random 2
    set cultural random 2
    set religious random 2

  ]

  create-local number_local [
    set xcor -16 + random 16
    set ycor random-ycor
    set shape "person"
    set color blue
    set language random 2
    set cultural random 2
    set religious random 2
  ]
  draw-circle

  reset-ticks
  setup-plots
end

to draw-circle
  let side-length 41
  let height 100
  let width 100
  create-turtles 1 [
    set shape "square"
    set size side-length
    setxy 16 -1
    set heading 0
    set color gray - 3
    pen-down
    fd height
    rt 90
    pen-up
    stamp
    die
  ]
end

to go

move-turtles
  ask turtles with [breed = migrant]
  [
    if xcor >= -1[
    create-links-to other migrant in-radius 1.5  [set color green + 3]
    ]
  ]
  ask migrant with [round xcor > -1 and factor_migration >= 0.5][
    if random 100 < speed_intake [
      set heading 270 fd 1
    ]
  ]
    ask migrant with [round xcor <= 0]
  [
    ask links with [color = green + 3] [ die ]
]

ask turtles with [round xcor <= -1][                                   ; interactions between groups
   ifelse breed = local [  ; probability of interaction with members of the other group based on their liberal attitude/tolerance
      create-links-to other local in-radius 1.5                        ; probability of interaction with  members of the own group occurrig by default
      ask my-out-links [set color blue]
    ][integration]
  ]

tick
end

to-report random-number-mig
  let random-number random 100 + 1
  let rn round random-number
  report rn
end

to move-turtles
    ask turtles with [round xcor <= -1] [        ; turtles satisfied  with their neighborhood move and explore the social world
     rt random-float 360  fd 1
     if not is-patch? patch-ahead 1 [back 1 rt 90]          ; to avoid boundary effects
     if [pxcor] of patch-here = 0 [back 1 rt 90]
    ask my-out-links [if [patch-here] of end2 != [neighbors] of end1 [die]]   ; to avoid visualization of links in other regions
      ]
    ask turtles with [round xcor >= -1] [        ; turtles satisfied  with their neighborhood move and explore the social world
           rt random-float 360  fd 1
       if not is-patch? patch-ahead 1 [back 1 rt 90]          ; to avoid boundary effects
       if [pxcor] of patch-here = 0 [back 1 rt 90]
     ask my-out-links [if [patch-here] of end2 != [neighbors] of end1 [die]]   ; to avoid visualization of links in other regions
  ]
end

to integration
  ask turtles with [breed = migrant] [
  set integration_acceptance cultural + religious + language

  if xcor <= -1 and integration_acceptance >= 2 and factor_migration >= 0.5 and learning_language >= 0.5 [
    create-links-to local in-radius 1.5
    ask my-out-links [set color yellow]
  ]

  if xcor <= -1 and integration_acceptance < 2 and learning_language < 0.5[
    set color red ; Rejection
  ]
]
end
@#$#@#$#@
GRAPHICS-WINDOW
215
10
766
562
-1
-1
16.455
1
10
1
1
1
0
0
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
6
284
98
346
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
101
283
191
345
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
0
219
188
252
speed_intake
speed_intake
0
100
22.0
1
1
max
HORIZONTAL

PLOT
1133
10
1512
281
migrant_intake
ticks
migrant
0.0
100.0
0.0
1.5
true
false
"plot count migrant with [xcor <= -3]" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count migrant with [xcor <= 0] / count migrant"

SLIDER
3
127
190
160
number_local
number_local
0
1000
109.0
1
1
NIL
HORIZONTAL

SLIDER
0
176
190
209
number_migrant
number_migrant
0
1000
486.0
1
1
NIL
HORIZONTAL

PLOT
769
10
1132
280
Level_language_migrant
NIL
NIL
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"High learning" 1.0 0 -2674135 true "" "plot (count migrant with [ xcor <= -1 and learning_language >= 0.5])"
"Low learning" 1.0 0 -13345367 true "" "plot (count migrant with [ xcor <= -1 and learning_language < 0.5])"

PLOT
766
280
1133
564
Persons non-migrated x Persons migrated
time
number-possible-migrant
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"People non-migrated" 1.0 0 -16777216 true "" "plot count migrant with [xcor > 0]"
"People migrated" 1.0 0 -11221820 true "" "plot count migrant with [xcor < 0]"

PLOT
1134
282
1512
566
Integrated x non-integrates
time
Count of migrants
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"integrated" 1.0 0 -1184463 true "" "plot count turtles with [xcor <= 0 and any? my-out-links with [color = yellow]]\n\n"
"non-integrated" 1.0 0 -2674135 true "" "plot count turtles with [xcor <= 0 and color = red]"

@#$#@#$#@
## WHAT IS IT?

The integration of refugees refers to the process by which forcibly displaced individuals, due to conflicts, human rights violations, or other difficult circumstances, adapt and join the society of the host country. Integration involves creating a sense of belonging and mutual acceptance between refugees and members of the host society, as well as the active participation of refugees in all aspects of social, economic, cultural, and political life in the community.

This model depicts the process of refugee integration.

## HOW IT WORKS?

The simulation begins by creating a population of migrants and a local population. Each agent is assigned an ethnicity: "local" (represented by the color blue) or "migrant" (represented by the color green).

Each agent is characterized by their "language," "religious," and "culture," which can be 0 or 1. Migrants with a "factor_migration" less than 0.5 are considered agents who do not have the ability to migrate, while those with a "factor_migration" equal to or greater than 0.5 are considered agents who have the ability to migrate. Additionally, migrants with a "learning_language" equal to or greater than 0.5 have learned the language of the host country more rapidly, increasing their chances of integration into the host community.

The variable "integration_acceptance" determines whether a migrant can immigrate by summing the values of "language," "culture," and "religious." If the sum is greater than or equal to 2, the migrants can move towards the host community. These migrants retain their green color and create links with other agents who have a "factor_migration" greater than or equal to 0.5. On the other hand, red agents are migrants who have immigrated but do not meet the integration criteria (they can be considered as rejected).

In summary, the simulation creates a population of migrants and locals, assigns attributes to each agent such as language, culture, religious beliefs, and migration factors. It evaluates the integration acceptance of migrants based on their attributes and determines their ability to move towards the host community. The simulation aims to explore how these factors impact the integration of migrants into the local community.


## HOW TO USE IT

- number_local [0,1000]: number local agents
- number_migrant [0,1000] number migrant agents
- speed_intake [0, 100]: percentage of migrant agents moving together to host country

## THINGS TO NOTICE

In our simulation, we have four histograms:

1.  "level_language_migrant" represents the level of language learning among migrants. The red color is assigned to migrants with a high level of language learning, while the blue color represents migrants with a low level of language learning.

2.  "Persons non-migrated X Persons migrated" represents the number of migrants who have successfully migrated versus those who have not migrated.

3.  "Integrated X Non-integrated" represents the number of migrants who have successfully integrated into the host community versus those who have not integrated

4.   'migrant-intake' represents percentage of migrant agents moving together to host country

## REFERENCES

model by Smiralda Milfort based on MigrAgent of Rocco Paolillo.

Rocco Paolillo, Wander Jager (2018, November 28). “MigrAgent” (Version 1.2.0). CoMSES Computational Model Library. Retrieved from: https://doi.org/10.25937/b454-rq57
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiments" repetitions="20" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>count turtles with [round xcor &lt;=  -1]</metric>
    <metric>count migrant with [round xcor &lt;=  -1]</metric>
    <metric>count migrant with [round xcor &gt;  -1]</metric>
    <metric>count local with [conservatism &lt; 0]</metric>
    <metric>count local with [conservatism &gt;= 0]</metric>
    <metric>count migrant with [round xcor &gt;  -1 and conservatism  &lt; 0]</metric>
    <metric>count migrant with [round xcor &gt;  -1 and conservatism  &gt;=  0]</metric>
    <metric>count migrant with [round  xcor &lt;=  -1 and conservatism  &lt; 0]</metric>
    <metric>count migrant with [round  xcor &lt;=  -1 and conservatism  &gt;=  0]</metric>
    <metric>mean [conservatism] of local</metric>
    <metric>variance [conservatism] of local</metric>
    <metric>mean [conservatism] of migrant</metric>
    <metric>variance [conservatism] of migrant</metric>
    <metric>mean [conservatism] of local with [conservatism  &lt; 0]</metric>
    <metric>variance [conservatism] of local with [conservatism  &lt; 0]</metric>
    <metric>mean [conservatism] of local with [conservatism &gt;=  0]</metric>
    <metric>variance [conservatism] of local with [conservatism &gt;=  0]</metric>
    <metric>mean [conservatism] of migrant with [conservatism  &lt; 0]</metric>
    <metric>variance [conservatism] of migrant with [conservatism  &lt; 0]</metric>
    <metric>mean [conservatism] of migrant with [conservatism &gt;=  0]</metric>
    <metric>variance [conservatism] of migrant with [conservatism &gt;=  0]</metric>
    <metric>count links with [[breed] of end1 = migrant and [conservatism] of end1 &lt; 0 and [breed] of end2 = local and [conservatism] of end2 &lt; 0]</metric>
    <metric>count links with [[breed] of end1 = migrant and [conservatism] of end1 &lt; 0 and [breed] of end2 = local and [conservatism] of end2 &gt;= 0]</metric>
    <metric>count links with [[breed] of end1 = migrant and [conservatism] of end1  &gt;=   0 and [breed] of end2 = local and [conservatism] of end2 &lt; 0]</metric>
    <metric>count links with [[breed] of end1 = migrant and [conservatism] of end1 &gt;= 0 and [breed] of end2 = local and [conservatism] of end2 &gt;= 0]</metric>
    <metric>count links with [[breed] of end1 = local and [conservatism] of end1 &lt; 0 and [breed] of end2 = migrant and [conservatism] of end2 &lt; 0]</metric>
    <metric>count links with [[breed] of end1 = local and [conservatism] of end1 &lt; 0 and [breed] of end2 = migrant and [conservatism] of end2 &gt;= 0]</metric>
    <metric>count links with [[breed] of end1 = local and [conservatism] of end1 &gt;=  0 and [breed] of end2 = migrant and [conservatism] of end2 &lt; 0]</metric>
    <metric>count links with [[breed] of end1 = local and [conservatism] of end1 &gt;= 0 and [breed] of end2 = migrant and [conservatism] of end2 &gt;= 0]</metric>
    <metric>count local with [conservatism &lt; 0 and any? my-in-links with [[breed] of end1 = [breed] of myself] and any? my-in-links with [[breed] of end1 != [breed] of myself]]</metric>
    <metric>count local with [conservatism &lt; 0 and any? my-in-links with [[breed] of end1 != [breed] of myself] and not any? my-in-links with [[breed] of end1 = [breed] of myself]]</metric>
    <metric>count local with [conservatism &lt; 0 and any? my-in-links with [[breed] of end1 = [breed] of myself] and not any? my-in-links with [[breed] of end1 != [breed] of myself]]</metric>
    <metric>count local with [conservatism &lt; 0 and not any? my-in-links with [[breed] of end1 = [breed] of myself] and not any? my-in-links with [[breed] of end1 != [breed] of myself]]</metric>
    <metric>count local with [conservatism &gt;= 0 and any? my-in-links with [[breed] of end1 = [breed] of myself] and any? my-in-links with [[breed] of end1 != [breed] of myself]]</metric>
    <metric>count local with [conservatism &gt;= 0 and any? my-in-links with [[breed] of end1 != [breed] of myself] and not any? my-in-links with [[breed] of end1 = [breed] of myself]]</metric>
    <metric>count local with [conservatism &gt;= 0 and any? my-in-links with [[breed] of end1 = [breed] of myself] and not any? my-in-links with [[breed] of end1 != [breed] of myself]]</metric>
    <metric>count local with [conservatism &gt;= 0 and not any? my-in-links with [[breed] of end1 = [breed] of myself] and not any? my-in-links with [[breed] of end1 != [breed] of myself]]</metric>
    <metric>count migrant with [round xcor &lt;=  -1 and conservatism &lt; 0 and any? my-in-links with [[breed] of end1 = [breed] of myself] and any? my-in-links with [[breed] of end1 != [breed] of myself]]</metric>
    <metric>count migrant with [round xcor &lt;=  -1 and conservatism &lt; 0 and any? my-in-links with [[breed] of end1 != [breed] of myself] and not any? my-in-links with [[breed] of end1 = [breed] of myself]]</metric>
    <metric>count migrant with [round xcor &lt;=  -1 and conservatism &lt; 0 and any? my-in-links with [[breed] of end1 = [breed] of myself] and not any? my-in-links with [[breed] of end1 != [breed] of myself]]</metric>
    <metric>count migrant with [round xcor &lt;=  -1 and conservatism &lt; 0 and not any? my-in-links with [[breed] of end1 = [breed] of myself] and not any? my-in-links with [[breed] of end1 != [breed] of myself]]</metric>
    <metric>count migrant with [round xcor &lt;=  -1 and conservatism &gt;= 0 and any? my-in-links with [[breed] of end1 = [breed] of myself] and any? my-in-links with [[breed] of end1 != [breed] of myself]]</metric>
    <metric>count migrant with [round xcor &lt;=  -1 and conservatism &gt;= 0 and any? my-in-links with [[breed] of end1 != [breed] of myself] and not any? my-in-links with [[breed] of end1 = [breed] of myself]]</metric>
    <metric>count migrant with [round xcor &lt;=  -1 and conservatism &gt;= 0 and any? my-in-links with [[breed] of end1 = [breed] of myself] and not any? my-in-links with [[breed] of end1 != [breed] of myself]]</metric>
    <metric>count migrant with [round xcor &lt;=  -1 and conservatism &gt;= 0 and not any? my-in-links with [[breed] of end1 = [breed] of myself] and not any? my-in-links with [[breed] of end1 != [breed] of myself]]</metric>
    <enumeratedValueSet variable="migrant_plot">
      <value value="&quot;liberal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conservatism_local">
      <value value="-0.75"/>
      <value value="-0.25"/>
      <value value="0"/>
      <value value="0.25"/>
      <value value="0.75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="speed_intakes">
      <value value="1"/>
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="local_plot">
      <value value="&quot;population&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conservatism_migrant">
      <value value="-0.75"/>
      <value value="-0.25"/>
      <value value="0"/>
      <value value="0.25"/>
      <value value="0.75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number_migrant">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number_local">
      <value value="500"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Circle -7500403 true true 135 135 30
@#$#@#$#@
0
@#$#@#$#@
