function oADEVArray = timeADevCalculation(fracFreq, sPeriod, tau)
%function for doing ovelapping Allan calculations array tau values
 
 phaseError = calculatePhaseError((1/sPeriod),fracFreq); %turn freq readings to frac freq values
 
 tCount = numel(tau); %get the size of the tau array
 oADEVArray = zeros(1,tCount); %allocate array for Allan Dev values
 
 %add a wait bar so user knows status
j = 1/tCount;
h = waitbar(0,'Performing ADEV calculations...','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(h,'canceling',0)
%loop through each tau value and calculate ADEV
 for i = 1:tCount
     oADEVArray(i) = calculateADEV(tau(i),sPeriod,phaseError);
     % Check for Cancel button press
    if getappdata(h,'canceling')
        oADEVArray = [];
        oADEVArray = -42881;
        delete(h);
        return;
    end
     waitbar((i*j),h,'Performing ADEV calculations...');
 end
 
 waitbar(1.0,h,'ADEV calculations done');
 %plot(tau,allanArray);
 %semilogx(tau,allanArray);
 %loglog(tau,hadaArray);
 delete(h);