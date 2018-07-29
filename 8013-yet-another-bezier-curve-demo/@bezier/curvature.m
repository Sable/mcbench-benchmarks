function [t,K]=curvature(b,N)
% function [t,K]=curvature(b,N)

if ~strcmpi(class(b),'bezier')
  error('Expecting a bezier object');
end


t=linspace(0,1,N);
K=(6*b.bx*t+2*b.bx)./(6*b.by*t+2*b.by)./(1+(3*b.bx*(t.^2)+2*b.bx*t+b.cx).^2./(3*b.by*t.^2+2*b.by*t+b.cy).^2).^(3/2);

