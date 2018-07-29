%*************************************************************
%Program:			SAVFILT
%Simply AVeraging FILTer for vectors or matrices (works on columns of matrices)
%Description: generalized and improved version of SGOLAYFILT(Dat,1,W)
%In practice SGOLAYFILT is most frequently used with ORDer 1, 
%because at given filtering frame W the ORDer 1 gives the highest 
%smoothening of the Data.
%Advantages of SAVFILT(Dat,W) in comparison to SGOLAYFILT(Dat,1,W):
%  1. Better results at the rands of the Data: instead of arbitrary padding
%   the Data with zeros, a possibly wide frame is used at the rands.
%  2. SAVFILT accepts arbitrary frames W>1, not only odd ones, as SGOLAYFILT does.
%   The results of filtering white noise with any W>1 leads to almost by the factor of sqrt(W) 
%   smaller standard deviation of the filtered data in comparison to raw data. 
%   This feature is especially helpful in the case
%   of filtering periodical data with an arbitrary period.
%  3. With odd W SAVFILT works more than 2 times faster than SGOLAYFILT, and about at the same speed
%   in the case of nonodd W (can be made equally fast and with exact efficiency sqrt(W)). 
%   The Efficiency of any low-pass filter is defined as: E=std(Dat)/std(DatF),
%   Dat being white gaussian noise and DatF is filtered Dat
%Call:				
%		DatF=savfilt(Dat,W,E)			
%Input:		
%	Dat = Data to be filtered, a matrix N*M, any([N,M]>1)
%	E= filter efficiency, abs(E)>1
%	W= abs(E)^2
%   W or E are used interchangeably. If nargin>2, W-value will be replaced by W=abs(E^2)
%Output:	
%	DatF = Filtered Data
%
%V.Pastushenko, 22-nd July 1993, J.Kepler Univ. of Linz, Austria
%==============================================================

function 		DatF = savfilt(Dat,w,E)

	[a,b]=size(Dat);
    if all([a b]==1),DatF=Dat;erbip('A scalar can''t be filtered');return,end
    if nargin>2
        w=abs(E^2);
    end
    if nargin<2,erpib('NOT ENOUGH ARGUMENTS'),return,end
    trans=a==1;
    if trans, Dat=Dat(:);end
    if w<=1,Datf=Dat;erpib('TOO SHORT WINDOW'),return,end%__________
        
    %Main version: odd window
    if rem(w-1,2)==0
        DatF=svf(Dat,w);
    else
     %Derivative versions: nonodd window
    LOW=floor(w);
    if rem(LOW,2)==0
        LOW=LOW-1; %Low should be odd
    end
        HIW=LOW+2;
        D1=svf(Dat,LOW);
        D2=svf(Dat,HIW);
        RAT=sqrt(HIW/LOW);
        MID=sqrt(w/LOW);
        al=sqrt((HIW/w-1)/(HIW/LOW-1));
        DatF=D1*al+D2*(1-al);
    end
    
if trans
    DatF=DatF.';
end



function DatF=svf(Dat,W)
%Simply AVeraging Filter
%Dat = a column or a matrix of columns
DatF=Dat; 
if W<3
     return
end


HW=(W-1)/2; %Real data start from HW+1!!
[R,C]=size(Dat);
DatF=cumsum(Dat);
BEGIN=DatF(1:2:W,:);

ENDIN=cumsum(Dat(end:-1:end-W+1,:));
ENDIN=flipud(ENDIN(1:2:end,:));

DatF(HW+2:end-HW-1,:)=DatF(W+1:end-1,:)-DatF(1:end-W-1,:);


DatF(1:HW+1,:)=BEGIN;
DatF(end-HW:end,:)=ENDIN;

WEIG=1./[1:2:W,W*ones(1,R-W-1),W:-2:1]';
WEIG=WEIG(:,ones(1,C));

DatF=DatF.*WEIG;


function erbip(MES)
%	Vassili Pastushenko	 june 2004
%==============================
bip;
if nargin>0
    disp(MES)
end


function erpib(MES)
%	Vassili Pastushenko	 june 2004
%==============================
bip(1);
if nargin>0
    disp(MES)
end

function   bip(pib)
%Soud warning
%Call:
%           bip(inverted bip)
%Input:
%  if set, inverts sound
%Vassili Pastushenko	Jul	2004
%==============================
t=(1:.1:70)';
ONETWO=linspace(1,3,length(t))';
S=cos(t.*ONETWO)./(2+ONETWO);
if nargin>0
    S=flipud(S);
end
sound(S);