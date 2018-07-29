function gc = gcurvature(x,y,z)

[xu,xv]     =   gradient(x);
[xuu,xuv]   =   gradient(xu);
[xvu,xvv]   =   gradient(xv);

[yu,yv]     =   gradient(y);
[yuu,yuv]   =   gradient(yu);
[yvu,yvv]   =   gradient(yv);

[zu,zv]     =   gradient(z);
[zuu,zuv]   =   gradient(zu);
[zvu,zvv]   =   gradient(zv);

for i=1:(size(z,1))
    for j=1:(size(z,2))
        Xu          =   [xu(i,j) yu(i,j) zu(i,j)];
        Xv          =   [xv(i,j) yv(i,j) zv(i,j)];
        Xuu         =   [xuu(i,j) yuu(i,j) zuu(i,j)];
        Xuv         =   [xuv(i,j) yuv(i,j) zuv(i,j)];
        Xvv         =   [xvv(i,j) yvv(i,j) zvv(i,j)];
        E           =   dot(Xu,Xu);
        F           =   dot(Xu,Xv);
        G           =   dot(Xv,Xv);
        m           =   cross(Xu,Xv);
        n           =   m/sqrt(sum(m.*m));
        L           =   dot(Xuu,n);
        M           =   dot(Xuv,n);
        N           =   dot(Xvv,n);
        gc(i,j)      =   ((L*N)-M^2)/((E*G)-F^2);
    end
end
