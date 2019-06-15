/*

*/

filein "dialogs.ms"
filein "stream.ms"
filein "an_model.ms"

struct aniStrings
(
  types = "Storm 2 (*.an)|*.an",
  openFileCaption = "Open .an file"
)

struct anFile
(
  strings = aniStrings(),
  fstream,
  filename,
  freader,
  object = anObject(),  
  fn readHeader =
  (
    object.header.frameCount = ReadLong fstream #unsigned 
    object.header.boneCount = ReadLong fstream #unsigned	
    object.header.speed = ReadFloat fstream		
  ),
  fn readSkeleton =
  (  
    for i = 1 to object.header.boneCount do
	(
	  bne = anBone()
	  bne.parentId = ReadLong fstream #unsigned  
	  append object.anBones bne 
	)
	
    for i = 1 to object.header.boneCount do
	(
	  object.anBones[i].position = freader.readVector3F() 
	)	
  ),  
  fn readAnimations =
  (
    -- read positions
    for i = 1 to object.header.frameCount do  
      append object.animations.positions (freader.readVector3F()) 
	  
    -- read rotations	  
    for i = 1 to object.header.boneCount do 
	(
	  boneRotations = #()
      for i = 1 to object.header.frameCount do	
	    append boneRotations (freader.readQuatValues())
	  append object.animations.boneRotations (boneRotations)
	)	
  ),  
  fn readFile =
  (
    readHeader()
	readSkeleton()
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
      freader = streamReader(fstream)    
      result = true      
    )
  )   
)