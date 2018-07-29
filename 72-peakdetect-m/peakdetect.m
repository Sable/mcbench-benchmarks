function [pospeakind,negpeakind]=peakdetect(signal)

%	PEAKDETECT peak detection
%
%	[pospeakind,negpeakind]=peakdetect(signal)
%
%	The positive and negative polarity (concave down and up) peak index vectors are
%	generated from the signal vector and graphically displayed.  Positive and negative
%	polarity peaks occur at points of positive to negative and negative to positive
%	slope adjacency, respectively.  The typically rare contingencies of peaks
%	occurring at the lagging edges of constant intervals are supported.  Complex
%	signals are modified to the modulus of the elements.  If unspecified, the signal
%	vector is entered after the prompt from the keyboard.

%	Implemented using MATLAB 6.0.0
%
%	Examples:
%
%	ť [p,n]=peakdetect([-1 -1 0 1 0 1 0 -1 -1])
%
%	p =
%
%	     4     6
%
%	n =
%
%	     1     5     8
%
%	ť [p,n]=peakdetect(cos(2*pi*(0:999999)/500000))
%
%	p =
%
%	           1      500001     1000000
%
%	n =
%
%	      250001      750001
%
%	Copyright (c) 2001
%	Tom McMurray
%	mcmurray@teamcmi.com

%	if signal is not input, enter signal or return for empty outputs

if ~nargin
   signal=input('enter signal vector or return for empty outputs\n');
   if isempty(signal)
      pospeakind=[];
      negpeakind=[];
      return
   end
end
sizsig=size(signal);

%	while signal is unsupported, enter supported signal or return for empty outputs

while isempty(signal)|~isnumeric(signal)|~all(all(isfinite(signal)))...
      |length(sizsig)>2|min(sizsig)~=1
   signal=input(['signal is empty, nonnumeric, nonfinite, or nonvector:\nenter '...
         'finite vector or return for empty outputs\n']);
   if isempty(signal)
      pospeakind=[];
      negpeakind=[];
      return
   end
   sizsig=size(signal);
end

%	if signal is complex, modify to modulus of the elements

if ~isreal(signal)
   signal=abs(signal);
end

%	if signal is constant, return empty outputs

if ~any(signal-signal(1))
   pospeakind=[];
   negpeakind=[];
   disp('constant signal graph suppressed')
   return
end
sizsig1=sizsig(1);
lensig=sizsig1;

%	if signal is a row vector, modify to a column vector

if lensig==1
   signal=signal(:);
   lensig=sizsig(2);
end
lensig1=lensig-1;
lensig2=lensig1-1;

%	if signal length is 2, return max/min as positive/negative polarity peaks

if ~lensig2
   [sig,pospeakind]=max(signal);
   [sig,negpeakind]=min(signal);
   disp('2 element signal graph suppressed')
   return
end

%	generate difference signal

difsig=diff(signal);

%	generate vectors corresponding to positive slope indices

dsgt0=difsig>0;
dsgt00=dsgt0(1:lensig2);
dsgt01=dsgt0(2:lensig1);

%	generate vectors corresponding to negative slope indices

dslt0=difsig<0;
dslt00=dslt0(1:lensig2);
dslt01=dslt0(2:lensig1);

%	generate vectors corresponding to constant intervals

dseq0=difsig==0;
dseq01=dseq0(2:lensig1);
clear difsig

%	positive to negative slope adjacencies define positive polarity peaks

pospeakind=find(dsgt00&dslt01)+1;

%	negative to positive slope adjacencies define negative polarity peaks

negpeakind=find(dsgt01&dslt00)+1;

%	positive slope to constant interval adjacencies initiate positive polarity peaks

peakind=find(dsgt00&dseq01)+1;
lenpeakind=length(peakind);

%	determine positive polarity peak terminations

for k=1:lenpeakind
   peakindk=peakind(k);
   l=peakindk+1;
   
%	if end constant interval occurs, positive polarity peak exists
   
   if l==lensig
      pospeakind=[pospeakind;peakindk];
      
%	else l<lensig, determine next nonzero slope index
      
   else
      dseq0l=dseq0(l);
      while dseq0l&l<lensig1
         l=l+1;
         dseq0l=dseq0(l);
      end
      
%	if negative slope or end constant interval occurs, positive polarity peaks exist
      
      if dslt0(l)|dseq0l;
         pospeakind=[pospeakind;peakindk];
      end
   end
end

%	negative slope to constant interval adjacencies initiate negative polarity peaks

peakind=find(dslt00&dseq01)+1;
lenpeakind=length(peakind);
clear dseq01

%	determine negative polarity peak terminations

for k=1:lenpeakind
   peakindk=peakind(k);
   l=peakindk+1;
   
%	if end constant interval occurs, negative polarity peak exists
   
   if l==lensig
      negpeakind=[negpeakind;peakindk];
   
%	else l<lensig, determine next nonzero slope index
      
   else
      dseq0l=dseq0(l);
      while dseq0l&l<lensig1
         l=l+1;
         dseq0l=dseq0(l);
      end
      
%	if positive slope or end constant interval occurs, negative polarity peaks exist
      
      if dsgt0(l)|dseq0l;
         negpeakind=[negpeakind;peakindk];
      end
   end
end
clear dsgt0 peakind

%	if initial negative slope occurs, initial positive polarity peak exists

if dslt00(1)
   pospeakind=[1;pospeakind];
   
%	elseif initial positive slope occurs, initial negative polarity peak exists

elseif dsgt00(1)
   negpeakind=[1;negpeakind];
   
%	else initial constant interval occurs, determine next nonzero slope index

else
   k=2;
   dseq0k=dseq0(2);
   while dseq0k
      k=k+1;
      dseq0k=dseq0(k);
   end
   
%	if negative slope occurs, initial positive polarity peak exists
   
   if dslt0(k)
      pospeakind=[1;pospeakind];
      
%	else positive slope occurs, initial negative polarity peak exists
      
   else
      negpeakind=[1;negpeakind];
   end
end
clear dsgt00 dslt0 dslt00 dseq0

%	if final positive slope occurs, final positive polarity peak exists

if dsgt01(lensig2)
   pospeakind=[pospeakind;lensig];
   
%	elseif final negative slope occurs, final negative polarity peak exists

elseif dslt01(lensig2)
   negpeakind=[negpeakind;lensig];   
end
clear dsgt01 dslt01

%	if peak indices are not ascending, order peak indices

if any(diff(pospeakind)<0)
   pospeakind=sort(pospeakind);
end
if any(diff(negpeakind)<0)
   negpeakind=sort(negpeakind);
end

%	if signal is a row vector, modify peak indices to row vectors

if sizsig1==1
   pospeakind=pospeakind.';
   negpeakind=negpeakind.';
end

%	plot signal peaks

plot(0:lensig1,signal,pospeakind-1,signal(pospeakind),'b^',negpeakind-1,...
   signal(negpeakind),'bv')
xlabel('Sample')
ylabel('Signal')
grid