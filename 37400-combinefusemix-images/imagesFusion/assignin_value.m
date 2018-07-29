function assignin_value(name,value)
% creates a variable with a given name and value in the calling function variable space
assignin('caller',name,value); % it's odd I couldn't just use assignin function in the calling function itslef, 
                               % and had to create a service function for this task...