% /*M-FILE SCRIPT SwarmBat_demo_SO_std MMM SGALAB */ %
% /*==================================================================================================
%  Swarm Optimisation and Algorithm Laboratory Toolbox for MATLAB
%
%  Copyright 2012 The SxLAB Family - Yi Chen - leo.chen.yi@live.co.uk
% ====================================================================================================
% File description:
%
%Appendix comments:
%
%Usage:
%
%===================================================================================================
%  See Also:
%
%===================================================================================================
%===================================================================================================
%Revision -
%Date          Name     Description of Change  email
%16-May-2011   Chen Yi  Initial version        leo.chen.yi@live.co.uk
%26-Jul-2011   Chen Yi  Add eachtimeplot       leo.chen.yi@live.co.uk
%HISTORY$
%==================================================================================================*/
%==================================================================================================*/

% SwarmBat_demo_SO_std Begin



% fresh
clear ;
close ('all');
warning off
% to delete old output_*.txt
!del SwarmBat_O_*.*
% set working path

% begin to count time during calculating
home ;
tic % timer start >>

% data preparation

% open data files

%%%input data files
fid1  = fopen('SwarmBat_I_min_confines.txt' , 'r' );
fid2  = fopen('SwarmBat_I_max_confines.txt' , 'r' );
%fid3  = fopen('SwarmBat_I_soundspeed.txt' , 'r' );
fid4  = fopen('SwarmBat_I_distpara.txt' , 'r' );
fid5  = fopen('SwarmBat_I_population.txt' , 'r' );
fid6  = fopen('SwarmBat_I_randomstep.txt' , 'r' );
fid7  = fopen('SwarmBat_I_max_generation.txt' , 'r' );
fid8  = fopen('SwarmBat_I_loundness_min.txt' , 'r' );
fid9  = fopen('SwarmBat_I_PErate_min.txt','r');
%          fid10 = fopen('INPUT_deta_fitness_max.txt','r');
%          fid11 = fopen('INPUT_max_probability_crossover.txt','r');
%          fid12 = fopen('INPUT_probability_crossover_step.txt','r');
%          fid13 = fopen('INPUT_max_no_change_fitness_generation.txt','r');
%          fid22 = fopen('INPUT_tournament_size.txt','r');
fid10  = fopen('SwarmBat_I_loundness_alpha.txt' , 'r' );
fid11  = fopen('SwarmBat_I_PErate_gamma.txt','r');

fid20= fopen('SwarmBat_I_fHz.txt','r');

% set total test number
fid1000= fopen('SwarmBat_I_testnumber.txt','r');

%output data files
fid120 = fopen('SwarmBat_O_best_fitness.txt','a+');
fid130 = fopen('SwarmBat_O_maxfitness.txt','a+');
fid140 = fopen('SwarmBat_O_minfitness.txt','a+');
fid150 = fopen('SwarmBat_O_meanfitness.txt','a+');
fid160 = fopen('SwarmBat_O_best_solutions.txt','a+');
%          fid19 = fopen('OUTPUT_best_coding_space.txt','w+');
%          fid20 = fopen('OUTPUT_now_generation.txt','w+');
%          fid21 = fopen('OUTPUT_now_probability_crossover.txt','w+');

% begin to load data from file

% read data from these files
disp('/*==================================================================================================*/')
disp('/*  Swarm Optimisation and Algorithm Laboratory Toolbox 1.0.0.1 */ ')
disp('');
disp('    30-Mar-2012 Chen Yi leo.chen.yi@live.co.uk Glasgow ')
disp('/*==================================================================================================*/')
disp('>>>>')
disp(' Begin to Evaluate...Waiting Please ...');

min_confines = fscanf( fid1 , '%f' ); min_confines = min_confines' ;

