function [List,f1,x] = find_normal_distribution(N, mean, sigma, increments)

%N = 1000; increments = 25; mean = 0; sigma = 1;

%% Create normal distribution
% Probability density function
x = linspace(-3*sigma,3*sigma,increments); 
a = sigma*sqrt(2*pi);
b = 2*sigma^2;
f = 1/a*exp((-(x-mean).^2)/b);
n = find(f>max(f)/100); f = f(n); x = x(n);
%plot(x,f,'-o'); hold on;

f = f.*N/sum(f);
f1 = floor(f);
f2 = mod(f,f1);

while sum(f1) < N
    n = f2==max(f2);
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
