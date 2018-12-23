function [Vertices, Triangle, Quads] = make_STL_of_Array(FileName,Data,scaleX,scaleY,scaleZ)  
% make_STL_of_Array  Convert a voxelised object contained within a 3D logical array into an STL surface mesh
%==========================================================================
% AUTHOR        Amir-Hosein Safari
% CONTACT       amirsfr5353@gmail.com
% INSTITUTION   Max-Planck institute for informatic
% DATE          25th Aug 2018
%
% EXAMPLE       make_STL_of_Array(FileName,Data,scaleX,scaleY,scaleZ)  
%       ..or..  [Vertices, Triangle, Quads] = make_STL_of_Array(FileName,Data,scaleX,scaleY,scaleZ)
%
% INPUTS        FileName   - string            - Filename of the STL file.
%
%               Data  - 3D logical array - Voxelised data
%                                     1 => Inside the object
%                                     0 => Outside the object
%                       (FOR PRINTING WITH TWO MATERIALS YOU SHOULD INVERSE
%                       Data (Data = ~Data) AND RUN CODE AGAIN TO HAVE THE SECOND TYPE)
%
%               scaleX     - A number which means the X size of every
%                       voxel in mm
%               scaleY     - A number which means the Y size of every 
%                       voxel in mm
%               scaleZ     - A number which means the Z size of every
%                       voxel in mm
%
%
% OUTPUTS       vertices - Nx3 array   - A list of the x,y,z coordinates of
%                          each vertex in the mesh.
%               
%               Triangle    - Nx3 array   - A list of the vertices used in
%                          each Triangle of the mesh, identified using the row
%                          number in the array vertices.
%
%               Quads    - Nx4 array   - A list of the vertices used in
%                          each Quads of the mesh, identified using the row
%                          number in the array vertices.
%==========================================================================

%======================================================
%   ALLOCATING THE MEMORY FOR MATRIXES
%======================================================

    Vertices = zeros(8*size(Data,1)* size(Data,2)* size(Data,3), 3);    
    Quads = zeros(6*size(Data,1)* size(Data,2)* size(Data,3), 4);
    Triangle = zeros(12*size(Data,1)* size(Data,2)* size(Data,3), 3);
    
    Vertices_Pointer = 1;
    Quads_Pointer = 1;
    Triangle_Pointer = 1;
    GoIn3D = 0;
    ZlayerVertexNum = 0;
    PrevZlayerVertexNum = 0;
    PrevVertexPointer = 0;
