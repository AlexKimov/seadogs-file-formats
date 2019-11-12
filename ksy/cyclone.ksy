meta:
  id: cyclone
  title: Sea Dogs, Age of Sail 2 CFF/CLF (aka Cyclone) file formats
  application: Sea Dogs (2000), Age of Sail 2 (2001, 2002)
  file-extension:
    - clf
    - cff
  license: MIT
  encoding: ASCII
  endian: le
doc: |
  Cyclone file format were used by Akella in here first "pirate" games started 
  with popular Sea Dogs (russian Корсары) game published in 2000 and not so 
  successful Age of Sail 2 (russian Век Парусников 2) two-game series released 
  in 2001 and 2002 years respectively. 
  
  About format versions:
  .cff - main format (aka cyclone final) and
  .clf - intermediate format with some other file structure differencies and 
  it's not used by game, but you can create it with official plugins for 3d software
  
  Basic differencies between formats:
  - sections
  materials and bsp sections only in .cff files
  - fields
  in .cff files data in mesh section is partly compressed or something like that,
  anyway you need to do some precalculations before it can be used
seq:
  - id: header
    type: file_header
  - id: textures
    type: cyclone_texture
    repeat: expr
    repeat-expr: header.body.num_textures
  - id: materials
    type: cyclone_material
    repeat: expr
    repeat-expr: header.num_materials
    if: format == "clf"
  - id: lods
    type: cyclone_lod_mesh 
    repeat: expr
    repeat-expr: header.num_lods 
    doc: number of lod models 
  - id: bsp
    type: bsp_section 
    if: format == "cff" or header.ofs_bsp_section > 0 
    doc: only in .cff files  
instances:
  format:
    value: header.magic == [0x13, 0x12, 0x11, 0x10] ? "clf" : "cff"  
