%% Using the m file

%Do your work
result=rand;
%Now create an event telling you your work is done, reporting results and
%sending you notices:
gcaleventor('username@gmail.com', 'password', 'Finished task',...
    ['Results were: ' num2str(result)], 'my lab', true, true,0)

%% Using the java class directly

%Make sure your GCalData.class file is in a defined path or add it
%For instance if the class file is in the same place as this m then:
javaaddpath(pwd);
%Import the class file to use its functions
import GCalData.*;
%Do your work
result=rand;
%Now create an event telling you your work is done, reporting results and
%sending you notices:
GCalData.addEvent('username@gmail.com', 'password', 'Finished task',...
    ['Results were: ' num2str(result)], 'my lab', true, true,0)