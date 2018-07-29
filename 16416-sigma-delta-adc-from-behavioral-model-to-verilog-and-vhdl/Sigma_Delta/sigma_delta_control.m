function c = sigma_delta_control

c = hdlnewcontrol(mfilename);

c.forEach('design_multi_stage3/Stage1_40_Tap_FIR_using_LUT/Sum',...
 'built-in/Sum', {},...
 'hdldefaults.ProductTreeHDLEmission',{});

%for tree implementation use hdldefaults.ProductTreeHDLEmission
%for cascade implementaiton use hdldefaults.ProductCascadeHDLEmission