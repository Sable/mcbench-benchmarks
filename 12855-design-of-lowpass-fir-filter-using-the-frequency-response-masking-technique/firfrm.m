%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIR filter design using Frequency Response Masking Technique
% -------------------------------------------------
% Copyright (c) 2006 ChinSoon Lim
%
% This library is free software; you can redistribute it and/or
% modify it under the terms of the GNU Library General Public
% License as published by the Free Software Foundation; either
% version 2 of the License, or (at your option) any later version.
%
% This library is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% Library General Public License http://www.gnu.org/licenses/gpl.txt 
% for more details.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION:
% ============
% FIR digital filter is designed using the frequency response masking 
% technique [1,2] resulting in significant savings in number of multipliers 
% used to implement the FIR filter. Savings is exceptional when the normalized 
% transistion width is less than 1/16. The resulting structure of the filter 
% can be found in [1].
%
% If any errors are found, please let me know. I have not tested it exhaustively. 
%
%  ChinSoon
%
% USAGE:    
% ============                                                           
% [Fa Fma Fmc] = firfrm(pb,sb,pbRip,sbRip,fs);         
% Inputs:                                                   
% pb - passband of the desired FIR filter in the same units as fs
% sb - stopband of the desired FIR filter in the same units as fs
% pbRip - maximum allowable passband ripple in linear magnitude
% sbRip - maximum allowable stopband ripple in linear magnitude 
% fs - sampling frequency in Hz, kHz, MHz, etc.                     
%                                                                        
% Outputs: 
% Fa - contains the filter taps for the interpolated filter 
% Fma - contains the filter taps for the masking filter for interpolated filter
% Fmc - contains the filter taps for the masking filter for complementary 
%           interpolated filter                                                 
%                                        
% EXAMPLE CALL:                                                         
% ============    
% [Fa Fma Fmc] = firfrm(2800,2850,0.01,0.01,10000); 
%    
% REFERENCES:    
% ============    
% [1] Y. C. Lim, "Frequency-response masking approach for the synthesis of 
%     sharp linear phase digital filters," IEEE Trans. Circuits Syst., vol. 
%     CAS-33, pp. 357-364, Apr. 1986. 
% [2] Y. C. Lim and Y. Lian, "The optimum design of One- and Two-Dimensional 
%     FIR filters using the frequency response masking technique," IEEE 
%     Trans. Circuits Syst.,vol. 40, No. 2,Feb 93.
%
% NOTES: 
% ============ 
% 1. This function only designs lowpass filter. To implement highpass
% filter, please find the equivalent lowpass filter by shifting the
% magnitude response left or right by 0.5. Design this new lowpass filter
% then phase shift the final filter output.
%
% Author: ChinSoon Lim (chinsoon12@gmail.com) 
% Version 1: 2 Nov 2006
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function [Fa, Fma, Fmc] = firfrm(pb,sb,pbRip,sbRip,fs)

if nargin ~= 5
    error('usage: firfrm(passband,stopband,passbandRipple,stopbandRipple,sampling_frequency)');
end;

if (pb >= sb)
    error('This function only designs lowpass filter.');
end

%Initialization
stopband = sb/fs;
passband = pb/fs;
passbandRipple = pbRip;
stopbandRipple = sbRip;
transistionWidth = abs(stopband - passband);
if (transistionWidth > 1/16)
    error('No significant savings from using Frequency Response Masking');
end
estOptInt = ceil(1/2/sqrt(transistionWidth));
intFactors = [estOptInt-2 estOptInt-1 estOptInt estOptInt+1 estOptInt+2];

%Get true optimum interpolation factor, Mopt and Update subfilters
%specifications
[optInt, integer_m, pbFa, sbFa, newLenFa pbFma, sbFma, newLenFma, pbFmc, sbFmc, newLenFmc] = GetTrueOptM_UpdateFilters(intFactors,passband,stopband,passbandRipple,stopbandRipple);

%--------------------------
%initialization before loop
success = false;
alternate = 0;
iteration = 0;
lenFa = [];lenFma = [];lenFmc = [];

