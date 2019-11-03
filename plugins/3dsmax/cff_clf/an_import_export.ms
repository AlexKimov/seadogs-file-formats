/*
  Author: AlexKimov
  Description: .an files (Sea Dogs 2/3) import/export script
  Version: 0.1
*/

filein "lib/ms.ms"
filein "lib/utils.ms"
filein "lib/an.ms"
filein "lib/an_viewer.ms"
filein "lib/ini.ms"
filein "lib/system.ms"
filein "lib/settings.ms"

struct anStrings
(
  importRolloutTitle = "Import/Export",
  settingsRolloutTitle = "Import settings",
  buttonImportCaption = "Import",
  buttonExportCaption = "Export",
  editStartFrameTitle = "Start frame",
  editEndFrameTitle = "End frame",
  checkboxLoadSkeletonCaption = "load skeleton",
  checkboxAllAnimationsCaption = "load animations",
  dialogTitle = "Storm 2 .an Import/Export",
  groupAnimatedObjectCaption = "Apply animation to:",
  radioSelectAnimatedObjectItems = #("skeleton", "selection"),
  exportRolloutTitle = "Export settings",
  groupGetObjectCaption = "Get object",
  radioGetObjecttItems = #("by selection", "by name", "by group"),
  editExportStartFrameTitle  = "Start frame",
  editExportEndFrameTitle = "End frame",
  checkboxAllFramesCaption = "All frames",
  importDialogCaption = "Open .an file",
  importDialogTypes = "Storm 2 an format (*.an)|*.an",
  fn loadFromIni filename =
  (
    local sets = iniSettings(this)
    sets.loadFromIniFile filename "settings"
  )       
)

struct anSettings
(
  startFrame = 1,
  endFrame = 1000,
  loadSkeleton = true,
  allAnimations = true,
  exportStartFrame = 1,
  exportEndFrame = 1000,
  exportAllFrames = true,
  fn loadFromIni filename =
  (
    local sets = iniSettings(this)
    sets.loadFromIniFile filename "settings"
  )     
)

struct anUI
(
  settings,
  strings,
  iniFilename = "an.ini",
  fn importANFile filename: =
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
      file = anFile()         
      file.openStream filestream filename      
      if file.readFile() then
      ( 
	    viewer = anViewer file.object
		--viewer.settings. = 
		viewer.create()
	  )
	  file.closeFile()
    )	  
  ),
  fn exportANFile =
  (
    print "wip"
  ),
  exportRollout =
  (
    rollout exportRollout strings.exportRolloutTitle
	(
	  local owner = if owner != undefined do owner
	  
      groupBox group_getObjs owner.strings.groupGetObjectCaption \
	    pos:[10, 5] width:165 height:60
      radiobuttons radio_selectObjects columns:2
        labels:owner.strings.radioGetObjecttItems pos:[20, 25] 

      checkbox checkbox_allFrames owner.strings.checkboxAllFramesCaption \
        checked:owner.settings.exportAllFrames pos:[80, 70] 

      spinner spinner_exportStartFrame owner.strings.editExportStartFrameTitle \
        fieldWidth:70 type:#integer align:#right pos:[22, 90] \
        range:[1, 5000, owner.settings.exportStartFrame]   
      spinner spinner_exportEndFrame owner.strings.editExportEndFrameTitle \
        fieldWidth:70 type:#integer align:#right pos:[28, 110] \
        range:[1, 5000, owner.settings.exportEndFrame] 		
    )    
  ),  
  settingsRollout =
  (
    rollout settingsRollout strings.settingsRolloutTitle
	(
	  local owner = if owner != undefined do owner

      checkbox checkbox_loadSkeleton owner.strings.checkboxLoadSkeletonCaption \
        checked:owner.settings.loadSkeleton pos:[80, 5] 
      checkbox checkbox_allAnimations owner.strings.checkboxAllAnimationsCaption \
        checked:owner.settings.allAnimations  pos:[80, 25]  

      spinner spinner_startFrame owner.strings.editStartFrameTitle \
        fieldWidth:70 type:#integer align:#right pos:[22, 45] \
        range:[1, 5000, owner.settings.startFrame]   
      spinner spinner_endFrame owner.strings.editEndFrameTitle \
        fieldWidth:70 type:#integer align:#right pos:[28, 65] \
        range:[1, 5000, owner.settings.endFrame]   

      groupBox group_textures owner.strings.groupAnimatedObjectCaption \
	    pos:[10, 85] width:165 height:45 
      radiobuttons radio_selectAnimatedObject \
        labels:owner.strings.radioSelectAnimatedObjectItems pos:[30, 105]		
	)    
  ),  
  importRollout = 
  (
    rollout importRollout strings.importRolloutTitle
	(
	  local owner = if owner != undefined do owner

      button button_importAnFile owner.strings.buttonImportCaption width:120 
      button button_exportAnFile owner.strings.buttonExportCaption width:120 
      
      on button_importAnFile pressed do
      (
        owner.importANFile()
      )	 

      on button_exportAnFile pressed do
      (
        owner.exportANFile()
      )	  
	)
  ),
  dialog =
  (
    rollout dialog strings.dialogTitle
	(
	  local owner = if owner != undefined do owner 
	  
      subrollout subroll_container "container" height:395 width:196 pos:[2, 2]
      on dialog resized point do
      (
        subroll_container.height = dialog.height
      )  	  
	)    
  ),
  fn close = try (destroyDialog dialog) catch(),
  fn show =
  (
    createDialog dialog width:200 pos:mouse.screenpos \
      style:#(#style_sysmenu, #style_resizing, #style_titlebar)  
	AddSubRollout dialog.subroll_container settingsRollout
	AddSubRollout dialog.subroll_container exportRollout
    AddSubRollout dialog.subroll_container importRollout 	    
  ),  
  fn init =
  (
    if settings == undefined then
	(
	  settings = anSettings()
      settings.loadFromIni (sys.currentPath + iniFilename)
	)
	
    if strings == undefined then 
    (
      strings = anStrings()  
      strings.loadFromIni (sys.currentPath + iniFilename)  
    )	
	
    dialog.owner = this 
    importRollout.owner = this 
    settingsRollout.owner = this 
	exportRollout.owner = this 
  ),
  on create do init()
)

fn main =
(
  sys.currentPath = fileUtils.getCurrentPath(getThisScriptFilename())
  anDialog = anUI()
  anDialog.show() 
)

main()