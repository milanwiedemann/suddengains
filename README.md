# suddengains: R package for identifying sudden gains in psychological therapies

here some random notes, need to tidy this up at some point!
some functions wont work if the measure of the variable that the sudden gains are being analysed on starts with "sg".
this will conflict with the variables that get created for the bysg and byperson datasets.
there I think it shold be recommended to rename variables in this special case!

variables for identify sg must be numbered in a specific way. alpha (e.g. 'w' for week or 's' for session) and then session number in digit.
this is important as identify function automaticall checks for s0 intake score. 
if this is provided it will calculate sg after the first sessoin and name variables in that way starting qwith sg_1to2
if s0 is not provided it will name variables starting with sg_2to3
