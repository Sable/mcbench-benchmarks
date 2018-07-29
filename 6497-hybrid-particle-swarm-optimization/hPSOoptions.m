function options=hPSOoptions(varargin)
%Syntax: options=hPSOoptions(varargin)
%_____________________________________
%
% Options definition for PSO.
%
% options is the options struct:
%             'c1': the strength parameter for the local attractors
%             'c2': the strength parapeter for the global attractor
%              'w': the velocity decline parameter
%           'maxv': the maximum possible velocity for each dimension
%          'space': the 2-column matrix with the boundaries of each
%                   particle
%           'bees': the number of the population particles
%        'flights': the number of flights
%     'HybridIter': the maximum number of iterations allowed for the
%                   @fminsearch
%           'Show': displays the progress (or part of it) on the screen
%  'StallFliLimit': the number of flights after the last improvement before
%                   the optimization stops
% 'StallTimeLimit': time in seconds after the last improvement before the
%                   optimization stops
%      'TimeLimit': time in seconds before the optimization stops
%           'Goal': a value to be reached
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


options.c1 = 2;
options.c2 = 2;
options.w = 0;
options.maxv = inf;
options.space = [0 1];
options.bees = 20;
options.flights = 50;
options.HybridIter = 0;
options.Show = 'Final';
options.StallFliLimit = 50;
options.StallTimeLimit = 20;
options.TimeLimit = 30;
options.Goal = -inf;

if (nargin == 0) && (nargout == 0)
    fprintf('             c1: [ real positive scalar | {2} ]\n');
    fprintf('             c2: [ real positive scalar | {2} ]\n');
    fprintf('              w: [ scalar in [0 1) | {0} ]\n');
    fprintf('           maxv: [ real positive vector | {ones(nvars,1)*inf} ]\n');
    fprintf('          space: [ real matrix  | {[0 1]} ]\n');
    fprintf('           bees: [ integer positive scalar | {20} ]\n');
    fprintf('        flights: [ integer positive scalar | {50} ]\n');
    fprintf('     HybridIter: [ integer non-negative scalar | {0} ]\n');
    fprintf('           Show: [ integer non-negative scalar | {"Final"} ]\n');
    fprintf('  StallFliLimit: [ real positive scalar | {50} ]\n');
    fprintf(' StallTimeLimit: [ real positive scalar | {20} ]\n');
    fprintf('      TimeLimit: [ real positive scalar | {30} ]\n');
    fprintf('           Goal: [ real scalar | {-inf} ]\n');
end

if nargin > 1
    if rem(nargin,2)==0
        for i=1:nargin/2
            switch varargin{i*2-1}
                case {'c1','c2','bees','flights','StallFliLimit','StallTimeLimit','TimeLimit'}
                    %  varargin{i*2} must be a scalar
                    if sum(size(varargin{i*2}))>2
                        error([varargin{i*2-1} ' must be a scalar.']);
                    end
                    % varargin{i*2} must be positive
                    if varargin{i*2}<=0
                        error([varargin{i*2-1} ' must be positive.']);
                    end
                case {'maxv'}
                    % All the elements of varargin{i*2} must be positive
                    varargin{i*2}=varargin{i*2}(:);
                    if sum(any(varargin{i*2}))>0
                        error(['All the elements of ' varargin{i*2-1} ' must be positive.'])
                    end
                case {'HybridIter','Show'}
                    if isa(varargin{i*2},'numeric')==1
                        %  varargin{i*2} must be a scalar
                        if sum(size(varargin{i*2}))>2
                            error([varargin{i*2-1} ' must be a scalar.']);
                        end
                        % varargin{i*2} must be positive
                        if varargin{i*2}<=0
                            error([varargin{i*2-1} ' must be positive.']);
                        end
                        % varargin{i*2} must be an integer
                        if varargin{i*2}~=round(varargin{i*2})
                            error([varargin{i*2-1} ' must be an integer.']);
                        end
                    elseif strcmp(varargin{i*2-1},'Show')==1 & strcmp(varargin{i*2},'Final')==0
                        error('The only non-numeric value of "Show" is "Final".');
                    end
                case 'space'
                    % varargin{i*2} must be a 2 dimensinal matrix
                    if ndims(varargin{i*2})>3
                        error(['"' varargin{i*2-1} '" must be a 2 dimensinal matrix.']);
                    end
                    % varargin{i*2-1} must contain exactly 2 columns
                    if size(varargin{i*2},2)~=2
                        error(['"' varargin{i*2-1} '" must contain exactly 2 columns.']);
                    end
                case 'w'
                    % varargin{i*2} must be in [0 1)
                    if varargin{i*2}<0 | varargin{i*2}>=1
                        error(['"' varargin{i*2-1} '" must be in [0 1).']);
                    end                
                case 'Goal'
                    %  varargin{i*2} must be a scalar
                    if sum(size(varargin{i*2}))>2
                        error([varargin{i*2-1} ' must be a scalar.']);
                    end
                otherwise
                    error(['The field "' varargin{i*2-1} '" does not exist in the struct PSOoptions.']);
            end
            options = setfield(options,varargin{i*2-1},varargin{i*2});
            fprintf(' %s updated... OK\n',varargin{i*2-1});
        end
    else
        error('The number of input arguments must be even.');
    end
end