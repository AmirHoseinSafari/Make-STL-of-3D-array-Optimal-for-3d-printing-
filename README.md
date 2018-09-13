# TrainingDataFor3D_Printing   <br />

###  make_STL_of_Array  Convert a voxelised object contained within a 3D logical array into an STL surface mesh
 ==========================================================================
   <br /> AUTHOR:     <br />   Amir-Hosein Safari   <br /><br />
  CONTACT:  <br />       amirsfr5353@gmail.com  <br /><br />
  INSTITUTION:  <br />   Max-Planck institute for informatic  <br /><br />
  DATE:  <br />     25th Aug 2018  <br /><br />
 
  EXAMPLE:      <br />   make_STL_of_Array(FileName,Data,scaleX,scaleY,scaleZ)  
        ..or..   <br /> [Vertices, Triangle, Quads] = make_STL_of_Array(FileName,Data,scaleX,scaleY,scaleZ)
 
  INPUTS        
 
                FileName   - string            - Filename of the STL file.
                
                Data  - 3D logical array - Voxelised data
                                      1 => Inside the object
                                      0 => Outside the object
                        (FOR PRINTING WITH TWO MATERIALS YOU SHOULD INVERSE
                        Data (Data = ~Data) AND RUN CODE AGAIN TO HAVE THE SECOND TYPE)
 
                scaleX     - A number which means the X size of every
                        voxel in mm
                scaleY     - A number which means the Y size of every 
                        voxel in mm
                scaleZ     - A number which means the Z size of every
                        voxel in mm
 
 
  OUTPUTS       
  
                vertices - Nx3 array   - A list of the x,y,z coordinates of
                           each vertex in the mesh.
                           
                Triangle    - Nx3 array   - A list of the vertices used in
                           each Triangle of the mesh, identified using the row
                           number in the array vertices.
 
                Quads    - Nx4 array   - A list of the vertices used in
                           each Quads of the mesh, identified using the row
                           number in the array vertices.
 ==========================================================================

