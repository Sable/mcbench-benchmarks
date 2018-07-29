 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                       %
%%         Name: wimax.m                                                 %
%%                                                                       %
%%     In this file, a menu is defined which is able to call the         %
%%     different functions that carry out the simulations of the         %
%%     system by varying different parameters such as the channel        %
%%     model, the modulation technique, the size of the cyclic           %
%%     prefix and also the channel bandwidth.                            %
%%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;

% The variables used in the simulation of the system are defined here
SUI = [];
G = [];
n_mod_type = [];

run = 'y';
while run=='y'
    clc;
    disp('   ********************************************************************************************');
    disp('   *                                                                                          *');
    disp('   *                                   FINAL YEAR PROJECT                                     *');
    disp('   *                                                                                          *');
    disp('   *                                                                                          *');    
    disp('   *              Simulation and Performance Analysis of The 802.16 Physical Layer            *');
    disp('   *                                                                                          *');
    disp('   *                         Study Done by Carlos Batllés Ferrer                              *');
    disp('   *                                                                                          *');
    disp('   *       Next, all the possible variants of the simulation shall appear.                    *');
    disp('   *       In every option the user will be asked to define some parameters correctly         *');
    disp('   *       for the simulation.                                                                *');
    disp('   *                                                                                          *');
    disp('   ********************************************************************************************');
    disp('  ');
    disp('      --> The different tests:');
    disp('  ');
    disp('         1) Simulation in which all the modulations are used (BPSK,QPSK,16QAM and 64QAM).'); 
    disp('         2) When we change the size of the "cyclic prefix" (1/4 1/8 1/16 1/32).');
    disp('         3) We realise the simulation WITH and WITHOUT encoding of the bits and study the difference.');
    disp('         4) We carry out the simulation through different SUI channels (1 al 6).');
    disp('         5) We do a simulation with different values of the nominal BW of the system.');
    disp('         6) To exit the program.');
    disp('  ');
    option = input('     Please enter your choice: ');



    switch option
        case 1
            disp('  ');
            G = input('     Please enter the value of G (Cyclic Prefix) [1/4 1/8 1/16 1/32]: ');
            disp('  ');
            SUI = input ('     Please enter which channel you wish to simulate (1 al 6) [AWGN = 0]: ');
            disp('  ');
            disp('     Please enter the nominal BandWidth of the system (BW)');
            BW = input('     Possible Values:28,24,20,15,14,12,11,10,7,6,5.50,5,3.50,3,2.50,1.75,1.5,1.25 [MHz]:');
            disp('  ');
            figur = input('     From which number you wish to start calling the resultant figures:');
            disp('  ');
            samples = input('     Finally enter the number of OFDM symbols to simulate (total bits = 20*symbols):');
            disp('  ');
            disp('     Realizing the simulation.....Please wait a while');
            tic
            TestMods(G,SUI,samples,BW,figur);
        case 2
            disp('  ');
            n_mod_type = input('     Please enter the modulation to use (1->BPSK, 2->QPSK, 3->16QAM ó 4-->64QAM): ');
            if n_mod_type == 3
                n_mod_type = 4;
            elseif n_mod_type == 4
                n_mod_type =6;
            end
            disp('  ');
            SUI = input ('     Please enter which channel you wish to simulate (1 al 6) [AWGN = 0]: ');
            disp('  ');
            disp('     Please enter the nominal BandWidth of the system (BW)');
            BW = input('     Possible Values:28,24,20,15,14,12,11,10,7,6,5.50,5,3.50,3,2.50,1.75,1.5,1.25 [MHz]:');
            disp('  ');
            figur = input('     From which number you wish to start calling the resultant figures:');
            disp('  ');
            samples = input('     Finally enter the number of OFDM symbols to simulate (total bits = 20*symbols):');
            disp('  ');
            disp('     Realizing the simulation.....Please wait a while');
            tic
            TestCP(n_mod_type,SUI,samples,BW,figur);   
        case 3
            disp('  ');
            G = input('     Please enter the value of G (Cyclic Prefix) [1/4 1/8 1/16 1/32]: ');
            disp('  ');
            n_mod_type = input('     Please enter the modulation to use (1->BPSK, 2->QPSK, 3->16QAM ó 4-->64QAM): ');
            if n_mod_type == 3
                n_mod_type = 4;
            elseif n_mod_type == 4
                n_mod_type =6;
            end
            disp('  ');
            SUI = input ('     Please enter which channel you wish to simulate (1 al 6) [AWGN = 0]: ');
            disp('  ');
            disp('     Please enter the nominal BandWidth of the system (BW)');
            BW = input('     Possible Values:28,24,20,15,14,12,11,10,7,6,5.50,5,3.50,3,2.50,1.75,1.5,1.25 [MHz]:');
            disp('  ');
            figur = input('     From which number you wish to start calling the resultant figures:');
            disp('  ');
            samples = input('     Finally enter the number of OFDM symbols to simulate (total bits = 20*symbols):');
            disp('  ');
            disp('     Realizing the simulation.....Please wait a while');
            tic
            TestEncode(n_mod_type,G,SUI,samples,BW,figur);
        case 4
            disp('  ');
            G = input('     Please enter the value of G (Cyclic Prefix) [1/4 1/8 1/16 1/32]: ');
            disp('  ');
            n_mod_type = input('     Please enter the modulation to use (1->BPSK, 2->QPSK, 3->16QAM ó 4-->64QAM): ');
            if n_mod_type == 3
                n_mod_type = 4;
            elseif n_mod_type == 4
                n_mod_type =6;
            end
            disp('  ');
            disp('     Please enter the nominal BandWidth of the system (BW)');
            BW = input('     Possible Values:28,24,20,15,14,12,11,10,7,6,5.50,5,3.50,3,2.50,1.75,1.5,1.25 [MHz]:');
            disp('  ');
            figur = input('     From which number you wish to start calling the resultant figures:');
            disp('  ');
            samples = input('     Finally enter the number of OFDM symbols to simulate (total bits = 20*symbols):');
            disp('  ');
            disp('     Realizing the simulation.....Please wait a while');
            tic
            TestChannels(n_mod_type,G,samples,BW,figur);
        case 5
            disp('  ');
            G = input('     Please enter the value of G (Cyclic Prefix) [1/4 1/8 1/16 1/32]: ');
            disp('  ');
            n_mod_type = input('     Please enter the modulation to use (1->BPSK, 2->QPSK, 3->16QAM ó 4-->64QAM): ');
            if n_mod_type == 3
                n_mod_type = 4;
            elseif n_mod_type == 4
                n_mod_type =6;
            end
            disp('  ');
            SUI = input('     Please enter which channel you wish to simulate (1 al 6) [AWGN = 0]: ');
            disp('  ');
            figur = input('     From which number you wish to start calling the resultant figures:');
            disp('  ');
            samples = input('     Finally enter the number of OFDM symbols to simulate (total bits = 20*symbols):');
            disp('  ');
            disp('     Realizing the simulation.....Please wait a while');
            tic
            TestBW (G,SUI,n_mod_type,samples,figur);
        case 6
            run = 'n';

    end

    if option~=6
        % The clock is started to see how long the simulation has taken
        OFDM_time_simulation = toc;
        disp('  ');
        if OFDM_time_simulation >3600
            disp(strcat('     time taken for the simulation =', num2str(OFDM_time_simulation/3600), ' hours.'));
        elseif OFDM_time_simulation > 60
            disp(strcat('     time taken for the simulation =', num2str(OFDM_time_simulation/60), ' minutes.'));
        else
            disp(strcat('     time taken for the simulation =', num2str(OFDM_time_simulation), ' seconds.'));
        end
        disp('  ');
        run = input ('     --> Do you wish to run other simulations (y/n): ','s');        
    end
       
end

disp('  ');
disp ('     -->  Thank you for using this program  <--   ');


