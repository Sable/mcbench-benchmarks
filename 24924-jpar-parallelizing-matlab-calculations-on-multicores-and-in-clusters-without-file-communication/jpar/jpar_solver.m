function jpar_solver(hostname, port)
%jpar_solver: Run parallellization solver on a Matlab node.
%Inputs:  hostname - hostname of the jpar registration server instance,
%                    defaults to localhost
%         port     - port numer of the registration server instance,
%                    defaults to 1099 (which is default for Java RMI)

if ~exist('j2m_solver_wrapper','file'),
    error(['Function j2m_solver_wrapper doesn''t seam to exist']);
end

if nargin == 0,
    hostname = 'localhost';
    rmiRegistryPort = 1099;
elseif nargin == 1
    rmiRegistryPort = 1099;
elseif nargin > 2,
    disp('Usage:');
    disp('  jpar_solver([''hostname''])');
end

fprintf(1, 'Registering solver...');  
javaaddpath jpar.jar;

solver = matlab.jpar.solver.JParSolverImpl(hostname, rmiRegistryPort);
if solver.isInitialized
    fprintf(1, ' done\n');
    while solver.waitForJob(),
        newargs = solver.getNewArgs();
        j2m_solver_wrapper(newargs(1), newargs(2), newargs(3), newargs(4), newargs(5:length(newargs)));
    end
else
    fprintf(2, 'jpar: solver registration failed\n');
end

clear solver;
javarmpath jpar.jar;

return;

function j2m_solver_wrapper(solver, nargout, argout, func, varargin)
t1 = java.lang.System.currentTimeMillis();

mvarargin = varargin{1};
lenVarIn = length(mvarargin);
func = char(func);

args = [];
for I=1:lenVarIn,
    jobj = mvarargin(I);
    tmp = convj2matlab(jobj);
    eval(['args' num2str(I) ' = tmp;']);
end

a = sprintf('[%s] = feval(func', argout);
for i=1:lenVarIn,
   a = sprintf('%s, args%d', a, i);
end
a = strcat(a, ');');

eval(a,'keyboard');

for I=1:nargout,
    eval(['tmp = Q' int2str(I) ';']);
    tmp = convm2java(tmp);
    eval(['Q' int2str(I) ' = tmp;']);
end

eval([' solver.taskIsDone({' argout '});']);
t2 = java.lang.System.currentTimeMillis();
disp(sprintf('Solver: I have finished job %d in %f secs', solver.getTask_no(), (t2-t1)/1000));
