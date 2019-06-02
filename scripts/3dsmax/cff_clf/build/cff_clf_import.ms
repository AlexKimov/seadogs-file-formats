-- lib/ms.ms


clearlistener() 

-- lib/utils.ms

struct converter (
  fn arrayValuesToString valueArray =
  (
    if valueArray.count > 1 then
    (
      str = valueArray[1] as string
      for i = 2 to valueArray.count do
        str +=  "," + (valueArray[i] as string)
      result = "(" + str + ")"
    )
    else
      result = valueArray[1] as string
  ),
  fn stringToPoint2 str = 
  (
    elements = filterstring str "[,]"
	if elements.count > 0 then
	(
	  try
      (	  
        first = elements[1] as integer
        second = elements[2] as integer
	  ) 
	  catch 
	  (
	    messageBox "Error. Can't convert: " + str + " to Point2 value"
	  )
      pointTwo = [first, second]
	)
	else
	(
	  --messageBox "Error. Can't convert: " + str + " to Point2 value"
	  [0, 0]
	)	  
  ),
  fn stringToInteger str = 
  (
    try
    (	  
      str as integer
    )
    catch 
	(
	  --messageBox "Error. Can't convert: " + str + " to integer value"
	  -1
	)
  ),
  fn stringToFloat str = 
  (
    try
    (	  
      str as float
	)  
    catch 
	(
	  --messageBox "Error. Can't convert: " + str + " to float value"
	  -1
	)	
  ), 
  fn stringToBoolean str = 
  (
    try
    (	  
      str as boolean
	)  
    catch 
	(
	  --messageBox "Error. Can't convert: " + str + " to boolean value"
	  -1
	)	
  ),   
  fn stringToArray str = 
  (
    array = #()
    elements = filterstring str "(,)"
	if elements.count > 0 then
	  for element in elements do
        append array (element as name)
   	array  
  )
)

struct fileUtils
(
  fn isFileExist filename =
  (
    result = doesFileExist filename
  ), 
  fn getFileExtension filename =
  (
    result = getFilenameType filename
  ),
  fn getCurrentPath filename =
  (
    result = getFilenamePath filename
  ),
  fn getFileName filename ext:false =
  (
    if ext then
      filenameFromPath filename
    else
      getFilenameFile filename
  ),
  fn findFiles directory pattern subfolders:false =
  (
    local files = #()  
    if subfolders then
    (
      dir_array = GetDirectories (directory + "/*")
      for dir in dirArray do
        join dirArray (GetDirectories (dir + "/*"))
      for file in dirArray do
        join files (getFiles (file + pattern)) 
    )
    else
      files = getFiles (directory + pattern)
    result = files  
  )  
 )
 
fileUtils = fileUtils()
converter = converter()

-- lib/dialogs.ms


struct dialogs
(
  caption = "",
  types = "",
  fn isValue txt =
  (
    if txt != "" then
    (
      try
      (
        val = execute txt
        result = true
      )
      catch 
      (
        messageBox "ERROR. Not a number: " + txt + "."
        result = false
      )
    )  
    else 
      result = false        
  ),
  fn isNonNegativeValue txt =
  (
    value = converter.stringToInteger txt
    if value <= 0 then 
    (
      messageBox ("Error. Value: " + txt + " must be greater than or equal to zero.")
      result = false
    )  
    else
      result = true  
  ),  
  fn checkInputValue txt checkType =
  (  
    result = false
    if isValue txt then  
      result = isnNonNegativeValue txt         
  ),  
  fn openFileDialog &filename mode =
  (
  	if filename == undefined or filename == "" then
      filename = 
      (      
	    if mode == "rb" then 
          getOpenFileName caption: caption types: types
	    else
          getSaveFileName caption: caption types: types
      )  
	if filename != undefined then
      filestream = fopen filename mode 
  ), 
  fn saveFile =
  (
  
  ),   
  fn openFolder caption =
  (
    getSavePath caption: caption
  ),
  fn showMessage caption =
  (
    messageBox caption
  )  
)

dialogs = dialogs()

-- lib/ini.ms


