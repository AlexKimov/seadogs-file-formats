/*
  Author: AlexKimov
  Description: Storm 1 Engine (Sea Dogs, Age of Sail 2/Privateer's Bounty) 3d models files export script
  Version: 0.1
*/

filein "lib/ms.ms"
filein "lib/utils.ms"
filein "lib/cyclone.ms"

struct settingsExportUI
(
  w = 2
)

struct stringsExportUI
(
  buttonExportCaption = "Export model",
  rolloutExportTitle = "Export",
  rolloutTitle = "Export"
)

struct cycloneExportUI
(
  settings,
  strings,
  fn exportModel filename: =
  ( 
    print "123"
  ),  
  exportRollout =
  (
    rollout exportRollout strings.rolloutExportTitle
    (
      local owner = if owner != undefined do owner       
             
      button button_exportModel owner.strings.buttonExportCaption width:120          
      on button_exportModel pressed do
      (
        owner.exportModel()
      )     
    )
  ),   
  dialog =
  (
    rollout dialog strings.rolloutTitle
    (     
      local owner = if owner != undefined do owner   
      
      subrollout subroll_container "container" height:230 width:196 pos:[2, 2]
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
    
    createDialog dialog width:200 pos:mouse.screenpos style:#(#style_toolwindow, #style_sysmenu)    
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