function [X,Y,Z]=cylinder2(x,y,z,r,N,o)
%
%   [X,Y,Z]=cylinder2(x,y,z,r,N,o)
%
%   Vectors x, y, z define the central line of cylindrical surface
%   and vector r defines the radius of cylindrical surface, and has
%   the same length as x, y, z.
%
%   N is the number of points around the circumference. The default value
%   is N = 100.
%
%   Matrix o defines ovality of the directrix (circle) of cylindrical
%   surface. Its elements take values between 0 and 1 and apply to the
%   primary and secondary axis of directrix. The defeault values are 
%   o=ones(length(x),2).
%
%   Matrices X, Y, Z define the cylindrical surface, surf(X,Y,Z) displays 
%   the cylindrical surface.
%
%   Example 1: Horn
%
%              f=linspace(0,4*pi,100);
%              x=cos(f); y=sin(f); z=f; r=-1/99*([1:100]-1)+1;
%              [X,Y,Z]=cylinder2(x,y,z,r);
%
%   Example 2: Pot
%            
%              x=[0 0 1 1 .5 .5]; y=[0 0 3 3 1.5 1.5];
%              z=[0 0 2 2 1 1];   r=[0 1 1.5 1.2 1 0];
%              [X,Y,Z]=cylinder2(x,y,z,r,6); view([-150 25])
% 
%   Example 3: Plumbing
%
%              x=[0 0 0 0 0 0  1 1 1 1 1 1]; y=[0 .2 .2 1 1 .5 .5 1 1 .2 .2 0]; 
%              z=[1 1 1 1 0 0 0 0 1 1 1 1]; r=[.2 .2 .1 .1 .1 .1 .1 .1 .1 .1 .2 .2];
%              o=[1 1 .5 .5 .5 1 1 .5 .5 .5 1 1; 1 1 1 1 1 .5 .5 1 1 1 1 1];
%              [X,Y,Z]=cylinder2(x,y,z,r,8,o);
%
%
%   Example 4: Triangle , closed central line
%
%              f=linspace(0,2*pi,4); 
%              x=cos(f-pi/6); y=sin(f-pi/6); z=zeros(4,1); r=0.2*ones(4,1);
%              [X,Y,Z]=cylinder3(x,y,z,r); view([0 90])
%
%
%
%   Copyright (c) 2011, Version 2.2
%   Avni Pllana <avniu66@hotmail.com>

X=[]; Y=[]; Z=[];

if nargin<5
    N=100;
end

x=x(:); y=y(:); z=z(:); r=r(:);

nx=length(x);
ny=length(y);
nz=length(z);
nr=length(r);

an=[nx ny nz nr];
if ~ismember(diff(an),[0 0 0],'rows')
    disp(' ')
    disp('x, y, z, r must have the same length!')
else
    if nx<2
        disp(' ')
        disp('The length of x must be greater than 1!')
    else
                
      if nargin<6
        o=ones(nx,2);  
      else
        [o1,o2]=size(o);
        if o2>o1
            o=o';
        end          
      end
                  
      C=[x y z];         
      D=diff(C);
      
      for i=1:nx-1      
         if norm(D(i,:))>0
            E(i,:)=D(i,:)/norm(D(i,:));
         else
            E(i,:)=[0 0 0];
         end
          
      end
      
      if norm(C(1,:)-C(nx,:))<1e-10 && norm(cross(E(1,:),E(nx-1,:)))>0
         Closed=1;
         nxx=nx+1;
         E=[E;E(1,:)];
      else
         Closed=0;
         nxx=nx;        
      end
          
      f=linspace(0,2*pi,N+1);
      for j=1:N+1
          xcc(j)=cos(f(j));
          ycc(j)=sin(f(j));
          zcc(j)=0;
      end
                    
      for i=1:nx
               
          if i==1
              
              if ~Closed
                  
                  d=[];
                  k=i;

                  while k<nx-1
                      if norm(cross(E(k,:),E(k+1,:)))==0
                          k=k+1;
                          d=[d k];
                      else
                          break
                      end

                  end

                  if norm(E(1,:))==0;
                      vz=E(2,:);
                  else
                      vz=E(1,:);
                  end
                  
                  if k==nx-1
                     if norm(cross([0 0 1],vz))~=0
                         va=cross([0 0 1],vz);
                     else
                         va=cross([1 1 1],vz);
                     end
                  else
                     va=cross(E(k+1,:),vz);
                  end

                  vy=va/norm(va);
                  vx=cross(vy,vz);                          
                  V=[vx;vy;vz];
                  Vp=V;
                  Vpp=V;
                  alf=0;
                  
              else
                  
                  d=[];
                  vb=(E(1,:)+E(nx-1,:))/2;
                  vz=vb/norm(vb);               
                  va=cross(E(1,:),E(nx-1,:));
                  vy=va/norm(va);
                  vx=cross(vy,vz);
                  V=[vx;vy;vz];                         
                  Vpp=V;

                  alf=acos(E(1,:)*E(nx-1,:)'); 

                  if abs(alf>3*pi/4)
                     alf=0;
                  end
                  
              end             
              
          else
              
             if ismember(i,d)
                 V=Vp;
                 alf=0;
             else
                    d=[];
                    k=i;

                    while k<nx-1
                      if norm(cross(E(k,:),E(k+1,:)))==0
                          k=k+1;
                          d=[d k];
                      else                          
                          break
                      end

                    end
                  
                    if ~isempty(d) || i==nx
                          if norm(E(i-1,:))==0;
                              vz=E(i-2,:);
                          else
                              if i==nx
                                vz=E(i-1,:);
                              else
                                vz=E(i,:);
                              end
                          end
                                                          
                          va=Vpp(2,:);
                          vy=va/norm(va);
                          vx=cross(vy,vz);                          
                          V=[vx;vy;vz];
                          
                          Vp=V;
                          alf=0;
                        
                    end
                        
                    if i<nxx
                 
                          vb=(E(i,:)+E(i-1,:))/2;
                          vz=vb/norm(vb);               
                          va=cross(E(i,:),E(i-1,:));
                          vy=va/norm(va);
                          vx=cross(vy,vz);
                          V=[vx;vy;vz];                          

                          %%%%%%%%%%%%%
                          ang=acos(vy*Vpp(2,:)');
                          Vang=cross(vy,Vpp(2,:));
                          if Vang*vz'>0
                              ang=-ang;
                          end   

                          A=[cos(ang) sin(ang); -sin(ang) cos(ang)];
                          xy=A*[xcc;ycc];
                          xcc=xy(1,:);
                          ycc=xy(2,:);
                          %%%%%%%%%%%%
                          Vpp=V;

                          alf=acos(E(i,:)*E(i-1,:)'); 

                         if abs(alf>3*pi/4)
                            alf=0;
                         end
                     end
             end             
             
          end
                              
          xc=o(i,1)*r(i)/cos(alf/2)*xcc;
          yc=o(i,2)*r(i)*ycc;
          xyz=[xc;yc;zcc];
                     
          M=pinv(V);
           
          xyz1=M*xyz+repmat([x(i);y(i);z(i)],1,N+1);
          
          X(:,i)=xyz1(1,:)';
          Y(:,i)=xyz1(2,:)';
          Z(:,i)=xyz1(3,:)';
                   
      end
      
       figure
       surf(X,Y,Z) 
       shading interp
       camlight
       grid on
       axis equal
       
    end
end
