function [sROI] = ReadImageJROI(cstrFilenames)

% ReadImageJROI - FUNCTION Read an ImageJ ROI into a matlab structure
%
% Usage: [sROI] = ReadImageJROI(strFilename)
%        [cvsROIs] = ReadImageJROI(cstrFilenames)
%        [cvsROIs] = ReadImageJROI(strROIArchiveFilename)
%
% This function reads the ImageJ binary ROI file format.
%
% 'strFilename' is the full path to a '.roi' file.  A list of ROI files can be
% passed as a cell array of filenames, in 'cstrFilenames'.  An ImageJ ROI
% archive can be access by providing a '.zip' filename in
% 'strROIArchiveFilename'.  Single ROIs are returned as matlab structures, with
% variable fields depending on the ROI type.  Multiple ROIs are returned as a
% cell array of ROI structures.
%
% The field '.strName' is guaranteed to exist, and contains the ROI name (the
% filename minus '.roi').
%
% The field '.strType' is guaranteed to exist, and defines the ROI type:
% {'Rectangle', 'Oval', Line', 'Polygon', 'Freehand', 'Traced', 'PolyLine',
% 'FreeLine', 'Angle', 'Point', 'NoROI'}.
%
% The field '.vnRectBounds' is guaranteed to exist, and defines the rectangular
% bounds of the ROI: ['nTop', 'nLeft', 'nBottom', 'nRight'].
%
% The field '.nVersion' is guaranteed to exist, and defines the version number
% of the ROI format.
%
% ROI types:
%  Rectangle:
%     .strType = 'Rectangle';
%     .nArcSize         - The arc size of the rectangle's rounded corners
%
%      For a composite, "shape" ROI:
%     .strSubtype = 'Shape';
%     .vfShapeSegments  - A long, complicated vector of complicated shape
%                          segments.  This vector is in the format passed to the
%                          ImageJ ShapeROI constructor.  I won't decode this for
%                          you! :(
%
%  Oval:
%     .strType = 'Oval';
%
%  Line:
%     .strType = 'Line';
%  	.vnLinePoints     - The end points of the line ['nX1', 'nY1', 'nX2', 'nY2']
%
%     With arrow:
%     .strSubtype = 'Arrow';
%     .bDoubleHeaded    - Does the line have two arrowheads?
%     .bOutlined        - Is the arrow outlined?
%     .nArrowStyle      - The ImageJ style of the arrow (unknown interpretation)
%     .nArrowHeadSize   - The size of the arrowhead (unknown units)
%
%  Polygon:
%     .strType = 'Polygon';
%     .mnCoordinates    - An [Nx2] matrix, specifying the coordinates of
%                          the polygon vertices.  Each row is [nX nY].
%
%  Freehand:
%     .strType = 'Freehand';
%     .mnCoordinates    - An [Nx2] matrix, specifying the coordinates of
%                          the polygon vertices.  Each row is [nX nY].
%
%     Ellipse subtype:
%     .strSubtype = 'Ellipse';
%     .vfEllipsePoints  - A vector containing the ellipse control points:
%                          [fX1 fY1 fX2 fY2].
%     .fAspectRatio     - The aspect ratio of the ellipse.
%
%  Traced:
%     .strType = 'Traced';
%     .mnCoordinates    - An [Nx2] matrix, specifying the coordinates of
%                          the line vertices.  Each row is [nX nY].
%
%  PolyLine:
%     .strType = 'PolyLine';
%     .mnCoordinates    - An [Nx2] matrix, specifying the coordinates of
%                          the line vertices.  Each row is [nX nY].
%
%  FreeLine:
%     .strType = 'FreeLine';
%     .mnCoordinates    - An [Nx2] matrix, specifying the coordinates of
%                          the line vertices.  Each row is [nX nY].
%
%  Angle:
%     .strType = 'Angle';
%     .mnCoordinates    - An [Nx2] matrix, specifying the coordinates of
%                          the angle vertices.  Each row is [nX nY].
%
%  Point:
%     .strType = 'Point';
%     .mnCoordinates    - An [Nx2] matrix, specifying the coordinates of
%                          the points.  Each row is [nX nY].
%
%  NoROI:
%     .strType = 'NoROI';
%
% Additionally, ROIs from later versions (.nVersion >= 218) may have the
% following fields:
%
%     .nStrokeWidth     - The width of the line stroke
%     .nStrokeColor     - The encoded color of the stroke (ImageJ color format)
%     .nFillColor       - The encoded fill color for the ROI (ImageJ color
%                          format)
%
% If the ROI contains text:
%     .strSubtype = 'Text';
%     .nFontSize        - The desired font size
%     .nFontStyle       - The style of the font (unknown format)
%     .strFontName      - The name of the font to render the text with
%     .strText          - A string containing the text

% Author: Dylan Muir <muir@hifo.uzh.ch>
% Created: 9th August, 2011
%
% 20110810 Bug report contributed by Jean-Yves Tinevez
% 20110829 Bug fix contributed by Benjamin Ricca <ricca@berkeley.edu>
% 20120622 Order of ROIs in a ROI set is now preserved
% 20120703 Different way of reading zip file contents guarantees that ROI order
%           is preserved
%
% Copyright (c) 2011, 2012 Dylan Muir <muir@hifo.uzh.ch>

% -- Check arguments

if (nargin < 1)
   disp('*** ReadImageJROI: Incorrect usage');
   help ReadImageJROI;
   return;
end


% -- Check for a cell array of ROI filenames

if (iscell(cstrFilenames))
   % - Read each ROI in turn
   cvsROI = cellfun(@ReadImageJROI, CellFlatten(cstrFilenames), 'UniformOutput', false);
   
   % - Return all ROIs
   sROI = cvsROI;
   return;
   
else
   % - This is not a cell string
   strFilename = cstrFilenames;
   clear cstrFilenames;
end


% -- Check for a zip file

[nul, nul, strExt] = fileparts(strFilename);
if (isequal(lower(strExt), '.zip'))
   % - get zp file contents
   cstrFilenames_short = listzipcontents_rois(strFilename);
   
   % - Unzip the file into a temporary directory
   strROIDir = tempname;
   unzip(strFilename, strROIDir);
   
   for (nFileIndex = 1:length(cstrFilenames_short))
      cstrFilenames{1, nFileIndex} = [strROIDir '/' char(cstrFilenames_short(nFileIndex, 1))];
   end
   
   % - Build ROIs for each file
   cvsROIs = ReadImageJROI(cstrFilenames);
   
   % - Clean up temporary directory
   delete([strROIDir filesep '*.roi']);
   rmdir(strROIDir);
   
   % - Return ROIs
   sROI = cvsROIs;
   return;
end


% -- Read ROI

% -- Check file and open
if (~exist(strFilename, 'file'))
   error('ReadImageJROI:FileNotFound', ...
      '*** ReadImageJROI: The file [%s] was not found.', strFilename);
end

fidROI = fopen(strFilename, 'r', 'ieee-be');

% -- Check file magic code
strMagic = fread(fidROI, [1 4], '*char');

if (~isequal(strMagic, 'Iout'))
   error('ReadImageJROI:FormatError', ...
      '*** ReadImageJROI: The file was not an ImageJ ROI format.');
end

% -- Set ROI name
[nul, sROI.strName] = fileparts(strFilename);

% -- Read version
sROI.nVersion = fread(fidROI, 1, 'int16');

% -- Read ROI type
nTypeID = fread(fidROI, 1, 'uint8');
fseek(fidROI, 1, 'cof'); % Skip a byte

% -- Read rectangular bounds
sROI.vnRectBounds = fread(fidROI, [1 4], 'int16');

% -- Read number of coordinates
nNumCoords = fread(fidROI, 1, 'int16');

% -- Read the rest of the header
vfLinePoints = fread(fidROI, 4, 'float32');
nStrokeWidth = fread(fidROI, 1, 'int16');
nShapeROISize = fread(fidROI, 1, 'int32');
nStrokeColor = fread(fidROI, 1, 'int32');
nFillColor = fread(fidROI, 1, 'int32');
nROISubtype = fread(fidROI, 1, 'int16');
nOptions = fread(fidROI, 1, 'int16');
nArrowStyle = fread(fidROI, 1, 'int16');
nArrowHeadSize = fread(fidROI, 1, 'uint8');
nRoundedRectArcSize = fread(fidROI, 1, 'int16');
nPosition = fread(fidROI, 1, 'int16');

% - Seek to get aspect ratio
fseek(fidROI, 52, 'bof');
fAspectRatio = fread(fidROI, 1, 'float32');

% - Seek to after header
fseek(fidROI, 64, 'bof');


% -- Build ROI

switch nTypeID
   case 1
      % - Rectangle
      sROI.strType = 'Rectangle';
      sROI.nArcSize = nRoundedRectArcSize;
      
      if (nShapeROISize > 0)
         % - This is a composite shape ROI
         sROI.strSubtype = 'Shape';
         if (nTypeID ~= 1)
            error('ReadImageJROI:FormatError', ...
               '*** ReadImageJROI: A composite ROI must be a Rectangle type.');
         end
         
         % - Read shapes
         sROI.vfShapes = fread(fidROI, nShapeROISize, 'float32');
      end
      
      
   case 2
      % - Oval
      sROI.strType = 'Oval';
      
   case 3
      % - Line
      sROI.strType = 'Line';
      sROI.vnLinePoints = round(vfLinePoints);
      
      if (nROISubtype == 2)
         % - This is an arrow line
         sROI.strSubtype = 'Arrow';
         sROI.bDoubleHeaded = nOptions & 2;
         sROI.bOutlined = nOptions & 4;
         sROI.nArrowStyle = nArrowStyle;
         sROI.nArrowHeadSize = nArrowHeadSize;
      end
      
      
   case 0
      % - Polygon
      sROI.strType = 'Polygon';
      sROI.mnCoordinates = read_coordinates;
      
   case 7
      % - Freehand
      sROI.strType = 'Freehand';
      sROI.mnCoordinates = read_coordinates;
      
      if (nROISubtype == 3)
         % - This is an ellipse
         sROI.strSubtype = 'Ellipse';
         sROI.vfEllipsePoints = vfLinePoints;
         sRoi.fAspectRatio = fAspectRatio;
      end
      
   case 8
      % - Traced
      sROI.strType = 'Traced';
      sROI.mnCoordinates = read_coordinates;
      
   case 5
      % - PolyLine
      sROI.strType = 'PolyLine';
      sROI.mnCoordinates = read_coordinates;
      
   case 4
      % - FreeLine
      sROI.strType = 'FreeLine';
      sROI.mnCoordinates = read_coordinates;
      
   case 9
      % - Angle
      sROI.strType = 'Angle';
      sROI.mnCoordinates = read_coordinates;
      
   case 10
      % - Point
      sROI.strType = 'Point';
      sROI.mnCoordinates = read_coordinates;
      
   case 6
      sROI.strType = 'NoROI';
      
   otherwise
      error('ReadImageJROI:FormatError', ...
         '--- ReadImageJROI: The ROI file contains an unknown ROI type.');
end


% -- Handle version >= 218

if (sROI.nVersion >= 218)
   sROI.nStrokeWidth = nStrokeWidth;
   sROI.nStrokeColor = nStrokeColor;
   sROI.nFillColor = nFillColor;
   sROI.bSplineFit = nOptions & 1;
   
   if (nROISubtype == 1)
      % - This is a text ROI
      sROI.strSubtype = 'Text';
      
      % - Seek to after header
      fseek(fidROI, 64, 'bof');
      
      sROI.nFontSize = fread(fidROI, 1, 'int32');
      sROI.nFontStyle = fread(fidROI, 1, 'int32');
      nNameLength = fread(fidROI, 1, 'int32');
      nTextLength = fread(fidROI, 1, 'int32');
      
      % - Read font name
      sROI.strFontName = fread(fidROI, nNameLength, 'int16=>char');
      
      % - Read text
      sROI.strText = fread(fidROI, nTextLength, 'int16=>char');
   end
end

% - Close the file
fclose(fidROI);


% --- END of ReadImageJROI FUNCTION ---

   function [mnCoordinates] = read_coordinates
      % - Read X and Y coords
      vnX = fread(fidROI, [nNumCoords 1], 'int16');
      vnY = fread(fidROI, [nNumCoords 1], 'int16');
      
      % - Trim at zero
      vnX(vnX < 0) = 0;
      vnY(vnY < 0) = 0;
      
      % - Offset by top left ROI bound
      vnX = vnX + sROI.vnRectBounds(2);
      vnY = vnY + sROI.vnRectBounds(1);
      
      mnCoordinates = [vnX vnY];
   end

   function [filelist] = listzipcontents_rois(zipFilename)
      
      % listzipcontents_rois - FUNCTION Read the file names in a zip file
      %
      % Usage: [filelist] = listzipcontents_rois(zipFilename)
      
      % - Import java libraries
      import java.util.zip.*;
      import java.io.*;
      
      % - Read file list via JAVA object
      filelist={};
      in = ZipInputStream(FileInputStream(zipFilename));
      entry = in.getNextEntry();
      
      % - Filter ROI files
      while (entry~=0)
         name = entry.getName;
         if (name.endsWith('.roi'))
            filelist = cat(1,filelist,char(name));
         end;
         entry = in.getNextEntry();
      end;
      
      % - Close zip file
      in.close();
   end


   function [cellArray] = CellFlatten(varargin)
      
      % CellFlatten - FUNCTION Convert a list of items to a single level cell array
      %
      % Usage: [cellArray] = CellFlatten(arg1, arg2, ...)
      %
      % CellFlatten will convert a list of arguments into a single-level cell array.
      % If any argument is already a cell array, each cell will be concatenated to
      % 'cellArray' in a list.  The result of this function is a single-dimensioned
      % cell array containing a cell for each individual item passed to CellFlatten.
      % The order of cell elements in the argument list is guaranteed to be
      % preserved.
      %
      % This function is useful when dealing with variable-length argument lists,
      % each item of which can also be a cell array of items.
      
      % Author: Dylan Muir <dylan@ini.phys.ethz.ch>
      % Created: 14th May, 2004
      
      % -- Check arguments
      
      if (nargin == 0)
         disp('*** CellFlatten: Incorrect usage');
         help CellFlatten;
         return;
      end
      
      
      % -- Convert arguments
      
      if (iscell(varargin{1}))
         cellArray = CellFlatten(varargin{1}{:});
      else
         cellArray = {varargin{1}};
      end
      
      for (nIndexArg = 2:length(varargin)) %#ok<FORPF>
         if (iscell(varargin{nIndexArg}))
            cellReturn = CellFlatten(varargin{nIndexArg}{:});
            cellArray = [cellArray cellReturn{:}];
         else
            cellArray = [cellArray varargin{nIndexArg}];
         end
      end
      
      
      % --- END of CellFlatten.m ---
      
   end

end
% --- END of ReadImageJROI.m ---