max_confines = fscanf( fid2 , '%f' ); max_confines = max_confines';
%
%       probability_crossover = fscanf( fid3 , '%f' ); probability_mutation = fscanf(fid4,'%f');
%
population = fscanf( fid5 , '%f' );
%
random_step = fscanf( fid6 , '%f' );
%
max_generation = fscanf( fid7 , '%f' );
%
%soundspeed = fscanf( fid3 , '%f' );
%
beta = fscanf( fid4 , '%f' ); % random distribution parameters
%
loudness_min = fscanf( fid8 , '%f' );
%
PErate_min = fscanf( fid9,'%f' );
%
alpha = fscanf(fid10,'%f');
%
gamma = fscanf(fid11,'%f');
%

%
%       now_probability_crossover = probability_crossover;
%
fHz = fscanf(fid20,'%f'); % Hz = [fmin, fmax] is the frequency range
% %

testnumber = fscanf(fid1000,'%f');

disp(' the total test number is');
disp(testnumber);

% Step into SGALAB()
%
eachtimeplot       = 0;
statisticalplot    = [1,1,1,1,1];
%statisticalplot(1) - plot MIN,MEAN,MAX or not, 0-NO, 1-YES
%statisticalplot(2) - plot mAP or not,          0-NO, 1-YES
%statisticalplot(3) - plot mSTD or not,         0-NO, 1-YES
%statisticalplot(4) - plot mmAP or not,         0-NO, 1-YES
%statisticalplot(5) - plot mmSTD or not,        0-NO, 1-YES

options = { ...
    fHz,                  % 1, Hz range
    random_step,          % 2, bat random walk step
    [],                   % 3, sound speed, 340m/s in default
    beta,                 % 4, distribution parameters
    eachtimeplot,         % 5, plot each test, 1 - plot each time, 0 - no plots
    statisticalplot,      % 6, statistical plots, 1 - yes ,  0 - no plots
    'Roulettewheel',       % 7, selection method
    loudness_min,         % 8, loudness min
    PErate_min,           % 9, Pulse Emission rate min
    alpha,                % 10, alpha for loudness
    gamma   };            % 11, gamma for pulse emission rate


SwarmBat_Procedure_h = timebar('SwarmsLAB::SwarmFish','Total Progress...');

for idx = 1 : 1 : testnumber
    % Output
    
    timebar( SwarmBat_Procedure_h , idx/testnumber );
    
    disp('Test NO.'); disp(idx);
    disp('');
    
    [   fitness_data ,...
        best_decimal_space ,...
        error_status ]= SwarmBat__entry_SO_std...
        ( options,...
        min_confines ,...
        max_confines ,...
        population ,...
        max_generation,...
        [testnumber,idx] );
    
    disp('');
    
    if ( error_status ~= 0 )  return ;  end
    
    %write data to output files
    
    %   OUTPUT_bestfitness.txt
    fprintf( fid120 , '%f\n', fitness_data(1));
    
    %   OUTPUT_maxfitness.txt
    fprintf( fid130 , '%f\n', fitness_data(2));
    
    %   OUTPUT_minfitness.txt
    fprintf( fid140,  '%f\n', fitness_data(3));
    
    %   OUTPUT_meanfitness.txt
    fprintf(  fid150,  '%f\n', fitness_data(4));
    
    %   OUTPUT_best_result_space.txt
    fprintf(  fid160,  '%f\n', best_decimal_space );
    
    % %   OUTPUT_best_coding_space
    % fprintf(  fid19 , '%f\n' , best_coding_space );
    
    % %   OUTPUT_now_generation.txt
    % fprintf(  fid20, '%f\n' , now_generation );
    %
    % %   OUTPUT_now_probability_crossover.txt
    % fprintf(  fid21, '%f\n' , now_probability_crossover );
    
end

%close files
close( SwarmBat_Procedure_h );
status = fclose( 'all' );

disp('End SwarmFish Evaluating');
disp('');

disp(' More detail result in text files with " Swarm_O_*.txt " ' )
disp('----------------------------------------------------------------------------------------')
result_files = list_current_dir_files ('SwarmBat_O_*.*')

disp('----------------------------------------------------------------------------------------')

% timer end
toc
% SwarmBat_demo_SO_std End