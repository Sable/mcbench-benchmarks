function converter_mask(blk)

mask_visible = get_param(blk,'maskvisibilities');  % remove non-options
% Determine determine if model has variable parameters
Vparam = get_param(blk,'zcv');
if strcmp(Vparam,'off')
    if ~strcmp(mask_visible(3),'on')
        [mask_visible{3}]=deal('on');
    end
else
    if ~strcmp(mask_visible(3),'off')
        [mask_visible{3}]=deal('off');
        % reset parameter to zero start
        set_param(blk,'Vc0','0');
    end
end
Vparam = get_param(blk,'ICM');
if strcmp(Vparam,'off')
    set_param(blk,'ILmin','-Inf');
else
    set_param(blk,'ILmin','0');
end

set_param(blk,'maskvisibilities',mask_visible);
return
