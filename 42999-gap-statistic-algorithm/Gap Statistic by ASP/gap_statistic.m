function [opt_k, gaps] = gap_statistic(data, k_vector, n_tests, n_cores)

% -----------------------------------------------------------------------
%   FUNCTION
%   Gap Statistic v1.0 (gap_statistic.m)
%
%   DESCRIPTION
%   This function is designed to compute the optimum number of ks using the
%   Gap Statistic algorithm (Tibshirani, Walther & Hastie, 2001; a great
%   introduction can be found in Edwin Chen's blog). The reference datasets
%   are created from uniform distributions. Note: we use the phrases
%   'reference data(set)' and 'test data(set)' as synonymies in the code.
%
%   INPUTS
%   data: 2D dataset where each column is a variable.
%   k_vector: a vector with the ks to test.
%   n_test: number of test-datasets that have to be generated.
%   n_cores: the number of cores used in the computation; leave it null if
%   you miss the Parallel Computing Toolbox.
%
%   OUTPUTS
%   opt_k: the optimum k, that is the one that gaves the max gap.
%   gaps: 1-by-max_k array containing the gaps for all the ks tested.
%
%   AUTHOR
%   Alessandro Scoccia Pappagallo, 2013
%   Under the supervision of Ryota Kanai
%   University of Sussex, Psychology Dep.
% -----------------------------------------------------------------------

%% Trevor introducing itself (feel free to skip this part)

disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp(' ');
disp('Good morning, Master. My name is Trevor and I am going to find the optimum number of clusters for you.');

%% If the fourth argument is specified, the threads are open

if nargin == 4
    matlabpool ('open', n_cores);
end

size_k = size(k_vector);

tic
old_time = 0;
n_done = 0;
clear gaps
clear opt_k

%% Calculate the dispersions for the original dataset

dispersions(1, 1:size_k(2)) = zeros;
disp('I am calculating the dispersions for the original dataset, Master.');
disp(' ');
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp(' ');
for id_k = k_vector
    dispersions(1, id_k) = calculate_dispersion(data, id_k);
    time = toc;
    n_done = n_done + 1;
    disp('I have calculated one dispersion for the original dataset. Remaning:')
    disp(size_k(2) - n_done)
    disp('It took me (in seconds):')
    disp(time-old_time)
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    disp(' ');
    old_time = time;
end

disp('I have finished to calculate the dispersions for the original dataset, Master.');
disp('In total it took me, in seconds:');
so_far = toc;
disp(toc)
disp('Now I am going to generate the dummy dataset(s) and calculate their dispersions, my lord.');
disp(' ')

%% Generate test data

%This cycle is repeated n_tests times where n_tests is equal
%to the number of reference datasets you want to use
for id_test = 2:n_tests+1
    
    test_data = generate_test_data(data);
    
    %% Calculate the dispersion(s) for the generated dataset(s)
    
    dispersions(id_test, k_vector) = zeros;
    
    old_time = toc;
    disp('The test-dataset was created, thank you for the patience. It took me, in seconds:');
    disp(old_time - so_far);
    
    if nargin == 4
        %We calculate the dispersion for the id_test reference dataset (Parallel)
        parfor id_k = k_vector
            dispersions(id_test, id_k) = calculate_dispersion(test_data, id_k);
        end       
    else
        %We calculate the dispersion for the id_test reference dataset (No Parallel)
        for id_k = k_vector
            dispersions(id_test, id_k) = calculate_dispersion(test_data, id_k);
        end
    end
    
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    disp(' ');
    disp('I have finished to calculate the dispersions for a dummy dataset. It took me:');
    disp(toc - old_time);
    old_time = toc;
    disp('Now I am going to repeat the procedure. Number of dummy dataset(s) to go:');
    disp(n_tests-(id_test-1))
    
end

%% Compute the gaps (Tibshirani, Walther & Hastie, 2001, p. 412)

disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp('Done! Now I have only one last thing to do: calculate the gaps.');
disp('I hope I was not too slow, Master. So far it took me, in seconds:');
disp(toc)

gaps(1:size_k(2)) = zeros;

for id_gap = k_vector;
    gaps(id_gap) = log(mean(dispersions(2:n_tests+1,id_gap))) - log(dispersions(1,id_gap));
end

%% Select the k with the highest gap associated

max_gap = max(gaps);
opt_k = find(gaps == max(gaps));

b_gaps = gaps ~= 0;
gaps = gaps(b_gaps);

%% Time taken for the computation

disp('Done! I hope you are satisfied with my work, sir. It took me, in seconds:')
disp(toc)

if nargin == 4
    matlabpool ('close');
end

end