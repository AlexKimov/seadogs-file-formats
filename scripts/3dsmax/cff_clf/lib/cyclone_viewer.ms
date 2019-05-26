/*

*/

filein "max.ms"
filein "system.ms"
filein "utils.ms"

struct cycloneViewerSettings
(
  texturesPath = "",
  isTextured = True,
  texFormat = "tf",
  lodIndex = 1,
  frameIndex = 0, 
  to3dsMaxSystem = True 
)

struct cyclonSceneViewer
(
  materials = #(),
  objects = #()
)

struct cycloneMeshViewer
(
  fn create modelMesh modelPos modelScale materials: =
  ( 
    local faceArray = #()   
    local vertArray = #()    

    for vert in modelMesh.vertexes do 
    (     
      local x = modelPos.x + (vert.coordinates.x * modelScale.x) / 32767.0 
      local y = modelPos.y + (vert.coordinates.y * modelScale.y) / 32767.0  
      local z = modelPos.z + (vert.coordinates.z * modelScale.z) / 32767.0  
      
      append vertArray [x, y, z]   
    )  
    
    for face in modelMesh.faces do 
    (      
      face.indexes.x += 1 
      face.indexes.y += 1 
      face.indexes.z += 1 
      append faceArray face.indexes
    )     
    
    if materials != unsupplied then
    (
      tvertArray = #()  
      for vert in modelMesh.vertexes do 
      (   
        local uvX = vert.uv.x/modelMesh.header.uvDelim    
        local uvY = vert.uv.y/modelMesh.header.uvDelim          
        append tvertArray [uvX, -uvY, 0]
      )    
      
      msh = max.createTexturedMesh vertArray faceArray tvertArray \
        name:modelMesh.header.name
      
      max.material.addMaterialToMesh msh materials[modelMesh.header.textureIndex + 1]
    )
    else
      msh = max.createMesh vertArray faceArray name:modelMesh.header.name
    
    result = msh      
  )
)

struct cycloneAnimationViewer
(
  fn create msh frame =
  (
    local angles = eulerAngles (frame.rotation.x * (180/pi)) \
      (frame.rotation.y * (180/pi)) (frame.rotation.z * (180/pi))
        
    local transformMatrix = matrix3 1
    transformMatrix.row4 = frame.position
    transformMatrix = preRotateY transformMatrix angles.y      
    transformMatrix = preRotateX transformMatrix angles.x    
    transformMatrix = preRotateZ transformMatrix angles.z       
     
    max.controller.addKey msh.position.controller frame.time
    max.controller.addKey msh.rotation.controller frame.time 
    
    animate on
    (   
      at time frame.time msh.position.controller.value = transformMatrix.translationpart 
      at time frame.time msh.rotation.controller.value = transformMatrix.rotationpart
    )
  )
)

struct modelViewer
(
  model,
  scene = cyclonSceneViewer(),
  settings = cycloneViewerSettings(),
  meshViewer = cycloneMeshViewer(),  
  animationViewer = cycloneAnimationViewer(),  
  fn addMaterial name =
  (
    basename = fileUtils.getFileName name
    filepath = settings.texturesPath + "/" + basename + "." + settings.texFormat
    bitmapMaterial = max.material.createMaterialFromBitmap filepath basename

    if bitmapMaterial == undefined then
    (    
      standMat = max.material.createStandardMaterial true basename
      standMat.diffuseMap = max.material.createTextureMap name
      standMat.twoSided = True
      result = standMat
    )
    else
    ( bitmapMaterial.twoSided = True
      result = bitmapMaterial
    )  
  ),
  fn addMesh modelMesh modelOrigin modelScale mats: =
  (
    if mats == unsupplied then
      newMesh = meshViewer.create modelMesh modelOrigin modelScale
    else
      newMesh = meshViewer.create modelMesh modelOrigin modelScale materials:mats 

    result = newMesh    
  ), 
  fn setAnimationFrame msh frame =
  (
    animationViewer.create msh frame
  ),  
  fn createScene =
  (
    -- textures
    if settings.isTextured then 
    (
      max.sme.open()
      smeView = max.sme.createView "Materials"
      for i = 1 to model.header.textureCount do
      (
        mat = addMaterial model.textureList[i].name
        max.sme.createNode mat smeView [0, i*100]
        append scene.materials mat
      )  
      max.sme.close()   
    ) 
    
    progressStart "creating meshes"
    
    if settings.lodIndex == 0 then
    ( 
      startLodIndex = 1    
      lodCount = model.header.lodCount     
    )      
    else
    (
      if settings.lodIndex <= model.header.lodCount then
      (
        startLodIndex = settings.lodIndex    
        lodCount = settings.lodIndex  
      ) 
      else
      (
        startLodIndex = 1  
        lodCount = 1        
      )      
    )
    
    -- lods
    with undo off
    for i = startLodIndex to lodCount do
    (
      modelLod = model.modelLods[i]
      
      progress = (100.0/model.header.meshCount as float)          
    
      meshIndex = 1
    
      with redraw off        
      for modelMesh in modelLod.meshes do 
      (      
        if settings.isTextured then
          msh = addMesh modelMesh model.header.origin model.header.scale \
            mats:scene.materials
        else
          msh = addMesh modelMesh model.header.origin model.header.scale
        
        progressUpdate (progress*meshIndex) 
        meshIndex += 1   
        
        if getProgressCancel() then 
        (
          setProgressCancel true  
          exit        
        )  
                     
        if msh != undefined then
        (       
          append scene.objects msh       
          -- mesh animations
          if modelMesh.header.frameCount > 0 then
          (
            if settings.frameIndex == 0 then
            (        
              for frame in modelMesh.animationFrames do
              (
                if frame.time > animationRange.end then
                  max.animation.setLength frame.time 
                setAnimationFrame msh frame 
              )
            )
            else 
            (
              if settings.frameIndex <= modelMesh.header.frameCount then
                setAnimationFrame msh modelMesh.animationFrames[settings.frameIndex] 
              else        
                setAnimationFrame msh modelMesh.animationFrames[0]
            ) 
          )          
        )

        if settings.to3dsMaxSystem then
        (
          rotMatrix = (matrix3 [1, 0, 0] [0, 0, 1] [0, -1, 0] [0, 0, 0]) 
          msh.transform = msh.transform*rotMatrix          
        )        
      )
      
      progressEnd()       
    ) 
    
    if scene.objects.count > 0 then
    (
      select scene.objects[1]
      max zoomext sel  
      redrawViews()       
    ) 
  )  
)