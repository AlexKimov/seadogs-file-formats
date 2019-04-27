from inc_noesis import *


def registerNoesisTypes():
    handle = noesis.register("Sea Dogs (2000) cyclone model", ".cff;.clf")
    noesis.setHandlerTypeCheck(handle, sdCycloneCheckType)
    noesis.setHandlerLoadModel(handle, sdCycloneLoadModel)
             
    return 1
  
  
class Vector3F:
    def read(self, reader):
        self.x = reader.readFloat()
        self.y = reader.readFloat()
        self.z = reader.readFloat()   


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
        
    def read(self, type, reader):
        if type == 0:
            indexes = Vector3B()           
        else:      
            indexes = Vector3SH() 
        indexes.read(reader)            
        self.indexes = (indexes.x, indexes.y, indexes.z)  
            
            
class cycloneModelVertex: 
    def __init__(self):        
        self.position = Vector3UI16()
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
    def __init__(self, reader): 
        self.filereader = reader
        self.textureList = []        
        self.meshes = []
        
    def readHeader(self):
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
      
    def getTextureList(self):
        for i in range(self.textureCount):
            length = self.filereader.readUByte()  
            self.textureList.append(str(self.filereader.readBytes(length), 'utf-8'))

    def getProperties(self):
        # skip all data
        for i in range(self.propCount):
            self.filereader.seek(36, NOESEEK_REL)
            count = self.filereader.readUInt()
            self.filereader.seek(count*20, NOESEEK_REL)
    
    def readMesh(self): 
        mesh = cycloneModelMesh()  
        
        # read header
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
               face.read(1, self.filereader)    
            else:            
               face.read(0, self.filereader)
            
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
        meshCount = self.filereader.readUInt()

        self.filereader.seek(4, NOESEEK_REL) 
        for i in range(meshCount): 
            self.readMesh()
      
    def read(self): 
        self.readHeader()     
        self.getTextureList()
        self.getProperties()
        self.getMeshes()
        
        
def sdCycloneCheckType(data):

	return 1    
        
        
def sdCycloneLoadModel(data, mdlList): 
    cycloneModel = SDCycloneModel(NoeBitStream(data)) 
    cycloneModel.read() 
   
    #noesis.logPopup()
    #print(len(cycloneModel.meshes[0].vertexes))
   
    ctx = rapi.rpgCreateContext()

    # load textures
    if cycloneModel.textureList:
        materials = []
        textures = []        
        for name in cycloneModel.textureList:
            try:             
                name = name.split(".")[0]
                textureName = "{}.tf".format(name)               
                texture = rapi.loadExternalTex(textureName)
                if texture != None:
                    textures.append(texture)            
                    material = NoeMaterial(name, textureName)
                    material.setFlags(0, 1)
                    materials.append(material)
            except: 
                print("Can't load texture ", name) 

    # load meshes
    for mesh in cycloneModel.meshes:
        frame = mesh.animationFrames[0]
        rotation = frame.rotation
        translation = frame.translation

        posVector = NoeVec3((translation.x, translation.y, translation.z))
        rotVector = NoeVec3((rotation.x, rotation.y, rotation.z)).normalize()
        transMatrix2 = rotVector.toMat43()
        transMatrix = NoeMat43( ((1, 0, 0), (0, 1, 0), (0, 0, 1), posVector) )
       
        transMatrix2[3] = posVector       
        rapi.rpgSetTransform(transMatrix2)    

        rapi.rpgSetMaterial(materials[mesh.texIndex].name)
    
        rapi.immBegin(noesis.RPGEO_TRIANGLE)
        
        for face in mesh.faces:
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
                rapi.immVertex3((posX, posY, posZ)) 
        
        rapi.immEnd()              

    mdl = rapi.rpgConstructModelSlim()            
    mdl.setModelMaterials(NoeModelMaterials(textures, materials))                
    mdlList.append(mdl)
    
    return 1    
