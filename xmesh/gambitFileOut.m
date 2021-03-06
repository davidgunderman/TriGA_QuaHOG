function [] = gambitFileOut(filename,NODE,IEN,BFLAG,CFLAG,varargin)

if nargin == 5
    temp = [];
elseif nargin == 6
    temp = varargin{1};
end
NUMNP = length(NODE);
NELEM = size(IEN,2);
MAXNODE  = size(IEN,1);
NGRPS = 1;

if any(BFLAG)
    NBSETS = max(BFLAG(:,3));
else
    NBSETS = 0;
end
NDFCD = 2;
NDFVL = 2;

% Getting NODE and IEN into the correct format for the neutral file.
NODE(:,2:4) = NODE;
NODE(:,1) = 1:NUMNP;

% Loop over columns in IEN and find the number of non-zeros in each column.
% This is for mixed meshes, where there can be quads or tris.

elemType = zeros(1,NELEM);
nnz = zeros(1,NELEM);
for ee = 1:NELEM
    nnz(ee) = sum(IEN(:,ee)>0);
    
    if nnz(ee) == 3 || nnz(ee) == 6 || nnz(ee) == 10
        elemType(ee) = 3;
    elseif nnz(ee) == 4 || nnz(ee) == 9 || nnz(ee) == 16
        elemType(ee) = 2;
    end
    
end

IEN(3+(1:MAXNODE),:) = IEN;
IEN(1,:) = 1:NELEM;
IEN(2,:) = elemType;
IEN(2,CFLAG) = -IEN(2,CFLAG); % Flag curved elements by a negative sign.
IEN(3,:) = nnz; % Setting how many nodes define the eeth element.

% Opening the file.
filename = [filename,'.neu'];
fileID = fopen(filename,'w');

% Printing out the file header.
fprintf(fileID,'%s \n','CONTROL INFO 1.3.0');
fprintf(fileID,'%s \n','** GAMBIT NEUTRAL FILE');
fprintf(fileID,'%s \n','UDEMe meshfile, generated by function:');
fprintf(fileID,'%s \n','gambitFileOut(/TriGA)');
fprintf(fileID,'%s \n','WinUSEMe beta version August 2002');

% Printing out global mesh information. 
fprintf(fileID,'%11s %10s %10s %10s %10s %10s \n','NUMNP','NELEM','NGRPS','NBSETS','NDFCD','NDFVL');
fprintf(fileID,'%11u %10u %10u %10u %10u %10u \n',NUMNP,NELEM,NGRPS,NBSETS,NDFCD,NDFVL);
fprintf(fileID,'%s \n','ENDOFSECTION');

% Printing out the nodal Coordinates
fprintf(fileID,'%s \n','   NODAL COORDINATES 1.3.0');
fprintf(fileID,'%15.10f %20.15f %20.15f %20.15f \n',NODE');
fprintf(fileID,'%s \n','ENDOFSECTION');

% Printing out the connectivity information.
fprintf(fileID,'%s \n','    ELEMENTS/CELLS 1.3.0');
for ee = 1:NELEM
    fprintf(fileID,'%6u %6i %6u',IEN(1:3,ee));
    for nn = 1:nnz(ee)
        fprintf(fileID,'%6u',IEN(nn+3,ee));
    end
    fprintf(fileID,'\n');  
end
fprintf(fileID,'%s \n','ENDOFSECTION');

% Printing out the matrial group information. Right now this is trivial as
% TriGA does not support multi-material meshing. This functionality will be
% added at some point in the future.
fprintf(fileID,'%s \n','    ELEMENT GROUP 1.3.0');
fprintf(fileID,'%s %11.0u %s %11.0u %s %11.0u %s %11.0f \n','GROUP:',1,' ELEMENTS', NELEM, ' MATERIAL:',4,' NFLAGS:',0);
fprintf(fileID, '%s %7.4f \n','                epsilon:',1);
fprintf(fileID, '%8.0f \n' , 0);
fprintf(fileID, '%8.0u %8.0u %8.0u %8.0u %8.0u %8.0u %8.0u %8.0u %8.0u %8.0u \n',1:NELEM);

if mod(NELEM,10)
    fprintf(fileID, '\n');
end

fprintf(fileID,'%s \n','ENDOFSECTION');

if any(BFLAG)
    ITYPE = 1;
    for bb = 1:max(BFLAG(:,3))
        GROUP = BFLAG(BFLAG(:,3)==bb,:);
        NENTRY = size(BFLAG(BFLAG(:,3)==bb),1);
        NVALUES = 1;
        IBCODE = GROUP(1,4);
        if IBCODE == 6
            BCTYPE = 'Dirichlet';
        elseif IBCODE == 7
            BCTYPE = 'Neuman';
        else
            disp('Error: Invalid boundary condition type specified')
        end
        bctemp = [BFLAG(BFLAG(:,3)==bb,1) ones(NENTRY,1)*3 BFLAG(BFLAG(:,3)==bb,2) zeros(NENTRY,1)]';
        
        fprintf(fileID,'%s \n',' BOUNDARY CONDITIONS 1.3.0');
        fprintf(fileID,'%20s %4u %4u %4u  %4u \n',BCTYPE,ITYPE, NENTRY, NVALUES,IBCODE);
        fprintf(fileID,'%4u %4u %4u %4u \n',bctemp);
        fprintf(fileID,'%s \n','ENDOFSECTION');
    end
end

if any(temp)
    temp = [(1:length(temp))' full(temp)]';
    fprintf(fileID,'%20s \n','TIMESTEPDATA  1.3.0');
    fprintf(fileID,'%s %5u %s %5u %s %5u \n','TIMESTEP: ',1,' TIME:   ',0,' INCRMNT:   ',0);
    fprintf(fileID,'%20s %5u % 5u %5u \n','TEMPERATURE',0,0,1);
    fprintf(fileID,'%10u %23.15f \n',temp);
    fprintf(fileID,'%s \n','ENDOFTIMESTEP');
end

fclose(fileID);

return