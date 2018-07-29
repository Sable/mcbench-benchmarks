function [amp,phi,yr]=HANTS(ni,nb,nf,y,ts,HiLo,low,high,fet,dod,delta)
% HANTS processing
% 
% Wout Verhoef
% NLR, Remote Sensing Dept.
% June 1998
%
% Converted to MATLAB:
% Mohammad Abouali (2011)
%
% NOTE: This version is tested in MATLAB V2010b. In some older version you 
% might get an error on line 117. Refer to the solution provided on that
% line.
%
% Modified: 
%   Apply suppression of high amplitudes for near-singular case by 
%	adding a number delta to the diagonal elements of matrix A, 
%	except element (1,1), because the average should not be affected
% 
%	Output of reconstructed time series in array yr June 2005
% 
%   Change call and input arguments to accommodate a base period length (nb)
%   All frequencies from 1 (base period) until nf are included
% 
% Parameters
% 
% Inputs:
%   ni    = nr. of images (total number of actual samples of the time 
%           series)
%   nb    = length of the base period, measured in virtual samples 
%           (days, dekads, months, etc.)
%   nf    = number of frequencies to be considered above the zero frequency
%   y     = array of input sample values (e.g. NDVI values)
%   ts    = array of size ni of time sample indicators 
%           (indicates virtual sample number relative to the base period); 
%           numbers in array ts maybe greater than nb
%           If no aux file is used (no time samples), we assume ts(i)= i, 
%           where i=1, ..., ni
%   HiLo  = 2-character string indicating rejection of high or low outliers
%   low   = valid range minimum
%   high  = valid range maximum (values outside the valid range are rejeced
%           right away)
%   fet   = fit error tolerance (points deviating more than fet from curve 
%           fit are rejected)
%   dod   = degree of overdeterminedness (iteration stops if number of 
%           points reaches the minimum required for curve fitting, plus 
%           dod). This is a safety measure
%   delta = small positive number (e.g. 0.1) to suppress high amplitudes
% 
% Outputs:
% 
% amp   = returned array of amplitudes, first element is the average of 
%         the curve
% phi   = returned array of phases, first element is zero
% yr	= array holding reconstructed time series


mat=zeros(min(2*nf+1,ni),ni,'single');
amp=zeros(nf+1,1,'single');
phi=zeros(nf+1,1,'single');
yr=zeros(ni,1,'double');


% if (Opt.FirstRun==true)
    sHiLo = 0;
    if (strcmp(HiLo,'Hi'))
        sHiLo =-1;
    end
    if (strcmp(HiLo,'Lo'))
        sHiLo = 1;
    end
    nr=min(2*nf+1,ni);
    noutmax=ni-nr-dod;
    dg=180.0/pi;
    mat(1,:)=1.0;

    ang=2.*pi*(0:nb-1)/nb;
    cs=cos(ang);
    sn=sin(ang);
%     Opt.FirstRun=false;
% end
i=1:nf;
for j=1:ni
    index=1+mod(i*(ts(j)-1),nb);
    mat(2*i  ,j)=cs(index);
    mat(2*i+1,j)=sn(index);
end

p=ones(ni,1);
p(or(y<low,y>high))=0;
nout=sum(p==0);

if (nout>noutmax)
%     disp('Not enough data points')
%     disp(['nout:' num2str(nout) ' ,noutmax:' num2str(noutmax)])
%     error('nout > noutmax')
    return
end

ready=false;
nloop=0;
nloopmax=ni;

while ((~ready)&&(nloop<nloopmax))
    nloop=nloop+1;
    za=mat*(p.*y);

    A=mat*diag(p)*mat';
    A=A+diag(ones(nr,1))*delta;
    A(1,1)=A(1,1)-delta;
    zr=A\za;

    yr=mat'*zr;
    diffVec=sHiLo*(yr-y);
    err=p.*diffVec;

	[~, rankVec]=sort(err,'ascend');
% The above line may not be recognized on some older MATLAB versions.
% Simply comment the above line and uncomment the line below.
%    [tmp, rankVec]=sort(err,'ascend');

    maxerr=diffVec(rankVec(ni));
    ready=(maxerr<=fet)||(nout==noutmax);

    if (~ready)
        i=ni;
        j=rankVec(i);
        while ( (p(j)*diffVec(j)>maxerr*0.5)&&(nout<noutmax) )
				p(j)=0;
				nout=nout+1;
				i=i-1;
				j=rank(i);
        end
    end
end

amp(1)=zr(1);
phi(1)=0.0;

zr(ni+1)=0.0;

i=2:2:nr;
ifr=(i+2)/2;
ra=zr(i);
rb=zr(i+1);
amp(ifr)=sqrt(ra.*ra+rb.*rb);
phase=atan2(rb,ra)*dg;
phase(phase<0)=phase(phase<0)+360;
phi(ifr)=phase;

end