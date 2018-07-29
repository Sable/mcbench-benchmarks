function [Problem] = CMATpick_point(...
    Problem,Constraints,Spec,Objectives,Haxes)
satisfied = false;
while ~satisfied
    disp('Choose new point by clicking')
    [x,y] = ginput(1);
    newpth = plot(gca,x,y,'*k','MarkerEdgeColor','k',...
        'MarkerFaceColor','b','MarkerSize',9);
    
    %%  Change deceision vector to new point
    TestProb = Problem;
    ind = Haxes==gca;
    [ii,jj] = find(ind);
    testsolX = Problem.x0(Problem.activeX);
    testsolX(ii) = y;
    testsolX(jj) = x;
    TestProb.x0(Problem.activeX) = testsolX;
    %%
    commandwindow;
    if get_yes_or_no(...
            'New design point plotted. Evaluate chosen point? [Y]/N: ',true)
        ITERevaluate_X0(TestProb,Constraints,Spec,Objectives,false);
    end
    whattodo = txtmenu('',...
        'Choose new point (zoom/pan now)','Use chosen point',...
        'Cancel - use old design point');
    switch whattodo
        case 1 %satisfied
            Problem.x0 = TestProb.x0;
            satisfied = true;
        case 0 %try again
            delete(newpth);
        case 2 %use old
            delete(newpth);
            satisfied = true;
    end
end
        
end


