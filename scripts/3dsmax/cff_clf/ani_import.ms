/*
  Author: AlexKimov
  Description: 
  Version: 0.1
*/

filein "lib/ms.ms"
filein "lib/utils.ms"
filein "lib/ani.ms"
filein "lib/cyclone_viewer.ms"

struct settingsImportAni
(
  animOn = True
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
  checkboxAnimOnCaption = "animate"
)

struct aniSceneImportUI
(
  settings,
  strings,
  fn importModel =
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
      ani = aniFile()
      ani.openStream filestream filename      
      if file.readFile() then
      (
        aniViewer = aniSceneViewer ani.model
        aniViewer.create()
      ) 
      ani.closeFile()      
    )    
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
      edittext edit_path "Path to Models folder" fieldWidth:154 pos:[15, 40] \
        readOnly:true labelOnTop:true
      button button_setTexturePath owner.strings.buttonSetPathCaption \
        width:75 pos:[15, 85]
      button button_clearTexturePath owner.strings.buttonClearPathCaption \
        width:75 pos:[95, 85]       
    )    
  ),  
  importRollout =
  (
    rollout importRollout strings.rolloutImportTitle
    (
      local owner = if owner != undefined do owner       
             
      button button_importAniScene owner.strings.buttonImportCaption width:120          
      on button_importModel pressed do
      (
        setRollout = owner.dialog.subroll_container.settingsRollout
        importSettings = owner.settings
        
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