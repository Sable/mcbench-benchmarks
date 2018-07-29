function y = Fault_decision_wg_t2(u)
global st15

% Using model defined by the structure st15 to make decision about type2 wg fault

sker=st15.x2sup+(abs(u))'*abs(u)*ones(st15.Nlsup,1)-2*st15.xsup*abs(u);
y=(st15.w)'*exp(-sker./(2*(st15.sigma).^2))+st15.b;

if y>=-0.3
    y=1;
else
    y=0;
end
end