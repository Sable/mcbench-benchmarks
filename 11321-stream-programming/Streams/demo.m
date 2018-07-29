%% Stream programming in Matlab
%  The stream programming is a computer programming methodology that is
% born in the field of mathematical languages using lambda calculus toole
% and exploiting the lazy evaluation methodology. Here a unefficient
% library, really useful to explain lazy evaluation and stream programming,
% is given. The set of tools is really wide to give examples of pure lazy
% evaluation, simple stream generation, the composition pattern, the
% accumulation pattern, the filtering pattern and a wide set of examples
% that allow the user to learn what stream programming is. This library
% isn't useful to create systems that must work with large ammounts of
% data, but can used where the number of data elements is small.. for
% example to generate streams of images (i.e. a stream of the
% approximations of a given image using a set of fourier armonics, this is
% a classical accumulation example).

%% What lazy evaluation is
%  The lazy evaluation is the technique of managing entities that aren't
% computed yet. For example we can think to the gradient of an image that
% can be taken as a variable and passed in functions and in workspaces, but
% that isn't computed yet, when we acces, for example, to a tail of the
% gradient that isn't computed automatically the lazy evaluation system
% computes that part of the matrix. This is usefull to optimize the code
% for execution time (parts of the gradient aren't computed) and for memory
% usage (because the parts of the gradient that aren't used arent allocated
% in the gradient matrix).
%
%  For example we can delay the evaluation of a function with a set of
% parameters:

% Function evaluation delayed:
dsin = delayEval(@sin,{2}),

%% Forcing the evaluation
%  After the delayed evaluation composition, the entity "dsin" can be thing
% to the promise of evaluation of the function "sin" with parameter "2".
% This isn't done yet, we can force the evaluation when we wish to get it.
% If we have tools to guess if an entity must be evaluated or not we can
% automatize the evaluation so that it is done only when an entity is
% accessed the first time, like the example of the gradient.
%
%  Here we force the evaluation exlpicitly:

% Forcing the evaluation:
res = forceEval(dsin),

%% The Stream Programming (SP)
%  The stream programming is a technique, based on lazy evaluation, to
% manage infinitely long sequence of elements, for examples the sequences
% of numbers, or the sequences of functions, series or other things. To
% manage an infinitely long sequence, that cannot be stored in a finite
% computer memory, we think to the sequence as a first element  followed
% with the promise to compute the other part of the sequence: this is a
% stream:
% 
%     % A sample stream generating function generating the integers sequence:
%     function s = integersFrom(n)
%     s = {n, delayEval(@integersFrom,{n+1})};

% Generating an integers sequence:
integers = integersFrom(0),

% Getting another integer:
otherIntegers = forceEval(integers{2}),

% Computing the first ten integers:
firstTenInts = streamHead(integers,10),

%% Fibonacci numbers
%  The Fibonacci numbers can be constructed as a sequence where each number
% can be constructed as the sum of the previous two numbers. The first two
% numbers ar 0 and 1. With the following stream constructor the Fibonacci
% sequence can be constructed:
%
%     % The constructor of the Fibonacci sequence:
%     function s = fiboFrom(a1,a2)
%     s = {a1,delayEval(@fiboFrom,{a2,a1+a2})};
%
%  using this constructor we can obtain:

% Creating the sequence:
fib = fiboFrom(0,1);

% Getting the first ten values:
firstTenInts = streamHead(fib,10),

%% Functional list operators (from Schema language)
%  In the lisp and Schema languages the car and cdr operators are the bases
% for the management of lists. Here we have used "streamHead" to get the
% first elements of a stream, that is an infinite list; functions "head"
% and "tail" are defined as aliases of "streamCar" and "streamCdr", this
% two functions can be easily defined as follows:
%
%     % Head of a stream:
%     function v = streamCar(s)
%     v = s{1};
%
%     % Tail of a stream:
%     function so = streamCdr(si)
%     so = forceEval(si{2});
%
%  the streamHead function simply iterates with this two functions:
%
%     % Iteratively obtain a sequence of values:
%     function vals = streamHead(s,n)
%     s1 = s;
%     vals = cell(1,n);
%     for i=1:n
%         vals{i} = streamCar(s1);
%         s1 = streamCdr(s1);
%     end
%
%  other helper functions can be written with the same philosophy, like
% "streamRange" or "streamCons" to concatenate a value to a stream:
%
%     % Cut a range of a stream:
%     function vals = streamRange(s,start,nElem)
%     s1 = s;
%     for i=1:start-1
%         s1 = streamCdr(s1);
%     end
%     vals = cell(1,nElem);
%     for i=1:nElem
%         vals{i} = streamCar(s1);
%         s1 = streamCdr(s1);
%     end
%
%     % Concatenate a value with a stream:
%     function so = streamCons(v,si)
%     so = {v, delayEval(@fIdentity,{si})};

%% SP patterns: accumulate
%  In the software engeneering the design patterns are fundamental bricks
% for a correct and robust design of a complex system; generally desogn
% patterns are defined for OOP, but the same can be done for functional
% programming, procedural programming... and SP.
%  The accumulate pattern allows to define elements that operates over
% streams and that can be used as accumulators of data. Accumulators can be
% used to do a wide number of works like integration, sum of series...
% and for example the generation of streams containing successive
% approximations of series of what we wish to manage, for example the
% approximations of an image using its Fourier coefficients. Here the
% accumulator tool is defined as follows:
% 
%     % Given a stream, a starting value and an accumulator function an
%     % accumulated stream is generated with the starting value as first
%     % element and the accumulator function that computes the next element.
%     function so = streamAccumulate(si,start,accumulator)
%     so = {start,delayEval(@streamAccumulate, ...
%             {streamCdr(si),
%              feval(accumulator,start,streamCar(si)),accumulator})};
%
%  Using this simple function (but take a deep look to it) we can define
% easily the integration:
%
%     % Integration of a sequence of numbers:
%     function so = integrateStream(si,dt,c)
%     so = scaleStream(streamAccumulate(si,c/dt,@plus),dt);
%
%  Let's try it:

% A discretization step:
dt = 0.1;

% A sequence of values from 0:
X = scaleStream(integers,dt);

% A sine function:
Y = filterStream(X,@sin);

% Getting sample values:
Xs = streamHead(X,10),
Ys = streamHead(Y,10),

% Computing the integral stream:
Yint = integrateStream(Y,dt,-1);
Yints = streamHead(Yint,10),
figure; hold on;
plotStream(X,Y,100,0),
plotStream(X,Yint,100,0),

%% SP patterns: accumulate
%  The composition of streams can be used to do different computations in
% different streams and then mixing them int a single stream. A simple
% example is the stream sum of other streams, we can try to sum the sin
% stream and it's integral.
%  A composition can be done given a sequence of streams and a composing
% function as follows:
%
%     % Composing n streams:
%     function so = streamCompose(streams,func)
%     argsv = {func};
%     argsf = {};
%     for i=1:size(streams,2);
%         argsv{i+1} = streamCar(streams{i});
%         argsf{i} = streamCdr(streams{i});
%     end
%     val = builtin('feval',argsv{:});
%     so = {val,delayEval(@streamCompose,{argsf,func})};
%
%  This tool allows to generate easily new composition operators:
%
%     % Adding the streams values:
%     function so = addStreams(varargin)
%     so = streamCompose(varargin,@sumVals);
%     function ris = sumVals(varargin)
%     ris = sum(cell2mat(varargin));
% 
%     % Subtracting the stream values:
%     function so = subStreams(s1,s2)
%     so = streamCompose({s1,s2},@subVals);
%     function ris = subVals(v1,v2)
%     ris = v1-v2;
% 
%     % Multiply streams:
%     function so = mulStreams(varargin)
%     so = streamCompose(varargin,@mulVals);
%     function ris = mulVals(varargin)
%     ris = prod(cell2mat(varargin));
% 
%     % Divide streams:
%     function so = divStreams(s1,s2)
%     so = streamCompose({s1,s2},@divVals);
%     function ris = divVals(v1,v2)
%     ris = v1/v2;
%
%  Whit this tool all the composition of streams that we wish to do can be
% easily added to our operators set.

% Generating the sum of the two streams:
Ysum = addStreams(Y,Yint);

% Plotting:
figure; plotStream(X,Ysum,100,0),

%% SP patterns: filter
%  A stream can be filtered in a sense different from the previous one
% (that is the mapping of functional programming), a stream can be filtered
% with a filter that decides if an element must be discarded or not. For
% example immagine that you wish to get a sequence of prime numbers, you
% can get them filtering the stream of integers from 2 removing the
% integers that can be divided by the previous primes. We can design a
% stream filter function that recives another boolean function that can
% decide if an element can be mantained or must be rejected:
%
%     % A filtering element for streams:
%     function so = streamFilter(si,filter,varargin)
%     while ~builtin('feval',filter,head(si),varargin{:})
%         si = tail(si);
%     end
%     so = {head(si),delayEval(@streamFilter,{tail(si),filter,varargin{:}})};
%
%  This can filter element by element a stream (and can generate infinite
% loops). This can be usefull to generate streams from other discarding
% elements; the prime numbers stream is an extreme case because the filters
% chain grows of one for each element (prime) generated:
%
%     % Generation of all the primes:
%     function so = primes
%     so = PrimesFrom(integersFrom(2));
% 
%     % The filtering function add a new filter to the stream:
%     function so = PrimesFrom(si)
%     % The first number is ok:
%     val=head(si); so=tail(si);
%     % The others are filtered:
%     so = streamFilter(so,@(v,p)(mod(v,p)~=0),val);
%     % Composing:
%     so = {val,delayEval(@PrimesFrom,{so})};
%
%  This is really inefficient, also because the use of the recursion is
% heavy, but it's an approach that generates the required results:

% Creating the primes stream:
pr = primes;

% Extracting values:
streamHead(pr,20),

%% Conclusions
%  The stream programming is a powerful technique to manage infinite
% sequences of elements, the lazy evaluation allows to manage this
% particular entities easily, this implementation of streams in Matlab does
% not look at computational complexity but an efficient version can be
% implemented. Tools like Simulink, Labview, HP-VEE gives the stream
% programming as a base programming tool and a graphical environment to
% generate programs connecting stream generators, operators and consumers.
% The stream programming can be an useful tool also in programs written in
% other procedural languages like Python or Java, the power is big.. but
% the diffusion of this technique is not :(
