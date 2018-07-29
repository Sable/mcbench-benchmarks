function getkey(~, event)
global increment;
global controls;

N = numel(increment);
ctrl = find(controls(1:N,:)==event.Key(1), 1);
if ~isempty(ctrl)
    player = mod(ctrl, N) + N * (mod(ctrl, N) == 0);
    direction = ceil(ctrl / N);
    increment(player) = (-1)^(direction - 1);
end