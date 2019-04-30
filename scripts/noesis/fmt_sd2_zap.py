from inc_noesis import *


def registerNoesisTypes():
    handle = noesis.register("Sea Dogs 2 (Pirates of the Caribbean) mask/foam texture", ".zap")

    noesis.setHandlerTypeCheck(handle, zapCheckType)
    noesis.setHandlerLoadRGBA(handle, zapLoadRGBA)
    
    #noesis.setHandlerWriteRGBA(handle, sdpcWriteRGBA)
    
    return 1
    
    
class ZAPImage:
    def __init__(self, reader):
        self.filereader = reader
        self.size = 0
        self.blockIndex = []
        self.blockData = []
        
    def parseHeader(self):
        self.imageSize = self.filereader.readUInt() # image width
        self.blocksInRow = self.filereader.readUInt() # number of packed blocks in image line 
        self.blockSize = self.filereader.readUInt() # size of block in bytes
        self.unknown1 = self.filereader.readUInt() # 3 bytes per pixel?
        self.unknown2 = self.filereader.readUInt()
        if self.blockSize != 8 or self.unknown1 != 3 or self.unknown2 != 7:
            return 1           
        self.blockCount = self.filereader.readUInt() # number of packed blocks   
        
        return 0 
        
    def unpackDataToRGB(self):
        # the image splitted into blocks of 8×8
        # "blockIndex" contains block indexes, if block index is equel 0xXX80, it   
        # must be replaced with array of XX values 64 bytes in size, if not data 
        # must copied from "blockData" using index from "blockIndex"
        
        unpackedData = bytearray() 
        col = 0
        
        unpackedImageLines = bytearray([0] * self.imageSize * self.blockSize)
        blockCol = 0
        noesis.logPopup()
       
        # refactor this
        for index in self.blockIndex:
            if index & 0xFF00 == 32768:
                blockData = bytearray([index & 0xFF] * self.blockSize * self.blockSize)  
            else:            
                blockData = self.blockData[index]            
            for i in range(self.blocksInRow):
                blockPos = self.blockSize * i
                imageLinePos = self.imageSize * i + blockCol * self.blockSize                    
                unpackedImageLines[0 + imageLinePos: self.blockSize + imageLinePos] = \
                    blockData[0 + blockPos: self.blockSize + blockPos]
           
            blockCol += 1           
                     
            if blockCol == self.blocksInRow:          
                unpackedData += unpackedImageLines
                unpackedImageLines = bytearray([0] * self.imageSize * self.blockSize)                 
                blockCol = 0
        
        # from 8bit to rgb24 
        data = bytearray()        
        for component in unpackedData:
            pixelColorComponent = (component).to_bytes(1, byteorder = 'big')
            data += pixelColorComponent + pixelColorComponent + pixelColorComponent
     
        # it's need to be flipped, but...
        
        return data
        
    def getRGBAData(self):

        # read block indexes 
        count = int((self.imageSize * self.blocksInRow) / self.blockSize)
        for i in range(count):
            self.blockIndex.append(self.filereader.readUShort())
        
        # read blocks
        count = self.blockSize*self.blockSize # 64
        for i in range(self.blockCount):               
            self.blockData.append(self.filereader.readBytes(count))
         
        # unpack data 
        return self.unpackDataToRGB()    
        
    def read(self):
        self.data = self.getRGBAData()
        
    
    
def zapCheckType(data):
    zapImage = ZAPImage(NoeBitStream(data))
    if zapImage.parseHeader() != 0:
        return 0
        
    return 1   


def zapLoadRGBA(data, texList):

    zapImage = ZAPImage(NoeBitStream(data))
    if zapImage.parseHeader() != 0:
        return 0
        
    zapImage.read()    

    texList.append(NoeTexture("seadogstex", zapImage.imageSize, zapImage.imageSize, \
            zapImage.data, noesis.NOESISTEX_RGB24))     

    return 1               