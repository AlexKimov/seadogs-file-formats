/*

*/


struct anHeader
(
  frameCount = 0,
  boneCount = 0,
  speed = 0
)

struct anBone
(
  position = (point3 0 0 0),
  parentId = 0  
)

struct anAnimations
(
  positions = #(),
  boneRotations = #()
)

struct anObject
(
  header = anHeader(),
  anBones = #(),
  animations = anAnimations() 
)