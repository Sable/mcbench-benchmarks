% KEYWORDs: random number variate generator generation log-concave 
% this program generates random numbers x from a log-concave function f(x)
% note that (1) f(x) must be a generalized probability density function (pdf),
%               i.e. a pdf known up to the normalizing constant, f(x)>0 on its support
%           (2) log[f(x)] must be concave, i.e. (d^2/dx^2)log[f(x)]<=0 for all x
% the generation of x is done as follows: 
%    (1) construct piece-exponential envelope function F(x), such that F(x)>=f(x), 
%        and log[F(x)]=log_f(p_i)+log_f_prime(p_i)*(x-p_i) on intervals b_i<=x<=b_{i+1}, where 
%        the construction points are p_i, b_i<p_i<b_{i+1}, i=1,2,...,I, note that log[F(x)] is 
%        a piece-linear function on intervals b_i<=x<=b_{i+1}
%    (2) sample x by rejection method: draw x from the normalized F(x) pdf, then accept x with 
%        probability f(x)/F(x)
% USAGE: [random_numbers, acceptance_rate]...
%         =rand_log_concave(log_function_name, function_parameters, x_pdf_support, I, x_construction, N)
% INPUTs: "log_function_name" is a string, it is the name of the function that returns log[f(x)]
%            and its derivative (d/dx){log[f(x)]}; this function must accept a vector argument "x"
%            and a vector of parameters "function_parameters"
%         "function_parameters" is a vector of parameters of function f(x)
%         "x_pdf_support" is a 2-element vector that contains the left and right boundaries of the
%            support of f(x), note that x_pdf_support(1) can be -Inf and x_pdf_support(2) can be +Inf
%         "I" is number of construction points used for the piece-exponential envelope function F(x),
%            increase I if the acceptance rate is low
%         "x_construction" is a 2-element vector that contains the left and right boundaries of the
%            the interval in which the construction points are chosen, this interval should
%            cover most (or all) of the probability mass (you can take x_construction=x_pdf_support)
%         "N" is the number of random numbers to generate
% OUTPUTs: "random_numbers" is the resulting 1-by-N vector of the generated random numbers
%          "acceptance_rate" is the averaged acceptance rate
% NOTES: (1) reference: "Automatic Nonuniform Random Variate Generation" by W. Hormann, J. Leydold
%                       and G. Derflinger, Springer (2004), pages 55-63
%        (2) numerical tricks are used to avoid numerical zero and infinity, and, as a result,
%            the calculations are done with logarithms, which makes the code more complicated
%        (3) in most acceptance tests of candidate x we avoid potentially costly computations 
%            of log[f(x)] by using an inscribed piece-exponential curve f_min(x)<=f(x)
% Last modified on Oct 22, 2007

function [random_numbers, acceptance_rate]...
    =rand_log_concave(log_function_name, function_parameters, x_pdf_support, I, x_construction, N)

% check x_pdf_support, I, x_construction, N
I=max([1, round(I)]);
N=max([1, round(N)]);
if numel(x_pdf_support)~=2 | numel(x_construction)~=2 ...
      | x_construction(1)<x_pdf_support(1) | x_construction(2)>x_pdf_support(2)
  error('MY ERROR: wrong choice of x_pdf_support and/or x_construction');
end

% set I construction points x_construction(1)<p_i<x_construction(2), i=1,2,...,I, 
% use homogenious grid for the construction points, or any other grid, 
% it MUST be sorted in increasing order!
p_vector=x_construction(1)+((x_construction(2)-x_construction(1))/(I+1))*(1:I);
%p_vector=sort(p_vector);

% set extended vector of construction point, which includes end points x_construction(:)
p_vector_ext=[x_construction(1), p_vector, x_construction(2)];
% find values of log[f(x)] and (d/dx)log[f(x)] at the extended construction points p_vector_ext
warning off;
[log_f_ext, log_f_prime_ext]=eval([log_function_name,'(p_vector_ext, function_parameters)']);
warning on;
% set values of log[f(x)] and (d/dx)log[f(x)] at the construction points p_vector
log_f=log_f_ext(2:end-1);
log_f_prime=log_f_prime_ext(2:end-1);
clear log_f_prime_ext

% check function values at the end points x_construction(:) for Inf and NaN
if isinf(log_f_ext(1)) | isnan(log_f_ext(1))
    % remove the first end point x_construction(1)
    p_vector_ext=p_vector_ext(2:end);
    log_f_ext=log_f_ext(2:end);
end
if isinf(log_f_ext(end)) | isnan(log_f_ext(end))
    % remove the last the end point x_construction(2)
    p_vector_ext=p_vector_ext(1:end-1);
    log_f_ext=log_f_ext(1:end-1);
