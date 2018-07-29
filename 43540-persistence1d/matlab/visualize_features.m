% A function which creates a graph with input data and marks maxima and minima.
% Assumes it recieves a data file with indices of extrema features
function [ ] = visualize_features( datafilename, resfilename )

    datafile = fopen(datafilename);
    data_cell_array = textscan(datafile, '%f'); %reads all of the file into a vector in a cell array
    fclose(datafile);

    resfile = fopen(resfilename);
    extrema_cell_array =  textscan(resfile,'%u'); %reads all of the file into a vector in a cell array
    fclose(resfile);

    data = data_cell_array{1};

    %assumes 1-based indexing, outout already adjusted for matlab
    extrema = extrema_cell_array{1};

    figure; 
    plot_data_with_features(data, extrema);

end



