function y =Fault_decision_wg2_t2(u)
global st11

% Using model defined by the structure st11 to make decision about type2 wg2 fault

res=u(1);u=u(2:end);
if res>0.5
sker=st11.x2sup+u'*u*ones(st11.Nlsup,1)-2*st11.xsup*u;
y=(st11.w)'*exp(-sker./(2*(st11.sigma).^2))+st11.b;
else
    y=0;
end
if y>=0.05
    y=1;
else
    y=0;
end
end