end
% check function values at the construction points p_vector for Inf or NaN
if any(isinf(log_f)) | any(isnan(log_f)) | any(isinf(log_f_prime)) | any(isnan(log_f_prime))
    error('MY ERROR: Inf, NaN values found in log[f(x)], (d/dx)log[f(x)] at construction points');
end
% check if (d/dx)log[f(x)] is monotonicaly decreasing at the construction points p_vector
log_f_prime_diff=diff(log_f_prime);
if any(log_f_prime_diff>0)
  error('MY ERROR: the function is not log-concave');
end
% check for and exclude repeated values of (d/dx)log[f(x)]
if any(log_f_prime_diff==0)
  [log_f_prime, indexes_unique]=unique(log_f_prime);
  log_f=log_f(indexes_unique);
  p_vector=p_vector(indexes_unique);
  I=numel(p_vector);
  clear indexes_unique
end
clear log_f_prime_diff

% compute the intersection points b_i of linear functions log_f(p_i)+log_f_prime(p_i)*(x-p_i), i.e
% b_i satisfies log_f(p_i)+log_f_prime(p_i)*(b_i-p_i)=log_f(p_{i+1})+log_f_prime(p_{i+1})*(b_i-p_{i+1})
if I>1
  b_vector=p_vector(1:(I-1))...
           +(log_f_prime(2:I).*(p_vector(2:I)-p_vector(1:(I-1)))+log_f(1:(I-1))-log_f(2:I))...
           ./(log_f_prime(2:I)-log_f_prime(1:(I-1)));
else
  b_vector=[];
end
% add points x_pdf_support(1) and x_pdf_support(2)
b_vector=[x_pdf_support(1), b_vector, x_pdf_support(2)];

% find A_i that are integrals of envelope function F(x)=exp[log_f(p_i)+log_f_prime(p_i)*(x-p_i)] 
% over intervals [b_i,b_{i+1}], note that A_i are renormalized so that max(A_i)=1, and i-1,2,...,I
A=zeros(1,I);
A_partial=zeros(1,I);
delta_b=(b_vector(2:(I+1))-b_vector(1:I));
exp_argument=log_f_prime.*delta_b;
exp_argument_1=log_f+log_f_prime.*(b_vector(2:(I+1))-p_vector);
exp_argument_2=log_f-log_f_prime.*(p_vector-b_vector(1:I));
indexes_1=find(exp_argument>=0.3);                     % large positive values
indexes_2=find(exp_argument<=-0.3);                    % large negative values
indexes_3=find(exp_argument>-0.3 & exp_argument<0.3);  % small values
n3=numel(indexes_3);
if numel(indexes_1)>0
  % exp_argument>=0.3 case, in this case we will use formula A=A_partial*exp[exp_argument_1] below
  A_partial(indexes_1)=(1-exp(-exp_argument(indexes_1)))./log_f_prime(indexes_1);
end
if numel(indexes_2)>0
  % exp_argument<=-0.3 case, in this case we will use formula A=A_partial*exp[exp_argument_2] below
  A_partial(indexes_2)=(exp(exp_argument(indexes_2))-1)./log_f_prime(indexes_2);
end
if n3>0
  % use Taylor expansion for abs(exp_argument)<0.3 to obtain accurate results,
  % note that in this case we will use formula A=A_partial*exp[exp_argument_2] below
  exp_argument=exp_argument(indexes_3);
  s=zeros(1,n3);
  tmp_factor=ones(1,n3);
  for k=0:12                 % include first 13 terms of Taylor expansion
    % add Taylor terms
    s=s+tmp_factor;
    % update factor
    tmp_factor=(1/(k+2))*exp_argument.*tmp_factor;
  end
  A_partial(indexes_3)=delta_b(indexes_3).*s;
  clear s
end
% to obtain A, multiply A_partial by factors exp[exp_argument_1] and exp[exp_argument_2],
% in addition, to avoid numerical 0 and Inf, we normalize log(A) so that max[log(A)]=0
indexes_2=[indexes_2,indexes_3];
log_A_1=exp_argument_1(indexes_1)+log(A_partial(indexes_1));
log_A_2=exp_argument_2(indexes_2)+log(A_partial(indexes_2));
norm_exp_argument=max([max(log_A_1), max(log_A_2)]);
A(indexes_1)=exp(log_A_1-norm_exp_argument);
A(indexes_2)=exp(log_A_2-norm_exp_argument);
clear tmp* delta_b exp_argument* A_partial log_A_* indexes* norm_exp_argument

% obtain cumulative distribution function (cdf) values proportional to A,
% we will later randomly choose intervals i=1,2,...,I according to these cdf values
cdf_values=cumsum(A);
clear A
cdf_values=cdf_values*(1/cdf_values(I));
cdf_values(I)=1;
cdf_values=[0, cdf_values];