struct iniFile
(
  filename,
  fn setValue section key value =
  (
    setINISetting filename section key (value as string)
  ),
  fn getValue section key =
  (
    getINISetting filename section key
  ),
  fn getIntegerValue section key =
  (
    strValue = getINISetting filename section key
	if strValue != "" then
      converter.stringToInteger(strValue)
	else
      result = -1	
  ),
   fn getBooleanValue section key =
  (
    strValue = getINISetting filename section key
	if strValue != "" then
      converter.stringToBoolean(strValue)
	else
      result = undefined	
  ), 
  fn getFloatValue section key =
  (
    strValue = getINISetting filename section key
	if strValue != "" then   
      converter.stringToFloat(strValue)
	else
      result = -1		  
  ),
  fn getArrayValue section key =
  (
    strValue = getINISetting filename section key
	if strValue != "" then     
      converter.stringToArray(strValue)
	else
      result = -1		   
  ),
  fn getPoint2Value section key =
  (
    strValue = getINISetting filename section key
	if strValue != "" then      
      converter.stringToPoint2 (strValue)
	else
      result = [0, 0]	  
  ),   
  fn isKeyExist section key =
  (
    hasINISetting filename section key      	  
  )
)

ini = iniFile()

-- lib/settings.ms


struct settings
(
  properties,
  iniFile = "settings.ini",
  fn saveToIniFile filename iniSectionTitle =
  (    
    ini.filename = iniFile    
	if fileUtils.isFileExist filename then    
      ini.filename = filename  
   
	if fileUtils.isFileExist ini.filename then 
    (
      local strValue
      names = getPropNames properties
      for name in names do
      (
        strName = name as string
        if ini.isKeyExist iniSectionTitle strName then
        (
          prop = getProperty properties name
          propClass = classof prop
          case propClass of 
          (        
            Array:
            (
              local str = convertor.arrayValuesToString prop
              ini.setValue iniSectionTitle strName str       
            )                
            default:
              ini.setValue iniSectionTitle strName (prop as string)                     
          )                     
        )
      ) 
    )     
  ),  
  fn loadFromIniFile filename iniSectionTitle =
  (
    local intValue = 0
    local array = #()
    local point = [0, 0]
    local strValue = ""
    local boolValue = true
    
    ini.filename = iniFile    
	if fileUtils.isFileExist filename then    
      ini.filename = filename  
   
	if fileUtils.isFileExist ini.filename then 
    (
      local strValue
      names = getPropNames properties
      for name in names do
      (
        strName = name as string
        if ini.isKeyExist iniSectionTitle strName then
        (
          prop = getProperty properties name
          propClass = classof prop
          case propClass of 
          (        
            Integer:
            (
              intValue = ini.getIntegerValue iniSectionTitle strName
              if intValue > 0 then
                setProperty properties name intValue             
            )
            Array:
            (
              array = ini.getArrayValue iniSectionTitle strName
              if array.count > 0 then
                setProperty properties name array             
            )                
            Point2: 
            (
              point = ini.getPoint2Value iniSectionTitle strName
              if point.x > 0 then
                setProperty properties name point            
            ) 
            BooleanClass: 
            (
              boolValue = ini.getBooleanValue iniSectionTitle strName
              if boolValue != undefined then
                setProperty properties name boolValue  
            )    
            -- String, Value, etc...
            default:
            (
              strValue = ini.getValue iniSectionTitle strName
              if strValue != "" then
                setProperty properties name strValue             
            )            
          )                     
        )
      ) 
    )   
  )
)


-- lib/max.ms


struct maxStrings 
(
  lang = "Eng",
  errorVertNumber = "Error. Number of vertexes of the mesh is less than %d.",
  fn loadFromIni filename =
  (
    local strings = settings(this)
    strings.loadFromIniFile filename lang
  )
)

struct maxAnimation
(
  fn setLength length =
  (
    animationRange = interval 0 length
  )
)

