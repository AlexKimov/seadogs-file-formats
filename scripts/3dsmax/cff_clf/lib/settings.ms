/*
  Author: AlexKimov
  Version: 0.1
  Description: 
*/

filein "utils.ms"
filein "ini.ms"

struct iniSettings
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
      for propName in names do
      (
        strName = propName as string
        if ini.isKeyExist iniSectionTitle strName then
        (
          prop = getProperty properties propName
          propClass = classof prop
          case propClass of 
          (        
            Integer:
            (
              intValue = ini.getIntegerValue iniSectionTitle strName
              if intValue > 0 then
                setProperty properties propName intValue             
            )
            Array:
            (
              strArray = ini.getArrayValue iniSectionTitle strName
              if strArray.count > 0 then
                setProperty properties propName strArray            
            )                
            Point2: 
            (
              point = ini.getPoint2Value iniSectionTitle strName
              if point.x > 0 then
                setProperty properties propName point            
            ) 
            BooleanClass: 
            (
              boolValue = ini.getBooleanValue iniSectionTitle strName
              if boolValue != undefined then
                setProperty properties propName boolValue  
            )    
            -- String, Value, etc...
            default:
            (
              strValue = ini.getValue iniSectionTitle strName
              if strValue != "" then
                setProperty properties propName strValue             
            )            
          )                     
        )
      ) 
    )   
  )
)
