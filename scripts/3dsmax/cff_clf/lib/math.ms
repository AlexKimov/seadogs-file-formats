/*

*/

struct maxMath
(
  fn radToEuler radians =
  (
    const = (180/pi)
    result = eulerAngles (radians.x * const) (radians.y * const) (radians.z * const)
  ),
  fn rotateMatByAngles angles matrix: =
  (
    if matrix == unsupplied then
      local transformMatrix = matrix3 1
    else
      local transformMatrix = matrix	

    transformMatrix = preRotateY transformMatrix angles.y     
    transformMatrix = preRotateX transformMatrix angles.x            
    transformMatrix = preRotateZ transformMatrix angles.z

    result = transformMatrix	
  )  
)

mathFunction = maxMath()