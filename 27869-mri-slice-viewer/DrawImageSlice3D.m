function [ fighandle, surfh ] = DrawImageSlice3D( dicom_filename,  fighandle,  transparency )
%============================
% [ fighandle, surfh ] = DrawImageSlice3D( dicom_filename,  fighandle,  transparency )
% This is a function for drawing slices in 3D space based on the dicom header
% information.
% Input:
%   dicom_filename = full path to a DICOM image file. Default = '*' 
%                   empty string ('') or and string with a wildcard (*) will prompt the file browser
%   figh = figure handle
%   transparency = alpha for the image slice. 
%                   Use values < 1 to get partial transparency when
%                   plotting multiple slices in one figure
% Example:
% First pick and image (assuming the DICOM file extension is IMA) and draw the slice semi-transparent
%  [ fighandle, surfh(1) ] = DrawImageSlice3D( '*.IMA',  [],  0.5 );
% Next, call up a second image and draw a slice in the same figure
%  [ fighandle, surfh(2) ] = DrawImageSlice3D( 'mysecond_dicomim.IMA', fighandle,  0.5 );
% 
% The axes are rotated at the end of this function. 
% A simple edit setting 'show_rotate' to 0 will suppress this.
%
% NOTE: In the DICOM file there are several series UID and reference frame UID to
% ensure that the slices are from the same study and position. 
% No check for this is included in this function. One could compose figures
% with slices of different subjects if so inclined.
% The DICOM fields used should be universal, the reference frame should be
% patient orientation dependend X = RL, Y =AP, Z = FH
% 
%======================================================================

%======================================================================
% Ronald Ouwerkerk , NIH/NIDDK, June 2010
% Tested on Mac OS 10.5 with Martlab  2008b on Siemens DICOM images (VB15 export to offline) 
% Images were all head first supine. Let me know if other orientations
% create problems.
%======================================================================

%% Define constants
topl = 1;
topr = 2;
botl = 3;
botr = 4;

X = 1;
Y = 2;
Z = 3;

%% Set defaults for input arguments
if nargin <1
    dicom_filename = '*';
end

if nargin <2
    fighandle = [];
end

if ~ishandle( fighandle )
    msgstr = sprintf('Warning in %s: Second argument is not a valid figure handle. Creating a new one', mfilename);
    disp( msgstr)
     fighandle = [];
end

if nargin <3
   transparency = 1;
end

if isempty( dicom_filename )
    dicom_filename = '*';
end

%save the current path
orig_path = pwd;
 
% Call the filebrowswer UI if the dicom filename contains a wildcard
if ~isempty( findstr( dicom_filename, '*') )
    [ filename, fpath ] = uigetfile( dicom_filename , 'Select DICOM file');
    cd( fpath );
    dicom_filename =filename;
end


%% Read DICOM header and image data
dinfo= dicominfo( dicom_filename );
imdata = dicomread(  dicom_filename );
cd( orig_path )

%% Calculate slice corner positions from the DICOM header info
% Get the top left corner position in XYZ coordinates
pos    = dinfo.ImagePositionPatient;
 
nc = double(dinfo.Columns);
nr = double(dinfo.Rows);

% Get the row and column direction vercors in XYZ coordinates
row_dircos(X) = dinfo.ImageOrientationPatient(1);
row_dircos(Y) = dinfo.ImageOrientationPatient(2);
row_dircos(Z) = dinfo.ImageOrientationPatient(3);
col_dircos(X) = dinfo.ImageOrientationPatient(4);
col_dircos(Y) = dinfo.ImageOrientationPatient(5);
col_dircos(Z) = dinfo.ImageOrientationPatient(6);

% % Check normality and orthogonality of the row and col vectors
% Crownorm = dot(row_dircos, row_dircos);
% Ccolnorm = dot(col_dircos, col_dircos);
% Cdotprod = dot(row_dircos, col_dircos);
% 
% if abs(Cdotprod) > 1e-5
%     warnstr = sprintf('Possible dicominfo error: the dotproduct of the row and col vectors is %f should be 0',Cdotprod );
%     disp(warnstr)
% end

% Calculate image dimensions
row_length = dinfo.PixelSpacing(1) * nr;
col_length = dinfo.PixelSpacing(2) * nc;


%% Set up the corner positions matrix in XYZ coordinates
% Top Left Hand Corner
corners( topl, X) = pos(X);
corners( topl, Y) = pos(Y);
corners( topl, Z) = pos(Z);

% Top Right Hand Corner
corners( topr, X) = pos(X) + row_dircos(X) * row_length;
corners( topr, Y) = pos(Y) + row_dircos(Y) * row_length;
corners( topr, Z) = pos(Z) + row_dircos(Z) * row_length;

% Bottom Left Hand Corner
corners( botl, X) = pos(X) + col_dircos(X) * col_length;
corners( botl, Y) = pos(Y) + col_dircos(Y) * col_length;
corners( botl, Z) = pos(Z) + col_dircos(Z) * col_length;

% Bottom Right Hand Corner
corners( botr, X) = pos(X) + row_dircos(X) * row_length + col_dircos(X) * col_length;
corners( botr, Y) = pos(Y) + row_dircos(Y) * row_length + col_dircos(Y) * col_length;
corners( botr, Z) = pos(Z) + row_dircos(Z) * row_length + col_dircos(Z) * col_length;

%% Prepare the figure
% Select active figure, set hold on to alow multiple slices in one figure
if isempty(  fighandle )
     fighandle = figure;
     colormap( gray );
     newfig = 1;
else
    newfig = 0;
end

figure( fighandle );
hold on;

%Tidy up the figure
% set aspect ratio
daspect( [1,1,1]);
set( gca, 'color', 'none')

%% Display slice
%  normalize image data
imdata = double( imdata );
imdata = imdata / max( imdata(:));
% scale the image
I = imdata*255;
% create an alternative matrix for corner points
A( 1,1 , 1:3 ) = corners( topl, : );
A( 1,2 , 1:3 ) = corners( topr, : );
A( 2,1 , 1:3 ) = corners( botl, : );
A( 2,2 , 1:3 ) = corners( botr, : );
% extract the coordinates for the surfaces
x = A( :,:,X );
y = A( :,:,Y );
z = A( :,:,Z );

% plot surface
surfh = surface('XData',x,'YData',y,'ZData',z,...
'CData', I,...
'FaceColor','texturemap',...
'EdgeColor','none',...
'LineStyle','none',...
'Marker','none',...
'MarkerFaceColor','none',...
'MarkerEdgeColor','none',...
'CDataMapping','direct');    
%set transparency level
set( surfh, 'FaceAlpha', transparency );
% label axes and optimize figure
xlabel('RL');
ylabel('AP');
zlabel('FH');

% if only one slice is in the figure this may flatten the 3rd axis
if ~newfig
    axis tight
end

%% Optional: rotate to show all
% edit this to create a movie
do_movie = 0;
show_rotate = 1

if do_movie
    % open avifile
    aviobj = avifile('slice3Drotate.avi');
    show_rotate = 1;
end

if show_rotate
    % tilt and rotate
    el = 22;
    for azplus = 0:10:360
        az = mod( 45+azplus, 360);
        view( [az, el] );
        if do_movie
            % add farem to the movie
            frame = getframe(fh);
            aviobj = addframe(aviobj,frame);
        else
            % needed to see the intemediate steps
           drawnow;
        end
    end
end

if do_movie
    % close avifile
    close( aviobj );
end

return

