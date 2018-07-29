function M = makeFslXfmMatrix(T,R,S,filename)
%MAKEFSLXFMMATRIX Make FSL-compatible transformation matrix.
%   M = MAKEFSLXFMMATRIX(T,R,S,FILENAME) outputs a 4x4 transformation
%   matrix performing the translations in T, the rotations in R and the
%   scalings in S and writes this matrix to the file specified by the 
%   string FILENAME. This file is compatible with FSL's flirt and thus can
%   be directly used without further modification.
%   
%   This function is actually the inverse function of FSL's avscale in that
%   avscale reads a transformation matrix file and lists the corresponding
%   translation, rotation and so on. 
%
%   MAKEFSLXFMMATRIX can be especially useful if you would like to run
%   simulations.   
%
%   Please note that, just as in avscale, T is in millimeters, R is in
%   radians and S is unitless. 
%
%   Usage example:
%   ==============
%   T = [1.433440 19.715600 0.786690]; % in mm.
%   R = [0.102735 -0.155470 0.121564]; % in rad.
%   S = [1 1 1]; % unitless
%   filename = 'thisIsWhatIWant.mat'; % :))
%   
%   M = makeFslXfmMatrix(T,R,S,filename);
% 
%   Now you can use avscale to see if things are working correctly.
%
%   [status,result] = system(['avscale --allparams thisIsWhatIWant.mat']);
%   disp(result)
% 
%   Best.

% Check inputs
if ~isnumeric(T) || ~isnumeric(R) || ~isnumeric(S) 
    error('T, R and S have to be numeric...');
end

if ~ischar(filename)
    error('FILENAME has to be a string...');
end    

% Get rotation angles about each axis.
thetaX = R(1);
thetaY = R(2);
thetaZ = R(3);

% Compute the rotation matrices.
Rx = [1 0 0; 0 cos(thetaX) sin(thetaX);0 -sin(thetaX) cos(thetaX)];
Ry = [cos(thetaY) 0 -sin(thetaY);0 1 0;sin(thetaY) 0 cos(thetaY)];
Rz = [cos(thetaZ) sin(thetaZ) 0;-sin(thetaZ) cos(thetaZ) 0;0 0 1];

% Concatenate rotations.
R_3x3 = Rx*Ry*Rz;

% Put scalings on the diagonal.
S_3x3 = diag(S); 

% Make the 4x4 transformation matrix.
M = [R_3x3*S_3x3 T(:); 0 0 0 1];

% Try to open the file
fid = fopen(filename,'w');

% Check if it worked
if fid == -1
    error(['Could not open for writing: ' filename]);
end

for k = 1:4
    fprintf(fid,[num2str(M(k,:)) '\n']);
end

fclose(fid);