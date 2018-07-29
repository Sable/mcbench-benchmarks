function result = myStopTest(history, data)
% This function must return a structure, and that structure must have a
% single length variable called 'stop' as a result of the test.
% In this example, return structure is 'result', and its 'stop' field is
% set to false or true.
% You can add additional information using your own field.



result.stop = false;



if length(history)>1

    % Any additional information you want to record can be added.
    % You can make your own data structure here.
    % Here, MSE is added for example.
    yin = data; % This is the data you set in stopcriterion.
    ycurrent = history(length(history)).mu_OLS;
    MSE = sum((yin-ycurrent).^2)/length(yin);
    result.MSE = MSE;
    
    % Some additional dummy data...
    result.message = 'Good';
    result.myData = rand(2,3);
    
    
    
    % Don't Forget!!!
    % To stop the algorithm, you must set 'result.stop' to 'true'.
    result.stop = true;
end






