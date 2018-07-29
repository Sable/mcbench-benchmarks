
clear all
clc

PCA_or_LDA = 0; % 0 means PCA
                % 1 means LDA
zitter_factor = 0.1;
File_Path = '../';

% Getting the files located in the folder
filelist = ls([File_Path,'*.arff']);
m = size(filelist,1);


in_data = cell(m,2);
for i=1:m
    fid = fopen([File_Path,filelist(i,:)]);
    c = lower(strtrim(fgetl(fid)));
    
    %********* This block counts the number of attributes ***********
    count =0;
    while(isempty(strfind(c,'@data')))
        if (~isempty(strfind(c,'@attribute')))
            count=count +1;
        end
        c = lower(strtrim(fgetl(fid)));
    end
    %****************************************************************
    
    % Eishob ajgubi jinish shudhu MATLAB ei shombhob
    % This line actually creates the format string '%f, %f, etc'
     a= (ones(count-1,1)*'%f ')';  formatString = [char(a(:)') ' %s'];   

    % The Data section of the file is read here
    in_data(i,:) = textscan(fid,formatString,'delimiter', ',', ...
    'commentStyle', '@','CollectOutput',1);
end

if (PCA_or_LDA==0)
    for i = 1:m
        [prin_comp,compVals] = princomp(in_data{i,1});

        % finds the indeces of tuples with positive & negative classes
        positiveIndices = find((ismember(lower(in_data{i,2}),'positive')==1));
        negativeIndices = find((ismember(lower(in_data{i,2}),'negative')==1));

        %Plotting the values
        figure;
        scatter3(compVals(positiveIndices,1),compVals(positiveIndices,2),compVals(positiveIndices,3),'b');
        hold on
        scatter3(compVals(negativeIndices,1),compVals(negativeIndices,2),compVals(negativeIndices,3),'r');
        title(filelist(i,:));
        hold off
        xlabel('Principal Component 1');
        ylabel('Principal Component 2');
        zlabel('Principal Component 3');
        legend('Positive','Negative')

    end
end

if (PCA_or_LDA == 1)
    for i = 1:m
       fea = in_data{i,1};
       positiveIndices = find((ismember(lower(in_data{i,2}),'positive')==1));
       negativeIndices = find((ismember(lower(in_data{i,2}),'negative')==1));
       
       gnd = ones(length(positiveIndices)+length(negativeIndices),1);
       gnd(negativeIndices)=0;
       
       options = [];
       %options.Fisherface = 1;
       [eigvector, eigvalue] = LDA(gnd, options, fea);
       Y = fea*eigvector;
       figure;hold on;
       len_positive = length(positiveIndices);
       len_negative = length(negativeIndices);
       scatter(Y(positiveIndices),ones(len_positive,1).*(zitter_factor*rand(len_positive,1))-(zitter_factor*0.5)*ones(len_positive,1),'r');
       scatter(Y(negativeIndices),ones(len_negative,1).*(zitter_factor*rand(len_negative,1))-(zitter_factor*0.5)*ones(len_negative,1),'b');
       axis ([min(Y),max(Y),-1,1])
       hold off;
       
       title(filname{i,1});
       xlabel('Projection on Fisher Discriminant Line');
       ylabel('Zitter');
       legend('Positive','Negative')
    end
end