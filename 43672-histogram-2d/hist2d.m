function h=hist2d(d,Nx,Ny)
   h=zeros(Nx,Ny);
   mx=max(d(:,1));
   my=max(d(:,2));
   
   nx=ceil(d(:,1)/mx*Nx);
   ny=ceil(d(:,2)/my*Ny);

ny(ny==0)=1;
nx(nx==0)=1;

   for n=1:length(d)
    h(nx(n),ny(n))=h(nx(n),ny(n))+1;
   end
end