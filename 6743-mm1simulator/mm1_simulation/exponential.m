%function exponential is being called by the 
%main function mm1 and takes as an argument the mean service
%time or the mean arrival time of the system and returns
%a value which is produced by the exprnd() function of Matlab
%exprnd() provides us with random numbers which follow exponential distribution



function e=exponential(mean)
e=exprnd(mean);

