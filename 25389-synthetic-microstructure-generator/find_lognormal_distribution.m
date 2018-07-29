function [List,f1,x] = find_lognormal_distribution(N, mean, sigma, increments)

% ---------------------------------------------------------
%  http://en.wikipedia.org/wiki/Beta_distribution
% ---------------------------------------------------------
%N = 1000; increments = 25; mean = 1; sigma = 0.25

%% Create normal distribution
% Probability density function
x = linspace(0.01,100,1000); 
f = 1./(x*sigma*sqrt(2*pi)).*exp(-((log(x)-mean).^2)/(2*sigma^2));
n = find(f~=inf); f = f(n); x = x(n);
f = round(1000*f)/1000;
x = x(f~=0); x_max = x(end);
x = linspace(0.01,x_max,increments); 
f = 1./(x*sigma*sqrt(2*pi)).*exp(-((log(x)-mean).^2)/(2*sigma^2));
n = find(f~=0); f = f(n); x = x(n);
%plot(x,f,'-o'); hold on;

f = f.*N/sum(f);
f1 = floor(f);
f2 = mod(f,f1);

while sum(f1)<N
    n = find(f2==max(f2));
    f1(n) = f1(n)+1;
    f2(n) = 0;
end

% Create list of sizes
nparticles = 0;
increment = diff(x(1:2));
List = zeros(N,1);
for i = 1:length(f1)
    if f1(i)~=0;
        n = rand(f1(i),1) * increment + x(i) - increment * 0.5;
        List(nparticles+1:nparticles+f1(i)) = n;
        nparticles = nparticles + f1(i);
    end
end
%figure;hist(List,x);hold on;plot(x,f1,'-or');


