/*
  Author: AlexKimov
  Description: .ani files (Sea Dogs) import script
  Version: 0.1
*/

filein "lib/ms.ms"
filein "lib/utils.ms"
filein "lib/ani.ms"
filein "lib/ani_viewer.ms"
filein "lib/ini.ms"
filein "lib/system.ms"
filein "lib/settings.ms"

struct settingsImportAni
(
  pathToModelsFolder = "",
  pathToTexturesFolder = "",
  allLods = false,
  allFrames = true,
  isTextured = true,
  path = "",
  to3dsMaxSystem = true,
  isClockwizeOrder = true,
  lod = 1,
  frame = 1,
  texFormat = "tf",
  addCamera = false,
  fn loadFromIni filename =
  (
    local sets = iniSettings(this)
    sets.loadFromIniFile filename "settings"
  )   
)

struct stringsImportAni
(
  rolloutTitle = "Import .ani scene",
  rolloutImportTitle = "Import",
  buttonImportCaption = "Open .ani file",
  groupModelsCaption = "Folder",
  buttonSetPathCaption = "Get path",
  buttonClearPathCaption = "Clear",
  rolloutSettingsTitle = "Paths",
  rolloutImportSettingsTitle = "Models",
  importDialogCaption = "Import .ani file",
  importDialogTypes  = "Sea Dogs 1 animated scenes file (*.ani)|*.ani",
  openFolder = "Open \"Models\" folder",
  editChooseLodModelTitle = "LOD",
  groupModelCaption = "Model",
  groupTexturesCaption = "Textures",
  editChooseFrameTitle = "Frame",
  checkboxAllLodsCaption = "all lods",
  checkboxAllFramesCaption = "all frames",
  labelChoosePath = "Path",
  checkboxTexturedCaption = "add textures",
  buttonSetTexturePathCaption = "Get path",
  buttonClearTexturePathCaption = "Clear",
  openTexturesFolder = "Choose textures folder",
  dropdownlistExtensionCaption = "ext.",
  dropdownlistExtensionItems = #("tf", "bmp", "tga", "png"),
  checkboxConvertCoordSystem = "convert coordinate system",
  checkboxFaceOrder = "Change face order",
  editChooseStartFrameTitle = "Start" ,
  groupIniCaption = "Path",
  buttonClearCaption = "Clear scene", 
  rolloutClearTitle = "Clear", 
  groupCameraCaption  = "Camera",
  checkboxCameraCaption  = "Add camera",
  editPathToModelsText = "Path to Models folder",
  fn loadFromIni filename =
  (
    local sets = iniSettings(this)
    sets.loadFromIniFile filename "strings"
  )   
)

