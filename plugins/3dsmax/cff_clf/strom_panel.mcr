/*
  Author: AlexKimov
  Version: 0.1
  Description: Storm 1 Engine tools
  Game: Sea Dogs 1 (2000), Age of Sail 2, Privateers Bounty: Age of Sail 2
*/

macroScript STORM_ENGINE_TOOLS
category: "Game file import/export"
tooltip: "Storm 1 Engine tools"
buttontext: "Storm 1 Engine tools"
icon: #("storm_icon", 1)
autoUndoEnabled:false
(
  struct toolsDialogStrings
  (
    buttonImportCyclCaption = "Import Cyclone model",
	buttonImportAniCaption = "Import .ani file",
    title = "Storm Engine tools",	
  )
  
  struct toolsDialog
  (
    strings,
    width = 100,
    pos = [100, 100],
    style = #(#style_titlebar, #style_border, #style_sysmenu),
    fn importCyclone = 
    (
  	  include "raw_import.ms"
    ),
    fn importAni = 
    (
  	  include "raw_export.ms"
    ),
    dialog =
    (
      rollout dialog strings.title
      (
	    local owner = if owner != undefined do owner
	    button button_importCyclone strings.buttonImportCyclCaption
	    button button_importAni strings.buttonImportAniCaption 
  	    on button_importCyclone pressed do owner.importCyclone
  	    on button_importAni pressed do owner.importAni
      )
    ),
    fn show = createDialog dialog width:width pos:pos style:style,
    fn close = try (destroyDialog dialog) catch(),
    on create do 
	(
	  dialog.owner = this
	  strings = toolsDialogStrings()
	)  
  )
  
  stormToolsUI = toolsDialog()
  stormToolsUI.show() 
)