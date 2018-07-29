function result=maxfig(fig_hndl, maxtype)
%MAXIMIZES a matlab figure window
%
%Uses api_maxfig.dll or api_maxfig_R14SP2.dll
% (c) 2005 Mihai Moldovan M.Moldovan@mfi.ku.dk


if computer == 'PCWIN'
    
    v=version;
    if v(1)=='7'
        if v(end)=='2'
            sp=2;
        else
            sp=1;
        end    
    else
        warning ('designed for Matlab R14 SP2');
        return
    end    
    
    maxtype=upper(maxtype);
    
    switch maxtype
        case 'DESKTOP'
            set (fig_hndl,'Resize','on','WindowStyle','normal');
            
            if sp==2
                result=api_maxfig_R14SP2 (fig_hndl,'DESKTOP');
            else
                result=api_maxfig (fig_hndl,'DESKTOP');
            end
            
        case 'SCREEN'
            set (fig_hndl,'Resize','off','WindowStyle','normal');
            
            if sp==2
                result=api_maxfig_R14SP2 (fig_hndl,'SCREEN');
            else
                result=api_maxfig (fig_hndl,'SCREEN');
            end
                
            otherwise
            error ('Unknown Type')
    end        
    
    result=result(3:4);
    
    
else
   % unable to call dll
    error ('this function is only for WINDOWS 32');
end

    
return
%--------------------------------------------------------------------------