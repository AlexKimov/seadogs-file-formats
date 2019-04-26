from inc_noesis import *
import noewin

def registerNoesisTypes():
    handle = noesis.register("Sea Dogs (2000) Textures", ".tf")

    noesis.setHandlerTypeCheck(handle, sdCheckType)
    noesis.setHandlerLoadRGBA(handle, sdLoadRGBA)
    noesis.setHandlerWriteRGBA(handle, sdWriteRGBA)
    
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
        self.imageCount = self.filereader.readUByte() 
        self.palettedCount = self.filereader.readUByte()  
        
        self.width = self.filereader.readUInt() 
        self.height = self.filereader.readUInt()  
        
        return 0

    def getMipMapsData(self):
        # skip mip-maps
        width = self.width
        height = self.height
        
        for i in range(self.imageCount - 1):
            width = int(width/2)
            height = int(height/2)
            self.filereader.seek(width * height * 2, NOESEEK_REL)            
     
    def getPalettedImageData(self):              
        # get palette 

        alpha = (255).to_bytes(1, byteorder = "little")         
        palette = bytearray()
        for i in range(256):
            palette += self.filereader.readBytes(3)
            self.filereader.seek(1, NOESEEK_REL)
            palette += alpha                        
        
        # get first image              
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
        self.getPalettedImageData()        
    
    
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
    #   sdImage.maskData, noesis.NOESISTEX_RGBA32))          
    return 1 


class TFHeader():
    def __init__(self, type, mmCount, palCount, width, height):
        self.type = type
        self.mmCount = mmCount
        self.palCount = palCount
        self.width = width
        self.height = height
    
    def toBytes(self):
        result = bytearray()
        result += bytearray(5) # file starts with zeroes
        result += self.type.to_bytes(1, byteorder='little')      
        result += self.mmCount.to_bytes(1, byteorder='little')
        result += self.palCount.to_bytes(1, byteorder='little')
        result += self.width.to_bytes(4, byteorder='little')
        result += self.height.to_bytes(4, byteorder='little')
        
        return result  


class exportDialogWindow:
    def __init__(self):
        self.options = {"type":0, "mmCount":6, "palCount":6} 
        self.isCanceled = True
        
    def exportOptionsButtonExport(self, noeWnd, controlId, wParam, lParam):         
        index = self.typeListBox.getSelectionIndex()        
        self.options["type"] = index

        index = self.mmcountComboBox.getSelectionIndex()        
        self.options["mmCount"] = index

        index = self.palcountComboBox.getSelectionIndex()        
        self.options["palCount"] = index        
            
        self.isCanceled = False
        self.noeWnd.closeWindow()
        
        return True  
        
    def exportOptionsButtonCancel(self, noeWnd, controlId, wParam, lParam):
        self.noeWnd.closeWindow()
         
        return True    
    
    def show(self):   
        self.noeWnd = noewin.NoeUserWindow("Export options", "HTWindowClass", \
            300, 155) 
        noeWindowRect = noewin.getNoesisWindowRect()
        
        if noeWindowRect:
            windowMargin = 64
            self.noeWnd.x = noeWindowRect[0] + windowMargin
            self.noeWnd.y = noeWindowRect[1] + windowMargin   
            
        if self.noeWnd.createWindow():
            self.noeWnd.setFont("Arial", 12)    
            
            self.noeWnd.createStatic("Choose format:", 5, 5, 160, 20)
            # choose game list            
            index = self.noeWnd.createListBox(5, 25, 184, 47, None, 0)
            self.typeListBox = self.noeWnd.getControlByIndex(index)
            
            typeList = ("Format RGB565", "Format RGBA5551")
            
            for type in typeList:
                self.typeListBox.addString(type)               
            
            self.typeListBox.selectString(typeList[0])
                        
            self.noeWnd.createStatic("Number of 16 bit images:", 5, 70, 169, 20)
            # choose format combobox           
            index = self.noeWnd.createComboBox(160, 65, 30, 20)
            self.mmcountComboBox = self.noeWnd.getControlByIndex(index)            
            
            self.noeWnd.createStatic("Number of paletted images:", 5, 98, 169, 20)
            # choose format combobox           
            index = self.noeWnd.createComboBox(160, 95, 30, 20)
            self.palcountComboBox = self.noeWnd.getControlByIndex(index)             
            
            countList = ("6", "5", "4", "3", "2", "1", "0")            
            
            for count in countList:
                self.mmcountComboBox.addString(count)
                self.palcountComboBox.addString(count)
            
            self.mmcountComboBox.selectString(countList[0])
            self.palcountComboBox.selectString(countList[0])
            
            self.noeWnd.createButton("Export", 210, 25, 80, 30, \
                 self.exportOptionsButtonExport)
            self.noeWnd.createButton("Cancel", 210, 60, 80, 30, \
                 self.exportOptionsButtonCancel)
            
            self.noeWnd.doModal()   


def getOptions():                 
    if not noesis.optWasInvoked("-type"):
        exportDialog = exportDialogWindow()
        exportDialog.show()
        if exportDialog.isCanceled:
            return None
        options = exportDialog.options            
    else:            
        # set export options
        options = {"type":0, "mmCount":6, "palCount":6}
    
        if noesis.optWasInvoked("-type"):
            try:
                type = int(noesis.optGetArg("-type"))
                options["type"] = type                
            except:
                pass 
        
        if noesis.optWasInvoked("-MipMapCount"):
            try: 
                type = int(noesis.optGetArg("-MipMapCount"))
                options["mmCount"] = type                
            except:
                pass                
            
        if noesis.optWasInvoked("-PaletteCount"):
            try: 
                type = int(noesis.optGetArg("-PaletteCount"))
                options["palCount"] = type 
            except:
                pass              
    
    return options


def sdWriteRGBA(data, imageWidth, imageHeight, filewriter):
    options = getOptions()
    if options == None:
        return 0
    
    type = options["type"]
    mmCount = options["mmCount"]
    palCount = options["palCount"]

    header = TFHeader(type, mmCount, palCount, imageWidth, imageHeight)
    filewriter.writeBytes(header.toBytes())
   
    width = imageWidth
    height = imageHeight  
    
    if type == 1:
        format = "b5g5r5a1"         
    else:
        format = "b5g6r5"    
    
    for i in range(mmCount):
        imageData = rapi.imageEncodeRaw(data, width, height, format)
        filewriter.writeBytes(imageData)
        width = int(width / 2)
        height = int(height / 2)    
    
    palette = rapi.imageGetPalette(data, imageWidth, imageHeight, 256, 0, 0)
    filewriter.writeBytes(palette)

    width = imageWidth
    height = imageHeight  
    
    for i in range(palCount):    
        indexes = rapi.imageApplyPalette(data, width, height, palette, 256)
        filewriter.writeBytes(indexes)  
        width = int(width / 2)
        height = int(height / 2) 
        
    return 1    