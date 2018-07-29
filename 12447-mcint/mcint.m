function varargout = mcint(h, n, opt)

%MCINT Monte Carlo integrator for multiple functions
%
% Satisfy your wildest integration fantasies!
%
%
%
% written by Lee Ferchoff, 2006
% Do not modify this file in any way unless for your own personal
% use. Do not re-release any part of the code contained in this file.
% Do not attach your own name to any part of the code contained in this
% file. Please reference me and e-mail to inform me if you use any part
% of this code, or original ideas from the algorithm. Thanks! Hope you find
% it helpful.
% E-mail: umferch1 at cc DOT umanitoba DOT ca
%
%
%
%
% A real-valued integral is calculated in arbitrary n-dimensional
% coordinates by averaging the value of a
% function over a large number of randomly selected points within the
% hypervolume to be integrated. Multiple functions can be integrated
% simultaneously over the same domain. The hypervolume can be of
% arbitrary shape, as long as it can be expressed as a series of
% logical conditions on the coordinates.
%
% Examples of the usage of mcint can be found in learnmcint.m
%
% Throughout, x(i,j) contains the matrix of "darts", or random
% points used to evaluate the function to be integrated.
% The rows i, refer to the ith coordinate of a
% point, where each column j, is a separate point. In standard
% notation, the coordinate vectors of all points 'n' are given by:
%
%       1-coordinate vector is     x(1,:)
%       2-coordinate vector is     x(2,:)
%       3-coordinate vector is     x(3,:)
%       ...
%       mth-coordinate is   x(m,:)
%
% In Cartesian coordinates, you might define the 1-dimension to be x,
% the 2-dimension to be y, or if you are using spherical coordinates,
% you could define the 1-dimension to be r, the 2-dimension to be
% theta, and the 3-dimension to be phi.
%
% This is the format that must be used when passing functions
% of coordinates to mcint. Operations on these coordinates must
% be written as vector operations (i.e. .* and .^, not * and ^).
%
% To integrate in a non-Cartesian coordinate system, in your
% function definition, multiply by the Jacobian from
% the Cartesian to 'system' transformation, for whatever coordinate
% system you are using. Jacobians for common coordinate systems
% can be obtained from jacobian.m. For example, to integrate
% f(r,theta,phi) in spherical coordinates, on paper you would write
%
%   triple integral ( f(r,theta,phi) * r^2 * sin(theta) dr d(theta) d(phi) )
%
% So the integrand should be defined as:
%
%   "f(x)" .* x(1,:).^2 + sin(x(2,:))
%       or making use of jacobian.m;
%   "f(x)" .* jacobian(x,'spherical')
%
% You can write your own Jacobian in, if you choose not to call jacobian.m.
% This flexibility allows you to mix coordinate systems. For example, you
% can do a 6-dimensional integral where three of the dimensions are in
% spherical coordinates and the other three are in elliptical. Furthermore,
% you can choose whatever order you want for the coordinate
% defintions, as long as you write the Jacobian accordingly. For example,
% x(1,:) could be theta, x(2,:) r, x(3,:) the angular variable in the
% elliptic coordinates, and so on.
%
%
%INPUT
% 
% h -- data structure defining a hypervolume integration problem
%
%   h.b(i,j) -- bounding parallepiped of the hypervolume to be
%       integrated.
%       size(b) = [dim 2] where dim is the number of dimensions
%       of the hypervolume. (i,1) is the minimum bounding coordinate
%       in the ith dimension and (i,2) is the maximum bounding coordinate
%       in the ith dimension.
%
%       Example: To integrate x from -1 to 1, and y from 0 to Inf,
%                b(:,1) = [-1; 0]
%                b(:,2) = [1; Inf]
%
%   h.cond{1,j} (OPTIONAL) -- cell array which contains the functions
%       expressing additional logical conditional statements that define
%       a hypervolume within its bounding box. These conditional
%       statements, indexed by j, are functions.
%       h.cond may be empty, if one wishes to integrate
%       over a rectangular parallepiped and doesn't
%       require any further logical conditions on the
%       hypervolume.
%
%       Example: cond = {@outCircle @aboveLine}
%                where the functions are defined as:
%
%                function tf = outcircle(x, par)
%                   tf = x(1,:).^2 + x(2,:).^2 >= 1;
%
%                function tf = aboveLine(x, par)
%                   tf = x(2,:) > x(1,:);
%
%                In this example, our hypervolume of integration
%                is restricted to the region outside of circle of
%                radius 1 at the origin, and to the upper left
%                of the line y=x.
%
%       All h.cond function definitions should take a structure par as
%       their second input, even if no parameters from 'par' are used in
%       the funciton.
%
%   h.funcs{1,j} -- cell array which contains the functions to be
%       integrated. When the jth function is evaluated, it returns
%       the evaluation of the jth integrand. The usual usage is
%       to enter a function that returns an row vector for the integrand
%       f(1,k), where the kth column is the integrand evaluated at the
%       kth dart point. mcint tests the conditions in the order you enter
%       them in the cell array, therefore it is most efficient to list
%       them from most likely to fail to least likely to fail.
%
%       Example: function f = simpleExample(x, par)
%                   f = x(1,:).^2 .* 2*exp(-x(2,:));
%
%       In this case, the integral returned will be a scalar, I(1,1)
%       containing the value of the integral.
%
%       If h.funcs contains several functions, I(1,m) will be the
%       value of the integral for the mth function in h.funs.
%
%       Example: function f = simpleExample(x, par)
%                   f = x(1,:).^2 .* 2*exp(-x(2,:));
%                function f = Id(x)
%                   f = ones( 1, size(x,2));
%
%       In this example, I(1,1) will be the integral of @simpleExample
%       and I(1,2) will be the integral of @Id. Note that @Id is the
%       identity function; to obtain the hypervolume itself, simply
%       integrate this identity function.
%
%       To allow greater flexibility, a function handle may contain
%       more than one function. If h.funcs contains one function handle
%       which returns a function with m rows, then I(m,1) will be
%       the integral for the integrand defined by the mth row returned
%       by the function.
%
%       Example: function f = energy(x, par)
%                   p = calculatePsi(x);
%                   H = getHamiltonian(x);
%                   f(1,:) = conj(p).*H.*p;
%                   f(2,:) = conj(p).*p;
%
%       This example shows you how you might calculate the expectation
%       value of energy for a quantum system. Here we've calculated
%       p (the wavefunction psi) and H (the Hamiltonian) on the random
%       dart matrix (x). Row one of the function will be the
%       evaluation of the integrand for the expectation value of the
%       Hamiltonian, and row two will be the probability density.
%       mcint will give I(1,1) which is the expectation value of the
%       Hamiltonian, and I(2,1) which is the total probability. Then
%       the user can simply find the expectation value of energy as
%       I(1,1)/I(2,1).
%
%       This method of putting multiple integrands in one function
%       handle is preferable when they are calculated with the same
%       ingredients. It would be more time consuming to make a separate
%       function handle for both expectation values calculated above
%       since the wavefunction psi would have to be calculated in
%       BOTH of the function handles with a call to @calculatePsi:
%                   p = calculatePsi(x);
%
%       This inefficiency can thus be avoided. In Quantum Energy Solver
%       (Lee Ferchoff), I use this method to calculate the expectation
%       value of the Hamiltonian, and the identity operator for ALL of
%       the individuals in the population at at once under one function
%       handle.
%
%       NOTE: As of now, if multiple function handles are used, each one
%             must contain the same number of rows. Support will be added
%             for varying numbers of rows in a future version.
%
%       In general, if h.funcs contains j function handles, then mcint
%       returns I, where I(i,j) is the integral of the function in the ith
%       row of the jth function handle.
%
%       All h.funcs function definitions should take a structure 'par' as
%       their second input, even if no parameters from 'par' are used in
%       the funciton.
%
% 
% n -- the number of randomly chosen sampling points
%
% 
% opt (OPTIONAL) -- integration options
%
%   opt.maxArray -- adjustable max array size parameter. mcint has
%       built-in memory management. This is the largest number
%       of elements that will be stored in memory for
%       use by mcint at any given time.
%
%       NOTE: The default max array size of 1e4 has been tested
%       extensively, this gives the shortest run time for a fixed amount
%       of points. This has been tested for integrals of dimensions 1 and
%       3 and n of 1e5 and 5e6, and it was found that run time increased
%       if the max array size was either increased or decreased from 1e4
%       in all cases.
%       If it is decreased from 1e4, the run time sharply increases. This
%       is because we lose most of the vectorization of the code,
%       since the function evaluations are broken up into vectorized
%       groups of the maximum array size. If the max array size is
%       increased from 1e4, the run time gradually increases by about
%       25% until memory management is not being used and the whole
%       integration is done in one shot. I suppose this is because
%       doing stuff with really large matricies is unwieldy and in
%       this case breaking up a bit of the vectorization at the benefit
%       of using smaller matricies seems to be a good thing.
%
%       1e-4 is optimum for the linux boxes in Room 523.
%       Anything above 1e-3 seems to be handled equally well by
%       hactar.
%   opt.noerror -- if true, statistical errors are not calculated and
%       only the integral value is returned. Note that this mode cannot
%       be used when a tolerance is requested with opt.tol.
%   opt.tol -- TOLERANCE STOPPING CONDITION
%       absolute tolerance requested (integration will stop
%       when reached)
%       opt.tol(i,j) is the absolute tolerance
%         for the ith row of the jth function in h.funcs. If a tolerance
%         is set to zero, then it is taken to mean that no tolerance is
%         requested for that particular integral.
%   opt.time -- TIME STOPPING CONDITION
%       maximum time allowed in seconds. Integration
%       will end normally after this time.
%   opt.warnOff -- if true, turn off printed warnings, such as not meeting a
%       requested tolerance
%   opt.mcintPar -- a struture containing parameters that is passed to the
%       functions in h.funcs, which can be used in function evaluation
%
%OUTPUT
%  
% varargout(1) is
% I(i,j,k) -- integral (with optional error)
%     I(i,j,1) -- value of the integral for the integrand defined
%     in the ith row of the jth function handle in h.funcs.
%     I(i,j,2) -- value of the statistical error of the integral
%     for the integrand defined in the ith row of the jth function
%     handle in h.funcs. The error is calculated from random fluctations
%     of the integrand about its mean value.
%
%     Errors are calculated by default, so k=1:2 by default.
%     If user passes opt.noerror=1 to mcint, then no errors are
%     calculated, and so k=1 only.
%
% varargout(2) is
% info (OPTIONAL) -- technical data about the integration. The data
%     can be used for error checking.
%
%     info.maxArray -- maximum array size used
%     info.memoryManaged -- if true, the requested number of points
%         n was large enough, that the integration had to be
%         performed with chunks of size maxArray
%     info.noerror -- if true, no statistical error calculated
%     info.extraParameters -- if true, extra parameters were passed
%         to the functions to be integrated in opt.mcintPar
%
%     info.dim -- number of dimensions
%     info.n -- number of random points requested
%     info.points -- number of random points used
%     info.pointdiff -- info.n-info.points
%
%     info.tolReq(i,j) -- tolerance requested by user. The abs tolerance
%         for the ith row of the jth function in h.funcs. If a tolerance
%         is set to zero, then it is taken to mean that no tolerance is
%         requested for that particular integral. This is what the user
%         entered in opt.tol.
%     info.someTolReq -- if true, at least one integral tolerance has
%         been requested
%     info.tolMet(i,j) -- true in the indicies for integrals which
%         have had their requested tolerance met. (i,j) labels the ith
%         row of the jth function in h.funcs
%         info.tolMet=-1 in the indicies representing integrals for which
%         a specific tolerance was not requested. If no tolerance was
%         required for any integral, info.tolMet is a scalar -1.
%     info.allTolMet -- if true, the requested tolerance for every
%         tolerance was met
%     info.timeReq -- max time requested by the user. info.timeReq=-1
%         if a specific time limit was not requested
%     info.timeMet -- if true, the integration was within the requested
%         time. info.timeMet=-1 if a specific time limit was not
%         requested
%     info.totalTime -- total time required for integration
%
%
%FEATURES TO BE ADDED IN THE NEXT VERSION:
%
% - relative tolerance stopping condition
% - differening amounts of rows in the functions in h.funcs
% - protection against overflow from a chance hit near a singularity
%
%Lee Ferchoff

