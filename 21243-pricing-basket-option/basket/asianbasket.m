function Price = asianbasket(basketstruct,OptSpec,ExerciseDates,Settle,N,n,r,Strike,...
    Americanoption,AvgType, AvgPrice, AvgDate)
%ASIANBASKET price asian basket options
%
% basketstruct - basket structure obtained from BASKETSET
% OptSpec - Specifies if its a call or a put
% T - time to maturity
% N - number of time intervals
% n - number of replications
% Strike - Strike Price. For floating Asian options specify NaN as the
% Strike
% AmericanOpt -(Optional) If AmericanOpt = 0, NaN, or is
%               unspecified, the option is a European option. If
%               AmericanOpt = 1, the option is an American option.
% AvgType -  (Optional)String = 'arithmetic' for arithmetic average (default) or 'geometric' for geometric average.
%
% AvgPrice - (Optional) Scalar representing the average price of the underlying asset at Settle. This argument is used when AvgDate < Settle. Default is the current stock price.
%
% AvgDate - (Optional) Scalar representing the date on which the averaging period begins.
%
% Currently calculating only fixed price asian options
% Assuming stock prices at the settlement date are given and settlement and
% valuation dates are the same.

if nargin < 8
    error('finderiv:asianbasket:InvalidNumInputs','There needs to be a minimum of 8 arguments')
end

if ~exist('Americanoption')||isempty(Americanoption)
    Americanoption = 0;
end

if exist('AvgPrice')& (~exist('AvgDate')|| isempty(AvgDate))
    error('finderiv:asianbasket:InvalidInputs','There needs to be an AvgDate with an AvgPrice')
end

if isempty(AvgType) || ~exist('AvgType')
    AvgType = 'Arithmetic';
end

if ~strcmpi(AvgType,'Arithmetic') & ~strcmpi(AvgType,'Geometric')
    error('finderiv:asianbasket:InvalidAvgType','AvgType must be either Arithmetic or Geometric')
end

%(n,num_stock,N+1)
if Americanoption ~=1                               % for eurpoean options
    T = yearfrac(Settle,ExerciseDates);
    [S,num] = basketsim(basketstruct,T,N,n,r);          % calls stock price simulation engine
    PriceM = zeros(1,n);

    adjust_mean_factor = ones(N+1,1);
    t_adj = 0;
    if exist('AvgDate')& ~isempty(AvgDate)
        t_adj = yearfrac(Settle,AvgDate);
        if t_adj > 0
            % calculate number of time steps to skip
            steps_skip = round(t_adj/(T/N));
            adjust_mean_factor(1:steps_skip) = 0;
        end
    end


    for i = 1:n
        S_port = num*reshape(S(i,:,:),size(num,2),N+1); % calculates portfolio value at each time instant for one replication
        S_final = S_port(end);

        S_port = adjust_mean_factor'.*S_port;

        if t_adj < 0
            steps_back = abs(round(t_adj/(T/N)));

            if strcmpi(AvgType,'Arithmetic')
                S_port = (AvgPrice*steps_back + sum(S_port))/(N+1+steps_back); % since we are averaging considering the average price at settlement
            end

            if strcmpi(AvgType,'Geometric')
                S_port = ((AvgPrice^steps_back)*prod(S_port))^(1/(N+1+steps_back));
            end

        else

            if strcmpi(AvgType,'Arithmetic')
                S_port = mean(S_port);
            end

            if strcmpi(AvgType,'Geometric')
                S_port = geomean(S_port);
            end
        end

        if strcmp(OptSpec,'Call')
            if isnan(Strike)
                Strike =  S_final;
                PriceM(i) = max(0,-S_port+Strike);
            else
                PriceM(i) = max(0,S_port-Strike);
            end
        end

        if strcmp(OptSpec,'Put')
            if isnan(Strike)
                Strike =  S_final;
                PriceM(i) = max(0,S_port-Strike);
            else
                PriceM(i) = max(0,-S_port+Strike);
            end
        end
    end
    Price = exp(-r*T)*mean(PriceM);
end

% Price American Options

