% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



% simulate the jump times
% add zero to the arrival times for nicer plots
  NSim = 5;
  T = 10;
  lambda = .81;
 
  % sums of exponentialy distributed interarrival times
  % as matrix columns
  i = 1;
  % cells array method is faster than appending numerical arrays 
  % for large numbers!
  tic;
%   JT = {};
%   JT{i,1} = zeros(1,NSim);
%   while (min(JT{i,1})<=T) % wait until the last process arrival is bigger than T
%    JT{i+1,1} = JT{i,1} - log(rand(1,NSim))/lambda;
%    i = i+1;
%   end
%    JumpTimes = cell2mat(JT);

  JumpTimes = zeros(1, NSim);
  while (min(JumpTimes(i,:))<=T) % wait until the last process arrival is bigger than T
    newrand = -log(rand(1,NSim))/lambda;
    JumpTimes = [JumpTimes; JumpTimes(i, :) + newrand];  
    i = i+1;
  end
 
  toc  
  % plot the counting processes
  stairs1 = stairs(JumpTimes);%, 0:size(tarr, 2)-1);
  
set(stairs1(1),'Marker','diamond');
set(stairs1(2),'Marker','hexagram');
set(stairs1(3),'Marker','square');
set(stairs1(4),'Marker','pentagram');
set(stairs1(5),'Marker','o','Color',[0.749 0 0.749]);

% Create xlabel
xlabel('time');

% Create ylabel
ylabel('value');

% Create title
title('Poisson Process with \lambda = 0.1 - The Jump Times -','FontWeight','bold','FontSize',12,...
    'FontName','Arial');


%% Fixed Grid
NSim = 5;
NTimes = 10;
Delta = T/NTimes;
xvals = ones(1,NTimes+1);
xvals = Delta*(cumsum(xvals)-1);
FixedGrid = zeros(NSim,NTimes+1);

for k = 2:NTimes+1
    N = random('poiss',lambda*Delta,NSim,1);
    FixedGrid(:,k) = FixedGrid(:,k-1)+N;
end
figure; stairs2=stairs(xvals',FixedGrid');
set(stairs2(1),'Marker','diamond');
set(stairs2(2),'Marker','hexagram');
set(stairs2(3),'Marker','square');
set(stairs2(4),'Marker','pentagram');
set(stairs2(5),'Marker','o','Color',[0.749 0 0.749]);
% Create xlabel
xlabel('time');

% Create ylabel
ylabel('value');

% Create title
title('Poisson Process with \lambda = 0.1 - The Fixed Grid -','FontWeight','bold','FontSize',12,...
    'FontName','Arial');