t0 = clock; % record initial time

if ~isfield(h,'cond')
    h.cond = {};
end


% ===========================
% SET OPTIONS
% ===========================

% --------------------------------------
% mcint is memory managed, and will not
% use an array that has more elements
% than the number maxArray
p.info.maxArray = 1e4; % default max array size
% will be changed if opt.maxArray is a field
% --------------------------------------

% -1 means no request
p.info.tolReq = -1;
p.info.someTolReq = -1;
p.info.tolMet = -1;
p.info.allTolMet = -1;
p.info.timeReq = -1;
p.info.timeMet = -1;

p.info.noerror = 0; % if true, statistical errors are not calculated
p.info.extraParameters = 0; % if true, the user has provided opt.mcintPar

warnOff = 0; % if true, no warnings will be printed to screen
p.par = [];

if nargin==3 % optional parameter structure opt has been provided
    if isfield(opt,'maxArray')
        p.info.maxArray = opt.maxArray;
    end
    if isfield(opt,'noerror')
        p.info.noerror = opt.noerror;
    end
    if isfield(opt,'mcintPar') % user has provided extra parameters
        p.info.extraParameters = 1;
        p.par = opt.mcintPar;
    end
    if isfield(opt,'tol') % user requested tolerances
        p.info.tolReq = abs(opt.tol);
        p.info.someTolReq = 1;
        p.info.tolMet = 0;
        p.info.allTolMet = 0;
    end
    if isfield(opt,'time') % user requested max integration time
        p.info.timeReq = opt.time;
        p.info.timeMet = 0;
    end
    if isfield(opt,'warnOff')
        warnOff = opt.warnOff;
    end
