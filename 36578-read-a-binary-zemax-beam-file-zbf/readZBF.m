function [Ex Ey x y dx dy nx ny]=readZBF(filename)
%% READZBF reads a binary Zemax ZBF file (version 1).
%    readZBF reads a binary Zemax ZBF pop file per the version 2
%    description in the ZEMAX manual.
%
%   Inputs:
%       filename - filename fof the zbf file including extension.
%       
%   Outputs:
%       Ex  - Matrix of complex E-field amplitudes.
%       Ey  - Matrix of complex E-field amplitude. Returns 0 if unpolarised
%       x,y - x and y coordinatyes of pixel centres in ZEMAX lens units
%       dx  - The x direction spacing between points.
%       dy  - The y direction spacing between points.
%       nx  - The number of x samples.
%       ny  - The number of x samples.
% 
% Copyright (c) 2012, Chris Betters
% Copyright (c) 2011, Sean Bryan
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
% 
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%       
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.

% Read the contents back into an array
fid = fopen(filename);

%% read header data
% 1 integer: The format version number, currently 1.
version=fread(fid, 1, 'uint');

% 1 integer: The number of x samples (nx).
nx=fread(fid, 1, 'uint');

% 1 integer: The number of y samples (ny).
ny=fread(fid, 1, 'uint');

% 1 integer: The "is polarized" flag; 0 for unpolarized, 1 for polarized. 
ispol=fread(fid, 1, 'uint');

% 1 integer: Units, 0 for mm, 1 for cm, 2 for in, 3 for meters.
units=fread(fid, 1, 'uint');

% 4 integers: Currently unused, may be any value.
fread(fid, 4, 'uint');

% 1 double: The x direction spacing between points.
dx=fread(fid, 1, 'double');

% 1 double: The y direction spacing between points.
dy=fread(fid, 1, 'double');

% 1 double: The z position relative to the pilot beam waist, x direction.
zposition_x=fread(fid, 1, 'double');

% 1 double: The Rayleigh distance for the pilot beam, x direction.
rayleigh_x=fread(fid, 1, 'double');

% 1 double: The waist in lens units of the pilot beam, x direction.
waist_x=fread(fid, 1, 'double');

% 1 double: The z position relative to the pilot beam waist, y direction.
zposition_y=fread(fid, 1, 'double');

% 1 double: The Rayleigh distance for the pilot beam, y direction.
rayleigh_y=fread(fid, 1, 'double');

% 1 double: The waist in lens units of the pilot beam, y direction.
waist_y=fread(fid, 1, 'double');

% 1 double: The wavelength in lens units of the beam in the current medium.
lambda=fread(fid, 1, 'double');

% 1 double: The index of refraction in the current medium.
index=fread(fid, 1, 'double');

% 1 double: The receiver efficiency. Zero if fiber coupling is not computed.
receiver_ef=fread(fid, 1, 'double');

% 1 double: The system efficiency. Zero if fiber coupling is not computed.
system_ef=fread(fid, 1, 'double');

% 8 doubles: Currently unused, may be any value.
fread(fid, 8, 'double');

%% read beam data
rawx=fread(fid, 2*nx*ny,'double');
if ispol
    rawy=fread(fid, 2*nx*ny,'double');
else
    rawy=0;
end

fclose(fid);


%% format beam data
% from READ_ZBF by Sean Bryan on Matlab centeral File ID: #32099

% convert rawx and rawy arrays into complex Matlab matrices
x = zeros(nx,ny);
y = zeros(nx,ny);
Ex_real = zeros(nx,ny);
Ex_imag = zeros(nx,ny);
if ispol
    Ey_real = zeros(nx,ny);
    Ey_imag = zeros(nx,ny);
end

xc = 1 + nx/2;
yc = 1 + ny/2;

k = 1;
for j=1:ny
    for i=1:nx
        % populate x and y matrices
        x(i,j) = (i - xc)*dx;
        y(i,j) = (j - yc)*dy;
        
        % populate E-field matrices
        Ex_real(i,j) = rawx(k);
        Ex_imag(i,j) = rawx(k+1);
        if ispol
            Ey_real(i,j) = rawy(k);
            Ey_imag(i,j) = rawy(k+1);
        end
        
        % increment counter
        k = k + 2;
    end
end

% shift x and y arrays by half a pixel to make the pcolor plots come out right
x = x - dx/2;
y = y - dy/2;

% combine the real and imaginary parts at the end for speed
Ex = Ex_real + 1i.*Ex_imag;
if ispol
    Ey = Ey_real + 1i.*Ey_imag;
else
    Ey = 0;
end
