function so = integrateStream(si,dt,c)
% INTEGRATESTREAM  Generate a stream of integral values
so = scaleStream(streamAccumulate(si,c/dt,@plus),dt);
