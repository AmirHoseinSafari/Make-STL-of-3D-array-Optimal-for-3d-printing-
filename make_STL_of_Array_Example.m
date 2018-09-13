% LOADING DATA
arr = load('example.mat');
Data = arr.a; 

scaleX = 0.084;
scaleY = 0.084;
scaleZ = 0.03;

[Vertices, Triangle, Quads] = make_STL_of_Array('example.stl',Data,scaleX,scaleY,scaleZ);  