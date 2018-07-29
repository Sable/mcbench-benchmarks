function [data_val] = read_cursor_data(event_obj)


bin_index = 0;
while(1)
              pause; 
              
              dcm_obj = datacursormode(event_obj);
              info_struct = getCursorInfo(dcm_obj);
     
              reply = input('The selected value has been recorded. Press "Q" to stop or continue to a new point... ', 's');
             if (reply == 'Q')
                  disp('exited')
                  break;
              else
                 bin_index = bin_index + 1;
                 data_val.xbin(bin_index) = info_struct.Position(1);
                 data_val.ybin(bin_index) = info_struct.Position(2);
                 %disp(' Got the value')
              end
end

end