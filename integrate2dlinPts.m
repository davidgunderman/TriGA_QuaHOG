function [xq,yq,wq] = integrate2dlinPts(pts,tri,ordergauss)
% -----------------------------------------------------------------------------%
% integrate2d integrates a function integrand(x,y) over a mesh

% Input:
% filename: The filename of a gambit neutral file that contains the mesh
% information and boundary condition flags for the problem geometry.

% integrand: A matlab function handle giving the internal heat generation as
% a function of cartesian coordinates (x,y). 


% Output: 
% nQuads: integer signifying the number of quadrature points used
% value: double containing the calculated value of the integral

% -----------------------------------------------------------------------------%

xq=zeros(0,1); yq=zeros(0,1); wq=zeros(0,1);
I=0;
for i=1:size(tri,1)
    [xx,yy,ww]= gaussTbdsPts(ordergauss,pts(tri(i,:),:));
    xq=[xq; xx]; yq=[yq; yy]; wq=[wq;ww];
end
% nQuads=size(tri,1)*ordergauss^2;

% Loop through the elements
% value=I;

end
