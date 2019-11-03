from inc_noesis import *

def registerNoesisTypes():
    handle = noesis.register("Sea Dogs (2000) island image", ".dlt")

    noesis.setHandlerTypeCheck(handle, dltCheckType)
    noesis.setHandlerLoadRGBA(handle, sdDLTLoadRGBA)
    noesis.setHandlerWriteRGBA(handle, sdDLTWriteRGBA)
    
    return 1
    

class DLTImage:
    def __init__(self, reader):
        self.filereader = reader       
        
    def parseHeader(self):        
        self.size = self.filereader.readUInt()  
        self.width = self.filereader.readUInt() 
        self.height = self.filereader.readUInt() 
        self.mapCount = self.filereader.readUInt() 
        self.filereader.seek(4, NOESEEK_REL)
        
        return 0    
        
    def getImageData(self):       
        imageBuffer = self.filereader.readBytes(self.width * self.height * 2)
        self.data = rapi.imageDecodeRaw(imageBuffer, self.width, self.height, \
            "b5g6r5")    
          
    def read(self): 
        self.getImageData()


def dltCheckType(data):
    dltImage = DLTImage(NoeBitStream(data))
    if dltImage.parseHeader() != 0:
        return 0
        
    return 1


def sdDLTLoadRGBA(data, texList):
    dltImage = DLTImage(NoeBitStream(data))
    if dltImage.parseHeader() != 0:
        return 0
  
    dltImage.read()
    
    # 16 bit texture RGB565
    texList.append(NoeTexture("seadogsislandimage", dltImage.width, dltImage.height, \
        dltImage.data, noesis.NOESISTEX_RGBA32))  

    return 1  


class DLTHeader():
    def __init__(self, width, height):
        self.width = width
        self.height = height
    
    def toBytes(self):
        result = bytearray()
        imageSize = 174740
        param = 0.9        
        result += (imageSize).to_bytes(4, byteorder='little')
        result += self.width.to_bytes(4, byteorder='little')
        result += self.height.to_bytes(4, byteorder='little')
        result += (6).to_bytes(4, byteorder='little')
        result += bytearray(noePack("f", param))         
        
        return result    


def sdDLTWriteRGBA(data, imageWidth, imageHeight, filewriter): 
    header = DLTHeader(imageWidth, imageHeight)
    filewriter.writeBytes(header.toBytes()) 
    
    width = imageWidth
    height = imageHeight     
    
    for i in range(6):
        imageData = rapi.imageEncodeRaw(data, width, height, "b5g6r5")
        filewriter.writeBytes(imageData)
        width = int(width / 2)
        height = int(height / 2)     

    return 1       