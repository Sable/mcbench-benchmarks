function l=length(b,N)
% function l=length(b,N)

if ~strcmpi(class(b),'bezier')
  error('Expecting a bezier object');
end


[t,x,y]=get_points(b,N);

l=sum(sqrt(diff(x).^2+diff(y).^2));


