function T_new = ExplicitScheme(T_old,alpha,dx,dy,dt,x_intervals,y_intervals)

T_new = T_old;

for x_index = 2:1:(x_intervals-1)
    for y_index = 2:1:(y_intervals-1)

         T_new(x_index,y_index) = T_old(x_index,y_index) + (alpha*dt)*((T_old(x_index+1,y_index) - 2*T_old(x_index,y_index)+ T_old(x_index-1,y_index))/dx^2 + (T_old(x_index,y_index+1) - 2*T_old(x_index,y_index)+ T_old(x_index,y_index-1))/dy^2); 
      
    end
end

end