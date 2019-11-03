/*
  Author: AlexKimov
  Description: Storm 1 Engine (Sea Dogs, Age of Sail 2/Privateer's Bounty) 3d models files export script
  Version: 0.1
*/

filein "lib/ms.ms"
filein "lib/utils.ms"
filein "lib/dialogs.ms"
filein "lib/cyclone.ms"

struct settingsExportUI
(
  exportMaterials = true,
  exportAnimations = true,
  extension = "",
  selectionType = 1,
  modelName = "",
  spinnerFrameNumber = 1000  
)

struct stringsExportUI
(
  buttonExportCaption = "Export model",
  rolloutExportTitle = "Export",
  rolloutTitle = "Export .clf model",
  rolloutSettingsTitle = "Settings",
  groupLodCaption = "LOD",
  radioSelectItems  = #("by selection", "by group", "by prefix"),
  radioSelectCaption = "Select objects:",
  groupMeshCaption = "Mesh",
  dropdownlistExtensionItems = #("", "bmp", "tga", "png", "tf"),
  labelTextureType = "Texture type",
  checkboxExportMaterials = "Export materials",
  checkboxexportAnimations = "Export animations",
  meshNotSelected = "Meshes aren't selected.",
  editFrameNumberTitle = "Frames",
  exportDialogCaption = "Save Cyclon Model file",
  exportDialogTypes = "Cyclone final format (*.clf)|*.clf"
)

struct cycloneExportUI
(
  settings,
  strings,
  fn exportModel filename: =
  ( 
    if settings.selectionType == 1 then
    (
      if selection.count == 0 then 
	    dialogs.showMessage strings.meshNotSelected 
	  else
      (	  
        local objs = for obj in selection where isproperty obj #verts collect obj
        local model = cycloneModel()
        model.addLod objs
		dialogs.caption = strings.exportDialogCaption
        dialogs.types = strings.exportDialogTypes  
        local filestream = dialogs.openFileDialog &fname "wb"
		if filestream != undefined then
		(
		  local file = clfFile()
          file.openStream filestream fname	
		  file.writeFile()
          file.closeFile()		
		)	
      )		
    )
    else if settings.selectionType == 2 then
    (
      local model = cycloneModel() 
      for modelGroup in objects where isGroupHead obj do 
	  (
        local objs = for obj in modelGroup.children where isproperty obj #verts collect obj
        --model.addLod objs
      )      
    )
    else
    (
      local objs = for obj in objects \
        where isproperty obj #verts and findString obj.name exportSettings.modelName collect obj
      local model = cycloneModel()
      --model.addLod objs 
    )	  
  ), 
  settingsRollout =
  (
    rollout settingsRollout strings.rolloutSettingsTitle
    (
      local owner = if owner != undefined do owner 
      
      groupBox group_lod owner.strings.groupLodCaption pos:[5, 0] width:175 \
        height:115
      radiobuttons radio_selectObject owner.strings.radioSelectCaption \
        labels:owner.strings.radioSelectItems pos:[20, 20]
      edittext edit_modelName "" fieldWidth:145 pos:[15, 87] 

      groupBox group_mesh owner.strings.groupMeshCaption pos:[5, 120] width:175 \
        height:110
      dropdownlist dropdownlist_extension items:owner.strings.dropdownlistExtensionItems \
        pos:[100, 140] width:50
      label label_texType owner.strings.labelTextureType pos:[30, 143]   

      checkbox checkbox_exportMaterials owner.strings.checkboxExportMaterials \
        checked:owner.settings.exportMaterials pos:[30, 165] 
      checkbox checkbox_exportAnimations owner.strings.checkboxexportAnimations \
        checked:owner.settings.exportAnimations pos:[30, 185] 
		
	  spinner spinner_frameNumber owner.strings.editFrameNumberTitle \
        fieldWidth:40 type:#integer align:#right pos:[30, 205] \
        range:[1, 2000, owner.settings.spinnerFrameNumber] 
        		
    )
  ),  
  exportRollout =
  (
    rollout exportRollout strings.rolloutExportTitle
    (
      local owner = if owner != undefined do owner       
             
      button button_exportModel owner.strings.buttonExportCaption width:120          
      on button_exportModel pressed do
      (
        setRollout = owner.dialog.subroll_container.settingsRollout
        exportSettings = owner.settings
        
        exportSettings.selectionType = setRollout.dropdownlist_extension.selection
        exportSettings.exportAnimations = setRollout.checkbox_exportAnimations.checked 
        exportSettings.exportMaterials = setRollout.checkbox_exportMaterials.checked 
        exportSettings.modelName = setRollout.edit_modelName.text
        exportSettings.extension = setRollout.dropdownlist_extension.text
        
        owner.exportModel()
      )     
    )
  ),   
  dialog =
  (
    rollout dialog strings.rolloutTitle
    (     
      local owner = if owner != undefined do owner   
      
      subrollout subroll_container "container" height:315 width:196 pos:[2, 2]
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
      settings = settingsExportUI()
    if strings == undefined then  
      strings = stringsExportUI()
      
    dialog.owner = this 
    exportRollout.owner = this 
    settingsRollout.owner = this
    
    createDialog dialog width:200 pos:mouse.screenpos \
      style:#(#style_sysmenu, #style_resizing, #style_titlebar)   
    AddSubRollout dialog.subroll_container settingsRollout      
    AddSubRollout dialog.subroll_container exportRollout   
  ),
  on create do init()  
)

fn main = 
(
  currentPath = fileUtils.getCurrentPath(getThisScriptFilename())
  exportUI = cycloneExportUI()
)

main()