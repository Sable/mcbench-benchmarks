function std_value = standard_values(target)
% Copyright 2006-2013 The Mathworks, Inc.
% Standard value sequence for 5% tolerance components with "pads" of 0.91 and 11 on
% the ends. 
value_sequence=[0.91 1 1.1 1.2 1.3 1.5 1.6 1.8 2.0 2.2 2.4 2.7 3.0 3.3 3.6 3.9 4.3 4.7 5.1 5.6 6.2 6.8 7.5 8.2 9.1 10 11];

for k = 1:length(target)
   % first, determine the multiplier
   mul = floor(log10(target(k)));
   % normalize by this number 
   tn = target(k)/(10^mul);
   ki = find(tn >= value_sequence); % search for boardering values

   % select the closest one
   if length(ki)>1
       va=value_sequence(ki(end))*(10^mul);
       vb=value_sequence(ki(end)+1)*(10^mul);
       if abs(va-target(k)) < abs(vb-target(k))
          std_value(k) = va;
       else
          std_value(k) = vb;
       end
   else
       std_value(k) = value_sequence(ki(end))*(10^mul)
       disp('Error in component_values.m routine ?')
   end;
end; % for loop

