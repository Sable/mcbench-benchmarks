function idtplot(instruccion)
% _______________________________________________________
%
% With this routine you can get the different   
% intensity - duration - frecuency curves, using the Gumbel's
% method.
% Equations used in this routine:
%   1 - 1 / T = exp( -exp ( - ( i + a ) / c) )
%
% Where: c = ( sqrt(6) / pi ) * s;
%            a = ( 0.577 * c ) - imed;
%            s = standard deviation of data
%            imed = data media
%
% Syntax to use the function:
%            None. You only run it.
%
% Inputs:
%            Precipitations or Intensity of rain
%
% Outputs:
%             Intensity - Duration - Return Period plot
%
%  Requirements or additional information:
%         This routine gets the data since a *.xls file.
%         Please, chek the file comments.m
%
%  Example:
%           >> run idtplot
%
% Development: Gabriel Ruiz Mtz.
% Thanks to Mr. George A.Z.
% 08-ene-06
% This routine is provided "as is" without warranty of any kind. 
% _____________________________________
    
if nargin == 0
       instruccion = 'iniciar';
end

   % Defining variables which will store the handles as variable global %
   global f1i oppreci opintens vpan hpan anspre ansint Namefile
    
   % Start the graphical interfase of user %
    if strcmp(instruccion,'iniciar')
   
          screen = get(0, 'screensize');
          if screen(1,3) > 1024
                screen = screen - 256;  % Please, the screen has the resolution of 1280 * 1024
          end
          vpan = screen(1,4)-35; hpan = screen(1,3);  % Resolution of 1024 * 733

          f1i = figure('Menubar' , 'none' , 'Numbertitle' , 'off' , 'Name' , 'IDF curves' , 'Tag' , 'wp' , ...
                              'Units' , 'pixels' , 'Position' , [(hpan/2)-105   (vpan/2)-50   hpan-814   vpan-633 ] , 'ReSize' , 'off' );
          uicontrol(f1i, 'Style' , 'Text' , 'BackGroundColor', [0.80 0.80 0.80] , 'String' , 'The worksheet has data of:' , ...
                                     'Units' , 'pixels' , 'Position' , [hpan-1003   vpan-660   hpan-856   vpan-713] , 'FontWeight' , 'Bold' );
          oppreci = uicontrol(f1i, 'Style' , 'radiobutton' , 'String' , 'Precipitations' , 'Units' , 'pixels' , 'Tag' , 'precipation' , ...
                        'Position' , [hpan-992 vpan-683   hpan-884   vpan-713] , 'BackGroundColor' , [0.80 0.80 0.80] , 'ForeGroundColor' , ...
                        [0.50 0.25 0.25] , 'FontWeight' , 'Bold' , 'callback' , 'idtplot(''worksheet'')');
          opintens = uicontrol(f1i, 'Style' , 'radiobutton' , 'String' , 'Intensities' , 'Units' , 'pixels' , 'Tag' , 'intensity' , ...
                      'Position' , [hpan-992   vpan-713   hpan-877   vpan-713] , 'BackGroundColor' , [0.80 0.80 0.80] , 'ForeGroundColor' , ...
                        [0.50 0.25 0.25] , 'FontWeight' , 'Bold' , 'callback' , 'idtplot(''worksheet'')' );
                   
    elseif strcmp(instruccion,'worksheet')
          anspre = get(oppreci, 'Value'); 
          ansint = get(opintens, 'Value');
    %clear f1i;
           close(f1i);
           [NombreFile, RutaFile] = uigetfile( { '*.xls ;*.xls'  , 'Excel Worksheet ( * .xls )' } , ...
                                         'Choose the file which has the data' );
        if RutaFile ~= 0
                          NameFile = fullfile(RutaFile , NombreFile);
                          [precip] = xlsread(NameFile);
            
                          if anspre == 1
                                  duracionin = precip(1,:);
                                  dur = length(duracionin);
                                  duracion = precip(1,2:1:dur);
                                  dur = length(duracion);
                                  datos = length(precip)-1;
                                  durinhr= duracion/60;

                                  for i = 1 : datos
                                       for j = 1 : dur
                                            inten(i,j)= precip(i+1,j+1)/durinhr(1,j);
                                       end
                                  end
                                  asc = sort(inten);
                                  inten = flipud(asc);
                          end
            
                          if ansint == 1
                                  duracionin = precip(1,:);
                                  dur = length(duracionin);
                                  duracion = precip(1,2:1:dur);
                                  dur = length(duracion);
                                  datos = length(precip)-1;
                                  inten = precip;
                                  inten(1,:) = [ ];
                                  asc = sort(inten);
                                  inten = flipud(asc);
                          end
                          clear anspre ansint NombreFile RutaFile NameFile opintens oppreci f1i;

% &&&&&&&&&&&&&&&& Gumbel's method &&&&&&&&&&&&&&&&&&&&&
                         for i = 1 : dur
                                   Suminten(1,i) = sum(inten(:,i));
                                   itestada(1,i) = Suminten(1,i)/datos;
                                   desviacion(1,i) = std(inten(:,i));
                                   c(1,i) = (sqrt(6)/pi) * desviacion(1,i);
                                   ah(1,i) = ( 0.577 * c(1,i) ) - itestada(1,i);
                         end
     
                         for i = 1 :dur
                              for j = 1 : dur
                                   tr(i,j) =(((log((log(1-(1/duracion(1,i)))*-1)))*-1)*c(1,j))-ah(1,j);
                                   unod(i,j) = inv(tr(i,j));
                                   id(i,j) = duracion(1,j)/tr(i,j);
                              end
                         end
     
                         duracioncuad = duracion.^2;
                         sumdurcuad = sum(duracioncuad);
                         sumdur= sum(duracion);
     
                         for i = 1 : dur
                                   Sumunod(i,1) = sum(unod(i,:));
                                   Sumid(i,1) = sum(id(i,:));
                         end
     
                         for i = 1 : dur
                              a(i,1) = ((dur * sumdurcuad) - sumdur^2 ) / ( ( dur * Sumid(i,1)) - (sumdur* Sumunod(i,1)));
                              b(i,1) = ((a(i,1)* Sumunod(i,1))-sumdur)/dur;
                         end
     
                         duracioni = 0:1:duracionin(1,dur+1);
                         dure = length(duracioni);
                         for i =1 : dur
                                   for j = 1 : dure
                                        intensity(i,j) = a(i,1)/(duracioni(1,j)+b(i,1));
                                   end
                         end
     
% &&&&&&&&&&&&&&&&& Getting the plot &&&&&&&&&&&&&&&&&&&&&     
                         figure('MenuBar' , 'none' , 'Name', 'IDF Curves', 'NumberTitle', 'off');
                         plot(duracioni,intensity);
                         xlabel('Time (min)');
                         ylabel('Intensity (mm/hr)');
                         textos2 = 'f = ';
                         for i = 1 : dur
                                   stringer{i,1} = num2str(duracion(1,i));
                                   textos{i,1} = horzcat(textos2,stringer{i,1},' years');
                         end

                         drt = title('Intensity - Duration - Frequency Curves', 'HorizontalAlignment' , 'center' , ...
                                        'FontWeight', 'bold');
                         set(gca, 'XGrid', 'on', 'XMinorTick', 'on' , 'YGrid' , 'on' , 'YMinorTick' , 'on', 'Fontsize', 8 );
                         legend(textos);         
        else
                          Respuesta = questdlg('Would you really like to exit? ' , 'Exit?' , 'Yes' , 'No' ,  'Yes');
                          if strcmp(Respuesta, 'Yes')
                             close all
                          end
                          cd('..');
        end      
end