%masking filters dont care bands
[dunCareFma dunCareFmc] = GetDontCareBands(optInt, integer_m, pbFa, sbFa, pbFma, sbFma, pbFmc, sbFmc);
%bandsFma for input to firpmord function
bandsFma = [];
tmpBandsFma = [dunCareFma; [pbFma sbFma]];
tmpBandsFma = sortrows(tmpBandsFma,1);
for n = 1:length(tmpBandsFma(:,1))
    bandsFma = [bandsFma tmpBandsFma(n,:)];
end

%bandsFmc for input to firpmord function
bandsFmc = [];
tmpBandsFmc = [dunCareFmc; [pbFmc sbFmc]];
tmpBandsFmc = sortrows(tmpBandsFmc,1);
for n = 1:length(tmpBandsFmc(:,1))
    bandsFmc = [bandsFmc tmpBandsFmc(n,:)];
end

%amplitudes Fma for input to firpmord function
cond = bandsFma <= pbFma;
numOnes = ceil(sum(cond)/2);
numZeros = (length(bandsFma)+2)/2 - numOnes;
ampFma = [ones(1,numOnes) zeros(1,numZeros)];

%amplitudes Fmc for input to firpmord function
cond = bandsFmc <= pbFmc;
numOnes = ceil(sum(cond)/2);
numZeros = (length(bandsFmc)+2)/2 - numOnes;
ampFmc = [ones(1,numOnes) zeros(1,numZeros)];

%Ripples
passbandRippleFa = 0.85*passbandRipple;
stopbandRippleFa = 0.85*stopbandRipple;
passbandRippleFma = 0.85*passbandRipple;
stopbandRippleFma = 0.85*stopbandRipple;
passbandRippleFmc = 0.85*passbandRipple;
stopbandRippleFmc = 0.85*stopbandRipple;
%devFma and devFmc for input to firpmord function
devFma = passbandRippleFma*ampFma + stopbandRippleFma*not(ampFma);
devFmc = passbandRippleFmc*ampFmc + stopbandRippleFmc*not(ampFmc);
%--------------------------

%create overall filter and test if it pass the requirement
while (success == false)
    %bandedge shaping filter
    [orderFa,f,a,w] = firpmord([pbFa sbFa],[1 0],[passbandRippleFa stopbandRippleFa],1);
    
    %(La-1)M must be even to avoid half sampl delay
    if (mod(optInt*(newLenFa-1),2) ~= 0)
        newLenFa = newLenFa + 1;
    end
    
    Fa = firpm(newLenFa-1,f,a,w); 
    FIR_typeFa = GetFIRType(Fa);
    
    %masking filter for interpolated filter
    %[orderFma,fma,ama,wma] = firpmord([pbFma sbFma],[1 0],[passbandRippleFma stopbandRippleFma],1);
    [orderFma,fma,ama,wma] = firpmord(bandsFma,ampFma,devFma,1);    %take into account dun care bands
    
    %masking filter for complementary interpolated filter
    %[orderFmc,fmc,amc,wmc] = firpmord([pbFmc sbFmc],[1 0],[passbandRippleFmc stopbandRippleFmc],1);
    [orderFmc,fmc,amc,wmc] = firpmord(bandsFmc,ampFmc,devFmc,1);    %take into account dun care bands
    
    %both masking filters must be odd or even to ensure that outputs are in phase
    if (mod(newLenFma,2) ~= mod(newLenFmc,2))
        if (newLenFma < newLenFmc)
            newLenFma = newLenFma + 1;
        else
            newLenFmc = newLenFmc + 1;
        end
    end

    %design masking filters
    Fma = firpm(newLenFma-1,fma,ama,wma);
    FIR_typeFma = GetFIRType(Fma);
    Fmc = firpm(newLenFmc-1,fmc,amc,wmc);  
    FIR_typeFmc = GetFIRType(Fmc);
    
    %pad shorter filter to ensure that outputs are in phase
    if (newLenFma < newLenFmc)
        Fma = PadWithZero(Fma,newLenFmc);
        newLenFma = newLenFmc;
    else
        Fmc = PadWithZero(Fmc,newLenFma);
        newLenFmc = newLenFma;
    end

    coeffFa = GetCoefficients(Fa,FIR_typeFa);
    coeffFma = GetCoefficients(Fma,FIR_typeFma);
    coeffFmc = GetCoefficients(Fmc,FIR_typeFmc);
    
    condition = TestFinalFilter(optInt,passband,stopband,passbandRipple,stopbandRipple,coeffFa,newLenFa,FIR_typeFa,coeffFma,newLenFma,FIR_typeFma,coeffFmc,newLenFmc,FIR_typeFmc);
    if (condition == false)
        %adjust deviation
        if(alternate == 0)
            newLenFa = newLenFa + 1;
            [passbandRippleFa stopbandRippleFa] = KasierDevEst(newLenFa,abs(sbFa-pbFa),passbandRippleFa/stopbandRippleFa);
            alternate = alternate + 1;
        elseif (alternate == 1)
            newLenFma = newLenFma + 1;
	    [passbandRippleFma stopbandRippleFma] = KasierDevEst(newLenFma,abs(sbFma-pbFma),passbandRippleFma/stopbandRippleFma);
	    devFma = passbandRippleFma*ampFma + stopbandRippleFma*not(ampFma);
