function r = CSVtoARFF (data, relation, type)
% csv to arff file converter

% load the csv data
[rows cols] = size(data);

% open the arff file for writing
farff = fopen(strcat(type,'.arff'), 'w');

% print the relation part of the header
fprintf(farff, '@relation %s', relation);

% Reading from the ARFF header
fid = fopen('ARFFheader.txt','r');
tline = fgets(fid);
while ischar(tline)
    tline = fgets(fid);
    fprintf(farff,'%s',tline);
end
fclose(fid);

% Converting the data
for i = 1 : rows
    % print the attribute values for the data point
    for j = 1 : cols - 1
        if data(i,j) ~= -1 % check if it is a missing value
            fprintf(farff, '%d,', data(i,j));
        else
            fprintf(farff, '?,');
        end
    end
    % print the label for the data point
    fprintf(farff, '%d\n', data(i,end));
end

% close the file
fclose(farff);

r = 0;