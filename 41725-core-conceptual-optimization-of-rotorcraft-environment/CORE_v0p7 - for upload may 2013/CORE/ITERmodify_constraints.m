function [Constraints] = ...
    ITERmodify_constraints(Constraints,Spec)

nCons=Constraints.nCons;
conLabels=Constraints.conLabels;
active_cons=Constraints.active_cons;
useBEAflag = Constraints.useBEA;
margins=Constraints.margins;
nPPreqs = Spec.nPPrequirements;

listitems{1,1} = 'Done\n\n\t\tStatus Method Margin  Constraint';
while 1
    home; pause(.0001);

    for ii = 1:nCons
        if active_cons(ii)
            firstbit{ii} = 'Active'; %#ok<*AGROW>
        else
            firstbit{ii} = '   Off'; 
        end
        if (ii <= nPPreqs)
            if useBEAflag(ii)
                methodbit{ii} = 'BEA ';
            else
                methodbit{ii} = 'Mom.';
            end
        else
            methodbit{ii} = ' -  ';
        end
        listitems{ii+1,1} = sprintf('%s  %s  %+4.3f  %s',...
            firstbit{ii},methodbit{ii},margins(ii),conLabels{ii}); 
    end
    subchoice = txtmenu('Select constraint to change',listitems);
    
    if subchoice == 0;
        break
    else
        disp(       ['  Name: ' conLabels{subchoice}]);
        disp(['Status: ' firstbit{subchoice}]);
        fprintf('Margin: %+5.4f (margin < 0 allows constr. violation)\n'...
            ,margins(subchoice));
        if subchoice  <= nPPreqs
            methodprompt = ' | char: toggle method';
        else methodprompt = '';
        end
        k = input(...
            ['New margin value ([]: toggle status' methodprompt '): '],'s');
        if isempty(k)
            active_cons(subchoice) = ~active_cons(subchoice);
        else
            k = str2double(k);
            if isnan(k) || isinf(k)
                if subchoice  <= nPPreqs
                    useBEAflag(subchoice) = ~useBEAflag(subchoice);
                end
            else
                if k<=-.8
                    disp(...
        'Large margin violation allowed. Consider deactivating constraint')
                    beep;
                    pause(3);
                end
                margins(subchoice) = k;
            end
        end
    end
end

Constraints.nCons = nCons;
Constraints.conLabels = conLabels;
Constraints.active_cons = active_cons;
Constraints.margins = margins;
Constraints.useBEA = useBEAflag;

end