function [ndraw, count, count2, error]=rand_int(a, b, n, sorted, no_duplicates, make_plot)
% % This program quickly and randomly selects n integers from a to b.
% % The uniform distribution is used so that all integers are more equally
% % probable.  No claims are made about the actual probability
% % distributions.
% %
% % Input Arguments      ************************************************
% %
% % a and b are the lower and upper values of the range of integers.
% % Either a or b can be the higher and lower values of the range.
% %
% % n is the number of integers to select and can be a constant
% % or a two element vector.
% %
% % If n is a single number, then ndraw is a column vector.
% %
% % If n is a two element vector then n specifies the size of the output
% % matrix.  Example: n=[mm nn]; size(ndraw)=[mm nn];
% %
% % The user specifies whether the output is sorted 1 or randomly ordered 0.
% % The defualt is not sorted.  If sorted the output is in ascending order.
% %
% % The user specifies to remove duplicate integers 0 or allow duplicate
% % integers 1.  The default is to remove duplicates.  If duplicates are
% % removed, then each integer can occur only once.
% % 
% % If make_plot equals 1, then a plot of the random integers is made. 
% % If make_plot does not equal 1, then no plots are made.
% % The x-axis is the row or column indices whichever has more indices.  
% % The y-axis is the value of the integers.
% % 
% % This option was created to visually check the uniformity of the output
% % distribution. 
% % 
% % Output Arguments      ************************************************
% %
% % ndraw   is the matrix of random integers.
% %
% %         If n is a single number then ndraw is a column vector.
% %
% %         if n is a two element vector then ndraw is a matrix with
% %         size equal to n.  Example n=[mm nn]; size(ndraw)=[mm nn]
% %
% % count   is the number of iterations of selecting integers.
% %
% % count2  is the number of iterations of deleting extra random numbers
% %
% % error   1 there is at least 1 error
% %         0 there are no errors
% %
% % Comments on Speed      ***********************************************
% %
% % This program quickly selects n integers even when
% % b-a is very large (See the Large Integer Range Examples).
% %
% % When duplicates are allowed the program just selects the required
% % number of integers.  It is very simple case.
% %
% % When duplicates are removed, three regimes are used to optimize speed.
% %
% % The code runs the fastest in regime 2 pure rejection code contributed
% % by John D'Errico (woodchips@rochester.rr.com).  A catch is used to
% % prevent crashing since the pure rejection code will occasionally fail
% % to select the required number of integers.
% %
% % The code runs the slowest when min((b-a+1)-n, n)/(b-a) > 0.43
% % and utilizes a contributed alternative approach in this range
% % from Jos x@y.z.
% %
% % For all other cases, the program selects extra integers, then keeps the
% % unique integers and randomly deselects extra integers.
% % There is a selection while loop and a deselection while loop.
% %
% %
% % See example for syntax and definitions
% % of the input and output arguments
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Example='';       % Large integer Range Example with very small n
%
% a=1;              % a is the lowest integer that can be selected.
%                   % default value is 1
%
% b=10^15;          % b is the highest integer that can be selected.
%                   % default value is 10
%
% n=5;              % n is the number of integers to select.
%                   % default value is 5
%                   %
%                   % n can be a constant or a two element vector
%                   %
%                   % if n is a constant then the output is a column
%                   % vector with n rows
%                   %
%                   % if n is a two element matrix [mm nn]
%                   % then the output is a matrix of size [mm nn]
%
% sorted=1;         % 1 output is sorted (ascending order)
%                   % otherwise not sorted
%                   % default value is 0 (not sorted)
%
% no_duplicates=1;  % 1 there are no duplicate integers in the output
%                   % otherwise allow duplicate integers
%                   % default value is 1 (duplicates removed)
% 
% make_plot=1;      % 1 make plots of the integers
%                   % otherwise do not make any plots
% 
% [ndraw, count]=rand_int(a, b, n, sorted, no_duplicates, make_plot);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Example='';       % Very Large integer Range Example with small n
% 
% a=-10^15;
% b=10^15;
% n=1000;
% sorted=1;         %(ascending order)
% no_duplicates=1;
% [ndraw, count, count2]=rand_int(a,b,n,sorted, no_duplicates, make_plot);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Example='';       % Large integer Range Example with large n
% 
% a=1;
% b=10^7;
% n=[2.5*10^6 2];  % note that n is a two element matrix and very large
% sorted=0;
% no_duplicates=0;
% [ndraw, count, count2]=rand_int(a,b,n, sorted, no_duplicates, make_plot);
% 
% Examples of the 3 regimes
% 
% [ndraw, count, count2, error]=rand_int(-10000, 10000, [ 1000 10 ], 0, 0, 1);
% 
% [ndraw, count, count2, error]=rand_int(-10000, 10000, [ 10 1 ], 0, 0, 1);
% 
% [ndraw, count, count2, error]=rand_int(-10000, 10000, [ 100 10 ], 0, 0, 1);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Example=''; % Exceeding count limit.  The Pure Rejection Regime Failure
%
% % If the following code is run enough times the pure rejection regime
% % will return an error.
% 
% a=1;
% b=10000;
% n=250;  % note that n is a two element matrix and very large
% sorted=1;
% no_duplicates=1;
% [ndraw, count, count2]=rand_int(a,b,n, sorted, no_duplicates);
% 
% % The pure rejection regime has a glitch it will periodically fail
% % to select enough integers.  So a catch, to fail safe is put into place.
% %
% % Integer Selection Failure returns an error
% % and the catch returns an Error cancelled.
% %
% % Warning: Failed to select enough integers
% % > In rand_int at 382
% % Warning: Error Canceled.  Correct Number of Integers Selected.  Return full array
% % > In rand_int at 456
% %
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %
% %
% %
% % This program was written by Edward L. Zechmann
% %     date  23 January 2008
% %
% % modified  23 January 2008   updated comments
% %                             increased speed for a large range of
% %                             integers
% %
% % modified  24 January 2008   Modified the code to be faster
% %                             Added contributed alternative approach
% %                             from Jos x@y.z.
% %                             Created a second regime to quicken
% %                             integer selection when number of sleected
% %                             integers is nearly one-half of the range
% %                             Added some large integer range examples
% %
% % modified  25 January 2008   Added sorted option order of output
% %                             Now output can be sorted or random
% %
% %                             Added an option for n to be a two element
% %                             matrix stipulating the output matrix size
% %                             so n=[mm nn];
% %                             mm is number of rows
% %                             nn is number of columns
% %
% % modified  26 January 2008   Updated Comments
% %
% %                             Fixed a bug so that output is within the
% %                             selected range.
% %
% %                             Added contributed code from
% %                             John D'Errico (woodchips@rochester.rr.com)
% %                             Created a third regime to quickly select
% %                             a very small number of integers.
% %
% %                             Added warnings and error output when input
% %                             does not make sense or is out of range
% %
% % modified  30 January 2008   Rearranged the three regimes so that
% %                             third regime can catch failures from the
% %                             100% purge regime when it exceeds
% %                             the max_count limit.
% %
% % modified  31 January 2008   Fixed bug.  The ouptput is reshaped
% %                             to the specified size or the best size
% %                             for ndraw
% %
% %                             The comments were revised and updated
% %
% % modified  20 February 2008  Added option to make a plot of the integers
% %                             Added additional examples.
% %
% %
% % ***********************************************************
% %
% % Feel free to modify this code.
% %
% %

