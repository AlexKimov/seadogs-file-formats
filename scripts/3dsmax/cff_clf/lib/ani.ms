/*

*/

filein "dialogs.ms"
filein "stream.ms"
filein "ani_model.ms"

struct aniStrings
(
  types = "Sea Dogs 1 animated scene (*.ani)|*.ani",
  openFileCaption = "Open .ani file"
)

struct aniFile
(
  strings = aniStrings(),
  scene = aniScene(),
  fstream,
  filename,
  freader, 
  fn readHeader =
  (
    fseek fstream 4 #seek_cur  
    scene.header.objectCount = ReadLong fstream #unsigned
    fseek fstream 4 #seek_cur
    scene.header.frameCount = ReadLong fstream #unsigned   
  ),
  fn readObjects =
  (
    for i = 1 to scene.header.objectCount do
    (
      local type = ReadLong fstream #unsigned
      local frame = ReadLong fstream #unsigned
      local size = ReadLong fstream #unsigned
      if type == 0 then
      (
        sceneObject = aniSceneObject()
        sceneObject.frame = frame
        sceneObject.name = freader.ReadChars size
        append scene.objects sceneObject
        print sceneObject.name        
      ) 
      else      
        fseek fstream size #seek_cur
    )
  ),
  fn readAnimations =
  (
    for i = 1 to scene.header.frameCount do
    (
      frame = aniAnimationFrame()  
     
      frame.position = freader.readVector3F()   
      frame.rotation = freader.readVector3F()
      frame.time = ReadFloat fstream
      
      append scene.animations frame
    )    
  ),
  fn readFile =
  (
    readHeader()
    readObjects()
    readAnimations()
    result = True
  ),  
  fn closeFile =
  (
    fclose fstream
  ),
  fn openStream fstream filename =
  (
    this.fstream = fstream
    this.filename = filename 
    freader = streamReader(fstream)   
  ),   
  fn openFile mode:"rb" =
  (
    result = False
    
    dialogs.types = strings.types
    dialogs.caption = strings.openFileCaption
    
    local fname = filename
    fstream = dialogs.openFileDialog &fname mode
    if fstream != undefined then
    (
      filename = fname
      freader = formatReader(fstream)    
      result = True      
    )
  )    
)