%======================================================
%   LOOPING THROUGH EVERY ELEMENTS OF 3D LOGICAL ARRAY(Data)
%======================================================
   
    for i3 = 1 : size(Data,3)
        ZlayerVertexNum = 0;
        for i2 = 1 : size(Data,2)
            for i1 = 1 : size(Data,1)
                % i1 and i2 will change inside a for loop so we use i11 and
                % i22 to save the value before changing and we will use them
                i11 = i1;
                i22 = i2;

                % check that Data(i1,i2,i3) is not surronded by 1s!
                if i1 ~= 1 && i2 ~= 1 && i3 ~= 1 && i1 ~= size(Data,1) && i2 ~= size(Data,2) && i3 ~= size(Data,3) && Data(i1 - 1,i2,i3) == 2 && Data(i1,i2 - 1,i3) == 2 && Data(i1,i2,i3 - 1) == 2 && (Data(i1 + 1,i2,i3) == 1 || Data(i1 + 1,i2,i3) == 2 ) && (Data(i1,i2 + 1,i3) == 1 || Data(i1,i2 + 1,i3) == 2 ) && (Data(i1,i2,i3 + 1) == 1 || Data(i1,i2,i3 + 1) == 2 ) && Data(i1,i2,i3) ~= 0
                    Data(i1,i2,i3) = 2;
                    continue;
                end
                
                
                if Data(i1,i2,i3) == 1
                    %======================================================
                    %   LOOKING FOR THE BIGGEST RECTANGLE (BY ITS AREA) FROM THIS PONT
                    %   IN 2D!
                    %   FOR THIS WE LOOPING THROUGH X AND Y TILL FINDING A ZERO IN THAT DIRECTION!
                    %   WE SAVE THE INDEX OF X AND Y OF THE BIGGEST AREA IN
                    %   maxX, maxY
                    %======================================================

                    maxX = 0;
                    maxY = 0;

                    loop2Len = size(Data,2);
                    for i1 = i1 : size(Data,1)
                        i2 = i22;
                        % IF WE REACH A VOXEL FROM OUTSIDE WE BREAK FROM THE
                        % LOOP
                        if Data(i1,i2,i3) ~= 1
                            i1 = i1 - 1;
                            break;
                        end
                        for i2 = i2 : loop2Len
                            % IF WE REACH A VOXEL FROM OUTSIDE WE BREAK FROM THE
                            % LOOP
                            if Data(i1,i2,i3) ~= 1
                                loop2Len = i2 -1;
                                i2 = i2 - 1;
                                break;
                            else
                                if maxX*maxY < (i1 - i11 + 1) * (i2 - i22 + 1)
                                    maxX = i1 - i11;
                                    maxY = i2 - i22;
                                end
                            end
                        end
                    end

                    % WE CHANGE THE VALUE OF THE BIGGEST AREA TO 2, IT
                    % MEANS THAT WE'LL NOT CONSIDER THIS AREA AGAIN
                    Data(i11:i11 + maxX, i22:i22 + maxY, i3) = 2;
                    
                    % CREATE THE VERTICES AND ADD THEM TO Vertices MATRIX
                    % AND INCREAS THE Vertices_Pointer
                    V1 = [ (i11 - 1) * scaleX , (i22 - 1) * scaleY, (i3 - 1) * scaleZ];
                    V2 = [ (i11 + maxX) * scaleX , (i22 - 1) * scaleY, (i3 - 1) * scaleZ];
                    V3 = [ (i11 - 1) * scaleX , (i22 + maxY) * scaleY, (i3 - 1) * scaleZ];
                    V4 = [ (i11 + maxX) * scaleX , (i22 + maxY) * scaleY, (i3 - 1) * scaleZ];

                    V5 = [ (i11 - 1) * scaleX , (i22 - 1) * scaleY, (i3) * scaleZ];
                    V6 = [ (i11 + maxX) * scaleX , (i22 - 1) * scaleY, (i3) * scaleZ];
                    V7 = [ (i11 - 1) * scaleX , (i22 + maxY) * scaleY, (i3) * scaleZ];
                    V8 = [ (i11 + maxX) * scaleX , (i22 + maxY) * scaleY, (i3) * scaleZ];
                    
                    % CHCK IF IT CAN GO IN DEPTH OR NOT
                    GoIn3D = 0;
                    if PrevVertexPointer > 0
                        for i4 = PrevVertexPointer - PrevZlayerVertexNum : 8 : Vertices_Pointer - 8
                           if size(Vertices) > 0
                              if Vertices(i4,1) == V1(1) && Vertices(i4,2) == V1(2) && Vertices(i4 + 1,1) == V2(1) && Vertices(i4 + 1,2) == V2(2) && Vertices(i4 + 2,1) == V3(1) && Vertices(i4 + 2,2) == V3(2) && Vertices(i4 + 3,1) == V4(1) && Vertices(i4 + 3,2) == V4(2)  
                                  GoIn3D = 1;
                                  Vertices(i4 + 4,3) = Vertices(i4 + 4,3) + scaleZ;
                                  Vertices(i4 + 5,3) = Vertices(i4 + 5,3) + scaleZ;
                                  Vertices(i4 + 6,3) = Vertices(i4 + 6,3) + scaleZ;
                                  Vertices(i4 + 7,3) = Vertices(i4 + 7,3) + scaleZ;
                                  break;
                               end 
                           end
                        end
                    end
                    
                    if GoIn3D == 1
                        continue;
                    end
                    
                    ZlayerVertexNum = ZlayerVertexNum + 8;
                    
                    if Vertices_Pointer == 0
                        Vertices = cat(1,Vertices,V1);
                    end

                    Vertices(Vertices_Pointer,:) = V1;
                    V_pointer1 = Vertices_Pointer;
                    Vertices_Pointer = Vertices_Pointer + 1;

                    Vertices(Vertices_Pointer,:) = V2;
                    V_pointer2 = Vertices_Pointer;
                    Vertices_Pointer = Vertices_Pointer + 1;

                    Vertices(Vertices_Pointer,:) = V3;
                    V_pointer3 = Vertices_Pointer;
                    Vertices_Pointer = Vertices_Pointer + 1;

                    Vertices(Vertices_Pointer,:) = V4;
                    V_pointer4 = Vertices_Pointer;
                    Vertices_Pointer = Vertices_Pointer + 1;

                    Vertices(Vertices_Pointer,:) = V5;
                    V_pointer5 = Vertices_Pointer;
                    Vertices_Pointer = Vertices_Pointer + 1;
    
                    Vertices(Vertices_Pointer,:) = V6;
                    V_pointer6 = Vertices_Pointer;
                    Vertices_Pointer = Vertices_Pointer + 1;
    
                    Vertices(Vertices_Pointer,:) = V7;
                    V_pointer7 = Vertices_Pointer;
                    Vertices_Pointer = Vertices_Pointer + 1;

                    Vertices(Vertices_Pointer,:) = V8;
                    V_pointer8 = Vertices_Pointer;
                    Vertices_Pointer = Vertices_Pointer + 1;
                end
            end
        end
        PrevZlayerVertexNum = ZlayerVertexNum;
        PrevVertexPointer = Vertices_Pointer;
    end
    
    % CUT THE UNUSED ELEMENTS OF Vertices
    Vertices = Vertices(1:Vertices_Pointer - 1,:);
    
    % CREATE THE QUADS AND ADD THEM TO Quads MATRIX
    % AND INCREAS THE Quads_Pointer
    Quads_Pointer = 1;
    for iInVertices = 1 : 8: size(Vertices)
        Quads(Quads_Pointer,:) = [iInVertices, iInVertices + 1, iInVertices + 2, iInVertices + 3];
        Quads_Pointer = Quads_Pointer + 1;
        Quads(Quads_Pointer,:) = [iInVertices + 4, iInVertices + 5, iInVertices + 6, iInVertices + 7];
        Quads_Pointer = Quads_Pointer + 1;
        Quads(Quads_Pointer,:) = [iInVertices + 4, iInVertices + 5, iInVertices, iInVertices + 1];
        Quads_Pointer = Quads_Pointer + 1;
        Quads(Quads_Pointer,:) = [iInVertices + 2, iInVertices + 3, iInVertices + 6, iInVertices + 7];
        Quads_Pointer = Quads_Pointer + 1;
        Quads(Quads_Pointer,:) = [iInVertices + 4, iInVertices, iInVertices + 6, iInVertices + 2];
        Quads_Pointer = Quads_Pointer + 1;
        Quads(Quads_Pointer,:) = [iInVertices + 1, iInVertices + 5, iInVertices + 3, iInVertices + 7];
        Quads_Pointer = Quads_Pointer + 1;
    end
    
    % CUT THE UNUSED ELEMENTS OF Quads
    Quads = Quads(1:Quads_Pointer - 1,:);
    
    % REMOVE REPETITIOUS QUADS
    Quads = unique(Quads,'rows','stable');
    
    % CREATE THE TRIAGNLES FROM QUADS AND ADD THEM TO Triangle MATRIX
    % AND INCREAS THE Triangle_Pointer
    for i = 1 : size(Quads,1)
       Triangle(Triangle_Pointer,:) = [Quads(i,1) Quads(i,2) Quads(i,3)];
       Triangle_Pointer = Triangle_Pointer + 1;
       Triangle(Triangle_Pointer,:) = [Quads(i,4) Quads(i,2) Quads(i,3)];
       Triangle_Pointer = Triangle_Pointer + 1;
    end
    
    % CUT THE UNUSED ELEMENTS OF MATRIXES
    Triangle = Triangle(1:Triangle_Pointer - 1,:);
    
    % WRITE THE STL FILE
stlwrite(FileName, Triangle, Vertices);
