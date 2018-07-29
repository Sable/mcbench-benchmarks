function perf_increase = test_str_to_double_performance()
    % input sizes
    input_sizes = [1,4,8,16,36,64,128,256,516,1024,4096,8192,16384,32768,65536,1E5,1E6];
    
    native_times = zeros(size(input_sizes));
    custom_times = zeros(size(input_sizes));
    
    for i = 1:numel(input_sizes)
        [native_times(i), custom_times(i)] = compare_performance(input_sizes(i));
    end 
    perf_increase = native_times./custom_times;
    
    %loglog(input_sizes, native_times, input_sizes, custom_times);
    plot(input_sizes, native_times, input_sizes, custom_times);
    xlabel('input size'); ylabel('exec time');
    legend('str2double','str2doubleq')
    
%     plot(input_sizes, perf_increase);
%     xlabel('input size'); ylabel('performance gain');
%     legend('performance gain str2double vs str2doubleq')
    
    
    function [native,custom] = compare_performance(n)
        % generate random inputs
%         nums = 100.*rand(n,1);
%         str = cell(n,1);
%         for j = 1:n
%            str{j} =  num2str(nums(j));
%         end
        % do the above dummy generation much quicker 
        str = repmat({num2str(1000*rand())},n,1);
        
        tic;
        y1 = str2double(str);
        native = toc;
        
        tic;
        y2 = str2doubleq(str);
        custom = toc;
        
        if norm(y1-y2) > 10-9
            warning('results between str2double and str2doubleq are different!')
        end
    end
    
end

