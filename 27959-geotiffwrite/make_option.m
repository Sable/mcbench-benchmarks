%MAKE_OPTION  GUI to generate 'option' argument for geotiffwrite program
%
%  geotiffwrite.m is a MATLAB program to write 2D or 3D array to a single or
%  multi-band GeoTIFF file. However, the nature of GeoTIFF format requires
%  you to specify a couple to a dozens of Tags or GeoKeys in the 'option'
%  argument of the geotiffwrite program. This could be a bit of pain.
%
%  With this make_option.m program, you will find that it is a lot easier to
%  generate the 'option' argument by selecting whatever matches you. You can
%  provide only the required fields, or you can specify standard optional or
%  even user-defined optional fields.
%
%  If the ModelType is Geographic, and you have bbox (a required argument in
%  geotiffwrite.m, but optional here) argument, the PixelScale and Tiepoint
%  fields will be grayed out, which means that you don't have to worry about
%  them.
%
%  Usage:  [option bbox] = make_option([bbox]);
%          geotiffwrite(filename, bbox, image, [bit_depth, option]);
%
%  Example:  [option bbox] = make_option;
%            geotiffwrite('MyFile.TIF', bbox, img, 8, option);
%
%  bbox - (optional) Bounding box with West/East of longitude and South/North
%         of latitude. The latitude & longitude must be in Decimal Degree
%         (DD) format, and they must be in a 2x2 array with the order
%         of:
%               [  longitude_West,  latitude_South;
%		   longitude_East,  latitude_North  ]
%
%         If GTModelTypeGeoKey is not ModelTypeGeographic, bbox will
%         be reset to empty.
%
%  - Jimmy Shen (jimmy@rotman-baycrest.on.ca)
%
function [opt, bbox] = make_option(action)

   if ~exist('action','var')
      action = [];
   end

   if isnumeric(action)
      init(action);
      uiwait(gcf);
      opt = getappdata(gcf, 'opt');
      bbox = getappdata(gcf, 'bbox');
      close(gcf);
      return;
   elseif ischar(action)
      switch action
      case 'modeltype'
         tmp = get(findobj(gcf,'tag','GTModelTypeGeoKey'),'value');
         bbox = getappdata(gcf, 'bbox');

         if tmp ~= 2 | isempty(bbox)
            set(findobj(gcf,'tag','ModelPixelScaleTag_x'),'back',[1 1 1],'enable','on','string','');
            set(findobj(gcf,'tag','ModelPixelScaleTag_y'),'back',[1 1 1],'enable','on','string','');
            set(findobj(gcf,'tag','ModelPixelScaleTag_z'),'back',[1 1 1],'enable','on','string','0');
            set(findobj(gcf,'tag','ModelTiepointTag_i'),'back',[1 1 1],'enable','on','string','0');
            set(findobj(gcf,'tag','ModelTiepointTag_j'),'back',[1 1 1],'enable','on','string','0');
            set(findobj(gcf,'tag','ModelTiepointTag_k'),'back',[1 1 1],'enable','on','string','0');
            set(findobj(gcf,'tag','ModelTiepointTag_x'),'back',[1 1 1],'enable','on','string','');
            set(findobj(gcf,'tag','ModelTiepointTag_y'),'back',[1 1 1],'enable','on','string','');
            set(findobj(gcf,'tag','ModelTiepointTag_z'),'back',[1 1 1],'enable','on','string','0');
         else
            set(findobj(gcf,'tag','ModelPixelScaleTag_x'),'back',[0.9 0.9 0.9],'enable','inactive','string','');
            set(findobj(gcf,'tag','ModelPixelScaleTag_y'),'back',[0.9 0.9 0.9],'enable','inactive','string','');
            set(findobj(gcf,'tag','ModelPixelScaleTag_z'),'back',[0.9 0.9 0.9],'enable','inactive','string','0');
            set(findobj(gcf,'tag','ModelTiepointTag_i'),'back',[0.9 0.9 0.9],'enable','inactive','string','0');
            set(findobj(gcf,'tag','ModelTiepointTag_j'),'back',[0.9 0.9 0.9],'enable','inactive','string','0');
            set(findobj(gcf,'tag','ModelTiepointTag_k'),'back',[0.9 0.9 0.9],'enable','inactive','string','0');
            set(findobj(gcf,'tag','ModelTiepointTag_x'),'back',[0.9 0.9 0.9],'enable','inactive','string','');
            set(findobj(gcf,'tag','ModelTiepointTag_y'),'back',[0.9 0.9 0.9],'enable','inactive','string','');
            set(findobj(gcf,'tag','ModelTiepointTag_z'),'back',[0.9 0.9 0.9],'enable','inactive','string','0');
         end
      case 'ok'
         checkout;
         uiresume(gcf);
      case 'cancel'
         setappdata(gcf, 'opt', []);
         uiresume(gcf);
      otherwise
         help make_option;
         error('Incorrect input');
      end
   else
      help make_option;
      error('Incorrect input');
   end

   return;						% make_option


