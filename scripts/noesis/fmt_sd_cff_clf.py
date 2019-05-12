from inc_noesis import *
import os
import noewin
import noewinext

def registerNoesisTypes():
    handle = noesis.register("Sea Dogs (2000) cyclone model", ".cff;.clf")
    noesis.setHandlerTypeCheck(handle, sdCycloneCheckType)
    noesis.setHandlerLoadModel(handle, sdCycloneLoadModel)
        
    return 1
  

CYCLONE_INTERMEDIATE_FORMAT = 1  
  
  
class Vector3F:
    def read(self, reader):
        self.x = reader.readFloat()
        self.y = reader.readFloat()
        self.z = reader.readFloat()   


class Vector2F:
    def read(self, reader):
        self.x = reader.readFloat()
        self.y = reader.readFloat()


class Vector3UI16:
    def read(self, reader):
        self.x = reader.readShort()
        self.y = reader.readShort()
        self.z = reader.readShort()


class Vector2UI16:
    def read(self, reader):
        self.x = reader.readShort()
        self.y = reader.readShort()      
 
 
class Vector3B:
    def read(self, reader):
        self.x = reader.readUByte()
        self.y = reader.readUByte()
        self.z = reader.readUByte()
        
class Vector3SH:
    def read(self, reader):
        self.x = reader.readShort()
        self.y = reader.readShort()
        self.z = reader.readShort()        
 
 
class cycloneModelFace: 
    def __init__(self):
        self.indexes = ()
        self.uvs = []
        
    def readIndexes(self, type, reader):
        if type == 0:
            indexes = Vector3B()           
        else:      
            indexes = Vector3SH() 
        indexes.read(reader)            
        self.indexes = (indexes.x, indexes.y, indexes.z)  
        
    def readUVs(self, reader):
        for i in range(3):
            uv = Vector2F()        
            uv.read(reader)
            self.uvs.append(uv)         
            
            
class cycloneModelVertex: 
    def __init__(self, type = 0): 
        if type == 0:    
             self.position = Vector3UI16()
        else:
             self.position = Vector3F()        
        self.uv = Vector2UI16()
        self.color = Vector3B()
        
        
class cycloneModelMesh:
    def __init__(self):        
        self.position = Vector3F()
        self.uvDelim = 0
        self.radius = 0
        self.texIndex = 0
        self.name = ""
        self.vertexes = []
        self.faces = []
        self.animationFrames = []
        
 
class cycloneModelMeshAnimFrame:
    def __init__(self):  
        self.translation = Vector3F()
        self.rotation = Vector3F()
        
  
