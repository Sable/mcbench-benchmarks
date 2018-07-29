function [finaldata] = parseNACAairfoildata
% parse the text file NACAdata.txt into a structure

fid = fopen('NACAdata.txt','r');

data = textscan(fid, '%s %n %n %n %n %n');

fclose(fid);

%Initialize finaldata
finaldata(1).airfoil = data{1}{1};
finaldata(1).Re = data{2}(1);
finaldata(1).a0 = data{3}(1);
finaldata(1).a1 = data{4}(1);
finaldata(1).a2 = data{5}(1);
finaldata(1).alphastall = data{6}(1);
%Iterate through all entries in data
for i = 2:length(data{1})
    updated = 0;
    for j = 1:length(finaldata)
        %if we have already read in data about a certain airfoil, append
        %new data
        if strcmp(finaldata(j).airfoil,data{1}{i})
            finaldata(j).Re = [finaldata(j).Re; data{2}(i)];
            finaldata(j).a0 = [finaldata(j).a0; data{3}(i)];
            finaldata(j).a1 = [finaldata(j).a1; data{4}(i)];
            finaldata(j).a2 = [finaldata(j).a2; data{5}(i)];
            finaldata(j).alphastall = [finaldata(j).alphastall; data{6}(i)];
            updated = 1;
            break
        end
    end
    %if we have not already read in data about a certain airfoil, create
    %new entry
    if updated == 0
        finaldata(end+1).airfoil = data{1}{i};
        finaldata(end).Re = data{2}(i);
        finaldata(end).a0 = data{3}(i);
        finaldata(end).a1 = data{4}(i);
        finaldata(end).a2 = data{5}(i);
        finaldata(end).alphastall = data{6}(i);
    end
end
