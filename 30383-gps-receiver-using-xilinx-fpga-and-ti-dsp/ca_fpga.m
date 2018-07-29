function ca=ca_fpga;

load ca_code_file
ca=[];
for k=1:32
    ca=[ca,(ca_codes(k,:)+1)/2,0];
end;
