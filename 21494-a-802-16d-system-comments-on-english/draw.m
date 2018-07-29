function     draw(graphic,value,v_EbN0_dB,v_ber,figur);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                       %
%%      Name: Draw.m                                                     %
%%                                                                       %
%%       Description: This file draws each one of the results of the     %
%%        different tests.                                               %
%%                                                                       %
%%       Parameters: It receives the necessary parameters to be able     %
%%        to draw the corresponding graphs.                              %
%%                                                                       %
%%       Result: It gives back grapsh for each simulations.              %
%%                                                                       %
%%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
grids on;
switch graphic
    case 'Channels'       % Here "value" is equivalent of the channel that we are simulating.
        switch value
            case 1
                form = 'y-';
            case 2
                form = 'm-o';
            case 3
                form = 'c-o';
            case 4
                form = 'r-o';
            case 5
                form = 'g-o';
            case 6
                form = 'b-*';       
        end
        semilogy(v_EbN0_dB,v_ber,form);
        hold on;drawnow;
        
    case 'Encode'      % "value" is representing whether encoding is being used or not.
        switch value
            case 0                              % Uncoded
                form = 'o-';
            case 1                              % Encoded
                form = 'g-o';
        end
        semilogy(v_EbN0_dB,v_ber,form);
        hold on;drawnow;
 
    case 'CP'        % "value" is the size of the Cyclic Prefix.
        switch value
            case 1/4
                form = 'y-';
            case 1/8
                form = 'm-';
            case 1/16
                form = 'c-';
            case 1/32
                form = 'r-';      
        end
        semilogy(v_EbN0_dB,v_ber,form);
        hold on;drawnow;
    
     case 'BW'            % Here "value" is equivalent to the bandwidth-BW.
        switch value
            case 28
                form = 'y-.';
            case 20
                form = 'm-.';
            case 15
                form = 'c-.';
            case 10
                form = 'r-.';
            case 2.50
                form = 'g-.';
            case 1.25
                form = 'b-*';       
        end
        semilogy(v_EbN0_dB,v_ber,form);
        hold on;drawnow;
                
end
            