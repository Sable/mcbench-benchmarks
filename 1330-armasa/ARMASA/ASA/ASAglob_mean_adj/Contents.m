%ASAGLOB_MEAN_ADJ Subtraction of the signal mean identifier
%   Declaring the variable ASAGLOB_MEAN_ADJ in the base workspace, for 
%   example by typing at the command prompt,
%     ASAglob_mean_adj = 1;
%   will enable the ARMASA functions, ARMASEL, SIG2AR, SIG2MA and 
%   SIG2ARMA to read out the value of ASAGLOB_MEAN_ADJ. A value 1 will 
%   inform these functions, that the input data SIG have been level 
%   adjusted using the mean of SIG. This will have a small effect on the 
%   estimation of the Prediction Error, that is determined in these 
%   functions.
%   
%   By default the functions subtract the mean from the input data SIG 
%   and ASAGLOB_MEAN_ADJ is automatically assigned. If one choses to 
%   subtract the mean beforehand, or when it is known that the mean has 
%   already been subtracted by some other proces, assign 1 to 
%   ASAGLOB_MEAN_ADJ. To control the subtraction of the mean itself, use 
%   ASAGLOB_SUBTR_MEAN. ASAGLOB_SUBTR_MEAN will NOT be effected by any 
%   choice of ASAGLOB_MEAN_ADJ.
%   
%   See also: ASAGLOB_SUBTR_MEAN

disp('  Variable ASAGLOB_MEAN_ADJ is currently undefined.')
disp('  Type ''help ASAglob_mean_adj'' for more information.')