function so = streamCons(v,si)
% STREAMCONS  Cons a value (?) with a stream
so = {v, delayEval(@fIdentity,{si})};
