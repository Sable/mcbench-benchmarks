function [Objectives] = ITERmodify_composite_obj(Objectives)

weightings=Objectives.weightings;
nObj=Objectives.nObj;
ObjLabels=Objectives.ObjLabels;


listitems{1,1} = 'Done\n\n\t\tWeight    Objective Label';
while 1
    home; pause(.0001);
    for ii = 1:nObj
        listitems{ii+1,1} = sprintf('%-9.3g %s',...
            weightings(ii),ObjLabels{ii}); 
    end
    subchoice = txtmenu('Select an objective',listitems);
    if subchoice == 0;
        break
    else
        disp(       ['             Name: ' ObjLabels{subchoice}]);
        fprintf('Current Weighting: %d\n',...
            weightings(subchoice));
        k = input('New Weight ([]: no change): ');
        if ~isempty(k)
            if k<0
                disp('Objective will be MAXimized')
            end
            weightings(subchoice) = k; 
        end
    end
end

Objectives.weightings = weightings;
Objectives.nObj = nObj;
Objectives.ObjLabels = ObjLabels;

end