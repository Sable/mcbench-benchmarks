function y = Fault_decision_wg1_t2(u)
global st12

% Using model defined by the structure st12 to make decision about type2 wg1 fault

res=u(1);u=u(2:end);
if res>0.5
sker=st12.x2sup+u'*u*ones(st12.Nlsup,1)-2*st12.xsup*u;
y=(st12.w)'*exp(-sker./(2*(st12.sigma).^2))+st12.b;
else
    y=0;
end
if y>=0.05
    y=1;
else
    y=0;
end
end