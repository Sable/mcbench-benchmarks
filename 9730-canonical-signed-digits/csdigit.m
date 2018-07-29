function [digits,pos,neg,err]=csdigit(num,range,resolution)
% Returns the canonical signed digit representation of the input number.
% Useful for simple DSP implementations of multipliers.
%    [digits,pos,neg,err]=csdigit(num,range,resolution)
%
% example csdigit(23) returns +0-00-.
%         Where +0-00-. is a representation of +1 in 2^5, -1 in 2^3 and -1 in 2^0 positions.
%         i.e. 23 = 32 - 8 -1
%
% example [a,p,n]=csdigit(23.5,6,2) returns
%            a = +0-000.-0
%            p=32
%            n=8.5
%            23.5 = 32 - 8 -.5
%
% num           = input number (decimal)
% range         = maximum digits to the left of the decimal point
% resolution    = digits to the right of decimal point
% for example
%    csdigit(.25,2,2) represents xx.xx binary
%    csdigit(.25,0,4) represents .xxxx binary
% Note: An error is generated if num does not fit inside the representation.
%       is truncated to the specified resolution.
% Note: A warning message is generated if num doesn't fit in the precision
%       specified. The returned value is truncated.
% Note: The range is not used except for a check for overflow and to add
%       leading zeros.
%
% Patrick J. Moran
% AirSprite Technologies Inc.

% Copyright 2006, Patrick J. Moran for AirSprite Technologies Inc.
% Redistribution and use in source and binary forms, with or without modification, 
% are permitted provided that the following conditions are met:
% 
%    1. Redistributions of source code must retain the above copyright notice.
%    2. Any derivative of this work must credit the author, and must be made available to everyone.
%    3. The name of the author may not be used to endorse or promote products derived 
%       from this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, 
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
% PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, 
% INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
% LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
% OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY 
% WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
if nargin<1
    help csdigit;
    return
end
if nargin<2
    range=ceil(log(abs(num))/log(2))+1;
end
if nargin<3
    resolution=0;
end
targetNum=num;
num=abs(num)/(2^(-resolution));
if num~=floor(num)
    if floor(num)==0
        error('Insufficient precision to represent this number!')
    else
        warning('Some precision has been lost. Returned value is truncated!')
    end
end
num=floor(num);
if num>(2^(range+resolution))
    error('Input number is too large for the requested bit representation.');
end
binNum=dec2bin(num,range+resolution);
digits=('0'+0)*ones(size(binNum));
%allZeros=allZeros;
onesLoc=findstr(binNum,'1');
if ~isempty(onesLoc)
    onesRun=find(diff(onesLoc)==1);
    while ~isempty(onesRun)
        onesPointer=find(diff(onesLoc)==1)+1;
        addIn=onesLoc(onesPointer(end));
        adder=('0'+0)*ones(size(binNum));
        adder(addIn)=('1'+0);
        %keep track of the additional digits
        digits(addIn)=('-'+0);
        binAdder=char(adder);
        binNum=dec2bin(bin2dec(binNum)+bin2dec(binAdder),range+resolution);
        onesLoc=findstr(binNum,'1');
        onesRun=find(diff(onesLoc)==1);
        if length(binNum)>length(digits)
            digits=['0'+0,digits]; % add any additional leading zero
        end
    end
end
pos=bin2dec(binNum)*2^(-resolution);
negLoc=find(digits==('-'+0));
neg=('0'+0)*ones(size(binNum));
neg(negLoc)='1'+0;
neg=bin2dec(char(neg))*2^(-resolution);
digits(onesLoc)='+'+0;
if (length(digits)-resolution)>range
    warning('Number overflowed for this CSD representation')
end
if length(digits)<resolution
    digits=[digits,('0'+0)*ones(1,resolution-length(digits))];
end
digits=char([digits(1:length(digits)-resolution),'.'+0,digits(length(digits)-resolution+1:end)]);
if targetNum<0 % flip representation if negative
    ntemp=neg;
    neg=pos;
    pos=ntemp;
    digits=strrep(digits,'+','p');
    digits=strrep(digits,'-','+');
    digits=strrep(digits,'p','-');
end
%digits=char(digits);
err=targetNum-(pos-neg);