end
% error: can't not calculate error and still request an error tolerance
if p.info.noerror==1 && p.info.someTolReq==1
    if warnOff==0
        disp('WARNING: IF a tolerance is requested, error must be calculated.');
        disp('Integration will continue WITH error calculation.');
    end
    p.info.noerror = 0;
end


% ===========================
% SETUP INTEGRATION PROBLEM
% ===========================

p.dim = size(h.b, 1);
p.nf = length(h.funcs); % # functions
points = n; % running counter that keeps track of how many of the n darts have been thrown

% Transform any improper integral bounds:

% true in rows of b having at least one improper integral limit
p.infBound = sum(isinf(h.b),2) ~= 0;
% perform inverse tangent coordinate transformation on affected rows.
% This will allow us to calculate the improper integral in the old
% coordinate system as a proper integral in the new coordinate system.
h.b(p.infBound,:) = atan(h.b(p.infBound,:));
% p.infDims isthe numbers of the dimensions with improper limits
p.infDims = find(p.infBound==1);
p.improperProblem = ~isempty(p.infDims);  % if true, at least one infinite dim
V = prod(h.b(:,2) - h.b(:,1)); % bounding volume (after transformation)


% ===========================
% INTEGRATE
% ===========================

if p.dim*n <= p.info.maxArray
    
    p.info.memoryManaged = 0;

    p.cols = n;
    p.xMin=repmat(h.b(:,1),1,p.cols);
    p.xMax=repmat(h.b(:,2),1,p.cols);
    s = updateSums(h,p);

