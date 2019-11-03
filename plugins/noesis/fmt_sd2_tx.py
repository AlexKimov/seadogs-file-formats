from inc_noesis import *


def registerNoesisTypes():
    handle = noesis.register("Sea Dogs 2 (Pirates of the Caribbean) Textures", ".tx")

    noesis.setHandlerTypeCheck(handle, sdpcCheckType)
    noesis.setHandlerLoadRGBA(handle, sdpcLoadRGBA)
    #noesis.setHandlerWriteRGBA(handle, sdpcWriteRGBA)
    
    return 1
 
D3DFORMAT_DXT1 = 827611204
D3DFORMAT_DXT3 = 861165636
D3DFORMAT_DXT5 = 894720068
  
class SDPCImage:
    def __init__(self, reader):
        self.filereader = reader
        self.width = 0
        self.height = 0
        self.type = 0
 
    def parseHeader(self):
        #self.filereader.seek(5, NOESEEK_ABS)
        
        self.version = self.filereader.readUInt() 
        self.width = self.filereader.readUInt() 
        self.height = self.filereader.readUInt()  
        
        self.mapCount = self.filereader.readUInt() 
        self.type = self.filereader.readUInt() 
        self.size = self.filereader.readUInt() 
        
        return 0            

    def getImageData(self):
        d3dFormat = {21:"b8g8r8a8", 22:"b8g8r8a8", 23:"b5g6r5", 24:"b5g5r5a1", \
            25:"b5g5r5a1", 26:"b4g4r4a4"}
        if self.type < D3DFORMAT_DXT1: # RGB
            format = d3dFormat[self.type]  
            if self.type < 23: 
                imageBuffer = self.filereader.readBytes(self.width * self.height * 4)
            else:                    
                imageBuffer = self.filereader.readBytes(self.width * self.height * 2)   
            self.data = rapi.imageDecodeRaw(imageBuffer, self.width, self.height, \
            format) 
        else: # DXT
            if self.type == D3DFORMAT_DXT1:
                self.data = self.filereader.readBytes(int(self.width * self.height / 2))
            else:
                self.data = self.filereader.readBytes(self.width * self.height)                
 
    def read(self): 
        self.getImageData()
        
    
def sdpcCheckType(data):
    sdpcImage = SDPCImage(NoeBitStream(data))
    if sdpcImage.parseHeader() != 0:
        return 0
        
    return 1  


def sdpcLoadRGBA(data, texList):
    sdpcImage = SDPCImage(NoeBitStream(data))
    if sdpcImage.parseHeader() != 0:
        return 0 
        
    sdpcImage.read()    
     
    if sdpcImage.type == D3DFORMAT_DXT1:     
        texList.append(NoeTexture("seadogstex", sdpcImage.width, sdpcImage.height, \
            sdpcImage.data, noesis.NOESISTEX_DXT1))
    elif sdpcImage.type == D3DFORMAT_DXT3:     
        texList.append(NoeTexture("seadogstex", sdpcImage.width, sdpcImage.height, \
            sdpcImage.data, noesis.NOESISTEX_DXT3))
    elif sdpcImage.type == D3DFORMAT_DXT5:     
        texList.append(NoeTexture("seadogstex", sdpcImage.width, sdpcImage.height, \
            sdpcImage.data, noesis.NOESISTEX_DXT5))
    else:     
        texList.append(NoeTexture("seadogstex", sdpcImage.width, sdpcImage.height, \
            sdpcImage.data, noesis.NOESISTEX_RGBA32))    
            
    return 1          