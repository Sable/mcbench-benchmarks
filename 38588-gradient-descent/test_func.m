function [val grad]=test_func(x)

val=(x-2).^2;
grad=2*(x-2);