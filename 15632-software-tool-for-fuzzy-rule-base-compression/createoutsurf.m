function createoutsurf(system,systemName,intTable,outNum,option)
%   Create aoutput surface function
%
%   
%
%   Neelamugilan Gobalakrishnan
%   2006
%   $Revision:1.0 $ $Date: 15/03/2006 $
fprintf('\n');
surfTitle = input('Enter Title for the Output surface : ','s');% put outsite

if size(system.input, 2) == 1
    fprintf('\nEnter the number of points for input 1: ');
    numpoint(1) = input('');
    
    range(1,1) = system.input(1).range(1);
    range(1,2) = system.input(1).range(2);
    
    scale(1) = (range(1,2) - range(1,1)) / (numpoint(1) - 1);
    x = [range(1,1):scale(1):range(1,2)];
    
    for i=1:numpoint(1)
        inValues(1) = x(i);
        if option == 2
            displayOpt = 'off';
            newRules = finddomrules(system,intTable,outNum,inValues,displayOpt);
            createfis(systemName,system,newRules);
        end
        a = readfis(systemName);
        y(i) = evalfis([inValues], a);
    end
    
    xName = system.input(1).name;
    yName = system.output(outNum).name;
    
    figure;
    plot(x,y);
    
    xlabel(xName);
    ylabel(yName);
    % title(surfTitle);
else
    if size(system.input, 2) == 2
        ax = 1;
        ay = 2;   
    else

        fprintf('\n');
        condStatusax = 'start';
        while strcmp(condStatusax,'start') | strcmp(condStatusax,'cont')
            ax = input('Choose the input for x-axis : ');
            if ax < 1 | ax > size(system.input, 2)
                disp('Wrong input number is entered! Please recheck ');
                condStatusax = 'cont';
            else
                condStatusax = 'stop';
            end
        end
        
        condStatusay = 'start';
        while strcmp(condStatusay,'start') | strcmp(condStatusay,'cont')
            ay = input('Choose the input for y-axis : ');
            if ay < 1 | ay > size(system.input, 2)
                disp('Wrong input number is entered! Please recheck ');
                condStatusay = 'cont';
            elseif ay == ax
                disp('This input number is been choosed for the x-axis. ');
                disp('Please enter different input. ');
                condStatusay = 'cont';
            else
                condStatusay = 'stop';
            end
        end

        for i=1:size(system.input, 2)
            if i ~= ax & i ~= ay
                fprintf('\nEnter the fix value for input %d : ', i);
                inValues(i) = input('');
            end
        end
    end

    fprintf('\nEnter the number of points for input %d : ', ax);
    numpoint(1) = input('');
    fprintf('Enter the number of points for input %d : ', ay);
    numpoint(2) = input('');

    fprintf('\nPlease wait................. \n');

    range(1,1) = system.input(ax).range(1);
    range(1,2) = system.input(ax).range(2);    
    range(2,1) = system.input(ay).range(1);
    range(2,2) = system.input(ay).range(2);

    scale(1) = (range(1,2) - range(1,1)) / (numpoint(1) - 1);
    scale(2) = (range(2,2) - range(2,1)) / (numpoint(2) - 1);


    x = [range(1,1):scale(1):range(1,2)];
    y = [range(2,1):scale(2):range(2,2)];

    for i=1:numpoint(2)
        for j=1:numpoint(1)
            inValues(ax) = x(j);
            inValues(ay) = y(i);
            if option == 2
                displayOpt = 'off';
                newRules = finddomrules(system,intTable,outNum,inValues,displayOpt);
                createfis(systemName,system,newRules);
                fprintf('\n\n');
                disp(inValues);
                fprintf('\n');
                disp(newRules);
            end
            a = readfis(systemName);
            z(i,j) = evalfis([inValues], a);
        end
    end
    


    xName = system.input(ax).name;
    yName = system.input(ay).name;
    zName = system.output(outNum).name;

    [x,y] = meshgrid(x,y);
    
    fprintf('\n\n');
    if size(system.input, 2) > 2
        disp('The output surface values when : ');
        for i=1:size(system.input, 2)
            if i ~= ax & i ~= ay
                fprintf('Input%d fix to value: %.2f \n',i,inValues(i));
            end
        end
    else
        disp('The output surface values :');
    end 

    fprintf('\n\n    Input%d    Input%d    Output%d \n\n',ax,ay,outNum);
    row=1;
    for i=1:size(x,1)
        for j=1:size(x,2)
            newIntTable(row,1) = x(i,j);
            row = row+1;
        end
    end
    row=1;
    for i=1:size(y,1)
        for j=1:size(y,2)
            newIntTable(row,2) = y(i,j);
            row = row+1;
        end
    end
    row=1;
    for i=1:size(z,1)
        for j=1:size(z,2)
            newIntTable(row,3) = z(i,j);
            row = row+1;
        end
    end
    
    disp(newIntTable);
    disp('');
    
    figure;
    meshz(x,y,z);

    rotate3d on;
    xlabel(xName);
    ylabel(yName);
    zlabel(zName);
%     title(surfTitle);
end
