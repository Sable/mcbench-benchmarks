function SieveAnalysis5(Granulometria)
% _____________________________________________________
% See Contents.m
%  With this routine you can get the sand sieve analysis. Routine
% displays the computation of the particle-size distribution in different
% windows. Add you can get the main parameters of statistics analysis:
% percentiles, mean, standard deviation, kurtosis, etc.
% Syntax:
%              >> Granulometria[ %your data];
%              >> SieveAnalysis5(Granulometria)
% Update: 1. I've received a couples of emails, in which  some
%                people had a lot of problems with how to give the inputs;
%                for this reason, I decided to delete the GUI. Now, the
%                user only has to do, it's to create a variable with the
%                name "Granulometria" and inside this variable, you need to
%                write your data. First column, the sieve mesh (in mm) and
%                the second, the weights (in g). For example:
%                Granulometria = [4.0 0.88; 2.0 1.08; 1.0 1.49; 0.50 3.58; 0.25 11.50;
%                                                0.125 21.50; 0.0625 9.81; 0.0313 2.70];
%                2. I deleted an enormous bugs.
%
% Last modification : 03/21/09
% Author: PhD(c) Gabriel Ruiz 
% This routine is provided "as is" without warranty of any kind. 
% Please, you don't attribute it.
% If you'll detect any mistake or bug, may you communicate to me,
% please?
% v1.1.5
% Copyright 2006.
% _____________________________________________________
     clc;
    
    screen = get(0, 'screensize');
    if screen(1,3) == 1152 && screen(1,4) == 864
                 screen(1,3) = screen(1,3) - 128; screen(1,4) = screen(1,4) - 96;
        elseif screen(1,3) == 1280 && screen(1,4) == 768
                 screen(1,3) = screen(1,3) - 256; 
        elseif screen(1,3) == 1280 && screen(1,4) == 800
                 screen(1,3) = screen(1,3) - 256; screen(1,4) = screen(1,4) - 32;         
        elseif screen(1,3) == 1280 && screen(1,4) == 960
                 screen(1,3) = screen(1,3) - 256; screen(1,4) = screen(1,4) - 192;
        elseif screen(1,3) == 1280 && screen(1,4) == 1024
                 screen(1,3) = screen(1,3) - 256; screen(1,4) = screen(1,4) - 256; 
        elseif screen(1,3) == 1400 && screen(1,4) == 1050
                 screen(1,3) = screen(1,3) - 376; screen(1,4) = screen(1,4) - 282;
        elseif screen(1,3) == 1600 && screen(1,4) == 900
                 screen(1,3) = screen(1,3) - 576; screen(1,4) = screen(1,4) - 132;
        elseif screen(1,3) == 1600 && screen(1,4) == 1200        
                 screen(1,3) = screen(1,3) - 576; screen(1,4) = screen(1,4) - 432;
    end
    vpan = screen(1,4)-35; hpan = screen(1,3);    
    colores = [1 1 0.85 ]; colortexto = [0.50 0.25 0.25];
    WB = Granulometria(:,2);
    milimeters = Granulometria(:,1);
    r = length(milimeters);  

        for i = 1 : r 
                Worksheet_sieve_data{1,1}(i) = WB(i);
        end
        Sum_Col_1 = sum( Worksheet_sieve_data{1,1} );
        for i = 1: r 
                Worksheet_sieve_data{1,2}(i) = ( Worksheet_sieve_data{1,1}(i) / Sum_Col_1) * 100;
                if i == 1 
                        Worksheet_sieve_data{1,3}(i) = Worksheet_sieve_data{1,2}(i);
                        Worksheet_sieve_data{1,4}(i) = 100;
                else      
                        Worksheet_sieve_data{1,3}(i) = Worksheet_sieve_data{1,2}(i) + Worksheet_sieve_data{1,3}(i-1);
                        Worksheet_sieve_data{1,4}(i) = Worksheet_sieve_data{1,4}(1) - Worksheet_sieve_data{1,3}(i);
                end
        end

        diamX = Worksheet_sieve_data{1,4} ;
        diamX = diamX';
        diamY = milimeters;
        D_5 = interp1(diamX, diamY, 5, 'pchip');
        D_10 = interp1(diamX, diamY, 10, 'pchip');
        D_16 = interp1(diamX, diamY, 16, 'pchip');
        D_25 = interp1(diamX, diamY, 25, 'pchip');
        D_30 = interp1(diamX, diamY, 30, 'pchip');
        D_50 = interp1(diamX, diamY, 50, 'pchip');  
        D_60 = interp1(diamX, diamY, 60, 'pchip');
        D_75 = interp1(diamX, diamY, 75, 'pchip');
        D_84 = interp1(diamX, diamY, 84, 'pchip');
        D_95 = interp1(diamX, diamY, 95, 'pchip');

        resulchar.d_5 = num2str(D_5); 
        resulchar.d_10 = num2str(D_10); 
        resulchar.d_16 = num2str(D_16);
        resulchar.d_25 = num2str(D_25); 
        resulchar.d_30 = num2str(D_30); 
        resulchar.d_50 = num2str(D_50);
        resulchar.d_60 = num2str(D_60); 
        resulchar.d_75 = num2str(D_75); 
        resulchar.d_84 = num2str(D_84);
        resulchar.d_95 = num2str(D_95); 

        D_5phi = -log(D_5) / log(2);      %Matlab has the function log2, but I prefer to use this form.
        D_10phi = -log(D_10) / log(2);
        D_16phi = -log(D_16) / log(2);
        D_25phi = -log(D_25) / log(2);
        D_30phi = -log(D_30) / log(2);
        D_50phi = -log(D_50) / log(2);  
        D_60phi = -log(D_60) / log(2);
        D_75phi = -log(D_75) / log(2);
        D_84phi = -log(D_84) / log(2);
        D_95phi = -log(D_95) / log(2);

        Mean_grain_size = ( D_16phi + D_50phi + D_84phi ) / 3;      
        Mean_grain_size_mm = 2 ^ -(Mean_grain_size);
        resulchar.MeanGS = num2str(Mean_grain_size_mm);
        
        if Mean_grain_size_mm <= 0.075
                    resulchar.ASTM = 'Fine Soil';
            elseif Mean_grain_size_mm >= 0.076 && Mean_grain_size_mm <= 0.425
                    resulchar.ASTM = 'Fine sand';
            elseif Mean_grain_size_mm >= 0.426 && Mean_grain_size_mm <= 2
                    resulchar.ASTM = 'Medium sand';            
            elseif Mean_grain_size_mm >= 2.1 && Mean_grain_size_mm <= 4.75
                    resulchar.ASTM = 'Coarse sand';   
            elseif Mean_grain_size_mm >= 4.76 && Mean_grain_size_mm <= 19
                    resulchar.ASTM = 'Fine gravel'; 
            elseif Mean_grain_size_mm >= 19.1 && Mean_grain_size_mm <= 75
                    resulchar.ASTM = 'Coarse gravel';  
        end

        if Mean_grain_size_mm >= 0.0625 && Mean_grain_size_mm <= 0.125
                    resulchar.Wentworth = 'Very fine sand';
            elseif Mean_grain_size_mm >= 0.126 && Mean_grain_size_mm <= 0.250
                    resulchar.Wentworth = 'Fine sand';
            elseif Mean_grain_size_mm >= 0.251 && Mean_grain_size_mm <= 0.50
                    resulchar.Wentworth = 'Medium sand';            
            elseif Mean_grain_size_mm >= 0.51 && Mean_grain_size_mm <= 1
                    resulchar.Wentworth = 'Coarse sand';   
            elseif Mean_grain_size_mm >= 1.01 && Mean_grain_size_mm <= 2
                    resulchar.Wentworth = 'Very coarse sand'; 
            elseif Mean_grain_size_mm >= 2.01 && Mean_grain_size_mm <= 4.76
                    resulchar.Wentworth = 'Granule';  
            elseif Mean_grain_size_mm >= 4.77 && Mean_grain_size_mm <= 8
                    resulchar.Wentworth = 'Small pebble';             
            elseif Mean_grain_size_mm >= 8.01 && Mean_grain_size_mm <= 16
                    resulchar.Wentworth = 'Medium pebble'; 
            elseif Mean_grain_size_mm >= 16.01 && Mean_grain_size_mm <= 19.03
                    resulchar.Wentworth = 'Large pebble'; 
        end
        
        gravel = zeros(r,1);
        for i = 1 : r  
            if milimeters(i,1) <= 75 && milimeters(i,1) >= 4.75
                gravel(i,1) = Worksheet_sieve_data{1,2}(i);
            end
        end
        Gravel = sum(gravel(:,1));
        resulchar.Grava = num2str(Gravel);
 
        sand = zeros(r,1);
        for i = 1 : r  
            if milimeters(i,1) <= 4.74 && milimeters(i,1) >= 0.075
                    sand(i,1) = Worksheet_sieve_data{1,2}(i);
            end
        end
        Sand = sum(sand(:,1));
        resulchar.arena = num2str(Sand);

         fine = zeros(r,1);  
        for i = 1 : r  
            if milimeters(i,1) <= 0.074
                    fine(i,1) = Worksheet_sieve_data{1,2}(i);
            end
        end
        Fine = sum(fine(:,1));
        resulchar.fino =num2str(Fine);
        Muestrapor = [ Gravel Sand Fine ];

        Standard_Deviation = ( ( D_84phi - D_16phi ) / 4 ) + ( ( D_95phi - D_5phi ) / 6 );   % E.3.
        Standard_Deviation_mm = 2 ^ -(Standard_Deviation);
        resulchar.SDe = num2str(Standard_Deviation_mm);
        if Standard_Deviation < 0.34
                    resulchar.SD = 'Very well sorted';
            elseif Standard_Deviation >= 0.35 && Standard_Deviation <= 0.49
                    resulchar.SD = 'Well sorted';
            elseif Standard_Deviation >= 0.50 && Standard_Deviation <= 0.71
                    resulchar.SD = 'Moderately well sorted';
            elseif Standard_Deviation >= 0.72 && Standard_Deviation <= 0.99
                    resulchar.SD = 'Moderately sorted';
            elseif Standard_Deviation >= 1.00 && Standard_Deviation <= 1.99
                    resulchar.SD = 'Poorly sorted';
            elseif Standard_Deviation >= 2.00 && Standard_Deviation <= 3.99
                    resulchar.SD = 'Very poorly sorted';
            elseif Standard_Deviation >= 4.00 
                    resulchar.SD = 'Extremely poorly sorted';
        end
        
        Skewness =  ( ( D_84phi + D_16phi - ( 2 * D_50phi ) ) / ( 2 * ( D_84phi - D_16phi ) ) ) + ...     
                              ( ( D_95phi + D_5phi - ( 2 * D_50phi ) ) / ( 2 * ( D_95phi - D_5phi ) ) );
        Skewness_mm = 2 ^ -(Skewness);
        resulchar.S_ke = num2str(Skewness_mm);
        if Skewness < -0.29
                    resulchar.Sk = 'Very coarse skewed';
            elseif Skewness >= -0.30 && Skewness <= -0.09
                    resulchar.Sk = 'Coarse skewed';
            elseif Skewness >= -0.10 && Skewness <= 0.09
                    resulchar.Sk = 'Near symmetrical';
            elseif Skewness >= 0.10 && Skewness <= 0.29
                    resulchar.Sk = 'Fine skewed';
            elseif Skewness >= 0.30 
                    resulchar.Sk = 'Very fine skewed';
        end
    
        Kurtosis = ( D_95phi - D_5phi ) / ( 2.44 * ( D_75phi - D_25phi ) );     
        Kurtosis_mm = 2 ^ -(Kurtosis);
        resulchar.K_ur = num2str(Kurtosis_mm);
         if Kurtosis < 0.64
                    resulchar.kurt = 'Very platykurtic (flat)';
            elseif Kurtosis >= 0.65 && Kurtosis <= 0.89
                    resulchar.kurt = 'Platykurtic';
            elseif Kurtosis >= 0.90 && Kurtosis <= 1.10
                    resulchar.kurt = 'Mesokurtic ';
            elseif Kurtosis >= 1.11 && Kurtosis <= 1.49
                    resulchar.kurt = 'Leptokurtic (peaked)';
            elseif Kurtosis >= 1.50 && Kurtosis <= 2.99
                    resulchar.kurt = 'Very leptokurtic';
            elseif Kurtosis >= 3.00 
                    resulchar.kurt = 'Extremely leptokurtic';
        end
        
        Cc_Dispersal = D_30 ^ 2 / ( D_10 * D_60 ) ;
        resulchar.CC = num2str(Cc_Dispersal);
        Cu_Hazen_uniformity = D_60 / D_10;
        resulchar.Cu =num2str(Cu_Hazen_uniformity);
        if Cu_Hazen_uniformity >= 6 && ( ( Cc_Dispersal >= 1 ) && ( Cc_Dispersal <= 3 ) )
                    resulchar.SUCS = 'SW';
        else
                    resulchar.SUCS = 'SP';
        end
        
        figure(3);
        set(figure(3), 'Units' , 'Pixels' , 'NumberTitle' , 'Off' , 'Resize' , 'on' , ...
                'Name' , '1.Sieve Analysis - Histogram' , 'Color' , [0.93 0.91 0.85] , ...
                'Position' , [  hpan-880   vpan-440   hpan-664   vpan-464 ] );    
        histo_h =bar(milimeters,Worksheet_sieve_data{1,2}, 'group');
        colormap hsv;
        xlabel('Grain Size in mm' , 'Fontsize' , 7); 
        ylabel('Percent Finer by Weight (%)' , 'Fontsize' , 7);
        title('Histogram' , 'Color' , 'r' , 'FontWeight' , 'Bold' , 'Fontsize' , 8);
        set(histo_h,  'FaceColor', 'r');
        set(gca,  'Xgrid' , 'on' , 'Ygrid' , 'on' , 'Xcolor' , [0 0 0.37] , 'Ycolor' , [0 0 0.37] , 'Box' , 'off' , ...
                   'FontWeight' , 'Bold' , 'FontSize' , 7 , 'FontAngle' , 'Oblique' , 'XMinorTick' , 'on' , 'YMinorTick' , 'on');
          
        figure(4);
        set(figure(4), 'Units' , 'Pixels' , 'NumberTitle' , 'Off' , 'Resize' , 'on' , 'Color' , [0.93 0.91 0.85] , ...
                'Position' , [  hpan-859   vpan-469  hpan-664  vpan-464 ] , ... 
                'name' , '2.Sieve Analysis - Frecuency Curve' );  
        FCruve_h = plot(milimeters, Worksheet_sieve_data{1,2}, '-', 'Color' , 'b' , 'Linewidth' , 1.5);
        xlabel('Grain Size in mm' , 'Fontsize' , 7); 
        ylabel('Percent Finer by Weight (%)' , 'Fontsize' , 7);
        title('Frecuency Curve' , 'Color' , 'b' , 'FontWeight' , 'Bold' , 'Fontsize' , 8);
        set(gca,  'Xgrid' , 'on' , 'Ygrid' , 'on' , 'Xcolor' , [0 0 0.37] , 'Ycolor' , [0 0 0.37] , 'Box' , 'off' , ...
                   'FontWeight' , 'Bold' , 'FontSize' , 7 , 'FontAngle' , 'Oblique' , 'XMinorTick' , 'on' , 'YMinorTick' , 'on');

        figure(5);
        set(figure(5), 'Units' , 'Pixels' , 'NumberTitle' , 'Off' , 'Resize' , 'on' , 'Color' , [0.93 0.91 0.85] , ...
                'Position' , [hpan-838  vpan-499  hpan-664  vpan-464] , ...
                'name' , '3. Sieve Analysis - Cumulative Arithmetic Curve' );  
        ACurve_h = plot(milimeters, Worksheet_sieve_data{1,3}, '-', 'Color' , [0 0.5 0] , 'Linewidth' , 1.5);
        xlabel('Grain Size in mm' , 'Fontsize' , 7); 
        ylabel('Percent Finer by Weight (%)' , 'Fontsize' , 7);
        title('Frecuency Cumulative  Curve' , 'Color' , [0 0.5 0] , 'FontWeight' , 'Bold' , 'Fontsize' , 8);
        set(gca,  'Xgrid' , 'on' , 'Ygrid' , 'on' , 'Xcolor' , [0 0 0.37] , 'Ycolor' , [0 0 0.37] , 'Box' , 'off' , ...
                   'FontWeight' , 'Bold' , 'FontSize' , 7 , 'FontAngle' , 'Oblique' , 'XMinorTick' , 'on' , 'YMinorTick' , 'on');

        figure(6);
        set(figure(6), 'Units' , 'Pixels' , 'NumberTitle' , 'Off' , 'Resize' , 'on' , 'Color' , [0.93 0.91 0.85] , ...
                'Position' , [ hpan-816   vpan-529   hpan-664  vpan-464] , ...
                'name' , '4. Sieve Analysis - Cumulative Probability Arithmetic Curve' );   
        CCurve_h = plot(milimeters, Worksheet_sieve_data{1,4}, '-','Color' , [1 0.5 0] , 'Linewidth' , 1.5);
        xlabel('Grain Size in mm', 'Fontsize' , 7); 
        ylabel('Probability Finer by Weight (%)' , 'Fontsize' , 7);
        title('Cumulative Probability Curve ' , 'Color' , [1 0.5 0] , 'FontWeight' , 'Bold' , 'Fontsize' , 8);
        set(gca,  'Xgrid' , 'on' , 'Ygrid' , 'on' , 'Xcolor' , [0 0 0.37] , 'Ycolor' , [0 0 0.37] , 'Box' , 'off' , ...
                   'FontWeight' , 'Bold' , 'FontSize' , 7 , 'FontAngle' , 'Oblique' , 'XMinorTick' , 'on' , 'YMinorTick' , 'on');

        figure(7);
        set(figure(7), 'Units' , 'Pixels' , 'NumberTitle' , 'Off' , 'Resize' , 'on' , 'Color' , [0.93 0.91 0.85] , ...
                'Position' , [   hpan-778   vpan-587    hpan-348    vpan-464  ] , ... 
                 'name' , '6. Sieve Analysis - Cumulative Probability Semi-Log Curve'  );  
        CCurvesl_h = semilogx(milimeters, Worksheet_sieve_data{1,4}, '-o','Color' , [0 0 0.5] , ...
                                      'Linewidth' , 2.5, 'MarkerFaceColor' , [ 0 0 0.5 ] , 'MarkerSize' , 2, ...
                                      'MarkerEdgeColor' , [ 0 0.5 0.5] );
        axis tight;
        xlabel('Grain Size in mm', 'Fontsize' , 7); 
        ylabel('Probability Finer by Weight (%)' , 'Fontsize' , 7);
        title('Cumulative Probability Curve ' , 'Color' , [0 0 0.5] , 'FontWeight' , 'Bold' , 'Fontsize' , 8);
        set(gca,  'Xgrid' , 'on' , 'Ygrid' , 'on' , 'Xcolor' , [0 0 0.37] , 'Ycolor' , [0 0 0.37] , 'Box' , 'off' , 'XDir' , 'normal' , ...
                   'FontWeight' , 'Bold' , 'FontSize' , 7 , 'FontAngle' , 'Oblique' , 'XMinorTick' , 'on' , 'YMinorTick' , 'on', ...
                   'Xlim' , [0.01 10]  , 'XTickLabel', { '0.01' ; '0.1' ; '1' ;  '10' } ); 
        dimark = [0.074 4.76];
        hold on;
        escalY = get(gca,'YLim');
        escalY = [ 0 escalY(1,2) ];
        lenmark = length(dimark);
        xmark = reshape([dimark;dimark;ones(1,lenmark)*nan;],lenmark*3,1);
        ymark = repmat([escalY nan],1,lenmark);
        plot(xmark,ymark, 'r', 'LineWidth', 2 );
        punto07 = patch(D_50 , 50 , [1 0 0] );
        punto08 = patch(0.01, 50 ,  [1 0 0] ); 
        punto09 = patch(D_50 , 0.01 , [1 0 0]); 
         l4 = line('Xdata' , [D_50 D_50] , 'Ydata' , [0 50] , 'Color' ,  [0.75 0.75 0.75] , ...
                        'Linestyle' , '-' , 'Linewidth' , 2 ) ;
         l5 = line('Xdata' , [0.01 D_50] , 'Ydata' , [50 50] , 'Color' ,  [0.75 0.75 0.75] , ...
                        'Linestyle' , '-' , 'Linewidth' , 2 );
        set(punto07, 'marker' , 'o' , 'MarkerEdgeColor', 'r' , 'MarkerFaceColor', 'r' , ...
                 'MarkerSize' , 2);
        set(punto08, 'marker' , 'o' , 'MarkerEdgeColor', 'r' , 'MarkerFaceColor', 'r' , ...
                 'MarkerSize' , 2);
        set(punto09, 'marker' , 'o' , 'MarkerEdgeColor', 'r' , 'MarkerFaceColor', 'r', ...
                 'MarkerSize' , 2);
        td50 = text(D_50+.005 , 3, num2str(D_50)); set(td50, 'FontSize' , 8 , ...
                            'FontAngle' , 'Normal' , 'FontWeight' , 'Bold' );
        tfinos = text(0.011 , 95, 'Fine'); set(tfinos, 'FontSize' , 8 , 'FontWeight' , 'Bold');
        tsand = text(0.085 , 95, 'Sand'); set(tsand, 'FontSize' , 8 , 'FontWeight' , 'Bold' );
        tgrav = text(5 , 95, 'Gravel'); set(tgrav, 'FontSize' , 8 , 'FontWeight' , 'Bold' );
              
        figure(8);
        set(figure(8), 'Units' , 'Pixels' , 'NumberTitle' , 'Off' , 'Resize' , 'on' , 'Color' , [0.93 0.91 0.85] , ...
                'Position' , [   hpan-796   vpan-558    hpan-664  vpan-464  ] , ... 
                'name' , '5. Sieve Analysis - Cumulative Probability Logarithmic Curve' );   
        CCurvel_h = loglog(milimeters, Worksheet_sieve_data{1,4}, '-','Color' , [0.5 0 0.5] , 'Linewidth' , 1.5);
        xlabel('Grain Size in mm' ,'Fontsize' , 7); 
        ylabel('Probability Finer by Weight (%)', 'Fontsize' , 7);
        title('Cumulative Probability Curve ' , 'Color' , [0.5 0 0.5] , 'FontWeight' , 'Bold' , 'Fontsize' , 8);
        set(gca,  'Xgrid' , 'on' , 'Ygrid' , 'on' , 'Xcolor' , [0 0 0.37] , 'Ycolor' , [0 0 0.37] , 'Box' , 'off' , ...
                   'FontWeight' , 'Bold' , 'FontSize' , 7 , 'FontAngle' , 'Oblique' , 'XMinorTick' , 'on' , 'YMinorTick' , 'on'); clc;
     
        figure(9);
        set(figure(9), 'Units' , 'Pixels' , 'NumberTitle' , 'Off' , 'Resize' , 'on' , 'Color' , [0.93 0.91 0.85] , ...
                'Position' , [  hpan-757   vpan-616    hpan-664  vpan-464  ] , ... 
                'name' , '7. Sieve Analysis - % Percent of Sand'  );
        if Muestrapor(1,1) == 0 && Muestrapor(1,2) ~= 0 && Muestrapor(1,3) ~= 0
                    hotcake(1,1) =Muestrapor(1,2); 
                    hotcake(1,2) =Muestrapor(1,3); 
                    explode = [ 0 1 ];
                    piecg = pie(hotcake, explode); 
                    hdlleg = legend('Sand', 'Fine', -1); 
                    set(piecg(1,2), 'FontUnits', 'pixels', 'FontSize' , 10);
                    set(piecg(1,4), 'FontUnits', 'pixels', 'FontSize' , 10);
         elseif Muestrapor(1,1) ~= 0 && Muestrapor(1,2) ~= 0 && Muestrapor(1,3) == 0
                    hotcake(1,1) =Muestrapor(1,1); 
                    hotcake(1,2) =Muestrapor(1,2); 
                    explode = [ 0 1 ];
                    piecg = pie(hotcake, explode); 
                    hdlleg = legend('Gravel' , 'Sand',  -1); 
                    set(piecg(1,2), 'FontUnits', 'pixels', 'FontSize' , 10);
                    set(piecg(1,4), 'FontUnits', 'pixels', 'FontSize' , 10);
        elseif Muestrapor(1,1) ~= 0 && Muestrapor(1,2) ~= 0 && Muestrapor(1,3) ~= 0
                    explode = [ 0 1 0 ];
                    piecg = pie(Muestrapor, explode);
                    hdlleg = legend('Gravel' , 'Sand', 'Fine', -1);
                    set(piecg(1,2), 'FontUnits', 'pixels', 'FontSize' , 10);
                    set(piecg(1,4), 'FontUnits', 'pixels', 'FontSize' , 10);
                    set(piecg(1,6), 'FontUnits', 'pixels', 'FontSize' , 10);
        elseif Muestrapor(1,1) ~= 0 && Muestrapor(1,2) == 0 && Muestrapor(1,3) ~= 0
                    hotcake(1,1) = Muestrapor(1,1); 
                    hotcake(1,2) = Muestrapor(1,3);
                    explode = [ 0 1 ];
                    piecg = pie(hotcake, explode); 
                    hdlleg = legend('Gravel' , 'Fine',  -1); 
                    set(piecg(1,2), 'FontUnits', 'pixels', 'FontSize' , 10);
                    set(piecg(1,4), 'FontUnits', 'pixels', 'FontSize' , 10);
        elseif Muestrapor(1,1) ~= 0 && Muestrapor(1,2) == 0 && Muestrapor(1,3) == 0
                    hotcake = Muestrapor(1,1) ;
                    piecg = pie(hotcake); 
                    hdlleg = legend('Gravel' , -1); 
                    set(piecg(1,2), 'FontUnits', 'pixels', 'FontSize' , 10);
        elseif Muestrapor(1,1) == 0 && Muestrapor(1,2) ~= 0  && Muestrapor(1,3) == 0
                    hotcake = Muestrapor(1,2) ;
                    piecg = pie(hotcake); 
                    hdlleg = legend('Sand' , -1); 
                    set(piecg(1,2), 'FontUnits', 'pixels', 'FontSize' , 10);
         elseif Muestrapor(1,1) == 0 && Muestrapor(1,2) == 0 && Muestrapor(1,3) ~= 0
                    hotcake = Muestrapor(1,3) ;
                    piecg = pie(hotcake); 
                    hdlleg = legend('Fine' , -1);  
                    set(piecg(1,2), 'FontUnits', 'pixels', 'FontSize' , 10);
        end
        set(hdlleg, 'Color' , [ 0.93 0.91 0.85 ], 'Box', 'on'); clc;
        
        result = figure(11);
        set(result, 'Units' , 'Pixels' , 'NumberTitle' , 'Off' , 'Resize' , 'on' , 'Color' , [0.93 0.91 0.85] , ...
                'Position' , [   10+hpan/3+hpan-686  35   hpan-690 (vpan/3)*2-50] , ...
                'name' , '8. Sieve Analysis - Results' ); 
         P4 = 12;                
        uicontrol(result, 'Style' , 'Text' , 'String', 'The main results of sieve analysis were:' , 'Unit' , 'Pixels' , 'Position' , [0 418 300 P4] , ...
                                   'BackGroundColor' , [0.93 0.91 0.85] , 'FontWeight' , 'Bold', 'HorizontalAlignment', 'left' );
        uicontrol(result, 'Style' , 'Text' , 'String', ['D_5 (mm) = ' , resulchar.d_5  ] , 'Unit' , 'Pixels' , 'Position' , [0 405 200 P4] , ...
                                   'BackGroundColor' , [0.93 0.91 0.85] , 'FontWeight' , 'Bold', 'HorizontalAlignment', 'left');                               
        uicontrol(result, 'Style' , 'Text' , 'String', ['D_10 (mm) = ' , resulchar.d_10  ] , 'Unit' , 'Pixels' , 'Position' , [0 392 200 P4] , ...
                                   'BackGroundColor' , [0.93 0.91 0.85] , 'FontWeight' , 'Bold', 'HorizontalAlignment', 'left');   
        uicontrol(result, 'Style' , 'Text' , 'String', ['D_16 (mm) = ' , resulchar.d_16  ] , 'Unit' , 'Pixels' , 'Position' , [0 379 200 P4] , ...
                                   'BackGroundColor' , [0.93 0.91 0.85] , 'FontWeight' , 'Bold', 'HorizontalAlignment', 'left');   
        uicontrol(result, 'Style' , 'Text' , 'String', ['D_30 (mm) = ' , resulchar.d_30  ] , 'Unit' , 'Pixels' , 'Position' , [0 366 200 P4] , ...
                                   'BackGroundColor' , [0.93 0.91 0.85] , 'FontWeight' , 'Bold', 'HorizontalAlignment', 'left');                               
        uicontrol(result, 'Style' , 'Text' , 'String', ['D_50 (mm) = ' , resulchar.d_50  ] , 'Unit' , 'Pixels' , 'Position' , [0 353 200 P4] , ...
                                   'BackGroundColor' , [0.93 0.91 0.85] , 'FontWeight' , 'Bold', 'ForegroundColor' , [0.5 0 0 ] , 'HorizontalAlignment', 'left');   
        uicontrol(result, 'Style' , 'Text' , 'String', ['D_60 (mm) = ' , resulchar.d_60  ] , 'Unit' , 'Pixels' , 'Position' , [0 340 200 P4] , ...
                                   'BackGroundColor' , [0.93 0.91 0.85] , 'FontWeight' , 'Bold', 'HorizontalAlignment', 'left'); 
        uicontrol(result, 'Style' , 'Text' , 'String', ['D_75 (mm) = ' , resulchar.d_75  ] , 'Unit' , 'Pixels' , 'Position' , [0 327 200 P4] , ...
                                   'BackGroundColor' , [0.93 0.91 0.85] , 'FontWeight' , 'Bold', 'HorizontalAlignment', 'left');                               
        uicontrol(result, 'Style' , 'Text' , 'String', ['D_84 (mm) = ' , resulchar.d_84  ] , 'Unit' , 'Pixels' , 'Position' , [0 314 200 P4] , ...
                                   'BackGroundColor' , [0.93 0.91 0.85], 'FontWeight' , 'Bold', 'HorizontalAlignment', 'left');   
        uicontrol(result, 'Style' , 'Text' , 'String', ['D_95 (mm) = ' , resulchar.d_95  ] , 'Unit' , 'Pixels' , 'Position' , [0 301 200 P4] , ...
                                   'BackGroundColor' , [0.93 0.91 0.85] , 'FontWeight' , 'Bold', 'HorizontalAlignment', 'left'); 
        uicontrol(result, 'Style' , 'Text' , 'String', ['Mean Grain Size  (mm) = ' , resulchar.MeanGS  ] , 'Unit' , 'Pixels' , 'Position' , [0 288 200 P4] , ...
                                   'BackGroundColor' , [0.93 0.91 0.85] , 'FontWeight' , 'Bold', 'ForegroundColor' , [0.5 0 0 ] , 'HorizontalAlignment', 'left');   
        uicontrol(result, 'Style' , 'Text' , 'String', ['Standard Deviation ' , resulchar.SDe  ] , 'Unit' , 'Pixels' , 'Position' , [0 273 200 P4] , ...
                                   'BackGroundColor' , [0.93 0.91 0.85] , 'FontWeight' , 'Bold', 'HorizontalAlignment', 'left'); 
        uicontrol(result, 'Style' , 'Text' , 'String', ['Skewness = ' , resulchar.S_ke  ] , 'Unit' , 'Pixels' , 'Position' , [0 260 200 P4] , ...
                                   'BackGroundColor' , [0.93 0.91 0.85] , 'FontWeight' , 'Bold', 'HorizontalAlignment', 'left');                               
        uicontrol(result, 'Style' , 'Text' , 'String', ['Kurtosis = ' , resulchar.K_ur  ] , 'Unit' , 'Pixels' , 'Position' , [0 247 200 P4] , ...
                                   'BackGroundColor' , [0.93 0.91 0.85] , 'FontWeight' , 'Bold', 'HorizontalAlignment', 'left');   
        uicontrol(result, 'Style' , 'Text' , 'String', ['Coeficient of uniformity (Cc) = ' , resulchar.CC  ] , 'Unit' , 'Pixels' , 'Position' , [0 236 300 P4] , ...
                                   'BackGroundColor' , [0.93 0.91 0.85] , 'FontWeight' , 'Bold', 'HorizontalAlignment', 'left'); 
        uicontrol(result, 'Style' , 'Text' , 'String', ['Coeficient of curvature (Cu) = ' , resulchar.Cu  ] , 'Unit' , 'Pixels' , 'Position' , [0 223 300 P4] , ...
                                   'BackGroundColor' , [0.93 0.91 0.85] , 'FontWeight' , 'Bold', 'HorizontalAlignment', 'left');              
        uicontrol(result, 'Style' , 'Text' , 'String', ['Standard Deviation Classification = ' , resulchar.SD  ] , 'Unit' , 'Pixels' , 'Position' , [0 210 300 P4] , ...
                                   'BackGroundColor' , [0.93 0.91 0.85] , 'FontWeight' , 'Bold', 'HorizontalAlignment', 'left');   
        uicontrol(result, 'Style' , 'Text' , 'String', ['Skewness Classification = ' , resulchar.Sk  ] , 'Unit' , 'Pixels' , 'Position' , [0 197 300 P4] , ...
                                   'BackGroundColor' , [0.93 0.91 0.85] , 'FontWeight' , 'Bold', 'HorizontalAlignment', 'left');  
        uicontrol(result, 'Style' , 'Text' , 'String', ['Kurtosis Classification = ' , resulchar.kurt  ] , 'Unit' , 'Pixels' , 'Position' , [0 184 300 P4] , ...
                                   'BackGroundColor' , [0.93 0.91 0.85] , 'FontWeight' , 'Bold', 'HorizontalAlignment', 'left'); 
        uicontrol(result, 'Style' , 'Text' , 'String', ['ASTM Classification = ' , resulchar.ASTM  ] , 'Unit' , 'Pixels' , 'Position' , [0 169 300 P4] , ...
                                   'BackGroundColor' , [0.93 0.91 0.85] , 'FontWeight' , 'Bold', 'ForegroundColor' , [0.5 0 0 ] , 'HorizontalAlignment', 'left'); 
        uicontrol(result, 'Style' , 'Text' , 'String', ['% of Gravel = ' , resulchar.Grava  ] , 'Unit' , 'Pixels' , 'Position' , [0 158 300 P4] , ...
                                   'BackGroundColor' , [0.93 0.91 0.85] , 'FontWeight' , 'Bold', 'ForegroundColor' , [0.5 0 0 ] , 'HorizontalAlignment', 'left');  
        uicontrol(result, 'Style' , 'Text' , 'String', ['% of Sand = ' , resulchar.arena  ] , 'Unit' , 'Pixels' , 'Position' , [0 145 300 P4] , ...
                                   'BackGroundColor' , [0.93 0.91 0.85] , 'FontWeight' , 'Bold', 'ForegroundColor' , [0.5 0 0 ] , 'HorizontalAlignment', 'left');              
        uicontrol(result, 'Style' , 'Text' , 'String', ['% of Fine = ' , resulchar.fino  ] , 'Unit' , 'Pixels' , 'Position' , [0 132 300 P4] , ...
                                   'BackGroundColor' , [0.93 0.91 0.85] , 'FontWeight' , 'Bold', 'ForegroundColor' , [0.5 0 0 ] , 'HorizontalAlignment', 'left');                 
        uicontrol(result, 'Style' , 'Text' , 'String', ['Wentworth classification = ' , resulchar.Wentworth  ] , 'Unit' , 'Pixels' , 'Position' , [0 117 300 P4] , ...
                                   'BackGroundColor' , [0.93 0.91 0.85] , 'FontWeight' , 'Bold', 'ForegroundColor' , [0.5 0 0 ] , 'HorizontalAlignment', 'left');
        uicontrol(result, 'Style' , 'Text' , 'String', ['USCS classification = ' , resulchar.SUCS  ] , 'Unit' , 'Pixels' , 'Position' , [0 103 300 P4] , ...
                                   'BackGroundColor' , [0.93 0.91 0.85] , 'FontWeight' , 'Bold', 'ForegroundColor' , [0.5 0 0 ] , 'HorizontalAlignment', 'left');
