function ChangeMaskFields(blk)

dbpt=true;
M=get_param(blk,'MaskVisibilities');
c=2;
selChar = (get_param(blk,'Selector'));
switch(selChar)
    case 'A'
        i0=2;
        ie=3;
    case 'B'
        i0=4;
        ie=5;
    case 'C'
        i0=6;
        ie=8;
    otherwise
        i0=1;
        ie=1;
end
        
[M{:}]=deal('off');
M{1}='on';
[M{i0:ie}]=deal('on');
set_param(blk,'MaskVisibilities',M);

end