function	[Z,GAM]=melody(PES,x)
% Plays 2-letter note code, 1 note per row
% Example below:   MEL
%Call	
%		RES=melody(PES,x)
%Input
%		PES = Notes, def. russian song "Happy Xmas" ( elochka)
%       x = Freq. Factor (1,2,3,4,...), def.3
%Output
%       melody; Z = data to play,e.g.  sound(Z/5)
%       GAM = GAMMA used
%Vassili Pastushenko 20:45 at 31-st December 1999
%================================
if nargin<2,x=3;end
if nargin<1
    MEL=['dllslfdddllcrddddrrcclsfdllslfff'
'oaaoaaoooaai22222eeiiaoaoaaoaaaa']';    
    PES=MEL;
end
[a,b]=size(PES);
if a==1|b==1
PES=reshape(PES,2,length(PES)/2)';
end

F=2.^((-5:16)/12)*440;

REM=[1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 0 1 1 0 1 0 1 1 0];
F=F(REM(1:length(F))>.1);
GAM='doremifasolacid2r2m2f2s2l2c2d3r3m3f3s3l3c3d4';

GAM=reshape(GAM,2,length(GAM)/2)';
LG=length(GAM(:,1));

LEN=round(8192/x);
LPES=length(PES);
Z=zeros(LEN,LPES);
PH=0;


for i=1:LPES
   loc=PES(i,:);
   for k=1:LG
      if all(loc==GAM(k,:))
         j=k;
         break
      end
   end
      [S,PH]=gensnd(F(j),x,PH);
   Z(:,i)=S;
 end

 VV=2:4:LPES;  Z(:,VV)=Z(:,VV).*1.5;
 
 Z=Z(:);
 Z=Z/max(abs(Z));
 
 ZZ=Z;
 ZZ=[ZZ(101:end);ZZ(1:100)];
 Z=[Z,ZZ];
 sound(Z/5);