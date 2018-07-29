function oHDEVArray = hDevCalculation(fracFreq, sPeriod, tau)
%function for doing ovelapping Hadamard calculations for an array tau
%values. input arguments include array of fractional frequency readings,
%sPeriod of readings for overlap factor, and array of tau values
 
 phaseError = calculatePhaseError((1/sPeriod),fracFreq); %turn freq readings to frac freq values
 
 tCount = numel(tau); %get the size of the tau array
 oHDEVArray = zeros(1,tCount); %allocate array for Allan Dev values
 
 %add a wait bar so user knows status
j = 1/tCount;
h = waitbar(0,'Performing HDEV calculations...','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
 setappdata(h,'canceling',0)
 %loop through tau values and calculate HDEV at each value
 for i = 1:tCount
     oHDEVArray(i) = calculateHDEV(tau(i),sPeriod,phaseError);
     if getappdata(h,'canceling')
        oHDEVArray = [];
        oHDEVArray = -42881;
        delete(h);
        return;
    end
     waitbar((i*j),h,'Performing HDEV calculations...');
 end
 
 waitbar(1.0,h,'HDEV calculations done');
 delete(h);