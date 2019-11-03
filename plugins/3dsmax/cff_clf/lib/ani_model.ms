/*

*/

struct  aniSceneHeader
(
  objectCount = 0,
  frameCount = 0
)

struct aniSceneObject
(
  type = 0,
  frame = 0,
  name = 0
)

struct aniAnimationFrame
(
  position = (point3 0 0 0),
  rotation = (point4 0 0 0 0),
  time = 0
)

struct aniScene
(
  header = aniSceneHeader(),
  objects = #(),
  animations = #()
)