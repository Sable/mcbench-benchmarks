function so = streamCompose(streams,func)
% STREAMCOMPOSE  Compose a set of streams with func
argsv = {func};
argsf = {};
for i=1:size(streams,2);
    argsv{i+1} = streamCar(streams{i});
    argsf{i} = streamCdr(streams{i});
end
val = builtin('feval',argsv{:});
so = {val,delayEval(@streamCompose,{argsf,func})};