%            alternate = alternate + 1;
%	 elseif (alternate == 2)
            newLenFmc = newLenFmc + 1;
            [passbandRippleFmc stopbandRippleFmc] = KasierDevEst(newLenFmc,abs(sbFmc-pbFmc),passbandRippleFmc/stopbandRippleFmc);
            devFmc = passbandRippleFmc*ampFmc + stopbandRippleFmc*not(ampFmc);
            alternate = 0;
        end
        success = false;
    else
        success = true;
    end

    iteration = iteration + 1; %number of iterations
    if (iteration > 100)
        error('Exceed max num of iterations');
    end 
    lenFa = [lenFa newLenFa];
    lenFma = [lenFma newLenFma];
    lenFmc = [lenFmc newLenFmc];
end     %end while

end %end frm

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function [newPbRip newSbRip] = KasierDevEst(len,width,originalRatio)
deltaSq = (   10^(  ((len-1)*14.6*width+13) / -20  )   )^2;
newPbRip = sqrt(deltaSq*originalRatio);
newSbRip = deltaSq / newPbRip;
end %KasierDevEst
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function condition = TestFinalFilter(optInt,passband,stopband,passbandRipple,stopbandRipple,coeffFa,lenFa,FIR_typeFa,coeffFma,lenFma,FIR_typeFma,coeffFmc,lenFmc,FIR_typeFmc)
    %test passband requirement
    x = 0:0.001:passband;
    x = fliplr(x);
    omega = 2*pi*x;
    yInt = FilterOutput(coeffFa,lenFa,optInt*omega,FIR_typeFa);
    yCom = 1 - yInt;
    yma = FilterOutput(coeffFma,lenFma,omega,FIR_typeFma);
    ymc = FilterOutput(coeffFmc,lenFmc,omega,FIR_typeFmc);
    yPb = yInt.*yma + yCom.*ymc;
    cond = yPb >= 1+passbandRipple;
    if (sum(cond) > 0)
        condition = false;
        return;
    end
    cond = yPb <= 1-passbandRipple;
    if (sum(cond) > 0)
        condition = false;
        return;
    end
    
    %test stopband requirement
    x = stopband:0.001:0.5;
    omega = 2*pi*x;
    yInt = FilterOutput(coeffFa,lenFa,optInt*omega,FIR_typeFa);
    yCom = 1 - yInt;
    yma = FilterOutput(coeffFma,lenFma,omega,FIR_typeFma);
    ymc = FilterOutput(coeffFmc,lenFmc,omega,FIR_typeFmc);
    ySb = yInt.*yma + yCom.*ymc;
    cond = ySb <= -stopbandRipple;
    if (sum(cond) > 0)
        condition = false;
        return;
    end
    cond = ySb >= stopbandRipple;
    if (sum(cond) > 0)
        condition = false;
        return;
    end
    
    x = 0:0.001:0.5;
    omega = 2*pi*x;
    yInt = FilterOutput(coeffFa,lenFa,optInt*omega,FIR_typeFa);
    yCom = 1 - yInt;
    yma = FilterOutput(coeffFma,lenFma,omega,FIR_typeFma);
    ymc = FilterOutput(coeffFmc,lenFmc,omega,FIR_typeFmc);
    y = yInt.*yma + yCom.*ymc;
    plot(x,y,'LineWidth',0.5);
    xlabel('Normalized frequency');
    ylabel('Linear magnitude');
    title(['Magnitude response of overall filter designed using Frequency Response Masking']);
    
    figure
    x = 0:0.001:passband;
    plot(x,yPb);
    hold on;
    plot(x,1-passbandRipple,'r');
    plot(x,1+passbandRipple,'r');
    plot(passband,1-passbandRipple:0.0001:1+passbandRipple,'k');
    xlabel('Normalized frequency');
    ylabel('Linear magnitude');
    title(['Zooming into passband']);
    hold off;
    
    figure
    x = stopband:0.001:0.5;
    plot(x,ySb);
    hold on;
    plot(stopband:0.001:0.5,-stopbandRipple,'r');
    plot(stopband:0.001:0.5,stopbandRipple,'r');
    plot(stopband,-stopbandRipple:0.0001:stopbandRipple,'k');
    xlabel('Normalized frequency');
    ylabel('Linear magnitude');
    title(['Zooming into stopband']);
    hold off;
    
    condition = true;
