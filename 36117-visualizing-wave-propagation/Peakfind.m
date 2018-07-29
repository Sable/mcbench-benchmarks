  function [PeakData]=Peakfind(Xdata,Ydata,NumPeaks)
  %#eml
% function [PeakData]=Peakfind(Xdata,Ydata,NumPeaks)
% 
% Returns array PeakData with NumPeaks entries consisting of 
% the xindex,xvalue,yvalue
% Copyright 2010-2013 The MathWorks, Inc.

% 
   iYpeak    = 3;
   PeakState = [1 1 -inf];
   %  PeakData  = []; 
   PeakData = zeros(1,3);   % numpeaks set to 1
   ibeg = 1;    % start search point
   iend = length(Ydata-1);
 
   for k = 1:NumPeaks
       a = Ydata(ibeg:iend) > [-inf, Ydata(ibeg:iend-1)];% must be > point on left
       b = Ydata(ibeg:iend) > [Ydata(ibeg+1:iend), -inf];% must be > point on right
       c = Ydata(ibeg:iend) < PeakState(iYpeak);         % must be < previous peak
       
      ix=find(a & b & c );                
      if isempty(ix) 
         [y ix] = max(Ydata);   % no more peaks: go to max
      else
         [y i]  =  max(Ydata(ix));  % there are more: go to biggest
         ix     = ix(i);            % note that this redefined i! 
      end;
      
      PeakState=[ix,Xdata(ix),y];
      % PeakData = [PeakData;PeakState]; 
      
      PeakData(k,:)=PeakState;

   end
   
   
   
   
   