else % memory management needed
    
    p.info.memoryManaged = 1;

    p.cols = floor(p.info.maxArray/p.dim);
    p.xMin=repmat(h.b(:,1),1,p.cols);
    p.xMax=repmat(h.b(:,2),1,p.cols);

    % # of runs which use the full maxArray size
    fullruns = ceil(p.dim*n/p.info.maxArray)-1;
    for j=1:fullruns
        newS = updateSums(h,p);
        if ~exist('s') % first run through loop; initialize s, s2
            s = zeros(size(newS));
        end
        s = s + newS;
        points = j*p.cols;
        
        % Check for stopping conditions
        if (p.info.timeReq~=-1 && etime(clock,t0)>p.info.timeReq)
            % executes if max time has elapsed
            p.info.timeMet = 1;
            break;
        elseif p.info.someTolReq==1
            % checks if all tolerances have been met
            E = getError(s,points,V);
            tolMatrix = zeros(size(E));
            tolMatrix(:) = Inf;
            tolMatrix = p.info.tolReq(find(p.info.tolReq~=0));
            p.info.tolMet = E < tolMatrix;
            p.info.allTolMet = prod(+p.info.tolMet(:));
            if p.info.allTolMet==1
                break;
            end
        end
    end

    % if integration wasn't stopped by some condition, finish the leftover
    % points
    if ~(p.info.timeMet==1 || p.info.allTolMet==1)
        % The last update covers the leftover points on the exact
        % number of points the user requested
        
        p.cols = n - points;
        p.xMin=repmat(h.b(:,1),1,p.cols);
        p.xMax=repmat(h.b(:,2),1,p.cols);

        newS = updateSums(h,p);
        s = s + newS;

        points = points + p.cols;      
    end

