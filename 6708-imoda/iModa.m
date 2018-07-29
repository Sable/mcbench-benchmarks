function [Moda , ncont] = iModa(x)

% A matlab script to find the mode of vector x. 
% There are two options at the end so that it is possible to perform a checksum
% on data and plot the vector of frequencies, just uncomment the right lines!
%
% Isaac M. M. INOGS, Trieste(Italy). January 10, 2005 @01h46:44
% Developed under Matlab(TM) version 7.0.0.19901 (R14)
% Modified on January 13, 2005 @14h49:50
% in order to include suggestion from Jos jnvdg@arcor.de (thanks, Jos)
% and add some robustness regarding NANs (Not-A-Number)

x = x(:);
Xvalue = unique(x(~isnan(x)));             % find elements in x with no repetitions (sorted output)

Xvalue = Xvalue(:);        % elements in vector
Xcont = histc(x,Xvalue);
Xcont = Xcont(:);          % frequency of each element

[maxCont imaxCont] = max(Xcont);  
ncont = maxCont;                     % frequency of mode
Moda = Xvalue(imaxCont);             % the mode

%%%%%% optional 1 - plot of frequencies for each element

 plot(Xvalue,Xcont);  
 xlabel('values')
 ylabel('frequencies')
 
%%%%%% optional 2 - checksum

% disp(strcat('sum of frequencies :',num2str(sum(Xcont))));
% disp(strcat('lenght of vector :',num2str(length(x))));
% disp(strcat('Nans, if any :',num2str(sum(isnan(x)))));
% chcksm = (sum(Xcont)+sum(isnan(x))) == length(x);
% disp(chcksm)