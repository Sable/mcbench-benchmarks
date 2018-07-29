function errores = errors

source = evalin('base','source');
decout = evalin('base','decout');
N = evalin('base','N');

errores = sum(abs(source - decout));