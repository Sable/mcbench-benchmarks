function decayTimes = generateDecayData(sampleTime,sampleCount,halfLife,relativeAmount)
% generateDecayData : simulate the signal from decay of mixture of isotopes
% The physical setup is a mixture of atoms of different isotopes, having
% different half lives.  We observe the decays of the atoms in this mixture
% until we observe a set amount of decays (sampleCount).

%   Copyright 2008-2009 The MathWorks, Inc.
%   $Revision: 35 $  $Date: 2009-05-29 15:27:34 +0100 (Fri, 29 May 2009) $

% Convert half life in minutes to decay rate in seconds
secondsPerMinute = 60;

meanLifetime = (halfLife*secondsPerMinute)/log(2); % in s^-1

% Total number of atoms
totalAtomCount = 1e7;

isotopeCount = floor(totalAtomCount.*relativeAmount/sum(relativeAmount));

% For each isotope generate observed decay times from that isotope
% The probability that an individual atom decays after time t is is given
% be 1/mu*exp(t/mu), where mu is the mean lifetime.  We can use exprnd to
% sample from this distribution
decayTimes = [];
for isotopeIndex = 1:numel(halfLife)
    thisLifetime = meanLifetime(isotopeIndex);
    thisAtomCount = isotopeCount(isotopeIndex);
    decayTimes = [decayTimes; exprnd(thisLifetime,thisAtomCount,1)];
end

% Assume that we don't observe the decay times greater than the sample time
decayTimes = decayTimes(decayTimes<sampleTime);

% Randomise the order of decay times
decayTimes = decayTimes(randperm(numel(decayTimes)));

% % Assume that we only observe 1% of the decays
% decayTimes = decayTimes(1:totalAtomCount/100);
% 
% % Sort the decayTimes
% decayTimes = sort(decayTimes);

% Extract the first sampleCount elements of the decayTimes vector as the
% observed decay times
decayTimes = decayTimes(1:sampleCount);
