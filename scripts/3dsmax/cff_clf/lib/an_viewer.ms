/*

*/

filein "lib/max.ms"

struct anViewerSettings
(
  startFrame = 1,
  endFrame = 0,
  showSkeleton = true,
  addAnimations = false
)

struct anViewer
(
  object,
  settings = anViewerSettings(),
 -- transform bone coordinates to 3dsmax ones
  fn transformCoordinates pos =
  (
    result = (point3 pos.x pos.y pos.z)
  ),
  fn create =
  ( 
    with undo off, redraw off
	(
      if settings.showSkeleton then 
	  (	
        skeletoneBones = #()
        rootBone = bone pos:(transformCoordinates object.anBones[1].position) name:"Root Bone"
        append skeletoneBones rootBone
    
        for i = 2 to object.anBones.count do
        (
          bne =  object.anBones[i]
          parentBone = skeletoneBones[bne.parentId + 1]
          in parentBone skelBone = \
            bone pos:(parentBone.position + (transformCoordinates bne.position))
          append skeletoneBones skelBone
        )   
      )

      if settings.addAnimations then 
	  (
        progressStart "creating animations"
        progress = (100.0/object.header.boneCount as float)     
    
        max.animation.setLength object.header.frameCount
        for boneIndex = 1 to object.header.boneCount do
        (
          boneRotations = object.animations.boneRotations[boneIndex]
          for i = 1 to object.header.frameCount do
          (
            rootBonePosition = object.animations.positions[i]
            boneRotation = boneRotations[i]
             
            bne = skeletoneBones[boneIndex]
            max.controller.addKey bne.position.controller i
            max.controller.addKey bne.rotation.controller i     
            animate on
            (   
              at time (i - 1) bne.position.controller.value = rootBonePosition
              at time (i - 1) bne.rotation.controller.value = boneRotation
            )
          )
          progressUpdate (progress*boneIndex)
          if getProgressCancel() then 
          (
            setProgressCancel true  
            exit        
          )       
        )
    
        progressEnd()  	  
	  )
    )
  )
)