function flag = validate_ipaddress(ipaddress)
%======== VALIDATE_IPADDRESS function validates whether the ip address being input by a User is Valid or not======%. 
%If the Ip address is valid then Flag will be set to 1 else Flag will be set to 0
%======== Input Parameters =========%
%ipaddress - String containing the Ip address given as input by the User.
%======== Output Parameters ========%
%flag - Output Value which indicates whether the Ipaddress being input is Valid or not.

%==== Initialise the Variables ====%
Valid_lengths = (7:15);
num_array = ones(1,4);
Check_flag = 1;
%==== Error Checking =======%
if ~ischar(ipaddress)
  flag = 0;
  return;
else
  length_ip = length(ipaddress);
  if ~CHK_isMember(length_ip,Valid_lengths)
    flag = 0;
    return;  
  else
    ipaddress = strcat(ipaddress,'.');  
    char_count = 1;
    part_count = 0;
    cr = [];
    part_array = cell(1,4);
    for index=1:4
        
     while (strcmpi(cr,'.') || char_count <=(part_count+3)) && num_array(index)==1
     cr = ipaddress(char_count);
     if ~strcmpi(ipaddress(char_count),'.')
     part_array{index} = strcat(part_array{index},ipaddress(char_count));
     else
     num_array(index) = 0;    
     end
     char_count = char_count + 1;
     end
     
     if isempty(part_array{index})
         part_array{index} = '999';
     end    
     
     if num_array(index) == 1 && strcmpi(ipaddress(char_count),'.') && ~isempty(str2num(part_array{index})) 
         
     temp_num = str2num(part_array{index});
     if ~(temp_num>=0 && temp_num<=255) 
     Check_flag = 0;
     num_array = zeros(1,4);
     break;    
     end 
     char_count = char_count + 1;
     num_array(index) = 0;
     
     elseif num_array(index) == 0 && ~isempty(str2num(part_array{index}))
     
     temp_num = str2num(part_array{index});
     if ~(temp_num>=0 && temp_num<=255) 
     Check_flag = 0;
     num_array = zeros(1,4);
     break;    
     end
     num_array(index) = 0;
     
     else
     Check_flag = 0;
     num_array = zeros(1,4);
     break;
     
     end
     
     part_count = char_count;

    end

  end
  
 if Check_flag == 0 && (sum(num_array) == 0)
  flag = 0;   
 else 
  flag = 1;   
 end

end