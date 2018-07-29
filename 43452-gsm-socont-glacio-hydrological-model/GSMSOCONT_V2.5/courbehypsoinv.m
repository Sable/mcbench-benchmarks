function [altmoy,altlimit]=courbehypsoinv(data,noband)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is part of the hydrological model GSM-SOCONT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB code written by Bettina Schaefli
% Ecole Polytechnique Fédérale de Lausanne,Switzerland
% E-mail: bettina.schaefli@epfl.ch
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function computes the mean altitude of n elevation bands
% if the hypsometric curve is given;
% Input:
%   data: the hypsometric curve
%   noband: number of elevation bands
%
% This works for a hypsometric data set with the format
% col 1: percentage of area that lies above the altitude in the 2nd colonne
% col 2: altitude 
% first line has to contain 100% and the minimum altitude always exceeded
% e.g.
%100    1100            altitude always exceeded     
% 99    1125
% 98    1150
% 97    1175
% 96    1150
% .     .
% .     .
%  0    3789            altitude never exceeded

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%vector with half-surface
halfint=[100-100/noband/2:-100/noband:0+100/noband/2];

interval=[100:-100/noband:0];

altmoy=zeros(length(halfint),1);
altlimit=zeros(length(interval),1);

for i=1:length(halfint)
    a=0;
    for j=1:size(data,1)
        if data(j,1)>=halfint(i)
            a=a+1;
        end
    end
    % linear interpolation between closest points
    increm=(halfint(i)-data(a,1))/(data(a+1,1)-data(a,1));
    altmoy(i)=(increm*(data(a+1,2)-data(a,2))+data(a,2));
end


altlimit(1,1)=data(1,2);
altlimit(length(altlimit),1)=data(size(data,1),2);

for i=2:length(altlimit)-1
    a=0;
    for j=1:length(data)
        if data(j,1)>=interval(i)
            a=a+1;
        end
    end
    % linear interpolation between closest points
    increm=(interval(i)-data(a,1))/(data(a+1,1)-data(a,1));
    altlimit(i)=(increm*(data(a+1,2)-data(a,2))+data(a,2));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is part of the hydrological model GSM-SOCONT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Citation:
%   Schaefli, B., Hingray, B., Niggli, M. and Musy, A., 2005. 
%       A conceptual glacio-hydrological model for high mountainous catchments.     
%       Hydrology and Earth System Sciences, 9: 95 - 109.                                                                                             
%       http://www.hydrol-earth-syst-sci.net/9/95/2005/hess-9-95-2005.pdf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright and Disclaimer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Developed at EPFL, 2003-2005, version V2.4, Jan. 2011
% Copyright, 2013, EPFL, www.epfl.ch

% Neither the authors nor EPFL make any warranty, express or implied or
% assume any liability for the use of this Matlab code. Redistribution of 
% this source code, with or without modification is permitted provided
% that the copyright notice and the disclaimer are included.  
% If the software is modified to produce derivative works, such modified 
% software should be clearly marked, so as not to confuse it with the 
% current version.
%                                                                                               
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB code written by Bettina Schaefli
% Ecole Polytechnique Fédérale de Lausanne,Switzerland
% E-mail: bettina.schaefli@a3.epfl.ch
% PLEASE REPORT ERRORS TO bettina.schaefli@a3.epfl.ch
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
