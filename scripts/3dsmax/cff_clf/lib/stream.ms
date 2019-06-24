/*

*/

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
    result = (point4 x y z w)    
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
    local x = (ReadFloat fstream)
    local y = (ReadFloat fstream)
    local z = (ReadFloat fstream) 
    local w = (ReadFloat fstream)    
    result = (quat x y z w)
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
      if byte == 0 then
      (    
        fseek fstream (length - i) #seek_cur
        exit         
      )  
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
  fn writeString str length: =
  (
    if length != unsupplied then
	(
	  WriteString fstream str
	  length = length - str.count
	  for i = 1 to length do
	  (
	    WriteByte fstream 0
	  )
	)
	else
	  WriteString fstream str
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
  fn writeVector3F val =
  (
    WriteFloat fstream val.x
    WriteFloat fstream val.y
    WriteFloat fstream val.z
  ), 
  fn writeVector3UI16 val sign:#unsigned =
  (
    WriteShort fstream val.x sign
    WriteShort fstream val.y sign
    WriteShort fstream val.z sign 
  ),
  fn writeVector2F val sign:#unsigned =
  (
    WriteFloat fstream val.x
    WriteFloat fstream val.y    
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