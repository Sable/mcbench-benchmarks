function [grid1, grid2, freq1, freq2, biv, cond2on1, cond1on2, cexp1, cexp2] = bivkernrest(data1,data2,res1,res2,observed)
%[grid1, grid2, freq1, freq2, biv, cond2on1, cond1on2, cexp1, cexp2] = bivkern(data1,data2,res1,res2)
%data1,2 = data for which a kernel density needs to be derived
%res1,2 = step size
%observed = vector of dummies that identifies which elements of data1,2 are
%observations (1) rather than restrictions (0)
%
%restrictions are added by extending the data vectors with
%data1(i) = y for data2(i) = x, observed(i) = 0
%for example, data1(17) = 0, data2(17) = 0, observed(17) = 0
%
%Richard Tol, 13 September 2013

tic

ampl = 0.1; %bandwidth of the restriction
range = 4;  %data are evaluated between minimum minus range*standard deviation and maximum plus range*standard deviation

data1std = std(data1(observed==1));
data1min = res1*round((min(data1(observed==1)) - range*data1std)/res1); %minimum at observed minus range*standard deviation
data1min = max(0,data1min);
data1max = res1*((max(data1(observed==1)) + range*data1std)/res1); %maximum at observed plus range*standard deviation
nopnt = length(data1);
nocon = nopnt - sum(observed);
noobs = nopnt - nocon;

data2std = std(data2(observed==1));
data2min = res2*round((min(data2(observed==1)) - range*data2std)/res2); %minimum at observed minus range*standard deviation
%data2min = max(0,data2min);
data2max = res2*round((max(data2(observed==1)) + range*data2std)/res2); %maximum at observed plus range*standard deviation

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

%bandwith
sigma = cov(data1(observed==1), data2(observed==1))*1.06^2*noobs^-0.4;
h = inv(sigma);
h1 = 1.06 * noobs^-0.2 * std(data1); %for univariate
h2 = 1.06 * noobs^-0.2 * std(data2); %for univariate

%normal kernel
biv = zeros(nogrid1,nogrid2);
vbiv = biv;
vfreq1 = ones(nogrid1,noobs);
vfreq2 = ones(nogrid2,noobs);
x= zeros(2,1);
for i=1:nopnt,
    %disp(i);
    vfreq1(:,i) = exp(-0.5*((grid1-data1(i))/(h1*observed(i)+ampl*h1*(1-observed(i)))).^2)/(h1*observed(i)+ampl*h1*(1-observed(i)))/sqrt(2*pi);
    vfreq2(:,i) = exp(-0.5*((grid2-data2(i))/(h2*observed(i)+ampl*h2*(1-observed(i)))).^2)/(h2*observed(i)+ampl*h2*(1-observed(i)))/sqrt(2*pi);
    dev1 = grid1-data1(i);
    dev2 = grid2-data2(i);
    for k=1:nogrid1,
        for l=1:nogrid2,
            x1 = dev1(k);
            x2 = dev2(l);
            vbiv(k,l) = exp(-0.5*((h(1,1)*observed(i)+h(1,1)/ampl*(1-observed(i)))*x1^2 + (h(2,2)*observed(i)+h(2,2)/ampl*(1-observed(i)))*x2^2 + (h(1,2)*observed(i)+h(1,2)/ampl*(1-observed(i)))*x1*x2));
        end
    end
    biv = biv + vbiv/sum(sum(vbiv));
end
biv = biv/sum(sum(biv));
freq1 = sum(vfreq1,2);
freq1 = freq1/sum(freq1);
freq2 = sum(vfreq2,2);
freq2 = freq2/sum(freq2);

cond2on1=biv./repmat(sum(biv,2),1,nogrid2);
cond1on2=biv./repmat(sum(biv,1),nogrid1,1);
cond1on2=cond1on2';

cexp1 = sum(cond1on2.*repmat(grid1,1,nogrid2)',2);
cexp2 = sum(cond2on1.*repmat(grid2',nogrid1,1),2);

toc

end