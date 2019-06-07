/*

*/

filein "lib/max.ms"
filein "lib/cyclone.ms"
filein "lib/cyclone_viewer.ms"

struct aniViewerSettings
(
  showAnimations = True,
  modelsFolderPath = "",
  texturesPath = "",
  isTextured = True,
  texFormat = "tf",
  lodIndex = 1,
  frameIndex = 0, 
  to3dsMaxSystem = True,
  isClockwizeOrder = True,
  startFrame  
)

struct aniCameraAnimationViewer
(
  fn create msh frame transfCoordinates:true =
  (
    -- rads to degrees
    local angles = eulerAngles (frame.rotation.x * (180/pi)) \
      (frame.rotation.y * (180/pi)) (frame.rotation.z * (180/pi))
        
    local transformMatrix = matrix3 1
    transformMatrix.row4 = frame.position 
    transformMatrix = preRotateY transformMatrix angles.y      
    transformMatrix = preRotateX transformMatrix angles.x                
    transformMatrix = preRotateZ transformMatrix angles.z     
     
    if transfCoordinates then
    (
      transMatrix = (matrix3 [0, -1, 0] [-1, 0, 0] [0, 0, -1] [0, 0, 0]) 
      transformMatrix = transformMatrix*transMatrix
    )    
     
    max.controller.addKey msh.position.controller frame.time
    max.controller.addKey msh.rotation.controller frame.time 
    
    animate on
    (   
      at time frame.time msh.position.controller.value = transformMatrix.translationpart 
      at time frame.time msh.rotation.controller.value = transformMatrix.rotationpart
    )
  )
)

struct aniSceneViewer
(
  aniScene,
  settings = aniViewerSettings(),
  camAnimationViewer = aniCameraAnimationViewer(),
  sceneModels = #(),
  fn setAnimationFrame cam frame =
  (
    camAnimationViewer.create cam frame transfCoordinates:settings.isClockwizeOrder
  ), 
  fn loadModel modelName =
  (
    result = undefined  
    
    modelsFilePath = settings.modelsFolderPath + "/" + modelName
    charactersFilePath = settings.modelsFolderPath + "/CHARACTERS/" + modelName
    
    file = cffFile()
    file.filename = modelsFilePath
    fstream = file.openFile()
    if fstream == undefined then
    (     
      file.filename = charactersFilePath
      fstream = file.openFile()
    )  
       
    if fstream != undefined then
    (  
      if file.readFile() then
        result = file.model
      file.closeFile() 
    )    
      
    result    
  ),  
  fn create =
  (
    -- add models 
    for sceneObject in aniScene.objects do
    (
      model = loadModel sceneObject.name
    
      if model != undefined then
      (
        viewer = modelViewer model
              
        viewer.settings.isTextured = settings.isTextured
        viewer.settings.texturesPath = settings.texturesPath
        viewer.settings.texFormat = settings.texFormat
        viewer.settings.lodIndex = settings.lodIndex    
        viewer.settings.frameIndex = settings.frameIndex  
        viewer.settings.to3dsMaxSystem = settings.to3dsMaxSystem 
        viewer.settings.isClockwizeOrder = settings.isClockwizeOrder
        viewer.settings.startFrame = sceneObject.frame
        
        viewer.createScene redraw:false     
      )
    )
    
    -- add camera
    sceneCamera = max.objects.addCamera name:"Scene camera" 
    sceneCamera.clipManually = true
    sceneCamera.nearclip = 0.004
    sceneCamera.farclip = 500
    sceneCamera.fov = 65.47
    
    -- animate camera
    if aniScene.header.frameCount > 0 then
    (    
      if aniScene.header.frameCount > animationRange.end then
         max.animation.setLength aniScene.header.frameCount
      for frame in aniScene.animations do
        setAnimationFrame sceneCamera frame
    )
    
    redrawViews()
  )
)