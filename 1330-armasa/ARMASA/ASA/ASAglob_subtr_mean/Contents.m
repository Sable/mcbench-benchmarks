%ASAGLOB_SUBTR_MEAN Subtraction of signal mean
%   Declaring the variable ASAGLOB_SUBTR_MEAN in the base workspace, for 
%   example by typing at the command prompt,
%     ASAglob_subtr_mean = 0;
%   will enable the ARMASA functions, ARMASEL, SIG2AR, SIG2MA and SIG2ARMA 
%   to read out the value of ASAGLOB_SUBTR_MEAN. A value 0 will prevent 
%   that these functions subtract the mean from the input data SIG, which 
%   is ordinarily done by default and when ASAGLOB_SUBTR_MEAN = 1.
%   
%   Preventing the subtraction of the mean is advised when it is known a 
%   priori, that the process that generated the series of input data is 
%   characterized by mean 0, like in simulation experiments. When it is 
%   known that the mean has already been subtracted from the data by some 
%   other process, one should also declare the variable ASAGLOB_MEAN_ADJ 
%   and assign a value 1 to this variable.
%   
%   See also: ASAGLOB_MEAN_ADJ

disp('  Variable ASAGLOB_SUBTR_MEAN is currently undefined.')
disp('  Type ''help ASAglob_subtr_mean'' for more information.')