function so = differenziateStream(si,dt)
% DIFFERENZIATESTREAM  Generate a stream of differenziation
v1 = streamCar(si);
si2 = streamCdr(si);
v2 = streamCar(si2);
v = (v2-v1)/dt;
so = {v,delayEval(@differenziateStream,{si2,dt})};