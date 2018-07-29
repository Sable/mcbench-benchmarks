% Demo script for software from the paper
% 'Generating spike-trains with specified correlations',
%  Macke et al., submitted for publication, 2008
%
% www.kyb.mpg.de/bethgegroup/code/efficientsampling
%
% Instructions:
%  - Change to the code directory and run demo.m
%  - The script will take you through the functions .
%  - After each step, the script will pause. 
%  - To continue, hit any button.
%  - Read along in the demo.m file to follow what's happening.
%
% If you have questions, feel free to email us.

f = 1;
fprintf('\nDemo program for GENERATING SPIKE TRAINS WITH SPECIFIED CORRELATIONS, Macke et al.\n')


%% Step 1: Generating correlated binary variables (2D example)
mu = [.4,.3]';      % set the mean
v = mu.*(1-mu);     % calculate the variances
C = diag(v);        % build covariance matrix
C(1,2) = .1;
C(2,1) = .1;

[S,g,L] = sampleDichGauss01(mu,C,1e5);   % generate samples from the DG model

muHat = mean(S,2);  % estimate mean
CHat = cov(S');     % estimate covariance

fprintf('\nStep 1: Generating correlated binary variables (section 2.1)\n\n')
fprintf('Target mean X1:  %.2f     Estimated mean X1:  %.3f\n',mu(1),muHat(1))
fprintf('Target mean X2:  %.2f     Estimated mean X2:  %.3f\n',mu(2),muHat(2))
fprintf('Target cov X1X2: %.2f     Estimated cov X1X2: %.3f\n',C(1,2),CHat(1,2))

disp('To proceed to compare histograms, hit any key...')
pause

%% Step 2: How much do correlations change the distribution when means are
% assumed to be equal?

fprintf('\nStep 2: Effect of correlations\n\n')
fprintf('Computing...\n')

% First, we generate a mean vector in ten dimensions. We assume that all
% means are approximately .5, but we add some Gaussian noise to the network
% is not to uniform. We set the covariances so that the resulting
% correlations are sizable, but not to large (~0.1). 

mu = ones(10,1) * .2 + randn(10,1)*0.05;
v = mu.*(1-mu);
C = ones(10,10) * .02;
C(eye(size(C))==1) = v;

% We find the histogram of the independent distribution with this mean
% vector P(x) = PROD_i P(X_i=1) and the DG distribution with the same mean
% and the covariances as defined above.

h1 = binHistIndep(mu);    % returns the histogram of an independet distribution
S = sampleDichGauss01(mu,C,1e5);
h2 = binHist(S);          % creates a histogram of the binary patterns in S
h2 = h2 / sum(h2);

% When we compare them, we see that some patterns occur much more often 
% in the correlated then in the independent distribution. This a clear
% indication of the strength of the correlations. The "stripes" coincide
% with patterns with a different number of active neurons (starting at 0 in
% the upper left corner).

figure(f)
loglog(h1,h2,'k.')
xlabel('P(X) in independent model')
ylabel('P(X) in DG model')
title('Step 2: What effect do correlations have?')
axis square

f = f+1;


disp('To proceed to generate Poisson RVs, hit any key...')
pause

%% Step 3: Correlated Poisson from a binary process (3.1)
% First, we generate samples from a correlated Poisson distribution with
% specified mean and covariance matrix. The covariance between the two
% distributions is positive and quite strong. The construction follows the
% description in section 3.1, i.e. we first find a binary process with the
% correct parameters and sum over it. This means we create
% a joint Poisson distribution.

fprintf('\nStep 3: Correlated Poisson from a binary process (3.1)\n\n')
fprintf('Computing...\n')

mu = [7,9]';      % set the mean
C = [7 3;3 9];    % set an admissable covariance matrix

S = sampleCovPoisson(mu,C,10000);   % generate sample via discretized Gaussian

% We obtain a set of samples S. Next, we verify that the samples have 
% desired mean and covariance structure. We see that this is indeed the case.

muHat = mean(S,2);
CHat = cov(S');

fprintf('Target mean X1:  %.2f     Estimated mean X1:  %.3f\n',mu(1),muHat(1))
fprintf('Target mean X2:  %.2f     Estimated mean X2:  %.3f\n',mu(2),muHat(2))
fprintf('Target cov X1X2: %.2f     Estimated cov X1X2: %.3f\n',C(1,2),CHat(1,2))

disp('To plot the marginals and joint histogram, hit any key...')
pause
fprintf('Computing...\n')

figure (f)

% Now, we look at the marginal distribution we obtain from our sampling
% procedure. For comparison, we also plot the true 1D Poisson distributions
% as specified by the mean of the marginal (dotted). We see that they are
% very close to one another. 

h1 = histc(S(1,:),0:30); h1 = h1/sum(h1);
h2 = histc(S(2,:),0:30); h2 = h2/sum(h2);

subplot(1,2,1)
plot(0:length(h1)-1,h1,'-r','markersize',5), hold on
plot(0:length(h1),poisspdf(0:length(h1),mu(1)),'.r','markersize',5)
plot(0:length(h2)-1,h2,'-g','markersize',5)
plot(0:length(h1),poisspdf(0:length(h1),mu(2)),'.g','markersize',5)
t = legend('X_1','X_1 Poisson','X_2','X_2 Poisson');
set(t,'box','off')
axis square
xlabel('X'), ylabel('P(X)')
title(sprintf('Step 3: Correlated Poisson, Positive Correlation\nMarginal Distributions with Poisson\n distribution with correct mean'))

% Finally, we convince ourselves that the two variables are indeed
% positively correlated by looking at the 2D joint histogram. We can see
% that although the marginals are perfect Poissonian, most samples are
% concentrated along the main diagonal, indicating the positive
% correlation.

subplot(1,2,2)
hh = EstimateDiscreteJoint(S);
imagesc(hh)
axis square
title('')
xlabel('X_1'), ylabel('X_2')

disp('To proceed to positively correlated Poisson variables with another method, hit any key...')
pause


f = f+1;


%% Step 4: Generating correlated Poisson variables via the method 
% in section 3.3 for positive correlations
%
% Again, we generate samples from a correlated Poisson distribution with
% specified mean and covariance matrix. The covariance between the two
% distributions is positive and quite strong. The construction follows now
% section 3.3, so we truncate a Gaussian to obtain a distribution with
% Poisson marginals and a given covariance.

fprintf('\nStep 4: Generating positively correlated Poisson variables (section 3.3)\n\n')
fprintf('Computing...\n')

mu = [7,9]';      % set the mean
C = [7 3;3 9];    % set an admissable covariance matrix

[S,gamma,Lambda,joints2D] = DGPoisson(mu,C,1e5);   % generate sample via discretized Gaussian

% We obtain a set of samples S, the parameters of the hidden Gaussian
% variable (gamma and Lambda) and a structure containing the marginal
% distributions as well as the 2D joint distribution

% Next, we verify that the samples have desired mean and covariance
% structure. We see that this is indeed the case.

muHat = mean(S,2);
CHat = cov(S');


fprintf('Target mean X1:  %.2f     Estimated mean X1:  %.3f\n',mu(1),muHat(1))
fprintf('Target mean X2:  %.2f     Estimated mean X2:  %.3f\n',mu(2),muHat(2))
fprintf('Target cov X1X2: %.2f     Estimated cov X1X2: %.3f\n',C(1,2),CHat(1,2))

disp('To plot the marginals and joint histogram, hit any key...')
pause

figure(f)

% Now, we look at the marginal distribution we obtain from our sampling
% procedure. For comparison, we also plot the true 1D Poisson distributions
% as specified by the mean of the marginal (dotted). We see that they are
% very close to one another. 

subplot(2,2,1)
h1 = joints2D{1,1};   % marginal of X_1
h2 = joints2D{2,2};   % marginal of X_2
plot(0:length(h1)-1,h1,'-r','markersize',5), hold on
plot(0:length(h1),poisspdf(0:length(h1),mu(1)),'.r','markersize',5)
plot(0:length(h2)-1,h2,'-g','markersize',5)
plot(0:length(h1),poisspdf(0:length(h1),mu(2)),'.g','markersize',5)
t = legend('X_1','X_1 Poisson','X_2','X_2 Poisson');
set(t,'box','off')
axis square
xlabel('X'), ylabel('P(X)')
title(sprintf('Step 4: Correlated Poisson, Positive Correlation\nMarginal Distributions with Poisson\n distribution with correct mean'))

% Finally, we convince ourselves that the two variables are indeed
% positively correlated by looking at the 2D joint histogram. We can see
% that although the marginals are perfect Poissonian, most samples are
% concentrated along the main diagonal, indicating the positive
% correlation.

subplot(2,2,3)
hh = joints2D{2};   % joint histogram
imagesc(hh)
axis square
title('')
xlabel('X_1'), ylabel('X_2')

disp('To proceed to negatively correlated Poisson variables, hit any key...')
pause

%% Step 5: Generating correlated Poisson variables via the method 
% in section 3.3 for negative correlations
%
% Again, we generate samples from a correlated Poisson distribution with
% specified mean and covariance matrix. This time the covariance is
% negative though.

fprintf('\nStep 5: Generating negatively correlated Poisson variables (section 3.3)\n\n')
fprintf('Computing...\n')

mu = [7,9]';      % set the mean
C = [7 -3;-3 9];    % set an admissable covariance matrix

[S,gamma,Lambda,joints2D] = DGPoisson(mu,C,1e5);   % generate sample via discretized Gaussian

% Next, we verify that the samples have desired mean and covariance
% structure. We see that this is indeed the case. 

muHat = mean(S,2);
CHat = cov(S');

fprintf('Target mean X1:  %.2f     Estimated mean X1:  %.3f\n',mu(1),muHat(1))
fprintf('Target mean X2:  %.2f     Estimated mean X2:  %.3f\n',mu(2),muHat(2))
fprintf('Target cov X1X2: %.2f     Estimated cov X1X2: %.3f\n',C(1,2),CHat(1,2))

disp('To plot the marginals and joint histogram, hit any key...')
pause

figure(f)

% Again we compare the marginal distributions to the Poisson distribution
% with the same mean and we find them matching very well.

subplot(2,2,2)
h1 = joints2D{1,1};   % marginal of X_1
h2 = joints2D{2,2};   % marginal of X_2
plot(0:length(h1)-1,h1,'-r','markersize',5), hold on
plot(0:length(h1),poisspdf(0:length(h1),mu(1)),'.r','markersize',5)
plot(0:length(h2)-1,h2,'-g','markersize',5)
plot(0:length(h1),poisspdf(0:length(h1),mu(2)),'.g','markersize',5)
t = legend('X_1','X_1 Poisson','X_2','X_2 Poisson');
set(t,'box','off')
axis square
xlabel('X'), ylabel('P(X)')
title(sprintf('Step 5: Correlated Poisson, Negative Correlation\nMarginal Distributions with Poisson\n distribution with correct mean'))

% Nevertheless, the samples have a different structure as we can see from
% the 2D joint histogram. This time, the two variables are negatively
% correlated and when X_1 tends to take large values, X_2 tends to take low
% ones. 

subplot(2,2,4)
hh = joints2D{2};   % joint histogram
imagesc(hh)
axis square
title('')
xlabel('X_1'), ylabel('X_2')



