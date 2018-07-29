% -----------------------------------------------------------------  %
% Matlab Programs included the Appendix B in the book:               %
%  Xin-She Yang, Engineering Optimization: An Introduction           %
%                with Metaheuristic Applications                     %
%  Published by John Wiley & Sons, USA, July 2010                    %
%  ISBN: 978-0-470-58246-6,   Hardcover, 347 pages                   %
% -----------------------------------------------------------------  %
% Citation detail:                                                   %
% X.-S. Yang, Engineering Optimization: An Introduction with         %
% Metaheuristic Application, Wiley, USA, (2010).                     %
%                                                                    % 
% http://www.wiley.com/WileyCDA/WileyTitle/productCd-0470582464.html % 
% http://eu.wiley.com/WileyCDA/WileyTitle/productCd-0470582464.html  %
% -----------------------------------------------------------------  %
% ===== ftp://  ===== ftp://   ===== ftp:// =======================  %
% Matlab files ftp site at Wiley                                     %
% ftp://ftp.wiley.com/public/sci_tech_med/engineering_optimization   %
% ----------------------------------------------------------------   %


% Harmony Search (Demo) by X-S Yang (Cambridge University @ 2008 )   %
% Usage: B4_hs                                                       %
% or     B4_hs('(x-1)^2+100*(y-x^2)^2',25000);                       %
% -----------------------------------------------------------------  %

function [solution,fbest]=B4_hs(funstr,MaxAttempt)
disp('It may take a few minutes ...');
% MaxAttempt=25000;  % Max number of Attempt
if nargin<2, MaxAttempt=25000; end
if nargin<1,
% Rosenbrock's Banana function with the
% global fmin=0 at (1,1).
funstr = '(1-x1)^2+100*(x2-x1^2)^2';
end
% Converting to an inline function
f=vectorize(inline(funstr));
ndim=2;  %Number of independent variables
% The range of the objective function
range(1,:)=[-5 5]; range(2,:)=[-5 5];
% Pitch range for pitch adjusting
pa_range=[100 100];
% Initial parameter setting
HS_size=20;        %Length of solution vector
HMacceptRate=0.95; %HM Accepting Rate
PArate=0.7;        %Pitch Adjusting rate
% Generating Initial Solution Vector
for i=1:HS_size,
   for j=1:ndim,
   x(j)=range(j,1)+(range(j,2)-range(j,1))*rand;
   end
   HM(i, :) = x;
   HMbest(i) = f(x(1), x(2));
end %% for i
% Starting the Harmony Search
for count = 1:MaxAttempt,
  for j = 1:ndim,
    if (rand >= HMacceptRate)
      % New Search via Randomization
      x(j)=range(j,1)+(range(j,2)-range(j,1))*rand;
    else
      % Harmony Memory Accepting Rate
      x(j) = HM(fix(HS_size*rand)+1,j);
      if (rand <= PArate)
      % Pitch Adjusting in a given range
      pa=(range(j,2)-range(j,1))/pa_range(j);
      x(j)= x(j)+pa*(rand-0.5);
      end
    end
  end %% for j
  % Evaluate the new solution
   fbest = f(x(1), x(2));
  % Find the best in the HS solution vector
   HSmaxNum = 1; HSminNum=1;
   HSmax = HMbest(1); HSmin=HMbest(1);
   for i = 2:HS_size,
      if HMbest(i) > HSmax,
        HSmaxNum = i;
        HSmax = HMbest(i);
      end
      if HMbest(i)<HSmin,
         HSminNum=i;
         HSmin=HMbest(i);
      end
   end
   % Updating the current solution if better
   if fbest < HSmax,
       HM(HSmaxNum, :) = x;
       HMbest(HSmaxNum) = fbest;
   end
   solution=x;   % Record the solution
end %% for count (harmony search)

