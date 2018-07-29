function Coorddean = Dean(cm)
% ____________________________________________
% 1. Description:
%     This function displays the equilibrium beach profile, using
%     the Dean's equation (Bruun's equation modified).
%
% 2. Inputs:
%     Hs12 = The effective significant wave height (m).
%     Ts = The wave period associated with Hs12 (s).
%      D50 = Sediment size (m).
%
% 3. Output:
%      The closure depth (m)
%      The equilibrium beach profile coordinates.
%
%.4. Notes:
%     You can only run the function.
%
% 5. Referents:
%     - Dean, Robert G. (2002). Beach nourishment: theory and practice.
%                 Advanced Series on Ocean Engineering, Volume 18.
%                 World Scientific Publishing. Singapure.
%     - Universidad de Cantabria-GIOC. (2002). Manual del usuario TIC.
%                 España. 
%
% 6. Programming: Gabriel Ruiz Martinez.
%
% 7.  The author of this GUI does not do responsible for any
%  to thirds that implicate losses materials by the direct or
%  indirect use of this GUI. This is a beta version and the results
%  are distributed under the responsability, exclusive and unique
%  of the user. This routine is used in DEFOPS and MDYN.
%  May-2005.
% ____________________________________________

if nargin == 0
     
    cm = 'inicializa';
    close(gcf);
    wind_profile = figure('NumberTitle' , 'Off', 'Color' , [0.8 0.8 0.8] , 'Name' , 'Equilibrium Beach Profile' , ...
                                               'MenuBar' , 'None' , 'Resize' , 'on'  );
 end

global E_Hs12 E_Ts E_D

