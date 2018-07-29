% Author: Julio Zaragoza
% The University of Adelaide, Adelaide, South Australia
    
% Example: using the CACC function for discretizing continuos data.
%
% Note that such data appeared in the paper: 
%  'A Discretization Algorithm based on Class-Attribute Contingency Coefficient' (CACC), 
%  by Sheng-Jung Tsai, Shien-I Lee and Wei-Pang Yang, Information Sciences, Elsevier, 2008
%  and my results are the same as those reported in the paper.

contdata = [3,1;    % here 1 (in the second column) stands for class 'Care'
            5,1;    % 2 stands for class 'Edu' and 3 stands for class 'Work'.
            6,1;    
            15,2;
            17,2;
            21,2;
            35,3;
            45,3;
            46,3;
            51,2;
            56,2;
            57,2;
            66,1;
            70,1;
            71,1];
[ discdata,discvalues,discscheme ] = cacc(contdata)