%ASAGLOB_AR_COND ARMA/MA to AR order selection conditioning
%   Declaring the variable ASAGLOB_AR_COND in the base workspace, for 
%   example by typing at the command prompt,
%     ASAglob_ar_cond = 1;
%   will enable the ARMASA function ARMASEL to read out the value of 
%   ASAGLOB_AR_COND. ASAGLOB_AR_COND controls whether the MA and ARMA 
%   estimation routines, used in ARMASEL, will condition the selection of 
%   AR orders to the order that has been previously selected by SIG2AR. 
%   More specifically, by choosing a confined set of candidate AR orders 
%   and assigning ASAGLOB_AR_COND = 1, orders of internally used AR models 
%   in MA and ARMA estimation will be determined on the basis of the 
%   specific selection of an AR model order from that confined set. By 
%   leaving ASAGLOB_AR_COND unspecified or assigning ASAGLOB_AR_COND = 0, 
%   a standard AR order selection procedure is repeated if necessary, to 
%   supply the MA and ARMA estimators with that order.

disp('  Variable ASAGLOB_AR_COND is currently undefined.')
disp('  Type ''help ASAglob_ar_cond'' for more information.')