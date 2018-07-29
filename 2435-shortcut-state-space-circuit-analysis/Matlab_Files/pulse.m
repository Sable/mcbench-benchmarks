function y=pulse(t,f,w,Ein)
% unit pulse; starts at f ends at w; pulsewidth = w - f
% amplitude when on = Ein
if t < f | t > w
   y=0;
else
   y=Ein;
end
