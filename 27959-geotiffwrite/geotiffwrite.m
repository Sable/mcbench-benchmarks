%GEOTIFFWRITE  Write a 2D or 3D array to a single or multi-band GeoTIFF file
%
%  MATLAB's Mapping Toolbox only provides a "geotiffread" function, but
%  it does not have a "geotiffwrite" function (Note). This is the MATLAB 
%  program to write a 2D or 3D array to a single or multi-band GeoTIFF
%  file, where data can be either 1-bit monochrome data (i.e. binary or
%  bilevel), 8-bit unsigned integer, 16-bit signed / unsigned integer, 
%  32-bit signed integer, or 32-bit floating point.
%
%  Note: Starting from version R2011a, MATLAB's Mapping Toolbox also
%        provides its own "geotiffwrite" function
% (http://www.mathworks.com/help/toolbox/map/rn/bsq4us7-1.html#bsu1ro5-1).
%
%  This program is based on GeoTIFF Format Specification under:
%  http://www.remotesensing.org/geotiff/spec/geotiffhome.html
%  or http://download.osgeo.org/geotiff/spec
%
%  It does not need MATLAB's Mapping Toolbox, or any other library.
%
%  The motivation to create such a program is because I want to convert
%  the free satelite data from NASA & USGS to the GARMIN topo map for my
%  Garmin GPS. DEM2TOPO (http://people.uleth.ca/~brad.gom/dem2topo) is a
%  wonderful program that can nicely extract contours from the elevation
%  data. However, only 1201x1201 pixels data are supported. For USGS24K 
%  DEM data, 1-arc-second SRTM1 data, etc, DEM2TOPO cannot process them 
%  directly, which must be converted into GeoTIFF format first (see 
%  "Known Issues" in the above site). Although there is a free Windows 
%  program "3DEM" that can convert USGS24K DEM & SRTM1 data into GeoTIFF
%  format, sometimes you will still need to interpolate those DEM data 
%  for void or missing elevation points.
%
%  If you just want to write DEM data to a GeoTIFF file, all you have to
%  provide is a bounding box (2 latitude & 2 longitude), and a 2D or 3D
%  array. Otherwise, you can provide proper GeoTIFF fields to the option
%  argument. To make your life easier, a GUI program "make_option.m"
%  is also provided. So you can select the proper GeoTIFF fields to
%  generate the option argument.
%
%  I recommend that you use "make_option" program to generate option
%  argument instead of constructing it manually.
%
%  Usage:  [option bbox] = make_option([bbox]);
%          geotiffwrite(filename, bbox, image, [bit_depth, option]);
%
%  filename - GeoTIFF file name to be written.
%
%  bbox - Bounding box with West/East of longitude and South/North of
%         latitude. The latitude & longitude must be in Decimal Degree
%         (DD) format, and they must be in a 2x2 array with the order
%         of:
%
%               [  longitude_West,  latitude_South;
%		   longitude_East,  latitude_North  ]
%
%         Note: If GTModelTypeGeoKey is not ModelTypeGeographic, bbox
%               will be reset to empty.
%
%  image - 2D or 3D array. Although any orientation can be specified
%          through option.Orientation, it is simpler to just use the
%          following default orientation:
%
%            First row at North edge; last row at South edge;
%            First column at West edge; last column at East edge;
%
%          Note: By default, "geotiffwrite" assumes intensity image and
%                option.FullColor is 0. So the third dimension of a 3D
%                image represents different bands. If option.FullColor
%                is 1, the third dimension of 3D image must be 3, which
%                indicates R,G,B. i.e. when the third dimension of a 3D
%                array equals to 3, it represents a 3-band GeoTIFF
%                image, unless the option.FullColor is set to 1. When
%                option.ColorMap is set, the specified palette will be
%                used, and you cannot set option.FullColor to 1 at the
%                same time.
%
%  bit_depth - (optional) Number of bits to represent a data point (i.e. 
%          bits per sample):
%
%            1 for 1-bit monochrome data (i.e. binary or bilevel)
%            8 for 8-bit unsigned integer
%            16 for 16-bit signed integer
%            32 for 32-bit floating point (default)
%            -16 for 16-bit unsigned integer
%            -32 for 32-bit signed integer
%
%          Note: If you set values for option.ColorMap, 16 will be for
%                16-bit unsigned integer, and you cannot write in 32-bit
%                depth or 1-bit depth. If you set option.FullColor to 1,
%                8-bit unsigned integer will be used, and you cannot 
%                change bit_depth for Full Color image.
%
%  option - (optional) A structure of GeoTIFF fields:
%
%          First, please run: [option bbox] = make_option( [bbox] ); This
%          will include most fields, except the following:
%
%          option.NaN
%             By default, NaN value (void data point) in the image
%             variable will be kept untouched. However, if you decide
%             to replace it with other value (e.g. -32768), you can
%             define it here.
%
%          option.FullColor = [0] | 1
%             0: Intensity or ColorMap image; (default)
%             1: FullColor (24-bit RGB) image;
%
%          option.ColorMap                                    [Nx3 array]
%             Where N = 2^bit_depth, and bit_depth can only be 8 or 16.
%             Values in option.ColorMap range from 0 to 65535, and value
%             0 in image points to the first row in the ColorMap. Columns
%             in option.ColorMap are [R G B]. Black is represented by
%             [0 0 0], and white is represented by [65535 65535 65535].
%
%          option.Orientation = [1] | 2 | 3 | 4 | 5 | 6 | 7 | 8
%             1: Row from Top, Col from Left; (default)
%             2: Row from Top, Col from Right;
%             3: Row from Bottom, Col from Right;
%             4: Row from Bottom, Col from Left;
%             5: Row from Left, Col from Top;
%             6: Row from Right, Col from Top;
%             7: Row from Right, Col from Bottom;
%             8: Row from Left, Col from Bottom;
%
%          option.ModelTransformationTag                      [4x4 array]
%             In most case, ModelPixelScaleTag and ModelTiepointTag from
%             "make_option.m" program is sufficient to transform from raster
%             to model space. If raster image requires rotation or shearing,
%             you can use this ModelTransformationTag to define a 4x4 affine
%             transformation matrix.
%
%  Examples:
%  - Although not illustrated, it would be easier to use "make_option.m"
%    for option argument
%
%  Data from UTM projected coordinate systems:
%  ftp://ftp.remotesensing.org/pub/geotiff/samples/spot/chicago/UTM2GTIF.TIF
%  or    http://download.osgeo.org/geotiff/samples/spot/chicago/UTM2GTIF.TIF
%  img = imread('UTM2GTIF.TIF');
%  clear option
%  option.GTModelTypeGeoKey = 1;
%  option.ModelPixelScaleTag = [10;10;0];
%  option.ModelTiepointTag = [0;0;0;444650;4640510;0];
%  option.GeogEllipsoidGeoKey = 7008;
%  option.ProjectedCSTypeGeoKey = 26716;
%  option.GTCitationGeoKey = 'UTM Zone 16N NAD27"';
%  option.GeogCitationGeoKey = 'Clarke, 1866 by Default';
%  geotiffwrite('UTM2GTIFX.TIF',[],img,8,option);
%
%  Data from colormap indexed scan image:
%  ftp://ftp.remotesensing.org/pub/geotiff/samples/usgs/o41078a5.tif
%  or    http://download.osgeo.org/geotiff/samples/usgs/o41078a5.tif
%  [img cmap] = imread('o41078a5.tif');
%  clear option
%  option.GTModelTypeGeoKey = 1;
%  option.ModelPixelScaleTag = [2.4384;2.4384;0];
%  option.ModelTiepointTag = [0;0;0;698753.304798;4556059.506392;0];
%  option.ProjectedCSTypeGeoKey = 32617;
%  option.PCSCitationGeoKey = 'UTM Zone 17 N with WGS84';
%  option.ColorMap = 65535*cmap;
%  geotiffwrite('o41078a5X.tif',[],img,8,option);
%
%  DEM data:
%  ftp://ftp.remotesensing.org/pub/geotiff/samples/usgs/mlatlon.tif
%  or    http://download.osgeo.org/geotiff/samples/usgs/mlatlon.tif
%  img = imread('mlatlon.tif');
%  clear option
%  option.GeographicTypeGeoKey = 4267;
%  option.GTCitationGeoKey = 'Geographic Model/GeoTIFF 1.0';
%  option.GeogCitationGeoKey = 'NAD 27 Datum';
%  geotiffwrite('mlatlonX.tif',[-122.6261,37.4531;-122.0777,38],img,16,option);
%
%  Even simpler:
%  http://dds.cr.usgs.gov/srtm/version2_1/SRTM3/North_America/N46W082.hgt.zip
%  srtm = load_srtm('N46W082.hgt');
%  geotiffwrite('N46W082.tif',[-82,46;-81,47],flipud(srtm.dat));
%
%  - Jimmy Shen (jimmy@rotman-baycrest.on.ca)
%
function geotiffwrite(filename, bbox, image, bit_depth, option)

   %  Set default inputs
   %
   if nargin < 5
      option = [];

      if isempty(bbox)
         help geotiffwrite;
         error('Because you did not specify bounding box, please assign proper values to option argument');
      end
   end

   if nargin < 4
      bit_depth = [];
   end

   if nargin < 3
      error('Usage: geotiffwrite(filename, bbox, image, [bit_depth, option])');
   end

   if isempty(bit_depth)
      bit_depth = 32;
   end

   if isfield(option, 'FullColor') & option.FullColor == 1
      bit_depth = 8;

      if isfield(option, 'ColorMap')
         error('If you set option.FullColor to 1, you cannot set option.ColorMap.');
      end
   else
      option.FullColor = 0;
   end

   if isfield(option, 'ColorMap') & ( abs(bit_depth)==32 | abs(bit_depth)==1 )
      error('If you set values to option.ColorMap, you cannot write in 32-bit depth or 1-bit depth.');
   end

   %  Set void data: GeoTIFF set void data to -32768, while data from
   %  other software can be -32767 or NaN.
   %
%   if strcmpi( class(image), 'double' )
 %     image(find(isnan(image))) = -32768;
  % end

   %  Only for int16 DEM data
   %
%   if bit_depth == 16
 %     image(find(image==-32767)) = -32768;
  % end

   if isfield(option, 'NaN')
      image(find(isnan(image))) = option.NaN;
   end

   %  Set Orientation, 274
   %
   if isfield(option, 'Orientation')
      ifd.Orientation = option.Orientation;

      for i = 1:size(image,3)
         switch ifd.Orientation
         case 2
            image(:,:,i) = fliplr(image(:,:,i));
         case 3
            image(:,:,i) = fliplr(flipud(image(:,:,i)));
         case 4
            image(:,:,i) = flipud(image(:,:,i));
         case 5
            image(:,:,i) = flipud(rot90(image(:,:,i)));
         case 6
            image(:,:,i) = rot90(image(:,:,i));
         case 7
            image(:,:,i) = fliplr(rot90(image(:,:,i)));
         case 8
            image(:,:,i) = fliplr(flipud(rot90(image(:,:,i))));
         end
      end
   else
      % First row at North edge; last row at South edge;
      % First column at West edge; last column at East edge;
      %
      ifd.Orientation = 1;
   end

   if abs(bit_depth) == 1 & mod(size(image,2),8) ~= 0
      error('Please use integral multiple of 8 for 1-bit image size.');
   end


   GeoAsciiParamsTag = '';
   GeoDoubleParamsTag = [];
   GeoAsciiOffset = 0;
   GeoDoubleOffset = 0;
   NumberOfKeys = 0;
   GeoKeyDirectoryTag = [1 1 0 NumberOfKeys];

   %  Set GTModelTypeGeoKey, 1024
   %
   NumberOfKeys = NumberOfKeys + 1;
   GeoKeyDirectoryTag(1, 4) = NumberOfKeys;

   if isfield(option, 'GTModelTypeGeoKey') & option.GTModelTypeGeoKey ~= 2
      code = option.GTModelTypeGeoKey;
      bbox = [];
      disp('Warning: Since your Model Type is not Geographic, bbox is reset to empty.');
   else
      code = 2;					% ModelTypeGeographic
   end

   GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [1024 0 1 code]];

   %  Set GTRasterTypeGeoKey, 1025
   %
   NumberOfKeys = NumberOfKeys + 1;
   GeoKeyDirectoryTag(1, 4) = NumberOfKeys;

   if isfield(option, 'GTRasterTypeGeoKey')
      code = option.GTRasterTypeGeoKey;
   else
      code = 1;					% RasterPixelIsArea
   end

   gifd.GTRasterTypeGeoKey = code;
   GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [1025 0 1 code]];

   %  Set GTCitationGeoKey, 1026
   %
   if isfield(option, 'GTCitationGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = [option.GTCitationGeoKey(:); '|']; cnt = length(code);
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [1026 34737 cnt GeoAsciiOffset]];
      GeoAsciiParamsTag = [GeoAsciiParamsTag; code];
      GeoAsciiOffset = GeoAsciiOffset + cnt;
   end

   %  Set GeographicTypeGeoKey, 2048
   %
   if isfield(option, 'GeographicTypeGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.GeographicTypeGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [2048 0 1 code]];
   elseif ~isempty(bbox)
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
%      code = 4267;				% GCS_NAD27
%      code = 4322;				% GCS_WGS_72
      code = 4326;				% GCS_WGS_84
%      code = 4269;				% GCS_NAD83
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [2048 0 1 code]];
   end

   %  Set GeogCitationGeoKey, 2049
   %
   if isfield(option, 'GeogCitationGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = [option.GeogCitationGeoKey(:); '|']; cnt = length(code);
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [2049 34737 cnt GeoAsciiOffset]];
      GeoAsciiParamsTag = [GeoAsciiParamsTag; code];
      GeoAsciiOffset = GeoAsciiOffset + cnt;
   end

   %  Set GeogGeodeticDatumGeoKey, 2050
   %
   if isfield(option, 'GeogGeodeticDatumGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.GeogGeodeticDatumGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [2050 0 1 code]];
   end

   %  Set GeogPrimeMeridianGeoKey, 2051
   %
   if isfield(option, 'GeogPrimeMeridianGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.GeogPrimeMeridianGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [2051 0 1 code]];
   end

   %  Set GeogLinearUnitsGeoKey, 2052
   %
   if isfield(option, 'GeogLinearUnitsGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.GeogLinearUnitsGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [2052 0 1 code]];
   end

   %  Set GeogLinearUnitSizeGeoKey, 2053
   %
   if isfield(option, 'GeogLinearUnitSizeGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.GeogLinearUnitSizeGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [2053 34736 1 GeoDoubleOffset]];
      GeoDoubleParamsTag = [GeoDoubleParamsTag; code];
      GeoDoubleOffset = GeoDoubleOffset + 1;
   end

   %  Set GeogAngularUnitsGeoKey, 2054
   %
   if isfield(option, 'GeogAngularUnitsGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.GeogAngularUnitsGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [2054 0 1 code]];
   end

   %  Set GeogAngularUnitSizeGeoKey, 2055
   %
   if isfield(option, 'GeogAngularUnitSizeGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.GeogAngularUnitSizeGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [2055 34736 1 GeoDoubleOffset]];
      GeoDoubleParamsTag = [GeoDoubleParamsTag; code];
      GeoDoubleOffset = GeoDoubleOffset + 1;
   end

   %  Set GeogEllipsoidGeoKey, 2056
   %
   if isfield(option, 'GeogEllipsoidGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.GeogEllipsoidGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [2056 0 1 code]];
   end

   %  Set GeogSemiMajorAxisGeoKey, 2057
   %
   if isfield(option, 'GeogSemiMajorAxisGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.GeogSemiMajorAxisGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [2057 34736 1 GeoDoubleOffset]];
      GeoDoubleParamsTag = [GeoDoubleParamsTag; code];
      GeoDoubleOffset = GeoDoubleOffset + 1;
   end

   %  Set GeogSemiMinorAxisGeoKey, 2058
   %
   if isfield(option, 'GeogSemiMinorAxisGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.GeogSemiMinorAxisGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [2058 34736 1 GeoDoubleOffset]];
      GeoDoubleParamsTag = [GeoDoubleParamsTag; code];
      GeoDoubleOffset = GeoDoubleOffset + 1;
   end

   %  Set GeogInvFlatteningGeoKey, 2059
   %
   if isfield(option, 'GeogInvFlatteningGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.GeogInvFlatteningGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [2059 34736 1 GeoDoubleOffset]];
      GeoDoubleParamsTag = [GeoDoubleParamsTag; code];
      GeoDoubleOffset = GeoDoubleOffset + 1;
   end

   %  Set GeogAzimuthUnitsGeoKey, 2060
   %
   if isfield(option, 'GeogAzimuthUnitsGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.GeogAzimuthUnitsGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [2060 0 1 code]];
   end

   %  Set GeogPrimeMeridianLongGeoKey, 2061
   %
   if isfield(option, 'GeogPrimeMeridianLongGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.GeogPrimeMeridianLongGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [2061 34736 1 GeoDoubleOffset]];
      GeoDoubleParamsTag = [GeoDoubleParamsTag; code];
      GeoDoubleOffset = GeoDoubleOffset + 1;
   end

   %  Set ProjectedCSTypeGeoKey, 3072
   %
   if isfield(option, 'ProjectedCSTypeGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.ProjectedCSTypeGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [3072 0 1 code]];
   end

   %  Set PCSCitationGeoKey, 3073
   %
   if isfield(option, 'PCSCitationGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = [option.PCSCitationGeoKey(:); '|']; cnt = length(code);
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [3073 34737 cnt GeoAsciiOffset]];
      GeoAsciiParamsTag = [GeoAsciiParamsTag; code];
      GeoAsciiOffset = GeoAsciiOffset + cnt;
   end

   %  Set ProjectionGeoKey, 3074
   %
   if isfield(option, 'ProjectionGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.ProjectionGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [3074 0 1 code]];
   end

   %  Set ProjCoordTransGeoKey, 3075
   %
   if isfield(option, 'ProjCoordTransGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.ProjCoordTransGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [3075 0 1 code]];
   end

   %  Set ProjLinearUnitsGeoKey, 3076
   %
   if isfield(option, 'ProjLinearUnitsGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.ProjLinearUnitsGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [3076 0 1 code]];
   end

   %  Set ProjLinearUnitSizeGeoKey, 3077
   %
   if isfield(option, 'ProjLinearUnitSizeGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.ProjLinearUnitSizeGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [3077 34736 1 GeoDoubleOffset]];
      GeoDoubleParamsTag = [GeoDoubleParamsTag; code];
      GeoDoubleOffset = GeoDoubleOffset + 1;
   end

   %  Set ProjStdParallel1GeoKey, 3078
   %
   if isfield(option, 'ProjStdParallel1GeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.ProjStdParallel1GeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [3078 34736 1 GeoDoubleOffset]];
      GeoDoubleParamsTag = [GeoDoubleParamsTag; code];
      GeoDoubleOffset = GeoDoubleOffset + 1;
   end

   %  Set ProjStdParallel2GeoKey, 3079
   %
   if isfield(option, 'ProjStdParallel2GeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.ProjStdParallel2GeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [3079 34736 1 GeoDoubleOffset]];
      GeoDoubleParamsTag = [GeoDoubleParamsTag; code];
      GeoDoubleOffset = GeoDoubleOffset + 1;
   end

   %  Set ProjNatOriginLongGeoKey, 3080
   %
   if isfield(option, 'ProjNatOriginLongGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.ProjNatOriginLongGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [3080 34736 1 GeoDoubleOffset]];
      GeoDoubleParamsTag = [GeoDoubleParamsTag; code];
      GeoDoubleOffset = GeoDoubleOffset + 1;
   end

   %  Set ProjNatOriginLatGeoKey, 3081
   %
   if isfield(option, 'ProjNatOriginLatGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.ProjNatOriginLatGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [3081 34736 1 GeoDoubleOffset]];
      GeoDoubleParamsTag = [GeoDoubleParamsTag; code];
      GeoDoubleOffset = GeoDoubleOffset + 1;
   end

   %  Set ProjFalseEastingGeoKey, 3082
   %
   if isfield(option, 'ProjFalseEastingGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.ProjFalseEastingGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [3082 34736 1 GeoDoubleOffset]];
      GeoDoubleParamsTag = [GeoDoubleParamsTag; code];
      GeoDoubleOffset = GeoDoubleOffset + 1;
   end

   %  Set ProjFalseNorthingGeoKey, 3083
   %
   if isfield(option, 'ProjFalseNorthingGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.ProjFalseNorthingGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [3083 34736 1 GeoDoubleOffset]];
      GeoDoubleParamsTag = [GeoDoubleParamsTag; code];
      GeoDoubleOffset = GeoDoubleOffset + 1;
   end

   %  Set ProjFalseOriginLongGeoKey, 3084
   %
   if isfield(option, 'ProjFalseOriginLongGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.ProjFalseOriginLongGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [3084 34736 1 GeoDoubleOffset]];
      GeoDoubleParamsTag = [GeoDoubleParamsTag; code];
      GeoDoubleOffset = GeoDoubleOffset + 1;
   end

   %  Set ProjFalseOriginLatGeoKey, 3085
   %
   if isfield(option, 'ProjFalseOriginLatGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.ProjFalseOriginLatGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [3085 34736 1 GeoDoubleOffset]];
      GeoDoubleParamsTag = [GeoDoubleParamsTag; code];
      GeoDoubleOffset = GeoDoubleOffset + 1;
   end

   %  Set ProjFalseOriginEastingGeoKey, 3086
   %
   if isfield(option, 'ProjFalseOriginEastingGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.ProjFalseOriginEastingGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [3086 34736 1 GeoDoubleOffset]];
      GeoDoubleParamsTag = [GeoDoubleParamsTag; code];
      GeoDoubleOffset = GeoDoubleOffset + 1;
   end

   %  Set ProjFalseOriginNorthingGeoKey, 3087
   %
   if isfield(option, 'ProjFalseOriginNorthingGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.ProjFalseOriginNorthingGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [3087 34736 1 GeoDoubleOffset]];
      GeoDoubleParamsTag = [GeoDoubleParamsTag; code];
      GeoDoubleOffset = GeoDoubleOffset + 1;
   end

   %  Set ProjCenterLongGeoKey, 3088
   %
   if isfield(option, 'ProjCenterLongGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.ProjCenterLongGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [3088 34736 1 GeoDoubleOffset]];
      GeoDoubleParamsTag = [GeoDoubleParamsTag; code];
      GeoDoubleOffset = GeoDoubleOffset + 1;
   end

   %  Set ProjCenterLatGeoKey, 3089
   %
   if isfield(option, 'ProjCenterLatGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.ProjCenterLatGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [3089 34736 1 GeoDoubleOffset]];
      GeoDoubleParamsTag = [GeoDoubleParamsTag; code];
      GeoDoubleOffset = GeoDoubleOffset + 1;
   end

   %  Set ProjCenterEastingGeoKey, 3090
   %
   if isfield(option, 'ProjCenterEastingGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.ProjCenterEastingGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [3090 34736 1 GeoDoubleOffset]];
      GeoDoubleParamsTag = [GeoDoubleParamsTag; code];
      GeoDoubleOffset = GeoDoubleOffset + 1;
   end

   %  Set ProjCenterOriginNorthingGeoKey, 3091
   %
   if isfield(option, 'ProjCenterOriginNorthingGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.ProjCenterOriginNorthingGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [3091 34736 1 GeoDoubleOffset]];
      GeoDoubleParamsTag = [GeoDoubleParamsTag; code];
      GeoDoubleOffset = GeoDoubleOffset + 1;
   end

   %  Set ProjScaleAtNatOriginGeoKey, 3092
   %
   if isfield(option, 'ProjScaleAtNatOriginGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.ProjScaleAtNatOriginGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [3092 34736 1 GeoDoubleOffset]];
      GeoDoubleParamsTag = [GeoDoubleParamsTag; code];
      GeoDoubleOffset = GeoDoubleOffset + 1;
   end

   %  Set ProjScaleAtCenterGeoKey, 3093
   %
   if isfield(option, 'ProjScaleAtCenterGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.ProjScaleAtCenterGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [3093 34736 1 GeoDoubleOffset]];
      GeoDoubleParamsTag = [GeoDoubleParamsTag; code];
      GeoDoubleOffset = GeoDoubleOffset + 1;
   end

   %  Set ProjAzimuthAngleGeoKey, 3094
   %
   if isfield(option, 'ProjAzimuthAngleGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.ProjAzimuthAngleGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [3094 34736 1 GeoDoubleOffset]];
      GeoDoubleParamsTag = [GeoDoubleParamsTag; code];
      GeoDoubleOffset = GeoDoubleOffset + 1;
   end

   %  Set ProjStraightVertPoleLongGeoKey, 3095
   %
   if isfield(option, 'ProjStraightVertPoleLongGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.ProjStraightVertPoleLongGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [3095 34736 1 GeoDoubleOffset]];
      GeoDoubleParamsTag = [GeoDoubleParamsTag; code];
      GeoDoubleOffset = GeoDoubleOffset + 1;
   end

   %  Set VerticalCSTypeGeoKey, 4096
   %
   if isfield(option, 'VerticalCSTypeGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.VerticalCSTypeGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [4096 0 1 code]];
   end

   %  Set VerticalCitationGeoKey, 4097
   %
   if isfield(option, 'VerticalCitationGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = [option.VerticalCitationGeoKey(:); '|']; cnt = length(code);
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [4097 34737 cnt GeoAsciiOffset]];
      GeoAsciiParamsTag = [GeoAsciiParamsTag; code];
      GeoAsciiOffset = GeoAsciiOffset + cnt;
   end

   %  Set VerticalUnitsGeoKey, 4099
   %
   if isfield(option, 'VerticalUnitsGeoKey')
      NumberOfKeys = NumberOfKeys + 1;
      GeoKeyDirectoryTag(1, 4) = NumberOfKeys;
      code = option.VerticalUnitsGeoKey;
      GeoKeyDirectoryTag = [GeoKeyDirectoryTag; [4099 0 1 code]];
   end

   %  Set ifd.ImageWidth, 256
   %
   ifd.ImageWidth = size(image, 2);

   %  Set ifd.ImageLength, 257
   %
   ifd.ImageLength = size(image, 1);

   %  Set ifd.BitsPerSample, 258
   %
   ifd.BitsPerSample = abs(bit_depth)*ones(size(image,3),1);

   %  Set ifd.Compression, 259
   %
   ifd.Compression = 1;				% Uncompressed

   %  Set ifd.PhotometricInterpretation, 262
   %
   if isfield(option, 'ColorMap')
      ifd.PhotometricInterpretation = 3;	% Palette color
   elseif isfield(option, 'FullColor') & option.FullColor == 1
      ifd.PhotometricInterpretation = 2;	% RGB
   else
      ifd.PhotometricInterpretation = 1;	% BlackIsZero
   end

   %  Set ifd.StripOffsets, 273
   %
   ifd.StripOffsets = ones(ifd.ImageLength,1) * ifd.ImageWidth ...
	* abs(bit_depth)/8 * size(image,3);	% Num of bytes in a strip
   ifd.StripOffsets = cumsum(ifd.StripOffsets);
   ifd.StripOffsets(end) = [];
   ifd.StripOffsets = [0; ifd.StripOffsets];
   ifd.StripOffsets = ifd.StripOffsets + 8;	% 8 bytes before 1st strip

   %  Set ifd.SamplesPerPixel, 277
   %
   ifd.SamplesPerPixel = size(image, 3);	% Gray level intensity

   %  Set ifd.RowsPerStrip, 278
   %
   ifd.RowsPerStrip = 1;			% rows per strip

   %  Set ifd.StripByteCounts, 279
   %
   ifd.StripByteCounts = ones(ifd.ImageLength,1) * ifd.ImageWidth ...
	* abs(bit_depth)/8 * size(image,3);	% Num of bytes in a strip

   %  Set ifd.XResolution, 282
   %
   ifd.XResolution = 96;			% 96 dpi

   %  Set ifd.YResolution, 283
   %
   ifd.YResolution = 96;			% 96 dpi

   %  Set ifd.PlanarConfiguration, 284
   %
   ifd.PlanarConfiguration = 1;			% Chunky

   %  Set ifd.ResolutionUnit, 296
   %
   ifd.ResolutionUnit = 2;			% Inch

   %  Set ifd.ColorMap, 320
   %
   if isfield(option, 'ColorMap')
      ifd.ColorMap = option.ColorMap(:);
   end

   %  Set ifd.ExtraSamples, 338
   %
   if ndims(image) > 2
      ifd.ExtraSamples = zeros((size(image,3)-1),1);
   end

   %  Set ifd.SampleFormat, 339
   %
   switch bit_depth
   case {1, -1}
      ifd.SampleFormat = 4*ones(size(image,3),1);	% Undefined
   case {8, -16}
      ifd.SampleFormat = ones(size(image,3),1);		% Unsigned integer
   case {16, -32}
      ifd.SampleFormat = 2*ones(size(image,3),1);	% Signed integer
   case 32
      ifd.SampleFormat = 3*ones(size(image,3),1);	% Floating point
   end

   if isfield(ifd, 'ColorMap') & bit_depth == 16
      ifd.SampleFormat = ones(size(image,3),1);		% Unsigned integer
   end

   if ~isempty(bbox)

      %  Set gifd.ModelPixelScaleTag, 33550
      %
      if gifd.GTRasterTypeGeoKey == 1
         Sx = (bbox(2) - bbox(1)) / ifd.ImageWidth;
         Sy = (bbox(4) - bbox(3)) / ifd.ImageLength;
      elseif gifd.GTRasterTypeGeoKey == 2
         Sx = (bbox(2) - bbox(1)) / (ifd.ImageWidth-1);
         Sy = (bbox(4) - bbox(3)) / (ifd.ImageLength-1);
      else
         error('Incorrect option.GTRasterTypeGeoKey value');
      end

      gifd.ModelPixelScaleTag = [Sx Sy 0];

      %  Set gifd.ModelTiepointTag, 33922
      %
      RasterTiepoint = [0 0 0];
      ModelTiepoint = [bbox(1) bbox(4) 0];
      gifd.ModelTiepointTag = [RasterTiepoint ModelTiepoint];
   else
      if isfield(option, 'ModelPixelScaleTag')
         gifd.ModelPixelScaleTag = option.ModelPixelScaleTag(:);
      else
%         error('ModelPixelScale is required when your Model Type is not Geographic.');
      end

      if isfield(option, 'ModelTiepointTag')
         gifd.ModelTiepointTag = option.ModelTiepointTag(:);
      end

      if isfield(option, 'ModelTransformationTag')
         gifd.ModelTransformationTag = option.ModelTransformationTag(:);
      end

      if ~isfield(option, 'ModelTiepointTag') & ~isfield(option, 'ModelTransformationTag')
         error('Either ModelTiepoint or ModelTransformation is required when your Model Type is not Geographic.');
      end
   end

   %  Write TIFF info
   %
   num_entry = 16;				% 16 basic entries

   if isfield(ifd, 'ColorMap')
      num_entry = num_entry + 1;
   end

   if isfield(ifd, 'ExtraSamples')
      num_entry = num_entry + 1;
   end

   if isfield(gifd, 'ModelPixelScaleTag')
      num_entry = num_entry + 1;
   end

   if isfield(gifd, 'ModelTiepointTag')
      num_entry = num_entry + 1;
   end

   if isfield(gifd, 'ModelTransformationTag')
      num_entry = num_entry + 1;
   end

   if GeoAsciiOffset > 0
      num_entry = num_entry + 1;
   end

   if GeoDoubleOffset > 0
      num_entry = num_entry + 1;
   end

   ifd_end = 8 + sum(ifd.StripByteCounts) + 2 + num_entry*12 + 4;
   fid = fopen(filename, 'wb', 'ieee-le');

   if fid < 0,
      msg = sprintf('Cannot create file "%s".', filename);
      error(msg);
   end

   fwrite(fid, 'II', 'uint8');			% Little-endian
   fwrite(fid, 42, 'uint16');			% TIFF signature
   fwrite(fid, (8 + sum(ifd.StripByteCounts)), 'uint32');	% IFD offset

   %  Write data strip
   %
   image = squeeze(permute(image, [3 2 1]));

   switch abs(bit_depth)
   case 1
      image = bit2byte(image);
      fwrite(fid, image, 'uint8');
   case 8
      fwrite(fid, image, 'uint8');
   case 16
      if isfield(ifd, 'ColorMap') | bit_depth == -16
         fwrite(fid, image, 'uint16');
      else
         fwrite(fid, image, 'int16');
      end
   case 32
      if bit_depth == -32
         fwrite(fid, image, 'int32');
      else
         fwrite(fid, image, 'single');
      end
   end

   fwrite(fid, num_entry, 'uint16');

   %  Entry 1
   %
   fwrite(fid, 256, 'uint16');
   fwrite(fid, 3, 'uint16');		% uint16
   fwrite(fid, 1, 'uint32');		% count
   fwrite(fid, ifd.ImageWidth, 'uint16');
   fwrite(fid, 0, 'uint16');

   %  Entry 2
   %
   fwrite(fid, 257, 'uint16');
   fwrite(fid, 3, 'uint16');		% uint16
   fwrite(fid, 1, 'uint32');		% count
   fwrite(fid, ifd.ImageLength, 'uint16');
   fwrite(fid, 0, 'uint16');

   %  Entry 3
   %
   fwrite(fid, 258, 'uint16');
   fwrite(fid, 3, 'uint16');		% uint16
   fwrite(fid, length(ifd.BitsPerSample), 'uint32');	% count

   if length(ifd.BitsPerSample) > 2
      fwrite(fid, ifd_end, 'uint32');
      ifd_end = ifd_end + length(ifd.BitsPerSample)*2;
   else
      fwrite(fid, ifd.BitsPerSample(1), 'uint16');

      if length(ifd.BitsPerSample) > 1
         fwrite(fid, ifd.BitsPerSample(2), 'uint16');
      else
         fwrite(fid, 0, 'uint16');
      end
   end

   %  Entry 4
   %
   fwrite(fid, 259, 'uint16');
   fwrite(fid, 3, 'uint16');		% uint16
   fwrite(fid, 1, 'uint32');		% count
   fwrite(fid, ifd.Compression, 'uint16');
   fwrite(fid, 0, 'uint16');

   %  Entry 5
   %
   fwrite(fid, 262, 'uint16');
   fwrite(fid, 3, 'uint16');		% uint16
   fwrite(fid, 1, 'uint32');		% count
   fwrite(fid, ifd.PhotometricInterpretation, 'uint16');
   fwrite(fid, 0, 'uint16');

   %  Entry 6
   %
   fwrite(fid, 273, 'uint16');		% StripOffsets
   fwrite(fid, 4, 'uint16');		% uint32
   fwrite(fid, ifd.ImageLength, 'uint32');	% count
   fwrite(fid, ifd_end, 'uint32');
   ifd_end = ifd_end + ifd.ImageLength*4;

   %  Entry 7
   %
   fwrite(fid, 274, 'uint16');
   fwrite(fid, 3, 'uint16');		% uint16
   fwrite(fid, 1, 'uint32');		% count
   fwrite(fid, ifd.Orientation, 'uint16');
   fwrite(fid, 0, 'uint16');

   %  Entry 8
   %
   fwrite(fid, 277, 'uint16');
   fwrite(fid, 3, 'uint16');		% uint16
   fwrite(fid, 1, 'uint32');		% count
   fwrite(fid, ifd.SamplesPerPixel, 'uint16');
   fwrite(fid, 0, 'uint16');

   %  Entry 9
   %
   fwrite(fid, 278, 'uint16');
   fwrite(fid, 3, 'uint16');		% uint16
   fwrite(fid, 1, 'uint32');		% count
   fwrite(fid, ifd.RowsPerStrip, 'uint16');
   fwrite(fid, 0, 'uint16');

   %  Entry 10
   %
   fwrite(fid, 279, 'uint16');		% StripByteCounts
   fwrite(fid, 4, 'uint16');		% uint32
   fwrite(fid, ifd.ImageLength, 'uint32');	% count
   fwrite(fid, ifd_end, 'uint32');
   ifd_end = ifd_end + ifd.ImageLength*4;

   %  Entry 11
   %
   fwrite(fid, 282, 'uint16');		% XResolution
   fwrite(fid, 5, 'uint16');		% uint16
   fwrite(fid, 1, 'uint32');		% count
   fwrite(fid, ifd_end, 'uint32');
   ifd_end = ifd_end + 2*4;

   %  Entry 12
   %
   fwrite(fid, 283, 'uint16');		% YResolution
   fwrite(fid, 5, 'uint16');		% uint16
   fwrite(fid, 1, 'uint32');		% count
   fwrite(fid, ifd_end, 'uint32');
   ifd_end = ifd_end + 2*4;

   %  Entry 13
   %
   fwrite(fid, 284, 'uint16');
   fwrite(fid, 3, 'uint16');		% uint16
   fwrite(fid, 1, 'uint32');		% count
   fwrite(fid, ifd.PlanarConfiguration, 'uint16');
   fwrite(fid, 0, 'uint16');

   %  Entry 14
   %
   fwrite(fid, 296, 'uint16');
   fwrite(fid, 3, 'uint16');		% uint16
   fwrite(fid, 1, 'uint32');		% count
   fwrite(fid, ifd.ResolutionUnit, 'uint16');
   fwrite(fid, 0, 'uint16');

   if isfield(option, 'ColorMap')
      fwrite(fid, 320, 'uint16');
      fwrite(fid, 3, 'uint16');		% uint16
      fwrite(fid, length(ifd.ColorMap), 'uint32');	% count
      fwrite(fid, ifd_end, 'uint32');
      ifd_end = ifd_end + length(ifd.ColorMap)*2;
   end

   if isfield(ifd, 'ExtraSamples')
      fwrite(fid, 338, 'uint16');
      fwrite(fid, 3, 'uint16');		% uint16
      fwrite(fid, length(ifd.ExtraSamples), 'uint32');	% count

      if length(ifd.ExtraSamples) > 2
         fwrite(fid, ifd_end, 'uint32');
         ifd_end = ifd_end + length(ifd.ExtraSamples)*2;
      else
         fwrite(fid, ifd.ExtraSamples(1), 'uint16');

         if length(ifd.ExtraSamples) > 1
            fwrite(fid, ifd.ExtraSamples(2), 'uint16');
         else
            fwrite(fid, 0, 'uint16');
         end
      end
   end

   %  Entry 15
   %
   fwrite(fid, 339, 'uint16');
   fwrite(fid, 3, 'uint16');		% uint16
   fwrite(fid, length(ifd.SampleFormat), 'uint32');	% count

   if length(ifd.SampleFormat) > 2
      fwrite(fid, ifd_end, 'uint32');
      ifd_end = ifd_end + length(ifd.SampleFormat)*2;
   else
      fwrite(fid, ifd.SampleFormat(1), 'uint16');

      if length(ifd.SampleFormat) > 1
         fwrite(fid, ifd.SampleFormat(2), 'uint16');
      else
         fwrite(fid, 0, 'uint16');
      end
   end

   if isfield(gifd, 'ModelPixelScaleTag')
      fwrite(fid, 33550, 'uint16');	% ModelPixelScaleTag
      fwrite(fid, 12, 'uint16');	% double
      fwrite(fid, 3, 'uint32');		% count
      fwrite(fid, ifd_end, 'uint32');
      ifd_end = ifd_end + 3*8;
   end

   if isfield(gifd, 'ModelTiepointTag')
      fwrite(fid, 33922, 'uint16');	% ModelTiepointTag
      fwrite(fid, 12, 'uint16');	% double
      fwrite(fid, length(gifd.ModelTiepointTag), 'uint32');	% count
      fwrite(fid, ifd_end, 'uint32');
      ifd_end = ifd_end + length(gifd.ModelTiepointTag)*8;
   end

   if isfield(gifd, 'ModelTransformationTag')
      fwrite(fid, 34264, 'uint16');	% ModelTransformationTag
      fwrite(fid, 12, 'uint16');	% double
      fwrite(fid, 16, 'uint32');	% count
      fwrite(fid, ifd_end, 'uint32');
      ifd_end = ifd_end + 16*8;
   end

   %  Entry 16
   %
   fwrite(fid, 34735, 'uint16');	% GeoKeyDirectoryTag
   fwrite(fid, 3, 'uint16');		% uint16
   fwrite(fid, prod(size(GeoKeyDirectoryTag)), 'uint32');	% count
   fwrite(fid, ifd_end, 'uint32');
   ifd_end = ifd_end + prod(size(GeoKeyDirectoryTag))*2;

   if GeoDoubleOffset > 0
      fwrite(fid, 34736, 'uint16');	% GeoDoubleParamsTag
      fwrite(fid, 12, 'uint16');	% double
      fwrite(fid, length(GeoDoubleParamsTag), 'uint32');	% count
      fwrite(fid, ifd_end, 'uint32');
      ifd_end = ifd_end + length(GeoDoubleParamsTag)*8;
   end

   if GeoAsciiOffset > 0
      GeoAsciiParamsTag = [GeoAsciiParamsTag; 0];	% TIFF6 requres NUL ending
      fwrite(fid, 34737, 'uint16');	% GeoAsciiParamsTag
      fwrite(fid, 2, 'uint16');		% ascii
      fwrite(fid, length(GeoAsciiParamsTag), 'uint32');		% count
      fwrite(fid, ifd_end, 'uint32');
      ifd_end = ifd_end + length(GeoAsciiParamsTag);
   end

   %  IFD is terminated with 4-byte offset to the next IFD,
   %  or 0 if there are none.
   %
   fwrite(fid, 0, 'uint32');

   if length(ifd.BitsPerSample) > 2
      fwrite(fid, ifd.BitsPerSample, 'uint16');		% 258
   end

   fwrite(fid, ifd.StripOffsets, 'uint32');		% 273
   fwrite(fid, ifd.StripByteCounts, 'uint32');		% 279
   fwrite(fid, ifd.XResolution, 'uint32');		% 282
   fwrite(fid, 1, 'uint32');				% 282
   fwrite(fid, ifd.YResolution, 'uint32');		% 283
   fwrite(fid, 1, 'uint32');				% 283

   if isfield(option, 'ColorMap')
      fwrite(fid, ifd.ColorMap, 'uint16');		% 320
   end

   if isfield(ifd, 'ExtraSamples') & length(ifd.ExtraSamples) > 2
      fwrite(fid, ifd.ExtraSamples, 'uint16');		% 338
   end

   if length(ifd.SampleFormat) > 2
      fwrite(fid, ifd.SampleFormat, 'uint16');		% 339
   end

   if isfield(gifd,'ModelPixelScaleTag') 
      fwrite(fid, gifd.ModelPixelScaleTag, 'double');	% 33550
   end

   if isfield(gifd,'ModelTiepointTag') 
      fwrite(fid, gifd.ModelTiepointTag, 'double');	% 33922
   end

   if isfield(gifd,'ModelTransformationTag')
      fwrite(fid, gifd.ModelTransformationTag, 'double'); % 34264
   end

   GeoKeyDirectoryTag = GeoKeyDirectoryTag';
   fwrite(fid, GeoKeyDirectoryTag, 'uint16');		% 34735

   if GeoDoubleOffset > 0
      fwrite(fid, GeoDoubleParamsTag, 'double');	% 34736
   end

   if GeoAsciiOffset > 0
      fwrite(fid, GeoAsciiParamsTag, 'uint8');		% 34737
   end

   fclose(fid);

   return;					% geotiffwrite


%------------------------------------------------------------------------
%  Convert bits to bytes to store
%
function byte = bit2byte(bit)

%   byte = bit(:);

   %  Pad with 0
   %
%   if mod(length(byte),8) ~= 0
 %     byte = [byte; zeros(8-mod(length(byte),8),1)];
  % end

   byte = reshape(bit, [8, length(bit(:))/8])';
   byte(find(byte>0)) = 1;
   byte(find(byte<1)) = 0;
%   byte = byte*[1 2 4 8 16 32 64 128]';
   byte = double(byte)*[128 64 32 16 8 4 2 1]';

   return;					% bit2byte

