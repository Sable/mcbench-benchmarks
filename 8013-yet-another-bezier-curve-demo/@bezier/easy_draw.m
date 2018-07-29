function easy_draw(b)
% function easy_draw(b)
% just draw a curve and do nothing more


if ~strcmpi(class(b),'bezier')
  error('Expecting a bezier object');
end

[t,x,y]=get_points(b,100);

plot(x,y,'b');

