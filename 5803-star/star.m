function [Z,H]=star(CENTRAD,N,col)
% Unlimited set of resizable markers, LINE or PATCH style, def. PATCH
%Call:
%           [Z,H]=star(CENTRAD,N,col)
%Input:
%		CENTRAD = a column of marker positions CENTERS,
%       CENTERS =Xcenter+1i*Ycenter
%       or M*2 matrix, CENTRAD = [CENTERS SIZES], def.[0 1]
%       SIZES=a column of radial sizes of markers (in units of plotted data)
%		N = nVertices+1i*Shift, def. 5+2i
%       nVertices = number of Vertices of a star
%       Shift>=1: integer, defines step between connected Vertices
%       col = color/starstyle spec: line or patch; if set, graphic is on;
%       col = one of 1-letter colors and/or one of digits 1:9 for linewidth
%       if any(str2num(col)==1:9), starstyle = LINE, otherwise PATCH 
%Output:
%		Z = star (complex) coordinates as columns of Z, for use with PATCH or LINE
%       H = handle(s) to star(s), mainly used to erase the markers: delete(H)
% ================================================
%       DEMOs
%       z=star((1:3:16)'*(1+1i),3);patch(real(z),imag(z),'g');  
%       [z,h]=star([0;3i; 3+1i;3+3i],5+2i,'r');pause;delete(h) %patch
%       [z,h]=star([0;3i; 3+1i;3+3i],5+2i,'3b');pause;delete(h) %line
%       star(0,6+2i,'b');
%       star(10*(randn(5,1)+1i*randn(5,1)),7+5i,'r');star([1i,.5],2,'b3');
%       star(0,4,'r'); %Patch style
%       star(0,35+17i,'m'); %Patch style
%       z=star(0,25+12i,'g9'); pause;cline(z,'r3');%Line style
%       star((0:3:9)'*(1+1i),60+3i,'2r)
%================================================
%       See also: CLINE
%	Vassili Pastushenko	 27-th Aug 2004
%=================================================
NARG=nargin;
if NARG<1
    CENTRAD=[0 1];
end

%Default 5-star
if NARG<2
    N=5+2i; 
end

[M,RA]=size(CENTRAD);
%If only CENTERS, set markersize = 1 
if RA==1
    CENTRAD(:,2)=1;
end
%-----------------

%Set default shift=1
if isreal(N)
    N=N+1i;
end
%--------------------

S=abs(round(imag(N))); %extract shift
N=abs(round(real(N))); %extract nVertices

if S>N,S=max(1,rem(S,N));end

CEN=CENTRAD(:,1); %extract centers
RAD=abs(CENTRAD(:,2));%extract markersize

%Select marker style: line or patch
LINE=1<0;  %Patch assumed
if NARG>2
    LINWID='123456789'; %accepted linewidths
    LENCOL=length(col);
    for i=1:LENCOL
        if any(LINWID==col(i))
            LINE=~LINE;  %Select patch
        end
    end
end
%-------------------------

%Prepare unit size marker shape w
z=exp(1i*pi*(.5+(1:N)/N*2));
zz=z([S+1:N,1:S]);
w=[z;zz];
%------------------------

%Prepare line or patch data
Z=[];     
if LINE
        for i=1:M
            z=w*RAD(i)+CEN(i);
            z(3,:)=NaN;
            Z(:,i)=z(:);
        end
 else
        for i=1:M
            z=w(:)*RAD(i)+CEN(i);
            Z(:,i)=z;
        end
 end
 %------------------------------
 
 %Plotting
 if NARG>2
        if LINE
            H=cline(Z,col);
        else
            H=patch(real(Z),imag(Z),col,'edgecolor','none');
        end
        set(gca,'dataaspectratio',[1 1 1])
        figure(gcf)
 end