struct skinModifier
(
  fn create =
  (
    result = skin()
  ),
  fn applyToMesh msh =
  (
    skinmod = this.create()
    addModifier msh skinmod
    setCommandPanelTaskMode #modify
    modPanel.setCurrentObject skinmod
    result = skinmod
  ),
  fn setVertexWeight skinMod vertexId boneID vertexWeight =
  (
    skinOps.replaceVertexWeights skinMod vertexId boneID vertexWeight
  ),
  fn addBone skinMod skeletonBone =
  (
    skinOps.addBone skinMod skeletonBone 1 
  ),
  fn attachBonesToMesh msh boneArray =
  (
    skinmod = this.applyToMesh msh
    for skeletonBone in boneArray do
      this.addBone skinmod skeletonBone  
    modPanel.setCurrentObject skinmod       
    result = skinmod 
  )  
)

struct maxController
(
  fn addKey controller time =
  (
    addNewKey controller time
  ),
  fn deleteAllKeys controller =
  (
    deleteKeys controller #allKeys 
  ),
  fn deleteKeysByRange controller startFrame endFrame =
  (
  	for x in controller.keys.count to 1 by -1 do
  	(
  	  if (controller.keys[x].time >= startFrame) and \
        (controller.keys[x].time <= endFrame) do 
        deleteKey controller x
  	)
  )  
)

struct maxModifier
(
  skin = skinModifier()
)

struct maxBones
(
  fn create startPos endPos axis name: = 
  (
    bone = BoneSys.createBone startPos endPos axis
    if name != unsupplied then
      bone.name = name
    bone.width = 1
    bone.height = 1
    bone.taper = 100
    bone.wirecolor = yellow
    bone.showlinks = true
    bone.position.controller = linear_position()
    bone.rotation.controller = linear_rotation()
    result = bone  
  )
)

struct maxNodeOp
(
  fn addToGroup obj objs =
  (
    attachNodesToGroup obj objs
  ),
  fn createGroup objs name opened:false =
  (
    groupNode = Group objs name:name
    if opened then
      this.openGroup groupNode
    result = groupNode
  ),
  fn openGroup group =
  (  
    setGroupOpen group true
  ),
  fn closeGroup group =
  (  
    setGroupOpen group false
  ),  
  fn getNode name =
  (
    result = getnodebyname name exact:true
  )  
)

struct slateMatEditor
(
  fn open =
  (
    sme.Open()
  ),
  fn close =
  (
    sme.Close()
  ), 
  fn createView caption =
  ( 
    local index = sme.GetViewByName caption
    if index > 0 then
      result = sme.GetView index
    else
      result = sme.GetView(sme.CreateView caption)   
  ),
  fn createNode material view pos =
  (
    result = view.CreateNode material pos
  )  
)

struct maxMaterial
(
  fn createTextureMap textureName =
  (
    bitmapTex = bitmaptexture filename:textureName
    result = bitmapTex  
  ),
  fn createStandardMaterial twoSided matName =
  (
    standMaterial = standardMaterial twoSided:twoSided showInViewport:true
    standMaterial.name = matName
    result = standMaterial
  ),
  fn createMaterialFromBitmap filename matname =
  (
    bitmapTexture = this.openBitmapFile fileName
    if bitmapTexture != undefined then
    (
      mat = this.createBitmapMaterial bitmapTexture
      mat.name = matname 
      result = mat
    )     
  ),
  fn createBitmapBlendMaterial bitmapImageArray =
  (  
    blendmat = blend
    blendmat.map1 = standardMaterial \
      diffuseMap:(bitmaptexture bitmap:bitmapImageArray[1]) showInViewport:true
    blendmat.map2 = standardMaterial \
      diffuseMap:(bitmaptexture bitmap:bitmapImageArray[2]) showInViewport:true 
    blendmat.mask = gradient  
    result = blendmat    
  ),  
  fn createBitmapMultiMaterial bitmapImageArray isTexBlended =
  (  
    if isTexBlended then
      numsubs = bitmapImageArray.count + 1
    else
      numsubs = bitmapImageArray.count
    multimat = multimaterial numsubs:numsubs
    for i = 1 to bitmapImageArray.count do
      multimat[i] = standardMaterial \
      diffuseMap:(bitmaptexture bitmap:bitmapImageArray[i]) showInViewport:true
    if isTexBlended != unsupplied and isTexBlended then
      multimat[multimat.count + 1] = createBitmapBlendMaterial bitmapImageArray
    result = multimat  
  ),
  fn addMaterialToMesh msh mat =
  (
  	msh.material = mat
  ),  
  fn openBitmapFile filename =
  (
    --try
    --(
      openBitMap filename
    --)  
    --catch
    --(
    --  messageBox ("Can't open bitmap file " + filename + ".")
    --  result = undefined
    --)  
  ),
  fn createBitmapMaterial bitmapImage =
  (
    result = standardMaterial diffuseMap:(bitmaptexture bitmap:bitmapImage) \
      showInViewport:true
  ),  
  fn createBitmap imageData imageWidth imageHeight filename =
  (
  	b = bitmap imageWidth imageHeight color:white 
	b.filename = filename + ".bmp"
    for line = 0 to (imageHeight - 1) do
    (
      row = #()
      for col = (line*imageWidth + 1) to (line + 1)*imageWidth do 
        append row imageData[col]
      setPixels b [0, line] row
    )       
    save b    
	result = b
  ),
  fn addBitmapToMesh msh bitmapImage =
  (
  	msh.material = standardMaterial \
      diffuseMap:(bitmaptexture bitmap:bitmapImage) showInViewport:true
  )    
)