types:
  file_header:
    seq:
      - id: magic
        contents: [0x13, 0x12, 0x11, 0x10]
        doc: 269554195 as integer number
      - id: body
        type:
          switch-on: format
          cases:
            "clf": clf_file_header
            "cff": cff_file_header               
    types:
      clf_file_header:
        seq:
          - id: unknown1
            type: u4
            doc: unknown value
          - id: unknown2
            doc: 0 by default
            type: u4      
          - id: unknown3
            type: u4  
            doc: 0 by default        
          - id: num_lods
            type: u4  
            doc: number of LOD models
          - id: num_textures
            type: u4  
            doc: number of textures/mats  
          - id: unknown4
            type: u4 
            doc: 0 by default         
          - id: num_meshes
            type: u4 
            doc: number of meshes        
          - id: unknown5
            type: u4 
            doc: 0 by default         
          - id: num_frames
            type: s4  
            doc: total number of frames for model animation
          - id: unknown6
            type: u4 
            doc: 0 by default         
          - id: unknown7
            type: u4   
            doc: 0 by default 
      cff_file_header:
        seq: 
          - id: object_origin
            type: f4
            repeat: expr
            repeat-expr: 3
            doc: xyz coordinates where object origin is
          - id: object_scale
            type: f4
            repeat: expr
            repeat-expr: 3
            doc: xyz object scale coordinates   
          - id: num_textures
            type: u4
            doc: number of textures
          - id: num_materials
            type: u4
            doc: number of materials
          - id: num_lods
            type: u4
            doc: number of LOD models         
          - id: ofs_bsp_section
            type: f4   
            doc: offset to bsp section, zero if doesn't exist 
          - id: lod_switch_distance
            type: f4   
            doc: distance to switch LOD models                      
  cyclone_material:
    seq:  
      - id: unknown1 
        type: u4 
      - id: unknown2 
        type: u4   
      - id: unknown3 
        type: u4 
      - id: unknown4 
        type: u4   
      - id: unknown5 
        type: u4 
      - id: unknown6 
        type: u4  
      - id: unknown7 
        type: u4  
      - id: unknown8 
        type: f4  
      - id: unknown9 
        type: u4  
      - id: num_unknown 
        type: u4 
      - id: unknown10         
        type: unknown_params
        repeat: expr
        repeat-expr: num_unknown        
    types:
      unknown_params:
        seq:
          - id: unknown1         
            type: u4 
          - id: unknown2         
            type: f4   
          - id: unknown3         
            type: u4   
          - id: unknown4         
            type: u4   
          - id: unknown5         
            type: u4             
  cyclone_texture:
    seq:  
      - id: body
        type:     
          switch-on: format
          cases:
            "clf": clf_texture_name
            "cff": cff_texture_name
    types:
      clf_texture_name:  
        seq:       
          - id: name 
            type: str      
            size: 256
            terminator: 0        
      cff_texture_name:  
        seq:  
          - id: length 
            type: b1        
          - id: name 
            type: str      
            size: length            
  cyclone_lod_mesh:
    doc: |
      LOD model mesh parameters: vertex and texture coordinates, indexes, 
      animation parameters  
    seq: 
      - id: mesh_parameters
        type:
          switch-on: format
          cases:
            "clf": clf_mesh_parameters
            "cff": cff_mesh_parameters      
      - id: animations
        type: mesh_animation_frame   
        repeat: expr
        repeat-expr: header.frame_count          
    types: 
      clf_mesh_parameters:
        seq:
          - id: header
            type: clf_mesh_header
          - id: vertexes
            type: clf_mesh_vertex      
            repeat: expr
            repeat-expr: header.vertex_count           
          - id: faces
            type: clf_mesh_face    
            repeat: expr
            repeat-expr: header.face_count 
        types:
          clf_mesh_header:  
            seq:
              - id: name
                type: str      
                size: 32
                terminator: 0 
                doc: mesh name (hand, window, etc..)
              - id: num_frame_count
                type: u4 
                doc: total number of frames for animations, only for characters
              - id: texture_index
                type: u4 
                doc: index of texture assigned to the mesh  
              - id: num_verteces
                type: u4 
                doc: number of mesh vertices         
              - id: num_faces
                type: u4 
                doc: number of mesh faces       
              - id: reserved
                size: 96  
                doc: unused 
          clf_mesh_vertex:  
            seq:     
              - id: vertex_coordinates
                type: f4 
                repeat: expr
                repeat-expr: 3   
                doc: x, y, z vertex coordinates             
              - id: reserved
                size: 20  
                doc: unused 
          clf_mesh_face:
            seq: 
              - id: vertex_index 
                type: u2 
                repeat: expr
                repeat-expr: 3   
                doc: indexes of face            
              - id: reserved 
                type: u2 
                doc: seems to be always 0           
              - id: texture_coordinates
                type: mesh_vertex_texture_coordinates 
                repeat: expr
                repeat-expr: 3   
                doc: texture coordinates for vertexes                              
      cff_mesh_parameters:
        seq:
          - id: header
            type: cff_mesh_header
          - id: vertexes
            type: cff_mesh_vertex      
            repeat: expr
            repeat-expr: header.vertex_count           
          - id: faces
            type: cff_mesh_face    
            repeat: expr
            repeat-expr: header.face_count        
        types:        
          cff_mesh_header:  
            seq:  
              - id: object_origin_coordinates
                type: f4
                repeat: expr
                repeat-expr: 3   
                doc: object origin coordinates
              - id: uv_delimeter
                type: f4 
                doc: number to divide uv values  
              - id: radius
                type: f4 
                doc: occlusion sphere radius ?                 
              - id: texture_index
                type: u4 
                doc: index of texture assigned to the mesh                  
              - id: num_verteces
                type: u4 
                doc: number of mesh vertices         
              - id: num_faces
                type: u4 
                doc: number of mesh faces 
              - id: unknown1     
                type: u4
                doc: seems to be 1 always
              - id: num_frame_count
                type: u4 
                doc: total number of frames for animations, only for characters                 
              - id: name
                type: str      
                size: 4
                doc: mesh name, it's kinda short, isn't it?           
          cff_mesh_vertex:  
            seq:     
              - id: vertex_coordinates
                type: u2 
                repeat: expr
                repeat-expr: 3              
                doc: xyz vertex coordinates             
              - id: vertex_texture_coordinates
                type: mesh_vertex_texture_coordinates              
                doc: uv vertex coordinates 
              - id: vertex_color
                type: b1 
                repeat: expr
                repeat-expr: 3              
                doc: rgb color                                
          cff_mesh_face:
            seq:
              - id: body
                type:
                  switch-on: header.num_vertcies
                  cases:
                    "clf": clf_mesh_face_indexes
                    "cff": cff_mesh_face_indexes                
            types:
              clf_mesh_face_indexes:
                seq:  
                  - id: mesh_face_indexes
                    type: b1 
                    repeat: expr
                    repeat-expr: 3              
                    doc: face indexes                
              cff_mesh_face_indexes:
                seq:  
                  - id: mesh_face_indexes
                    type: u2
                    repeat: expr
                    repeat-expr: 3              
                    doc: face indexes                                
      mesh_vertex_texture_coordinates:
        seq:
          - id: texture_coordinate_u
            type: f4  
            doc: u coordinate 
          - id: texture_coordinate_v
            type: f4  
            doc: v coordinate                     
      mesh_animation_frame:    
        seq:
          - id: positions
            type: frame_mesh_position 
            doc: seems to be always 0 
          - id: rotations 
            type: frame_mesh_rotation
            doc: seems to be always 0  
          - id: frame_index
            type: f4  
            doc: index of the frame             
        types:
          frame_mesh_position:   
            seq:          
              - id: position
                type: f4 
                repeat: expr
                repeat-expr: 3   
                doc: xyz coordinates of mesh in frame          
          frame_mesh_rotation: 
            seq:           
              - id: rotation 
                type: f4 
                repeat: expr
                repeat-expr: 3   
                doc: rotation angles in radians of mesh in frame  
  bsp_section: 
    seq: 
      - id: header
        type: bsp_header  
      - id: nodes
        type: bsp_nodes
        if: header.type == 1        
    types:
      bsp_header:
        seq:
          - id: type
            type: u4        
          - id: num_nodes1
            type: u4 
          - id: num_nodes2
            type: u4 
          - id: num_nodes3
            type: u4 
          - id: len_block
            type: u4             
      bsp_nodes: 
        seq:
          - id: nodes
            type: node        
            repeat: expr
            repeat-expr: header.num_nodes1 + header.num_nodes2           
        types:
          node:
            seq:
              - id: index1
                type: s4    
              - id: index2
                type: s4
              - id: indexes
                type: unknown_indexes
                repeat: expr
                repeat-expr: indexes.index2 
            types:
              unknown_indexes:
                seq: 
                  - id: index1
                    type: s4    
                  - id: index2
                    type: s4                
                