function [ fitness ] = SGA_FITNESS_function(x,y)
% function [ fitness ] = SGA_FITNESS_function(alpha,beta,gamma,zeta,delta,eta)


% /*M-FILE FUNCTION SGA_FITNESS_function MMM SGALAB */ %
% /*==================================================================================================
%  Simple Genetic Algorithm Laboratory Toolbox for Matlab 7.x
%
%  Copyright 2011 The SxLAB Family - Yi Chen - leo.chen.yi@gmail.com
% ====================================================================================================
%
%File description:
%
% [1]for both single objective and multi objective problems,
%
% [2]accept stand-alone variables and matrix variables, e.g.
%
% (1) stand-alone variables, fitness(x,y,z)
%
% (2) matrix variables,
% 
% fitness([x,y,z;x,y,z],[x,y,z;x,y,z],[x,y,z;x,y,z])
%
%Input:
%          User define-- in the format ( x1, x2, x3,... )
% 
%Output:
%          fitness--     is the fitness value
%
%Appendix comments:
%
% 02-Dec-2009   Chen Yi
% obsolete SGA__fitness_MO_evaluating.m
%          SGA_FITNESS_MO_function.m
% use      SGA__fitness_evaluating.m
%          SGA_FITNESS_function.m (for both single objective and multi
%                                  objective problems )
%
%Usage:
%     [ fitness ] = SGA_FITNESS_function( xi,... )
%===================================================================================================
%  See Also:
%
%===================================================================================================
%
%===================================================================================================
%Revision -
%Date        Name    Description of Change email                 Location
%27-Jun-2003 Chen Yi Initial version       chen_yi2000@sina.com  Chongqing
%14-Jan-2005 Chen Yi update 1003           chenyi2005@gmail.com  Shanghai
%02-Dec-2009 Chen Yi obsolete
%                     SGA__fitness_MO_evaluating.m
%                     SGA_FITNESS_MO_function.m, use
%                     SGA_FITNESS_function for both single and multi
%                     objective problems
%HISTORY$
%==================================================================================================*/


%SGA_FITNESS_function begin

% fitness = x*sin(10*pi*x)+2.0;


fitness = (sin(x)./(x+eps)).*(sin(y)./(y+eps));


% % % timer = [ 202.497
% % % 857.489
% % % 1493.48
% % % 1917.48
% % % 2553.47
% % % 2977.46
% % % 3077.46
% % % 3401.46
% % % 3825.45
% % % 4037.45
% % % 4249.45
% % % 4461.44
% % % 4673.44
% % % 5309.43
% % % 5733.43
% % % 6369.42
% % % 7217.41
% % % 7641.4
% % % 8277.4
% % % 10397.4
% % % 12729.3
% % % 15273.3
% % % 18453.3
% % % 21209.2
% % % 23329.2
% % % 25661.2
% % % 27993.2
% % % 30749.1
% % % 35625.1
% % % 39653
% % % 45376.9
% % % 49192.9
% % % 52796.8
% % % 55976.8
% % % 60852.7
% % % 65304.7
% % % 68908.6
% % % 73148.6
% % % 77176.5
% % % 82264.5
% % % 86716.4
% % % 92652.3
% % % 100920
% % % 107492
% % % 112156
% % % 114064
% % % 114912
% % % 115760
% % % 116184
% % % 116820
% % % 117032
% % % 117456
% % % 117680
% % % 117880
% % % 118092
% % % 118492
% % % 118528
% % % 118798
% % % 118828
% % % 118830
% % % 118840
% % % 118850
% % % 118860
% % % 118870
% % % 118940
% % % 119576
% % % 120000 ]';
% % % % 
% % % % timer =  timer - mean(timer);
% % % % 
% % % % [ timer_normalised ] = SGA__FLC_normalisation( timer, [min(timer),max(timer)], [-5,5] );
% % % % 
% % % % % timer_shift =  timer - mean(timer);
% % % 
% % % CMOS4007_failurerate = [ 2200.01
% % % 2169.41
% % % 2121.37
% % % 2060.25
% % % 2003.48
% % % 1859.42
% % % 1859.42
% % % 1645.51
% % % 1536.37
% % % 1418.5
% % % 1222.07
% % % 1095.47
% % % 833.56
% % % 715.68
% % % 597.808
% % % 471.197
% % % 340.214
% % % 213.611
% % % 100.096
% % % 43.2729
% % % 30.0928
% % % 51.8257
% % % 64.8052
% % % 64.705
% % % 73.358
% % % 73.2732
% % % 81.9185
% % % 90.5484
% % % 90.371
% % % 85.8594
% % % 94.3813
% % % 85.5124
% % % 81.0162
% % % 67.8053
% % % 58.8977
% % % 41.2755
% % % 14.9539
% % % 10.4345
% % % 10.288
% % % 5.73784
% % % 5.57589
% % % 5.35995
% % % 5.05917
% % % 4.8201
% % % 39.5711
% % % 104.978
% % % 192.249
% % % 340.63
% % % 423.552
% % % 532.655
% % % 694.156
% % % 794.537
% % % 886.188
% % % 986.188
% % % 1083.01
% % % 1183.01
% % % 1223.06
% % % 1323.06
% % % 1423.06
% % % 1528.06
% % % 1645.06
% % % 1774.06
% % % 1872.06
% % % 1913.06
% % % 2064.72
% % % 2239.3
% % % 2413.89 ]';
% % % 
% % % 
% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % timer_shift                =  timer - mean(timer);
% % % xlowernorm                 = -5;
% % % xuppernom                  =  5;
% % % [ timer_shift_normalised ] = SGA__FLC_normalisation( timer_shift, [min(timer_shift),max(timer_shift)], [xlowernorm,xuppernom] );
% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % 
% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % timer_shift                =  CMOS_database.CMOS4007.timer - mean(CMOS_database.CMOS4007.timer);
% % % ylowernorm                 =  0;
% % % yuppernom                  =  10;
% % % yupperlimit = max(CMOS4007_failurerate);
% % % ylowerlimit = min(CMOS4007_failurerate);
% % % [ CMOS4007_failurerate_normalised ] = SGA__FLC_normalisation(CMOS4007_failurerate,...
% % %     [ylowerlimit,yupperlimit], [ylowernorm,yuppernom] );
% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % 
% % % 
% % % % upperlimit = max(CMOS4007_failurerate);
% % % % lowerlimit = min(CMOS4007_failurerate);
% % % % 
% % % % [ CMOS4007_failurerate_norm ] = SGA__FLC_normalisation( CMOS4007_failurerate,...
% % % %                                      [lowerlimit,upperlimit],...
% % % %                                      [0,10] );
% % % %                                  
% % % % alpha = params(1);
% % % % beta  = params(2);
% % % % gamma = params(3);
% % % % zeta  = params(4);
% % % % delta = params(5);
% % % % eta   = params(6);
% % % params = [alpha,beta,gamma,zeta,delta,eta];
% % % 
% % % [ CMOS4007_fish ] = SGA__FLC_MF_bathtub(timer_shift_normalised,params);
% % % 
% % % [fitness] = SECF__assess_R2( CMOS4007_failurerate_normalised, CMOS4007_fish );