% set the error flag to no error
% flag = 0 means there is typical output
% flag = 1 mean the output must be truncated because of bad input
flag=0;

if nargin < 1
    a=1;
end

if isempty(a)
    flag=1; % return an empty array and an error
    warning('Input error!  Argument a is empty.  Returning empty output array');
end

if nargin < 2
    b=10;
end

if isempty(b)
    flag=1; % return an empty array and an error
    warning('Input error!  Argument b is empty.  Returning empty output array');
end

if nargin < 3
    n=5;
end

if isempty(n)
    flag=1; % return an empty array and an error
    warning('Input error!  Argument n is empty.  Returning empty output array');
end

if nargin < 4 || isempty(sorted)
    sorted=0;
end

if nargin < 5 || isempty(no_duplicates)
    no_duplicates=1;
end

if ~isequal(sorted, 1)
    sorted=0;
end

if ~isequal(no_duplicates, 1)
    no_duplicates=0;
end

if nargin < 6
    make_plot=0;
end


ndraw=[];
count=0;
count2=0;
error=0;
mm=0;
nn=0;

if isequal(flag, 1)

else

    % set the error flag to no error
    % flag = 0 means there is typical output
    % flag = 1 mean the output must be truncated because of bad input
    flag=0;
    % set the other flags to null
    flag2=0;
    flag3=0;

    % make sure certain inputs are constant integers
    %
    % n can be a 2 element vector
    % round a up to nearest integer
    a=ceil(a(1));

    % round b down to nearest integer
    b=floor(b(1));

    % make sure n has only 2 dimensions
    n=round(n(:, :, 1));
    sorted=round(sorted(1));
    no_duplicates=round(no_duplicates(1));



    % If n is a constant the output is a column vector
    %
    % if n is a two element vector n=[mm nn];
    % Then the output matrix has size [mm nn];

    if length(n) > 1
        mm=n(1);
        nn=n(2);
        n=prod(n);
    else
        mm=n;
        nn=1;
    end

    % Make sure b > a
    % swap values if necessary
    if a > b
        c=a;
        a=b;
        b=c;
    end

    % Make sure b-a >= 1 and that n >= 1.
    % Make sure there are at least n integers from b to a.
    % There are b-a+1 integers from b to a inclusive.
    % if conditions are false return reasonable output.
    if logical((b-a+1) < 1)
        flag=1;
        ndraw=[];
        warning('Input error!  Empty range of integers.  Returning empty output array');
    end

    % If specified to select less than 1 integer return an empty matrix.
    if logical(n < 1)
        flag=1;
        ndraw=[];
        warning('Input error!  Select less than 1 integer.  Returning empty output array');
    end

    % If specified to select more integers than available then return all
    % availabe integers and print a warning.
    if logical(n > (b-a+1)) && isequal(no_duplicates, 1)
        flag=1;
        ndraw=(a:b)';
        warning('Input error!  Selecting more integers than in the range and choosing no duplicates.  Returning a:b as the output array');
    end

    % if flag is set to 1 then set the error
    % and truncate the output to reasonable output.
    if isequal(flag, 1)
        error=1;
        n2=min([length(ndraw), n]);
        if n2 >= 1
            ndraw=ndraw(1:n2, 1);
        else
            ndraw=[];
        end
    end

    n3=n;
    if n >= (b-a+1)/2
        %reverse algorithm and deselect data points
        flag2=1;
        n=(b-a+1)-n;
    end

    % define the threshold limits for the different regimes
    thresh_regime1=0.43;    % generates entire matrix

    % The regime 2 threshold depends on whether selecting almost all the
    % data points or very few data points
    % not sure what teh optimum threshold is
    % this does not crash
    thresh_regime2l=min([0.07, 7/n3]);  % The probability of a duplicate
    % grows with range and number
    % of selected integers
    thresh_regime2h=min([0.05, 5/((b-a+1)-n3)]);  %

    if min((b-a+1)-n3, n3)/(b-a) > thresh_regime1
        % Regime 1
        % n is nearly equal to half the number of data points
        flag3=1;
    elseif logical(n3 <= (b-a+1)*thresh_regime2l) || logical(n3 >= (b-a+1)*(1-thresh_regime2h))
        % Regime 2
        % n is a small fraction of the range
        flag3=2;
    else
        % Regime 3 catch any failures from the first two regimes
        % Regime 2 will fail. regime 1 should b never fail.
        % Select random integers then remove the extra integers
        flag3=3;
    end

    % maximum number of times the selection while loop will run
    max_count=max(ceil(n3/(n3-(b-a))), 100);

    % nunique is the number of unique integers selected
    nunique=0;

    % count is the number of iterations of the selection while loop
    count=0;

    % count2 is the number of iterations of the deselection while loop
    count2=0;

    num_points=b-a+1;

    if isequal(flag, 1)

    else
        if isequal(no_duplicates, 1)

            % For the case of removing all duplicates
            fail=0;

            if  isequal(flag3, 1)
                % This is the build the entire matrix of value a then
                % discard extras regime.
                % This is faster approach for the case
                % min((b-a+1)-n,n)/(b-a) > thresh_regime1
                % Code was contributed by Jos x@y.z
                % code was modified by sorting the output
                % when sorting is specified
                r=randperm(num_points);
                if isequal(sorted, 1)
                    ndraw=sort(a-1+r(1:n))';
                else
                    ndraw=a-1+r(1:n)';
                end

            elseif isequal(flag3, 2)
                % This is the 100 percent purge regime.
                % There is a possibility of returning an empty array.
                %
                % The program runs faster by rejecting all integers rather than
                % sorting through the input and keeping the good integers
                %
                % This is faster approach for the case
                % (b-a+1)/n > 1-thresh_regime2 || n/(b-a) < thresh_regime2
                %
                % The judicious cuttoff of ten percent minimizes the chances of
                % an error and returning an empty array.

                flag5 = 1;
                count=0;
                while flag5 && logical(count < max_count)
                    count=count+1;
                    ndraw = unique(round((a - 1/2) + (b-a+1)*rand(n,1)))';
                    flag5 = (length(ndraw)~=n);
                end

            end

            % check to find out if enough integers were selected
            if logical(length(ndraw)~=n) && ~isequal(flag3, 3)
                ndraw=[];
                error=1;
                fail=1;
                % This warning is caught by the if statement below
                % warning('Failed to select enough integers');
            end

            % if not enough integers were selected
            if (~isequal(flag3, 1) && ~isequal(flag3, 2)) || fail

                ndraw=[];
                count=0;

                while (logical(nunique < n) || logical(count < 1)) && logical(count < max_count)

                    count=count+1;

                    % To make all combinations more equally likely, stretch the random
                    % distribution to a-0.5 and b+0.5.
                    % Round the numbers to the nearest integers.
                    % Make sure the selected integers are unique.
                    % Only one selection per integer.
                    % select an extra thirty percent of points because there will
                    % duplicates that are discarded.
                    num_draws=max(ceil((1.1+n/num_points)*(n-nunique)));
                    ndraw1=round((a+b)/2+((b+0.5)-(a-0.5))*(-0.5+rand(num_draws, 1)));

                    % make sure the numbers fit in the proper range
                    ndraw1(ndraw1 > b)=b;
                    ndraw1(ndraw1 < a)=a;

                    ndraw=unique([ndraw' ndraw1'])';

                    % Count the number of unique integers selected
                    nunique=length(ndraw);
                    count2=0;

                    if nunique > n
                        ndraw_del=[];
                        num_draws=ceil(1.3*(nunique-n));
                        aa=1;
                        bb=nunique;
                        nunique_del=0;

                        while nunique_del < (nunique-n) && logical(count2 < 100)
                            count2=count2+1;
                            ndraw_del=unique([ndraw_del' round((aa+bb)/2+((bb+0.5)-(aa-0.5))*(-0.5+rand(num_draws, 1)))']');
                            nunique_del=length(ndraw_del);
                        end
                        p = randperm(nunique_del);
                        delete_ix=ndraw_del(p);

                        save_ix=setdiff(aa:bb, delete_ix(1:(nunique-n)));
                        ndraw=ndraw(save_ix);

                    end

                end

            end


            % If the number of integers to be selected is greater than half the
            % size of the draw pool of then use a deselection method.
            if isequal(flag2, 1)
                if length(ndraw) < 2
                    ndraw=setdiff((a:b)', ndraw');
                else
                    ndraw=setdiff((a:b)', ndraw')';
                end
            end

            if ~isequal(sorted, 1)
                draw_pool=randperm(length(ndraw))';
                ndraw=ndraw(draw_pool);
            end

            if fail
                if length(ndraw)~=n3
                    warning('Returning empty array');
                    ndraw=[];
                    error=1;
                else
                    % The error has been succesfully corrected 
                    %warning('Error Canceled.  Correct Number of Integers Selected.  Returned full array');
                    error=0;
                end
            end

        else

            % For the case of allowing duplicates

            if isequal(flag2, 1)
                n=(b-a+1)-n;
            end

            ndraw=round((a+b)/2+((b+0.5)-(a-0.5))*(-0.5+rand(n, 1)));

            % make sure the numbers fit in the proper range
            ndraw(ndraw > b)=b;
            ndraw(ndraw < a)=a;

            if isequal(sorted, 1)
                % sort output
                ndraw=sort(ndraw);
            end

        end

    end
end

%
% ************************************************************************
%
% Reshape the output array to the desired dimensions
% If there are not enough data points, then
% determine the best size for the output.
%
if logical(nn >= 1) && logical(mm >= 1)
    if logical( numel(ndraw) >= mm*nn)
        % reshape the data to the specified size
        ndraw=reshape(ndraw, mm, nn);
    else
        % Not enough data points to
        % reshape the data to the specified size.
        %
        % Get the number of data points available
        % and reshape the output to a reasonable size.
        np=numel(ndraw);
        if np < 1
            ndraw=[];
        else

            % Find the smaller dimension size
            [md min_dim]=min([mm, nn]);

            % determine the best way to reshape the output matrix
            % try to preserve the value of the smaller dimension
            if isequal(min_dim, 1)
                if mm <= np
                    nn=floor(np/mm);
                else
                    mm=np;
                    nn=1;
                end
            else

                if nn <= np
                    mm=floor(np/nn);
                else
                    nn=np;
                    mm=1;
                end
            end

            ndraw=reshape(ndraw(1:(mm*nn)), mm, nn);
            
        end

    end

end


if isequal(make_plot, 1) && logical(numel(ndraw) >= 1)
    
    figure(1);
    delete(1);
    figure(1);
    [m1, n1]=size(ndraw);
    
    if m1 > n1
        ndraw2=ndraw';
        axis_dir='Row';
    else
        ndraw2=ndraw;
        axis_dir='Column';
    end
    
    [m1, n1]=size(ndraw2);
    
    plot(1:n1, ndraw2, 'linestyle', 'none', 'Marker', '.', 'MarkerEdgeColor', 'k');
    ylim([a b]);
    
    xlim([0.5 n1+0.5]);
    
    regime_desc={'Build Entire Array, Then Discard Extras', 'Pure Purge', 'Select 10% Extra ,Then Discard Extras'};
    
    title({'Plot of Random Integers', ['Regime ', num2str(flag3), ' ', regime_desc{flag3}]}, 'Fontsize', 18);
    xlabel([axis_dir,' Indices of Integers'], 'Fontsize', 16);
    ylabel('Value of Integers', 'Fontsize', 16);
    
end