if strcmp(cm, 'inicializa')
     
     frame_inputs = uicontrol(gcf , 'Style' , 'Frame' , 'Units' , 'Normalized' , 'Position' , ...
                                                    [0.27 0.54 0.50 0.40] );

     Titulo =  uicontrol(gcf, 'Style' , 'Text' ,  'String' , 'Equilibrium Beach Profile' , ... 
                                                             'FontWeight' , 'Bold' , 'ForeGroundColor' , [0.25 0.25 0.49] , 'Units' , 'Normalized' , ...
                                                             'BackGroundColor' , [0.8 0.8 0.8] , 'Position' , [0.37 0.42 0.3 0.05] );  
                                                        
     axe_plots = axes('Units' , 'Normalized', 'Position' , [ 0.1 0.07 0.85 0.35] , ...
                                                   'Xgrid' , 'on' , 'Ygrid' , 'on' , 'Xcolor' , [0.25 0.25 0.49] , 'Ycolor' , [0.25 0.25 0.49] , ...
                                                   'Box' , 'on' , 'FontWeight' , 'Bold' , 'FontSize' , 7 , 'FontAngle' , 'Oblique' , ...
                                                   'XMinorTick' , 'on' , 'YMinorTick' , 'on' );
    
     inputlet = uicontrol(gcf, 'Style' , 'Text' , 'String' , 'Input data:' ,  ...
                           'FontWeight' , 'Normal' , 'Units' , 'Normalized' , 'Position' , [0.30 0.88 0.12 0.05] ); 
                       
         LetreHS12= uicontrol(gcf, 'Style' , 'Text' , 'String' , 'Hs12 (in m):' ,  ...
                                   'FontWeight' , 'Normal' , 'Units' , 'Normalized' , 'Position' , [0.30 0.84 0.12 0.05] , ...
                                   'ForeGroundColor' , [0 0 1] );
                               
              E_Hs12 = uicontrol(gcf, 'Style' , 'Edit' , 'String' , '3.00' ,  'FontWeight' , 'Normal' , ...
                                 'Units' , 'Normalized' , 'Position' , [0.30 0.79 0.12 0.05] , 'BackGroundColor' , [1 1 1] , ...
                                 'ForeGroundColor' , [0 0 0.4] , 'Callback' , 'Dean(''Grafica'')' );
                             
                LetreTs = uicontrol(gcf, 'Style' , 'Text' , 'String' , 'Ts (in s):' , 'FontSize' , 9 , 'FontWeight' , ...
                                          'Normal' , 'Units' , 'Normalized' , 'Position' , [0.30 0.74 0.12 0.05] , 'ForeGroundColor' , ...
                                          [0 0 1] );
                                      
                   E_Ts = uicontrol(gcf, 'Style' , 'Edit' , 'String' , '08.00' ,  'FontWeight' , 'Normal' , ...
                                 'Units' , 'Normalized' , 'Position' , [0.30 0.69 0.12 0.05] , 'BackGroundColor' , [1 1 1] , ...
                                 'ForeGroundColor' , [0 0 0.4] , 'Callback' , 'Dean(''Grafica'')' );
                             
                     LetreD = uicontrol(gcf, 'Style' , 'Text' , 'String' , 'D50 (in m):' ,  'FontWeight' , ...
                                          'Normal' , 'Units' , 'Normalized' , 'Position' , [0.30 0.64 0.12 0.05] , ...
                                          'ForeGroundColor' , [0 0 1] );
                                      
                         E_D = uicontrol(gcf, 'Style' , 'Edit' , 'String' , '0.0005' ,  'FontWeight' , 'Normal' , ...
                                 'Units' , 'Normalized' , 'Position' , [0.30 0.59 0.12 0.05] , 'BackGroundColor' , [1 1 1] , ...
                                 'ForeGroundColor' , [0 0 0.4] , 'Callback' , 'Dean(''Grafica'')' );
                             
           
                   Dean('Grafica');    
                      
         elseif strcmp(cm , 'Grafica')
                   eval ( [ 'Hs12 ='  get(E_Hs12, 'String') ';' ] );
                       eval ( [ 'Ts = '  get(E_Ts, 'String') ';' ] );
                            eval ( [ 'D = ' get(E_D, 'String') ';' ] );
                                     
                  if D < 0.0001                                                 
                             vfall = ( 1.1 * 10 ^ 6 ) * D ^ 2;
                       elseif ( 0.0001 < D ) && ( D < 0.001 )
                             vfall = ( 273 * D ^ 1.1 );
                       else
                             vfall = ( 4.36 * D ^ 0.51 );
                  end
    
                  A = 0.51 * vfall ^ 0.44;                                                                 
                    hc = ( 1.75 * Hs12) - ( 57.9 * ( Hs12 ^ 2 / ( 9.81 * Ts ^ 2 ) ) );         
                        xc = ( hc / A ) ^ (3/2);                                                           
                           Depthclo = num2str(-hc);
                                 Xclo = num2str(xc);
            
                                 NP = 10;                                              
                           DeltaX = xc / NP;                                 
     
                  for Contador = 1: NP+1                                            
                       n(Contador) = Contador - 1;                                 
                          x(Contador) = (DeltaX * n(Contador) );                 
                       y(Contador) = ( A * x(Contador) ^ (2/3) ) * -1;       
                  end

                        DeltaY1 = hc / NP;
                  for Contador1 = 1 :NP+1
                        m1(Contador1) = Contador1 - 1;
                            LhHc(Contador1) = ( DeltaY1 * hc ) / DeltaY1;
                               LhXc(Contador1) = m1(Contador1) * DeltaX;
                            LvXc(Contador1) = ( DeltaX * xc ) / DeltaX;
                        LvHc(Contador1) = m1(Contador1) * DeltaY1;
                  end

                   plot_Dean = plot(x , y , 'LineWidth' , 2, 'Color' , 'red' );
                       axis normal;
                            set(gca, 'Xgrid' , 'off' , 'Ygrid' , 'off', 'Box' , 'on' , 'Color' , [0.8 0.8 0.8] , 'XColor' , ...
                                      [0.25 0.25 0.49] , 'YColor' , [0.25 0.25 0.49] , 'XMinorTick' , 'on' , ...
                                      'YMinorTick' , 'on');
                            hold on
                        plot_Dean1 = plot(LhXc , -LhHc , 'LineWidth' , 1 , 'Color' , [0 0. 1] , 'LineStyle' , '-.' );
                   plot_Dean2 = plot(LvXc , -LvHc , 'LineWidth' , 1 , 'Color' , [0 0 1] , 'LineStyle' , '-.' );
                      hold off
                         outputlet = uicontrol(gcf, 'Style' , 'Text' , 'String' , 'Output data:' ,  ...
                                                     'FontWeight' , 'Normal' , 'Units' , 'Normalized' , 'Position' , [0.47 0.88 0.15 0.05] );  
                             outputlet1 = uicontrol(gcf, 'Style' , 'Text' , 'ForeGroundColor' , [0 0.33 0.16] , 'String' , 'The closure depth' , ...
                                                         'Units' , 'Normalized' , 'Position' , [0.47 0.84 0.25 0.05] ,  'FontWeight' , 'Normal' , ...
                                                         'HorizontalAlignment' , 'left');
                                outputlet2 = uicontrol(gcf, 'Style' , 'Text' , 'ForeGroundColor' , [0 0.33 0.16] , 'String' ,['is of (in m): ' , Depthclo]  , ...
                                                         'Units' , 'Normalized' , 'Position' , [0.47 0.79 0.25 0.05] ,  'FontWeight' , 'Normal' , ...
                                                         'HorizontalAlignment' , 'left');
                                  outputlet3 = uicontrol(gcf, 'Style' , 'Text' , 'ForeGroundColor' , [0 0.33 0.16] , 'String' , 'The width of beach profile' , ...
                                                         'Units' , 'Normalized' , 'Position' , [0.47 0.74 0.25 0.05] ,  'FontWeight' , 'Normal' , ...
                                                         'HorizontalAlignment' , 'left');
                                outputlet4 = uicontrol(gcf, 'Style' , 'Text' , 'ForeGroundColor' , [0 0.33 0.16] , 'String' ,['is of (in m): ' , Xclo]  , ...
                                                         'Units' , 'Normalized' , 'Position' , [0.47 0.69 0.25 0.05] , 'FontWeight' , 'Normal' , ...
                                                         'HorizontalAlignment' , 'left');

                   xlabel ('Distance Offshore (meters)');
                   ylabel ('Water Depth  (meters)');
  
                   Coorddean =[x ; y]';
                  
end
        
