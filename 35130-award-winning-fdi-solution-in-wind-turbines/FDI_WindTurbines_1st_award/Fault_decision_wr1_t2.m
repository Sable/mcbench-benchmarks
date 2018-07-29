function y = Fault_decision_wr1_t2(u)
global st8

% Using model defined by the structure st8 to make decision about type2 wr1 fault

res=u(1);u=u(2:end);
if res>0.5
sker=st8.x2sup+u'*u*ones(st8.Nlsup,1)-2*st8.xsup*u;
y=(st8.w)'*exp(-sker./(2*(st8.sigma).^2))+st8.b;
else
    y=0;
end
if y>=0.05
    y=1;
else
    y=0;
end
end