% generate N random numbers by drawing from envelope pdf F(x) and using the rejection algorithm
random_numbers=zeros(1,N);
total_counter=0;
accept_counter=0;
rand_num_counter=0;
log_f_calculation_counter=0;
% in a loop generate n candidate numbers x_candidates from F(x), run this loop until we 
% generate all N numbers, below choose n=ceil(N/10), or use any other choice of you own
n=ceil(N/10);
while 1
  % using "cdf_values", we randomly choose interval indexes "i_indexes" of the I intervals of the
  % piece-exponential envelope function F(x), according to the probabilities of the intervals
  i_indexes=zeros(1,n);
  % generate numbers of intervals according to "cdf_values"
  u=rand(1,n);
  numbers_of_intervals=histc(u, cdf_values);
  numbers_of_intervals(I+1)=[];
  % set "i_indexes" according to the generated "numbers_of_intervals"
  n_start=1;
  for i=1:I
    i_indexes(n_start:(n_start+numbers_of_intervals(i)-1))=i;
    n_start=n_start+numbers_of_intervals(i);
  end
  clear numbers_of_intervals
  % randomly permutate interval indexes "i_indexes"
  i_indexes=i_indexes(randperm(n));

  % set log_f_i, log_f_prime_i, b_i, b_i_plus_1 and p_i for intervals given by "i_indexes"
  log_f_i=log_f(i_indexes);
  log_f_prime_i=log_f_prime(i_indexes);
  b_i=b_vector(i_indexes);
  b_i_plus_1=b_vector(i_indexes+1);
  p_i=p_vector(i_indexes);
  
  % draw candidate values x_candidates from the envelope pdf function F(x) that is 
  % proportional to exp[log_f_prime(p_i)*(x-p_i)] on intervals b_i<=x<=b_{i+1}
  exp_argument=log_f_prime_i.*(b_i_plus_1-b_i);
  indexes_1=find(exp_argument<=-0.1);                       % large negative values
  indexes_2=find(exp_argument>=0.1);                        % large positive values
  indexes_3=find(exp_argument>-0.1 & exp_argument<0.1);     % small values
  n3=numel(indexes_3);
  x_candidates=zeros(1,n);
  u=rand(1,n);
  if numel(indexes_1)>0
    % we directly calculate the inverted cdf of F(x)
    x_candidates(indexes_1)=b_i(indexes_1) ...
        +log(1-u(indexes_1)+u(indexes_1).*exp(exp_argument(indexes_1)))./log_f_prime_i(indexes_1);
  end
  if numel(indexes_2)>0
    % we directly calculate the inverted cdf of F(x)
    x_candidates(indexes_2)=b_i_plus_1(indexes_2) ...
        +log(u(indexes_2)+(1-u(indexes_2)).*exp(-exp_argument(indexes_2)))./log_f_prime_i(indexes_2);
  end
  if n3>0
    % for numerical accuracy we use Taylor expansion for exponent to calculate the inverted cdf of F(x)
    exp_argument=exp_argument(indexes_3);
    s1=zeros(1,n3);
    tmp_factor=ones(1,n3);
    for k=0:9                 % include first 10 terms of Taylor expansion
      % add Taylor terms
      s1=s1+tmp_factor;
      % update factor
      tmp_factor=(1/(k+2))*exp_argument.*tmp_factor;
    end
    % next, for accuracy use Taylor expansion for logarithm to calculate the inverted cdf of F(x)
    u=u(indexes_3);
    tmp_multiplier=u.*exp_argument.*s1;
    s2=zeros(1,n3);
    tmp_factor=ones(1,n3);
    k_max=max([15, round(-34.2/log(max(abs(tmp_multiplier))))]);
    for k=0:k_max
      % add Taylor terms
      s2=s2+(1/(k+1))*tmp_factor;
      % update factor
      tmp_factor=-tmp_multiplier.*tmp_factor;
    end
    % set x_candidates
    x_candidates(indexes_3)=b_i(indexes_3)+u.*(b_i_plus_1(indexes_3)-b_i(indexes_3)).*s1.*s2;
    clear s1 s2 
  end
  if any(x_candidates<b_i) | any(x_candidates>b_i_plus_1)
    warning('MY WARNING: some of x_candidates are outside of interval [b_i, b_{i+1}]');
  end
  clear tmp* exp_argument indexes* u b_i b_i_plus_1

  % calculate the log value of the envelope function at x_candidates
  log_f_envelope_x=log_f_i+log_f_prime_i.*(x_candidates-p_i);
  
  % note that in most acceptance tests of candidate x we can save computational time by avoiding many
  % potentially costly computations of log[f(x)]; this is done by using an inscribed piece-exponential
  % curve f_min(x)<=f(x) and trying log[f_min(x)] for the tests before using log[f(x)]
  % find log_f_x_min=log[f_min(x)] such that log_f_x_min<=log[f(x)] for any x
  log_f_x_min=-Inf+zeros(1,n);
  % find x that satisfy p_vector_ext(1)<=x<p_vector_ext(end) (i.e., x that are inside 
  % the range of the extended construction points)
  tmp_indexes=find(x_candidates>=p_vector_ext(1) & x_candidates<p_vector_ext(end));
  if ~isempty(tmp_indexes)
    % cut out x and other vectors, such that p_vector_ext(1)<=x<p_vector_ext(end)
    x_cut=x_candidates(tmp_indexes);
    i_indexes_cut=i_indexes(tmp_indexes);
    p_i_cut=p_i(tmp_indexes);
    % find indexes j such that p_vector_ext(j_indexes)<=x_cut<p_vector_ext(j_indexes+1)
    j_indexes_cut=i_indexes_cut-(p_vector_ext(1)>=p_vector(1))+(x_cut>=p_i_cut);
    % to find log_f_x_min, we use inscribed linear interpolation for log[f(x)] inside 
    % intervals p_vector_ext(j_indexes) <= x < p_vector_ext(j_indexes+1)]
    p_left_cut=p_vector_ext(j_indexes_cut);
    p_right_cut=p_vector_ext(j_indexes_cut+1);
    if any(x_cut<p_left_cut) | any(x_cut>p_right_cut)
      error('MY ERROR: wrong p-interval in calculation of log_f_x_min');
    end
    log_f_left_cut=log_f_ext(j_indexes_cut);
    log_f_right_cut=log_f_ext(j_indexes_cut+1);  
    log_f_x_min_cut=log_f_left_cut ...
      +(x_cut-p_left_cut).*(log_f_right_cut-log_f_left_cut)./(p_right_cut-p_left_cut);
    % set log_f_x_min
    log_f_x_min(tmp_indexes)=log_f_x_min_cut;
    clear *_cut tmp*
  end
  clear p_i log_f_i log_f_prime_i i_indexes

  % find x_candidates that we accept, we accept them if and only if rand<=f(x)/F(x)
  % to avoid potentially costly computations of log[f(x)], fist we try to use  
  % the fact that, if rand<=f_min(x)/F(x), then rand<=f(x)/F(x) because f_min(x)<=f(x)
  % calculate log of n random numbers
  log_u=log(rand(1,n));
  
  % check condition rand<=f_min(x)/F(x) and set acceptance_flag to 1/0 if it is satisfied/unsatisfied
  acceptance_flag=(log_u<=log_f_x_min-log_f_envelope_x);
  
  % check condition rand<=f(x)/F(x) and set acceptance_flag to 1/0 if it is satisfied/unsatisfied
  % cut out remaining candidate x (not yet accepted) and other vectors that we need
  x_cut_indexes=find(acceptance_flag==0);
  x_cut=x_candidates(x_cut_indexes);
  log_f_x_cut=eval([log_function_name,'(x_cut, function_parameters)']);
  log_f_calculation_counter=log_f_calculation_counter+numel(x_cut);
  log_f_envelope_x_cut=log_f_envelope_x(x_cut_indexes);
  if any(log_f_x_cut>log_f_envelope_x_cut*0.999999999999)
    % error if F(x)>=f(x) is not satisfied for the envelope F(x)
    error('MY ERROR: envelope F(x) is less than function f(x)');
  end
  log_u_cut=log_u(x_cut_indexes);
  acceptance_flag(x_cut_indexes(find(log_u_cut<=log_f_x_cut-log_f_envelope_x_cut)))=1;
  clear *_cut tmp*
  
  % find indexes of all accepted x_candidates 
  x_indexes=find(acceptance_flag);
  n_accepted=numel(x_indexes);
  total_counter=total_counter+n;
  accept_counter=accept_counter+n_accepted;
  % save accepted x_candidates if there are any
  if n_accepted>0
    % set the number of accepted candidates that we need to have, no more than N in total
    ind_end=min([n_accepted, N-rand_num_counter]);
    ind=1:ind_end;
    random_numbers(rand_num_counter+ind)=x_candidates(x_indexes(ind));
    rand_num_counter=rand_num_counter+ind_end;
    clear ind
  end
  
  % check if we obtained N accepted numbers in total
  if rand_num_counter>=N
    % break because we have obtained N random numbers
    break;
  end
  clear x_candidates x_indexes log_f_envelope_x log_f_x log_u acceptance_flag 
end

% set acceptance rate
acceptance_rate=accept_counter/total_counter;

% if want to, then display the percentage of x_candidates for which we had to compute log[f(x)]
if 0
  disp(sprintf('percentage of acceptance tests of candidate x which required computation of log[f(x)] is %.3g%%', ...
    100*log_f_calculation_counter/total_counter));
end