struct aniSceneImportUI
(
  settings,
  strings,
  iniFilename = "ani.ini",
  fn importModel filename: =
  (
    if filename == unsupplied then
    (
      dialogs.caption = strings.importDialogCaption
      dialogs.types = strings.importDialogTypes  
      filestream = dialogs.openFileDialog &fname "rb" 
      filename = fname       
    )  
    
    if filestream != undefined then 
    (  
      file = aniFile()
      file.openStream filestream filename      
      if file.readFile() then
      (
        sceneViewer = aniSceneViewer file.scene
        viewerSettings = sceneViewer.settings  
        
        viewerSettings.modelsFolderPath = settings.pathToModelsFolder     
        viewerSettings.isTextured = settings.isTextured     
        if settings.allLods then 
          viewerSettings.lodIndex = 0
        else
          viewerSettings.lodIndex = viewerSettings.lodIndex
        if settings.allFrames  then 
          viewerSettings.frameIndex = 0
        else
          viewerSettings.frameIndex = viewerSettings.frameIndex              
        viewerSettings.texturesPath = settings.path
        viewerSettings.texFormat = settings.texFormat
        viewerSettings.to3dsMaxSystem = settings.to3dsMaxSystem 
        viewerSettings.isClockwizeOrder = settings.isClockwizeOrder
        viewerSettings.addCamera = settings.addCamera
		
        sceneViewer.create()
      ) 
      file.closeFile()      
    )    
  ),
  fn getPath =
  (
    path = dialogs.openFolder strings.openFolder	  
  ),
  clearRollout =
  (
    rollout clearRollout strings.rolloutClearTitle 
    (
	  local owner = if owner != undefined do owner 
	  
      button button_removeObjects owner.strings.buttonClearCaption width:120	  
		
      on button_removeObjects pressed do
      (
        print "none"
      )	  
    )	
  ),  
  importSettingsRollout =
  (
    rollout importSettingsRollout strings.rolloutImportSettingsTitle 
    (
      local owner = if owner != undefined do owner  
      groupBox group_model owner.strings.groupModelCaption \
        pos:[5, 97] width:175 height:110 
      groupBox group_textures owner.strings.groupTexturesCaption \
        pos:[5, 0] width:175 height:92         
      groupBox group_camera owner.strings.groupCameraCaption \
        pos:[5, 210] width:175 height:45  
        
      checkbox checkbox_addCamera owner.strings.checkboxCameraCaption \
        checked:owner.settings.addCamera pos:[25, 230] 		
		
      checkbox checkbox_convertCoord owner.strings.checkboxconvertCoordSystem \
        checked:owner.settings.to3dsMaxSystem pos:[25, 115]           
      checkbox checkbox_faceOrder owner.strings.checkboxFaceOrder \
        checked:owner.settings.isClockwizeOrder pos:[25, 135]   
    
      spinner spinner_lod owner.strings.editChooseLodModelTitle \
        fieldWidth:40 type:#integer align:#right pos:[25, 160] \
        range:[1, 10, owner.settings.lod]   
      spinner spinner_frame owner.strings.editChooseFrameTitle \
        fieldWidth:40 type:#integer align:#right pos:[15, 180] \
        range:[1, 2000, owner.settings.frame] 

      checkbox checkbox_allLods owner.strings.checkboxAllLodsCaption \
        checked:owner.settings.allLods pos:[105, 160] 
      checkbox checkbox_allFrames owner.strings.checkboxAllFramesCaption \
        checked:owner.settings.allFrames pos:[105, 180]  
        
      edittext edit_texPath "" \
	    fieldWidth:155 pos:[10, 40] readOnly:true text:owner.settings.pathToTexturesFolder
      
      button button_getTexturePath owner.strings.buttonSetTexturePathCaption \
        width:75 pos:[15, 62]
      button button_clearTexturePath owner.strings.buttonClearTexturePathCaption \
        width:75 pos:[95, 62]        
      checkbox checkbox_isTextured owner.strings.checkboxTexturedCaption \
        checked:owner.settings.isTextured pos:[15, 20]           
        
      dropdownlist dropdownlist_extension items:owner.strings.dropdownlistExtensionItems \
        pos:[120, 15] width:50
        
      on button_getTexturePath pressed do
      (
        pathToTexFolders = owner.getPath()
		if pathToTexFolders != undefined then edit_texPath.text = pathToTexFolders
      )  
      on button_clearTexturePath pressed do
      (
        edit_texPath.text = "" 
      )       
    )    
  ),  
  settingsRollout =
  (
    rollout settingsRollout strings.rolloutSettingsTitle 
    (
      local owner = if owner != undefined do owner  
      
      --groupBox group_model owner.strings.groupModelsCaption \
        --pos:[5, 0] width:175 height:90         
      edittext edit_modelsPath owner.strings.editPathToModelsText fieldWidth:154 \
        pos:[15, 5] readOnly:true labelOnTop:true text:owner.settings.pathToModelsFolder
        
      button button_setModelsPath owner.strings.buttonSetPathCaption \
        width:75 pos:[15, 45]
      button button_clearModelsPath owner.strings.buttonClearPathCaption \
        width:75 pos:[95, 45] 

      on button_setModelsPath pressed do
      (
        pathToModFolders = owner.getPath()
		if pathToModFolders != undefined then edit_modelsPath.text = pathToModFolders
      )  
      on button_clearModelsPath pressed do
      (
        edit_modelsPath.text = ""
      )                 
    )    
  ),  
  importRollout =
  (
    rollout importRollout strings.rolloutImportTitle
    (
      local owner = if owner != undefined do owner       
             
      button button_importAniScene owner.strings.buttonImportCaption width:120 
      
      on button_importAniScene pressed do
      (
        setRollout = owner.dialog.subroll_container.importSettingsRollout
        importSetRollout = owner.dialog.subroll_container.settingsRollout
        importSettings = owner.settings
        
        importSettings.pathToModelsFolder = importSetRollout.edit_modelsPath.text        
        importSettings.isTextured = setRollout.checkbox_isTextured.checked           
        importSettings.allLods = setRollout.checkbox_allLods.checked 
        importSettings.allFrames = setRollout.checkbox_allFrames.checked       
        importSettings.lod = setRollout.spinner_lod.value
        importSettings.frame = setRollout.spinner_frame.value
        importSettings.path = setRollout.edit_texPath.text
        importSettings.texFormat = setRollout.dropdownlist_extension.text
        importSettings.to3dsMaxSystem = setRollout.checkbox_convertCoord.checked
        importSettings.isClockwizeOrder = setRollout.checkbox_faceOrder.checked
        importSettings.addCamera = setRollout.checkbox_addCamera.checked
		
        owner.importModel()
      )     
    )
  ),    
  dialog =
  (
    rollout dialog strings.rolloutTitle
    (     
      local owner = if owner != undefined do owner   
      
      subrollout subroll_container "container" height:410 width:196 pos:[2, 2]
      on dialog resized point do
      (
        subroll_container.height = dialog.height
      )      
    )     
  ), 
  fn close = try (destroyDialog dialog) catch(),  
  fn show =
  (
    if settings == undefined then
	(
	  settings = settingsImportAni()
      settings.loadFromIni (sys.currentPath + iniFilename)
	)
	
    if strings == undefined then 
    (
      strings = stringsImportAni()  
      strings.loadFromIni (sys.currentPath + iniFilename)  
    )	

    createDialog dialog width:200 pos:mouse.screenpos \
      style:#(#style_sysmenu, #style_resizing, #style_titlebar)  	  
    AddSubRollout dialog.subroll_container settingsRollout 
    AddSubRollout dialog.subroll_container importSettingsRollout rolledUp:true  
    AddSubRollout dialog.subroll_container clearRollout	rolledUp:true 
    AddSubRollout dialog.subroll_container importRollout 	  
  ),
  fn init =
  (    
    dialog.owner = this 
    importRollout.owner = this 
    settingsRollout.owner = this 
    importSettingsRollout.owner = this 
	clearRollout.owner = this 
  ),
  on create do init()  
)

fn main = 
(
  sys.currentPath = fileUtils.getCurrentPath(getThisScriptFilename())
  aniSceneImport = aniSceneImportUI()
  aniSceneImport.show() 
)

main()