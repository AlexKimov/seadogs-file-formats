/*

*/

filein "dialogs.ms"
filein "stream.ms"
filein "utils.ms"
filein "sls_model.ms"

struct slsStrings
(
  types = "Sea Dogs 1 sailes data (*.sls)|*.sls",
  openFileCaption = "Open .sls file"
)

struct slsFile
(
  strings = slsStrings(),
  model = slsModel(),
  fstream,
  filename,
  freader,
  fn readVertex =
  (
    modVert = slsModelVertex()
    vert.position = freader.readVector3F()
	fseek fstream 16 #seek_cur
	
    result = vertex		
  ), 
  fn readFace =
  (
    modFace = slsModelFace()
    modFace.indexes = freader.readVector3UI16()
	fseek fstream 2 #seek_cur 
   	modFace.uv1 = freader.readVector2F()
   	modFace.uv2 = freader.readVector2F()
   	modFace.uv3 = freader.readVector2F()
	
    result = face	
  ),    
  fn readYard =
  (
    yard = slsYardModel()
    yard.filename = fstream.readChars 16
	fseek fstream 16 #seek_cur
	vertCount = ReadLong fstream #unsigned
	faceCount = ReadLong fstream #unsigned	
	for i = 1 to vertCount do
	  append yard.vertexes readVertex()
	for i = 1 to faceCount do
	  append yard.faces readFace() 

    result = yard	
  ),  
  fn readMast =
  (
    mast = slsMast()
    fseek fstream 8 #seek_cur
	mast.mat = fstream.readMatrix()
	count = ReadLong fstream #unsigned
    for i = 1 to count do
	  append mast.yards readYard()
	
    result = mast	
  ),
  fn readFile =
  (
    while not eof fstream do
	  append model.masts readMast() 
	
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