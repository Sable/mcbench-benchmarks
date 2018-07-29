function [dataout] = f_hysep(datain, Area)
% Baseflow separation program based on USGS HYSEP program
% local minimum method only
%
% written by
%   Curtis DeGasperi
%   King County, DNRP
%   email: Curtis.DeGasperi@kingcounty.gov
% 
% ever so slightly modified by:
%   Jeff Burkey
%   King County, DNRP
%   email: Jeff.Burkey@kingcounty.gov
%
% USGS Report for Hydrograph Separation routine can be found at:
% http://www.water-research.net/Waterlibrary/geologicdata/estbaseflow.pdf
%
% datain = n x 2
%    datain(:,1) = timestep (daily)
%    datain(:,2) = flow rate (mean daily)
% Area = square miles
%
% Output:
%  dataout = n x 4 [time baseflow stormflow totalflow]
%
% The duration of surface runoff is calculated from the empirical relation:
% N=A^0.2, (1) where N is the number of days after which surface runoff ceases, 
% and A is the drainage area in square miles (Linsley and others, 1982, p. 210). 
% The interval 2N* used for hydrograph separations is the odd integer between 
% 3 and 11 nearest to 2N (Pettyjohn and Henning, 1979, p. 31).
%
% Syntax:
%   dataout = f_hysep(datain, Area);

N = Area^0.2;

% The hydrograph separation begins one interval (2N* days) prior to the start of the date selected
% for the start of the separation and ends one interval (2N* days) after the end of the selected date
% to improve accuracy at the beginning and end of the separation. If the selected beginning and
% (or) ending date coincides with the start and (or) end of the period of record, then the start of the
% separation coincides with the start of the period of record, and (or) the end of the separation
% coincides with the end of the period of record.

if mod(ceil(2*N),2)==0
    inN = floor(2*N);
else
    inN = ceil(2*N);
end

if inN <3; inN=3; elseif inN>11; inN=11; end

%inN 

%inN = input('Override or accept N - ');

cnt = 1;

tmm = datain(:,1); Q = datain(:,2);

if inN<=4; inN=3; elseif inN<=6&&inN>4; inN=5; elseif inN<=8&&inN>6; inN=7; elseif inN<=10&&inN>8; inN=9; else inN=11; end

if inN ==3
    cnt = 1; starts = 2;
elseif inN == 5
    ql(1,1)=Q(1);
    dl(1,1)=tmm(1);
    cnt = 2; starts = 3;
elseif inN == 7
    ql(1:2,1)=Q(1);
    dl(1:2,1)=tmm(1:2);
    cnt = 3; starts = 4;
elseif inN == 9
    ql(1:3,1)=Q(1);
    dl(1:3,1)=tmm(1:3);
    cnt = 4; starts = 5;
elseif inN == 11
    ql(1:4,1)=Q(1);
    dl(1:4,1)=tmm(1:4);
    cnt = 5; starts = 6;
end

for i=starts:length(Q)-0.5*(inN-1)-1

     qd = Q(i-0.5*(inN-1):i+0.5*(inN-1));
     if Q(i)<=min(qd)
         ql(cnt,1) = Q(i);
         dl(cnt,1) = tmm(i);
         cnt = cnt+1;
     end
    
end

[tm ql] = hysep_interp(dl,ql); %tm = tm+0.5;
ql(end) = NaN;

for i=1:length(ql)
    a = find(tmm==tm(i,1));
    if ql(i,1)>Q(a)
        ql(i,1)=Q(a);
    end
end

a = find(tmm>=tm(1)&tmm<=tm(end));
qro = Q(a)-ql; 
qro(isnan(Q(a))==1) = NaN;
ql(isnan(Q(a))==1) = NaN;

dataout = [tm ql qro Q(a)];
% plot(tmm(a),Q(a),'b-')
% hold on
% plot(tm,ql,'r-')
% hold off
% pause(1)


function [xi qi] = hysep_interp(d, q)
%interp function for hysep [qi]

dll = diff(d);
xi = [d(1):1:d(end)]';
qi = ones(length(xi),1);

cnt = 0;
for i=1:length(d)-1
    for j=1:dll(i)
        if j==1
            cnt = cnt+1;
            qi(cnt) = q(i);
            xii = xi(cnt);
        else
            cnt = cnt+1;
            qi(cnt) = 10^(((xi(cnt)-d(i))/dll(i))*(log10(q(i+1))-log10(q(i)))+log10(q(i)));
        end      
    end
end
