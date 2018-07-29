function dv=createdatevec(rdate,p,indic)

% This function creates a monthly date vector that starts or ends at the
% date that is fed into the function. Required date format for this 
% function: 'mmmyyyy'. 
%
% Author: Marco Buchmann, ECB / Frankfurt University
% Date: March 2010
%
% The function requires as input:
% -- a string 'rdate'; required format 'mmmyyyy'
% -- a scalar 'periods'
% -- an indicator that should say 'forward' or 'backward' (string format)
%
% Output:
% -- a px1 cell array 'dv' that holds the dates

% Check input
if nargin<3
    error('Not enough input arguments')
end

dv=cell(p,1);                               % pre-allocate space for date vector
tmp_vec=datevec(datenum(rdate,'mmmyyyy'));  % reference date in vector format
ty=tmp_vec(1,1); tm=tmp_vec(1,2);           % reference year and month

% Check whether months are identified correctly; otherwise correct
if strcmp(rdate(1:3),'Jan')==1 || strcmp(rdate(1:3),'jan')==1 && tm~=1
    tm=1;
end
if strcmp(rdate(1:3),'Feb')==1 || strcmp(rdate(1:3),'feb')==1 && tm~=2
    tm=2;
end
if strcmp(rdate(1:3),'Mar')==1 || strcmp(rdate(1:3),'mar')==1 && tm~=3
    tm=3;
end
if strcmp(rdate(1:3),'Apr')==1 || strcmp(rdate(1:3),'apr')==1 && tm~=4
    tm=4;
end
if strcmp(rdate(1:3),'May')==1 || strcmp(rdate(1:3),'may')==1 && tm~=5
    tm=5;
end
if strcmp(rdate(1:3),'Jun')==1 || strcmp(rdate(1:3),'jun')==1 && tm~=6
    tm=6;
end
if strcmp(rdate(1:3),'Jul')==1 || strcmp(rdate(1:3),'jul')==1 && tm~=7
    tm=7;
end
if strcmp(rdate(1:3),'Aug')==1 || strcmp(rdate(1:3),'aug')==1 && tm~=8
    tm=8;
end
if strcmp(rdate(1:3),'Sep')==1 || strcmp(rdate(1:3),'sep')==1 && tm~=9
    tm=9;
end
if strcmp(rdate(1:3),'Oct')==1 || strcmp(rdate(1:3),'oct')==1 && tm~=10
    tm=10;
end
if strcmp(rdate(1:3),'Nov')==1 || strcmp(rdate(1:3),'nov')==1 && tm~=11
    tm=11;
end
if strcmp(rdate(1:3),'Dec')==1 || strcmp(rdate(1:3),'dec')==1 && tm~=12
    tm=12;
end

if strcmp(indic,'forward')==1
    dv(1,1)={rdate};
    for t=2:p
        tm=tm+1;
        if tm==13
            tm=1; ty=ty+1;
        end
        dv(t,1)={datestr([ty tm 1 0 0 0],'mmmyyyy')};
    end
elseif strcmp(indic,'backward')==1
    dv(end,1)={rdate};
    for t=2:p
        tm=tm-1;
        if tm==0
            tm=12; ty=ty-1;
        end
        dv(p-t+1,1)={datestr([ty tm 1 0 0 0],'mmmyyyy')};
    end
else
    error('Indicator must say ''forward'' or ''backward''')
end