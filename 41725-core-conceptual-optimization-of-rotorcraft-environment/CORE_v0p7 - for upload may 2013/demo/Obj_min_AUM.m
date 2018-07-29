function ObjectiveValue = Obj_min_AUM(AC)
% Objective functions to be minimized during the design process. They are
% provided with the AC structure (see documentation), and return the value
% to be minimized. If possible, with a physical quantity for an objective
% value, try to make it both on a reasonable order of magnitude (0-10 or
% 0-100) AND with meaningful units.
% Note that these objective functions are part of a dynamic linear
% combination of objectives (the composite objective), so there is no need
% to formulate composite objectives here. If the file name begins with
% "Obj_max", then the default weighting of that objective in the composite
% objective within COR will be negative.

ObjectiveValue = AC.W.AUM/1000; % Units of tonnes