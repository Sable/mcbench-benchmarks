function [x,fval,gfx,output]=hill(fitnessfun,x0,options,varargin)
%Syntax: [x,fval,gfx,output]=hill(fitnessfun,x0,options,varargin)
%________________________________________________________________
%
% A hill climbing algorithm for finding the minimum of a function
% 'fitnessfun' in the real space.
%
% x is the scalar/vector of the functon minimum
% fval is the function minimum
% gfx contains the minimization solution each iteration (columns 2:end)
%  and the corresponding function evaluation (column 1)
% output structure contains the following information
%   reason : is the reason for stopping
%   MaxIter: the maximum climbs before stopping
%   time   : the total time before stopping
% fitnessfun is the function to be minimized
% x0 is the initial point
% options are specified in the file "hilloptions.m"
%
% Example:
%    function e = parabola(x,y)
%    e = sum(x.^2)+y;
%
%    options = hilloptions('space',[-ones(8,1) ones(8,1)]);
%    [x,fval,gfx,output]=hill(@parabola,rand(8,1),options,2.3); % y = 2.3
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
% Dec 8, 2004.


% Make x0 a column vector
x0=x0(:);

if nargin<3 | isempty(options)==1
    options=hilloptions;
end

if size(options.space,1)==1
    for i=2:length(x0)
        options.space(i,:)=options.space(1,:);
    end
elseif size(options.space,1)~=length(x0)
    error('The rows of options.space are not equal to the number of dimensions.');
end

space = options.space;
MaxIter = options.MaxIter;
prec = options.prec;
line = options.line;
Display = options.Display;
TimeLimit = options.TimeLimit;
Goal = options.Goal;

% Check if x0 is within the boundaries
if any(x0<space(:,1)) | any(x0>space(:,2))
    error('x0 is outside the space boundaries.');
end

if Display>0 & strcmp(Display,'Final')==0
    fprintf('                              \n');
    fprintf('   Iteration           f(x)   \n');
    fprintf('   __________      ___________\n');
    fprintf('                              \n');
end

tic;
Time = 0;
output.reason = 'Optimization terminated: maximum number of climbs reached.';

% Define the precision of each parameter
h=10^(-prec)*(space(:,2)-space(:,1));

gfx(1,:)=[feval(fitnessfun,x0,varargin{:}) x0(:)'];

ymin=-inf;

for i=1:MaxIter
    
    % Evaluate the fitness function
    y0=gfx(i,1);
    
    % Try a step on each dimension...
    for j=1:length(x0)
        
        x=x0;
        
        % ... towards -inf
        x(j)=max(space(j,1),x0(j)-h(j));
        ybefore(j)=feval(fitnessfun,x,varargin{:});
        
        % ... towards inf
        x(j)=min(x0(j)+h(j),space(j,2));
        yafter(j)=feval(fitnessfun,x,varargin{:});
        
    end
    
    % Choose the steepest step
    ybefore=ybefore-y0;
    yafter=yafter-y0;
    if length(x0)==1
        I1=[1 1];
        [ymin,I2]=min([ybefore;yafter]);
    else
        [ymin,I1]=min([ybefore;yafter]');
        [ymin,I2]=min(ymin);
    end
    
    if ymin<0
        % If such step is found ... 
        I=I1(I2);
        x0=x;
        
        if line==0
            % ... stop if line == 0
            x0(I)=x0(I)+sign(I2-1.5)*h(I);
        else
            % ... proceed with additional steps, if line > 0
            for j=1:line
                x0line=x0;
                x0line(I)=x0(I)+sign(I2-1.5)*(j+1)*h(I);
                if x0line(I)<space(I,2) | x0line(I)>space(I,1)
                    yminnew=feval(fitnessfun,x0line,varargin{:})-y0;
                    if yminnew<ymin
                        ymin=yminnew;
                    else break;
                    end
                else break;
                end
            end
            if j==line
                x0=x0line;
            else
                x0(I)=x0(I)+sign(I2-1.5)*(j-1)*h(I);
            end
        end
        gfx(i+1,:)=[ymin+y0 x0(:)'];
    else
       % ... or terminate the minimization
        output.reason = 'Optimization terminated: a peak is reached.';
        break;        
    end
    
    % Show the progress
    if Display>0 & rem(i,Display)==0
        fprintf('     %4.0f           %8.4f  \n',i,gfx(i+1,1));
    end
    
    % Termination conditions
    Time=Time+toc;
    tic;
    if Time>TimeLimit
        output.reason = 'Optimization terminated: Time Limit exceeded.';
        break;
    end
    if gfx(i,1)<=Goal
        output.reason = 'Optimization terminated: Goal reached or exceeded.';
        break;
    end
    
end

output.climbs = i-1;
output.time = Time;

if Display>0 & strcmp(Display,'Final')==0
    fprintf('   __________      ___________\n');
    fprintf('                              \n');
    disp('output:');
    disp(output);
elseif strcmp(Display,'Final')==1
    fprintf('Global minimum reached: %8.4f\n',gfx(end,1));
end

% Get the point that correspond to the minimum of the function
x=gfx(end,2:end);

% Get the minimum of the function
fval=gfx(end,1);