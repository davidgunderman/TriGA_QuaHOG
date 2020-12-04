function [xq,yq,wq] = integrate2dPts(filename,ordergauss)
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

% Rational or Bernstein basis functions
rational = true;

% Read in the data from the .neu file
[NODE, IEN, BFLAG, CFLAG] = gambitFileIn(filename);
BFLAG = BFLAG(BFLAG(:,1)~=0,:);

% Setting Glabal Mesh Information.
nel = size(IEN,2);
nen = 10;
nNodes = length(NODE);

% Load the data for the quadrature rule.
% ordergauss=3;
[qPts, W] = gaussTPts(ordergauss);
nQuads=nel*ordergauss^2;
nQuad   = length(W);
% Generating Lookup Tables for the Bernstein Basis at the quad points.
[N,dN_du] = evaluateBasis(qPts);
xq=zeros(0,1); yq=zeros(0,1); wq=zeros(0,1);
% Loop through the elements
value=0;
for ee =1:nel
    % Display progress in 1% completion increments
%     dispFreq = round(nel/100);
%     if mod(ee,dispFreq) == 0
%         clc
%         fprintf('fea2d is %3.0f percent complete with the assembly process\n',ee/nel*100)
%     end
    
    % Define the local node.
    node = NODE(IEN(:,ee),:);
    
    % Conductivity and heat generation contributions to K and F, respectivly
    % Loop though the quadtrature points.
    for qq = 1:nQuad
        % Call the finite element subroutine to evaluate the basis functions
        % and their derivatives at the current quad point.
        [~, ~,x, J_det]  = tri10fast(node,N(:,qq),dN_du(:,:,qq));
        J_det = J_det;
        
%         scatter(x(1),x(2),36,'.');
%         hold on
        
        % Add the contribution of the current quad point
        xq=[xq; x(1)]; yq=[yq; x(2)]; wq=[wq; W(qq)*J_det];
    end
end

% disp('Done')
return
