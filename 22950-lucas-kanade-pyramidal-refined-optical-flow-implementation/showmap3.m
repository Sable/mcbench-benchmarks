function RGB = showmap3(u,v,vmax)

anglestep = pi/3;
colorstep=1/anglestep;

RGBpart=[   0   1   255 255 -1  0;
            -1  0   0  1    255    255;
            255 255 -1  0   0   1];
        
RGB=zeros(size(u,1),size(u,2),3);

for i=1:size(u,1)
    for j=1:size(u,2)
    
    angle=atan2(u(i,j),v(i,j));
    
    if  (angle < 0)
        angle = angle+2*pi;
    end
    
    part=angle/anglestep;
    if ( part >= 6.0 ) 
        part = 0.0; 
    end
    
    length=sqrt( u(i,j)*u(i,j) + v(i,j)*v(i,j) );    
    
        if(length>vmax)
            RGB(i,j,1)=1;
            RGB(i,j,2)=1;
            RGB(i,j,3)=1;
        else

            for k=1:3
                
                switch RGBpart(k,fix(part+1))
                    case 0 
                        RGB(i,j,k)=0;
                    
                    case 1 
                        RGB(i,j,k)=colorstep*mod(part,1)*length/vmax;
                
                    case -1
                        RGB(i,j,k)=(1-colorstep*mod(part,1))*length/vmax;
                
                    case 255
                        RGB(i,j,k)=length/vmax; 
                    
                end
                
            end
        
        end

    end
end
end