function [bitstream,char_table]=make_bits(msg)
% make a test transmission from msg
% Copyright 2002-2010 The MathWorks, Inc.
[vctable char_table]=load_alpha;   % varicode table index to 1+abs('c')
bitstream = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];   % idle bits
for k=1:length(msg)
    index=1+abs(msg(k));        % get ascii index (interesting use of the abs() function)
    vc=char(vctable(index));    % look up varicode bits
    kof=length(bitstream);
    bitstream([kof+(1:2)])=[0,0]; % 2 consecutive zeros is a character break
    for i=1:length(vc)
        bitstream(kof+2+i)=str2num(vc(i)); 
    end;
end;
