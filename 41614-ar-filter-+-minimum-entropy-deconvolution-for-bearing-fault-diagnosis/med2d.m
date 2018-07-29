function [y_final f_final kurtIter] = med2d(x,filterSize,termIter,termDelta,plotMode)
    %2D MINIMUM ENTROPY DECONVOLUTION
    %  code by Geoff McDonald (glmcdona@gmail.com), February 2011
    %  Used in my MSc research at the University of Alberta, Advanced
    %  Control Systems Laboratory.
    %
    % med2d(x,filterSize,termIter,termDelta,plotMode)
    %
    % Algorithm Reference:
    %    R.A. Wiggins, Minimum Entropy Deconvolution, Geoexploration, vol.
    %    16, Elsevier Scientific Publishing, Amsterdam, 1978. pp. 21–35.
    %
    % Inputs:
    %    x: 
    %       Signal to perform Minimum Entropy Deconvolution on. If a single
    %       column/row of data is specified, a 1d filter is designed to
    %       minimize the entropy of the resulting signale. If a 2d data 
    %       matrix is specified, a single 1d filter will be designed to
    %       minimize the averaged entropy of each column of the filtered
    %       data.
    % 
    %    filterSize:
    %       This is the length of the finite inpulse filter filter to 
    %       design. Using a value of around 30 is appropriate depending on
    %       the data. Investigate the performance difference using
    %       different values.
    %
    %    termIter: (OPTIONAL)
    %       This is the termination number of iterations. If the 
    %       the number of iterations exceeds this number, the MED process
    %       will complete. Specify [] to use default value of 30.
    %
    %    termDelta: (OPTIONAL)
    %       This is the termination condition. If the change in kurtosis
    %       between iterations is below this threshold, the iterative
    %       process will terminate. Specify [] to use the default value
    %       of 0.01. You can specify a value of 0 to only terminate on
    %       the termIter condition, ie. execute an exact number of
    %       iterations.
    % 
    %    plotMode:
    %       If this value is > 0, plots will be generated of the iterative
    %       performance and of the resulting signal.
    %
    % Outputs:
    %    y_final:
    %       The input signal(s) x, filtered by the resulting MED filter.
    %       This is obtained simply as: y_final = filter(f_final,1,x);
    %
    %    f_final:
    %       The final 1d MED filter in finite impulse response format.
    %
    %    kurtIter:
    %       Kurtosis according to MED iteration. kurtIter(end) is the
    %       final kurtosis, ie. the summed kurtosis of each y_final
    %       column of y_final. sum(kurtosis(each column of y_final))
    % 
    % Example:
    %       % This will mostly extract the impulse-like
    %       % disturbances caused by 0.2*(mod(n,21)==0)
    %       % and plot the result.
    %       n = 0:999;
    %       x = [sin(n/30) + 0.2*(mod(n,21)==0);
    %           sin(n/13) + 0.2*(mod(n,21)==0)];
    %       [y_final f_final kurt] = med2d(x',30,[],0.01,1);
    % 
    % 
    % Note:
    %   The solution is not guaranteed to be the optimal solution to the
    %   entropy minimizataion problem, the solution is just a local
    %   minimum of the entropy and therefore a good pick.

                
    % Assign default values for inputs
    if( isempty(filterSize) )
        filterSize = 30;
    end
    if( isempty(termIter) )
        termIter = 30;
    end
    if( isempty(termDelta) )
        termDelta = 0.01;
    end
    if( isempty(plotMode) )
        plotMode = 0;
    end
    
    % Validate the inputs
    if( sum( size(x) > 1 ) > 2 )
        error('MED:InvalidInput', 'Input signal x must be of either 2d or 1d.')
    elseif( sum(size(termDelta) > 1) ~= 0 || termDelta < 0 )
        error('MED:InvalidInput', 'Input argument termDelta must be a positive scalar, or zero.')
    elseif( sum(size(termIter) > 1) ~= 0 || mod(termIter, 1) ~= 0 || termIter <= 0 )
        error('MED:InvalidInput', 'Input argument termIter must be a positive integer scalar.')
    elseif(  sum(size(plotMode) > 1) ~= 0 )
        error('MED:InvalidInput', 'Input argument plotMode must be a scalar.')
    elseif( sum(size(filterSize) > 1) ~= 0 || filterSize <= 0 || mod(filterSize, 1) ~= 0 )
        error('MED:InvalidInput', 'Input argument filterSize must be a positive integer scalar.')
    end

    % If the data is 1d, lets make it a column vector
    if( sum(size(x)>1) == 1 )
        x = x(:); % A column vector
    end
    L = filterSize;
    
    % Calculate the weighted toeplitz autocorrelation matrix
    % as the average autocorrelation matrix of the rows.
    autoCorr = zeros(1,L);
    for column = 1:size(x,2);
        for k = 0:L-1
            % Create the shifted x
            x2 = zeros(size(x,1),1);
            x2(k+1:end) = x(1:end-k,column);

            % Calculate the autocorrelation at this shift
            autoCorr(k+1) = autoCorr(k+1) + sum(x(:,column).*x2);
        end
    end
    autoCorr = autoCorr / size(x,2); % Average normalization
    A = toeplitz(autoCorr);
    A_inv = inv(A);
    
    
    % Initialize matrix sizes
    f = zeros(L,1);
    y = zeros(size(x,1),size(x,2));
    b = zeros(L,1);
    kurtIter = [];
    
    % Assume initial filter as a delayed impulse. This decision
    % was made by paper:
    % H. Endo and R. Randall, “Enhancement of autoregressive model based
    % gear tooth fault detection technique by the use of minimum entropy
    % deconvolution filter,” Mechanical Systems and Signal Processing vol.21,
    % no.2, February 2007
    f(2) = 1;
    
    % Iteratively adjust the filter to minimize entropy
    n = 1;
    while n == 1 || ( n < termIter && ( (kurt(filter(f,1,x)) - kurtIter(n-1)) > termDelta ) )
        
        % Compute output signal
        y = filter(f,1,x);
        
        % Calculate the kurtosis
        kurtIter(n) = kurt(y); %#ok<AGROW>

        % Calculate the matrix g = weighted av{ crosscorr( y.^3, x) }
        yc = y.^3;
        weightedCrossCorr = zeros(L,1);
        for column = 1:size(x,2);
            for k = 0:L-1
                % Create the shifted x
                x2 = zeros(size(x,1),1);
                x2(k+1:end) = x(1:end-k,column);

                % Calculate the crosscorrelation at this shift
                weightedCrossCorr(k+1) = weightedCrossCorr(k+1) + sum((y(:,column).^3).*x2);
            end
        end
        weightedCrossCorr = weightedCrossCorr / size(x,2);
        
        % Now we have new filter coefficients calculted as:
        % f = A^-1 * g
        f = A_inv*weightedCrossCorr;
        f = f/sqrt(sum(f.^2)); % Normalize the filter result

        % Next iteration
        n = n + 1;
    end
    
    % Update the final result
    f_final = f;
    y_final = filter(f_final,1,x);
    kurtIter(n) = kurt(y_final);
    
    % Plot the results
    if( plotMode > 0 )
        
        figure;
        subplot(2,1,1)
        plot(x)
        title('Input Signal(s)')
        ylabel('Value')
        xlabel('Sample Number')
        axis tight
        
        subplot(2,1,2)
        plot(y_final)
        title('Signal(s) Filtered by MED')
        ylabel('Value')
        xlabel('Sample Number')
        axis tight
        
        figure;
        stem(f_final)
        xlabel('Sample Number')
        ylabel('Value')
        title('Final Filter, Finite Impulse Response')

        figure;
        plot(kurtIter);
        xlabel('MED Algorithm Iteration')
        ylabel('Sum of Kurtosis for Filtered Signal(s)')
        
        if( n == termIter )
            display('Terminated for iteration condition.')
        else
            display('Terminated for minimum change in kurtosis condition.')
        end
    end
end

function [result] = kurt(x)
    % This function simply calculates the summed kurtosis of the input
    % signal, x.
    result = mean( (sum((x-ones(size(x,1),1)*mean(x)).^4)/(size(x,1)-2))./(std(x).^4) );
end
