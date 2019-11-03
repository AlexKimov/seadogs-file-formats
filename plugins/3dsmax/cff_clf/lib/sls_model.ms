/*

*/

struct slsModelVertex
(
  position = (point3 0 0 0)
)

struct slsModelFace
(
  indexes = (point3 0 0 0),
  uv1 = (point2 0 0),
  uv2 = (point2 0 0),
  uv3 = (point2 0 0)  
)

struct slsYardModel
(
  filename = "",
  vertexes = #(),
  faces = #()
)

struct slsMast
(
  type = 0,
  unknown = 0,
  matrix = matrix3 1,
  yards = #()
)

struct slsModel
(
  masts = #()
)