class SDCycloneModel:
    def __init__(self, reader, isIntermediateFormat = 0): 
        self.filereader = reader
        self.textureList = []        
        self.meshes = []
        self.isIntermediateFormat = True if isIntermediateFormat == 1 else False
        
    def readHeader(self):
        if self.isIntermediateFormat:
            if self.filereader.readUInt() != 269554195: 
                return 1            
            self.filereader.seek(12, NOESEEK_REL)           
            self.modelCount = self.filereader.readUInt() 
            self.textureCount = self.filereader.readUInt()
            self.filereader.seek(4, NOESEEK_REL)
            self.meshCount = self.filereader.readUInt()
            self.filereader.seek(4, NOESEEK_REL)
            self.animationCount = self.filereader.readUInt()
            self.filereader.seek(8, NOESEEK_REL)            
        else:    
            self.position = Vector3F()
            self.position.read(self.filereader)
            self.scale = Vector3F()
            self.scale.read(self.filereader)        
            
            self.textureCount = self.filereader.readUInt()
            self.propCount = self.filereader.readUInt()
            self.modelCount = self.filereader.readUInt()
            self.filereader.seek(4, NOESEEK_REL)
            
            self.cullRadius  = self.filereader.readFloat()  
            
            #noesis.logPopup()      
            #print(self.textureCount)
            
        return 0             
      
    def getTextureList(self):     
        if self.isIntermediateFormat:
            for i in range(self.textureCount): 
                self.textureList.append(str(self.filereader.readBytes(256), 'utf-8'))            
        else:        
            for i in range(self.textureCount):
                length = self.filereader.readUByte()  
                self.textureList.append(str(self.filereader.readBytes(length), 'utf-8'))
            
            self.getMaterials()          

    def getMaterials(self):
        # skip all data      
        for i in range(self.propCount):
            self.filereader.seek(36, NOESEEK_REL)
            count = self.filereader.readUInt()
            self.filereader.seek(count*20, NOESEEK_REL)
    
    def readMesh(self): 
        mesh = cycloneModelMesh()  
        
        # read header
        if self.isIntermediateFormat:
            mesh.name = str(self.filereader.readBytes(32), 'ascii')
            mesh.animFrameCount = self.filereader.readUInt()
            mesh.texIndex = self.filereader.readUInt()
            mesh.vertexCount = self.filereader.readUInt()       
            mesh.faceCount = self.filereader.readUInt()
            self.filereader.seek(96, NOESEEK_REL)
            
            # read vertexes
            for i in range(mesh.vertexCount):
                vertex = cycloneModelVertex(1)        
                vertex.position.read(self.filereader)
                self.filereader.seek(16, NOESEEK_REL) 
                
                mesh.vertexes.append(vertex)                
                
            # read faces
            for i in range(mesh.faceCount):
                face = cycloneModelFace()                    
                face.readIndexes(1, self.filereader)
                self.filereader.seek(2, NOESEEK_REL)                 
                face.readUVs(self.filereader)
                
                mesh.faces.append(face)           
        else:
            mesh.position.read(self.filereader)
            mesh.uvDelim = self.filereader.readFloat()
            mesh.radius = self.filereader.readFloat()
            mesh.texIndex = self.filereader.readUInt() 
            mesh.vertexCount = self.filereader.readUInt()       
            mesh.faceCount = self.filereader.readUInt()
            unknown = self.filereader.readUInt()
            mesh.animFrameCount = self.filereader.readUInt()
            mesh.name = self.filereader.readBytes(4)            
        
            # read vertexes
            for i in range(mesh.vertexCount):
                vertex = cycloneModelVertex()        
                vertex.position.read(self.filereader)
                vertex.uv.read(self.filereader)
                vertex.color.read(self.filereader)
                mesh.vertexes.append(vertex)
                
            # read faces
            for i in range(mesh.faceCount):
                face = cycloneModelFace()        
                if mesh.vertexCount > 256:
                   face.readIndexes(1, self.filereader)    
                else:            
                   face.readIndexes(0, self.filereader)
                
                mesh.faces.append(face) 
                
        # read animations
        for i in range(mesh.animFrameCount): 
            frame = cycloneModelMeshAnimFrame()        
            frame.translation.read(self.filereader) 
            frame.rotation.read(self.filereader)   
            
            self.filereader.seek(4, NOESEEK_REL) # frame number   
            
            mesh.animationFrames.append(frame) 
            
        self.meshes.append(mesh)                
               
    def getMeshes(self):
        if not self.isIntermediateFormat:
            self.meshCount = self.filereader.readUInt()
            self.filereader.seek(4, NOESEEK_REL) 
            
        for i in range(self.meshCount): 
            self.readMesh()
      
    def read(self): 
        if self.readHeader() == 1:
            return 0            
        self.getTextureList()
        self.getMeshes()
        
        return 1 
        
      
class sdmodelViewDialogWindow:
    def __init__(self, model):
        self.options = {"Frame": 0, "Path":""}    
        self.isCanceled = True
        
    def sdmodelViewButtonGetPath(self, noeWnd, controlId, wParam, lParam):    
        
        return True 
        
    def sdmodelViewButtonLoad(self, noeWnd, controlId, wParam, lParam):
        frame = self.frameEditBox.getText()  
        try:
            self.options["Frame"] = int(frame)        
        except:
            pass
       
        self.options["Path"] = self.pathEditBox.getText() 
        self.isCanceled = False
        self.noeWnd.closeWindow()  
        
        return True 
        
    def sdmodelViewButtonCancel(self, noeWnd, controlId, wParam, lParam):
        self.isCanceled = True      
        self.noeWnd.closeWindow()  
        
        return True          
 
    def create(self):   
        self.noeWnd = noewin.NoeUserWindow( \
            "Load cyclone model file", "openModelWindowClass", 385, 145) 
        noeWindowRect = noewin.getNoesisWindowRect()
        
        if noeWindowRect:
            windowMargin = 100
            self.noeWnd.x = noeWindowRect[0] + windowMargin
            self.noeWnd.y = noeWindowRect[1] + windowMargin   
            
        if self.noeWnd.createWindow():
            self.noeWnd.setFont("Arial", 12)    
            
            self.noeWnd.createStatic("Textures path:", 5, 5, 110, 20)
            # choose path to textures          
            index = self.noeWnd.createEditBox(5, 25, 275, 20, "", None, False, True)
            self.pathEditBox = self.noeWnd.getControlByIndex(index)           
            
            self.noeWnd.createStatic("Frame:", 5, 53, 110, 20)
            # choose frame number          
            index = self.noeWnd.createEditBox(50, 50, 95, 20, "")
            self.frameEditBox = self.noeWnd.getControlByIndex(index)
            self.frameEditBox.setText("0")            
                
            self.noeWnd.createButton("Open", 290, 20, 80, 25, \
                 self.sdmodelViewButtonGetPath)                  
            self.noeWnd.createButton("Load", 5, 85, 80, 30, \
                 self.sdmodelViewButtonLoad)
            self.noeWnd.createButton("Cancel", 90, 85, 80, 30, \
                 self.sdmodelViewButtonCancel)
                 
            self.noeWnd.doModal()                  
      
      
