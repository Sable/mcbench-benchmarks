function NrbsSrf2IGES(NrbSurf, OutName, BaseDir)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function will take a NURBS surface and convert it to an IGES file
% using Entity type 128 (Rational B-Spline Surface Entity).  Some things
% that should be noted are:
%
% 1 - This is a very speciallized IGES converter and ONLY outputs NURBS
%     surfaces.
% 2 - I make no attempt to work with different versions of IGES.
% 3 - To make the output more readable and easy I wasted a lot of space
% 4 - All the spacing is done manually so if any of the G section words
%     are changed the spacing will need to be fixed.
% 5 - Changing the output that of Rational B-Spline Curves should be
%     relatively easy.  Other Entities will require significantly more work.
%
% Created: 8 - 2006  Michael Fassbind
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear P;

%% to do examples need to comment first and last line of this script

% % Example 1  The basic test surface from the free NURBS toolbox
% BaseDir = '.\';
% load([BaseDir 'TestSRF']);
% OutName = 'NurbSrf.igs';
% NrbSurf = srf;
% nrbplot(NrbSurf, [20 20]);


% % Example 2  The basic Ruled surface from the free NURBS toolbox
% BaseDir = '.\';
% load([BaseDir 'TSTRuled']);
% OutName = 'TSTRuld.igs';
% NrbSurf = srf;
% nrbplot(NrbSurf, [20 20]);

nam = 'NrbSurf_Output';
       
%**************************information*********************************
SLine = 'Matlab Nurbs converted -> IGES file. Written by Mike F. ';
%GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
G{1,1} = ',';      % Parameter Deliminator Character
G{2,1} = ';';      % Record Delimiter Character
G{3,1} = nam;      % Product ID from Sender
G{4,1} = OutName;   % File Name
G{5,1} = 'MatNrb'; % System ID
G{6,1} = 'Matlab -> IGES v3.0 Aug 2006';            % Pre-processor Version
G{7,1} = 16;       % Number of Bits for Integers
G{8,1} = 6;        % Single Precision Magnitude
G{9,1} = 15;       % Single Precision Significance
G{10,1}= 13;       % Double Precision Magnitude
G{11,1}= 15;       % Double Precision Significance
G{12,1}= nam;      % Product ID for Receiver
G{13,1}= 1.00000;  % Model Space Scale
G{14,1}= 3;        % Unit Flag (1 = inches, 3 = look to index 15 name)
G{15,1}= 'MM';     % Units  (Inches = "INCH")
G{16,1}= 8;        % Maximum Number of Line Weights
G{17,1}= 0.0160000; % Size of Maximum Line Width
G{18,1}= 'Today';   % Date and Time Stamp  ** fix me **
G{19,1}= 0.000100000; % Minimum User-intended Resolution
G{20,1}= 300.000;   % Approximate Maximum Coordinate
G{21,1}= 'Michael Fassbind: mikefazz@gmail.com';     % Name of Author
G{22,1}= 'Puget Sound VA RR&D';     % Author's Organization
G{23,1}= 11; % - USPRO/IPO-100 (IGES 5.2) [USPRO93]';  % IGES Version Number  ** prob not right **
G{24,1}= 3; % - ANSI';            % Drafting Standard Code
G{25,1}= 'Today of course'; % Model Creation/Change Date

%DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDd
sz_i = size(NrbSurf.knots{1,1});
sz_j = size(NrbSurf.knots{1,2});
sz_w = size(NrbSurf.coefs);

