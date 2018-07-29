function [y_final f_final ckIter] = mckd(x,filterSize,termIter,T,M,plotMode)
    %MAXIMUM CORRELATED KURTOSIS DECONVOLTUION
    %  code and method by Geoff McDonald (glmcdona@gmail.com), May 2011
    %  This code file is an external reference for a paper being submitted
    %  for review.
    %
    % mckd(x,filterSize,termIter,plotMode,T,M)
    %
    % Description:
    %    This method tries to deconvolve a periodic series of impulses from
    %    a 1d vector. It does this by designing a FIR filter to maximize
    %    a norm criterion called Correlated Kurtosis. This method is has
    %    applications in fault detection of rotating machinery (such as
    %    ball bearing and gear faults).
    %
    % Algorithm Reference:
    %    (Paper link coming soon. If you are interested in this, please
    %    contact me at glmcdona@gmail.com. I will add the link if/when the
    %    paper is available online)
    %
    % Inputs:
    %    x: 
    %       Signal to perform deconvolution on. This should be a 1d vector.
    %       MCKD will be performed on this vector by designing a FIR
    %       filter.
    % 
    %    filterSize:
    %       This is the length of the finite impulse filter filter to 
    %       design. Using a value of around 100 is appropriate depending on
    %       the data. Investigate the performance difference using
    %       different values.
    %
    %    termIter: (OPTIONAL)
    %       This is the termination number of iterations. If the 
    %       the number of iterations exceeds this number, the MCKD process
    %       will complete. Specify [] to use default value of 30.
    %
    %    T:
    %       This is the period for the deconvolution. The algorithm will
    %       try to deconvolve periodic impulses separated by this period.
    %       This period should be specified in number of samples and can be
    %       fractional (such as 106.29). In the case of a fractional T, the
    %       method will resample the data to the nearest larger integer T:
    %        i.e. 106.29 -> 107
    %       and the y_final output will still be at this resampled factor.
    %
    %    M:
    %       This is the shift order of the deconvolution algorithm.
    %       Typically an integer value between 1 and 5 is good. Increasing
    %       the number increases the number of periodic impulses it tries
    %       to find in a row. For example M = 5 would try to extract at
    %       least 5 impulses in a row. When you use a larger M you need a
    %       better estimate of T. Using too large a M (approx M > 10) will
    %       result in a loss of numerical precision.
    % 
    %    plotMode:
    %       If this value is > 0, plots will be generated of the iterative
    %       performance and of the resulting signal.
    %
    % Outputs:
    %    y_final:
    %       The input signal x filtered by the resulting MCKD filter.
    %       This is obtained simply as: y_final = filter(f_final,1,x);
    %
    %    f_final:
    %       The final MCKD filter in finite impulse response format.
    %
    %    ckIter:
    %       Correlated Kurtosis of shift M according to MED iteration.
    %       ckIter(end) is the final ck.
    % 
    % Example Usage:
    %      % We want to extract the periodic impulses
    %      % from the very strong white noise!
    %      n = 0:999;
    %      x = 3*(mod(n,100)==0) + randn(size(n));
    %      [y_final f_final ck_iter] = mckd(x,400,30,100,7,1); % M = 7
    %                                                          % T = 100
    % 
    % 
    % Note:
    %   The solution is not guaranteed to be the optimal solution to the
    %   correlated kurtosis maximization problem, the solution is just a
    %   local maximum and therefore a good pick.


    % Assign default values for inputs
    if( isempty(filterSize) )
        filterSize = 100;
    end
    if( isempty(termIter) )
        termIter = 30;
    end
    if( isempty(plotMode) )
        plotMode = 0;
    end
    if( isempty(T) )
        T = 0;
    end
    if( isempty(M) )
        M = 1;
    end
    
    % Validate the inputs
    if( sum( size(x) > 1 ) > 1 )
        error('MCKD:InvalidInput', 'Input signal x must be a 1d vector.')
    elseif( sum(size(T) > 1) ~= 0 || T < 0 )
        error('MCKD:InvalidInput', 'Input argument T must be a zero or positive scalar.')
    elseif( sum(size(termIter) > 1) ~= 0 || mod(termIter, 1) ~= 0 || termIter <= 0 )
        error('MCKD:InvalidInput', 'Input argument termIter must be a positive integer scalar.')
    elseif(  sum(size(plotMode) > 1) ~= 0 )
        error('MCKD:InvalidInput', 'Input argument plotMode must be a scalar.')
    elseif( sum(size(filterSize) > 1) ~= 0 || filterSize <= 0 || mod(filterSize, 1) ~= 0 )
        error('MCKD:InvalidInput', 'Input argument filterSize must be a positive integer scalar.')
    elseif( sum(size(M) > 1) ~= 0 || M < 1 || round(M)-M ~= 0 )
        error('MCKD:InvalidInput', 'Input argument M must be a positive integer scalar.')
    elseif( filterSize > length(x) )
        error('MCKD:InvalidInput', 'The length of the filter must be less than or equal to the length of the data.')
    end
    
    
    % Force x into a column vector
    x = x(:);
    L = filterSize;
    OriginalLength = length(x);
    
    
    % Perform a resampling of x to an integer period if required
    if( abs(round(T) - T) > 0.01 )
        % We need to resample x to an integer period
        T_new = ceil(T);
        
        % The rate transformation factor
        Factor = 20;
        
        % Calculate the resample factor
        P = round(T_new * Factor);
        Q = round(T * Factor);
        Common = gcd(P,Q);
        P = P / Common;
        Q = Q / Common;
        
        % Resample the input
        x = resample(x, P, Q);
        T = T_new;
    else
        T = round(T);
    end
    
    N = length(x);
    
    % Calculate XmT
    XmT = zeros(L,N,M+1);
    for( m = 0:M)
        for( l = 1:L )
            if( l == 1 )
                XmT(l,(m*T+1):end,m+1) = x(1:N-m*T);
            else
                XmT(l, 2:end,m+1) = XmT(l-1, 1:end-1,m+1);
            end
        end
    end
    
    % Calculate the matrix inverse section
    Xinv = inv(XmT(:,:,1)*XmT(:,:,1)');
    
    % Assume initial filter as a delayed impulse
    f = zeros(L,1);
    f(round(L/2)) = 1;
    f(round(L/2)+1) = -1;
    f_best = f;
    ck_best = 0;
    iter_best = 0;
    
    % Initialize iteration matrices
    y = zeros(N,1);
    b = zeros(L,1);
    ckIter = [];
    
    
    
    
    % Iteratively adjust the filter to minimize entropy
    n = 1;
    delta = 0;
    while n == 1 || ( n <= termIter )
        % Compute output signal
        y = (f'*XmT(:,:,1))';
        
        % Generate yt
        yt = zeros(N,M);
        for( m = 0:M )
            if( m == 0 )
                yt(:,m+1) = y;
            else
                yt(T+1:end,m+1) = yt(1:end-T,m);
            end
        end
        
        % Calculate alpha
        alpha = zeros(N,M+1);
        for( m = 0:M )
            alpha(:,m+1) = (prod(yt(:,[1:m (m+2):size(yt,2)]),2).^2).*yt(:,m+1);
        end
        
        % Calculate beta
        beta = prod(yt,2);
        
        % Calculate the sum Xalpha term
        Xalpha = zeros(L,1);
        for( m = 0:M )
            Xalpha = Xalpha + XmT(:,:,m+1)*alpha(:,m+1);
        end
        
        % Calculate the new filter coefficients
        f = sum(y.^2) / (2*sum(beta.^2)) * Xinv * Xalpha;
        
        f = f/sqrt(sum(f.^2));
        
        
        % Calculate the ck value fo this iteration
        ckIter(n) = sum(prod(yt,2).^2)/( sum(y.^2)^(M+1) );
        
        % Update the best match filter if required
        if( ckIter(n) > ck_best )
            ck_best = ckIter(n);
            f_best = f;
            iter_best = n;
        end
        
        n = n + 1;
        
        
    end
    
    % Update the final result
    f_final = f_best;
    y_final = filter(f_final,1,x);
     
    % Resample the final result
    if( length(y_final) ~= OriginalLength )
        y_final = y_final(1:OriginalLength);
    end
    
    % Plot the results
    if( plotMode > 0 )
        
        figure;
        subplot(4,1,1)
        plot(x)
        title('Input Signal')
        ylabel('Value')
        xlabel('Sample Number')
        axis tight
        
        subplot(4,1,2)
        plot(y_final)
        title('Signal Filtered by MCKD')
        ylabel('Value')
        xlabel('Sample Number')
        axis tight
        
        subplot(4,1,3)
        stem(f_final)
        xlabel('Sample Number')
        ylabel('Value')
        title('Final Filter, Finite Impulse Response')
        axis tight
        
        subplot(4,1,4)
        plot(ckIter);
        title('CK_m versus algorithm iteration')
        xlabel('Iteration')
        ylabel('CK_m(T)')
        axis tight
        
        hold on
        plot([iter_best], ckIter(iter_best),'-oblack','LineWidth',2)
        
        legend('CK_m versus iteration','Best match location')
    end
end