struct max3ds
(
  strings,
  VisualStyle = #Shaded,
  sme,
  bones,
  nodes,
  modifiers, 
  controller,
  animation,
  material,
  fn setUnits unitsSystem type =
  (
    units.DisplayType = unitsSystem
    if unitsSystem == #Metric then
      units.MetricType = type
  ),
  fn getBoundPoints mesh =
  (
    boundPoint = #()
    append boundPoint mesh.max
	append boundPoint mesh.min
	boundPoint
  ),
  fn getMeshDimension msh =
  (
    meshDimensions = msh.max - msh.min
  ),
  fn getMeshVertCount msh =
  (
    result = getNumVerts msh 
  ),
  fn getMeshVerts msh =
  (
    result = (for i = 1 to msh.numVerts collect (getVert msh i))
  ),
  fn getFaceColor mesh =
  (
    faceColorArray = #()
    for i = 1 to mesh.numVerts do 
      append vertArray (getVert mesh i)
  	result = faceColorArray
  ),  
  fn createPlaneMesh size pos name =
  (
    vertArray = #([0, 0, 0], [size.x, 0, 0], [0, size.y, 0], [size.x, size.y, 0])
    faceArray = #([1, 2, 3], [2, 4, 3])
    idArray = #(1, 1)
    tvertArray = #([0, 0, 0], [1, 0, 0], [0, 1, 0], [1, 1, 0]) 
    msh = max.createTexturedMesh vertArray faceArray idArray tvertArray name
    if msh != undefined then
    (
      msh.pos = pos
      result = msh
    )
  ),  
  fn createMesh vertArray faceArray name: =
  (
    --try
	--(
      msh = mesh vertices:vertArray faces:faceArray
      if name != unsupplied and name != "" then      
        msh.name = name  
      result = msh		
	--)
	--catch 
	--(
	--  messageBox ("ERROR. Can't create mesh.")
    --)  	
  ), 
  fn createTexturedMesh vertArray faceArray tvertArray idArray: name: =
  (
    --try
	--(        
      if idArray == unsupplied then
        msh = mesh vertices:vertArray faces:faceArray tverts:tvertArray
      else      
        msh = mesh vertices:vertArray faces:faceArray materialIDS:idArray \
          tverts:tvertArray
    --) 
	--catch 
	--(
	  --messageBox ("ERROR. Can't create mesh: " + name + ".")
      --return undefined
    --)
    
    buildTVFaces msh.mesh
    for i = 1 to msh.mesh.numfaces do 
      (setTVFace msh.mesh i (getFace msh.mesh i)) 
    if name != unsupplied and name != "" then      
      msh.name = name 
    result = msh			
  ),
  fn cloneMesh msh pos nodes =
  (
    maxOps.CloneNodes msh offset:pos expandHierarchy:false cloneType:#copy \
      newNodes:&nodes 
  ),
  fn moveMesh msh pos = 
  (
    move msh pos
  ),
  fn rotateMesh msh angles =
  (
    rotate msh angles
  ),
  fn copyMesh msh =
  (
    mshCopy = copy msh
	mshCopy
  ),
  fn attachMesh srcMesh dstMesh =
  (
    meshop.attach srcMesh dstMesh
  ),
  fn sliceMesh msh planeNormal planePos =
  (
  	local offset = dot planeNormal (planePos - (msh.pos * inverse msh.transform * msh.objecttransform))
  	meshop.slice msh #all planeNormal offset delete:true
  	update msh
  ),
  fn createHelperPoint name transformMatrix:(matrix3 1) =
  (
    hpoint = point()
    hpoint.name = name
    hpoint.transform = transformMatrix
    result = hpoint
  ), 
  fn init =
  (
    if strings == undefined then
      strings = maxStrings()
    this.sme = slateMatEditor()
    this.bones = maxBones()
    this.nodes = maxNodeOp()
    this.modifiers = maxModifier()  
    this.controller = maxController()
    this.animation = maxAnimation()
    this.material = maxMaterial() 
	-- set viewport mod
    VP = NitrousGraphicsManager.GetActiveViewportSetting()
    VP.VisualStyleMode = VisualStyle
  ),
  on create do init()
)

