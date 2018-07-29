function ChangeMaskFields_Sub(blk)

 dbpt=true;
M=get_param(blk,'MaskVisibilities');
c=2;
selChar = (get_param(blk,'valC3'));
switch(selChar)
    case 'C3sub1'
        i0=9;
    case 'C3sub2'
        i0=10;
    case 'C3sub3'
        i0=11;
    case 'C3sub4'
        i0=12;
    otherwise
        i0=9;
end
        
[M{9:12}]=deal('off');
M{i0}='on';
set_param(blk,'MaskVisibilities',M);

end