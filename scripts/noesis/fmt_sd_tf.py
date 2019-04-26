from inc_noesis import *


def registerNoesisTypes():
    handle = noesis.register("Sea dogs Textures", ".tf")

    noesis.setHandlerTypeCheck(handle, sdCheckType)
    noesis.setHandlerLoadRGBA(handle, sdLoadRGBA)
    
    return 1
 

class SDImage:
    def __init__(self, reader):
        self.filereader = reader
        self.width = 0
        self.height = 0
        self.type = 0
 
    def parseHeader(self):
        self.filereader.seek(5, NOESEEK_ABS)
        
        self.type = self.filereader.readUByte() 
        self.mipmapCount = self.filereader.readUByte() 
        self.maskCount = self.filereader.readUByte()  
        
        self.width = self.filereader.readUInt() 
        self.height = self.filereader.readUInt()  
        
        return 0

    def getMipMapsData(self):
        # skip mip-maps
        width = self.width
        height = self.height
        
        for i in range(self.mipmapCount - 1):
            width = int(width/2)
            height = int(height/2)
            self.filereader.seek(width * height * 2, NOESEEK_REL)            
     
    def getMasksData(self):              
        # get palette 

        alpha = (255).to_bytes(1, byteorder = "little")         
        palette = bytearray()
        for i in range(256):
            palette += self.filereader.readBytes(3)
            self.filereader.seek(1, NOESEEK_REL)
            palette += alpha                        
        
        # get first mask               
        indexes = self.filereader.readBytes(self.width * self.height)
        self.maskData = rapi.imageDecodeRawPal(indexes, palette, self.width, \
            self.height, 8, "r8g8b8a8")  
 
    def getImageData(self):
        if self.type == 1:
            format = "b5g5r5a1"         
        else:
            format = "b5g6r5"
            
        imageBuffer = self.filereader.readBytes(self.width * self.height * 2)
        
        self.data = rapi.imageDecodeRaw(imageBuffer, self.width, self.height, \
            format) 
        
        if self.type == 1:                    
            i = 0 
            size = len(self.data)         
            for i in range(size):
                if not(i & 3):            
                    self.data[i - 1] = 255      
 
    def read(self): 
        self.getImageData()
        self.getMipMapsData()
        self.getMasksData()        
    
    
def sdCheckType(data):
    sdImage = SDImage(NoeBitStream(data))
    if sdImage.parseHeader() != 0:
        return 0
        
    return 1

    
def sdLoadRGBA(data, texList):
    sdImage = SDImage(NoeBitStream(data))
    if sdImage.parseHeader() != 0:
        return 0
  
    sdImage.read()
  
    # 16 bit texture
    texList.append(NoeTexture("seadogstex", sdImage.width, sdImage.height, \
        sdImage.data, noesis.NOESISTEX_RGBA32))   

    # 8 bit texture        
    #texList.append(NoeTexture("seadogstex", sdImage.width, sdImage.height, \
    #    sdImage.maskData, noesis.NOESISTEX_RGBA32))          
    return 1    