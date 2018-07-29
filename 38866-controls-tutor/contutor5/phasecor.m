function [fphs]=phasecor(lo,axs,wloc)
%
% Utility Function: PHASECOR
%
% The purpose of this function is to extend the phase plot outside [-360,0]
% so that it becomes continuous across Nichols chart phase axis and
% guarantees that it wraps correctly depending upon axis limits

% Author: Craig Borghesani
% Date: 8/8/94
% Revised:
% Copyright (c) 1999, Prentice-Hall

phs=phase4(lo)*180/pi;
ip=length(phs);
fphs=phs;
if any(fphs~=0),

 d=diff(fphs);
 id=find(abs(d) > 180)+1; % add 1 to correct for location after diff
 for j=1:length(id),
  fphs(id(j):ip)=fphs(id(j):ip)-sign(diff(phs([id(j)-1,id(j)])))*360;
 end

 ax1=axs(1); ax2=axs(2);
 if ax2<0,
  shift1=ceil(abs(ax2)/360)*360;
 else
  shift1=floor(abs(ax2)/360)*360;
 end
 fphs=fphs+(sign(ax2)*shift1);
 shift2=floor((ax2-ax1)/360)*360;
 if shift2==0, shift2=360; end
 brkl=find(fphs<ax1); brkr=find(fphs>ax2);
 while length(brkl), fphs(brkl)=fphs(brkl)+shift2; brkl=find(fphs<ax1); end
 while length(brkr), fphs(brkr)=fphs(brkr)-shift2; brkr=find(fphs>ax2); end

 if nargin==3,
  fphs=fphs(wloc);
 end
elseif nargin==3,
 fphs=fphs(wloc);
end