%------------------------------------------------------------------------
function init(bbox)

   w = 0.95;
   h = 0.85;
   x = (1-w)/2;
   y = (1-h)/2;
   pos = [x y w h];

   h0 = figure('unit','normal', ...
        'numberTitle','off', ...
        'menubar', 'none', ...
        'toolbar','none', ...
        'name', 'Generate option argument for geotiffwrite', ...
	'color',[0.8 0.8 0.8], ...
        'position', pos);

   fnt = 0.4;

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   x = 0.01;
   y = 0.94;
   h = 0.04;
   w = 1;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'fore',[1 0 0], ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
	'fontweight','bold', ...
   	'FontSize',fnt+0.2, ...
        'Position',pos, ...
        'String','The following fields are required, unless they are grayed out (Selecting ''user-defined'' choice is not recommended):', ...
   	'Tag','');

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   x = 0.01;
   y = y - 0.05;
   h = 0.04;
   w = 0.06;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','RasterType', ...
   	'Tag','');

   x = x + 0.06;
   w = 0.12;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','popupmenu', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String',{'RasterPixelIsArea','RasterPixelIsPoint','user-defined'}, ...
   	'Tag','GTRasterTypeGeoKey');

   x = x + 0.14;
   w = 0.06;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','ModelType', ...
   	'Tag','');

   x = x + 0.06;
   w = 0.14;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','popupmenu', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String',{'ModelTypeProjected','ModelTypeGeographic','ModelTypeGeocentric','user-defined'}, ...
	'value',2, ...
   	'callback','make_option(''modeltype'');', ...
   	'Tag','GTModelTypeGeoKey');

   x = x + 0.16;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','PixelScale', ...
   	'Tag','');

   x = x + 0.05;
   w = 0.02;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','right', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','X ', ...
   	'Tag','');

   x = x + 0.02;
   w = 0.03;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','', ...
   	'Tag','ModelPixelScaleTag_x');

   x = x + 0.03;
   w = 0.02;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','right', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','Y ', ...
   	'Tag','');

   x = x + 0.02;
   w = 0.03;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','', ...
   	'Tag','ModelPixelScaleTag_y');

   x = x + 0.03;
   w = 0.02;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','right', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','Z ', ...
   	'Tag','');

   x = x + 0.02;
   w = 0.03;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','0', ...
   	'Tag','ModelPixelScaleTag_z');

   x = x + 0.05;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','Tiepoint', ...
   	'Tag','');

   x = x + 0.05;
   w = 0.01;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','right', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','I ', ...
   	'Tag','');

   x = x + 0.01;
   w = 0.03;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','0', ...
   	'Tag','ModelTiepointTag_i');

   x = x + 0.03;
   w = 0.02;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','right', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','J ', ...
   	'Tag','');

   x = x + 0.02;
   w = 0.03;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','0', ...
   	'Tag','ModelTiepointTag_j');

   x = x + 0.03;
   w = 0.02;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','right', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','K ', ...
   	'Tag','');

   x = x + 0.02;
   w = 0.03;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','0', ...
   	'Tag','ModelTiepointTag_k');

   x = x + 0.03;
   w = 0.02;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','right', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','X ', ...
   	'Tag','');

   x = x + 0.02;
   w = 0.03;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','', ...
   	'Tag','ModelTiepointTag_x');

   x = x + 0.03;
   w = 0.02;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','right', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','Y ', ...
   	'Tag','');

   x = x + 0.02;
   w = 0.03;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','', ...
   	'Tag','ModelTiepointTag_y');

   x = x + 0.03;
   w = 0.02;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','right', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','Z ', ...
   	'Tag','');

   x = x + 0.02;
   w = 0.03;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','0', ...
   	'Tag','ModelTiepointTag_z');

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   x = 0.01;
   y = y - 0.05;
   w = 1;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','If obtained ''info'' from MATLAB Mapping Toolbox''s geotiffinfo.m, you can set the fields above like this: PixelScale.X=info.PixelScale(1); PixelScale.Y=info.PixelScale(2); PixelScale.Z=info.PixelScale(3);', ...
   	'Tag','');

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   x = 0.01;
   y = y - 0.03;
   w = 1;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','Tiepoint.X=info.TiePoints.WorldPoints.X; (info.TiePoints.WorldPoints(1) in old MATLAB); Tiepoint.Y=info.TiePoints.WorldPoints.Y; (info.TiePoints.WorldPoints(2) in old MATLAB); Tiepoint.Z=0;', ...
   	'Tag','');

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   x = 0.01;
   y = y - 0.03;
   w = 1;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','ModelType=info.ModelType; but please keep: Tiepoint.I=0; Tiepoint.J=0; Tiepoint.K=0; instead of info.TiePoints.ImagePoints.', ...
   	'Tag','');

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   x = 0.01;
   y = y - 0.06;
   w = 1;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'fore',[1 0 0], ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
	'fontweight','bold', ...
   	'FontSize',fnt+0.2, ...
        'Position',pos, ...
        'String','The following fields are optional, please select or fill whatever you know (Avoid using ''user-defined'', if possible):', ...
   	'Tag','');

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   x = 0.01;
   y = y - 0.05;
   w = 0.09;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','GeographicType', ...
   	'Tag','');

   str = {''
'GCS_Adindan'
'GCS_AGD66'
'GCS_AGD84'
'GCS_Ain_el_Abd'
'GCS_Afgooye'
'GCS_Agadez'
'GCS_Lisbon'
'GCS_Aratu'
'GCS_Arc_1950'
'GCS_Arc_1960'
'GCS_Batavia'
'GCS_Barbados'
'GCS_Beduaram'
'GCS_Beijing_1954'
'GCS_Belge_1950'
'GCS_Bermuda_1957'
'GCS_Bern_1898'
'GCS_Bogota'
'GCS_Bukit_Rimpah'
'GCS_Camacupa'
'GCS_Campo_Inchauspe'
'GCS_Cape'
'GCS_Carthage'
'GCS_Chua'
'GCS_Corrego_Alegre'
'GCS_Cote_d_Ivoire'
'GCS_Deir_ez_Zor'
'GCS_Douala'
'GCS_Egypt_1907'
'GCS_ED50'
'GCS_ED87'
'GCS_Fahud'
'GCS_Gandajika_1970'
'GCS_Garoua'
'GCS_Guyane_Francaise'
'GCS_Hu_Tzu_Shan'
'GCS_HD72'
'GCS_ID74'
'GCS_Indian_1954'
'GCS_Indian_1975'
'GCS_Jamaica_1875'
'GCS_JAD69'
'GCS_Kalianpur'
'GCS_Kandawala'
'GCS_Kertau'
'GCS_KOC'
'GCS_La_Canoa'
'GCS_PSAD56'
'GCS_Lake'
'GCS_Leigon'
'GCS_Liberia_1964'
'GCS_Lome'
'GCS_Luzon_1911'
'GCS_Hito_XVIII_1963'
'GCS_Herat_North'
'GCS_Mahe_1971'
'GCS_Makassar'
'GCS_EUREF89'
'GCS_Malongo_1987'
'GCS_Manoca'
'GCS_Merchich'
'GCS_Massawa'
'GCS_Minna'
'GCS_Mhast'
'GCS_Monte_Mario'
'GCS_M_poraloko'
'GCS_NAD27'
'GCS_NAD_Michigan'
'GCS_NAD83'
'GCS_Nahrwan_1967'
'GCS_Naparima_1972'
'GCS_GD49'
'GCS_NGO_1948'
'GCS_Datum_73'
'GCS_NTF'
'GCS_NSWC_9Z_2'
'GCS_OSGB_1936'
'GCS_OSGB70'
'GCS_OS_SN80'
'GCS_Padang'
'GCS_Palestine_1923'
'GCS_Pointe_Noire'
'GCS_GDA94'
'GCS_Pulkovo_1942'
'GCS_Qatar'
'GCS_Qatar_1948'
'GCS_Qornoq'
'GCS_Loma_Quintana'
'GCS_Amersfoort'
'GCS_RT38'
'GCS_SAD69'
'GCS_Sapper_Hill_1943'
'GCS_Schwarzeck'
'GCS_Segora'
'GCS_Serindung'
'GCS_Sudan'
'GCS_Tananarive'
'GCS_Timbalai_1948'
'GCS_TM65'
'GCS_TM75'
'GCS_Tokyo'
'GCS_Trinidad_1903'
'GCS_TC_1948'
'GCS_Voirol_1875'
'GCS_Voirol_Unifie'
'GCS_Bern_1938'
'GCS_Nord_Sahara_1959'
'GCS_Stockholm_1938'
'GCS_Yacare'
'GCS_Yoff'
'GCS_Zanderij'
'GCS_MGI'
'GCS_Belge_1972'
'GCS_DHDN'
'GCS_Conakry_1905'
'GCS_WGS_72'
'GCS_WGS_72BE'
'GCS_WGS_84'
'GCS_Bern_1898_Bern'
'GCS_Bogota_Bogota'
'GCS_Lisbon_Lisbon'
'GCS_Makassar_Jakarta'
'GCS_MGI_Ferro'
'GCS_Monte_Mario_Rome'
'GCS_NTF_Paris'
'GCS_Padang_Jakarta'
'GCS_Belge_1950_Brussels'
'GCS_Tananarive_Paris'
'GCS_Voirol_1875_Paris'
'GCS_Voirol_Unifie_Paris'
'GCS_Batavia_Jakarta'
'GCS_ATF_Paris'
'GCS_NDG_Paris'
'GCSE_Airy1830'
'GCSE_AiryModified1849'
'GCSE_AustralianNationalSpheroid'
'GCSE_Bessel1841'
'GCSE_BesselModified'
'GCSE_BesselNamibia'
'GCSE_Clarke1858'
'GCSE_Clarke1866'
'GCSE_Clarke1866Michigan'
'GCSE_Clarke1880_Benoit'
'GCSE_Clarke1880_IGN'
'GCSE_Clarke1880_RGS'
'GCSE_Clarke1880_Arc'
'GCSE_Clarke1880_SGA1922'
'GCSE_Everest1830_1937Adjustment'
'GCSE_Everest1830_1967Definition'
'GCSE_Everest1830_1975Definition'
'GCSE_Everest1830Modified'
'GCSE_GRS1980'
'GCSE_Helmert1906'
'GCSE_IndonesianNationalSpheroid'
'GCSE_International1924'
'GCSE_International1967'
'GCSE_Krassowsky1940'
'GCSE_NWL9D'
'GCSE_NWL10D'
'GCSE_Plessis1817'
'GCSE_Struve1860'
'GCSE_WarOffice'
'GCSE_WGS84'
'GCSE_GEM10C'
'GCSE_OSU86F'
'GCSE_OSU91A'
'GCSE_Clarke1880'
'GCSE_Sphere'
'user-defined'};

   x = x + 0.09;
   w = 0.22;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','popupmenu', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String',str, ...
   	'Tag','GeographicTypeGeoKey');

   x = x + 0.24;
   w = 0.09;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','GeodeticDatum', ...
   	'Tag','');

   str = {''
'Datum_Adindan'
'Datum_Australian_Geodetic_Datum_1966'
'Datum_Australian_Geodetic_Datum_1984'
'Datum_Ain_el_Abd_1970'
'Datum_Afgooye'
'Datum_Agadez'
'Datum_Lisbon'
'Datum_Aratu'
'Datum_Arc_1950'
'Datum_Arc_1960'
'Datum_Batavia'
'Datum_Barbados'
'Datum_Beduaram'
'Datum_Beijing_1954'
'Datum_Reseau_National_Belge_1950'
'Datum_Bermuda_1957'
'Datum_Bern_1898'
'Datum_Bogota'
'Datum_Bukit_Rimpah'
'Datum_Camacupa'
'Datum_Campo_Inchauspe'
'Datum_Cape'
'Datum_Carthage'
'Datum_Chua'
'Datum_Corrego_Alegre'
'Datum_Cote_d_Ivoire'
'Datum_Deir_ez_Zor'
'Datum_Douala'
'Datum_Egypt_1907'
'Datum_European_Datum_1950'
'Datum_European_Datum_1987'
'Datum_Fahud'
'Datum_Gandajika_1970'
'Datum_Garoua'
'Datum_Guyane_Francaise'
'Datum_Hu_Tzu_Shan'
'Datum_Hungarian_Datum_1972'
'Datum_Indonesian_Datum_1974'
'Datum_Indian_1954'
'Datum_Indian_1975'
'Datum_Jamaica_1875'
'Datum_Jamaica_1969'
'Datum_Kalianpur'
'Datum_Kandawala'
'Datum_Kertau'
'Datum_Kuwait_Oil_Company'
'Datum_La_Canoa'
'Datum_Provisional_S_American_Datum_1956'
'Datum_Lake'
'Datum_Leigon'
'Datum_Liberia_1964'
'Datum_Lome'
'Datum_Luzon_1911'
'Datum_Hito_XVIII_1963'
'Datum_Herat_North'
'Datum_Mahe_1971'
'Datum_Makassar'
'Datum_European_Reference_System_1989'
'Datum_Malongo_1987'
'Datum_Manoca'
'Datum_Merchich'
'Datum_Massawa'
'Datum_Minna'
'Datum_Mhast'
'Datum_Monte_Mario'
'Datum_M_poraloko'
'Datum_North_American_Datum_1927'
'Datum_NAD_Michigan'
'Datum_North_American_Datum_1983'
'Datum_Nahrwan_1967'
'Datum_Naparima_1972'
'Datum_New_Zealand_Geodetic_Datum_1949'
'Datum_NGO_1948'
'Datum_Datum_73'
'Datum_Nouvelle_Triangulation_Francaise'
'Datum_NSWC_9Z_2'
'Datum_OSGB_1936'
'Datum_OSGB_1970_SN'
'Datum_OS_SN_1980'
'Datum_Padang_1884'
'Datum_Palestine_1923'
'Datum_Pointe_Noire'
'Datum_Geocentric_Datum_of_Australia_1994'
'Datum_Pulkovo_1942'
'Datum_Qatar'
'Datum_Qatar_1948'
'Datum_Qornoq'
'Datum_Loma_Quintana'
'Datum_Amersfoort'
'Datum_RT38'
'Datum_South_American_Datum_1969'
'Datum_Sapper_Hill_1943'
'Datum_Schwarzeck'
'Datum_Segora'
'Datum_Serindung'
'Datum_Sudan'
'Datum_Tananarive_1925'
'Datum_Timbalai_1948'
'Datum_TM65'
'Datum_TM75'
'Datum_Tokyo'
'Datum_Trinidad_1903'
'Datum_Trucial_Coast_1948'
'Datum_Voirol_1875'
'Datum_Voirol_Unifie_1960'
'Datum_Bern_1938'
'Datum_Nord_Sahara_1959'
'Datum_Stockholm_1938'
'Datum_Yacare'
'Datum_Yoff'
'Datum_Zanderij'
'Datum_Militar_Geographische_Institut'
'Datum_Reseau_National_Belge_1972'
'Datum_Deutsche_Hauptdreiecksnetz'
'Datum_Conakry_1905'
'Datum_WGS72'
'Datum_WGS72_Transit_Broadcast_Ephemeris'
'Datum_WGS84'
'Datum_Ancienne_Triangulation_Francaise'
'Datum_Nord_de_Guerre'
'DatumE_Airy1830'
'DatumE_AiryModified1849'
'DatumE_AustralianNationalSpheroid'
'DatumE_Bessel1841'
'DatumE_BesselModified'
'DatumE_BesselNamibia'
'DatumE_Clarke1858'
'DatumE_Clarke1866'
'DatumE_Clarke1866Michigan'
'DatumE_Clarke1880_Benoit'
'DatumE_Clarke1880_IGN'
'DatumE_Clarke1880_RGS'
'DatumE_Clarke1880_Arc'
'DatumE_Clarke1880_SGA1922'
'DatumE_Everest1830_1937Adjustment'
'DatumE_Everest1830_1967Definition'
'DatumE_Everest1830_1975Definition'
'DatumE_Everest1830Modified'
'DatumE_GRS1980'
'DatumE_Helmert1906'
'DatumE_IndonesianNationalSpheroid'
'DatumE_International1924'
'DatumE_International1967'
'DatumE_Krassowsky1960'
'DatumE_NWL9D'
'DatumE_NWL10D'
'DatumE_Plessis1817'
'DatumE_Struve1860'
'DatumE_WarOffice'
'DatumE_WGS84'
'DatumE_GEM10C'
'DatumE_OSU86F'
'DatumE_OSU91A'
'DatumE_Clarke1880'
'DatumE_Sphere'
'user-defined'};

   x = x + 0.09;
   w = 0.26;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','popupmenu', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String',str, ...
   	'Tag','GeogGeodeticDatumGeoKey');

   x = x + 0.28;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','Ellipsoid', ...
   	'Tag','');

   str = {''
'Ellipse_Airy_1830'
'Ellipse_Airy_Modified_1849'
'Ellipse_Australian_National_Spheroid'
'Ellipse_Bessel_1841'
'Ellipse_Bessel_Modified'
'Ellipse_Bessel_Namibia'
'Ellipse_Clarke_1858'
'Ellipse_Clarke_1866'
'Ellipse_Clarke_1866_Michigan'
'Ellipse_Clarke_1880_Benoit'
'Ellipse_Clarke_1880_IGN'
'Ellipse_Clarke_1880_RGS'
'Ellipse_Clarke_1880_Arc'
'Ellipse_Clarke_1880_SGA_1922'
'Ellipse_Everest_1830_1937_Adjustment'
'Ellipse_Everest_1830_1967_Definition'
'Ellipse_Everest_1830_1975_Definition'
'Ellipse_Everest_1830_Modified'
'Ellipse_GRS_1980'
'Ellipse_Helmert_1906'
'Ellipse_Indonesian_National_Spheroid'
'Ellipse_International_1924'
'Ellipse_International_1967'
'Ellipse_Krassowsky_1940'
'Ellipse_NWL_9D'
'Ellipse_NWL_10D'
'Ellipse_Plessis_1817'
'Ellipse_Struve_1860'
'Ellipse_War_Office'
'Ellipse_WGS_84'
'Ellipse_GEM_10C'
'Ellipse_OSU86F'
'Ellipse_OSU91A'
'Ellipse_Clarke_1880'
'Ellipse_Sphere'
'user-defined'};

   x = x + 0.05;
   w = 0.23;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','popupmenu', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String',str, ...
   	'Tag','GeogEllipsoidGeoKey');

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   x = 0.01;
   y = y - 0.05;
   w = 0.09;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','GeogLinearUnits', ...
   	'Tag','');

   str = {''
'Meter'
'Foot'
'Foot_US_Survey'
'Foot_Modified_American'
'Foot_Clarke'
'Foot_Indian'
'Link'
'Link_Benoit'
'Link_Sears'
'Chain_Benoit'
'Chain_Sears'
'Yard_Sears'
'Yard_Indian'
'Fathom'
'Mile_International_Nautical'
'user-defined'};

   x = x + 0.09;
   w = 0.18;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','popupmenu', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String',str, ...
   	'Tag','GeogLinearUnitsGeoKey');

   x = x + 0.20;
   w = 0.07;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','AngularUnits', ...
   	'Tag','');

   str = {''
'Radian'
'Degree'
'Arc_Minute'
'Arc_Second'
'Grad'
'Gon'
'DMS'
'DMS_Hemisphere'
'user-defined'};

   x = x + 0.07;
   w = 0.16;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','popupmenu', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String',str, ...
   	'Tag','GeogAngularUnitsGeoKey');

   x = x + 0.18;
   w = 0.07;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','AzimuthUnits', ...
   	'Tag','');

   str = {''
'Radian'
'Degree'
'Arc_Minute'
'Arc_Second'
'Grad'
'Gon'
'DMS'
'DMS_Hemisphere'
'user-defined'};

   x = x + 0.07;
   w = 0.16;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','popupmenu', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String',str, ...
   	'Tag','GeogAzimuthUnitsGeoKey');

   x = x + 0.18;
   w = 0.08;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','PrimeMeridian', ...
   	'Tag','');

   str = {''
'PM_Greenwich'
'PM_Lisbon'
'PM_Paris'
'PM_Bogota'
'PM_Madrid'
'PM_Rome'
'PM_Bern'
'PM_Jakarta'
'PM_Ferro'
'PM_Brussels'
'PM_Stockholm'
'user-defined'};

   x = x + 0.08;
   w = 0.11;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','popupmenu', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String',str, ...
   	'Tag','GeogPrimeMeridianGeoKey');

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   x = 0.01;
   y = y - 0.05;
   w = 0.09;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','ProjectedCSType', ...
   	'Tag','');

   str = {''
'PCS_Adindan_UTM_zone_37N'
'PCS_Adindan_UTM_zone_38N'
'PCS_AGD66_AMG_zone_48'
'PCS_AGD66_AMG_zone_49'
'PCS_AGD66_AMG_zone_50'
'PCS_AGD66_AMG_zone_51'
'PCS_AGD66_AMG_zone_52'
'PCS_AGD66_AMG_zone_53'
'PCS_AGD66_AMG_zone_54'
'PCS_AGD66_AMG_zone_55'
'PCS_AGD66_AMG_zone_56'
'PCS_AGD66_AMG_zone_57'
'PCS_AGD66_AMG_zone_58'
'PCS_AGD84_AMG_zone_48'
'PCS_AGD84_AMG_zone_49'
'PCS_AGD84_AMG_zone_50'
'PCS_AGD84_AMG_zone_51'
'PCS_AGD84_AMG_zone_52'
'PCS_AGD84_AMG_zone_53'
'PCS_AGD84_AMG_zone_54'
'PCS_AGD84_AMG_zone_55'
'PCS_AGD84_AMG_zone_56'
'PCS_AGD84_AMG_zone_57'
'PCS_AGD84_AMG_zone_58'
'PCS_Ain_el_Abd_UTM_zone_37N'
'PCS_Ain_el_Abd_UTM_zone_38N'
'PCS_Ain_el_Abd_UTM_zone_39N'
'PCS_Ain_el_Abd_Bahrain_Grid'
'PCS_Afgooye_UTM_zone_38N'
'PCS_Afgooye_UTM_zone_39N'
'PCS_Lisbon_Portugese_Grid'
'PCS_Aratu_UTM_zone_22S'
'PCS_Aratu_UTM_zone_23S'
'PCS_Aratu_UTM_zone_24S'
'PCS_Arc_1950_Lo13'
'PCS_Arc_1950_Lo15'
'PCS_Arc_1950_Lo17'
'PCS_Arc_1950_Lo19'
'PCS_Arc_1950_Lo21'
'PCS_Arc_1950_Lo23'
'PCS_Arc_1950_Lo25'
'PCS_Arc_1950_Lo27'
'PCS_Arc_1950_Lo29'
'PCS_Arc_1950_Lo31'
'PCS_Arc_1950_Lo33'
'PCS_Arc_1950_Lo35'
'PCS_Batavia_NEIEZ'
'PCS_Batavia_UTM_zone_48S'
'PCS_Batavia_UTM_zone_49S'
'PCS_Batavia_UTM_zone_50S'
'PCS_Beijing_Gauss_zone_13'
'PCS_Beijing_Gauss_zone_14'
'PCS_Beijing_Gauss_zone_15'
'PCS_Beijing_Gauss_zone_16'
'PCS_Beijing_Gauss_zone_17'
'PCS_Beijing_Gauss_zone_18'
'PCS_Beijing_Gauss_zone_19'
'PCS_Beijing_Gauss_zone_20'
'PCS_Beijing_Gauss_zone_21'
'PCS_Beijing_Gauss_zone_22'
'PCS_Beijing_Gauss_zone_23'
'PCS_Beijing_Gauss_13N'
'PCS_Beijing_Gauss_14N'
'PCS_Beijing_Gauss_15N'
'PCS_Beijing_Gauss_16N'
'PCS_Beijing_Gauss_17N'
'PCS_Beijing_Gauss_18N'
'PCS_Beijing_Gauss_19N'
'PCS_Beijing_Gauss_20N'
'PCS_Beijing_Gauss_21N'
'PCS_Beijing_Gauss_22N'
'PCS_Beijing_Gauss_23N'
'PCS_Belge_Lambert_50'
'PCS_Bern_1898_Swiss_Old'
'PCS_Bogota_UTM_zone_17N'
'PCS_Bogota_UTM_zone_18N'
'PCS_Bogota_Colombia_3W'
'PCS_Bogota_Colombia_Bogota'
'PCS_Bogota_Colombia_3E'
'PCS_Bogota_Colombia_6E'
'PCS_Camacupa_UTM_32S'
'PCS_Camacupa_UTM_33S'
'PCS_C_Inchauspe_Argentina_1'
'PCS_C_Inchauspe_Argentina_2'
'PCS_C_Inchauspe_Argentina_3'
'PCS_C_Inchauspe_Argentina_4'
'PCS_C_Inchauspe_Argentina_5'
'PCS_C_Inchauspe_Argentina_6'
'PCS_C_Inchauspe_Argentina_7'
'PCS_Carthage_UTM_zone_32N'
'PCS_Carthage_Nord_Tunisie'
'PCS_Carthage_Sud_Tunisie'
'PCS_Corrego_Alegre_UTM_23S'
'PCS_Corrego_Alegre_UTM_24S'
'PCS_Douala_UTM_zone_32N'
'PCS_Egypt_1907_Red_Belt'
'PCS_Egypt_1907_Purple_Belt'
'PCS_Egypt_1907_Ext_Purple'
'PCS_ED50_UTM_zone_28N'
'PCS_ED50_UTM_zone_29N'
'PCS_ED50_UTM_zone_30N'
'PCS_ED50_UTM_zone_31N'
'PCS_ED50_UTM_zone_32N'
'PCS_ED50_UTM_zone_33N'
'PCS_ED50_UTM_zone_34N'
'PCS_ED50_UTM_zone_35N'
'PCS_ED50_UTM_zone_36N'
'PCS_ED50_UTM_zone_37N'
'PCS_ED50_UTM_zone_38N'
'PCS_Fahud_UTM_zone_39N'
'PCS_Fahud_UTM_zone_40N'
'PCS_Garoua_UTM_zone_33N'
'PCS_ID74_UTM_zone_46N'
'PCS_ID74_UTM_zone_47N'
'PCS_ID74_UTM_zone_48N'
'PCS_ID74_UTM_zone_49N'
'PCS_ID74_UTM_zone_50N'
'PCS_ID74_UTM_zone_51N'
'PCS_ID74_UTM_zone_52N'
'PCS_ID74_UTM_zone_53N'
'PCS_ID74_UTM_zone_46S'
'PCS_ID74_UTM_zone_47S'
'PCS_ID74_UTM_zone_48S'
'PCS_ID74_UTM_zone_49S'
'PCS_ID74_UTM_zone_50S'
'PCS_ID74_UTM_zone_51S'
'PCS_ID74_UTM_zone_52S'
'PCS_ID74_UTM_zone_53S'
'PCS_ID74_UTM_zone_54S'
'PCS_Indian_1954_UTM_47N'
'PCS_Indian_1954_UTM_48N'
'PCS_Indian_1975_UTM_47N'
'PCS_Indian_1975_UTM_48N'
'PCS_Jamaica_1875_Old_Grid'
'PCS_JAD69_Jamaica_Grid'
'PCS_Kalianpur_India_0'
'PCS_Kalianpur_India_I'
'PCS_Kalianpur_India_IIa'
'PCS_Kalianpur_India_IIIa'
'PCS_Kalianpur_India_IVa'
'PCS_Kalianpur_India_IIb'
'PCS_Kalianpur_India_IIIb'
'PCS_Kalianpur_India_IVb'
'PCS_Kertau_Singapore_Grid'
'PCS_Kertau_UTM_zone_47N'
'PCS_Kertau_UTM_zone_48N'
'PCS_La_Canoa_UTM_zone_20N'
'PCS_La_Canoa_UTM_zone_21N'
'PCS_PSAD56_UTM_zone_18N'
'PCS_PSAD56_UTM_zone_19N'
'PCS_PSAD56_UTM_zone_20N'
'PCS_PSAD56_UTM_zone_21N'
'PCS_PSAD56_UTM_zone_17S'
'PCS_PSAD56_UTM_zone_18S'
'PCS_PSAD56_UTM_zone_19S'
'PCS_PSAD56_UTM_zone_20S'
'PCS_PSAD56_Peru_west_zone'
'PCS_PSAD56_Peru_central'
'PCS_PSAD56_Peru_east_zone'
'PCS_Leigon_Ghana_Grid'
'PCS_Lome_UTM_zone_31N'
'PCS_Luzon_Philippines_I'
'PCS_Luzon_Philippines_II'
'PCS_Luzon_Philippines_III'
'PCS_Luzon_Philippines_IV'
'PCS_Luzon_Philippines_V'
'PCS_Makassar_NEIEZ'
'PCS_Malongo_1987_UTM_32S'
'PCS_Merchich_Nord_Maroc'
'PCS_Merchich_Sud_Maroc'
'PCS_Merchich_Sahara'
'PCS_Massawa_UTM_zone_37N'
'PCS_Minna_UTM_zone_31N'
'PCS_Minna_UTM_zone_32N'
'PCS_Minna_Nigeria_West'
'PCS_Minna_Nigeria_Mid_Belt'
'PCS_Minna_Nigeria_East'
'PCS_Mhast_UTM_zone_32S'
'PCS_Monte_Mario_Italy_1'
'PCS_Monte_Mario_Italy_2'
'PCS_M_poraloko_UTM_32N'
'PCS_M_poraloko_UTM_32S'
'PCS_NAD27_UTM_zone_3N'
'PCS_NAD27_UTM_zone_4N'
'PCS_NAD27_UTM_zone_5N'
'PCS_NAD27_UTM_zone_6N'
'PCS_NAD27_UTM_zone_7N'
'PCS_NAD27_UTM_zone_8N'
'PCS_NAD27_UTM_zone_9N'
'PCS_NAD27_UTM_zone_10N'
'PCS_NAD27_UTM_zone_11N'
'PCS_NAD27_UTM_zone_12N'
'PCS_NAD27_UTM_zone_13N'
'PCS_NAD27_UTM_zone_14N'
'PCS_NAD27_UTM_zone_15N'
'PCS_NAD27_UTM_zone_16N'
'PCS_NAD27_UTM_zone_17N'
'PCS_NAD27_UTM_zone_18N'
'PCS_NAD27_UTM_zone_19N'
'PCS_NAD27_UTM_zone_20N'
'PCS_NAD27_UTM_zone_21N'
'PCS_NAD27_UTM_zone_22N'
'PCS_NAD27_Alabama_East'
'PCS_NAD27_Alabama_West'
'PCS_NAD27_Alaska_zone_1'
'PCS_NAD27_Alaska_zone_2'
'PCS_NAD27_Alaska_zone_3'
'PCS_NAD27_Alaska_zone_4'
'PCS_NAD27_Alaska_zone_5'
'PCS_NAD27_Alaska_zone_6'
'PCS_NAD27_Alaska_zone_7'
'PCS_NAD27_Alaska_zone_8'
'PCS_NAD27_Alaska_zone_9'
'PCS_NAD27_Alaska_zone_10'
'PCS_NAD27_California_I'
'PCS_NAD27_California_II'
'PCS_NAD27_California_III'
'PCS_NAD27_California_IV'
'PCS_NAD27_California_V'
'PCS_NAD27_California_VI'
'PCS_NAD27_California_VII'
'PCS_NAD27_Arizona_East'
'PCS_NAD27_Arizona_Central'
'PCS_NAD27_Arizona_West'
'PCS_NAD27_Arkansas_North'
'PCS_NAD27_Arkansas_South'
'PCS_NAD27_Colorado_North'
'PCS_NAD27_Colorado_Central'
'PCS_NAD27_Colorado_South'
'PCS_NAD27_Connecticut'
'PCS_NAD27_Delaware'
'PCS_NAD27_Florida_East'
'PCS_NAD27_Florida_West'
'PCS_NAD27_Florida_North'
'PCS_NAD27_Hawaii_zone_1'
'PCS_NAD27_Hawaii_zone_2'
'PCS_NAD27_Hawaii_zone_3'
'PCS_NAD27_Hawaii_zone_4'
'PCS_NAD27_Hawaii_zone_5'
'PCS_NAD27_Georgia_East'
'PCS_NAD27_Georgia_West'
'PCS_NAD27_Idaho_East'
'PCS_NAD27_Idaho_Central'
'PCS_NAD27_Idaho_West'
'PCS_NAD27_Illinois_East'
'PCS_NAD27_Illinois_West'
'PCS_NAD27_Indiana_East'
'PCS_NAD27_BLM_14N_feet'
'PCS_NAD27_Indiana_West'
'PCS_NAD27_BLM_15N_feet'
'PCS_NAD27_Iowa_North'
'PCS_NAD27_BLM_16N_feet'
'PCS_NAD27_Iowa_South'
'PCS_NAD27_BLM_17N_feet'
'PCS_NAD27_Kansas_North'
'PCS_NAD27_Kansas_South'
'PCS_NAD27_Kentucky_North'
'PCS_NAD27_Kentucky_South'
'PCS_NAD27_Louisiana_North'
'PCS_NAD27_Louisiana_South'
'PCS_NAD27_Maine_East'
'PCS_NAD27_Maine_West'
'PCS_NAD27_Maryland'
'PCS_NAD27_Massachusetts'
'PCS_NAD27_Massachusetts_Is'
'PCS_NAD27_Michigan_North'
'PCS_NAD27_Michigan_Central'
'PCS_NAD27_Michigan_South'
'PCS_NAD27_Minnesota_North'
'PCS_NAD27_Minnesota_Cent'
'PCS_NAD27_Minnesota_South'
'PCS_NAD27_Mississippi_East'
'PCS_NAD27_Mississippi_West'
'PCS_NAD27_Missouri_East'
'PCS_NAD27_Missouri_Central'
'PCS_NAD27_Missouri_West'
'PCS_NAD_Michigan_Michigan_East'
'PCS_NAD_Michigan_Michigan_Old_Central'
'PCS_NAD_Michigan_Michigan_West'
'PCS_NAD83_UTM_zone_3N'
'PCS_NAD83_UTM_zone_4N'
'PCS_NAD83_UTM_zone_5N'
'PCS_NAD83_UTM_zone_6N'
'PCS_NAD83_UTM_zone_7N'
'PCS_NAD83_UTM_zone_8N'
'PCS_NAD83_UTM_zone_9N'
'PCS_NAD83_UTM_zone_10N'
'PCS_NAD83_UTM_zone_11N'
'PCS_NAD83_UTM_zone_12N'
'PCS_NAD83_UTM_zone_13N'
'PCS_NAD83_UTM_zone_14N'
'PCS_NAD83_UTM_zone_15N'
'PCS_NAD83_UTM_zone_16N'
'PCS_NAD83_UTM_zone_17N'
'PCS_NAD83_UTM_zone_18N'
'PCS_NAD83_UTM_zone_19N'
'PCS_NAD83_UTM_zone_20N'
'PCS_NAD83_UTM_zone_21N'
'PCS_NAD83_UTM_zone_22N'
'PCS_NAD83_UTM_zone_23N'
'PCS_NAD83_Alabama_East'
'PCS_NAD83_Alabama_West'
'PCS_NAD83_Alaska_zone_1'
'PCS_NAD83_Alaska_zone_2'
'PCS_NAD83_Alaska_zone_3'
'PCS_NAD83_Alaska_zone_4'
'PCS_NAD83_Alaska_zone_5'
'PCS_NAD83_Alaska_zone_6'
'PCS_NAD83_Alaska_zone_7'
'PCS_NAD83_Alaska_zone_8'
'PCS_NAD83_Alaska_zone_9'
'PCS_NAD83_Alaska_zone_10'
'PCS_NAD83_California_1'
'PCS_NAD83_California_2'
'PCS_NAD83_California_3'
'PCS_NAD83_California_4'
'PCS_NAD83_California_5'
'PCS_NAD83_California_6'
'PCS_NAD83_Arizona_East'
'PCS_NAD83_Arizona_Central'
'PCS_NAD83_Arizona_West'
'PCS_NAD83_Arkansas_North'
'PCS_NAD83_Arkansas_South'
'PCS_NAD83_Colorado_North'
'PCS_NAD83_Colorado_Central'
'PCS_NAD83_Colorado_South'
'PCS_NAD83_Connecticut'
'PCS_NAD83_Delaware'
'PCS_NAD83_Florida_East'
'PCS_NAD83_Florida_West'
'PCS_NAD83_Florida_North'
'PCS_NAD83_Hawaii_zone_1'
'PCS_NAD83_Hawaii_zone_2'
'PCS_NAD83_Hawaii_zone_3'
'PCS_NAD83_Hawaii_zone_4'
'PCS_NAD83_Hawaii_zone_5'
'PCS_NAD83_Georgia_East'
'PCS_NAD83_Georgia_West'
'PCS_NAD83_Idaho_East'
'PCS_NAD83_Idaho_Central'
'PCS_NAD83_Idaho_West'
'PCS_NAD83_Illinois_East'
'PCS_NAD83_Illinois_West'
'PCS_NAD83_Indiana_East'
'PCS_NAD83_Indiana_West'
'PCS_NAD83_Iowa_North'
'PCS_NAD83_Iowa_South'
'PCS_NAD83_Kansas_North'
'PCS_NAD83_Kansas_South'
'PCS_NAD83_Kentucky_North'
'PCS_NAD83_Kentucky_South'
'PCS_NAD83_Louisiana_North'
'PCS_NAD83_Louisiana_South'
'PCS_NAD83_Maine_East'
'PCS_NAD83_Maine_West'
'PCS_NAD83_Maryland'
'PCS_NAD83_Massachusetts'
'PCS_NAD83_Massachusetts_Is'
'PCS_NAD83_Michigan_North'
'PCS_NAD83_Michigan_Central'
'PCS_NAD83_Michigan_South'
'PCS_NAD83_Minnesota_North'
'PCS_NAD83_Minnesota_Cent'
'PCS_NAD83_Minnesota_South'
'PCS_NAD83_Mississippi_East'
'PCS_NAD83_Mississippi_West'
'PCS_NAD83_Missouri_East'
'PCS_NAD83_Missouri_Central'
'PCS_NAD83_Missouri_West'
'PCS_Nahrwan_1967_UTM_38N'
'PCS_Nahrwan_1967_UTM_39N'
'PCS_Nahrwan_1967_UTM_40N'
'PCS_Naparima_UTM_20N'
'PCS_GD49_NZ_Map_Grid'
'PCS_GD49_North_Island_Grid'
'PCS_GD49_South_Island_Grid'
'PCS_Datum_73_UTM_zone_29N'
'PCS_ATF_Nord_de_Guerre'
'PCS_NTF_France_I'
'PCS_NTF_France_II'
'PCS_NTF_France_III'
'PCS_NTF_Nord_France'
'PCS_NTF_Centre_France'
'PCS_NTF_Sud_France'
'PCS_British_National_Grid'
'PCS_Point_Noire_UTM_32S'
'PCS_GDA94_MGA_zone_48'
'PCS_GDA94_MGA_zone_49'
'PCS_GDA94_MGA_zone_50'
'PCS_GDA94_MGA_zone_51'
'PCS_GDA94_MGA_zone_52'
'PCS_GDA94_MGA_zone_53'
'PCS_GDA94_MGA_zone_54'
'PCS_GDA94_MGA_zone_55'
'PCS_GDA94_MGA_zone_56'
'PCS_GDA94_MGA_zone_57'
'PCS_GDA94_MGA_zone_58'
'PCS_Pulkovo_Gauss_zone_4'
'PCS_Pulkovo_Gauss_zone_5'
'PCS_Pulkovo_Gauss_zone_6'
'PCS_Pulkovo_Gauss_zone_7'
'PCS_Pulkovo_Gauss_zone_8'
'PCS_Pulkovo_Gauss_zone_9'
'PCS_Pulkovo_Gauss_zone_10'
'PCS_Pulkovo_Gauss_zone_11'
'PCS_Pulkovo_Gauss_zone_12'
'PCS_Pulkovo_Gauss_zone_13'
'PCS_Pulkovo_Gauss_zone_14'
'PCS_Pulkovo_Gauss_zone_15'
'PCS_Pulkovo_Gauss_zone_16'
'PCS_Pulkovo_Gauss_zone_17'
'PCS_Pulkovo_Gauss_zone_18'
'PCS_Pulkovo_Gauss_zone_19'
'PCS_Pulkovo_Gauss_zone_20'
'PCS_Pulkovo_Gauss_zone_21'
'PCS_Pulkovo_Gauss_zone_22'
'PCS_Pulkovo_Gauss_zone_23'
'PCS_Pulkovo_Gauss_zone_24'
'PCS_Pulkovo_Gauss_zone_25'
'PCS_Pulkovo_Gauss_zone_26'
'PCS_Pulkovo_Gauss_zone_27'
'PCS_Pulkovo_Gauss_zone_28'
'PCS_Pulkovo_Gauss_zone_29'
'PCS_Pulkovo_Gauss_zone_30'
'PCS_Pulkovo_Gauss_zone_31'
'PCS_Pulkovo_Gauss_zone_32'
'PCS_Pulkovo_Gauss_4N'
'PCS_Pulkovo_Gauss_5N'
'PCS_Pulkovo_Gauss_6N'
'PCS_Pulkovo_Gauss_7N'
'PCS_Pulkovo_Gauss_8N'
'PCS_Pulkovo_Gauss_9N'
'PCS_Pulkovo_Gauss_10N'
'PCS_Pulkovo_Gauss_11N'
'PCS_Pulkovo_Gauss_12N'
'PCS_Pulkovo_Gauss_13N'
'PCS_Pulkovo_Gauss_14N'
'PCS_Pulkovo_Gauss_15N'
'PCS_Pulkovo_Gauss_16N'
'PCS_Pulkovo_Gauss_17N'
'PCS_Pulkovo_Gauss_18N'
'PCS_Pulkovo_Gauss_19N'
'PCS_Pulkovo_Gauss_20N'
'PCS_Pulkovo_Gauss_21N'
'PCS_Pulkovo_Gauss_22N'
'PCS_Pulkovo_Gauss_23N'
'PCS_Pulkovo_Gauss_24N'
'PCS_Pulkovo_Gauss_25N'
'PCS_Pulkovo_Gauss_26N'
'PCS_Pulkovo_Gauss_27N'
'PCS_Pulkovo_Gauss_28N'
'PCS_Pulkovo_Gauss_29N'
'PCS_Pulkovo_Gauss_30N'
'PCS_Pulkovo_Gauss_31N'
'PCS_Pulkovo_Gauss_32N'
'PCS_Qatar_National_Grid'
'PCS_RD_Netherlands_Old'
'PCS_RD_Netherlands_New'
'PCS_SAD69_UTM_zone_18N'
'PCS_SAD69_UTM_zone_19N'
'PCS_SAD69_UTM_zone_20N'
'PCS_SAD69_UTM_zone_21N'
'PCS_SAD69_UTM_zone_22N'
'PCS_SAD69_UTM_zone_17S'
'PCS_SAD69_UTM_zone_18S'
'PCS_SAD69_UTM_zone_19S'
'PCS_SAD69_UTM_zone_20S'
'PCS_SAD69_UTM_zone_21S'
'PCS_SAD69_UTM_zone_22S'
'PCS_SAD69_UTM_zone_23S'
'PCS_SAD69_UTM_zone_24S'
'PCS_SAD69_UTM_zone_25S'
'PCS_Sapper_Hill_UTM_20S'
'PCS_Sapper_Hill_UTM_21S'
'PCS_Schwarzeck_UTM_33S'
'PCS_Sudan_UTM_zone_35N'
'PCS_Sudan_UTM_zone_36N'
'PCS_Tananarive_Laborde'
'PCS_Tananarive_UTM_38S'
'PCS_Tananarive_UTM_39S'
'PCS_Timbalai_1948_Borneo'
'PCS_Timbalai_1948_UTM_49N'
'PCS_Timbalai_1948_UTM_50N'
'PCS_TM65_Irish_Nat_Grid'
'PCS_Trinidad_1903_Trinidad'
'PCS_TC_1948_UTM_zone_39N'
'PCS_TC_1948_UTM_zone_40N'
'PCS_Voirol_N_Algerie_ancien'
'PCS_Voirol_S_Algerie_ancien'
'PCS_Voirol_Unifie_N_Algerie'
'PCS_Voirol_Unifie_S_Algerie'
'PCS_Bern_1938_Swiss_New'
'PCS_Nord_Sahara_UTM_29N'
'PCS_Nord_Sahara_UTM_30N'
'PCS_Nord_Sahara_UTM_31N'
'PCS_Nord_Sahara_UTM_32N'
'PCS_Yoff_UTM_zone_28N'
'PCS_Zanderij_UTM_zone_21N'
'PCS_MGI_Austria_West'
'PCS_MGI_Austria_Central'
'PCS_MGI_Austria_East'
'PCS_Belge_Lambert_72'
'PCS_DHDN_Germany_zone_1'
'PCS_DHDN_Germany_zone_2'
'PCS_DHDN_Germany_zone_3'
'PCS_DHDN_Germany_zone_4'
'PCS_DHDN_Germany_zone_5'
'PCS_NAD27_Montana_North'
'PCS_NAD27_Montana_Central'
'PCS_NAD27_Montana_South'
'PCS_NAD27_Nebraska_North'
'PCS_NAD27_Nebraska_South'
'PCS_NAD27_Nevada_East'
'PCS_NAD27_Nevada_Central'
'PCS_NAD27_Nevada_West'
'PCS_NAD27_New_Hampshire'
'PCS_NAD27_New_Jersey'
'PCS_NAD27_New_Mexico_East'
'PCS_NAD27_New_Mexico_Cent'
'PCS_NAD27_New_Mexico_West'
'PCS_NAD27_New_York_East'
'PCS_NAD27_New_York_Central'
'PCS_NAD27_New_York_West'
'PCS_NAD27_New_York_Long_Is'
'PCS_NAD27_North_Carolina'
'PCS_NAD27_North_Dakota_N'
'PCS_NAD27_North_Dakota_S'
'PCS_NAD27_Ohio_North'
'PCS_NAD27_Ohio_South'
'PCS_NAD27_Oklahoma_North'
'PCS_NAD27_Oklahoma_South'
'PCS_NAD27_Oregon_North'
'PCS_NAD27_Oregon_South'
'PCS_NAD27_Pennsylvania_N'
'PCS_NAD27_Pennsylvania_S'
'PCS_NAD27_Rhode_Island'
'PCS_NAD27_South_Carolina_N'
'PCS_NAD27_South_Carolina_S'
'PCS_NAD27_South_Dakota_N'
'PCS_NAD27_South_Dakota_S'
'PCS_NAD27_Tennessee'
'PCS_NAD27_Texas_North'
'PCS_NAD27_Texas_North_Cen'
'PCS_NAD27_Texas_Central'
'PCS_NAD27_Texas_South_Cen'
'PCS_NAD27_Texas_South'
'PCS_NAD27_Utah_North'
'PCS_NAD27_Utah_Central'
'PCS_NAD27_Utah_South'
'PCS_NAD27_Vermont'
'PCS_NAD27_Virginia_North'
'PCS_NAD27_Virginia_South'
'PCS_NAD27_Washington_North'
'PCS_NAD27_Washington_South'
'PCS_NAD27_West_Virginia_N'
'PCS_NAD27_West_Virginia_S'
'PCS_NAD27_Wisconsin_North'
'PCS_NAD27_Wisconsin_Cen'
'PCS_NAD27_Wisconsin_South'
'PCS_NAD27_Wyoming_East'
'PCS_NAD27_Wyoming_E_Cen'
'PCS_NAD27_Wyoming_W_Cen'
'PCS_NAD27_Wyoming_West'
'PCS_NAD27_Puerto_Rico'
'PCS_NAD27_St_Croix'
'PCS_NAD83_Montana'
'PCS_NAD83_Nebraska'
'PCS_NAD83_Nevada_East'
'PCS_NAD83_Nevada_Central'
'PCS_NAD83_Nevada_West'
'PCS_NAD83_New_Hampshire'
'PCS_NAD83_New_Jersey'
'PCS_NAD83_New_Mexico_East'
'PCS_NAD83_New_Mexico_Cent'
'PCS_NAD83_New_Mexico_West'
'PCS_NAD83_New_York_East'
'PCS_NAD83_New_York_Central'
'PCS_NAD83_New_York_West'
'PCS_NAD83_New_York_Long_Is'
'PCS_NAD83_North_Carolina'
'PCS_NAD83_North_Dakota_N'
'PCS_NAD83_North_Dakota_S'
'PCS_NAD83_Ohio_North'
'PCS_NAD83_Ohio_South'
'PCS_NAD83_Oklahoma_North'
'PCS_NAD83_Oklahoma_South'
'PCS_NAD83_Oregon_North'
'PCS_NAD83_Oregon_South'
'PCS_NAD83_Pennsylvania_N'
'PCS_NAD83_Pennsylvania_S'
'PCS_NAD83_Rhode_Island'
'PCS_NAD83_South_Carolina'
'PCS_NAD83_South_Dakota_N'
'PCS_NAD83_South_Dakota_S'
'PCS_NAD83_Tennessee'
'PCS_NAD83_Texas_North'
'PCS_NAD83_Texas_North_Cen'
'PCS_NAD83_Texas_Central'
'PCS_NAD83_Texas_South_Cen'
'PCS_NAD83_Texas_South'
'PCS_NAD83_Utah_North'
'PCS_NAD83_Utah_Central'
'PCS_NAD83_Utah_South'
'PCS_NAD83_Vermont'
'PCS_NAD83_Virginia_North'
'PCS_NAD83_Virginia_South'
'PCS_NAD83_Washington_North'
'PCS_NAD83_Washington_South'
'PCS_NAD83_West_Virginia_N'
'PCS_NAD83_West_Virginia_S'
'PCS_NAD83_Wisconsin_North'
'PCS_NAD83_Wisconsin_Cen'
'PCS_NAD83_Wisconsin_South'
'PCS_NAD83_Wyoming_East'
'PCS_NAD83_Wyoming_E_Cen'
'PCS_NAD83_Wyoming_W_Cen'
'PCS_NAD83_Wyoming_West'
'PCS_NAD83_Puerto_Rico_Virgin_Is'
'PCS_WGS72_UTM_zone_1N'
'PCS_WGS72_UTM_zone_2N'
'PCS_WGS72_UTM_zone_3N'
'PCS_WGS72_UTM_zone_4N'
'PCS_WGS72_UTM_zone_5N'
'PCS_WGS72_UTM_zone_6N'
'PCS_WGS72_UTM_zone_7N'
'PCS_WGS72_UTM_zone_8N'
'PCS_WGS72_UTM_zone_9N'
'PCS_WGS72_UTM_zone_10N'
'PCS_WGS72_UTM_zone_11N'
'PCS_WGS72_UTM_zone_12N'
'PCS_WGS72_UTM_zone_13N'
'PCS_WGS72_UTM_zone_14N'
'PCS_WGS72_UTM_zone_15N'
'PCS_WGS72_UTM_zone_16N'
'PCS_WGS72_UTM_zone_17N'
'PCS_WGS72_UTM_zone_18N'
'PCS_WGS72_UTM_zone_19N'
'PCS_WGS72_UTM_zone_20N'
'PCS_WGS72_UTM_zone_21N'
'PCS_WGS72_UTM_zone_22N'
'PCS_WGS72_UTM_zone_23N'
'PCS_WGS72_UTM_zone_24N'
'PCS_WGS72_UTM_zone_25N'
'PCS_WGS72_UTM_zone_26N'
'PCS_WGS72_UTM_zone_27N'
'PCS_WGS72_UTM_zone_28N'
'PCS_WGS72_UTM_zone_29N'
'PCS_WGS72_UTM_zone_30N'
'PCS_WGS72_UTM_zone_31N'
'PCS_WGS72_UTM_zone_32N'
'PCS_WGS72_UTM_zone_33N'
'PCS_WGS72_UTM_zone_34N'
'PCS_WGS72_UTM_zone_35N'
'PCS_WGS72_UTM_zone_36N'
'PCS_WGS72_UTM_zone_37N'
'PCS_WGS72_UTM_zone_38N'
'PCS_WGS72_UTM_zone_39N'
'PCS_WGS72_UTM_zone_40N'
'PCS_WGS72_UTM_zone_41N'
'PCS_WGS72_UTM_zone_42N'
'PCS_WGS72_UTM_zone_43N'
'PCS_WGS72_UTM_zone_44N'
'PCS_WGS72_UTM_zone_45N'
'PCS_WGS72_UTM_zone_46N'
'PCS_WGS72_UTM_zone_47N'
'PCS_WGS72_UTM_zone_48N'
'PCS_WGS72_UTM_zone_49N'
'PCS_WGS72_UTM_zone_50N'
'PCS_WGS72_UTM_zone_51N'
'PCS_WGS72_UTM_zone_52N'
'PCS_WGS72_UTM_zone_53N'
'PCS_WGS72_UTM_zone_54N'
'PCS_WGS72_UTM_zone_55N'
'PCS_WGS72_UTM_zone_56N'
'PCS_WGS72_UTM_zone_57N'
'PCS_WGS72_UTM_zone_58N'
'PCS_WGS72_UTM_zone_59N'
'PCS_WGS72_UTM_zone_60N'
'PCS_WGS72_UTM_zone_1S'
'PCS_WGS72_UTM_zone_2S'
'PCS_WGS72_UTM_zone_3S'
'PCS_WGS72_UTM_zone_4S'
'PCS_WGS72_UTM_zone_5S'
'PCS_WGS72_UTM_zone_6S'
'PCS_WGS72_UTM_zone_7S'
'PCS_WGS72_UTM_zone_8S'
'PCS_WGS72_UTM_zone_9S'
'PCS_WGS72_UTM_zone_10S'
'PCS_WGS72_UTM_zone_11S'
'PCS_WGS72_UTM_zone_12S'
'PCS_WGS72_UTM_zone_13S'
'PCS_WGS72_UTM_zone_14S'
'PCS_WGS72_UTM_zone_15S'
'PCS_WGS72_UTM_zone_16S'
'PCS_WGS72_UTM_zone_17S'
'PCS_WGS72_UTM_zone_18S'
'PCS_WGS72_UTM_zone_19S'
'PCS_WGS72_UTM_zone_20S'
'PCS_WGS72_UTM_zone_21S'
'PCS_WGS72_UTM_zone_22S'
'PCS_WGS72_UTM_zone_23S'
'PCS_WGS72_UTM_zone_24S'
'PCS_WGS72_UTM_zone_25S'
'PCS_WGS72_UTM_zone_26S'
'PCS_WGS72_UTM_zone_27S'
'PCS_WGS72_UTM_zone_28S'
'PCS_WGS72_UTM_zone_29S'
'PCS_WGS72_UTM_zone_30S'
'PCS_WGS72_UTM_zone_31S'
'PCS_WGS72_UTM_zone_32S'
'PCS_WGS72_UTM_zone_33S'
'PCS_WGS72_UTM_zone_34S'
'PCS_WGS72_UTM_zone_35S'
'PCS_WGS72_UTM_zone_36S'
'PCS_WGS72_UTM_zone_37S'
'PCS_WGS72_UTM_zone_38S'
'PCS_WGS72_UTM_zone_39S'
'PCS_WGS72_UTM_zone_40S'
'PCS_WGS72_UTM_zone_41S'
'PCS_WGS72_UTM_zone_42S'
'PCS_WGS72_UTM_zone_43S'
'PCS_WGS72_UTM_zone_44S'
'PCS_WGS72_UTM_zone_45S'
'PCS_WGS72_UTM_zone_46S'
'PCS_WGS72_UTM_zone_47S'
'PCS_WGS72_UTM_zone_48S'
'PCS_WGS72_UTM_zone_49S'
'PCS_WGS72_UTM_zone_50S'
'PCS_WGS72_UTM_zone_51S'
'PCS_WGS72_UTM_zone_52S'
'PCS_WGS72_UTM_zone_53S'
'PCS_WGS72_UTM_zone_54S'
'PCS_WGS72_UTM_zone_55S'
'PCS_WGS72_UTM_zone_56S'
'PCS_WGS72_UTM_zone_57S'
'PCS_WGS72_UTM_zone_58S'
'PCS_WGS72_UTM_zone_59S'
'PCS_WGS72_UTM_zone_60S'
'PCS_WGS72BE_UTM_zone_1N'
'PCS_WGS72BE_UTM_zone_2N'
'PCS_WGS72BE_UTM_zone_3N'
'PCS_WGS72BE_UTM_zone_4N'
'PCS_WGS72BE_UTM_zone_5N'
'PCS_WGS72BE_UTM_zone_6N'
'PCS_WGS72BE_UTM_zone_7N'
'PCS_WGS72BE_UTM_zone_8N'
'PCS_WGS72BE_UTM_zone_9N'
'PCS_WGS72BE_UTM_zone_10N'
'PCS_WGS72BE_UTM_zone_11N'
'PCS_WGS72BE_UTM_zone_12N'
'PCS_WGS72BE_UTM_zone_13N'
'PCS_WGS72BE_UTM_zone_14N'
'PCS_WGS72BE_UTM_zone_15N'
'PCS_WGS72BE_UTM_zone_16N'
'PCS_WGS72BE_UTM_zone_17N'
'PCS_WGS72BE_UTM_zone_18N'
'PCS_WGS72BE_UTM_zone_19N'
'PCS_WGS72BE_UTM_zone_20N'
'PCS_WGS72BE_UTM_zone_21N'
'PCS_WGS72BE_UTM_zone_22N'
'PCS_WGS72BE_UTM_zone_23N'
'PCS_WGS72BE_UTM_zone_24N'
'PCS_WGS72BE_UTM_zone_25N'
'PCS_WGS72BE_UTM_zone_26N'
'PCS_WGS72BE_UTM_zone_27N'
'PCS_WGS72BE_UTM_zone_28N'
'PCS_WGS72BE_UTM_zone_29N'
'PCS_WGS72BE_UTM_zone_30N'
'PCS_WGS72BE_UTM_zone_31N'
'PCS_WGS72BE_UTM_zone_32N'
'PCS_WGS72BE_UTM_zone_33N'
'PCS_WGS72BE_UTM_zone_34N'
'PCS_WGS72BE_UTM_zone_35N'
'PCS_WGS72BE_UTM_zone_36N'
'PCS_WGS72BE_UTM_zone_37N'
'PCS_WGS72BE_UTM_zone_38N'
'PCS_WGS72BE_UTM_zone_39N'
'PCS_WGS72BE_UTM_zone_40N'
'PCS_WGS72BE_UTM_zone_41N'
'PCS_WGS72BE_UTM_zone_42N'
'PCS_WGS72BE_UTM_zone_43N'
'PCS_WGS72BE_UTM_zone_44N'
'PCS_WGS72BE_UTM_zone_45N'
'PCS_WGS72BE_UTM_zone_46N'
'PCS_WGS72BE_UTM_zone_47N'
'PCS_WGS72BE_UTM_zone_48N'
'PCS_WGS72BE_UTM_zone_49N'
'PCS_WGS72BE_UTM_zone_50N'
'PCS_WGS72BE_UTM_zone_51N'
'PCS_WGS72BE_UTM_zone_52N'
'PCS_WGS72BE_UTM_zone_53N'
'PCS_WGS72BE_UTM_zone_54N'
'PCS_WGS72BE_UTM_zone_55N'
'PCS_WGS72BE_UTM_zone_56N'
'PCS_WGS72BE_UTM_zone_57N'
'PCS_WGS72BE_UTM_zone_58N'
'PCS_WGS72BE_UTM_zone_59N'
'PCS_WGS72BE_UTM_zone_60N'
'PCS_WGS72BE_UTM_zone_1S'
'PCS_WGS72BE_UTM_zone_2S'
'PCS_WGS72BE_UTM_zone_3S'
'PCS_WGS72BE_UTM_zone_4S'
'PCS_WGS72BE_UTM_zone_5S'
'PCS_WGS72BE_UTM_zone_6S'
'PCS_WGS72BE_UTM_zone_7S'
'PCS_WGS72BE_UTM_zone_8S'
'PCS_WGS72BE_UTM_zone_9S'
'PCS_WGS72BE_UTM_zone_10S'
'PCS_WGS72BE_UTM_zone_11S'
'PCS_WGS72BE_UTM_zone_12S'
'PCS_WGS72BE_UTM_zone_13S'
'PCS_WGS72BE_UTM_zone_14S'
'PCS_WGS72BE_UTM_zone_15S'
'PCS_WGS72BE_UTM_zone_16S'
'PCS_WGS72BE_UTM_zone_17S'
'PCS_WGS72BE_UTM_zone_18S'
'PCS_WGS72BE_UTM_zone_19S'
'PCS_WGS72BE_UTM_zone_20S'
'PCS_WGS72BE_UTM_zone_21S'
'PCS_WGS72BE_UTM_zone_22S'
'PCS_WGS72BE_UTM_zone_23S'
'PCS_WGS72BE_UTM_zone_24S'
'PCS_WGS72BE_UTM_zone_25S'
'PCS_WGS72BE_UTM_zone_26S'
'PCS_WGS72BE_UTM_zone_27S'
'PCS_WGS72BE_UTM_zone_28S'
'PCS_WGS72BE_UTM_zone_29S'
'PCS_WGS72BE_UTM_zone_30S'
'PCS_WGS72BE_UTM_zone_31S'
'PCS_WGS72BE_UTM_zone_32S'
'PCS_WGS72BE_UTM_zone_33S'
'PCS_WGS72BE_UTM_zone_34S'
'PCS_WGS72BE_UTM_zone_35S'
'PCS_WGS72BE_UTM_zone_36S'
'PCS_WGS72BE_UTM_zone_37S'
'PCS_WGS72BE_UTM_zone_38S'
'PCS_WGS72BE_UTM_zone_39S'
'PCS_WGS72BE_UTM_zone_40S'
'PCS_WGS72BE_UTM_zone_41S'
'PCS_WGS72BE_UTM_zone_42S'
'PCS_WGS72BE_UTM_zone_43S'
'PCS_WGS72BE_UTM_zone_44S'
'PCS_WGS72BE_UTM_zone_45S'
'PCS_WGS72BE_UTM_zone_46S'
'PCS_WGS72BE_UTM_zone_47S'
'PCS_WGS72BE_UTM_zone_48S'
'PCS_WGS72BE_UTM_zone_49S'
'PCS_WGS72BE_UTM_zone_50S'
'PCS_WGS72BE_UTM_zone_51S'
'PCS_WGS72BE_UTM_zone_52S'
'PCS_WGS72BE_UTM_zone_53S'
'PCS_WGS72BE_UTM_zone_54S'
'PCS_WGS72BE_UTM_zone_55S'
'PCS_WGS72BE_UTM_zone_56S'
'PCS_WGS72BE_UTM_zone_57S'
'PCS_WGS72BE_UTM_zone_58S'
'PCS_WGS72BE_UTM_zone_59S'
'PCS_WGS72BE_UTM_zone_60S'
'PCS_WGS84_UTM_zone_1N'
'PCS_WGS84_UTM_zone_2N'
'PCS_WGS84_UTM_zone_3N'
'PCS_WGS84_UTM_zone_4N'
'PCS_WGS84_UTM_zone_5N'
'PCS_WGS84_UTM_zone_6N'
'PCS_WGS84_UTM_zone_7N'
'PCS_WGS84_UTM_zone_8N'
'PCS_WGS84_UTM_zone_9N'
'PCS_WGS84_UTM_zone_10N'
'PCS_WGS84_UTM_zone_11N'
'PCS_WGS84_UTM_zone_12N'
'PCS_WGS84_UTM_zone_13N'
'PCS_WGS84_UTM_zone_14N'
'PCS_WGS84_UTM_zone_15N'
'PCS_WGS84_UTM_zone_16N'
'PCS_WGS84_UTM_zone_17N'
'PCS_WGS84_UTM_zone_18N'
'PCS_WGS84_UTM_zone_19N'
'PCS_WGS84_UTM_zone_20N'
'PCS_WGS84_UTM_zone_21N'
'PCS_WGS84_UTM_zone_22N'
'PCS_WGS84_UTM_zone_23N'
'PCS_WGS84_UTM_zone_24N'
'PCS_WGS84_UTM_zone_25N'
'PCS_WGS84_UTM_zone_26N'
'PCS_WGS84_UTM_zone_27N'
'PCS_WGS84_UTM_zone_28N'
'PCS_WGS84_UTM_zone_29N'
'PCS_WGS84_UTM_zone_30N'
'PCS_WGS84_UTM_zone_31N'
'PCS_WGS84_UTM_zone_32N'
'PCS_WGS84_UTM_zone_33N'
'PCS_WGS84_UTM_zone_34N'
'PCS_WGS84_UTM_zone_35N'
'PCS_WGS84_UTM_zone_36N'
'PCS_WGS84_UTM_zone_37N'
'PCS_WGS84_UTM_zone_38N'
'PCS_WGS84_UTM_zone_39N'
'PCS_WGS84_UTM_zone_40N'
'PCS_WGS84_UTM_zone_41N'
'PCS_WGS84_UTM_zone_42N'
'PCS_WGS84_UTM_zone_43N'
'PCS_WGS84_UTM_zone_44N'
'PCS_WGS84_UTM_zone_45N'
'PCS_WGS84_UTM_zone_46N'
'PCS_WGS84_UTM_zone_47N'
'PCS_WGS84_UTM_zone_48N'
'PCS_WGS84_UTM_zone_49N'
'PCS_WGS84_UTM_zone_50N'
'PCS_WGS84_UTM_zone_51N'
'PCS_WGS84_UTM_zone_52N'
'PCS_WGS84_UTM_zone_53N'
'PCS_WGS84_UTM_zone_54N'
'PCS_WGS84_UTM_zone_55N'
'PCS_WGS84_UTM_zone_56N'
'PCS_WGS84_UTM_zone_57N'
'PCS_WGS84_UTM_zone_58N'
'PCS_WGS84_UTM_zone_59N'
'PCS_WGS84_UTM_zone_60N'
'PCS_WGS84_UTM_zone_1S'
'PCS_WGS84_UTM_zone_2S'
'PCS_WGS84_UTM_zone_3S'
'PCS_WGS84_UTM_zone_4S'
'PCS_WGS84_UTM_zone_5S'
'PCS_WGS84_UTM_zone_6S'
'PCS_WGS84_UTM_zone_7S'
'PCS_WGS84_UTM_zone_8S'
'PCS_WGS84_UTM_zone_9S'
'PCS_WGS84_UTM_zone_10S'
'PCS_WGS84_UTM_zone_11S'
'PCS_WGS84_UTM_zone_12S'
'PCS_WGS84_UTM_zone_13S'
'PCS_WGS84_UTM_zone_14S'
'PCS_WGS84_UTM_zone_15S'
'PCS_WGS84_UTM_zone_16S'
'PCS_WGS84_UTM_zone_17S'
'PCS_WGS84_UTM_zone_18S'
'PCS_WGS84_UTM_zone_19S'
'PCS_WGS84_UTM_zone_20S'
'PCS_WGS84_UTM_zone_21S'
'PCS_WGS84_UTM_zone_22S'
'PCS_WGS84_UTM_zone_23S'
'PCS_WGS84_UTM_zone_24S'
'PCS_WGS84_UTM_zone_25S'
'PCS_WGS84_UTM_zone_26S'
'PCS_WGS84_UTM_zone_27S'
'PCS_WGS84_UTM_zone_28S'
'PCS_WGS84_UTM_zone_29S'
'PCS_WGS84_UTM_zone_30S'
'PCS_WGS84_UTM_zone_31S'
'PCS_WGS84_UTM_zone_32S'
'PCS_WGS84_UTM_zone_33S'
'PCS_WGS84_UTM_zone_34S'
'PCS_WGS84_UTM_zone_35S'
'PCS_WGS84_UTM_zone_36S'
'PCS_WGS84_UTM_zone_37S'
'PCS_WGS84_UTM_zone_38S'
'PCS_WGS84_UTM_zone_39S'
'PCS_WGS84_UTM_zone_40S'
'PCS_WGS84_UTM_zone_41S'
'PCS_WGS84_UTM_zone_42S'
'PCS_WGS84_UTM_zone_43S'
'PCS_WGS84_UTM_zone_44S'
'PCS_WGS84_UTM_zone_45S'
'PCS_WGS84_UTM_zone_46S'
'PCS_WGS84_UTM_zone_47S'
'PCS_WGS84_UTM_zone_48S'
'PCS_WGS84_UTM_zone_49S'
'PCS_WGS84_UTM_zone_50S'
'PCS_WGS84_UTM_zone_51S'
'PCS_WGS84_UTM_zone_52S'
'PCS_WGS84_UTM_zone_53S'
'PCS_WGS84_UTM_zone_54S'
'PCS_WGS84_UTM_zone_55S'
'PCS_WGS84_UTM_zone_56S'
'PCS_WGS84_UTM_zone_57S'
'PCS_WGS84_UTM_zone_58S'
'PCS_WGS84_UTM_zone_59S'
'PCS_WGS84_UTM_zone_60S'
'user-defined'};

   val = [0
20137
20138
20248
20249
20250
20251
20252
20253
20254
20255
20256
20257
20258
20348
20349
20350
20351
20352
20353
20354
20355
20356
20357
20358
20437
20438
20439
20499
20538
20539
20700
20822
20823
20824
20973
20975
20977
20979
20981
20983
20985
20987
20989
20991
20993
20995
21100
21148
21149
21150
21413
21414
21415
21416
21417
21418
21419
21420
21421
21422
21423
21473
21474
21475
21476
21477
21478
21479
21480
21481
21482
21483
21500
21790
21817
21818
21891
21892
21893
21894
22032
22033
22191
22192
22193
22194
22195
22196
22197
22332
22391
22392
22523
22524
22832
22992
22993
22994
23028
23029
23030
23031
23032
23033
23034
23035
23036
23037
23038
23239
23240
23433
23846
23847
23848
23849
23850
23851
23852
23853
23886
23887
23888
23889
23890
23891
23892
23893
23894
23947
23948
24047
24048
24100
24200
24370
24371
24372
24373
24374
24382
24383
24384
24500
24547
24548
24720
24721
24818
24819
24820
24821
24877
24878
24879
24880
24891
24892
24893
25000
25231
25391
25392
25393
25394
25395
25700
25932
26191
26192
26193
26237
26331
26332
26391
26392
26393
26432
26591
26592
26632
26692
26703
26704
26705
26706
26707
26708
26709
26710
26711
26712
26713
26714
26715
26716
26717
26718
26719
26720
26721
26722
26729
26730
26731
26732
26733
26734
26735
26736
26737
26738
26739
26740
26741
26742
26743
26744
26745
26746
26747
26748
26749
26750
26751
26752
26753
26754
26755
26756
26757
26758
26759
26760
26761
26762
26763
26764
26765
26766
26767
26768
26769
26770
26771
26772
26773
26774
26774
26775
26775
26776
26776
26777
26777
26778
26779
26780
26781
26782
26783
26784
26785
26786
26787
26788
26789
26790
26791
26792
26793
26794
26795
26796
26797
26798
26801
26802
26803
26903
26904
26905
26906
26907
26908
26909
26910
26911
26912
26913
26914
26915
26916
26917
26918
26919
26920
26921
26922
26923
26929
26930
26931
26932
26933
26934
26935
26936
26937
26938
26939
26940
26941
26942
26943
26944
26945
26946
26948
26949
26950
26951
26952
26953
26954
26955
26956
26957
26958
26959
26960
26961
26962
26963
26964
26965
26966
26967
26968
26969
26970
26971
26972
26973
26974
26975
26976
26977
26978
26979
26980
26981
26982
26983
26984
26985
26986
26987
26988
26989
26990
26991
26992
26993
26994
26995
26996
26997
26998
27038
27039
27040
27120
27200
27291
27292
27429
27500
27581
27582
27583
27591
27592
27593
27700
28232
28348
28349
28350
28351
28352
28353
28354
28355
28356
28357
28358
28404
28405
28406
28407
28408
28409
28410
28411
28412
28413
28414
28415
28416
28417
28418
28419
28420
28421
28422
28423
28424
28425
28426
28427
28428
28429
28430
28431
28432
28464
28465
28466
28467
28468
28469
28470
28471
28472
28473
28474
28475
28476
28477
28478
28479
28480
28481
28482
28483
28484
28485
28486
28487
28488
28489
28490
28491
28492
28600
28991
28992
29118
29119
29120
29121
29122
29177
29178
29179
29180
29181
29182
29183
29184
29185
29220
29221
29333
29635
29636
29700
29738
29739
29800
29849
29850
29900
30200
30339
30340
30491
30492
30591
30592
30600
30729
30730
30731
30732
31028
31121
31291
31292
31293
31300
31491
31492
31493
31494
31495
32001
32002
32003
32005
32006
32007
32008
32009
32010
32011
32012
32013
32014
32015
32016
32017
32018
32019
32020
32021
32022
32023
32024
32025
32026
32027
32028
32029
32030
32031
32033
32034
32035
32036
32037
32038
32039
32040
32041
32042
32043
32044
32045
32046
32047
32048
32049
32050
32051
32052
32053
32054
32055
32056
32057
32058
32059
32060
32100
32104
32107
32108
32109
32110
32111
32112
32113
32114
32115
32116
32117
32118
32119
32120
32121
32122
32123
32124
32125
32126
32127
32128
32129
32130
32133
32134
32135
32136
32137
32138
32139
32140
32141
32142
32143
32144
32145
32146
32147
32148
32149
32150
32151
32152
32153
32154
32155
32156
32157
32158
32161
32201
32202
32203
32204
32205
32206
32207
32208
32209
32210
32211
32212
32213
32214
32215
32216
32217
32218
32219
32220
32221
32222
32223
32224
32225
32226
32227
32228
32229
32230
32231
32232
32233
32234
32235
32236
32237
32238
32239
32240
32241
32242
32243
32244
32245
32246
32247
32248
32249
32250
32251
32252
32253
32254
32255
32256
32257
32258
32259
32260
32301
32302
32303
32304
32305
32306
32307
32308
32309
32310
32311
32312
32313
32314
32315
32316
32317
32318
32319
32320
32321
32322
32323
32324
32325
32326
32327
32328
32329
32330
32331
32332
32333
32334
32335
32336
32337
32338
32339
32340
32341
32342
32343
32344
32345
32346
32347
32348
32349
32350
32351
32352
32353
32354
32355
32356
32357
32358
32359
32360
32401
32402
32403
32404
32405
32406
32407
32408
32409
32410
32411
32412
32413
32414
32415
32416
32417
32418
32419
32420
32421
32422
32423
32424
32425
32426
32427
32428
32429
32430
32431
32432
32433
32434
32435
32436
32437
32438
32439
32440
32441
32442
32443
32444
32445
32446
32447
32448
32449
32450
32451
32452
32453
32454
32455
32456
32457
32458
32459
32460
32501
32502
32503
32504
32505
32506
32507
32508
32509
32510
32511
32512
32513
32514
32515
32516
32517
32518
32519
32520
32521
32522
32523
32524
32525
32526
32527
32528
32529
32530
32531
32532
32533
32534
32535
32536
32537
32538
32539
32540
32541
32542
32543
32544
32545
32546
32547
32548
32549
32550
32551
32552
32553
32554
32555
32556
32557
32558
32559
32560
32601
32602
32603
32604
32605
32606
32607
32608
32609
32610
32611
32612
32613
32614
32615
32616
32617
32618
32619
32620
32621
32622
32623
32624
32625
32626
32627
32628
32629
32630
32631
32632
32633
32634
32635
32636
32637
32638
32639
32640
32641
32642
32643
32644
32645
32646
32647
32648
32649
32650
32651
32652
32653
32654
32655
32656
32657
32658
32659
32660
32701
32702
32703
32704
32705
32706
32707
32708
32709
32710
32711
32712
32713
32714
32715
32716
32717
32718
32719
32720
32721
32722
32723
32724
32725
32726
32727
32728
32729
32730
32731
32732
32733
32734
32735
32736
32737
32738
32739
32740
32741
32742
32743
32744
32745
32746
32747
32748
32749
32750
32751
32752
32753
32754
32755
32756
32757
32758
32759
32760
32767];

   x = x + 0.09;
   w = 0.25;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','popupmenu', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String',str, ...
	'user',val, ...
   	'Tag','ProjectedCSTypeGeoKey');

   x = x + 0.27;
   w = 0.06;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','Projection', ...
   	'Tag','');

   str = {''
'Proj_Alabama_CS27_East'
'Proj_Alabama_CS27_West'
'Proj_Alabama_CS83_East'
'Proj_Alabama_CS83_West'
'Proj_Arizona_Coordinate_System_east'
'Proj_Arizona_Coordinate_System_Central'
'Proj_Arizona_Coordinate_System_west'
'Proj_Arizona_CS83_east'
'Proj_Arizona_CS83_Central'
'Proj_Arizona_CS83_west'
'Proj_Arkansas_CS27_North'
'Proj_Arkansas_CS27_South'
'Proj_Arkansas_CS83_North'
'Proj_Arkansas_CS83_South'
'Proj_California_CS27_I'
'Proj_California_CS27_II'
'Proj_California_CS27_III'
'Proj_California_CS27_IV'
'Proj_California_CS27_V'
'Proj_California_CS27_VI'
'Proj_California_CS27_VII'
'Proj_California_CS83_1'
'Proj_California_CS83_2'
'Proj_California_CS83_3'
'Proj_California_CS83_4'
'Proj_California_CS83_5'
'Proj_California_CS83_6'
'Proj_Colorado_CS27_North'
'Proj_Colorado_CS27_Central'
'Proj_Colorado_CS27_South'
'Proj_Colorado_CS83_North'
'Proj_Colorado_CS83_Central'
'Proj_Colorado_CS83_South'
'Proj_Connecticut_CS27'
'Proj_Connecticut_CS83'
'Proj_Delaware_CS27'
'Proj_Delaware_CS83'
'Proj_Florida_CS27_East'
'Proj_Florida_CS27_West'
'Proj_Florida_CS27_North'
'Proj_Florida_CS83_East'
'Proj_Florida_CS83_West'
'Proj_Florida_CS83_North'
'Proj_Georgia_CS27_East'
'Proj_Georgia_CS27_West'
'Proj_Georgia_CS83_East'
'Proj_Georgia_CS83_West'
'Proj_Idaho_CS27_East'
'Proj_Idaho_CS27_Central'
'Proj_Idaho_CS27_West'
'Proj_Idaho_CS83_East'
'Proj_Idaho_CS83_Central'
'Proj_Idaho_CS83_West'
'Proj_Illinois_CS27_East'
'Proj_Illinois_CS27_West'
'Proj_Illinois_CS83_East'
'Proj_Illinois_CS83_West'
'Proj_Indiana_CS27_East'
'Proj_Indiana_CS27_West'
'Proj_Indiana_CS83_East'
'Proj_Indiana_CS83_West'
'Proj_Iowa_CS27_North'
'Proj_Iowa_CS27_South'
'Proj_Iowa_CS83_North'
'Proj_Iowa_CS83_South'
'Proj_Kansas_CS27_North'
'Proj_Kansas_CS27_South'
'Proj_Kansas_CS83_North'
'Proj_Kansas_CS83_South'
'Proj_Kentucky_CS27_North'
'Proj_Kentucky_CS27_South'
'Proj_Kentucky_CS83_North'
'Proj_Kentucky_CS83_South'
'Proj_Louisiana_CS27_North'
'Proj_Louisiana_CS27_South'
'Proj_Louisiana_CS83_North'
'Proj_Louisiana_CS83_South'
'Proj_Maine_CS27_East'
'Proj_Maine_CS27_West'
'Proj_Maine_CS83_East'
'Proj_Maine_CS83_West'
'Proj_Maryland_CS27'
'Proj_Maryland_CS83'
'Proj_Massachusetts_CS27_Mainland'
'Proj_Massachusetts_CS27_Island'
'Proj_Massachusetts_CS83_Mainland'
'Proj_Massachusetts_CS83_Island'
'Proj_Michigan_State_Plane_East'
'Proj_Michigan_State_Plane_Old_Central'
'Proj_Michigan_State_Plane_West'
'Proj_Michigan_CS27_North'
'Proj_Michigan_CS27_Central'
'Proj_Michigan_CS27_South'
'Proj_Michigan_CS83_North'
'Proj_Michigan_CS83_Central'
'Proj_Michigan_CS83_South'
'Proj_Minnesota_CS27_North'
'Proj_Minnesota_CS27_Central'
'Proj_Minnesota_CS27_South'
'Proj_Minnesota_CS83_North'
'Proj_Minnesota_CS83_Central'
'Proj_Minnesota_CS83_South'
'Proj_Mississippi_CS27_East'
'Proj_Mississippi_CS27_West'
'Proj_Mississippi_CS83_East'
'Proj_Mississippi_CS83_West'
'Proj_Missouri_CS27_East'
'Proj_Missouri_CS27_Central'
'Proj_Missouri_CS27_West'
'Proj_Missouri_CS83_East'
'Proj_Missouri_CS83_Central'
'Proj_Missouri_CS83_West'
'Proj_Montana_CS27_North'
'Proj_Montana_CS27_Central'
'Proj_Montana_CS27_South'
'Proj_Montana_CS83'
'Proj_Nebraska_CS27_North'
'Proj_Nebraska_CS27_South'
'Proj_Nebraska_CS83'
'Proj_Nevada_CS27_East'
'Proj_Nevada_CS27_Central'
'Proj_Nevada_CS27_West'
'Proj_Nevada_CS83_East'
'Proj_Nevada_CS83_Central'
'Proj_Nevada_CS83_West'
'Proj_New_Hampshire_CS27'
'Proj_New_Hampshire_CS83'
'Proj_New_Jersey_CS27'
'Proj_New_Jersey_CS83'
'Proj_New_Mexico_CS27_East'
'Proj_New_Mexico_CS27_Central'
'Proj_New_Mexico_CS27_West'
'Proj_New_Mexico_CS83_East'
'Proj_New_Mexico_CS83_Central'
'Proj_New_Mexico_CS83_West'
'Proj_New_York_CS27_East'
'Proj_New_York_CS27_Central'
'Proj_New_York_CS27_West'
'Proj_New_York_CS27_Long_Island'
'Proj_New_York_CS83_East'
'Proj_New_York_CS83_Central'
'Proj_New_York_CS83_West'
'Proj_New_York_CS83_Long_Island'
'Proj_North_Carolina_CS27'
'Proj_North_Carolina_CS83'
'Proj_North_Dakota_CS27_North'
'Proj_North_Dakota_CS27_South'
'Proj_North_Dakota_CS83_North'
'Proj_North_Dakota_CS83_South'
'Proj_Ohio_CS27_North'
'Proj_Ohio_CS27_South'
'Proj_Ohio_CS83_North'
'Proj_Ohio_CS83_South'
'Proj_Oklahoma_CS27_North'
'Proj_Oklahoma_CS27_South'
'Proj_Oklahoma_CS83_North'
'Proj_Oklahoma_CS83_South'
'Proj_Oregon_CS27_North'
'Proj_Oregon_CS27_South'
'Proj_Oregon_CS83_North'
'Proj_Oregon_CS83_South'
'Proj_Pennsylvania_CS27_North'
'Proj_Pennsylvania_CS27_South'
'Proj_Pennsylvania_CS83_North'
'Proj_Pennsylvania_CS83_South'
'Proj_Rhode_Island_CS27'
'Proj_Rhode_Island_CS83'
'Proj_South_Carolina_CS27_North'
'Proj_South_Carolina_CS27_South'
'Proj_South_Carolina_CS83'
'Proj_South_Dakota_CS27_North'
'Proj_South_Dakota_CS27_South'
'Proj_South_Dakota_CS83_North'
'Proj_South_Dakota_CS83_South'
'Proj_Tennessee_CS27'
'Proj_Tennessee_CS83'
'Proj_Texas_CS27_North'
'Proj_Texas_CS27_North_Central'
'Proj_Texas_CS27_Central'
'Proj_Texas_CS27_South_Central'
'Proj_Texas_CS27_South'
'Proj_Texas_CS83_North'
'Proj_Texas_CS83_North_Central'
'Proj_Texas_CS83_Central'
'Proj_Texas_CS83_South_Central'
'Proj_Texas_CS83_South'
'Proj_Utah_CS27_North'
'Proj_Utah_CS27_Central'
'Proj_Utah_CS27_South'
'Proj_Utah_CS83_North'
'Proj_Utah_CS83_Central'
'Proj_Utah_CS83_South'
'Proj_Vermont_CS27'
'Proj_Vermont_CS83'
'Proj_Virginia_CS27_North'
'Proj_Virginia_CS27_South'
'Proj_Virginia_CS83_North'
'Proj_Virginia_CS83_South'
'Proj_Washington_CS27_North'
'Proj_Washington_CS27_South'
'Proj_Washington_CS83_North'
'Proj_Washington_CS83_South'
'Proj_West_Virginia_CS27_North'
'Proj_West_Virginia_CS27_South'
'Proj_West_Virginia_CS83_North'
'Proj_West_Virginia_CS83_South'
'Proj_Wisconsin_CS27_North'
'Proj_Wisconsin_CS27_Central'
'Proj_Wisconsin_CS27_South'
'Proj_Wisconsin_CS83_North'
'Proj_Wisconsin_CS83_Central'
'Proj_Wisconsin_CS83_South'
'Proj_Wyoming_CS27_East'
'Proj_Wyoming_CS27_East_Central'
'Proj_Wyoming_CS27_West_Central'
'Proj_Wyoming_CS27_West'
'Proj_Wyoming_CS83_East'
'Proj_Wyoming_CS83_East_Central'
'Proj_Wyoming_CS83_West_Central'
'Proj_Wyoming_CS83_West'
'Proj_Alaska_CS27_1'
'Proj_Alaska_CS27_2'
'Proj_Alaska_CS27_3'
'Proj_Alaska_CS27_4'
'Proj_Alaska_CS27_5'
'Proj_Alaska_CS27_6'
'Proj_Alaska_CS27_7'
'Proj_Alaska_CS27_8'
'Proj_Alaska_CS27_9'
'Proj_Alaska_CS27_10'
'Proj_Alaska_CS83_1'
'Proj_Alaska_CS83_2'
'Proj_Alaska_CS83_3'
'Proj_Alaska_CS83_4'
'Proj_Alaska_CS83_5'
'Proj_Alaska_CS83_6'
'Proj_Alaska_CS83_7'
'Proj_Alaska_CS83_8'
'Proj_Alaska_CS83_9'
'Proj_Alaska_CS83_10'
'Proj_Hawaii_CS27_1'
'Proj_Hawaii_CS27_2'
'Proj_Hawaii_CS27_3'
'Proj_Hawaii_CS27_4'
'Proj_Hawaii_CS27_5'
'Proj_Hawaii_CS83_1'
'Proj_Hawaii_CS83_2'
'Proj_Hawaii_CS83_3'
'Proj_Hawaii_CS83_4'
'Proj_Hawaii_CS83_5'
'Proj_Puerto_Rico_CS27'
'Proj_St_Croix'
'Proj_Puerto_Rico_Virgin_Is'
'Proj_BLM_14N_feet'
'Proj_BLM_15N_feet'
'Proj_BLM_16N_feet'
'Proj_BLM_17N_feet'
'Proj_Map_Grid_of_Australia_48'
'Proj_Map_Grid_of_Australia_49'
'Proj_Map_Grid_of_Australia_50'
'Proj_Map_Grid_of_Australia_51'
'Proj_Map_Grid_of_Australia_52'
'Proj_Map_Grid_of_Australia_53'
'Proj_Map_Grid_of_Australia_54'
'Proj_Map_Grid_of_Australia_55'
'Proj_Map_Grid_of_Australia_56'
'Proj_Map_Grid_of_Australia_57'
'Proj_Map_Grid_of_Australia_58'
'Proj_Australian_Map_Grid_48'
'Proj_Australian_Map_Grid_49'
'Proj_Australian_Map_Grid_50'
'Proj_Australian_Map_Grid_51'
'Proj_Australian_Map_Grid_52'
'Proj_Australian_Map_Grid_53'
'Proj_Australian_Map_Grid_54'
'Proj_Australian_Map_Grid_55'
'Proj_Australian_Map_Grid_56'
'Proj_Australian_Map_Grid_57'
'Proj_Australian_Map_Grid_58'
'Proj_Argentina_1'
'Proj_Argentina_2'
'Proj_Argentina_3'
'Proj_Argentina_4'
'Proj_Argentina_5'
'Proj_Argentina_6'
'Proj_Argentina_7'
'Proj_Colombia_3W'
'Proj_Colombia_Bogota'
'Proj_Colombia_3E'
'Proj_Colombia_6E'
'Proj_Egypt_Red_Belt'
'Proj_Egypt_Purple_Belt'
'Proj_Extended_Purple_Belt'
'Proj_New_Zealand_North_Island_Nat_Grid'
'Proj_New_Zealand_South_Island_Nat_Grid'
'Proj_Bahrain_Grid'
'Proj_Netherlands_E_Indies_Equatorial'
'Proj_RSO_Borneo'
'user-defined'};

   val = [0
10101
10102
10131
10132
10201
10202
10203
10231
10232
10233
10301
10302
10331
10332
10401
10402
10403
10404
10405
10406
10407
10431
10432
10433
10434
10435
10436
10501
10502
10503
10531
10532
10533
10600
10630
10700
10730
10901
10902
10903
10931
10932
10933
11001
11002
11031
11032
11101
11102
11103
11131
11132
11133
11201
11202
11231
11232
11301
11302
11331
11332
11401
11402
11431
11432
11501
11502
11531
11532
11601
11602
11631
11632
11701
11702
11731
11732
11801
11802
11831
11832
11900
11930
12001
12002
12031
12032
12101
12102
12103
12111
12112
12113
12141
12142
12143
12201
12202
12203
12231
12232
12233
12301
12302
12331
12332
12401
12402
12403
12431
12432
12433
12501
12502
12503
12530
12601
12602
12630
12701
12702
12703
12731
12732
12733
12800
12830
12900
12930
13001
13002
13003
13031
13032
13033
13101
13102
13103
13104
13131
13132
13133
13134
13200
13230
13301
13302
13331
13332
13401
13402
13431
13432
13501
13502
13531
13532
13601
13602
13631
13632
13701
13702
13731
13732
13800
13830
13901
13902
13930
14001
14002
14031
14032
14100
14130
14201
14202
14203
14204
14205
14231
14232
14233
14234
14235
14301
14302
14303
14331
14332
14333
14400
14430
14501
14502
14531
14532
14601
14602
14631
14632
14701
14702
14731
14732
14801
14802
14803
14831
14832
14833
14901
14902
14903
14904
14931
14932
14933
14934
15001
15002
15003
15004
15005
15006
15007
15008
15009
15010
15031
15032
15033
15034
15035
15036
15037
15038
15039
15040
15101
15102
15103
15104
15105
15131
15132
15133
15134
15135
15201
15202
15230
15914
15915
15916
15917
17348
17349
17350
17351
17352
17353
17354
17355
17356
17357
17358
17448
17449
17450
17451
17452
17453
17454
17455
17456
17457
17458
18031
18032
18033
18034
18035
18036
18037
18051
18052
18053
18054
18072
18073
18074
18141
18142
19900
19905
19912
32767];

   x = x + 0.06;
   w = 0.25;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','popupmenu', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String',str, ...
	'user',val, ...
   	'Tag','ProjectionGeoKey');

   x = x + 0.27;
   w = 0.06;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','CoordTrans', ...
   	'Tag','');

   str = {''
'CT_TransverseMercator'
'CT_TransvMercator_Modified_Alaska'
'CT_ObliqueMercator'
'CT_ObliqueMercator_Laborde'
'CT_ObliqueMercator_Rosenmund'
'CT_ObliqueMercator_Spherical'
'CT_Mercator'
'CT_LambertConfConic_2SP'
'CT_LambertConfConic_Helmert'
'CT_LambertAzimEqualArea'
'CT_AlbersEqualArea'
'CT_AzimuthalEquidistant'
'CT_EquidistantConic'
'CT_Stereographic'
'CT_PolarStereographic'
'CT_ObliqueStereographic'
'CT_Equirectangular'
'CT_CassiniSoldner'
'CT_Gnomonic'
'CT_MillerCylindrical'
'CT_Orthographic'
'CT_Polyconic'
'CT_Robinson'
'CT_Sinusoidal'
'CT_VanDerGrinten'
'CT_NewZealandMapGrid'
'CT_TransvMercator_SouthOriented'
'user-defined'};

   x = x + 0.06;
   w = 0.23;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','popupmenu', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String',str, ...
   	'Tag','ProjCoordTransGeoKey');

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   x = 0.01;
   y = y - 0.05;
   w = 0.09;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','ProjLinearUnits', ...
   	'Tag','');

   str = {''
'Meter'
'Foot'
'Foot_US_Survey'
'Foot_Modified_American'
'Foot_Clarke'
'Foot_Indian'
'Link'
'Link_Benoit'
'Link_Sears'
'Chain_Benoit'
'Chain_Sears'
'Yard_Sears'
'Yard_Indian'
'Fathom'
'Mile_International_Nautical'
'user-defined'};

   x = x + 0.09;
   w = 0.18;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','popupmenu', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String',str, ...
   	'Tag','ProjLinearUnitsGeoKey');

   x = x + 0.23;
   w = 0.08;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','VerticalCSType', ...
   	'Tag','');

   str = {''
'VertCS_Airy_1830_ellipsoid'
'VertCS_Airy_Modified_1849_ellipsoid'
'VertCS_ANS_ellipsoid'
'VertCS_Bessel_1841_ellipsoid'
'VertCS_Bessel_Modified_ellipsoid'
'VertCS_Bessel_Namibia_ellipsoid'
'VertCS_Clarke_1858_ellipsoid'
'VertCS_Clarke_1866_ellipsoid'
'VertCS_Clarke_1880_Benoit_ellipsoid'
'VertCS_Clarke_1880_IGN_ellipsoid'
'VertCS_Clarke_1880_RGS_ellipsoid'
'VertCS_Clarke_1880_Arc_ellipsoid'
'VertCS_Clarke_1880_SGA_1922_ellipsoid'
'VertCS_Everest_1830_1937_Adjustment_ellipsoid'
'VertCS_Everest_1830_1967_Definition_ellipsoid'
'VertCS_Everest_1830_1975_Definition_ellipsoid'
'VertCS_Everest_1830_Modified_ellipsoid'
'VertCS_GRS_1980_ellipsoid'
'VertCS_Helmert_1906_ellipsoid'
'VertCS_INS_ellipsoid'
'VertCS_International_1924_ellipsoid'
'VertCS_International_1967_ellipsoid'
'VertCS_Krassowsky_1940_ellipsoid'
'VertCS_NWL_9D_ellipsoid'
'VertCS_NWL_10D_ellipsoid'
'VertCS_Plessis_1817_ellipsoid'
'VertCS_Struve_1860_ellipsoid'
'VertCS_War_Office_ellipsoid'
'VertCS_WGS_84_ellipsoid'
'VertCS_GEM_10C_ellipsoid'
'VertCS_OSU86F_ellipsoid'
'VertCS_OSU91A_ellipsoid'
'VertCS_Newlyn'
'VertCS_North_American_Vertical_Datum_1929'
'VertCS_North_American_Vertical_Datum_1988'
'VertCS_Yellow_Sea_1956'
'VertCS_Baltic_Sea'
'VertCS_Caspian_Sea'
'user-defined'};

   x = x + 0.08;
   w = 0.28;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','popupmenu', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String',str, ...
   	'Tag','VerticalCSTypeGeoKey');

   x = x + 0.33	;
   w = 0.07;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','VerticalUnits', ...
   	'Tag','');

   str = {''
'Meter'
'Foot'
'Foot_US_Survey'
'Foot_Modified_American'
'Foot_Clarke'
'Foot_Indian'
'Link'
'Link_Benoit'
'Link_Sears'
'Chain_Benoit'
'Chain_Sears'
'Yard_Sears'
'Yard_Indian'
'Fathom'
'Mile_International_Nautical'
'user-defined'};

   x = x + 0.07;
   w = 0.18;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','popupmenu', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String',str, ...
   	'Tag','VerticalUnitsGeoKey');

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   x = 0.01;
   y = y - 0.05;
   w = 0.08;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','GTCitation', ...
   	'Tag','');

   x = x + 0.08;
   w = 0.38;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'horizon','left', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','GTCitationGeoKey');

   x = 0.51;
   w = 0.08;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','GeogCitation', ...
   	'Tag','');

   x = x + 0.08;
   w = 0.38;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'horizon','left', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','GeogCitationGeoKey');

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   x = 0.01;
   y = y - 0.05;
   w = 0.08;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','PCSCitation', ...
   	'Tag','');

   x = x + 0.08;
   w = 0.38;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'horizon','left', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','PCSCitationGeoKey');

   x = 0.51;
   w = 0.08;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','VerticalCitation', ...
   	'Tag','');

   x = x + 0.08;
   w = 0.38;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'horizon','left', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','VerticalCitationGeoKey');

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   x = 0.01;
   y = y - 0.08;
   w = 1;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'fore',[1 0 0], ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
	'fontweight','bold', ...
   	'FontSize',fnt+0.2, ...
        'Position',pos, ...
        'String','The following fields are optional and for user-defined only, please DO NOT fill those that you are not sure:', ...
   	'Tag','');

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   x = 0.01;
   y = y - 0.05;
   w = 0.1;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','GeogLinearUnitSize', ...
   	'Tag','');

   x = x + 0.1;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','GeogLinearUnitSizeGeoKey');

   x = x + 0.07;
   w = 0.11;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','GeogAngularUnitSize', ...
   	'Tag','');

   x = x + 0.11;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','GeogAngularUnitSizeGeoKey');

   x = x + 0.08;
   w = 0.08;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','SemiMajorAxis', ...
   	'Tag','');

   x = x + 0.08;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','GeogSemiMajorAxisGeoKey');

   x = x + 0.07;
   w = 0.08;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','SemiMinorAxis', ...
   	'Tag','');

   x = x + 0.08;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','GeogSemiMinorAxisGeoKey');

   x = x + 0.08;
   w = 0.07;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','InvFlattening', ...
   	'Tag','');

   x = x + 0.07;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','GeogInvFlatteningGeoKey');

   x = x + 0.07;
   w = 0.1;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','PrimeMeridianLong', ...
   	'Tag','');

   x = x + 0.1;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','GeogPrimeMeridianLongGeoKey');

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   x = 0.01;
   y = y - 0.05;
   w = 0.1;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','ProjLinearUnitSize', ...
   	'Tag','');

   x = x + 0.1;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','ProjLinearUnitSizeGeoKey');

   x = x + 0.27;
   w = 0.07;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','StdParallel1', ...
   	'Tag','');

   x = x + 0.07;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','ProjStdParallel1GeoKey');

   x = x + 0.08;
   w = 0.07;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','StdParallel2', ...
   	'Tag','');

   x = x + 0.07;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','ProjStdParallel2GeoKey');

   x = x + 0.07;
   w = 0.08;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','NatOriginLong', ...
   	'Tag','');

   x = x + 0.08;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','ProjNatOriginLongGeoKey');

   x = x + 0.1;
   w = 0.07;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','NatOriginLat', ...
   	'Tag','');

   x = x + 0.07;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','ProjNatOriginLatGeoKey');

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   x = 0.01;
   y = y - 0.05;
   w = 0.1;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','ProjFalseEasting', ...
   	'Tag','');

   x = x + 0.1;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','ProjFalseEastingGeoKey');

   x = x + 0.07;
   w = 0.08;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','FalseNorthing', ...
   	'Tag','');

   x = x + 0.08;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','ProjFalseNorthingGeoKey');

   x = x + 0.07;
   w = 0.09;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','FalseOriginLong', ...
   	'Tag','');

   x = x + 0.09;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','ProjFalseOriginLongGeoKey');

   x = x + 0.07;
   w = 0.08;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','FalseOriginLat', ...
   	'Tag','');

   x = x + 0.08;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','ProjFalseOriginLatGeoKey');

   x = x + 0.08;
   w = 0.1;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','FalseOriginEasting', ...
   	'Tag','');

   x = x + 0.1;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','ProjFalseOriginEastingGeoKey');

   x = x + 0.07;
   w = 0.1;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','FalseOriginNorthing', ...
   	'Tag','');

   x = x + 0.1;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','ProjFalseOriginNorthingGeoKey');

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   x = 0.01;
   y = y - 0.05;
   w = 0.1;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','ProjCenterEasting', ...
   	'Tag','');

   x = x + 0.1;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','ProjCenterEastingGeoKey');

   x = x + 0.07;
   w = 0.08;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','CenterNorthing', ...
   	'Tag','');

   x = x + 0.08;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','ProjCenterNorthingGeoKey');

   x = x + 0.09;
   w = 0.07;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','CenterLong', ...
   	'Tag','');

   x = x + 0.07;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','ProjCenterLongGeoKey');

   x = x + 0.09;
   w = 0.06;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','CenterLat', ...
   	'Tag','');

   x = x + 0.06;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','ProjCenterLatGeoKey');

   x = x + 0.09;
   w = 0.09;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','ScaleAtNatOrigin', ...
   	'Tag','');

   x = x + 0.09;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','ProjScaleAtNatOriginGeoKey');

   x = x + 0.09;
   w = 0.08;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','ScaleAtCenter', ...
   	'Tag','');

   x = x + 0.08;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','ProjScaleAtCenterGeoKey');

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   x = 0.01;
   y = y - 0.05;
   w = 0.1;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','ProjAzimuthAngle', ...
   	'Tag','');

   x = x + 0.1;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','ProjAzimuthAngleGeoKey');

   x = x + 0.07;
   w = 0.11;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','text', ...
	'horizon','left', ...
	'back',[0.8 0.8 0.8], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','StraightVertPoleLong', ...
   	'Tag','');

   x = x + 0.11;
   w = 0.05;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
	'style','edit', ...
	'back',[1 1 1], ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
   	'Tag','ProjStraightVertPoleLongGeoKey');

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   x = 0.75;
   y = 0.04;
   w = 0.1;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','OK', ...
   	'Callback','make_option(''ok'');', ...
   	'Tag','');

   x = x + 0.12;
   pos = [x y w h];

   c = uicontrol('Parent',h0, ...
        'Units','normal', ...
   	'FontUnits','normal', ...
   	'FontSize',fnt, ...
        'Position',pos, ...
        'String','Cancel', ...
   	'Callback','make_option(''cancel'');', ...
   	'Tag','');

   setappdata(gcf, 'bbox', bbox);

   if ~isempty(bbox)
      set(findobj(gcf,'tag','ModelPixelScaleTag_x'),'back',[0.9 0.9 0.9],'enable','inactive','string','');
      set(findobj(gcf,'tag','ModelPixelScaleTag_y'),'back',[0.9 0.9 0.9],'enable','inactive','string','');
      set(findobj(gcf,'tag','ModelPixelScaleTag_z'),'back',[0.9 0.9 0.9],'enable','inactive','string','0');
      set(findobj(gcf,'tag','ModelTiepointTag_i'),'back',[0.9 0.9 0.9],'enable','inactive','string','0');
      set(findobj(gcf,'tag','ModelTiepointTag_j'),'back',[0.9 0.9 0.9],'enable','inactive','string','0');
      set(findobj(gcf,'tag','ModelTiepointTag_k'),'back',[0.9 0.9 0.9],'enable','inactive','string','0');
      set(findobj(gcf,'tag','ModelTiepointTag_x'),'back',[0.9 0.9 0.9],'enable','inactive','string','');
      set(findobj(gcf,'tag','ModelTiepointTag_y'),'back',[0.9 0.9 0.9],'enable','inactive','string','');
      set(findobj(gcf,'tag','ModelTiepointTag_z'),'back',[0.9 0.9 0.9],'enable','inactive','string','0');
      set(findobj(gcf,'tag','GeographicTypeGeoKey'),'value',119);
   else
      set(findobj(gcf,'tag','GeographicTypeGeoKey'),'value',1);
   end

   return;						% init


