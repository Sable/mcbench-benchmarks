function output = bivkern(data1,data2)
%output = bivkern(data1,data2)
%
%Bivariate (quantile) kernel regression
%
%Gaussian kernel, Silverman bandwidth
%
%data1,2 = data for which a kernel density needs to be derived
%
%output is a structure with the following fields
%output.grid1,2 = grid for which the kernel density is evaluated
%grid runs from max(0, min(data) - std(data)) to max(data) + std(data)
%at the moment, grid is hardwired, but adjusting the code is trivial
%the step size of the grids is defined by res1,2; hardwired for now
%
%output.freq1,2 = marginal kernel densities
%output.biv = bivariate kernel density
%output.cond1on2,2on1 = conditional kernel densities
%output.cexp1,2 = conditional expectations, aka Nadaraya-Watson kernel regression
%output.cumcond1on2,2on1 = conditional cumulative kernel densities
%output.lower1,2 = conditional 1th percentile
%at the moment, the 1%ile is hardwired, but adjusting the code is trivial
%output.upper1,2 = conditional 99th percentile
%at the moment, the 99%ile is hardwired, but adjusting the code is trivial
%
%Richard Tol, 13 September 2013

tic

%step size
res1 = 1;
res2 = 2;

%the grid ranges from the observed minimum minus RANGE times the standard deviation to the observed maximum plus RANGE time the standard deviation
range1 = 1; 
range2 = 1;

%the grid ranges from MIN to MAX; the constraints are applied after RANGE
min1 = 0;
max1 = inf;
min2 = 0;
max2 = inf;

%low and up set the percentiles of the lower and upper bounds of the
%confidence interval
low1 = 0.01;
low2 = 0.01;
up1 = 0.99;
up2 = 0.99;

%data range
data1std = std(data1);
data1min = res1*round((min(data1) - range1*data1std)/res1); %minimum at observed minus standard deviation
data1min = max(min1,data1min);
data1max = res1*((max(data1) + range1*data1std)/res1); %maximum at observed plus standard deviation
data1max = min(data1max,max1);
noobs = length(data1);

data2std = std(data2);
data2min = res2*round((min(data2) - range2*data2std)/res2); %minimum at observed minus standard deviation
data2min = max(min2,data2min);
data2max = res2*round((max(data2) + range2*data2std)/res2); %maximum at observed plus standard deviation
data2max = min(data2max,max2);

%make grid
nogrid1 = round((data1max-data1min)/res1);
grid1 = zeros(nogrid1,1);
grid1(1) = data1min;
for i=2:nogrid1
    grid1(i) = grid1(i-1) + res1;
end

nogrid2 = round((data2max-data2min)/res2);
grid2 = zeros(nogrid2,1);
grid2(1) = data2min;
for i=2:nogrid2
    grid2(i) = grid2(i-1) + res2;
end

output = struct('grid1',grid1,'grid2',grid2);

%bandwith
sigma = cov(data1, data2)*1.06^2*noobs^-0.4;
h = inv(sigma);
%h(2,1)= 0;
%h(1,2)= 0;
scale = 2*pi*sqrt(det(sigma));
scale = 1/scale;
h1 = 1.06 * noobs^-0.2 * std(data1);
h2 = 1.06 * noobs^-0.2 * std(data2);

%normal kernel
biv = zeros(nogrid1,nogrid2);
vbiv = biv;
vfreq1 = ones(nogrid1,noobs);
vfreq2 = ones(nogrid2,noobs);
x= zeros(2,1);
for i=1:noobs,
    %disp(i);
    vfreq1(:,i) = exp(-0.5*((grid1-data1(i))/h1).^2)/h1/sqrt(2*pi);
    vfreq2(:,i) = exp(-0.5*((grid2-data2(i))/h2).^2)/h2/sqrt(2*pi);
    dev1 = grid1-data1(i);
    dev2 = grid2-data2(i);
    for k=1:nogrid1,
        for l=1:nogrid2,
            x(1) = dev1(k);
            x(2) = dev2(l);
            ssr = -0.5*(h(1,1)*x(1)^2 + h(2,2)*x(2)^2 + h(1,2)*x(1)*x(2));
            vbiv(k,l) = exp(ssr)*scale;
        end
    end
    biv = biv + vbiv;
end
biv = biv/sum(sum(biv));
freq1 = sum(vfreq1,2);
freq1 = freq1/sum(freq1);
freq2 = sum(vfreq2,2);
freq2 = freq2/sum(freq2);

output = setfield(output,'freq1',freq1);
output = setfield(output,'freq2',freq2);
output = setfield(output,'biv',biv);

cond2on1=biv./repmat(sum(biv,2),1,nogrid2);
cond1on2=biv./repmat(sum(biv,1),nogrid1,1);
cond1on2=cond1on2';

output = setfield(output,'cond1on2',cond1on2);
output = setfield(output,'cond2on1',cond2on1);

cexp1 = sum(cond1on2.*repmat(grid1,1,nogrid2)',2);
cexp2 = sum(cond2on1.*repmat(grid2',nogrid1,1),2);

output = setfield(output,'cexp1',cexp1);
output = setfield(output,'cexp2',cexp2);

cumcond1on2 = cond1on2;
for i=2:nogrid1,
    cumcond1on2(:,i) = cumcond1on2(:,i-1) + cond1on2(:,i);
end;

cumcond2on1 = cond2on1;
for i=2:nogrid2,
    cumcond2on1(:,i) = cumcond2on1(:,i-1) + cond2on1(:,i);
end;

output = setfield(output,'cumcond1on2',cumcond1on2);
output = setfield(output,'cumcond2on1',cumcond2on1);

lower1 = zeros(nogrid2,1);
test = cumcond1on2 > low1;
tsum = nogrid1+1-sum(test,2);
for i=1:nogrid2,
    lower1(i)=grid1(tsum(i));
end

output = setfield(output,'lower1',lower1);

lower2 = zeros(nogrid1,1);
test = cumcond2on1 > low2;
tsum = nogrid2+1-sum(test,2);
for i=1:nogrid1,
    lower2(i)=grid2(tsum(i));
end

output = setfield(output,'lower2',lower2);

upper1 = zeros(nogrid2,1);
test = cumcond1on2 > up1;
tsum = nogrid1+2-sum(test,2);
for i=1:nogrid2,
    upper1(i)=grid1(tsum(i));
end

output = setfield(output,'upper1',upper1);

upper2 = zeros(nogrid1,1);
test = cumcond2on1 > up2;
tsum = nogrid2+2-sum(test,2);
for i=1:nogrid1,
    upper2(i)=grid2(tsum(i));
end

output = setfield(output,'upper2',upper2);

toc

end