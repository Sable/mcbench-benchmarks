function var = params2var(params,freeList)

var = [];
for i=1:length(freeList)
  evalStr = sprintf('tmp = params.%s;',freeList{i});
  eval(evalStr);
  var = [var,tmp(:)'];
end
