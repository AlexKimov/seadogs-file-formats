/*
  Author: AlexKimov
  Description: .ani files (Sea Dogs) import script
  Version: 0.1
*/

filein "lib/ms.ms"
filein "lib/utils.ms"
filein "lib/ani.ms"
filein "lib/ani_viewer.ms"

struct settingsImportAni
(
  pathToModelsFolder = "",
  allLods = False,
  allFrames = True,
  isTextured = True,
  path = "",
  to3dsMaxSystem = True,
  isClockwizeOrder = True,
  lod = 1,
  frame = 1,
  texFormat = "tf"
)

struct stringsImportAni
(
  rolloutTitle = "Import .ani scene",
  rolloutImportTitle = "Import",
  buttonImportCaption = "Open .ani file",
  groupModelsCaption = "Folder",
  buttonSetPathCaption = "Get path",
  buttonClearPathCaption = "Clear",
  rolloutSettingsTitle = "Settings",
  rolloutImportSettingsTitle = "Model import settings",
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
  checkboxFaceOrder = "change face order",
  editChooseStartFrameTitle = "Start"  
)

struct aniSceneImportUI
(
  settings,
  strings,
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
        sceneViewer.settings.modelsFolderPath = "C:\Program Files\1C\Корсары\RESOURCE\MODELS"
        
        sceneViewer.create()
      ) 
      file.closeFile()      
    )    
  ),
  fn getTexturesPath =
  (
    path = dialogs.openFolder strings.openFolder
    if path != undefined then
      this.dialog.subroll_container.importSettingsRollout.edit_modelsPath.text = path
  ),
  fn clearTexturesPath =
  (
    this.dialog.subroll_container.importSettingsRollout.edit_modelsPath.text = "" 
  ),  
  fn getFolderPath =
  (
    path = dialogs.openFolder strings.openFolder
    if path != undefined then
      this.dialog.subroll_container.settingsRollout.edit_modelsPath.text = path
  ),
  fn clearFolderPath =
  (
    this.dialog.subroll_container.settingsRollout.edit_modelsPath.text = "" 
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
        
      edittext edit_texPath "" fieldWidth:155 pos:[10, 40] readOnly:true
      
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
        owner.getTexturesPath()
      )  
      on button_clearTexturePath pressed do
      (
        owner.clearTexturesath()
      )       
    )    
  ),  
  settingsRollout =
  (
    rollout settingsRollout strings.rolloutSettingsTitle 
    (
      local owner = if owner != undefined do owner  
      
      groupBox group_model owner.strings.groupModelsCaption \
        pos:[5, 0] width:175 height:90         
      edittext edit_modelsPath "Path to Models folder" fieldWidth:154 \
        pos:[15, 20] readOnly:true labelOnTop:true
        
      button button_setModelsPath owner.strings.buttonSetPathCaption \
        width:75 pos:[15, 60]
      button button_clearModelsPath owner.strings.buttonClearPathCaption \
        width:75 pos:[95, 60] 

      on button_setModelsPath pressed do
      (
        owner.getFolderPath()
      )  
      on button_clearModelsPath pressed do
      (
        owner.clearFolderPath()
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
  fn init =
  (
    if settings == undefined then
      settings = settingsImportAni()
    if strings == undefined then  
      strings = stringsImportAni()
      
    dialog.owner = this 
    importRollout.owner = this 
    settingsRollout.owner = this 
    importSettingsRollout.owner = this 
    
    createDialog dialog width:200 pos:mouse.screenpos \
      style:#(#style_sysmenu, #style_resizing, #style_titlebar)     
    AddSubRollout dialog.subroll_container settingsRollout 
    AddSubRollout dialog.subroll_container importSettingsRollout rolledUp:true  
    AddSubRollout dialog.subroll_container importRollout      
  ),
  on create do init()  
)

fn main = 
(
  aniSceneImport = aniSceneImportUI()
)

main()