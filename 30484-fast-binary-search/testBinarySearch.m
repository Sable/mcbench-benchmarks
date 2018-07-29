function testBinarySearch
%     idx = binarySearch(data, items, dirIfFound, dirIfNotFound)    

    % This function tests the binarySearch algorithm to verify that it
    % gives the correct output using various different parameters. In the 
    % cases where the indexes are not known beforehand, the 
    % output is checked by comparing it with Matlab's built-in linear
    % search ("find") method.

    fprintf('Running checks ... ');
    N = 1000;

    
    
    % 0. Basic test - exactly 1 occurence of each item in the data array.
    data = sort(randn(1,N));
    idx_orig = randi(N, 1, 10);
    items = data(idx_orig);
    idx_bsearch = binarySearch(data, items);
    assert(isequal(idx_orig, idx_bsearch)); % make sure the indices match the original indices
            
    
    % 1. Test behavior if multiplies copies are found (using dirIfFound parameter)
    n = 10;
    data = sort(randi(n, 1, N)); % multiple copies of the numbers 1..10
    items = 1:n;

    firstPos_linSearch = arrayfun(@(x) find(data == x, 1, 'first'), items);        
    firstPos_bSearch   = binarySearch(data, items, 'first');
    assert(isequal(firstPos_linSearch, firstPos_bSearch));

    lastPos_linSearch  = arrayfun(@(x) find(data == x, 1, 'last'),  items);        
    lastPos_bSearch    = binarySearch(data, items, 'last');
    assert(isequal(lastPos_linSearch, lastPos_bSearch));

    % 2. test behavior if items are not found (using dirIfNotFound)

    % 2a. test  dirIfNotFound = 0  (== return 0 if item not found)
    s = [-3:.5:13];  % [ranges from 1 to 9.999]  
    pos = binarySearch(data, s, [], 'exact');
    assert( all( s(pos == 0) == setdiff(s, data) ) );            
    
    % 2b. test  dirIfNotFound = down/up
    data = [1:10];
    items = 1 + rand(N,1) * 9;  % [ranges from 1 to 9.999]  
    pos = binarySearch(data, items, [], 'down');
    actualPos = floor(items);
    assert(isequal(pos, actualPos));

    actualPos = ceil(items);
    pos = binarySearch(data, items, [], 'up');
    assert(isequal(pos, actualPos));
    
    % 2c. test  dirIfNotFound = 0.5
    pos = binarySearch(data, items, [], 'frac');
    assert(isequal(pos, items));
    
    
    % 3. test the sort checking option.    
    data_notSorted = 10:-1:1;
    items = [5,6];
    % 4a. verify that we don't get an error if the first argument is not sorted
    try 
        binarySearch(data_notSorted, items);    
    catch MErr
        error('Should not have generated an error');        
    end        
    
    % 4b. verify that we *do* get an error if we tell the algorithm 
    % to check the sorting.
    checkFlag = 1;
    try 
        binarySearch(data_notSorted, items, [], [], checkFlag);
        error('Should have generated an error');
    catch MErr
        assert(strcmp(MErr.message, 'Input 1 (data) must be sorted.'));
    end
    fprintf(' All checks passed!\n');

    
    fprintf('Running speed test...\n');
    
    % Speed test:
    % compare speed with Matlab's "find" function.
    Ns = 10.^[2:6];
%     t_ratios = zeros(1,size(Ns));
    for i = 1:length(Ns)
        data = sort(randn(1,Ns(i)));
        idx_orig = randi(Ns(i), 1, 10);
        items = data(idx_orig);
        % regular matlab "find"
        tic;
        idx_find = arrayfun(@(x) find(data == x, 1), items);
        t1 = toc;
        assert(isequal(idx_orig, idx_find)); % make sure the indices match the original indices
        % binary search; (use "dontCheckFlag" to skip checking b/c we know
        % the data is sorted.
        tic;
        idx_bsearch = binarySearch(data, items);
        t2 = toc;
        assert(isequal(idx_orig, idx_find)); % make sure the indices match the original indices
        assert(isequal(idx_orig, idx_bsearch)); % make sure the indices match the original indices
        t_ratio = t1/t2;
        fprintf('For array size N =% 9d, binarySearch is ~%.1f times faster than find\n', Ns(i), t_ratio);
    end
    
    
    % check single / double handling
    data_d = sort(randn(1, 1000));
    items_d = rand(1, 100);
    data_f = single(data_d);
    items_f = single(items_d);
    
    idx_dd = binarySearch(data_d, items_d);
    idx_ff = binarySearch(data_f, items_f);
    idx_df = binarySearch(data_d, items_f);
    idx_fd = binarySearch(data_f, items_d);

    assert(isequal(idx_dd, idx_ff));
    assert(isequal(idx_dd, idx_fd));
    assert(isequal(idx_dd, idx_df));
    3;
 
    
    
end