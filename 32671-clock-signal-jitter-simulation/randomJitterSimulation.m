function [ampl time] = randomJitterSimulation(sRate, sCount, cCycles, jMag, dist)
%This function creates a digital clock signal waveform with random jitter
%on it. The intent of this function is that the generated waveform data 
%will be uploaded onto an arbitrary waveform generator (AWG) to simulate a 
%real world digital clock with a known amount of jitter for noise immunity 
%and other similar test applications.
%The random jitter is genrated using matlab's rand function. You can 
%choose two different distributions for generating the random values:
%normal and uniform. For the normal distributions jMag is used as the 3 
%sigma point which covers 99.7% of the area of the distribution.
%This funtion uses
%Matlab's built-in error function or erf() function. for information on the
%erf() function http://www.mathworks.com/help/techdoc/ref/erf.html. For
%more information or questions on the technique and math used in this 
%function to simulate real world jitter refer to my blog post:
%http://gpete-neil.blogspot.com/2011/08/simulating-jitter-with-arbitrary.html
%or email me at: neil_forcier at agilent dot com
%The following is a description of the input arguments and returned 
%variables
%sRate: The sample rate of the waveform points. This value should be same 
%sample rate you plan to use with the AWG
%sCount: the number of points needed in one clock cycle
%cCycles: the number of clock cycles you want in the waveform. cCycles *
%sCount gives you the number of points in the waveform
%jMag: is the maximum value in seconds that the signal should vary +/- from
%the ideal value. It is used to set the limits of the uniform distribution
%and the 3 sigma point of the normal distribution. jMag must be less than
%or equal to 80 percent of the pulse width or one half cycle period. 
%Otherwise it will be set to 80 percent.
%dist: Used to specify the type of distribution to be used by the random()
%function. There are two distributions normal and uniform. 
%-->to select normal distribution enter string 'normal' or 'norm'
%-->to select uniform distribution enter string 'uniform'
%-->the default distribution is normal
%ampl: This is the returned array of digital clock waveform amplitude
%points. In terms of a plot this would be the y axis points
%time: This is the array of the timing points that correspond to the array
%of amplitude points. Some AWGs use the timing points to set their sample
%rate. Most AWGs do not require the timing points and the sample rate can
%be set manually on the front panel or remotely with a command

sPeriod = 1/sRate; %calculate sample period or time between samples
cPeriod = sPeriod * sCount; %calculate period of one cycle of clock waveform

%if the magnitude of the jitter is higher than 80% pulse width clip it to 
%80 percent of pulse width
if jMag > ((cPeriod*0.5)*.8)
    jMag = ((cPeriod*0.5)*.8); 
end

%check to see which distribution type should be used
if strcmp(dist,'uniform')
    %Use uniform distribution
    rArray = 1 * rand(cCycles,1) .* sign(rand(cCycles,1) - 0.5);
else
    %Use normal distribution
    sigma = 1/3; %calculate standard with 3 sigma equal to 1
    mu = 0; %mean is always zero
    rArray = mu + sigma.*randn(1,cCycles);
end

%establish over sampling pad using sPeriod. this is what is used to set
%rise and fall times of clock pulses
oSamp = 2.5 * sPeriod; 
time = sPeriod:sPeriod:(cPeriod*cCycles); %build x time axis

%pre-allocate ampl for better performance
ampl = zeros(1,(sCount*cCycles));
iter = 1; %this variable tracks ampl array

   for  r=1:1:cCycles; %This loop controls the number of clock cycles
    for i = sPeriod:sPeriod:cPeriod;  %this loop creates one clock period
        %the following formula creates the waveform using erf()
        ampl(iter) = erf((i-(cPeriod/2))/oSamp)+erf(-((i-cPeriod)+(rArray(r)*jMag))/oSamp)-1;
        iter = iter + 1;
    end
   end
   
%the following commented code plots the result and writes to csv
%plot(time,ampl);
%write each waveform to CSV file
%z = [time;ampl]; 
%dlmwrite('Clock.csv', z', 'coffset', 0, 'roffset', 0);