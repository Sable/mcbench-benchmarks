function [xout,yout,varargout] = sp_proj(zone,type,x,y,units)
% SP_PROJ - convert to and from US state plane coordinates
%
%   [XOUT,YOUT] = SP_PROJ(ZONE,TYPE,X,Y,UNITS) converts to or 
%   from US state plane coordinates X and Y located in the state
%   plane zone specified by ZONE. The TYPE and UNITS inputs are used to 
%   specify whether to convert from or to state plane coordinates and 
%   the units of the inputs or outputs. XOUT and YOUT will either 
%   be state plane coordinates or geographic coordinates based 
%   on the TYPE of transformation specified.
% 
%   All calcuations assume the NAD83 datum and GRS1980 spheriod.
%
%   [XOUT,YOUT,MSTRUCT] = SP_PROJ(...) - The optional third output
%   argument returns the map projection used by PROJFWD and 
%   PROJINV to perform the coordinate transformation.
%
%   INPUTS
%       'zone'  - State plane zone (string). Use SP_PROJ([],...) 
%                 to select the zone from a list of available zones. 
%                 Zones can also be specified using the FIPS ID (eg.
%                 '0401' specifies the 'California 1' zone).
%       'type'  - Two possible options: 'forward' converts from 
%                 geographic coordinates to state plane and 
%                 'inverse' converts from state plane coordinates to 
%                 geographic
%       'x'     - x coordinates (either state plane or longitude)
%       'y'     - y coordinates (either state plane or latitude)
%       'units' - units of input or output.  When converting to 
%                 state plane (ie. 'forward' option), units specifies
%                 the units of the output coordinates.  When converting
%                 from state plane to geographic, units specifies the 
%                 the units of the input coordinates. Units can either be
%                 'meters' or 'survey feet' [abr. 'm', 'sf', respectively]. 
%
%   EXAMPLE 
%   %geographic data
%   lat = 37.45569; 
%   lon = -122.17009; 
%   
%   % Calculate the x,y, coordinates in survey feet at my 
%   % office in the "California 1" state plane zone
%   [xsp,ysp] = sp_proj('california 1','forward',lon,lat,'sf')
%
%   % Re-calculate the geographic coordinates
%   [lon1,lat1] = sp_proj('california 1','inverse',xsp,ysp,'sf')
% 
% SEE ALSO PROJFWD PROJINV AXESM

% Andrew Stevens 01/18/2010
% astevens@usgs.gov

%check inputs
error(nargchk(5,5,nargin,'struct'));
if isempty(zone)
    zone=zone_ui;
else
    if isnumeric(zone)
        zone=sprintf('%0.4d',zone);
    end
end 


if ~any(strcmpi(type,{'forward','fwd','f',...
        'inverse','inv','i'}))
    error('TYPE must be either ''forward'', or ''inverse''')
end
if size(x(:))~=size(y(:))
    error('x- and y- inputs must be the same size')
end
if ~any(strcmpi(units,{'meters','m','feet',...
        'survey feet','sf'}))
    error('Units must be either ''meters'' or ''survey feet''')
else
    ur=unitsratio(units,'m');
end



