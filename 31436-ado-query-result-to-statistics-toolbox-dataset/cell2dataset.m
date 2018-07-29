function [dset] = cell2dataset(inputData)
    dset = dataset();
    if (~isfield(inputData, 'data'))
        error('[cell2dataset] input dataset structure has no ".data" field');
    end
    if (~isfield(inputData, 'columnnames'))
        error('[cell2dataset] input dataset structure has no ".columnnames" field');        
    end
    
    for i = 1:size(inputData.columnnames,2)
        if(isnumeric(inputData.data{1,i}))
            if(isempty(dset))
                dset = dataset({cell2mat(inputData.data(:,i)),cell2mat(inputData.columnnames(i))});               
            else
                dset = [dset dataset({cell2mat(inputData.data(:,i)),cell2mat(inputData.columnnames(i))})];
            end
            disp('numeric')
        else
            if(isempty(dset))
                dset = dataset({inputData.data(:,i),cell2mat(inputData.columnnames(i))});
            else
                dset = [dset dataset({inputData.data(:,i),cell2mat(inputData.columnnames(i))})];
            end
            disp('other')
        end
    end
end
