function y=emfg(u)
if (u>-180)&&(u<=-120)
    y=[-1;0;1];
elseif(u>-120)&&(u<=-60)
    y=[0;-1;1];
elseif(u>-60)&&(u<=0)
    y=[1;-1;0];
elseif(u>0)&&(u<=60)
    y=[1;0;-1];
elseif(u>60)&&(u<=120)
    y=[0;1;-1];
elseif(u>120)&&(u<=180)
    y=[-1;1;0];
end