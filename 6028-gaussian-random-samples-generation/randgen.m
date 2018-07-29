% randgen(mu,mu1,mu2,cov1,cov2,cov3) = Random generation of Gaussian Samples
% in d-dimensions where d = 2
% mu, mu1, mu2 = (x,y) coordinates(means) that the gaussian samples are centered around
% cov1, cov2, cov3 are the covariance matrices and will vary changing the
% shape of the distribution, example: cov = sigma^2*Identity Matrix, where sigma^2 = a scalar
% N = the number of gaussian samples used are provided as user input,
% A test set of N/2 and a training set of N/2 gaussian samples is also generated 
% Output is directed to the command window and a plot of the distributions are generated 
% example1: randgen([4 5],[9 0;0 9],[10 15],[6 0;0 6],[15 10],[4 0;0 4]) or
% example2: randgen([4 5],[9, 0; 0 9],[10 15],[5, 1.5; 1, 5.5],[15 10],[6, -1; -1, 4]) 
% by John Shell

function randgen(mu1,cov1,mu2,cov2,mu3,cov3)

if (nargin == 1)
    fprintf('Error, number of arguments must be at least 2.\n');
    end
if (nargin == 2)
    mu2 = mu1; cov2 = cov1; mu3 = mu1; cov3 = cov1;
end
if (nargin == 3)
    fprintf('Error, number of arguments must be at least 4.\n');
end
if (nargin == 4)
   mu3 = mu2; cov3 = cov2;
end
if (nargin == 5)
    fprintf('Error, number of arguments must be at least 6.\n');
end

d = 2;
N = input('\nPlease enter the number of samples(N) then press enter:   ')
if (N < 4)
    fprintf('\nNumber of samples should be at least 4.\n');
    N = 3;
end
if (mod(N,2) ~= 0)
    fprintf('\nDefaulting to even number of samples.\n\n');
    N = N + 1;
end

z = randn(N, d);                    %  N x d, 
meanz = mean(z)';                   %  d x 1
covz = cov(z);                      %  1 x d
meanz2 = [meanz meanz];             %  d x d
mu11 = mu1'; mu22 = mu2'; mu33 = mu3';
mu1 = [mu11 mu11];                  %  d x d
mu2 = [mu22 mu22];                  %  d x d
mu3 = [mu33 mu33];                  %  d x d

[row, col] = size(z');
[row1, col1] = size(meanz2);

while col1 ~= col
    meanz2 = [meanz2 meanz];
    mu1 = [mu1 mu11];
    mu2 = [mu2 mu22];
    mu3 = [mu3 mu33];
    col1 = col1 + 1;
end

[zvects, zeigs] = eig(covz);        % eigenvectors = d x d , eigenvalues = d x d, (lambdas=diagonals)
[x1vects, x1eig] = eig(cov1);
[x2vects, x2eig] = eig(cov2);
[x3vects, x3eig] = eig(cov3);
yp = (zvects * zeigs ^ (-.5))'*z'- meanz2;            % A Whitening Transform for zero means correction
x1 = (((x1vects * x1eig^(-.5))')^-1) * yp + mu1;      % d x N, the inverse Whitening to center the dist. to means 
x2 = (((x2vects * x2eig^(-.5))')^-1) * yp + mu2;      % d x N, the inverse Whitening to center the dist. to means
x3 = (((x3vects * x3eig^(-.5))')^-1) * yp + mu3;      % d x N, the inverse Whitening to center the dist. to means       
x1p = x1'; x2p = x2'; x3p = x3';
meanx1 = mean(x1p);                         % d x d
covx1 = cov(x1p);
meanx2 = mean(x2p);
covx2 = cov(x2p);
meanx3 = mean(x3p);
covx3 = cov(x3p);
fprintf('The calculated mean for mu1 is [%2.4f %2.4f]\n',meanx1);
fprintf('The calculated value for cov1 is [%2.4f, %1.4f; %1.4f %2.4f]\n',covx1);
fprintf('The calculated mean for mu2 is [%2.4f %2.4f]\n',meanx2);
fprintf('The calculated value for cov2 is [%2.4f, %1.4f; %1.4f %2.4f]\n',covx2);
fprintf('The calculated mean for mu3 is [%2.4f %2.4f]\n',meanx3);
fprintf('The calculated value for cov3 is [%2.4f, %1.4f; %1.4f %2.4f]\n\n',covx3);

figure(1)
hold on
plot(x1(1,:),x1(2,:),'.r')
plot(x2(1,:),x2(2,:),'.g')
plot(x3(1,:),x3(2,:),'.b')
    title('2 dimensional gaussian samples'),
    xlabel('x1'),ylabel('x2');
hold off;

z1 = reshape(z, N/2, 4);
ztrain = z1(:,1:2);
ztest = z1(:,3:4);
ztrainmean = mean(ztrain);
ztestmean = mean(ztest);
covztrain = cov(ztrain);
covztest = cov(ztest);
fprintf('The mean of the training set is [%1.4f %1.4f].\n',ztrainmean);
fprintf('The covariance of the training set is [%1.4f %1.4f; %1.4f %1.4f].\n',covztrain);
fprintf('The mean of the test set is [%1.4f %1.4f].\n',ztestmean);
fprintf('The covariance of the test set is [%1.4f %1.4f; %1.4f %1.4f].\n',covztest);

