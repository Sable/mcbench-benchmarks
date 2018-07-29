function [x,fval,gfx,output]=hPSO(fitnessfun,nvars,options,varargin)
%Syntax: [x,fval,gfx,output]=hPSO(fitnessfun,nvars,options,varargin)
%___________________________________________________________________
%
% A hybrid Particle Swarm Optimization algorithm for finding the minimum of
% the function 'fitnessfun' in the real space.
%
% x is the scalar/vector of the functon minimum
% fval is the function minimum
% gfx contains the best particle for each flight (columns 2:end) and the
%  corresponding solutions (1st column)
% output structure contains the following information
%   reason : is the reason for stopping
%   flights: the nuber of flights before stopping
%   time   : the total time before stopping
% fitnessfun is the function to be minimized
% nvars is the number of variables of the problem
% options are specified in the file "PSOoptions.m"
%
%
% Reference:
% Kennedy J., Eberhart R.C. (1995): Particle swarm optimization. In: Proc.
% IEEE Conf. on Neural Networks, IV, Piscataway, NJ, pp. 1942–1948
%
%
% Alexandros Leontitsis
% Department of Education
% University of Ioannina
% 45110- Dourouti
% Ioannina
% Greece
% 
% University e-mail: me00743@cc.uoi.gr
% Lifetime e-mail: leoaleq@yahoo.com
% Homepage: http://www.geocities.com/CapeCanaveral/Lab/1421
% 
% 17 Nov, 2004.


if nargin<3 | isempty(options)==1
    options=hPSOoptions;
end

if size(options.space,1)==1
    for i=1:nvars
        s(i,:)=options.space;
    end
    options.space=s;
elseif size(options.space,1)~=nvars
    error('The rows of options.space are not equal to nvars.');
end

if size(options.maxv,1)==1
    for i=1:nvars
        v(i,1)=options.maxv;
    end
    options.maxv=v;
elseif size(options.maxv,1)~=nvars
    error('The rows of options.maxv are not equal to nvars.');
end

c1 = options.c1;
c2 = options.c2;
w = options.w;
maxv = options.maxv;
space = options.space;
popul = options.bees;
flights = options.flights;
HybridIter = options.HybridIter;
Show = options.Show;
StallFliLimit = options.StallFliLimit;
StallTimeLimit = options.StallTimeLimit;
TimeLimit = options.TimeLimit;
Goal = options.Goal;

% Define the options for the hybrid approach
options = optimset('LargeScale','off','Display','off','MaxIter',HybridIter);

% Initial population (random start)
ru=rand(popul,size(space,1));
pop=ones(popul,1)*space(:,1)'+ru.*(ones(popul,1)*(space(:,2)-space(:,1))');


% Hill climb of each solution (bee)
for i=1:popul*sign(HybridIter)
    [pop(i,:),fxi(i,1)]=fminsearch(fitnessfun,pop(i,:),options,varargin{:});
end
pop=min(pop,ones(popul,1)*space(:,2)');
pop=max(pop,ones(popul,1)*space(:,1)');
fxi=feval(fitnessfun,pop,varargin{:});

% Local minima
p=pop;
fxip=fxi;

% Initialize the velocities
v=zeros(popul,size(space,1));

% Isolate the best solution
[Y,I]=min(fxi);
gfx(1,:)=[Y pop(I,:)];
P=ones(popul,1)*pop(I,:);

if Show>1 & strcmp(Show,'Final')==0
    fprintf('                                              \n');
    fprintf(' Flight #        GlobalMin       Stall Flight \n');
    fprintf('__________      ___________     ______________\n');
    fprintf('                                              \n');
end

tic;
Time = 0;
StallFli = 0;
output.reason = 'Optimization terminated: maximum number of flights reached.';

% For each flight
for i=2:flights
    
    % Estimate the velocities
    r1=rand(popul,size(space,1));
    r2=rand(popul,size(space,1));
    v=v*w+c1*r1.*(p-pop)+c2*r2.*(P-pop);
    v=max(v,-ones(popul,1)*maxv');
    v=min(v,ones(popul,1)*maxv');
    
    % Add the velocities to the population 
    pop=pop+v;
    
    % Drag the particles into the search space
    pop=min(pop,ones(popul,1)*space(:,2)');
    pop=max(pop,ones(popul,1)*space(:,1)');
    
    % Hill climb search for the new population
    pnew=p;
    fxipnew=fxip;
    for j=1:popul*sign(HybridIter)
        [pop(j,:),fxi(j,1)]=fminsearch(fitnessfun,pop(j,:),options,varargin{:});
        [pnew(j,:),fxipnew(j,1)]=fminsearch(fitnessfun,p(j,:),options,varargin{:});
    end
    pop=min(pop,ones(popul,1)*space(:,2)');
    pop=max(pop,ones(popul,1)*space(:,1)');
    pnew=min(pnew,ones(popul,1)*space(:,2)');
    pnew=max(pnew,ones(popul,1)*space(:,1)');
    fxi=feval(fitnessfun,pop,varargin{:});
    fxipnew=feval(fitnessfun,pnew,varargin{:});
    
    % Min(fxi,fxip)
    s=find(fxi<fxip);
    p(s,:)=pop(s,:);
    fxip(s)=fxi(s);
    
    % Min(fxipnew,fxip);
    s=find(fxipnew<fxip);
    p(s,:)=pnew(s,:);
    fxip(s)=fxipnew(s);
    
    % Isolate the best solution
    [Y,I]=min(fxip);
    gfx(i,:)=[Y p(I,:)];
    P=ones(popul,1)*p(I,:);
    
    % Show the progress
    if Show>1 & rem(i,Show)==0
        fprintf('  %4.0f           %8.4f           %4.0f\n',i,gfx(i,1),StallFli);
    end
    
    % Termination conditions
    if gfx(i,1)==gfx(i-1,1)
        StallFli = StallFli+1;
    else
        Time=Time+toc;
        tic;
    end    
    StallTime=toc;
    if StallTime>StallTimeLimit
        output.reason = 'Optimization terminated: Stall Time Limit exceeded.';
        break;
    end
    if Time>TimeLimit
        output.reason = 'Optimization terminated: Time Limit exceeded.';
        break;
    end
    if StallFli==StallFliLimit
        output.reason = 'Optimization terminated: Stall Flights Limit reached.';
        break;
    end
    if gfx(i,1)<=Goal
        output.reason = 'Optimization terminated: Goal reached or exceeded.';
        break;
    end
end

output.flights = i;
output.time = Time;

if Show>1 & strcmp(Show,'Final')==0
    fprintf('__________      ___________     ______________\n');
    fprintf('                                              \n');
elseif strcmp(Show,'Final')==1
    fprintf('Global minimum reached: %8.4f\n',gfx(end,1));
end

% Get the point that correspond to the minimum of the function
x=gfx(end,2:end);

% Get the minimum of the function
fval=gfx(end,1);