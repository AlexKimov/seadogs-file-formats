/*
  Author: AlexKimov
  Description: Storm 1 Engine (Sea Dogs, Age of Sail 2/Privateer's Bounty) 3d models files import script
  Version: 0.1
*/

filein "lib/ms.ms"
filein "lib/utils.ms"
filein "lib/cyclone.ms"
filein "lib/cyclone_viewer.ms"

struct settingsImportUI
(
  lod = 1,
  frame = 1,
  texFormat = "tf",
  allLods = False,
  allFrames = True,
  isTextured = True,
  path = "",
  to3dsMaxSystem = True,
  isClockwizeOrder = True 
)

struct stringsImportUI
(
  rolloutTitle = "Import Storm 1 Engine model",
  importDialogCaption = "Open 3d Model file",
  importDialogTypes = "Cyclone final format (*.cff;*.clf)|*.cff;*.clf",
  formatsArray = #(".cff", ".clf"),
  rolloutSettingsTitle = "Settings",  
  rolloutImportTitle = "Import",
  buttonImportCaption = "Import model",
  editChooseLodModelTitle = "LOD",
  groupModelCaption = "Model",
  groupTexturesCaption = "Textures",
  editChooseFrameTitle = "Frame",
  checkboxAllLodsCaption = "all lods",
  checkboxAllFramesCaption = "all frames",
  labelChoosePath = "Path",
  checkboxTexturedCaption = "add textures",
  buttonSetTexturePathCaption = "Set",
  buttonClearTexturePathCaption = "Clear",
  openTexturesFolder = "Choose textures folder",
  dropdownlistExtensionCaption = "ext.",
  dropdownlistExtensionItems = #("tga", "bmp", "tga", "png"),
  checkboxConvertCoordSystem = "convert coordinate system",
  checkboxFaceOrder = "change face order"
)

struct cycloneImportUI
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
      local ext = fileUtils.getFileExtension filename 
      file = case (ext) of
      (
        (strings.formatsArray[1]): cffFile()
        (strings.formatsArray[2]): clfFile()   
      )     
      
      file.openStream filestream filename      
      if file.readFile() then
      (
        viewer = modelViewer file.model
        viewer.settings.isTextured = settings.isTextured
        --viewer.settings.texturesPath = settings.path
        viewer.settings.texturesPath = "C:\Program Files\1C\Корсары\RESOURCE\MODELS\CHARACTERS"
        viewer.settings.texFormat = settings.texFormat
        if settings.allLods == True then
          viewer.settings.lodIndex = 0
        else
          viewer.settings.lodIndex = settings.lod
        if settings.allFrames == True then  
          viewer.settings.frameIndex = 0        
        else        
          viewer.settings.frameIndex = settings.frame  
        viewer.settings.to3dsMaxSystem = settings.to3dsMaxSystem 
        viewer.settings.isIntermediateFormat = \
          (if (classOf(file) == clfFile) then True else False)
          
        viewer.settings.isClockwizeOrder = settings.isClockwizeOrder
        
        viewer.createScene()
      )
      file.closeFile()
    )    
  ),
  fn getPath =  
  (
    path = dialogs.openFolder strings.openTexturesFolder
    if path != undefined then
    (
      this.dialog.subroll_container.settingsRollout.edit_texPath.text = path
    )      
  ),
  fn clearPath =  
  (
    this.dialog.subroll_container.settingsRollout.edit_texPath.text = ""      
  ),  
  settingsRollout =
  (
    rollout settingsRollout strings.rolloutSettingsTitle 
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

      --label label_choosePath owner.strings.labelChoosePath pos:[15, 20]          
      edittext edit_texPath "" fieldWidth:155 pos:[10, 40] readOnly:true
      
      button button_setTexturePath owner.strings.buttonSetTexturePathCaption \
        width:75 pos:[15, 62]
      button button_clearTexturePath owner.strings.buttonClearTexturePathCaption \
        width:75 pos:[95, 62]        
      checkbox checkbox_isTextured owner.strings.checkboxTexturedCaption \
        checked:owner.settings.isTextured pos:[15, 20] 
        
      dropdownlist dropdownlist_extension items:owner.strings.dropdownlistExtensionItems \
        pos:[120, 15] width:50
        
      on button_setTexturePath pressed do
      (
        owner.getPath()
      )  
      on button_clearTexturePath pressed do
      (
        owner.clearPath()
      )       
    )    
  ),
  importRollout =
  (
    rollout importRollout strings.rolloutImportTitle
    (
      local owner = if owner != undefined do owner       
             
      button button_importModel owner.strings.buttonImportCaption width:120          
      on button_importModel pressed do
      (
        setRollout = owner.dialog.subroll_container.settingsRollout
        importSettings = owner.settings
        
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
      
      subrollout subroll_container "container" height:295 width:196 pos:[2, 2]
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
      settings = settingsImportUI()
    if strings == undefined then  
      strings = stringsImportUI()
      
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
  currentPath = fileUtils.getCurrentPath(getThisScriptFilename())
  importUI = cycloneImportUI()
  importUI.importModel filename:"Hubernator_Spa.clf"
)

main()