%------------------------------------------------------------------------
function status = checkout

   status = 1;
   opt.GTModelTypeGeoKey = get(findobj(gcf,'tag','GTModelTypeGeoKey'),'value');
   if opt.GTModelTypeGeoKey == 4, opt.GTModelTypeGeoKey = 32767; end;

   opt.GTRasterTypeGeoKey = get(findobj(gcf,'tag','GTRasterTypeGeoKey'),'value');
   if opt.GTRasterTypeGeoKey == 3, opt.GTRasterTypeGeoKey = 32767; end;

   bbox = getappdata(gcf, 'bbox');

   if opt.GTModelTypeGeoKey ~= 2 | isempty(bbox)
      setappdata(gcf, 'bbox', []);
      ModelPixelScaleTag_x = str2num(get(findobj(gcf,'tag','ModelPixelScaleTag_x'),'string'));
      ModelPixelScaleTag_y = str2num(get(findobj(gcf,'tag','ModelPixelScaleTag_y'),'string'));
      ModelPixelScaleTag_z = str2num(get(findobj(gcf,'tag','ModelPixelScaleTag_z'),'string'));
      ModelTiepointTag_i = str2num(get(findobj(gcf,'tag','ModelTiepointTag_i'),'string'));
      ModelTiepointTag_j = str2num(get(findobj(gcf,'tag','ModelTiepointTag_j'),'string'));
      ModelTiepointTag_k = str2num(get(findobj(gcf,'tag','ModelTiepointTag_k'),'string'));
      ModelTiepointTag_x = str2num(get(findobj(gcf,'tag','ModelTiepointTag_x'),'string'));
      ModelTiepointTag_y = str2num(get(findobj(gcf,'tag','ModelTiepointTag_y'),'string'));
      ModelTiepointTag_z = str2num(get(findobj(gcf,'tag','ModelTiepointTag_z'),'string'));

      if isempty(ModelPixelScaleTag_x) | isempty(ModelPixelScaleTag_y) | isempty(ModelPixelScaleTag_z) | ...
	isempty(ModelTiepointTag_i) | isempty(ModelTiepointTag_j) | isempty(ModelTiepointTag_k) | ...
	isempty(ModelTiepointTag_x) | isempty(ModelTiepointTag_y) | isempty(ModelTiepointTag_z)

         msgbox('Make sure that the required fields are selected or filled, unless they are grayed out.','ERROR','modal');
         setappdata(gcf, 'opt', []);
         status = 0;
         return;
      end

      opt.ModelPixelScaleTag = [ModelPixelScaleTag_x; ModelPixelScaleTag_y; ModelPixelScaleTag_z];
      opt.ModelTiepointTag = [ModelTiepointTag_i; ModelTiepointTag_j; ModelTiepointTag_k; ModelTiepointTag_x; ModelTiepointTag_y; ModelTiepointTag_z];
   end

   tmp = get(findobj(gcf,'tag','GeographicTypeGeoKey'),'value');
   if tmp > 1 & tmp < 117
      opt.GeographicTypeGeoKey = tmp + 4199;
   elseif tmp > 119 & tmp < 133
      opt.GeographicTypeGeoKey = tmp + 4681;
   elseif tmp > 134 & tmp < 170
      opt.GeographicTypeGeoKey = tmp + 3866;
   elseif tmp ==117
      opt.GeographicTypeGeoKey = 4322;
   elseif tmp ==118
      opt.GeographicTypeGeoKey = 4324;
   elseif tmp ==119
      opt.GeographicTypeGeoKey = 4326;
   elseif tmp ==133
      opt.GeographicTypeGeoKey = 4901;
   elseif tmp ==134
      opt.GeographicTypeGeoKey = 4902;
   elseif tmp ==170
      opt.GeographicTypeGeoKey = 32767;
   end

   tmp = get(findobj(gcf,'tag','GeogGeodeticDatumGeoKey'),'value');
   if tmp > 1 & tmp < 117
      opt.GeogGeodeticDatumGeoKey = tmp + 6199;
   elseif tmp > 121 & tmp < 157
      opt.GeogGeodeticDatumGeoKey = tmp + 5879;
   elseif tmp ==117
      opt.GeogGeodeticDatumGeoKey = 6322;
   elseif tmp ==118
      opt.GeogGeodeticDatumGeoKey = 6324;
   elseif tmp ==119
      opt.GeogGeodeticDatumGeoKey = 6326;
   elseif tmp ==120
      opt.GeogGeodeticDatumGeoKey = 6901;
   elseif tmp ==121
      opt.GeogGeodeticDatumGeoKey = 6902;
   elseif tmp ==157
      opt.GeogGeodeticDatumGeoKey = 32767;
   end

   tmp = get(findobj(gcf,'tag','GeogPrimeMeridianGeoKey'),'value');
   if tmp > 1 & tmp < 13
      opt.GeogPrimeMeridianGeoKey = tmp + 8899;
   elseif tmp == 13
      opt.GeogPrimeMeridianGeoKey = 32767;
   end

   tmp = get(findobj(gcf,'tag','GeogLinearUnitsGeoKey'),'value');
   if tmp > 1 & tmp < 17
      opt.GeogLinearUnitsGeoKey = tmp + 8999;
   elseif tmp == 17
      opt.GeogLinearUnitsGeoKey = 32767;
   end

   tmp = get(findobj(gcf,'tag','GeogAngularUnitsGeoKey'),'value');
   if tmp > 1 & tmp < 10
      opt.GeogAngularUnitsGeoKey = tmp + 9099;
   elseif tmp == 10
      opt.GeogAngularUnitsGeoKey = 32767;
   end

   tmp = get(findobj(gcf,'tag','GeogEllipsoidGeoKey'),'value');
   if tmp > 1 & tmp < 37
      opt.GeogEllipsoidGeoKey = tmp + 6999;
   elseif tmp == 37
      opt.GeogEllipsoidGeoKey = 32767;
   end

   tmp = get(findobj(gcf,'tag','GeogAzimuthUnitsGeoKey'),'value');
   if tmp > 1 & tmp < 10
      opt.GeogAzimuthUnitsGeoKey = tmp + 9099;
   elseif tmp == 10
      opt.GeogAzimuthUnitsGeoKey = 32767;
   end

   tmp = get(findobj(gcf,'tag','ProjectedCSTypeGeoKey'),'user');
   tmp = tmp(get(findobj(gcf,'tag','ProjectedCSTypeGeoKey'),'value'));
   if tmp > 0
      opt.ProjectedCSTypeGeoKey = tmp;
   end

   tmp = get(findobj(gcf,'tag','ProjectionGeoKey'),'user');
   tmp = tmp(get(findobj(gcf,'tag','ProjectionGeoKey'),'value'));
   if tmp > 0
      opt.ProjectionGeoKey = tmp;
   end

   tmp = get(findobj(gcf,'tag','ProjCoordTransGeoKey'),'value');
   if tmp > 1 & tmp < 29
      opt.ProjCoordTransGeoKey = tmp - 1;
   elseif tmp == 29
      opt.ProjCoordTransGeoKey = 32767;
   end

   tmp = get(findobj(gcf,'tag','ProjLinearUnitsGeoKey'),'value');
   if tmp > 1 & tmp < 17
      opt.ProjLinearUnitsGeoKey = tmp + 8999;
   elseif tmp == 17
      opt.ProjLinearUnitsGeoKey = 32767;
   end

   tmp = get(findobj(gcf,'tag','VerticalCSTypeGeoKey'),'value');
   if tmp > 1 & tmp < 12
      opt.VerticalCSTypeGeoKey = tmp + 4999;
   elseif tmp > 11 & tmp < 34
      opt.VerticalCSTypeGeoKey = tmp + 5000;
   elseif tmp > 33 & tmp < 40
      opt.VerticalCSTypeGeoKey = tmp + 5067;
   elseif tmp ==40
      opt.VerticalCSTypeGeoKey = 32767;
   end

   tmp = get(findobj(gcf,'tag','VerticalUnitsGeoKey'),'value');
   if tmp > 1 & tmp < 17
      opt.VerticalUnitsGeoKey = tmp + 8999;
   elseif tmp == 17
      opt.VerticalUnitsGeoKey = 32767;
   end

   tmp = get(findobj(gcf,'tag','GeogLinearUnitSizeGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp) & ~isempty(str2num(tmp))
      opt.GeogLinearUnitSizeGeoKey = str2num(tmp);
   end

   tmp = get(findobj(gcf,'tag','GeogAngularUnitSizeGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp) & ~isempty(str2num(tmp))
      opt.GeogAngularUnitSizeGeoKey = str2num(tmp);
   end

   tmp = get(findobj(gcf,'tag','GeogSemiMajorAxisGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp) & ~isempty(str2num(tmp))
      opt.GeogSemiMajorAxisGeoKey = str2num(tmp);
   end

   tmp = get(findobj(gcf,'tag','GeogSemiMinorAxisGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp) & ~isempty(str2num(tmp))
      opt.GeogSemiMinorAxisGeoKey = str2num(tmp);
   end

   tmp = get(findobj(gcf,'tag','GeogInvFlatteningGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp) & ~isempty(str2num(tmp))
      opt.GeogInvFlatteningGeoKey = str2num(tmp);
   end

   tmp = get(findobj(gcf,'tag','GeogPrimeMeridianLongGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp) & ~isempty(str2num(tmp))
      opt.GeogPrimeMeridianLongGeoKey = str2num(tmp);
   end

   tmp = get(findobj(gcf,'tag','ProjLinearUnitSizeGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp) & ~isempty(str2num(tmp))
      opt.ProjLinearUnitSizeGeoKey = str2num(tmp);
   end

   tmp = get(findobj(gcf,'tag','ProjStdParallel1GeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp) & ~isempty(str2num(tmp))
      opt.ProjStdParallel1GeoKey = str2num(tmp);
   end

   tmp = get(findobj(gcf,'tag','ProjStdParallel2GeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp) & ~isempty(str2num(tmp))
      opt.ProjStdParallel2GeoKey = str2num(tmp);
   end

   tmp = get(findobj(gcf,'tag','ProjNatOriginLongGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp) & ~isempty(str2num(tmp))
      opt.ProjNatOriginLongGeoKey = str2num(tmp);
   end

   tmp = get(findobj(gcf,'tag','ProjNatOriginLatGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp) & ~isempty(str2num(tmp))
      opt.ProjNatOriginLatGeoKey = str2num(tmp);
   end

   tmp = get(findobj(gcf,'tag','ProjFalseEastingGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp) & ~isempty(str2num(tmp))
      opt.ProjFalseEastingGeoKey = str2num(tmp);
   end

   tmp = get(findobj(gcf,'tag','ProjFalseNorthingGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp) & ~isempty(str2num(tmp))
      opt.ProjFalseNorthingGeoKey = str2num(tmp);
   end

   tmp = get(findobj(gcf,'tag','ProjFalseOriginLongGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp) & ~isempty(str2num(tmp))
      opt.ProjFalseOriginLongGeoKey = str2num(tmp);
   end

   tmp = get(findobj(gcf,'tag','ProjFalseOriginLatGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp) & ~isempty(str2num(tmp))
      opt.ProjFalseOriginLatGeoKey = str2num(tmp);
   end

   tmp = get(findobj(gcf,'tag','ProjFalseOriginEastingGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp) & ~isempty(str2num(tmp))
      opt.ProjFalseOriginEastingGeoKey = str2num(tmp);
   end

   tmp = get(findobj(gcf,'tag','ProjFalseOriginNorthingGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp) & ~isempty(str2num(tmp))
      opt.ProjFalseOriginNorthingGeoKey = str2num(tmp);
   end

   tmp = get(findobj(gcf,'tag','ProjCenterLongGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp) & ~isempty(str2num(tmp))
      opt.ProjCenterLongGeoKey = str2num(tmp);
   end

   tmp = get(findobj(gcf,'tag','ProjCenterLatGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp) & ~isempty(str2num(tmp))
      opt.ProjCenterLatGeoKey = str2num(tmp);
   end

   tmp = get(findobj(gcf,'tag','ProjCenterEastingGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp) & ~isempty(str2num(tmp))
      opt.ProjCenterEastingGeoKey = str2num(tmp);
   end

   tmp = get(findobj(gcf,'tag','ProjCenterNorthingGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp) & ~isempty(str2num(tmp))
      opt.ProjCenterNorthingGeoKey = str2num(tmp);
   end

   tmp = get(findobj(gcf,'tag','ProjScaleAtNatOriginGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp) & ~isempty(str2num(tmp))
      opt.ProjScaleAtNatOriginGeoKey = str2num(tmp);
   end

   tmp = get(findobj(gcf,'tag','ProjScaleAtCenterGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp) & ~isempty(str2num(tmp))
      opt.ProjScaleAtCenterGeoKey = str2num(tmp);
   end

   tmp = get(findobj(gcf,'tag','ProjAzimuthAngleGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp) & ~isempty(str2num(tmp))
      opt.ProjAzimuthAngleGeoKey = str2num(tmp);
   end

   tmp = get(findobj(gcf,'tag','ProjStraightVertPoleLongGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp) & ~isempty(str2num(tmp))
      opt.ProjStraightVertPoleLongGeoKey = str2num(tmp);
   end

   tmp = get(findobj(gcf,'tag','GTCitationGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp)
      opt.GTCitationGeoKey = tmp;
   end

   tmp = get(findobj(gcf,'tag','GeogCitationGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp)
      opt.GeogCitationGeoKey = tmp;
   end

   tmp = get(findobj(gcf,'tag','PCSCitationGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp)
      opt.PCSCitationGeoKey = tmp;
   end

   tmp = get(findobj(gcf,'tag','VerticalCitationGeoKey'),'string');
   warning off; tmp = deblank(fliplr(deblank(fliplr(tmp)))); warning backtrace;
   if ~isempty(tmp)
      opt.VerticalCitationGeoKey = tmp;
   end

   setappdata(gcf, 'opt', opt);

   return;						% checkout

