function y = Fault_decision_wr2_t2(u)
global st7

% Using model defined by the structure st7 to make decision about type2 wr2 fault

res=u(1);u=u(2:end);
if res>0.5
sker=st7.x2sup+u'*u*ones(st7.Nlsup,1)-2*st7.xsup*u;
y=(st7.w)'*exp(-sker./(2*(st7.sigma).^2))+st7.b;
else
    y=0;
end

if y>=0.05
    y=1;
else
    y=0;
end
end