end


% ===========================
% REPORT RESULT
% ===========================

% return integral and possibly error
I(:,:,1) = V/points * s(:,:,1); % integral
if p.info.noerror==0
    I(:,:,2) = getError(s,points,V); % error
end
varargout(1) = {I};

% some tolerance was requested and wasn't met
if p.info.allTolMet==0 && warnOff==0
    disp('***');
    disp('Max number of requested darts thrown.');
    disp('Requested tolerance was not achieved.');
    disp('***');
end

 % build info structure to pass to user
if nargout==2   
    p.info.dim = p.dim;   
    p.info.n = n;
    p.info.points = points;
    p.info.pointdiff = n - points;   
    p.info.totalTime = etime(clock,t0);

    varargout(2) = {p.info};
end




function E = getError(s,points,V)
%GETERROR Find the current statistical error of the integral
%
%INPUT
%   s -- s(:,:,1) function sums
%     -- s(:,:,2) function squared sums
%   points -- number of points in sum
%   V -- hypervolume
%
%OUTPUT
%
%   E(i,j) -- the current error of the ith row and jth column using the
%             function sums in s

E = V/points * sqrt(s(:,:,2) - s(:,:,1).*s(:,:,1)/points);




function s = updateSums(h, p)

%UPDATESUMS Calculate function sums for mcint
%
%INPUT
%   h -- data structure defining the hypervolume integration problem
%   p -- data structure containing the current parameters of the
%        integration
%
%OUTPUT
%   s(i,j,k)  -- k=1, sum of the functions over all darts
%                k=2, sum of the functions squared over all darts
%                   for the ith row of the jth function handle in h.funcs
%
%   if p.info.noerror=1, then the k=2 matrix is not returned

% p.xMin, p.xMax passed into function rather than being calculated
% in it so that p.xMin, p.xMax only need to be calculated once
% for many memory blocks of size info.maxArray


% ===========================
% GENERATE RANDOM DARTS
% ===========================

% x(i,j) is the ith Cartesian coordinate of the jth random point
x = p.xMin + (p.xMax-p.xMin) .* rand(p.dim,p.cols); % random dart matrix


% ===========================
% COORDINATE TRANSFORMATIONS
% ===========================

% perform coordinate transformations if there is at least one improper
% integral. Transform only the infinite dimensions, since the
% transformation costs time and is not needed for the finite dimensions
if p.improperProblem
    x(p.infDims,:) = tan( x(p.infDims,:) );
end

% remove all points from x which aren't in hypervolume
% by using the extra restrictions given on the hypervolume
for i=1:length(h.cond)
    x = x( :, feval(h.cond{i},x));
end

% we calculate the Jacobian of the arctan transformation AFTER removing
% the points that aren't in the hypervolume so we don't waste time
% calculating the Jacobian for points that aren't in the integration
if p.improperProblem
    jacobian = prod( x(p.infDims,:).^2 + 1, 1 );
end


% ===========================
% INTEGRAND EVALUATION
% ===========================

for i = p.nf: -1: 1
    f = feval(h.funcs{i}, x, p.par);
    if p.improperProblem % multiply by the Jacobian of the arctan transform
        jacobian = repmat(jacobian(1,:), [size(f,1) 1]);
        f = f .* jacobian;
    end
    s(:,i,1) = sum(f,2);
    if p.info.noerror==0
        s(:,i,2) = sum(f.*f,2);
    end
end
