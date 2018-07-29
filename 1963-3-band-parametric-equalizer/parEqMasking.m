function parEqMasking
%Sets the Mask visibilities and option when the user-defined Bandwidth Gain
%option is chosen

maskVis  = get_param(gcb, 'MaskVisibilities');
maskVals = get_param(gcb, 'MaskValues');
maskWsVar = get_param(gcb,'maskwsvariables');


if strcmp(maskVals{3},'User-Defined')
    set_param(gcb,'MaskVisibilities',{'on','on','on'});  
else
    set_param(gcb,'NdB','.707');
    set_param(gcb,'MaskVisibilities',{'on','on','off'});
end


