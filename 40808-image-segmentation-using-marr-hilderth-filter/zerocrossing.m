function [Ioutput]=zerocrossing(Izerosmooth)

[rr,cc]=size(Izerosmooth);
Ioutput=zeros([rr,cc]);

for i=2:rr-1
    for j=2:cc-1
        if (Izerosmooth(i,j)>0)
             if (Izerosmooth(i,j+1)>=0 && Izerosmooth(i,j-1)<0) || (Izerosmooth(i,j+1)<0 && Izerosmooth(i,j-1)>=0)
                             
                Ioutput(i,j)= Izerosmooth(i,j+1);
                        
            elseif (Izerosmooth(i+1,j)>=0 && Izerosmooth(i-1,j)<0) || (Izerosmooth(i+1,j)<0 && Izerosmooth(i-1,j)>=0)
                    Ioutput(i,j)= Izerosmooth(i,j+1);
            elseif (Izerosmooth(i+1,j+1)>=0 && Izerosmooth(i-1,j-1)<0) || (Izerosmooth(i+1,j+1)<0 && Izerosmooth(i-1,j-1)>=0)
                  Ioutput(i,j)= Izerosmooth(i,j+1);
            elseif (Izerosmooth(i-1,j+1)>=0 && Izerosmooth(i+1,j-1)<0) || (Izerosmooth(i-1,j+1)<0 && Izerosmooth(i+1,j-1)>=0)
                  Ioutput(i,j)=Izerosmooth(i,j+1);
            end
                        
        end
            
    end
end

