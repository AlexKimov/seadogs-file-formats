/*

*/

filein "dialogs.ms"
filein "stream.ms"
filein "def_model.ms"

struct defStrings
(
  types = "Sea Dogs 1 defmated scene (*.def)|*.def",
  openFileCaption = "Open .def file"
)

struct defFile
(
  strings = defStrings(),
  scene = defScene(),
  fstream,
  filename,
  freader, 
  fn readItem =
  (
    dfItem = defItem()
    dfItem.index = ReadLong fstream #unsigned
	dfItem.type = ReadLong fstream #unsigned
	dfItem.unknown1 = ReadLong fstream #unsigned
	dfItem.filename = freader.ReadChars 256
    dfItem.position = freader.readVector3F()   
    dfItem.rotation = freader.readVector3F()
	dfItem.link = ReadLong fstream #signed

	result = dfItem 
  ),
  fn readFile =
  (
    itemCount = ReadLong fstream #unsigned
	for i = 1 to itemCount do
	(
      dfItem = readItem()
	  -- skip everything except .cff files (3d models)
	  if dfItem.type == 200 and \
	    toLower (fileUtils.getFileExtension (dfItem.filename))  == ".cff" then
	    append scene.items dfItem
	)
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