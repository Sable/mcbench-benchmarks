function ris = forceEval(d)
% FORCEEVAL  Force an evaluation
ris = builtin('feval',d{:});
