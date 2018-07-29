function []=FanChart(fore,hist,datefinal,datestep)

% This function generates a fan chart. A fan chart aims to visualize the
% uncertainty that surrounds a sequence of point forecasts.
%
% Author: Marco Buchmann (mb-econ.net), ECB / Frankfurt University
% Date: January 2010
%
% Required input:
% -- a HxD matrix 'fore': the density forecasts D along the horizon 1:H
% -- a Tx1 vector 'hist': a vector of historical data
%
% Optional input:
% -- a string 'datefinal': referring to the end of the forecast horizon
% -- a scalar 'datestep': if e.g. set to 3, then labels quarterly 
%
% Output:
% -- plot

% Check input
if nargin<2
    error('Not enough input arguments')
end

% Parameters
H=size(fore,1);
T=size(hist,1);
Ttot=T+H;

%datefinal='Jun2009'; % date for which last forecast is available

ftitle='Out-of-sample forecast'; % title for plot
targetvar='Y'; % label for horizontal axis

% Date vector
if exist('datefinal')==1 %#ok<EXIST>
    if exist('datestep')==0 %#ok<EXIST>
       datestep=1; 
    end
    dvec=createdatevec(datefinal,Ttot,'backward');
    tmp_mnump=-(Ttot-1);
    % Generate date vector (displacement b/w start and end of test period in months)
    tmp_b=datevec((addtodate((addtodate(datenum(dvec(end,1),'mmmyyyy'),tmp_mnump,'month')),1,'day')));
    if tmp_b(1,2)==1 || tmp_b(1,2)==4 || tmp_b(1,2)==7 || tmp_b(1,2)==10
        sg=3:datestep:size(dvec,1);
    elseif tmp_b(1,2)==2 || tmp_b(1,2)==5 || tmp_b(1,2)==8 || tmp_b(1,2)==11
        sg=2:datestep:size(dvec,1);
    else
        sg=1:datestep:size(dvec,1);
    end
end

% Set relevant quantiles (in percent)
quantiles=[5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95];
num_quant=size(quantiles,2);

% Compute quantiles
mat_quant=NaN(H,num_quant);
for h=1:H % loop over horizon
    for q=1:num_quant % loop over quantiles
        mat_quant(h,q)=quantile(fore(h,:),quantiles(1,q)/100);
    end
end

% Add hist. observations to the plot matrix
addv=[10^(-42) 10^(-43) 10^(-44) 10^(-45) 10^(-46) 10^(-47) 10^(-48) 10^(-49) 10^(-50) 0 10^(-50) 10^(-49) 10^(-48) 10^(-47) 10^(-46) 10^(-45) 10^(-44) 10^(-43) 10^(-42)];
hm=hist;
for i=1:18
    hm=[hm hist]; %#ok<AGROW>
end
mat_quant=[hm;mat_quant];
for t=1:T
   mat_quant(t,:)=mat_quant(t,:)+addv; 
end

% Prepare plot matrix for its use with the area function
matm=mat_quant;
for i=2:size(matm,2)
    matm(:,i)=matm(:,i)-mat_quant(:,i-1);
end

figure

% Generate plot
h=area(matm);
r=.2;
b=0;
set(h,'LineStyle','none')
set(h(1),'FaceColor',[1 1 1]) % white
set(h(2),'FaceColor',[r .99 b])
set(h(3),'FaceColor',[r .975 b])
set(h(4),'FaceColor',[r .95 b])
set(h(5),'FaceColor',[r .9 b])
set(h(6),'FaceColor',[r .85 b])
set(h(7),'FaceColor',[r .8 b])
set(h(8),'FaceColor',[r .75 b])
set(h(9),'FaceColor',[r .7 b])
set(h(10),'FaceColor',[r .65 b]) %
set(h(11),'FaceColor',[r .65 b])%
set(h(12),'FaceColor',[r .7 b])
set(h(13),'FaceColor',[r .75 b])
set(h(14),'FaceColor',[r .8 b])
set(h(15),'FaceColor',[r .85 b])
set(h(16),'FaceColor',[r .9 b])
set(h(17),'FaceColor',[r .95 b])
set(h(18),'FaceColor',[r .975 b])
set(h(19),'FaceColor',[r .99 b])
hold on
plot(mat_quant(:,10),'-k');  % median forecast in black
set(gcf,'Color','w')
xlim([-.5 Ttot+.5])
% Ticks x-axis
if exist('datefinal')==1 %#ok<EXIST>
    set(gca,'XTick',sg)
    set(gca,'XTickLabel',dvec(sg,1))
end
% Title+labels
title(ftitle)
ylabel(targetvar)