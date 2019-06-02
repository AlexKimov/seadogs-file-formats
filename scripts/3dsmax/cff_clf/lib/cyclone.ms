/*

*/

filein "dialogs.ms"
filein "stream.ms"
filein "cyclone_model.ms"

struct cffStrings
(
  types = "Cyclone final format (*.cff)|*.cff",
  openFileCaption = "",
  saveFileCaption = "",
  progressString = "Reading LOD model meshes" 
)

struct clfStrings
(
  types = "Cyclone final format (*.clf)|*.clf",
  openFileCaption = "",
  saveFileCaption = "",
  progressString = "Reading LOD model meshes"   
)

struct clfFile
(
  strings = clfStrings(),
  model = cycloneModel(),
  fstream,
  filename,
  freader,  
  fn readHeader =
  (
    fseek fstream 16 #seek_cur  
    model.header.lodCount = ReadLong fstream #unsigned
    model.header.textureCount = ReadLong fstream #unsigned
    fseek fstream 4 #seek_cur
    model.header.meshCount = ReadLong fstream #unsigned
    fseek fstream 4 #seek_cur    
    model.header.frameCount = ReadLong fstream #unsigned
    fseek fstream 8 #seek_cur      
  ),
  fn readTextureList =
  (
    for i = 1 to model.header.textureCount do
    (
      textureName = cycloneTextureName()
      textureName.name = freader.ReadChars 256 
      append model.textureList textureName
    )    
  ),  
  fn readMesh =
  (
    msh = cycloneModelLodMesh()

    -- read header
    msh.header.name = freader.ReadChars 32  
    msh.header.frameCount = ReadLong fstream #unsigned    
    msh.header.textureIndex = ReadLong fstream #unsigned
    msh.header.vertexCount = ReadLong fstream #unsigned
    msh.header.faceCount = ReadLong fstream #unsigned
    fseek fstream 96 #seek_cur  


    -- read vertexes
    for i = 1 to msh.header.vertexCount do
    (
      vert = cycloneModelLodMeshVertex()
      
      vert.coordinates = freader.readVector3F()
      fseek fstream 16 #seek_cur  
      
      append msh.vertexes vert
    )    
    
    -- read faces
    for i = 1 to msh.header.faceCount do
    (
      face = cycloneModelLodMeshFace()  
      
      face.indexes = freader.readVector3UI16()
      fseek fstream 2 #seek_cur
      uv = freader.readVector2F()
      face.uv1 = [uv.x, uv.y, 0]      
      uv = freader.readVector2F()
      face.uv2 = [uv.x, uv.y, 0] 
      uv = freader.readVector2F()
      face.uv3 = [uv.x, uv.y, 0] 
        
      append msh.faces face
    )      
     
    -- read animations
    for i = 1 to msh.header.frameCount do
    (
      frame = cycloneModelLodAnimationFrame()  
      
      frame.position = freader.readVector3F()   
      frame.rotation = freader.readVector3F()
      frame.time = ReadFloat fstream
      
      append msh.animationFrames frame
    )     

    result = msh    
  ),    
  fn readLods =
  (
    modelLod = cycloneModelLod()
      
    for k = 1 to model.header.lodCount do
    (
      progressStart strings.progressString    
      progress = (100.0/model.header.meshCount as float)        
        
      for i = 1 to model.header.meshCount do
      (    
        msh = readMesh()  
        append modelLod.meshes msh 
        
        progressUpdate (progress*i)
        
        if getProgressCancel() then 
        (
          setProgressCancel true  
          exit        
        )        
      )
      
      progressEnd()    
    )
    
    append model.modelLods modelLod
  ),  
  fn readFile =
  (
	--try
	--(
      readHeader()
      readTextureList()
      readLods()

      result = true
    --)	  
    --catch	
    --(
      --dialogs.showMessage (formattedprint filename --format:strings.errorReadFile)
      --result = false
    --)  
  ),
  fn closeFile =
  (
    fclose fstream
  ),
  fn openStream fstream filename mode:"rb" =
  (
    this.fstream = fstream
    this.filename = filename
    if mode == "rb" then    
      freader = streamReader(fstream)
    else  
      fwriter = streamWriter(fstream)    
  ),   
  fn openFile mode =
  (
    dialogs.types = strings.types
    if mode == "rb" then
      dialogs.caption = strings.openFileCaption
    else
      dialogs.caption = strings.saveFileCaption
    local fname = filename
    fstream = dialogs.openFileDialog &fname mode
    if fstream != undefined then
    (
      filename = fname
      freader = rseFormatReader(fstream)
      fwriter = rseFormatWriter(fstream)  
    )  
    result = fstream
  )  
)

-- .cff format

