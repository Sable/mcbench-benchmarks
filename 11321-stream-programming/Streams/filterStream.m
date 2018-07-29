function so = filterStream(si,filter)
% FILTERSTREAM  Filter (matimatically) a stream
so = {feval(filter,streamCar(si)), ...
        delayEval(@filterStream,{streamCdr(si),filter})};
