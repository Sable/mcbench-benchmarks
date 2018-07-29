function v=add_rotation(v,r,f,n)
% add global rotation
w=2*pi*f;
wv=[0;0;w];
for nc=1:n
    rx=r(1,nc,1);
    ry=r(1,nc,2);
    rv=[rx;ry;0];
    vv=cross(wv,rv);
    v(1,nc,1)=v(1,nc,1)+vv(1);
    v(1,nc,2)=v(1,nc,2)+vv(2);
    
end


