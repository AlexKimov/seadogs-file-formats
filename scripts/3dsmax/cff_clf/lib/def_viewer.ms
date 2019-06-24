/*

*/

filein "lib/max.ms"
filein "lib/cyclone.ms"
filein "lib/cyclone_viewer.ms"
filein "lib/math.ms "

struct defViewerSettings
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
  startFrame = 0,
  addCamera = true  
)

struct defSceneViewer
(
  scene,
  settings = defViewerSettings(),
  sceneModels = #(),
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
    -- load models to scene
    for sceneItem in scene.items do
    (
      model = loadModel sceneItem.filename

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
  
        viewer.createScene redraw:false showProgress:false position:sceneItem.position \
		  rotation:sceneItem.rotation	  
      )
    )
    
    redrawViews()
  )
)