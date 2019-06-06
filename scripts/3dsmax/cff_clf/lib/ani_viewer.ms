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

struct aniSceneViewer
(
  aniScene,
  settings = aniViewerSettings(),
  camAnimationViewer = cycloneAnimationViewer(),
  sceneObjects = #(),
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
        append sceneObjects model 
        
        viewer = modelViewer model

        viewer.settings.isTextured = settings.isTextured
        viewer.settings.texturesPath = settings.texturesPath
        viewer.settings.texFormat = settings.texFormat
        viewer.settings.lodIndex = settings.lodIndex    
        viewer.settings.frameIndex = settings.frameIndex  
        viewer.settings.to3dsMaxSystem = settings.to3dsMaxSystem 
        viewer.settings.isClockwizeOrder = settings.isClockwizeOrder
        viewer.settings.startFrame = sceneObject.frame
        
        viewer.createScene()
      )
    )
    
    -- add camera
    sceneCamera = max.objects.addCamera name:"Scene camera" 
    sceneCamera.farrange = 0.2
    
    -- animate camera
    if aniScene.header.frameCount > 0 then
    (    
      for frame in aniScene.animations do
        setAnimationFrame sceneCamera frame
    )
    
  )
)