end %TestFinalFilter
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function output = FilterOutput(coeff,L,omega,FIRType)
output = 0;
switch(FIRType)
    case 1
        n = 0:(L-1)/2;
        output = coeff*cos(n'*omega);
    case 2
        n = 1:L/2;
        output = coeff*cos((n-0.5*ones(1,length(n)))'*omega);
    case 3
        n = 1:(L-1)/2;
        output = coeff*sin(n'*omega);
    case 4
        n = 1:L/2;
        output = coeff*sin((n-0.5*ones(1,length(n)))'*omega);      
end %switch
end %FilterOutput
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function coeff = GetCoefficients(H,FIRType)
switch(FIRType)
    case 1
        coeff = H((length(H)-1)/2 + 1);
        coeff = [coeff 2*fliplr(H(1:(length(H)-1)/2))];
    case 2
        coeff = 2*fliplr(H(1:length(H)/2));
    case 3
        coeff = 2*fliplr(H(1:(length(H)-1)/2));
        error('FIR type 3 is impossible because LPF is being implemented.');
    case 4
        coeff = 2*fliplr(H(1:length(H)/2));
        error('FIR type 4 is impossible because LPF is being implemented.');
    otherwise
        coeff = 0;
end %switch
end %end GetCoefficients
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function newH = PadWithZero(H,newLen)
tmp = zeros(1,(newLen-length(H))/2);
newH = [tmp H tmp];
end %end PadWithZero
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function FIRType = GetFIRType(H)
FIRType = 1;        %start with type 1: sym impulse response, even length

if (H(1) == H(length(H)))       %symmetrical impulse response
    if (mod(length(H),2) == 0)  %length is even
        FIRType = FIRType + 1;
    end
else                            %antisymmetrical
    FIRType = FIRType + 2;
    if (mod(length(H),2) == 0)  %length is even
        FIRType = FIRType + 1;
    end
end
end     %end FIRType
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function [dunCareFma dunCareFmc] = GetDontCareBands(M, m, pbFa, sbFa, pbFma, sbFma, pbFmc, sbFmc)
dunCareFma = [];
dunCareFmc = [];

%determine frequency range I and II
freqRangeI = min([pbFma sbFmc]);
freqRangeII = max([sbFma sbFmc]);

%possible don't care for bands for Fmc
centreOf1 = 0:1/M:(m+2)/M;	%create larger range so as not to miss any dont care band
bandedgesOfToothWhen1 = [centreOf1' centreOf1'];
bandedgesOfToothWhen1(:,1) = bandedgesOfToothWhen1(:,1) - pbFa/M*ones(length(centreOf1),1); 
bandedgesOfToothWhen1(:,2) = bandedgesOfToothWhen1(:,2) + pbFa/M*ones(length(centreOf1),1); 
bandedgesOfToothWhen1 = Set_Trim(bandedgesOfToothWhen1);

%possible don't care for bands for Fma
centreOf0 = 1/M:1/M:(m+2)/M;	%create larger range so as not to miss any dont care band
bandedgesOfToothWhen0 = [centreOf0'-1/M*ones(length(centreOf0),1) centreOf0'];
bandedgesOfToothWhen0(:,1) = bandedgesOfToothWhen0(:,1) + sbFa/M*ones(length(centreOf0),1); 
bandedgesOfToothWhen0(:,2) = bandedgesOfToothWhen0(:,2) - sbFa/M*ones(length(centreOf0),1);
bandedgesOfToothWhen0 = Set_Trim(bandedgesOfToothWhen0);

%for Fmc
for n = 1:length(bandedgesOfToothWhen1(:,1))
    %Frequency Range I: interpolated filter mag = 1
    if (bandedgesOfToothWhen1(n,1) < freqRangeI && bandedgesOfToothWhen1(n,2) < freqRangeI)
        dunCareFmc = [dunCareFmc; bandedgesOfToothWhen1(n,:)];   
    %Frequency Range II: interpolated filter mag = 0
    elseif (bandedgesOfToothWhen1(n,1) > freqRangeII && bandedgesOfToothWhen1(n,2) > freqRangeII)
        dunCareFmc = [dunCareFmc; bandedgesOfToothWhen1(n,:)];
    end
end

%for Fma
for n = 1:length(bandedgesOfToothWhen0(:,1))
    %Frequency Range I: interpolated filter mag = 1
    if (bandedgesOfToothWhen0(n,1) < freqRangeI && bandedgesOfToothWhen0(n,2) < freqRangeI)
        dunCareFma = [dunCareFma; bandedgesOfToothWhen0(n,:)];   
    %Frequency Range II: interpolated filter mag = 0
    elseif (bandedgesOfToothWhen0(n,1) > freqRangeII && bandedgesOfToothWhen0(n,2) > freqRangeII)
        dunCareFma = [dunCareFma; bandedgesOfToothWhen0(n,:)];
    end
end 

end %GetDontCareBands
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function newBandsArray = Set_Trim(bandsArray)
%set first band passband = 0 if it is < 0
if (bandsArray(1,1) < 0)
    bandsArray(1,1) = 0;
end

%check if the band's pb and sb both exceed 0.5, if yes, trim those bands
cond = bandsArray > 0.5;
cond = not(cond(:,1) & cond(:,2));
bandsArray = [cond.*bandsArray(:,1) cond.*bandsArray(:,2)];
[C,I] = max(bandsArray(:,1));
newBandsArray = bandsArray(1:I,1:2);

%if the last tooth exceed 0.5, set to 0.5
if (newBandsArray(I,2) > 0.5)
    newBandsArray(I,2) = 0.5;
end

end %Set_Trim
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function [optInt, integer_m, pbFa, sbFa, newLenFa pbFma, sbFma, newLenFma, pbFmc, sbFmc, newLenFmc] = GetTrueOptM_UpdateFilters(intFactors,passband,stopband,passbandRipple,stopbandRipple)

%Find implementation case and m
%theta = intFactors*passband - floor(intFactors*passband);
%typeA = -floor(theta-0.5*ones(1,5));   %0 for case A and 1 for case B
%theta = ceil(intFactors*stopband) - intFactors*stopband;
%typeB = -floor(theta-0.5*ones(1,5));
phi = intFactors*stopband - floor(intFactors*passband);
typeA = phi <= 0.5;
phi = ceil(intFactors*stopband) - intFactors*passband;
typeB = phi <= 0.5;
m = floor(intFactors*passband).*typeA + ceil(intFactors*stopband).*typeB;

%Get subfilters' passbands and stopbands
tmpPbFa = (intFactors*passband - m).*typeA + (m - intFactors*stopband).*typeB;
tmpSbFa = (intFactors*stopband - m).*typeA + (m - intFactors*passband).*typeB;
tmpPbFma = (passband*ones(1,5)).*typeA + ((m - 1 + tmpSbFa)./intFactors).*typeB;
tmpSbFma = ((m + 1 - tmpSbFa)./intFactors).*typeA + (stopband*ones(1,5)).*typeB;
tmpPbFmc = ((m - tmpPbFa)./intFactors).*typeA + (passband.*ones(1,5)).*typeB;
tmpSbFmc = (stopband*ones(1,5)).*typeA + ((m + tmpPbFa)./intFactors).*typeB;

%find lengths of each subfilter
bFa(:,1) = tmpPbFa; bFa(:,2) = tmpSbFa;
bFma(:,1) = tmpPbFma; bFma(:,2) = tmpSbFma;
bFmc(:,1) = tmpPbFmc; bFmc(:,2) = tmpSbFmc;
aFa(:,1) = ones(5,1); aFa(:,2) = zeros(5,1);
aFma(:,1) = ones(5,1); aFma(:,2) = zeros(5,1);
aFmc(:,1) = ones(5,1); aFmc(:,2) = zeros(5,1);
devFa(:,1) = 0.85*passbandRipple*ones(5,1); devFa(:,2) = 0.85*stopbandRipple*ones(5,1);
devFma(:,1) = 0.85*passbandRipple*ones(5,1); devFma(:,2) = 0.85*stopbandRipple*ones(5,1);
devFmc(:,1) = 0.85*passbandRipple*ones(5,1); devFmc(:,2) = 0.85*stopbandRipple*ones(5,1);
tmpLenFa = zeros(5,1);tmpLenFma = zeros(5,1);tmplenFmc = zeros(5,1);
for n=1:5
    %factors that can crash firpmord
    cond = sum(bFa(n,:) > 0.5) + sum(bFma(n,:) > 0.5) + sum(bFmc(n,:) > 0.5);
    test = (bFa(n,1) == bFa(n,2)) | (bFma(n,1) == bFma(n,2)) | (bFmc(n,1) == bFmc(n,2));
    negativity = sum(bFa(n,:) < 0) + sum(bFmc(n,:) < 0) + sum(bFmc(n,:) < 0);
    if(cond == 0 && test == 0 && negativity == 0)
        [tmpLenFa(n,1), fo, ao, w] = firpmord(bFa(n,:),aFa(n,:),devFa(n,:),1);
        [tmpLenFma(n,1), fo, ao, w] = firpmord(bFma(n,:),aFma(n,:),devFma(n,:),1);
        [tmpLenFmc(n,1), fo, ao, w] = firpmord(bFmc(n,:),aFmc(n,:),devFmc(n,:),1);
    else
        tmpLenFa(n,1) = 10000;
        tmpLenFma(n,1) = 0;
        tmpLenFmc(n,1) = 10000;
    end
end

tmpDiffFmaFmc = abs(tmpLenFma - tmpLenFmc);
tmpLenTotal = tmpLenFa + tmpLenFma + tmpLenFmc;
tmpEffLen = intFactors'.*(tmpLenFa - ones(5,1)) + 1 + max(tmpLenFma,tmpLenFmc);

%access the 3 criteria to find Mopt
len(:,1) = [1;2;3;4;5];     %original index
len(:,2) = tmpDiffFmaFmc;len(:,3) = tmpLenTotal;len(:,4) = tmpEffLen;
len(:,5) = zeros(5,1);      %points gained

%length of Fma must be close to length of Fmc
len = sortrows(len,2);len(:,5) = len(:,5) + [15;12;9;6;3];
%total length must be minimum
len = sortrows(len,3);len(:,5) = len(:,5) + [10;8;6;4;2];
%effective length must be minimum
len = sortrows(len,4);len(:,5) = len(:,5) + [5;4;3;2;1];
[C,I] = max(len(:,5)); maxIndex = len(I,1); %get the index that gives the most points

%optimum interpolation factor
optInt = intFactors(maxIndex);
integer_m = m(maxIndex);

%update subfilters' specifications
pbFa = tmpPbFa(maxIndex);
sbFa = tmpSbFa(maxIndex);
newLenFa = tmpLenFa(maxIndex);
pbFma = tmpPbFma(maxIndex);
sbFma = tmpSbFma(maxIndex);
newLenFma = tmpLenFma(maxIndex);
pbFmc = tmpPbFmc(maxIndex);
sbFmc = tmpSbFmc(maxIndex);
newLenFmc = tmpLenFmc(maxIndex);

end     %end GetTrueOptM_UpdateFilters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End firfrm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%