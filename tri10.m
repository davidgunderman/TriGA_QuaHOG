function [R, dR_dx, J_det, dR_dxi, J] = tri10(xi,eta,node)
%----------------------------------------tri10---------------------------------%
% TRI10 is the finite element subroutine for a 10 node triangular element. It
% takes as inputs the control net of the triangle in physical space, B and the
% point in isoparametric space at which to evaluate the basis functions,
% [xi,eta]. It outputs the value of the basis function, R, its derivative with
% respect to physical coordinates, dR_dx, and the Jacobian determinate of the
% mapping from isoparametric space to physical space, J_det.


%------------------------------------------------------------------------------%
% Element parameters.
n = 3;
nen = 10;
% Find the barycentric coordinates of xi and eta
vert = [0,0;1,0;0,1];
x1 = vert(1,1);
x2 = vert(2,1);
x3 = vert(3,1);
y1 = vert(1,2);
y2 = vert(2,2);
y3 = vert(3,2);

detA =  det([x1,x2,x3; y1,y2,y3;1, 1, 1]);
detA1 = det([xi,x2,x3;eta,y2,y3;1, 1, 1]);
detA2 = det([x1,xi,x3;y1,eta,y3;1, 1, 1]);
detA3 = det([x1,x2,xi;y1,y2,eta;1, 1, 1]);

u = detA1/detA;
v = detA2/detA;
w = detA3/detA;

% Initializing variables
dx_dxi = zeros(2);
R = zeros(nen,1);
dR_dxi = zeros(nen,2);
dR_du = zeros(nen,3);
du_dxi = [-1 -1; 1 0;0 1];

% Index and tuples. The index is the location in the control net (row,col) of
% the ith control point. Tuples is the index in barycentric coordinates of the
% ith control point.
idx = [1 1; 4 1; 1 4; 2 1; 3 1; 3 2; 2 3; 1 3; 1 2; 2 2];
tuples  = [ 3 0 0;...
    0 3 0;...
    0 0 3;...
    2 1 0;...
    1 2 0;...
    0 2 1;...
    0 1 2;...
    1 0 2;...
    2 0 1;...
    1 1 1];

% Loop through the control points.
for nn = 1:nen
    
    i = tuples(nn,1);
    j = tuples(nn,2);
    k = tuples(nn,3);
    
    % From page 141 of Bezier and B-splines. Calculate the ith basis function
    % its derivative with respect to barycentric coordinates.
    R(nn) = factorial(n)/...
        (factorial(i)*factorial(j)*factorial(k))*u^i*v^j*w^k;
    
    if i-1 < 0
        dR_du(nn,1) =0;
    else
        dR_du(nn,1) = n * factorial(n-1)/...
            (factorial(i-1)*factorial(j)*factorial(k))*u^(i-1)*v^j*w^k;
    end
    
    if j-1 < 0
        dR_du(nn,2) = 0;
    else
        dR_du(nn,2) = n * factorial(n-1)/...
            (factorial(i)*factorial(j-1)*factorial(k))*u^(i)*v^(j-1)*w^k;
    end
    
    if k-1 < 0;
        dR_du(nn,3) = 0;
    else
        dR_du(nn,3) = n * factorial(n-1)/...
            (factorial(i)*factorial(j)*factorial(k-1))*u^i*v^j*w^(k-1);
    end
    
end

% Chain rule to find the derivative with respect to cartesian isoparametric
% coordinates.
dR_dxi = dR_du*du_dxi;

% Calculating the mapping from isoparametric space to physical space.

g = [0 0;0 0];
gp = [0 0; 0 0 ];
h = [0 0  ;0 0];
hp = [0 0; 0 0 ];

for row  = 1:2
    for col = 1:2
        for nn = 1:nen
            g(row,col) = g(row,col) + R(nn)*node(nn,row)*node(nn,3);
            h(row,col) = h(row,col) + R(nn)*node(nn,3);
            gp(row,col) = gp(row,col) + dR_dxi(nn,col)*node(nn,row)*node(nn,3);
            hp(row,col) = hp(row,col) + dR_dxi(nn,col)*node(nn,3);
        end
    end
    
    
end

dx_dxi = (gp.*h-g.*hp)./(h.^2);

% Calculating the shape function derivatives and the Jacobian determinate.
dR_dx =dR_dxi*inv(dx_dxi);
J_det = det(dx_dxi);
J = dx_dxi;
return

