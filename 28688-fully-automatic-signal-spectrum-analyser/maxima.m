function [TT,yy,kk]=maxima(tt,u1);
% This file obtain coordinates and indices of extreme multiple maximum
% points of u1 which is a function of tt. An extreme maximum point is
% defined as any particular point having a value higher than the two neighboring points to its left and to its right. 
% coordinates and indices are outputted as TT,yy,kk
n=length(u1);
k=1;
for i=2:n-1; % Run through the whole set of data
       if u1(i)>u1(i+1) % Check the point to the right
           if u1(i)>u1(i-1) %Check the point to the left
            yy(k)=u1(i); % register the kth point when condtions are satisfied     
            TT(k)=tt(i);
            kk(k)=i; % register index if condtion is satisfied
            k=k+1;   
        end
    end
   end
%plot(TT,yy,'k')