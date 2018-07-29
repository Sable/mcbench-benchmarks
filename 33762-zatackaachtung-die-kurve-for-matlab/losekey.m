function losekey(~,event)
global increment;
global controls;

N = numel(increment);
ctrl = find(controls(1:N,:)==event.Key(1), 1);
if ~isempty(ctrl)    
    player = mod(ctrl, N) + N * (mod(ctrl, N) == 0);
    increment(player) = 0;
end