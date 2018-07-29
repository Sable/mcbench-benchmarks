% Integers stream
integers = integersFrom(1);

% Even and odd numbers
even = addStreams(integers,integers);
odd = addStreams(integers,integersFrom(0));


% Fibonacci numbers
fibonacci = fiboFrom(0,1);

% Perfect squares
perfectSquares = streamAccumulate(odd,0,@plus);
perfectSquares2 = mulStreams(integersFrom(0),integersFrom(0));

% Sample of signal processing:
% Discretization value
dt = 0.01;
% Sampling times stream
time0 = scaleStream(integersFrom(0),dt);
% A sin wave
sin0 = filterStream(time0,@sin);
% The cos wave as differenziation od sin wave
cos1 = differenziateStream(sin0,dt);
% The sin wave as integral of cos wave
sin1 = integrateStream(cos1,dt,0);
% The error in the approssimation
err1 = filterStream(subStreams(sin0,sin1),@abs);
figure; hold on;
plotStream(time0,sin0,1000);
plotStream(time0,cos1,1000);