%here we go
%define the map projection
fig=figure;
switch lower(zone)
    case {'alabama east', '0101'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='alabama east';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=200000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=30.5;
        mstruct.nparallels=1;
        mstruct.origin=[30.5 -85.833333 0];
        mstruct.scalefactor= 0.999960;
        
    case {'alabama west','0102'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='alabama west';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=600000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=30.000000;
        mstruct.nparallels=1;
        mstruct.origin=[30.0 -87.500000 0];
        mstruct.scalefactor= 0.999933;        
    
    case {'arizona central','0202'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='arizona central';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=213360*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=31.0;
        mstruct.nparallels=1;
        mstruct.origin=[31.0 -111.916667 0];
        mstruct.scalefactor= 0.999900;   
        
    case {'arizona east','0201'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='arizona east';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=213360*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=31.0;
        mstruct.nparallels=1;
        mstruct.origin=[31.0 -110.166667 0];
        mstruct.scalefactor= 0.999900;          

    case {'arizona west','0203'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='arizona west';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=213360*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=31.0;
        mstruct.nparallels=1;
        mstruct.origin=[31.0  -113.750000 0];
        mstruct.scalefactor= 0.999933;   

    case {'arkansas north','0301'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='arkansas north';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=400000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[34.933333 36.233333];
        mstruct.nparallels=2;
        mstruct.origin=[34.333333 -92.000000 0];
        mstruct.scalefactor=1;        
        
    case {'arkansas south','0302'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='arkansas south';
        mstruct.falsenorthing=400000*ur;
        mstruct.falseeasting=400000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[34.766667 33.300000];
        mstruct.nparallels=2;
        mstruct.origin=[32.666667 -92.000000 0];
        mstruct.scalefactor=1;         
        
    case {'california 1','0401'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='california 1';
        mstruct.falsenorthing=500000*ur;
        mstruct.falseeasting=2000000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[41.666667 40.000000];
        mstruct.nparallels=2;
        mstruct.origin=[39.333333 -122.000000 0];
        mstruct.scalefactor=1;        
        
    case {'california 2','0402'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='california 2';
        mstruct.falsenorthing=500000*ur;
        mstruct.falseeasting=2000000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[39.833333 38.333333];
        mstruct.nparallels=2;
        mstruct.origin=[37.666667 -122.000000 0];
        mstruct.scalefactor=1;     
        
    case {'california 3','0403'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='california 3';
        mstruct.falsenorthing=500000*ur;
        mstruct.falseeasting=2000000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[38.433333 37.066667];
        mstruct.nparallels=2;
        mstruct.origin=[36.500000 -120.500000 0];
        mstruct.scalefactor=1;           
        
    case {'california 4','0404'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='california 4';
        mstruct.falsenorthing=500000*ur;
        mstruct.falseeasting=2000000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[37.250000 36.000000];
        mstruct.nparallels=2;
        mstruct.origin=[35.333333 -119.000000 0];
        mstruct.scalefactor=1;      
        
    case {'california 5','0405'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='california 5';
        mstruct.falsenorthing=500000*ur;
        mstruct.falseeasting=2000000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[35.466667 34.033333];
        mstruct.nparallels=2;
        mstruct.origin=[ 33.500000 -118.000000 0];
        mstruct.scalefactor=1;           
        
    case {'california 6','0406'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='california 6';
        mstruct.falsenorthing=500000*ur;
        mstruct.falseeasting=2000000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[33.883333 32.783333];
        mstruct.nparallels=2;
        mstruct.origin=[32.166667 -116.250000 0];
        mstruct.scalefactor=1;  
        
    case {'colorado central','0502'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='colorado central';
        mstruct.falsenorthing=304800.609600*ur;
        mstruct.falseeasting=914401.828900*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[39.750000 38.450000];
        mstruct.nparallels=2;
        mstruct.origin=[37.833333 -105.500000 0];
        mstruct.scalefactor=1;          
        
    case {'colorado north','0501'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='colorado north';
        mstruct.falsenorthing=304800.609600*ur;
        mstruct.falseeasting=914401.828900*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[40.783333 39.716667];
        mstruct.nparallels=2;
        mstruct.origin=[39.333333 -105.500000 0];
        mstruct.scalefactor=1; 
        
    case {'colorado south','0503'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='colorado south';
        mstruct.falsenorthing=304800.609600*ur;
        mstruct.falseeasting=914401.828900*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[38.433333 37.233333];
        mstruct.nparallels=2;
        mstruct.origin=[36.666667 -105.500000 0];
        mstruct.scalefactor=1;           
        
    case {'connecticut','0600'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='connecticut';
        mstruct.falsenorthing=152400.304800*ur;
        mstruct.falseeasting=304800.609600*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[41.866667 41.200000];
        mstruct.nparallels=2;
        mstruct.origin=[40.833333  -72.750000 0];
        mstruct.scalefactor=1;   
        
    case {'delaware','0700'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='delaware';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=200000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=38.0;
        mstruct.nparallels=1;
        mstruct.origin=[38.0 -75.416667 0];
        mstruct.scalefactor= 0.999995;     
        
    case {'florida east','0901'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='florida east';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=200000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=24.333333;
        mstruct.nparallels=1;
        mstruct.origin=[24.333333 -81.000000 0];
        mstruct.scalefactor= 0.999941;    
        
    case {'florida north','0903'}
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='florida north';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=600000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[30.750000 29.583333];
        mstruct.nparallels=2;
        mstruct.origin=[29.000000  -84.500000 0];
        mstruct.scalefactor=1;   
        
    case {'florida west','0902'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='florida west';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=200000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=24.333333;
        mstruct.nparallels=1;
        mstruct.origin=[24.333333 -82.000000 0];
        mstruct.scalefactor= 0.999941;            
        
    case {'georgia east','1001'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='georgia east';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=200000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=30.0;
        mstruct.nparallels=1;
        mstruct.origin=[30.0 -82.166667 0];
        mstruct.scalefactor= 0.999900;     
        
    case {'georgia west','1002'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='georgia west';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=700000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=30.0;
        mstruct.nparallels=1;
        mstruct.origin=[30.0 -84.166667 0];
        mstruct.scalefactor= 0.999900;      
        
    case {'hawaii 1','5101'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='hawaii 1';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=18.833333;
        mstruct.nparallels=1;
        mstruct.origin=[18.833333 -155.5 0];
        mstruct.scalefactor= 0.999967;        
        
    case {'hawaii 2','5102'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='hawaii 2';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=20.333333;
        mstruct.nparallels=1;
        mstruct.origin=[20.333333 -156.666667 0];
        mstruct.scalefactor= 0.999967;        
        
    case {'hawaii 3','5103'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='hawaii 3';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=21.166667;
        mstruct.nparallels=1;
        mstruct.origin=[21.166667 -158.0 0];
        mstruct.scalefactor= 0.999990;         
        
    case {'hawaii 4','5104'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='hawaii 4';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=21.833333;
        mstruct.nparallels=1;
        mstruct.origin=[21.833333 -159.5 0];
        mstruct.scalefactor= 0.999990;        
        
    case {'hawaii 5','5105'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='hawaii 5';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=21.666667;
        mstruct.nparallels=1;
        mstruct.origin=[21.666667 -160.166667 0];
        mstruct.scalefactor= 1.000000;             
        
    case {'idaho central','1102'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='idaho central';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=41.666667;
        mstruct.nparallels=1;
        mstruct.origin=[41.666667 -114.000000 0];
        mstruct.scalefactor= 0.999947; 
        
    case {'idaho east','1101'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='idaho east';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=200000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=41.666667;
        mstruct.nparallels=1;
        mstruct.origin=[41.666667 -112.166667 0];
        mstruct.scalefactor=  0.999947;            
        
    case {'idaho west','1103'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='idaho west';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=800000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=41.666667;
        mstruct.nparallels=1;
        mstruct.origin=[41.666667 -115.750000 0];
        mstruct.scalefactor=  0.999933;   
        
    case {'illinois east','1201'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='illinois east';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=300000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=36.666667;
        mstruct.nparallels=1;
        mstruct.origin=[36.666667 -88.333333 0];
        mstruct.scalefactor=  0.999975;       
        
    case {'illinois west','1202'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='illinois west';
        mstruct.falsenorthing=0*ur;
        mstruct.falseeasting=700000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=36.666667;
        mstruct.nparallels=1;
        mstruct.origin=[36.666667 -90.166667 0];
        mstruct.scalefactor=  0.999941;        
        
    case {'indiana east','1301'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='indiana east';
        mstruct.falsenorthing=250000*ur;
        mstruct.falseeasting=100000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=37.500000;
        mstruct.nparallels=1;
        mstruct.origin=[37.500000 -85.666667 0];
        mstruct.scalefactor=  0.999967;           
        
    case {'indiana west','1302'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='indiana west';
        mstruct.falsenorthing=250000*ur;
        mstruct.falseeasting=900000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=37.5;
        mstruct.nparallels=1;
        mstruct.origin=[37.5 -87.083333 0];
        mstruct.scalefactor= 0.999967;  
        
    case {'iowa north','1401'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='iowa north';
        mstruct.falsenorthing=1000000*ur;
        mstruct.falseeasting=1500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[43.266667 42.066667];
        mstruct.nparallels=2;
        mstruct.origin=[41.5  -93.5 0];
        mstruct.scalefactor=1;        
        
    case {'iowa south','1402'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='iowa south';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[ 41.783333 40.616667];
        mstruct.nparallels=2;
        mstruct.origin=[40.0  -93.5 0];
        mstruct.scalefactor=1;   
        
    case {'kansas north','1501'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='kansas north';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=400000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[39.783333 38.716667];
        mstruct.nparallels=2;
        mstruct.origin=[38.333333  -98.0 0];
        mstruct.scalefactor=1; 
        
    case {'kansas south','1502'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='kansas south';
        mstruct.falsenorthing=400000*ur;
        mstruct.falseeasting=400000*ur;
        mstruct.geoid=[6378137.*ur 0.081819191042815];
        mstruct.mapparallels=[38.566667 37.266667];
        mstruct.nparallels=2;
        mstruct.origin=[36.666667 -98.5 0];
        mstruct.scalefactor=1;          
        
    case {'kentucky','1600'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='kentucky';
        mstruct.falsenorthing=1000000*ur;
        mstruct.falseeasting=1500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[38.666667 37.083333];
        mstruct.nparallels=2;
        mstruct.origin=[36.333333 -85.750000 0];
        mstruct.scalefactor=1;       
        
    case {'kentucky north','1601'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='kentucky north';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[38.966667 37.966667];
        mstruct.nparallels=2;
        mstruct.origin=[37.5 -84.25 0];
        mstruct.scalefactor=1;          
        
    case {'kentucky south','1602'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='kentucky south';
        mstruct.falsenorthing=500000*ur;
        mstruct.falseeasting=500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[37.933333 36.733333];
        mstruct.nparallels=2;
        mstruct.origin=[36.333333 -85.75 0];
        mstruct.scalefactor=1;            
        
    case {'louisiana north','1701'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='louisiana north';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=1000000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[32.666667 31.166667];
        mstruct.nparallels=2;
        mstruct.origin=[30.5 -92.5 0];
        mstruct.scalefactor=1;              
        
    case {'louisiana south','1702'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='louisiana south';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=1000000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[30.7 29.3];
        mstruct.nparallels=2;
        mstruct.origin=[28.5 -91.333333 0];
        mstruct.scalefactor=1;             
        
    case {'maine east','1801'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='maine east';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=300000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=43.666667;
        mstruct.nparallels=1;
        mstruct.origin=[43.666667 -68.5 0];
        mstruct.scalefactor=  0.999900;            
        
    case {'maine west','1802'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='maine west';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=900000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=42.833333;
        mstruct.nparallels=1;
        mstruct.origin=[42.833333 -70.166667 0];
        mstruct.scalefactor=  0.999967;   
        
    case {'maryland','1900'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='maryland';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=400000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[39.45 38.3];
        mstruct.nparallels=2;
        mstruct.origin=[37.666667 -77 0];
        mstruct.scalefactor=1;      
        
    case {'massachusetts island','2002'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='massachusetts island';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[41.48333333 41.28333333];
        mstruct.nparallels=2;
        mstruct.origin=[41 -70.5 0];
        mstruct.scalefactor=1;         
        
    case {'massachusetts mainland','2001'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='massachusetts mainland';
        mstruct.falsenorthing=750000*ur;
        mstruct.falseeasting=200000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[42.683333 41.716667];
        mstruct.nparallels=2;
        mstruct.origin=[41 -71.5 0];
        mstruct.scalefactor=1;           
        
    case {'michigan central','2112'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='michigan central';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=6000000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[45.7 44.183333];
        mstruct.nparallels=2;
        mstruct.origin=[43.316667 -84.366667 0];
        mstruct.scalefactor=1;          
        
    case {'michigan north','2111'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='michigan north';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=8000000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[47.083333 45.483333];
        mstruct.nparallels=2;
        mstruct.origin=[44.783333 -87 0];
        mstruct.scalefactor=1;           
        
    case {'michigan south','2113'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='michigan south';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=4000000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[43.666667 42.100000];
        mstruct.nparallels=2;
        mstruct.origin=[41.5 -84.366667 0];
        mstruct.scalefactor=1;      
        
    case {'minnesota central','2202'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='minnesota central';
        mstruct.falsenorthing=100000*ur;
        mstruct.falseeasting=800000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[47.05 45.616667];
        mstruct.nparallels=2;
        mstruct.origin=[45 -94.25 0];
        mstruct.scalefactor=1;        
        
    case {'minnesota north','2201'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='minnesota north';
        mstruct.falsenorthing=100000*ur;
        mstruct.falseeasting=800000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[48.633333 47.033333];
        mstruct.nparallels=2;
        mstruct.origin=[46.5 -93.1 0];
        mstruct.scalefactor=1;        
        
    case {'minnesota south','2203'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='minnesota south';
        mstruct.falsenorthing=100000*ur;
        mstruct.falseeasting=800000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[45.216667 43.783333];
        mstruct.nparallels=2;
        mstruct.origin=[43 -94 0];
        mstruct.scalefactor=1;          
        
    case {'mississippi east','2301'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='mississippi east';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=300000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=29.5;
        mstruct.nparallels=1;
        mstruct.origin=[29.5 -88.833333 0];
        mstruct.scalefactor=  0.999950;        
        
    case {'mississippi west','2302'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='mississippi west';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=700000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=29.5;
        mstruct.nparallels=1;
        mstruct.origin=[29.5 -90.333333 0];
        mstruct.scalefactor=  0.999950;        
        
    case {'missouri central','2402'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='missouri central';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=35.833333;
        mstruct.nparallels=1;
        mstruct.origin=[35.833333 -92.5 0];
        mstruct.scalefactor=0.999933;      
        
    case {'missouri east','2401'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='missouri east';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=250000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=35.833333;
        mstruct.nparallels=1;
        mstruct.origin=[35.833333 -90.5 0];
        mstruct.scalefactor=0.999933;     
        
    case {'missouri west','2403'}
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='missouri west';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=850000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=36.166667;
        mstruct.nparallels=1;
        mstruct.origin=[36.166667 -94.5 0];
        mstruct.scalefactor=0.999941;         
        
    case {'montana','2500'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='montana';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=600000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[49 45];
        mstruct.nparallels=2;
        mstruct.origin=[44.25 -109.5 0];
        mstruct.scalefactor=1;   
        
    case {'nebraska','2600'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='nebraska';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[43 40];
        mstruct.nparallels=2;
        mstruct.origin=[39.833333 -100 0];
        mstruct.scalefactor=1;   
        
    case {'nevada central','2702'};
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='nevada central';
        mstruct.falsenorthing=6000000*ur;
        mstruct.falseeasting=500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=34.75;
        mstruct.nparallels=1;
        mstruct.origin=[34.75  -116.666667 0];
        mstruct.scalefactor=0.999900;    
        
    case {'nevada east','2701'};
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='nevada east';
        mstruct.falsenorthing=8000000*ur;
        mstruct.falseeasting=200000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=34.75;
        mstruct.nparallels=1;
        mstruct.origin=[34.75 -115.583333 0];
        mstruct.scalefactor=0.999900;       
        
    case {'nevada west','2703'};
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='nevada west';
        mstruct.falsenorthing=4000000*ur;
        mstruct.falseeasting=800000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=34.75;
        mstruct.nparallels=1;
        mstruct.origin=[34.75 -118.583333 0];
        mstruct.scalefactor=0.999900;            
        
    case {'new hampshire','2800'};
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='new hampshire';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=300000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=42.5;
        mstruct.nparallels=1;
        mstruct.origin=[42.5 -71.666667 0];
        mstruct.scalefactor=0.999967;       
        
    case {'new jersey','2900'};
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='new jersey';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=150000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=38.833333;
        mstruct.nparallels=1;
        mstruct.origin=[38.833333 -74.5 0];
        mstruct.scalefactor=0.999900;          
        
    case {'new mexico central','3002'};
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='new mexico central';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=31;
        mstruct.nparallels=1;
        mstruct.origin=[31 -106.25 0];
        mstruct.scalefactor= 0.999900;     
        
    case {'new mexico east','3001'};
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='new mexico east';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=165000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=31;
        mstruct.nparallels=1;
        mstruct.origin=[31 -104.333333 0];
        mstruct.scalefactor= 0.999909;          
        
    case {'new mexico west','3003'};
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='new mexico west';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=830000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=31;
        mstruct.nparallels=1;
        mstruct.origin=[31 -107.833333 0];
        mstruct.scalefactor= 0.999917;     
        
    case {'new york central','3102'};
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='new york central';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=250000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=40;
        mstruct.nparallels=1;
        mstruct.origin=[40  -76.583333 0];
        mstruct.scalefactor= 0.999938;       
        
    case {'new york east','3101'};
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='new york east';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=150000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=38.833333;
        mstruct.nparallels=1;
        mstruct.origin=[38.833333 -74.5 0];
        mstruct.scalefactor= 0.999900;     
        
    case {'new york long island','3104'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='new york long island';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=300000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[41.033333 40.666667];
        mstruct.nparallels=2;
        mstruct.origin=[40.166667 -74 0];
        mstruct.scalefactor=1;           
        
    case {'new york west','3103'};
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='new york west';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=350000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=40;
        mstruct.nparallels=1;
        mstruct.origin=[40 -78.583333 0];
        mstruct.scalefactor= 0.999938;  
        
    case {'north carolina','3200'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='north carolina';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=609601.22*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[36.166667 34.333333];
        mstruct.nparallels=2;
        mstruct.origin=[33.75 -79 0];
        mstruct.scalefactor=1;     
        
    case {'north dakota north','3301'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='north dakota north';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=600000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[48.733333 47.433333];
        mstruct.nparallels=2;
        mstruct.origin=[47 -100.5 0];
        mstruct.scalefactor=1;           
        
    case {'north dakota south','3302'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='north dakota south';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=600000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[47.483333 46.183333];
        mstruct.nparallels=2;
        mstruct.origin=[45.666667 -100.5 0];
        mstruct.scalefactor=1;       
        
    case {'ohio north','3401'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='ohio north';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=600000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[41.7 40.433333];
        mstruct.nparallels=2;
        mstruct.origin=[39.666667 -82.5 0];
        mstruct.scalefactor=1;  
        
    case {'ohio south','3402'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='ohio south';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=600000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[40.033333 38.733333];
        mstruct.nparallels=2;
        mstruct.origin=[38 -82.5 0];
        mstruct.scalefactor=1;     
        
    case {'oklahoma north','3501'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='oklahoma north';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=600000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[36.766667 35.566667];
        mstruct.nparallels=2;
        mstruct.origin=[35 -98 0];
        mstruct.scalefactor=1;       
        
    case {'oklahoma south','3502'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='oklahoma south';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=600000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[35.233333 33.933333];
        mstruct.nparallels=2;
        mstruct.origin=[33.333333 -98 0];
        mstruct.scalefactor=1;           
        
    case {'oregon north','3601'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='oregon north';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=2500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[46.000000 44.333333];
        mstruct.nparallels=2;
        mstruct.origin=[43.666667 -120.5 0];
        mstruct.scalefactor=1; 
        
    case {'oregon south','3602'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='oregon south';
        mstruct.falsenorthing=0;
        mstruct.falseeasting= 1500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[44 42.333333];
        mstruct.nparallels=2;
        mstruct.origin=[41.666667 -120.5 0];
        mstruct.scalefactor=1;          
        
    case {'pennsylvania north','3701'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='pennsylvania north';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=  600000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[41.950000 40.883333];
        mstruct.nparallels=2;
        mstruct.origin=[40.166667 -77.75 0];
        mstruct.scalefactor=1;  
        
    case {'pennsylvania south','3702'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='pennsylvania south';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=  600000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[40.966667 39.933333];
        mstruct.nparallels=2;
        mstruct.origin=[39.333333 -77.75 0];
        mstruct.scalefactor=1;        
        
    case {'puerto rico virgin islands','5200'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='puerto rico virgin islands';
        mstruct.falsenorthing=200000*ur;
        mstruct.falseeasting=200000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[18.433333 18.033333];
        mstruct.nparallels=2;
        mstruct.origin=[17.833333 -66.433333 0];
        mstruct.scalefactor=1;          
        
    case {'rhode island','3800'};
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='rhode island';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=100000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=41.083333;
        mstruct.nparallels=1;
        mstruct.origin=[41.083333 -71.5 0];
        mstruct.scalefactor= 0.999994;   
        
    case {'south carolina','3900'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='south carolina';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=609600*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[34.833333 32.500000];
        mstruct.nparallels=2;
        mstruct.origin=[31.833333 -81 0];
        mstruct.scalefactor=1;          
        
    case {'south dakota north','4001'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='south dakota north';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=600000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[ 45.683333 44.416667];
        mstruct.nparallels=2;
        mstruct.origin=[43.833333 -100 0];
        mstruct.scalefactor=1;              
        
    case {'south dakota south','4002'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='south dakota south';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=600000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[44.4 42.833333];
        mstruct.nparallels=2;
        mstruct.origin=[42.333333 -100.333333 0];
        mstruct.scalefactor=1;          
        
    case {'tennessee','4100'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='tennessee';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=600000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[36.416667 35.250000];
        mstruct.nparallels=2;
        mstruct.origin=[34.333333 -86 0];
        mstruct.scalefactor=1;         
        
    case {'texas central','4203'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='texas central';
        mstruct.falsenorthing=3000000*ur;
        mstruct.falseeasting=700000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[31.883333 30.116667];
        mstruct.nparallels=2;
        mstruct.origin=[29.666667 -100.333333 0];
        mstruct.scalefactor=1;     
        
    case {'texas north central','4202'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='texas north central';
        mstruct.falsenorthing=2000000*ur;
        mstruct.falseeasting=600000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[33.966667 32.133333];
        mstruct.nparallels=2;
        mstruct.origin=[31.666667 -98.5 0];
        mstruct.scalefactor=1;       
        
    case {'texas north','4201'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='texas north';
        mstruct.falsenorthing=1000000*ur;
        mstruct.falseeasting=200000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[36.183333 34.650000];
        mstruct.nparallels=2;
        mstruct.origin=[34 -101.5 0];
        mstruct.scalefactor=1;         
        
    case {'texas south central','4204'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='texas south central';
        mstruct.falsenorthing=4000000*ur;
        mstruct.falseeasting=600000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[30.283333 28.383333];
        mstruct.nparallels=2;
        mstruct.origin=[27.833333 -99 0];
        mstruct.scalefactor=1;      
        
        case {'texas south','4205'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='texas south';
        mstruct.falsenorthing=5000000*ur;
        mstruct.falseeasting=300000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[27.833333 26.166667];
        mstruct.nparallels=2;
        mstruct.origin=[25.666667 -98.5 0];
        mstruct.scalefactor=1;  
        
    case {'utah central','4302'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='utah central';
        mstruct.falsenorthing=2000000*ur;
        mstruct.falseeasting=500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[40.650000 39.016667];
        mstruct.nparallels=2;
        mstruct.origin=[38.333333 -111.5 0];
        mstruct.scalefactor=1;  
        
    case {'utah north','4301'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='utah north';
        mstruct.falsenorthing=1000000*ur;
        mstruct.falseeasting=500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[41.783333 40.716667];
        mstruct.nparallels=2;
        mstruct.origin=[40.333333 -111.5 0];
        mstruct.scalefactor=1;  
        
    case {'utah south','4303'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='utah south';
        mstruct.falsenorthing=3000000*ur;
        mstruct.falseeasting=500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[38.350000 37.216667];
        mstruct.nparallels=2;
        mstruct.origin=[36.666667 -111.5 0];
        mstruct.scalefactor=1;        
        
    case {'vermont','4400'};
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='vermont';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=42.5;
        mstruct.nparallels=1;
        mstruct.origin=[42.5 -72.5 0];
        mstruct.scalefactor= 0.999964;  
        
    case {'virginia north','4501'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='virginia north';
        mstruct.falsenorthing=2000000*ur;
        mstruct.falseeasting=3500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[39.200000 38.033333];
        mstruct.nparallels=2;
        mstruct.origin=[37.666667 -78.5 0];
        mstruct.scalefactor=1;       
        
    case {'virginia south','4502'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='virginia south';
        mstruct.falsenorthing=1000000*ur;
        mstruct.falseeasting=3500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[37.966667 36.766667];
        mstruct.nparallels=2;
        mstruct.origin=[36.333333 -78.5 0];
        mstruct.scalefactor=1;          
        
    case {'washington north','4601'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='washington north';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[48.733333 47.500000];
        mstruct.nparallels=2;
        mstruct.origin=[47.000000 -120.833333 0];
        mstruct.scalefactor=1;   
        
    case {'washington south','4602'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='washington south';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=500000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[47.333333 45.833333];
        mstruct.nparallels=2;
        mstruct.origin=[45.333333 -120.5 0];
        mstruct.scalefactor=1;  
        
    case {'west virginia north','4701'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='west virginia north';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=600000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[40.25 39.0];
        mstruct.nparallels=2;
        mstruct.origin=[38.5 -79.5 0];
        mstruct.scalefactor=1;         
        
    case {'west virginia south','4702'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='west virginia south';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=600000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[38.883333 37.483333];
        mstruct.nparallels=2;
        mstruct.origin=[37.0 -81.0 0];
        mstruct.scalefactor=1; 
        
    case {'wisconsin central','4802'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='wisconsin central';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=600000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[45.500 44.25];
        mstruct.nparallels=2;
        mstruct.origin=[43.833333 -90.0 0];
        mstruct.scalefactor=1;  
        
    case {'wisconsin north','4801'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='wisconsin north';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=600000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[46.766667 45.566667];
        mstruct.nparallels=2;
        mstruct.origin=[45.166667 -90.0 0];
        mstruct.scalefactor=1;         
        
    case {'wisconsin south','4803'};
        mstruct=gcm(axesm('lambertstd'));
        mstruct.zone='wisconsin south';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=600000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=[44.066667 42.733333];
        mstruct.nparallels=2;
        mstruct.origin=[42.0 -90.0 0];
        mstruct.scalefactor=1;        
        
    case {'wyoming east central','4902'};
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='wyoming east central';
        mstruct.falsenorthing=100000*ur;
        mstruct.falseeasting=400000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=40.50;
        mstruct.nparallels=1;
        mstruct.origin=[40.50 -107.333333 0];
        mstruct.scalefactor= 0.999938;  
        
    case {'wyoming east','4901'};
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='wyoming east';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=200000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=40.50;
        mstruct.nparallels=1;
        mstruct.origin=[40.50 -105.166667 0];
        mstruct.scalefactor=0.999938;       
        
    case {'wyoming west central','4903'};
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='wyoming west central';
        mstruct.falsenorthing=0;
        mstruct.falseeasting=600000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=40.50;
        mstruct.nparallels=1;
        mstruct.origin=[40.50 -108.75 0];
        mstruct.scalefactor=0.999938;    
        
    case {'wyoming west','4904'};
        mstruct=gcm(axesm('tranmerc'));
        mstruct.zone='wyoming west';
        mstruct.falsenorthing=100000*ur;
        mstruct.falseeasting=800000*ur;
        mstruct.geoid=[6378137*ur 0.081819191042815];
        mstruct.mapparallels=40.50;
        mstruct.nparallels=1;
        mstruct.origin=[40.50 -110.083333 0];
        mstruct.scalefactor=0.999938;            
        
    otherwise
        close(fig)
        error('Can''t find specified state plane zone.')

end
close(fig)

if any(strcmpi(type,{'forward';'fwd';'f'}))
   
    [xout,yout]=projfwd(mstruct,y,x);
else
    [yout,xout]=projinv(mstruct,x,y);
end

if nargout>1
    varargout{1}=mstruct;
end

%%------------------------------------------------------------------------
function zone = zone_ui
%ZONE_UI - UI to interactively choose state plane zone

zones={'alabama east';...
    'alabama west';...
    'arizona central';...
    'arizona east';...
    'arizona west';...
    'arkansas north';...
    'arkansas south';...
    'california 1';...
    'california 2';...
    'california 3';...
    'california 4';...
    'california 5';...
    'california 6';...
    'colorado central';...
    'colorado north';...
    'colorado south';...
    'connecticut';...
    'delaware';...
    'florida east';...
    'florida north';...
    'florida west';...
    'georgia east';...
    'georgia west';...
    'hawaii 1';...
    'hawaii 2';...
    'hawaii 3';...
    'hawaii 4';...
    'hawaii 5';...
    'idaho central';...
    'idaho east';...
    'idaho west';...
    'illinois east';...
    'illinois west';...
    'indiana east';...
    'indiana west';...
    'iowa north';...
    'iowa south';...
    'kansas north';...
    'kansas south';...
    'kentucky';...
    'kentucky north';...
    'kentucky south';...
    'louisiana north';...
    'louisiana south';...
    'maine east';...
    'maine west';...
    'maryland';...
    'massachusetts island';...
    'massachusetts mainland';...
    'michigan central';...
    'michigan north';...
    'michigan south';...
    'minnesota central';...
    'minnesota north';...
    'minnesota south';...
    'mississippi east';...
    'mississippi west';...
    'missouri central';...
    'missouri east';...
    'missouri west';...
    'montana';...
    'nebraska';...
    'nevada central';...
    'nevada east';...
    'nevada west';...
    'new hampshire';...
    'new jersey';...
    'new mexico central';...
    'new mexico east';...
    'new mexico west';...
    'new york central';...
    'new york east';...
    'new york long island';...
    'new york west';...
    'north carolina';...
    'north dakota north';...
    'north dakota south';...
    'ohio north';...
    'ohio south';...
    'oklahoma north';...
    'oklahoma south';...
    'oregon north';...
    'oregon south';...
    'pennsylvania north';...
    'pennsylvania south';...
    'puerto rico virgin islands';...
    'rhode island';...
    'south carolina';...
    'south dakota north';...
    'south dakota south';...
    'tennessee';...
    'texas central';...
    'texas north central';...
    'texas north';...
    'texas south central';...
    'texas south';...
    'utah central';...
    'utah north';...
    'utah south';...
    'vermont';...
    'virginia north';...
    'virginia south';...
    'washington north';...
    'washington south';...
    'west virginia north';...
    'west virginia south';...
    'wisconsin central';...
    'wisconsin north';...
    'wisconsin south';...
    'wyoming east central';...
    'wyoming east';...
    'wyoming west central';...
    'wyoming west'};

sel = listdlg('PromptString','Select a zone:',...
                      'SelectionMode','single',...
                      'ListString',zones);
zone=zones{sel};                  
                  
                  