% ------------------------------------------------------------------------%
% integrateDEMO
% This script demonstrates the use of integrate2d over two different geometries.
% ------------------------------------------------------------------------%
tic
clc
clear
close all
addpath('xmesh')
addpath('xmesh/Mesh2D')

% ------------------------------------------------------------------------%
% EXAMPLE 1: PLATE AND HOLE
% This problem consists of a 8x8 plate centered at the origin with a unit
% circle hole on the middle. Internal heat generation is defined based off
% of a manufactured solution, and all boundary conditions have homogeneous
% diriclet boundary conditions.
% ------------------------------------------------------------------------%

% % filename = './plateandhole/plateandholeSmoothedRef0';
% filename = './my_guitar';
% 
% % Define the function for the manufactured solution.
% phi = @(x,y) ones(size(x));
% 
% % Generating the mesh.
% options.smoothWeights=false;
% options.thresh=1.1;
% xmesh2d(filename,options);
% ngq=4;
% for i=1:7
% [nQuads,value]=integrate2d(filename,phi,i);
% QuadPoints(i)=nQuads;
% intVal(i)=value;
% end
% refineMeshRefLvl(filename,1);
% Calling integrate2d
% for i=1:4 
%     [nQuads,value]=integrate2d(filename,phi,1);
%     QuadPoints(i)=nQuads;
%     intVal(i)=value;
%     refineMeshRefLvl(filename,i+1);
% end

filename='circle';
phi=@(x,y) ones(size(x));

for i=1:4 
    [nQuads,value]=integrate2d(filename,phi,1);
    QuadPoints(i)=nQuads;
    intVal(i)=value;
    refineMeshRefLvl(filename,i+1);
end

% Visualizing results
% showResults(filename,1/10)