from inc_noesis import *
import os
import noewin
import noewinext
import tempfile

def registerNoesisTypes():  
    handle = noesis.register("Age of Sale 2/Privateer's Bounty resource archive", ".pak")
    noesis.setHandlerExtractArc(handle, aosExtractResources)
    
    handle = noesis.registerTool("Age of Sale 2 resource viewer", aosResViewerToolMethod, \
        "View Age of Sale 2 resource files.")
    noesis.setToolFlags(handle, noesis.NTOOLFLAG_CONTEXTITEM)
    noesis.setToolVisibleCallback(handle, aosResourceViewerVisible) 
    
    return 1


AGE_OF_SAIL_FORMAT       = 1001
PRIVATEERS_BOUNTY_FORMAT = 1002   
  
  
class pakDirHeader:
    def __init__(self, pos, type, count, offset, dirExist, name):
        self.pos = pos    
        self.type = type
        self.count = count
        self.offset = offset
        self.dirExist = dirExist
        self.name = name
        self.parent = None
        
        
class pakFileHeader:  
    def __init__(self, pos, type, size, offset, name):
        self.pos = pos
        self.type = type
        self.size = size 
        self.offset = offset
        self.name = name
      
      
class pakFileTableReader:
    def __init__(self, filereader):
        self.filereader = filereader
        self.fileTable = {}
        
    def readRecHeader(self):
        pos = self.filereader.tell()
        type = self.filereader.readUByte()
        size = self.filereader.readUInt()
        offset = self.filereader.readUInt()
        dirExist = self.filereader.readUInt()
        self.filereader.seek(4, NOESEEK_REL) 
        name = self.filereader.readString()

        if type == 1:
            return pakFileHeader(pos, type, size, offset, name) 
        else:
            return pakDirHeader(pos, type, size, offset, dirExist, name)        
    
    # wtf    
    def readDirRecord(self, header = None):      
        recHeader = self.readRecHeader()

        if recHeader.type == 0:
            self.readDirRecord(recHeader)
            if header != None and header.count > 0:
               self.readDirRecord(header)
         
        if recHeader.type == 1:  
            self.filereader.seek(recHeader.pos, NOESEEK_ABS)
            fileHeaders = []

            for i in range(header.count):
                fileRecHeader = self.readRecHeader()
                fileHeaders.append(fileRecHeader)
                
            self.fileTable.update({header:fileHeaders})		
            
            self.readDirRecord()   
                          
        if recHeader.type == 2 and recHeader.dirExist == 1:
            self.readDirRecord() 
            
    def readRecords(self):
        self.readDirRecord()


class pakDirectoryEntry:
    def __init__(self, fileCount = 0, name = ""):
        self.fileCount = fileCount
        self.name = name


class pakFileEntry:
    def __init__(self, size = 0, offset = 0, name = ""):
        self.size = size
        self.offset = offset
        self.name = name


class pakPBFileTableReader:      
    def __init__(self, filereader):
        self.filereader = filereader   
        self.fileTable = {}
        
    def readDirEntry(self):    
        fileCount = self.filereader.readUInt()
        name = self.filereader.readString()
        
        return pakDirectoryEntry(fileCount, name)
        
    def readFileEntry(self):    
        size = self.filereader.readUInt()
        offset = self.filereader.readUInt()
        self.filereader.seek(4, NOESEEK_REL)         
        name = self.filereader.readString()
        
        return pakFileEntry(size, offset, name)
        
    def readRecords(self):  
        dirCount = self.filereader.readUInt()

        dirEntries = []
        for i in range(dirCount):
            dirEntries.append(self.readDirEntry())

        for dirEntry in dirEntries:
            fileEntries = []
            for i in range(dirEntry.fileCount):
                   fileEntries.append(self.readFileEntry())
                
            self.fileTable.update({dirEntry: fileEntries})    
            
        return self.fileTable
        
        
class aosResorceFile:
    def __init__(self):
        self.fileTable = {}
        self.format = AGE_OF_SAIL_FORMAT
        
    def unpack(self, filepath):      
        for directory, files in self.fileTable.items():
            for file in files:
                try:                 
                    filename = "{}\{}\{}".format(filepath, directory.name, file.name)
                    os.makedirs(os.path.dirname(filename), exist_ok = True)
                    self.filereader.seek(file.offset, NOESEEK_ABS)
                    fileData = self.filereader.readBytes(file.size)                    
                    with open(filename, "wb") as resFile: 
                        resFile.write(fileData)                        
                except:
                    return False  
                    
        return True
                    
    def getFileData(self, filename):    
        for directory, files in self.fileTable.items():
            for file in files:
                try:              
                    if file.name == filename:
                        self.filereader.seek(file.offset, NOESEEK_ABS)
                        return self.filereader.readBytes(file.size)
                except:
                    return None                         
            
    def parseHeader(self):    
        magic = self.filereader.readString()
        
        if magic != "ENPAK":
            return False
        
        gameType = self.filereader.readByte()
        if gameType == 0: # Privateer's Bounty
            self.filereader.seek(3, NOESEEK_REL) 
            self.format = PRIVATEERS_BOUNTY_FORMAT
            self.filereader.seek(self.filereader.readUInt(), NOESEEK_ABS) # filetable pos
        elif gameType <= 2: # AOS 2
            self.filereader.seek(19, NOESEEK_REL)
        else:
            return False        
            
        return True        
    
    def readFileTable(self):       
        try:
            filetableReader = (pakPBFileTableReader(self.filereader) \
                if self.format == PRIVATEERS_BOUNTY_FORMAT else pakFileTableReader(self.filereader))
      
            filetableReader.readRecords()
            self.fileTable = filetableReader.fileTable
            if self.format == PRIVATEERS_BOUNTY_FORMAT:
                self.filereader.seek(30, NOESEEK_ABS) # back pos to files data 
        except:
            return None        
            
        return True
        
    def open(self, filename):
        try:      
            with open(filename, "rb") as resFile:
                self.filename = filename 
                self.filereader = NoeBitStream(resFile.read())                 
                               
            if self.parseHeader():              
                self.readFileTable()  				
            else:
                return None            
        except:
            return None        
  
  
