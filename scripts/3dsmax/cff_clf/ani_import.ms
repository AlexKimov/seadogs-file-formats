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
  animOn = True,
  pathToModelsFolder = ""
)

struct stringsImportAni
(
  rolloutTitle = "Import .ani scene",
  rolloutImportTitle = "Import",
  buttonImportCaption = "Open .ani file",
  groupModelsCaption = "Models",
  buttonSetPathCaption = "Get path",
  buttonClearPathCaption = "Clear",
  rolloutSettingsTitle = "Settings",
  checkboxAnimOnCaption = "animate",
  importDialogCaption = "Import .ani file",
  importDialogTypes  = "Sea Dogs 1 animated scenes file (*.ani)|*.ani",
  openFolder = "Open \"Models\" folder"
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
        sceneViewer.settings.showAnimations = settings.animOn
        sceneViewer.settings.modelsFolderPath = settings.pathToModelsFolder
        --sceneViewer.settings.modelsFolderPath = "C:\Program Files\1C\Корсары\RESOURCE\MODELS"
        
        sceneViewer.create()
      ) 
      file.closeFile()      
    )    
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
  settingsRollout =
  (
    rollout settingsRollout strings.rolloutSettingsTitle 
    (
      local owner = if owner != undefined do owner  
      
      groupBox group_model owner.strings.groupModelsCaption \
        pos:[5, 0] width:175 height:115   
      checkbox checkbox_animOn owner.strings.checkboxAnimOnCaption \
        checked:owner.settings.animOn pos:[15, 17]        
      edittext edit_modelsPath "Path to Models folder" fieldWidth:154 \
        pos:[15, 40] readOnly:true labelOnTop:true
        
      button button_setTexturePath owner.strings.buttonSetPathCaption \
        width:75 pos:[15, 85]
      button button_clearTexturePath owner.strings.buttonClearPathCaption \
        width:75 pos:[95, 85] 

      on button_setTexturePath pressed do
      (
        owner.getFolderPath()
      )  
      on button_clearTexturePath pressed do
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
        setRollout = owner.dialog.subroll_container.settingsRollout
        importSettings = owner.settings
        
        importSettings.animOn = setRollout.checkbox_animOn.checked
        importSettings.pathToModelsFolder = setRollout.edit_modelsPath.text
        
        owner.importModel()
      )     
    )
  ),    
  dialog =
  (
    rollout dialog strings.rolloutTitle
    (     
      local owner = if owner != undefined do owner   
      
      subrollout subroll_container "container" height:200 width:196 pos:[2, 2]
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
    
    createDialog dialog width:200 pos:mouse.screenpos style:#(#style_toolwindow, #style_sysmenu)     
    AddSubRollout dialog.subroll_container settingsRollout     
    AddSubRollout dialog.subroll_container importRollout      
  ),
  on create do init()  
)

fn main = 
(
  aniSceneImport = aniSceneImportUI()
)

main()