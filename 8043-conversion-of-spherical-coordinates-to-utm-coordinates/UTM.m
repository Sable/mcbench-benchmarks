function  [x,y,utmzone] = UTM(instruccion)
% -------------------------------------------------------------------------
% [ x,y,utmzone ] = UTM(instruccion)
% With this little routine, you can get the transformation
 % or the conversion of spherical coordinates to UTM 
 % coordinates, using some ellipsoid elevations.
 % I'm using the Alberto Cotticia and Luciano Saruce's
 % equations, these equations appear in  "Bolletino di
 % Geodesia e Science Affini", num. 1.
 % The different ellipsoids that I got them, you can
 % find them on:
 % http://www.aec2000.it/geodesy/geodesy.htm
 % You can check:
 % http://recursos.gabrielortiz.com/
 %
 % Inputs:
 % Latitude, Longitude and the reference of the Longitude.
 %
 % Outputs:
 % x, y , utm zone.
 %
 % Author: Gabriel Ruiz Martinez, M.C. Civil Engineer.
 %  Last Modification: May/05
 %-------------------------------------------------------------------------


   if nargin == 0
                 instruccion = 'iniciar';
   end

   % &&&&& Defining variables which will store the handles as variable global &&&&&
   global longitudG longitudM longitudS lonRef latitudG latitudM latitudS latRef ListaElips          

    % &&&&&Start the graphical interfase of user &&&&&
    if strcmp(instruccion,'iniciar')
    
                    marcocal = figure('name','Conversion of Spherical Coordinates to UTM Coordinates', 'color' , [0.92549 0.913725 0.847059] , ...
                                                   'menubar' , 'none' , 'units' , 'normalized' , 'position' , [0.24 0.40 0.54 0.24 ] , 'numbertitle' , 'off', 'resize' , 'off');

	                % &&&&& Create the frames &&&&&.
	                      uicontrol(marcocal , 'Style' , 'frame' , 'Units' ,'normalized', 'Position', [ 0.01 0.25 0.98 0.7 ] ); 
	                          uicontrol(marcocal , 'Style' , 'frame' , 'Units' , 'normalized' , 'Position' , [0.01 0.01 0.98 0.2 ]  );
    
                                 % &&&&& Create all the text &&&&&
                                         uicontrol(marcocal, 'Style' , 'Text' , 'String' , 'Spherical Coordinates' , 'Units' , ' Normalized' , 'Position' , [ 0.08 0.92 0.25 0.07] , ...
                                                                       'FontWeight' , 'Bold' , 'ForegroundColor' ,  [0.5 0 0] );
                                             uicontrol(marcocal, 'Style' , 'Text' , 'String' , 'Longitude:' , 'Units' , ' Normalized' , 'Position' , [ 0.08 0.83 0.11 0.07] , ...
                                                                           'FontWeight' , 'Bold', 'ForegroundColor' ,  [0 0 0.48] );
	                                                uicontrol(marcocal, 'Style' ,  'text' ,  'String' , 'Degrees:' , 'Units' , 'normalized' , 'Position' , [ 0.08 0.70 0.09 0.07 ] ); 
	                                         uicontrol(marcocal, 'Style' ,  'text' ,  'String' , 'Minutes:' , 'Units' , 'normalized' , 'Position' , [ 0.08 0.57 0.09 0.07 ] );
                                          uicontrol(marcocal, 'Style' , 'text' ,  'String' , 'Seconds:' , 'Units' , 'normalized' , 'Position' , [ 0.08 0.44 0.09 0.07] );
                                  uicontrol(marcocal, 'Style' , 'Text' , 'String' , 'Direction:' , 'Units' , 'normalized' , 'Position' , [ 0.08 0.31 0.09 0.07] );
                             uicontrol(marcocal, 'Style' , 'Text' , 'String' , 'Latitude:' , 'Units' , ' Normalized' , 'Position' , [ 0.35 0.83 0.1 0.07] , ...
                                                           'FontWeight' , 'Bold' , 'ForegroundColor' ,  [0 0 0.48] );
	                     uicontrol(marcocal, 'Style' ,  'text' ,  'String' , 'Degrees:' , 'Units' , 'normalized' , 'Position' , [ 0.35 0.70 0.09 0.07 ] ); 
	                 uicontrol(marcocal, 'Style' ,  'text' ,  'String' , 'Minutes:' , 'Units' , 'normalized' , 'Position' , [ 0.35 0.57 0.09 0.07 ] );
                        uicontrol(marcocal, 'Style' , 'text' ,  'String' , 'Seconds:' , 'Units' , 'normalized' , 'Position' , [ 0.35 0.44 0.09 0.07] );
                             uicontrol(marcocal, 'Style' , 'Text' , 'String' , 'Direction:' , 'Units' , 'normalized' , 'Position' , [ 0.35 0.31 0.09 0.07] );
                                   uicontrol(marcocal, 'Style' , 'Text' , 'String' ,  'Ellipsoid:' , 'Units' , 'normalized' , 'Position' , [ 0.62 0.8 0.09 0.07] );
                                             uicontrol(marcocal, 'Style' , 'Text' , 'String' , 'Universal Transverse Mercator Coordinates' ,  ...
                                                                             'Units' , ' Normalized' , 'Position' , [ 0.08 0.18 0.5 0.06] , 'FontWeight' , 'Bold' , ...
                                                                             'ForegroundColor' ,  [0.5 0 0] );
	   
    % Create the edit boxes for the coordinates data.
	                                        longitudG = uicontrol(marcocal, 'Style' , 'edit' ,  'String','86', 'Units' , 'normalized', 'Position' , ...
                                                                              [ 0.20 0.69 0.1 0.1 ] , 'CallBack' , 'UTM(''calcular'');'); 
	                                           longitudM = uicontrol(marcocal , 'Style' , 'edit', 'String' , '57' , 'Units' , 'normalized', 'Position' , ...
                                                                              [ 0.20 0.56 0.1 0.1 ] , 'CallBack' , 'UTM(''calcular'');' ); 
                                                    longitudS = uicontrol(marcocal , 'Style' , 'edit', 'String' , '46.1380' , 'Units' , 'normalized', 'Position' , ...
                                                                              [ 0.20 0.43 0.1 0.1 ] , 'CallBack' , 'UTM(''calcular'');' ); 
                                               lonRef = uicontrol(marcocal , 'Style' , 'edit', 'String' , 'W' , 'Units' , 'normalized', 'Position' , ...
                                                                              [ 0.20 0.30 0.05 0.1 ] , 'CallBack' , 'UTM(''calcular'');' );                                 
	                                        latitudG = uicontrol(marcocal, 'Style' , 'edit' ,  'String','20', 'Units' , 'normalized', 'Position' , ...
                                                                              [ 0.47 0.69 0.1 0.1 ] , 'CallBack' , 'UTM(''calcular'');'); 
	                                           latitudM = uicontrol(marcocal , 'Style' , 'edit', 'String' , '43' , 'Units' , 'normalized', 'Position' , ...
                                                                              [ 0.47 0.56 0.1 0.1 ] , 'CallBack' , 'UTM(''calcular'');' ); 
                                                    latitudS = uicontrol(marcocal , 'Style' , 'edit', 'String' , '56.2235' , 'Units' , 'normalized', 'Position' , ...
                                                                              [ 0.47 0.43 0.1 0.1 ] , 'CallBack' , 'UTM(''calcular'');' );
                                                latRef = uicontrol(marcocal , 'Style' , 'edit', 'String' , 'N' , 'Units' , 'normalized', 'Position' , ...
                                                                              [ 0.47 0.30 0.05 0.1 ] );
                                             ListaElips = uicontrol(marcocal , 'Style' , 'listbox' , 'String' , ...
                                                           'Airy 1830|Airy 1849|Airy Modified 1965|Australian National|Average Terrestrial System 1977|Bessel (Namibia 1841)|Bessel (Ethiopia, Indonesia 1841)|Bessel (Japan 1841)|Modified Bessel|Bessel NGO|Bessel RT90|Clarke 1858|Clarke 1858 (AUSLIG)|Clarke 1858-1|Clarke 1866|Clarke Michigan|Clarke 1880|Clarke 1880 ARC50|Clarke 1880 Benoit|Clarke 1880 Benoit|Clarke 1880 IGN|Clarke 1880 Jamaica|Clarke 1880 Merchich|Clarke 1880 Palestine|Clarke 1880 RGS|Clarke 1880 SGA 1922|Everest (India 1830)|Everest (Sabah & Sarawak)|Everest (India 1956)|Everest (W. Malaysia 1969)|Everest (W. Malaysia & Singapure 1948)|Everest (Pakistan)|Everest (Timbalai)|Everest 1967|Fischer 1960|Fischer 1968|Modified Fischer 1966|GEM 10C|GRS67|GRS80|Hayford 1909|Helmert 1906|Hough 1960|IAG 75|Indonesian 1974|International 1909|International 1924|IUGG 67|IUGG 75|Kaula|Krasovsky 1940|Merit 83|Mercury 1960|Modified Mercury 1968|New International 1967|NWL 10D|NWL 9D|OSU86F|OSU91A|Plessis 1817|SGS85|South American 1969|South Asia|Struve (Spain) 1860|Walbeck 1817|War Office|WGS60|WGS66|WGS72|WGS84' , ...
                                                           'Units' , 'normalized', 'Position' ,  [ 0.63 0.30 0.34 0.49 ] , 'BackgroundColor' , [1 1 1]  );
                                                       
	    % Beginning subfunction.
	     UTM('calcular');

     % Callback to the event of computing
    elseif strcmp(instruccion,'calcular')
        testing = 0;
            eval( [ 'longituG = ' get(longitudG, 'string') ';' ]  );
                eval( [ 'longituM = ' get(longitudM, 'string') ';' ]  );
                  eval( [ 'longituS = ' get(longitudS, 'string') ';' ]  );
                  eval( [ 'latituG = ' get(latitudG, 'string') ';' ]  );
                eval( [ 'latituM = ' get(latitudM, 'string') ';' ]  );
              eval( [ 'latituS = ' get(latitudS, 'string') ';' ]  );
        
             longitudRef = get(lonRef, 'string');
                  latitudRef = get(latRef, 'string');
                       ListaElip = get(ListaElips, 'value');
              if testing == 0     
                  switch ListaElip
                              case {1}
                                       sa = 6377563.396000 ; sb = 6356256.909237;    
                              case {2}
                                       sa = 6377340.189000 ; sb = 6356034.447897;
                              case {3}
                                       sa = 6377340.189000 ; sb = 6356034.447939;
                              case {4}
                                       sa = 6378160.000000 ; sb = 6356774.719195;
                              case {5}
                                       sa = 6378135.000000 ; sb = 6356750.304922;
                              case {6}
                                       sa = 6377483.865000 ; sb = 6356165.382967;         
                              case {7}
                                       sa = 6377397.155000 ; sb = 6356078.962819;
                              case {8}
                                       sa =6377397.155000  ; sb = 6356078.963000;   
                              case {9}
                                       sa = 6377492.018000 ; sb = 6356173.508713;
                              case {10}
                                       sa = 6377492.018000 ; sb = 6356173.508516;
                              case {11}
                                       sa = 6377397.154000 ; sb =6356078.962024;
                              case {12}
                                       sa = 6378294.000000 ; sb = 6356621.237513;
                              case {13}
                                       sa = 6378293.645000 ; sb = 6356617.937649;
                              case {14}
                                       sa = 6378293.639000 ; sb = 6356617.981760 ;
                              case {15}
                                       sa = 6378206.400000 ; sb = 6356583.799999;
                              case {16}
                                       sa = 6378450.047000  ; sb = 6356826.621424;         
                              case {17}
                                       sa = 6378249.136000  ; sb = 6356514.860580;
                              case {18}
                                       sa = 6378249.145000  ; sb = 6356514.966716 ;   
                              case {19}
                                       sa = 6378300.790000  ; sb = 6356566.429659;
                              case {20}
                                       sa = 6378300.790000  ; sb = 6356566.434997;          
                              case {21}
                                       sa = 6378249.200000  ; sb = 6356515.000000;
                              case {22}
                                       sa = 6378249.136000  ; sb = 6356514.957600;
                              case {23}
                                       sa = 6378249.200000  ; sb = 6356514.996942;
                              case {24}
                                       sa = 6378300.790000 ; sb =  6356566.429662;
                              case {25}
                                       sa = 6378249.145000  ; sb = 6356514.869550;
                              case {26}
                                       sa = 6378249.200000  ; sb = 6356514.996942 ;         
                              case {27}
                                       sa = 6377276.345000 ; sb =  6356075.413138;
                              case {28}
                                       sa = 6377298.556000 ; sb =  6356097.550301;   
                              case {29}
                                       sa = 6377301.243000 ; sb =  6356100.228366;
                              case {30}
                                       sa = 6377295.664000 ; sb =  6356094.667913; 
                              case {31}
                                       sa = 6377304.063000 ; sb =  6356103.038991;         
                              case {32}
                                       sa = 6377309.613000 ; sb = 6356108.570542;
                              case {33}
                                       sa = 6377298.561000 ; sb = 6356097.555284; 
                              case {34}
                                       sa = 6377298.556000 ; sb = 6356097.550299;
                              case {35}
                                       sa = 6378166.000000 ; sb = 6356784.283607;
                              case {36}
                                       sa = 6378150.000000 ; sb = 6356768.337244;
                              case {37}
                                       sa = 6378155.000000 ; sb = 6356773.320483;
                              case {38}
                                       sa = 6378137.000000 ; sb = 6356752.313990;
                              case {39}
                                       sa = 6378160.000000 ; sb = 6356774.516091;
                              case {40}
                                       sa = 6378137.000000 ; sb = 6356752.314140;
                              case {41}
                                       sa = 6378388.000000 ; sb = 6356911.946128;
                              case {42}
                                       sa = 6378200.000000 ; sb = 6356818.169628;         
                              case {43}
                                       sa = 6378270.000000 ; sb = 6356794.343434;
                              case {44}
                                       sa = 6378140.000000 ; sb = 6356755.304075;   
                              case {45}
                                       sa = 6378160.000000 ; sb = 6356774.508046;
                              case {46}
                                       sa = 6378388.000000 ; sb = 6356911.949128;
                              case {47}
                                       sa = 6378388.000000 ; sb =  6356911.949128;
                              case {48}
                                       sa = 6378160.000000 ; sb = 6356774.719195;
                              case {49}
                                       sa = 6378140.000000 ; sb = 6356755.288158;
                              case {50}
                                       sa = 6378165.000000 ; sb = 6356344.387615;
                              case {51}
                                       sa = 6378245.000000 ; sb = 6356863.018773;
                              case {52}
                                       sa = 6378137.000000 ; sb = 6356752.298216;         
                              case {53}
                                       sa = 6378166.000000 ; sb = 6356748.283666;
                              case {54}
                                       sa = 6378150.000000 ; sb = 6356768.337303;   
                              case {55}
                                       sa = 6378157.500000 ; sb = 6356772.227578;
                              case {56}
                                       sa = 6378135.000000 ; sb = 6356750.520016;          
                              case {57}
                                       sa = 6378145.000000 ; sb = 6356759.769489;
                              case {58}
                                       sa = 6378136.200000 ; sb = 6356751.516672;
                              case {59}
                                       sa = 6378136.300000 ; sb = 6356751.616337;
                              case {60}
                                       sa = 6376523.000000 ; sb = 6355862.933256;
                              case {61}
                                       sa = 6378136.000000 ; sb = 6356774.719201;
                              case {62}
                                       sa = 6378160.000000 ; sb = 6356774.719195;         
                              case {63}
                                       sa = 6378155.000000 ; sb = 6356773.320497;
                              case {64}
                                       sa = 6378298.300000 ; sb = 6356657.142670;   
                              case {65}
                                       sa = 6376896.000000 ; sb = 6355834.846687;
                              case {66}
                                       sa = 6378300.583000 ; sb = 6356752.270220; 
                              case {67}
                                       sa = 6378165.000000 ; sb = 6356783.286969;         
                              case {68}
                                       sa = 6378145.000000 ; sb = 6356759.769489;
                              case {69}
                                       sa = 6378135.000000 ; sb = 6356750.520016;   
                              case {70}
                                       sa = 6378137.000000 ; sb = 6356752.314245;
                          end
                          
                    e = ( ( ( sa ^ 2 ) - ( sb ^ 2 ) ) ^ 0.5 ) / sa;
                        e2 = ( ( ( sa ^ 2 ) - ( sb ^ 2 ) ) ^ 0.5 ) / sb;
                              e2cuadrada = e2 ^ 2;
                                   c = ( sa ^ 2 ) / sb;
                                       alpha = ( sa - sb ) / sa;             %f
                                             ablandamiento = 1 / alpha;   % 1/f

                                             mla = latituM / 60;
                                       sla = ( latituS / 60 ) / 60;
                                  mlo = longituM / 60;
                              slo = ( longituS / 60 ) / 60;
                        la = latituG + mla + sla;
                    lo = longituG + mlo + slo;
                                  
                    lat = la * ( pi / 180 );
                    lon = lo * ( pi / 180 );
                
                    if longitudRef == 'W' || longitudRef == 'w'
                        lo = lo * - 1;
                        lon = lon * - 1;
                     end 
               
                    Huso = fix( ( lo / 6 ) + 31);                       
                        S = ( ( Huso * 6 ) - 183 );
                              deltaS = lon - ( S * ( pi / 180 ) );
               
                                  a = cos(lat) * sin(deltaS);
                                            epsilon = 0.5 * log( ( 1 +  a) / ( 1 - a ) );
                                                 nu = atan( tan(lat) / cos(deltaS) ) - lat;
                                             v = ( c / ( ( 1 + ( e2cuadrada * ( cos(lat) ) ^ 2 ) ) ) ^ 0.5 ) * 0.9996;
                                       ta = ( e2cuadrada / 2 ) * epsilon ^ 2 * ( cos(lat) ) ^ 2;
                                  a1 = sin( 2 * lat );
                             a2 = a1 * ( cos(lat) ) ^ 2;
                        j2 = lat + ( a1 / 2 );
                    j4 = ( ( 3 * j2 ) + a2 ) / 4;
                         j6 = ( ( 5 * j4 ) + ( a2 * ( cos(lat) ) ^ 2) ) / 3;
                             alfa = ( 3 / 4 ) * e2cuadrada;
                                   beta = ( 5 / 3 ) * alfa ^ 2;
                                       gama = ( 35 / 27 ) * alfa ^ 3;
                                            Bm = 0.9996 * c * ( lat - alfa * j2 + beta * j4 - gama * j6 );
                                                 x = epsilon * v * ( 1 + ( ta / 3 ) ) + 500000;
                                            y = nu * v * ( 1 + ta ) + Bm;
                                            
                                   X = num2str(x);
                             Y = num2str(y);
                        HUso = num2str(Huso);
                                            
                   uicontrol(gcf, 'Style' , 'Text' , 'BackGroundColor' , [0.92549 0.913725 0.847059] , ...
                                                                             'String' ,[' X =   ' , X ]  , 'Units' , 'Normalized' , 'Position' , [ 0.08 0.06 0.2 0.07] ,  ...
                                                                             'FontWeight' , 'bold', 'HorizontalAlignment' , 'center' , 'ForegroundColor' , ...
                                                                               [0 0 0.48] );
                        uicontrol(gcf, 'Style' , 'Text' , 'BackGroundColor' , [0.92549 0.913725 0.847059] , ...
                                                                             'String' ,[' Y =   ' , Y ]  , 'Units' , 'Normalized' , 'Position' , [ 0.39 0.06 0.2 0.07] , ... 
                                                                             'FontWeight' , 'bold', 'HorizontalAlignment' , 'center' , 'ForegroundColor' , ...
                                                                               [0 0 0.48] );
                             uicontrol(gcf, 'Style' , 'Text' , 'BackGroundColor' , [0.92549 0.913725 0.847059] , ...
                                                                             'String' ,[' UTM Zone =   ' , HUso ]  , 'Units' , 'Normalized' , 'Position' , [ 0.7 0.06 0.2 0.07] ,  ...
                                                                             'FontWeight' , 'bold', 'HorizontalAlignment' , 'center' , 'ForegroundColor' , ...
                                                                               [0 0 0.48] );
              end
end % END command_str comparison checks.