max = max3ds()

-- lib/stream.ms

struct streamReader
(
  fstream,
  fn readBool longval:false =
  (
    if longval then
      result = (if (ReadLong fstream #unsigned) > 0 then true else false)
    else
      result = (if (ReadByte fstream #unsigned) > 0 then true else false)     
  ),
  fn readName =  
  (
    fseek fstream 4 #seek_cur
    result = ReadString fstream
  ),
  fn readVector3UI16 sign:#unsigned =
  (
    local x = (ReadShort fstream sign)
    local y = (ReadShort fstream sign)
    local z = (ReadShort fstream sign)
    result = (point3 x y z)     
  ),  
  fn readVector2UI16 sign:#unsigned =
  (
    local x = (ReadShort fstream sign)
    local y = (ReadShort fstream sign)
    result = (point2 x y)   
  ),    
  fn readVector2F =
  (
    local x = (ReadFloat fstream)
    local y = (ReadFloat fstream)
    result = (point2 x y)     
  ),  
  fn readVector3F =
  (
    local x = (ReadFloat fstream)
    local y = (ReadFloat fstream)
    local z = (ReadFloat fstream)    
    result = (point3 x y z)    
  ),
  fn readVector4F =
  (
    local x = (ReadFloat fstream)
    local y = (ReadFloat fstream)
    local z = (ReadFloat fstream) 
    local w = (ReadFloat fstream)     
    result = (point2 x y z w)    
  ),  
  fn readVector3B =
  (
    local x = (ReadByte fstream #unsigned)
    local y = (ReadByte fstream #unsigned)
    local z = (ReadByte fstream #unsigned)    
    result = (point3 x y z)      
  ), 
  fn readVector3SH =
  (
    local x = (ReadShort fstream #unsigned)
    local y = (ReadShort fstream #unsigned)
    local z = (ReadShort fstream #unsigned )   
    result = (point3 x y z)    
  ),  
  fn readIndexValues =
  (
    values = readVector3UI16()
    values.x = values.x + 1 
    values.y = values.y + 1 
    values.z = values.z + 1
    result = values 
  ),  
  fn readColorValues alpha:true normalized:true =
  (
    -- color component value is in range 0..1
    normalCoeff = 1
    if normalized then
      normalCoeff = 255
    r = (ReadFloat fstream)*normalCoeff
    g = (ReadFloat fstream)*normalCoeff
    b = (ReadFloat fstream)*normalCoeff   
    if alpha then
    (
      a = (ReadFloat fstream)*normalCoeff  
      result = (color r g b a)
    )
    else
      result = (color r g b)    
  ),  
  fn readVertexValues =
  (
    result = readVector3F()
  ), 
  fn readQuatValues =
  (
    result = readVector4F() as quat
  ),
  fn readMatrix = 
  (
    values1 = readVector3F()
    values2 = readVector3F()
    values3 = readVector3F()
    values4 = readVector3F()
    
    matrix = matrix3 1
    matrix.row1 = [values1.x, values1.y, values1.z]
    matrix.row2 = [values2.x, values2.y, values2.z]
    matrix.row3 = [values3.x, values3.y, values3.z]
    matrix.row4 = [values4.x, values4.y, values4.z]
    result = matrix    
  ),
  fn ReadChars length =
  (
	local str = ""
	for i = 1 to length do
	(
      byte = ReadByte fstream #unsigned
      if byte != 0 then 
        str += bit.intAsChar (byte)
	)
	return str
  )  
)

struct streamWriter
(
  fstream,
  fn writeBool boolValue =
  (
    if boolValue == true then 
      WriteByte fstream 1
    else 
      WriteByte fstream 0    
  ),  
  fn writeName name =  
  (
    WriteLong fstream (name.count + 1)
    WriteString fstream name
  ), 
  fn writeColor colorValues normalized:true =
  (
    if normalized then
      normalCoeff = 255
    ReadFloat fstream colorValues.r*normalCoeff
    ReadFloat fstream colorValues.g*normalCoeff
    ReadFloat fstream colorValues.b*normalCoeff       
  ),
  fn writePoint3Values point =
  (
    WriteFloat fstream point.x
    WriteFloat fstream point.y
    WriteFloat fstream point.z
  ), 
  fn writeQuatValues quatVar =
  (
    WriteFloat fstream quatVar.x
    WriteFloat fstream quatVar.y
    WriteFloat fstream quatVar.z
    WriteFloat fstream quatVar.w   
  ),
  fn writeMatrixValues matrix =
  (
    WriteFloat fstream matrix.row1.x 
    WriteFloat fstream matrix.row1.y
    WriteFloat fstream matrix.row1.z  
    WriteFloat fstream matrix.row2.x 
    WriteFloat fstream matrix.row2.y
    WriteFloat fstream matrix.row2.z  
    WriteFloat fstream matrix.row3.x 
    WriteFloat fstream matrix.row3.y
    WriteFloat fstream matrix.row3.z  
    WriteFloat fstream matrix.row4.x 
    WriteFloat fstream matrix.row4.y
    WriteFloat fstream matrix.row4.z      
  )  
)

-- lib/cyclone_model.ms


struct cyclonModelHeader
(
  origin = (point3 0 0 0),
  scale = (point3 0 0 0),
  textureCount = 0,
  materialCount = 0,
  meshCount = 0,
  frameCount = 0,
  lodCount = 0,
  occlusionRadius = 0
)

struct cycloneTextureName
(
  length = 0,
  name = ""   
)

struct cycloneMaterialUnknown
(
  Unknown1 = 0,
  Unknown2 = 0,
  Unknown3 = 0,
  Unknown4 = 0,
  Unknown5 = 0
)

struct cycloneMaterial
(
  Unknown1 = 0,
  Unknown2 = 0,
  Unknown3 = 0,
  Unknown4 = 0,
  Unknown5 = 0,
  Unknown6 = 0,
  Unknown7 = 0,
  Unknown8 = 0,
  Unknown9 = #() 
)

struct cycloneModelLodVertex
(
  origin = (point3 0 0 0) 
)

struct cycloneModelLodHeader
(
  origin = (point3 0 0 0), 
  uvDelim = 0,
  occlusionRadius = 0,
  textureIndex = 0,
  vertexCount = 0,
  faceCount = 0,
  unknown = 0,
  frameCount = 0,
  name = 0
)

struct cycloneModelLodMeshVertex
(
  coordinates = (point3 0 0 0),
  uv = (point3 0 0 0),
  color = (point3 0 0 0)
)

struct cycloneModelLodMeshFace
(
  indexes = (point3 0 0 0)  
)

struct cycloneModelLodAnimationFrame
(
  position = (point3 0 0 0),
  rotation = (point3 0 0 0),
  time = 0
)

struct cycloneModelLodMesh
(
  header = cycloneModelLodHeader(),
  vertexes = #(),
  faces = #(),
  animationFrames = #() 
)

struct cycloneModelLod
(
  meshes = #()
)

struct cycloneModel
(
  header = cyclonModelHeader(),
  textureList = #(),
  materials = #(),
  modelLods = #(),
  fn create =
  (
    getMaterials()
    getModels()
  )
)

-- lib/cyclone.ms


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

      msh.vertexes[face.indexes[1] + 1].uv = freader.readVector2F()  
      msh.vertexes[face.indexes[2] + 1].uv = freader.readVector2F() 
      msh.vertexes[face.indexes[3] + 1].uv = freader.readVector2F() 
      
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


-- lib/cyclone_viewer.ms


struct cycloneViewerSettings
(
  texturesPath = "",
  isTextured = True,
  texFormat = "tf",
  lodIndex = 1,
  frameIndex = 0, 
  to3dsMaxSystem = True,
  isIntermediateFormat = False,
  isClockwizeOrder = True  
)

struct cyclonSceneViewer
(
  materials = #(),
  objects = #()
)

struct cycloneMeshViewer
(
  isIntermediateFormat = False,
  isClockwiseOrder = True, 
  fn create modelMesh materials: modelPos: modelScale:  =
  ( 
    local faceArray = #()   
    local vertArray = #()    

    for vert in modelMesh.vertexes do 
    (    
      if isIntermediateFormat then  
        append vertArray vert.coordinates            
      else
      (     
        local x = modelPos.x + (vert.coordinates.x * modelScale.x) / 32767.0 
        local y = modelPos.y + (vert.coordinates.y * modelScale.y) / 32767.0  
        local z = modelPos.z + (vert.coordinates.z * modelScale.z) / 32767.0   
        
        append vertArray [x, y, z] 
      )
    )      
    
    for face in modelMesh.faces do 
    (   
      face.indexes.x += 1     
      if isClockwiseOrder == False then
      (    
        face.indexes.y += 1 
        face.indexes.z += 1 
      ) 
      else
      (
        face.indexes.z += 1      
        face.indexes.y += 1       
      )
      
      append faceArray face.indexes
    ) 
      
    if materials != unsupplied then
    (
      tvertArray = #()
      
      for vert in modelMesh.vertexes do 
      (       
        if isIntermediateFormat then 
        (         
          local uvX = vert.uv.x         
          local uvY = vert.uv.y          
        )        
        else
        (
          local uvX = vert.uv.x/modelMesh.header.uvDelim    
          local uvY = vert.uv.y/modelMesh.header.uvDelim 
        )    
        
        append tvertArray [uvX, -uvY, 0]  
      )         
        
      msh = max.createTexturedMesh vertArray faceArray tvertArray \
        name:modelMesh.header.name
      
      max.material.addMaterialToMesh msh materials[modelMesh.header.textureIndex + 1]
    )
    else
      msh = max.createMesh vertArray faceArray name:modelMesh.header.name
    
    result = msh      
  )
)

struct cycloneAnimationViewer
(
  fn create msh frame transfCoordinates:true =
  (
    -- rads to degrees
    local angles = eulerAngles (frame.rotation.x * (180/pi)) \
      (frame.rotation.y * (180/pi)) (frame.rotation.z * (180/pi))
        
    local transformMatrix = matrix3 1
    transformMatrix.row4 = frame.position
    transformMatrix = preRotateY transformMatrix angles.y      
    transformMatrix = preRotateX transformMatrix angles.x    
    transformMatrix = preRotateZ transformMatrix angles.z       
     
    if transfCoordinates then
    (
      transMatrix = (matrix3 [1, 0, 0] [0, 0, 1] [0, -1, 0] [0, 0, 0]) 
      transformMatrix = transformMatrix*transMatrix
    )    
     
    max.controller.addKey msh.position.controller frame.time
    max.controller.addKey msh.rotation.controller frame.time 
    
    animate on
    (   
      at time frame.time msh.position.controller.value = transformMatrix.translationpart 
      at time frame.time msh.rotation.controller.value = transformMatrix.rotationpart
    )
  )
)

struct modelViewer
(
  model,
  scene = cyclonSceneViewer(),
  settings = cycloneViewerSettings(),
  meshViewer = cycloneMeshViewer(),  
  animationViewer = cycloneAnimationViewer(),  
  fn addMaterial name =
  (
    basename = fileUtils.getFileName name
    filepath = settings.texturesPath + "/" + basename + "." + settings.texFormat
    bitmapMaterial = max.material.createMaterialFromBitmap filepath basename

    if bitmapMaterial == undefined then
    (    
      standMat = max.material.createStandardMaterial true basename
      standMat.diffuseMap = max.material.createTextureMap name
      standMat.twoSided = True
      result = standMat
    )
    else
    ( bitmapMaterial.twoSided = True
      result = bitmapMaterial
    )  
  ),
  fn addMesh modelMesh mats: =
  (
    result = 
    (
      meshViewer.isIntermediateFormat = settings.isIntermediateFormat
      if mats == unsupplied then
        meshViewer.create modelMesh modelPos:model.header.origin \
          modelScale:model.header.scale
      else
        meshViewer.create modelMesh modelPos:model.header.origin \
          modelScale:model.header.scale materials:mats 
    )   
  ), 
  fn setAnimationFrame msh frame =
  (
    animationViewer.create msh frame \
      transfCoordinates:settings.to3dsMaxSystem
  ),  
  fn createScene =
  (
    -- textures
    if settings.isTextured then 
    (
      max.sme.open()
      smeView = max.sme.createView "Materials"
      for i = 1 to model.header.textureCount do
      (
        mat = addMaterial model.textureList[i].name
        max.sme.createNode mat smeView [0, i*100]
        append scene.materials mat
      )  
      max.sme.close()   
    ) 
    
    progressStart "creating meshes"
    
    if settings.lodIndex == 0 then
    ( 
      startLodIndex = 1    
      lodCount = model.header.lodCount     
    )      
    else
    (
      if settings.lodIndex <= model.header.lodCount then
      (
        startLodIndex = settings.lodIndex    
        lodCount = settings.lodIndex  
      ) 
      else
      (
        startLodIndex = 1  
        lodCount = 1        
      )      
    )
    
    -- lods
    with undo off
    for i = startLodIndex to lodCount do
    (
      modelLod = model.modelLods[i]
      
      progress = (100.0/model.header.meshCount as float)          
    
      meshIndex = 1
    
      with redraw off        
      for modelMesh in modelLod.meshes do 
      (      
        if settings.isTextured then
          msh = addMesh modelMesh mats:scene.materials
        else
          msh = addMesh modelMesh
        
        progressUpdate (progress*meshIndex) 
        meshIndex += 1   
        
        if getProgressCancel() then 
        (
          setProgressCancel true  
          exit        
        )  
                             
        if msh != undefined then
        (          
          append scene.objects msh       
          -- mesh animations
          if modelMesh.header.frameCount > 0 then
          (
            if settings.frameIndex == 0 then
            (        
              for frame in modelMesh.animationFrames do
              (
                if frame.time > animationRange.end then
                  max.animation.setLength frame.time 
                setAnimationFrame msh frame 
              )
            )
            else 
            (
              if settings.frameIndex <= modelMesh.header.frameCount then
                setAnimationFrame msh modelMesh.animationFrames[settings.frameIndex] 
              else        
                setAnimationFrame msh modelMesh.animationFrames[0]
            ) 
          )
          else
          (
            -- convert coordinates to 3dsMax ones        
            if settings.to3dsMaxSystem then
            (
              transMatrix = (matrix3 [1, 0, 0] [0, 0, 1] [0, -1, 0] [0, 0, 0]) 
              msh.transform = msh.transform*transMatrix         
            )            
          )          
        )      
      )
      
      progressEnd()       
    ) 
    
    if scene.objects.count > 0 then
    (
      select scene.objects[1]
      max zoomext sel  
      redrawViews()       
    ) 
  )  
)



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