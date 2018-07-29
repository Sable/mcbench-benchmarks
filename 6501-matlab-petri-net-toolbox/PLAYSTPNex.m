function [Seq,setM] = PlaySTPNex(Pre, Post, M0, TimeT, TypeT, ticks)

%[Seq,setM] = PlaySTPNex(Pre, Post, M0, TimeT, TypeT, ticks)
% 	Pre     - Matrix of preconditions
%	Post    - Matrix of postconditions
%	M0   	- Column vector of initial markings  
%	TimeT   - Column vector of time, associated to the transitions
%	TypeT   - Column vector of transitions types :
%                    0  -  Zero timed transition
%                    1  -  Timed transition
%                    2  -  Stochastic time transition with unifom distribution
%       ticks  	- Integer number of simulation ticks 
%	Seq 	- The two row matrix of firing sequence (1st row - tick, 2nd row - transition fired)
%	M	- Marking of the STPN on the end of simulation 
%
%       TimeT(j) associated to stochastic time transition Tj means maximum value of the uniform 
%       distribution, i.e. 	if (TimeT(j)>0) then    1 <= (time assigned to Tj) <= TimeT(j).
%				if (TimeT(j)=0) then 	(time assigned to Tj)=0
%  	hanzalek@rtime.felk.cvut.cz

%!!!!!!! neumi zdrojovy prechod

[nofp,noft]=size(Pre);
M=M0;
C=Post-Pre;
Seq=[];
setM=[];
error=0;
setMM=[];
if any(xor(TimeT,TypeT)) 
	find(xor(TimeT,TypeT))
	sprintf('!!!! Transition Type and Time do not coincide')
	error=1;
end
if all(TimeT==0) 
	sprintf('!!!! There is no timed transition - program can infinitelly run')
	error=2;
end 

if (error==0)
  %initialize counters
  CountT=zeros(size(TimeT,1),1);
  for k=1:noft
	if (TypeT(k)==1)			%timed
		CountT(k)=TimeT(k);
	elseif (TypeT(k)==2)			%stochastic
		CountT(k)=ceil(rand(1)*TimeT(k));
	elseif (TypeT(k)==0)
		CountT(k)=0;
	end;
  end
  %PN Player Main Cycle
  tick=0;
  while tick<=ticks 

	%generation of vector of  enabled transitions
	for k=1:noft
      x(k)=all(M >= Pre(:,k));  			% x - enabled transition
		%set counter of not enabled transition ???? asi lze presunout dolu 
		if x(k)==0						
			if (TypeT(k)==1)			%timed
				CountT(k)=TimeT(k);
			elseif (TypeT(k)==2)			%stochastic
				CountT(k)=ceil(rand(1)*TimeT(k));
			end
		end
	end

	if (~any(x)) 
		sprintf('!!!! deadlock')
	end		
	y=x & (~CountT)';                  			% y - enabled transition with CountT=0

	if (any(y)) 
		%random selection of transition which fires 
      
      [m,fir]=max(rand(size(y)).*y);
		M=M+C(:,fir);
      setMM=[setMM,M];
		Seq(1,size(Seq,2)+1)=tick;
      Seq(2,size(Seq,2))=fir;
      %set counter of fired transition - single server semantics
      if (TypeT(fir)==1)				%timed
   	  	CountT(fir)=TimeT(fir);
		elseif (TypeT(fir)==2)			%stochastic
			CountT(fir)=ceil(rand(1)*TimeT(fir));
      end
	else
      		%changing counters for enabled timed and stochast transition
            tick=tick+1;
            
		if (rem(tick,100)==0)
			%sprintf('Tick %i',tick)
		end
		CountT=((CountT-1).*(x' & TypeT)) + (CountT.*(~(x' & TypeT)));   
		if (any(CountT<0)) 
			sprintf('!!!!negative time')
		end
   end
end %Main Cycle
for i=1:(size(Seq,2)-1)
   if Seq(1,i)<Seq(1,i+1)
      setM=[setM,setMM(:,i)];
   end
end
setM=[setM,setMM(:,size(Seq,2))];
end %endif