if Americanoption ==1                               % for american options
    if length(ExerciseDates)~=2
        error('finderiv:asianbasket:InvalidExerciseDates','American options needs two dates as boundary of exercise dates')
    end



    T = yearfrac(Settle,ExerciseDates{end});
    t_adj_exercise = yearfrac(Settle, ExerciseDates{1});

    if t_adj_exercise < 0
        t_adj_exercise = 0;
    end

    steps_skip_exercise = round(t_adj_exercise/(T/N));  % number of steps to skip before exercising
    [S,num] = basketsim(basketstruct,T,N,n,r);          % calls stock price simulation engine

    PriceM = zeros(n,N - steps_skip_exercise+1);              % initialize payoff matrix

    adjust_mean_factor = ones(N+1,1);
    S_average = zeros(n, N - steps_skip_exercise+1);           % initialize the average price for the period in which option can be exercised
    t_adj = 0;

    if exist('AvgDate')& ~isempty(AvgDate)
        t_adj = yearfrac(Settle,AvgDate);

        if t_adj > 0
            % calculate number of time steps to skip
            steps_skip = round(t_adj/(T/N));
            adjust_mean_factor(1:steps_skip) = 0;
        end

    end

    for i = 1:n
        S_port = num*reshape(S(i,:,:),size(num,2),N+1); % calculates portfolio value at each time instant for one replication
        S_final = S_port(end);

        %         if isnan(Strike)
        %             Strike = S_final;
        %         end

        S_port = adjust_mean_factor'.*S_port;

        if t_adj < 0
            steps_back = abs(round(t_adj/(T/N)));
            if strcmpi(AvgType,'Arithmetic')
                for j = 1:N - steps_skip_exercise+1
                    S_average(i,j) = (AvgPrice*steps_back + sum(S_port(steps_skip_exercise+1:j+steps_skip_exercise)))/(j+steps_back); % since we are averaging considering the average price at settlement
                end
            end

            if strcmpi(AvgType,'Geometric')
                for j = 1:N - steps_skip_exercise+1
                    S_average(i,j) = ((AvgPrice^steps_back)*prod(S_port(steps_skip_exercise+1:j+steps_skip_exercise)))^(1/(j+steps_back));
                end
            end
        else
            if strcmpi(AvgType,'Arithmetic')
                for j = 1:N - steps_skip_exercise+1
                    S_average(i,j) = mean(S_port(steps_skip_exercise+1:j+steps_skip_exercise));
                end
            end

            if strcmpi(AvgType,'Geometric')
                for j = 1:N - steps_skip_exercise+1
                    S_average(i,j)  = geomean(S_port(steps_skip_exercise+1:j+steps_skip_exercise));
                end
            end
        end

    end


end

if strcmp(OptSpec,'Call')
    PriceM(:,end) = max(0,S_average(:,end)-Strike);
end

if strcmp(OptSpec,'Put')
    PriceM(:,end) = max(0,-S_average(:,end)+Strike);
end

% Implementing LMS algorithm for American Options
for nn = N:-1:steps_skip_exercise+1

    if strcmp(OptSpec,'Call')
        y = max(0,S_average(:,nn - steps_skip_exercise)-Strike);
    end

    if strcmp(OptSpec,'Put')
        y = max(0,-S_average(:,nn - steps_skip_exercise)+Strike);
    end

    yex = [];
    X   = [];
    Y   = [];
    for i = 1:n
        if y(i) > 0                     % if in-the-money, then...
            yex = [yex; y(i)];          % exercise values
            X   = [X; S_average(i,nn - steps_skip_exercise)];          % stock prices at exercise values
            Y   = [Y;(exp(-r*(T/N)).^[1:N-nn+1])*PriceM(i,nn+1-steps_skip_exercise:N-steps_skip_exercise+1)']; % discount the cash flows to time step nn
        end
    end
    % basis functions 1, X, X^2
    A = [ones(size(yex)) X  X.*X   ] ;
    % Least-Square Regression:
    [U,W,V] = svd(A);
    b = V*(W\(U'*Y));
    yco = A*b;
    % stopping rule
    j = 1;
    for i = 1:n
        if y(i)>0
            if (yex(j) > yco(j))
                PriceM(i,:) = 0;
                PriceM(i,nn - steps_skip_exercise) = yex(j);
            end
            j = j+1;
        end
    end
end
PriceM = [zeros(n, steps_skip_exercise) PriceM];
Price = sum(PriceM*exp(-r*(T/N)).^[0:N]')/n;     % final price of the American contract

end