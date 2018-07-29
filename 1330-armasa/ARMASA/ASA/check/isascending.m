function state = isascending(mtx)

mtx_length = length(mtx);
if mtx_length == 0
   state = 0;
elseif mtx_length == 1
   state = 1;
else
   state = 1;
   i = 2;
   while state == 1
      state=gt(mtx(i),mtx(i-1));
      i = i+1;
      if i > mtx_length
         break
      end
   end
end

         
      