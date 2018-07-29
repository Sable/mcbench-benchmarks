function so = streamAccumulate(si,start,accumulator)
% STREAMACCUMULATE  Stream of accumulation of values
so = {start,delayEval(@streamAccumulate, ...
        {streamCdr(si), feval(accumulator,start,streamCar(si)),accumulator})};