def sdCycloneCheckType(data):

	return 1    
        
        
def sdCycloneLoadModel(data, mdlList):
    extension = os.path.splitext(rapi.getInputName())[1].lower()
    
    if extension == ".cff":    
        cycloneModel = SDCycloneModel(NoeBitStream(data))
    else:
        cycloneModel = SDCycloneModel(NoeBitStream(data), CYCLONE_INTERMEDIATE_FORMAT)
        
    cycloneModel.read() 
   
    #dialogWindow = sdmodelViewDialogWindow(cycloneModel)
    #dialogWindow.create() 
    #if dialogWindow.isCanceled:     
    #    return 0

    #frameNumber = dialogWindow.options.get("Frame")    
    #texturesPath = dialogWindow.options.get("Path") 
    frameNumber = 0
    texturesPath = ""
    
    ctx = rapi.rpgCreateContext()
    rapi.rpgSetOption(noesis.RPGOPT_TRIWINDBACKWARD, 1) # change face order
    
    # load textures
    if cycloneModel.textureList:
        materials = []
        textures = []        
        for name in cycloneModel.textureList:          
            name = name.split(".")[0]
            textureName = "{}{}.tf".format(texturesPath, name)               
            texture = rapi.loadExternalTex(textureName)
            if texture != None:
                textures.append(texture)            
                material = NoeMaterial(name, textureName)
                material.setFlags(noesis.NMATFLAG_TWOSIDED, 1)
                materials.append(material)
        
        if len(textures) != len(cycloneModel.textureList):
            materials = []
            textures = []                    
    
    #noesis.logPopup()
    # load meshes
    for mesh in cycloneModel.meshes:

        if mesh.animFrameCount > 0:
            if frameNumber > len(mesh.animationFrames):
                frame = mesh.animationFrames[0]
            else:                
                frame = mesh.animationFrames[frameNumber]
            rotation = frame.rotation
            translation = frame.translation

            posVector = NoeVec3( (translation.x, translation.y, translation.z) )
            rotAngles = NoeAngles( (rotation.x, rotation.y, rotation.z) ).toDegrees()

            transMatrix = NoeMat43()            
            transMatrix = transMatrix.rotate(rotAngles[1], NoeVec3([0.0, -1.0, 0.0])) 
            transMatrix = transMatrix.rotate(rotAngles[0], NoeVec3([1.0, 0.0, 0.0]))              
            transMatrix = transMatrix.rotate(rotAngles[2], NoeVec3([0.0, 0.0, 1.0])) 
            
            transMatrix[3] = posVector 
            rapi.rpgSetTransform(transMatrix)    

        if materials:
            rapi.rpgSetMaterial(materials[mesh.texIndex].name)
    
        rapi.immBegin(noesis.RPGEO_TRIANGLE)
        
        for face in mesh.faces:
            if not cycloneModel.isIntermediateFormat:        
                for index in face.indexes:
                    # uv
                    uv = mesh.vertexes[index].uv
                    uvX = uv.x / mesh.uvDelim
                    uvY = uv.y / mesh.uvDelim
                    rapi.immUV2((uvX, uvY))
                    # vertex pos
                    position = mesh.vertexes[index].position
                    posX = cycloneModel.position.x + position.x * cycloneModel.scale.x / 32767.0; 
                    posY = cycloneModel.position.y + position.y * cycloneModel.scale.y / 32767.0;  
                    posZ = cycloneModel.position.z + position.z * cycloneModel.scale.z / 32767.0;                
                    rapi.immVertex3( (posX, posY, posZ) ) 
            else:
                uvs = mesh.face.uvs             
                for i in range(3):
                    rapi.immUV2((uvs[i].u, uvs[i].v))
                    pos = mesh.vertexes[index].position                
                    rapi.immVertex3( (pos.x, pos.y, pos.z) )                             
        
        rapi.immEnd()              

    mdl = rapi.rpgConstructModelSlim()
    if materials:    
        mdl.setModelMaterials(NoeModelMaterials(textures, materials))                
    mdlList.append(mdl)
    
    #rapi.setPreviewOption("setAngOfs", "0 0 0")
    
    return 1    
