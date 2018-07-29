function wavelenvsth
% _____________________________________________________
% This function gets the nomograph which shows  the relationship which exists
% between the wavelength, wave period and water depth using the dispersion
% equation.
%
% 0. Syntax:
% >> wavelenvsth
%
% 1. Inputs:
%     None.
%
% 2. Outputs:
%     Nomograph.
%
% 3. Example:
%  >> run(wavelenvsth)
% 
%  4. Notes:
%     - It's only necessary to run the function.
%     - In the nomograph, it is activated the data cursor mode in order to
%       get the wavelength and waver depth in function of the water period.
%     - Wave depths in meters.
%     - Wave length in meters.
%
% 5. Referents:
%      Darlymple, R.G. and Dean R.A. (1999). Water Wave Mechanics
%              for Engineers and Scientist. Advanced Series on Ocean Engineering, Vol. 2
%              World Scientific. Singapure.
%      Le Mehuate, Bernard. (1976). An introduction to hidrodynamics and water waves. 
%              Springer-Verlag. USA.
%
% Gabriel Ruiz.
% Jun-2006
% UNAM
%_______________________________________________________________________

%%%%%%%%%%  M A I N      F U N C T I O N   %%%%%%%%%%
% clear all; clc;
 h = 1:1:130;
    g = 9.81;
        T = 4.5;
            dh = h';
        m=1;
    fg =figure('Menubar', 'none', 'Name', 'Wavelength vs Period and Depth', 'NumberTitle', 'off',...
                    'Position' , [ 6 37 1011 697 ] , 'Color' , [ 0.87 0.87 0.87 ]);

    while T ~= 17
        
        for i=1:130
                    con = 1;
                        l(con) = 0;
                    l(con+1) = 1.56 * T ^ 2; 
                    
                    while abs( l(con+1) - l(con) ) > 0.0001, 
                                l(con+2) = ( ( 9.81 * T ^ 2 ) / ( 2 * pi ) ) * tanh( ( 2 * pi * h(i) ) / l(con+1) );
                                con = con + 1;
                    end
                    
                    L(i) =  l(con);
                    k = ( 2 * pi ) / L(i);
        end
        
        Ls{1,m} = L';   
            hold on
                fgh =plot(dh,Ls{1,m});
                    xlabel('Water Depth (h), meters');
                        ylabel('Wave Length (L), meters');
                    xlim( [ 1 130 ] )
                set(fgh,'Color',rand(1,3));
            set(gca,'Box','on');
        drt = title('Wavelength vs Period and Depth', 'HorizontalAlignment' , 'center' , 'FontWeight', 'bold');
            set(gca, 'XGrid', 'off', 'XMinorTick', 'on' , 'YGrid' , 'off' , 'YMinorTick' , 'on', 'Fontsize', 8 );
                m = m+1;
                    T = 0.5+T;
    end
    
    T= 4.5:0.5:17;
        hj =length(T);
    textos2 = 'T = ';
    
    for i = 1 : hj
            stringer{i,1} = num2str(T(1,i));
            textos{i,1} = horzcat(textos2,stringer{i,1},' s');
    end
        asdk = legend(textos, 'Location', 'EastOutside');
            set(asdk, 'FontSize', 6);
                clc;
            datacursormode on;                        
        dcm_obj = datacursormode(fg);
       fundat = str2func('camdatos'); 
    set(dcm_obj, 'DisplayStyle', 'Window' , 'UpdateFcn' , fundat)
%%%%%%%%%%%%    E N D     M A I N     F U N C T I O N %%%%%%%%%%%%%

function [txtdcm,pos] = camdatos(empt,event_obj)    %% Subfunction 1
pos = get(event_obj,'Position');
txtdcm = {['Water Depth: ',num2str(pos(1))] , ['Wave Length: ',num2str(pos(2))]};

% End of Subfunction 1