class resViewerDialogWindow():
    def __init__(self, filename):
        self.filename = filename
        self.isCanceled = True
        self.resourceFile = aosResorceFile()
        self.resourceFile.open(self.filename)
     
    def viewerToolButtonOpen(self, noeWnd, controlId, wParam, lParam):
        selestedItem = self.resourceFileView.selected()
        if selestedItem != None:
            name = self.resourceFileView.getItemText(selestedItem)

          
            if name.find(".") != -1: 
                extension = os.path.splitext(name)[1]

                tempFile = tempfile.NamedTemporaryFile(suffix = extension, \
                    delete=False)
                data = self.resourceFile.getFileData(name)
                if data != None:
                    tempFile.write(data)
                    noesis.openAndRemoveTempFile(tempFile.name)
                else:
                    tempFile.close()               
        
        return True
        
    def viewerToolButtonUnpack(self, noeWnd, controlId, wParam, lParam):
        saveDialog = noewinext.NoeUserDialog("Choose path to export", "", "", "")  
        path = saveDialog.getSaveFileName()
        noesis.logPopup()        

        if path != None:
            if self.resourceFile.unpack(path.rstrip('\n\0')): 
                noesis.messagePrompt("Files successfully unpacked.")
            else:
                noesis.doException("Error: Can't unpack.")            
           
        return True             
  
    def viewerToolButtonClose(self, noeWnd, controlId, wParam, lParam):
        self.noeWnd.closeWindow()
             
        return True  
  
    def viewResFile(self):
        if self.resourceFile.fileTable != None:         
            self.resourceFileView.clear()
            
            for directory, files in self.resourceFile.fileTable.items():             
                rootItem = self.resourceFileView.insertItem(directory.name)
                for file in files:
                    self.resourceFileView.insertItem(file.name, rootItem) 
  
    def create(self):   
        self.noeWnd = noewinext.NoeUserWindowExt( \
            "AOS 2 Resource Viewer", "AOSResourceViewerWindowClass", \
            385, 495) 
        noeWindowRect = noewin.getNoesisWindowRect()
        
        if noeWindowRect:
            windowMargin = 100
            self.noeWnd.x = noeWindowRect[0] + windowMargin
            self.noeWnd.y = noeWindowRect[1] + windowMargin   
            
        if self.noeWnd.createWindow():
            self.noeWnd.setFont("Arial", 12)    
            
            self.noeWnd.createStatic("Resource file:", 5, 2, 110, 20)
            
            index = self.noeWnd.createTreeView(5, 25, 275, 440)
            self.resourceFileView = self.noeWnd.getControlByIndex(index) 

            #self.noeWnd.createButton("Open", 290, 25, 80, 30, \
            #     self.viewerToolButtonOpen)                       
            #self.noeWnd.createButton("Unpack", 290, 400, 80, 30, \
            #     self.viewerToolButtonUnpack)
            self.noeWnd.createButton("Close", 290, 435, 80, 30, \
                 self.viewerToolButtonClose)            

            self.viewResFile()

            self.noeWnd.doModal()  
            
            
def aosResourceViewerVisible(toolIndex, selectedFile):
    if selectedFile is None or \
        (os.path.splitext(selectedFile)[1].lower() != ".pak"):
        
        return 0
        
    return 1 
    
    
def aosResViewerToolMethod(toolIndex):
    srcPath = noesis.getSelectedFile()
    
    if srcPath is None or os.path.exists(srcPath) is not True:
        noesis.messagePrompt( \
            "Selected file isn't readable through the standard filesystem.")
            
        return 0
        
    resViewerDialogWindow(srcPath).create()  
    
    return 1   


def aosExtractResources(fileName, fileLen, justChecking):
    if justChecking: #it's valid
        return 1 
    
    resourceFile = aosResorceFile()
    resourceFile.open(fileName)
	   
    for directory, files in resourceFile.fileTable.items():
        for file in files:
            try:                 
                outfilename = "{}\{}".format(directory.name, file.name)
                resourceFile.filereader.seek(file.offset, NOESEEK_ABS)                               
                rapi.exportArchiveFile(outfilename, resourceFile.filereader.readBytes(file.size))                       
            except:
                return 0
       
    return 1      