struct cffFile
(
  strings = cffStrings(),
  model = cycloneModel(),
  fstream,
  filename,
  freader, 
  fn readHeader =
  (
    model.header.origin = freader.readVector3F()
    model.header.scale = freader.readVector3F()
    model.header.textureCount = ReadLong fstream #unsigned
    model.header.materialCount = ReadLong fstream #unsigned
    model.header.lodCount = ReadLong fstream #unsigned
    --model.header.bspSectionOffset = ReadLong fstream
    fseek fstream 4 #seek_cur
    model.header.occlusionRadius = ReadFloat fstream 
  ),
  fn readTextureList =
  (
    for i = 1 to model.header.textureCount do
    (
      textureName = cycloneTextureName()
      textureName.length = ReadByte fstream #unsigned
      textureName.name = freader.ReadChars textureName.length 
      append model.textureList textureName
    )
  ),
  fn readMaterials =
  (
    for i = 1 to model.header.materialCount do
    (
      --material = cycloneMaterial()      
      fseek fstream 36 #seek_cur
      skip = (ReadLong fstream)*20
      fseek fstream skip #seek_cur      
      --append model.textureList textureName
    )
  ),  
  fn readMesh =
  (   
    msh = cycloneModelLodMesh()  
     
    -- read header
    msh.header.origin = freader.readVector3F()
    msh.header.uvDelim = ReadFloat fstream
    msh.header.occlusionRadius = ReadFloat fstream
    msh.header.textureIndex = ReadLong fstream #unsigned
    msh.header.vertexCount = ReadLong fstream #unsigned
    msh.header.faceCount = ReadLong fstream #unsigned
    msh.header.unknown = ReadLong fstream #unsigned
    msh.header.frameCount = ReadLong fstream #unsigned
    msh.header.name = freader.ReadChars 4
    
    -- read vertexes
    for i = 1 to msh.header.vertexCount do
    (
      vert = cycloneModelLodMeshVertex()
      
      vert.coordinates = freader.readVector3UI16 sign:#signed
      uv = freader.readVector2UI16 sign:#signed
      vert.uv.x = uv.x 
      vert.uv.y = uv.y
      vert.color = freader.readVector3B()
      
      append msh.vertexes vert
    )    
       
    -- read faces
    for i = 1 to msh.header.faceCount do
    (
      face = cycloneModelLodMeshFace()  
      
      if msh.header.vertexCount <= 256 then
        face.indexes = freader.readVector3B()   
      else  
        face.indexes = freader.readVector3UI16() 
        
      append msh.faces face
    )      
    
    -- read animations
    for i = 1 to msh.header.frameCount do
    (
      frame = cycloneModelLodAnimationFrame()  
     
      frame.position = freader.readVector3F()   
      frame.rotation = freader.readVector3F()
      frame.time = ReadFloat fstream
      
      append msh.animationFrames frame
    )   
    
    result = msh    
  ),    
  fn readLods =
  (
    for k = 1 to model.header.lodCount do
    (   
      modelLod = cycloneModelLod()
       
      meshCount = ReadLong fstream #unsigned
      fseek fstream 4 #seek_cur    
      
      model.header.meshCount = meshCount
      
      progressStart strings.progressString    
      progress = (100.0/meshCount as float)        
        
      for i = 1 to meshCount do
      (    
        msh = readMesh()  
        append modelLod.meshes msh 
        
        progressUpdate (progress*i)
        
        if getProgressCancel() then 
        (
          setProgressCancel true  
          exit        
        )        
      )
      
      progressEnd()
      
      append model.modelLods modelLod
    )  
  ),  
  fn readFile =
  (
	--try
	--(
      readHeader()
      readTextureList()
      readMaterials()           
      readLods()
      result = true
    --)	  
    --catch	
    --(
      --dialogs.showMessage (formattedprint filename --format:strings.errorReadFile)
      --result = false
    --)  
  ),
  fn writeHeader =
  (
    print "test"
  ),
  fn writeTextureList =
  (
    print "test"  
  ),
  fn writeMaterials =
  (
    print "test"  
  ), 
  fn writeMesh =
  (
    print "test"  
  ),   
  fn writeLods =
  (
    print "test"  
  ),    
  fn writeFile =
  (
    print "test"  
  ),
  fn closeFile =
  (
    fclose fstream
  ),
  fn openStream fstream filename mode:"rb" =
  (
    this.fstream = fstream
    this.filename = filename
    if mode == "rb" then    
      freader = streamReader(fstream)
    else  
      fwriter = streamWriter(fstream)    
  ),   
  fn openFile mode =
  (
    dialogs.types = strings.types
    if mode == "rb" then
      dialogs.caption = strings.openFileCaption
    else
      dialogs.caption = strings.saveFileCaption
    local fname = filename
    fstream = dialogs.openFileDialog &fname mode
    if fstream != undefined then
    (
      filename = fname
      freader = rseFormatReader(fstream)
      fwriter = rseFormatWriter(fstream)  
    )  
    result = fstream
  )   
)
