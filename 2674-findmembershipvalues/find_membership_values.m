%THIS M-FILE IS CREATED BY C. JEGANATHAN, INDIAN INSTITUTE OF REMOTE
%SENSING, DEPARTMENT OF SPACE, DEHRADUN, INDIA

% THIS PROGRAMME IS A TYPE OF FUZZIFYING FUNCTION...THIS WILL TELL YOU THE
% FUZZIFIED VALUES FOR A GIVEN INPUT VALUE

%this m-file can be used to evaluate the STRENGTH OF MEMBERSHIP VALUES OF
%DIFFERENT LINGUISTIC CLASSES FROM CRISP VALUE
%inputs are the FIS MODEL NAME and a crisp value
% inout  value is used to judge whether user want to find the 
% membership values of input variable
% if "inout" is 0 then the programme understand that USER IS INTERESTED IN
% INPUT VARIBALES
% if "inout" is 1 then OUTPUT variable is considered

% "varinum" is the identification of the variable number, which means that
% whether user is interested in 1st variable or 2nd variable or 3rd
% variable, so the values for varinum may be 1 or 2 or 3......upto n (maximum
% number of available variables)
%
%note:
% varinum...may also used to represent the output variable number if the
% output of the model has more than one variable...

function [] = find_membership_values(inpfis,crispvalue,inout,varinum)

fuz = readfis(inpfis);

%FINDING THE STRENGTH OF OUTPUT CLASS============================



if inout == 0  
   [dum fuznummf] = size(fuz.input(varinum).mf);  % this is to find out howmany linguistic classes are present in each input
   
   
   pop = ['your variable name is ', fuz.input(varinum).name]
    for j = 1:fuznummf  % this loop is to find out type and parameters of each membership function
       fuzname = fuz.input(varinum).mf(j).name;
       fuztyp = fuz.input(varinum).mf(j).type;
       fuzmfparam = fuz.input(varinum).mf(j).params;
       fuzoutmfvalue = evalmf(crispvalue,fuzmfparam,fuztyp);
       if ( fuzoutmfvalue > 0)  %this is to popup only that linguistic class where membership is there
            pop = ['Linguistic class =  ',' ',fuzname,'  = ',num2str(fuzoutmfvalue)]
       end
    end  
   
   
end


if inout == 1  
   [dum fuznummf] = size(fuz.output(varinum).mf);  % this is to find out howmany linguistic classes are present in each input
  
   pop = ['your variable name is ', fuz.output(varinum).name]
    for j = 1:fuznummf  % this loop is to find out type and parameters of each membership function
       fuzname = fuz.output(varinum).mf(j).name;
       fuztyp = fuz.output(varinum).mf(j).type;
       fuzmfparam = fuz.output(varinum).mf(j).params;
       fuzoutmfvalue = evalmf(crispvalue,fuzmfparam,fuztyp);
       if ( fuzoutmfvalue > 0)  %this is to popup only that linguistic class where membership is there
            pop = ['Linguistic class =  ',' ',fuzname,'  = ',num2str(fuzoutmfvalue)]
       end
    end  
    
end

     
   