N_pnts = (sz_w(1,2)*sz_w(1,3));
NumLines = 1 + sz_i(1,2) + sz_j(1,2) + N_pnts + N_pnts + 1;
D{1,1} = 128;       % Entity Type.  128 is Rational B-Spline surface
D{2,1} = 1;         % Data Start line (only one entity so = 1)
D{3,1} = 0;         % Structure
D{4,1} = 1;         % Line Font Pattern (1= Solid)
D{5,1} = 0;         % Level
D{6,1} = 0;         % View
D{7,1} = 0;         % Transformation Matrix
D{8,1} = 0;         % Label Display
D{9,1} = 0;         % Blank Status (0 = Visible)
D{10,1}= 0;         % Subord. Entity Switch (0 = Independant)
D{11,1}= 0;         % Entity Use Flag (0 = Geometry)
D{12,1}= 1;         % Hierarchy ( 1 = Global defer)
D{13,1}= 0;         % Line Weight Number
D{14,1}= NumLines;  % Data end line
D{15,1}= 0;         % Form Number (9 = General Quadratic Surface), 0 = none of above (1-9) options

%PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
P{1,1} = 128;                   % Entity Type.  128 = Rational spline surface
P{2,1} = NrbSurf.number(1,1)-1; % Number of points in u direction (doesn't work without -1)
P{3,1} = NrbSurf.number(1,2)-1; % Number of points in v direction
P{4,1} = NrbSurf.order(1,1)-1;  % Degree_u  (degree = order -1)
P{5,1} = NrbSurf.order(1,2)-1;  % Degree_v
P{6,1} = 0;                     % PROP1 Closed_u (0 = Not Closed)
P{7,1} = 0;                     % PROP2 Closed_v (0 = Not Closed) ****change to 1 for FEA Limb****
P{8,1} = 0;                     % PROP3 (1 = Polynomial i.e. all weights equal), 0 = rational
P{9,1} = 0;                     % PROP4 1st Direction periodicity (0 = Non-periodic)
P{10,1}= 0;                     % PROP5 2nd Direction periodicity (0 = Non-periodic)

%-----------------Knots----------------
% It looks like we need to have integers and not floating point numbers for
% the knot values

% must add a superfolous 0 and 1 to front and back of each knot sequence
%----U----
% P{i+11,1} = NrbSurf.knots{1,2}(1,1);
for i = 1:sz_i(1,2)
    tmp1{i,1} = NrbSurf.knots{1,1}(1,i);
end
P = [P;tmp1];
% P = [P; NrbSurf.knots{1,1}(1,i)];

%----V----
for j = 1:sz_j(1,2)
    tmp2{j,1} = NrbSurf.knots{1,2}(1,j);
end
P = [P;tmp2];
% P = [P; NrbSurf.knots{1,2}(1,j)];

%----------------Weights---------------
k=1;
for v=1:sz_w(1,3)
    for u=1:sz_w(1,2)
        tmp3{k,1} = NrbSurf.coefs(4,u,v);  %**This should be fixed if ever want non-uniform splines**
        k=k+1;
    end
end
P = [P; tmp3];
clear tmp1 tmp2 tmp3
%************************Data export to file*******************************
% All lines must have exactly 80 characters across
filnam = [BaseDir OutName];
fid=fopen(filnam, 'w');

%------S Line information (The initial line to get things started)---------
% fprintf(fid,
% '*********|*********|*********|*********|*********|*********|*********|*********|\n');  80 Characters for measurment
Sln =1;
fprintf(fid, '%s                S%07.f\n', SLine, Sln);

%---------------G Line information  (Header infomation)--------------------
Gln=1;
for i = 1:25  % Number of characters after each one
    tmp = str2mat(G{i,1});
    len=size(tmp);
    G{i,2} = len(1,2);
    G{i,3} = ischar(G{i,1});  % 1 = yes, 0 = no
end 
fprintf(fid, '%1.0fH%s,', G{1,2}, G{1,1});              % 1            
fprintf(fid, '%1.0fH%s,', G{2,2}, G{2,1});   
fprintf(fid, '%2.0fH%s,', G{3,2}, G{3,1});  
fprintf(fid, '%2.0fH%s,                               G%07.f\n', G{4,2}, G{4,1}, Gln);  Gln=Gln+1;
fprintf(fid, '%1.0fH%s,', G{5,2}, G{5,1});              % 5
fprintf(fid, '%2.0fH%s,', G{6,2}, G{6,1});
fprintf(fid, '%2.0f,',    G{7,1});
fprintf(fid, '%2.0f,',    G{8,1}); 
fprintf(fid, '%2.0f,',    G{9,1});
fprintf(fid, '%2.0f,',    G{10,1});                    % 10
fprintf(fid, '%2.0f,                G%07.f\n', G{11,1}, Gln);  Gln=Gln+1;
fprintf(fid, '%2.0fH%s,', G{12,2}, G{12,1});
fprintf(fid, '%5.2f,',    G{13,1});   
fprintf(fid, '%2.0f,',    G{14,1});     
fprintf(fid, '%2.0fH%s,', G{15,2}, G{15,1});            % 15
fprintf(fid, '%2.0f,',    G{16,1});      
fprintf(fid, '%7.4f,',    G{17,1});      
fprintf(fid, '%2.0fH%s,', G{18,2}, G{18,1});
fprintf(fid, '%5.5f,           G%07.f\n', G{19,1},  Gln); Gln=Gln+1;
fprintf(fid, '%2.0f,',    G{20,1});                     % 20
fprintf(fid, '%2.0fH%s,                            G%07.f\n', G{21,2}, G{21,1}, Gln); Gln=Gln+1;
fprintf(fid, '%2.0fH%s,                                                 G%07.f\n', G{22,2}, G{22,1}, Gln); Gln=Gln+1;
fprintf(fid, '%2.0f,',    G{23,1});
fprintf(fid, '%2.0f,',    G{24,1});
fprintf(fid, '%2.0fH%s;                                               G%07.f\n', G{25,2}, G{25,1}, Gln);

%------------------D Line information (Data information)-------------------
Dln=1;
% Doing this with only one entity... 
fprintf(fid, '%8.0f%8.0f%8.0f%8.0f%8.0f%8.0f%8.0f               1D%07.f\n',...
             D{1,1}, D{2,1}, D{3,1}, D{4,1}, D{5,1}, D{6,1}, D{7,1}, Dln);Dln=Dln+1;
fprintf(fid, '%8.0f%8.0f%8.0f%8.0f%8.0f                                D%07.f\n',...
             D{1,1},D{12,1},D{13,1},D{14,1},D{15,1}, Dln);

%-----------------P Line information  (All the data)-----------------------
Pln=1;
fprintf(fid, '%3.0f,  %4.0f,  %4.0f,  %1.0f,  %1.0f,  ',...
             P{1,1},   P{2,1},  P{3,1},  P{4,1},  P{5,1});  
fprintf(fid, '%1.0f,  %1.0f,  %1.0f,  %1.0f,  %1.0f,                         1P%07.f\n',...
             P{6,1},   P{7,1},  P{8,1},  P{9,1},  P{10,1}, Pln);  Pln=Pln+1;
len = size(P);         
%-----------------Knots and Weights
st=1;
for i =11:len(1,1)
    fprintf(fid, '%7.6f,                                                              1P%07.f\n', P{i,1}, Pln); Pln=Pln+1;  
end

%------------------Coefficients------------------------------ 
for U = 1:sz_w(1,3)
    for V = 1:sz_w(1,2)
        fprintf(fid, '%010.6f, %010.6f, %010.6f,                                    ', ...
            NrbSurf.coefs(1,V,U), NrbSurf.coefs(2,V,U), NrbSurf.coefs(3,V,U));
        fprintf(fid, '1P%07.f\n', Pln);
        Pln = Pln+1;
    end
end
fprintf(fid, '0., 1., 0., 1.;                                                        1P%07.f\n', Pln);% U(0), U(1),V(0),V(1)

%-----------------T Line information  (Termination)------------------------
fprintf(fid, 'S%07.fG%07.fD%07.fP%07.f                                        T0000001',...
             Sln, Gln, Dln, Pln);
fclose(fid);

'Finished Export to IGES'
end