function [y ind_kernel] = batmaneq(x)
y = [];
ind_kernel = [];
for i = 1:6
    this_y = eval(['batmaneq_kernel' num2str(i) '(x)']);
    if isreal(this_y) && ~isempty(this_y)
       y = [y this_y]; 
       ind_kernel = [ind_kernel i(ones(size(this_y)))];
    end
end
return

function y = batmaneq_kernel1(x)
if ~isreal(sqrt(abs(abs(x)-3)/(abs(x)-3)))
    y = [];
    return;
end
y = 1 - ...
    (x/7).^2 * sqrt(abs(abs(x)-3)/(abs(x)-3));
y = [sqrt(y) -sqrt(y)];
y = y(~logical(imag(y)));
y = y * 3;

y = y(y > -3*sqrt(33)/7);
y = unique(y);
return

function y = batmaneq_kernel2(x)
y = abs(x/2) - ...
    ((3*sqrt(33)-7)/112)*x.^2 - ...
    3 + ...
    sqrt(1-(abs(abs(x)-2)-1).^2);
return

function y = batmaneq_kernel3(x)
y = 9*sqrt(abs((abs(x)-1)*(abs(x)-.75))/((1-abs(x))*(abs(x)-.75))) - ...
    8 * abs(x);
return

function y = batmaneq_kernel4(x)
y = 3*abs(x)+...
    0.75*sqrt(abs((abs(x)-0.75)*(abs(x)-0.5))/((0.75-abs(x))*(abs(x)-0.5)));
return

function y = batmaneq_kernel5(x)
y = 2.25*sqrt(abs((x-0.5)*(x+0.5))/((0.5-x)*(0.5+x)));
return

function y = batmaneq_kernel6(x)
y = 6*sqrt(10)/7 + ...
    (1.5-0.5*abs(x))*sqrt(abs(abs(x)-1)/(abs(x)-1)) - ...
    6*sqrt(10)/14 * sqrt(4 - (abs(x)-1)^2);
return