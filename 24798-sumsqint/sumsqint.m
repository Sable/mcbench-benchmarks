function y=sumsqint(n)
% SUMSQINT - solve x^2+y^2=n for non-negative integers x,y
%
% usage: y=sumsqint(n)
%
% SUMSQINT(N) returns an kx2 array Y where Y(i,:) is a pair of integer
% solutions [x,y] to x^2+y^2=N with 0<x<=y or [] if no solutions exist.
%
% SUMSQINT(F) where F is an array of positive prime integers returns the
% solutions to x^2+y^2=prod(F).  This is useful for solving equations such
% as x^2+y^2=z^2 where z is known, and extends the maximum feasible N up to
% about 2^100 (provided the prime factors are small enough).
%
% NOTE: for efficiency reasons, if factors of N are given they are assumed
% to be prime otherwise the algorithm might never terminate.
%
% Example:
%   sumsqint(1) % returns [0,1]
%   sumsqint(65) % returns [1,8;4,7]
%   sumsqint(repmat(factor(25e6),1,2)) % solves x^2+y^2=(25e6)^2
%   sumsqint([factor(25e6-1),factor(25e6+1)]) % solves x^2+y^2=(25e6)^2-1
%   sumsqint(vpi(5)^100)  % returns 51x2 vpi array (requires VPI toolbox)
%   sumsqint(vpi(65)^100) % returns 5101x2 vpi array
%
% Algorithm: based on gaussian integers: n = x^2+y^2 = (x+iy)(x-iy).
%
% Every gaussian integer has a unique factorization in terms of gaussian
% primes up to multiplication by units (1,-1,i,-i).  Every p+iq is a
% gaussian prime if and only if either p+iq=u*(4n+3) where u is a unit and
% 4n+3 is a prime integer, or p^2+q^2 is prime.
%
% First, find the integer factorization n=d*p1^k1*...&pm^km where d is 1 or
% a square product of primes that are 3 mod 4, and the pj are primes either
% 2 or 1 mod 4.  Each pj can be factored as (a+ib)(a-ib) for some a,b. This
% is found by table lookup if pj is small, or by brute force (suggestions
% for improvement are welcome!)
%
% Every solution (x,y), x+iy is the product of d and a combination of
% (a+ib) or (a-ib).  Multiplication by a unit does not produce a distinct
% solution, and the choice of (1+i) vs (1-i) does not affect the result (up
% to ordering and sign).
%
% This function is compatible with vpi integers in John D'Errico's Variable
% Precision Integer toolbox (see link on download page), provided the
% largest factor is not larger than intmax (2^31)

% Author:
%   Ben Petschel
% Change history:
%   20/7/2009: first release
%   13/8/2009: fixed bug that occurs when vpi prime factors are > 100
%   13/8/2009: added support for factored inputs
%   16/8/2009: changed list of guassian factors to sparse matrix;
%   16/8/2009: added internal option to remember newly found prime factors
%
% TODO: test quadratic residue method to see if there is a performance gain

persistent pmax pf % a list of small gaussian prime integers and their principal factors

addpf=true; % set addpf to false if you don't want to add newly found prime factors to the persistent list

if isempty(pf),
  p=[2,5,13,17,29,37,41,53,61,73,89,97];
  pmax=max(p);
  pf=sparse(pmax,2);
  pf(p,:)=[1,1;1,2;2,3;1,4;2,5;1,6;4,5;2,7;5,6;3,8;5,8;4,9];
  if any(nonzeros(sum(pf.^2,2))~=p(:)),
    error('check built-in list of prime factors');
  end;
end;

isvpi=isa(n,'vpi');
nmax=2^53;

if  numel(n)==1 && (iscell(n) || (n<0) || (~isvpi&&(n~=floor(n)||~isfinite(n)))),
  error('sumsqint:nonneginteger','n must be a non-negative integer');
  %y=[];
  %return;
elseif  numel(n)>1 && (iscell(n) || any(n<1) || any(n~=floor(n)) || (~isvpi&&any(n~=floor(n)|~isfinite(n)))),
  error('sumsqint:posintegerfactors','factors of n must be positive integers');
  %y=[];
  %return;
elseif numel(n)==1 && ~isvpi && n>=nmax,
  error('sumsqint:doubletoobig','Input n>=2^53 (too large to store exactly as a double).');
elseif numel(n)>1 && ~isvpi && prod(n)>=nmax^2
  error('sumsqint:factorstoobig','Input n>=(2^53)^2 (too large to store components exactly as a double).');
elseif numel(n)==1 && ~isvpi && n>intmax,
  try
    n=vpi(n);
    isvpi=true;
    warning('sumsqint:convertvpi','intmax < n < 2^53; converting to vpi');
  catch
    error('sumsqint:requirevpi','Require Variable Precision Integer toolbox for n>intmax');
    %y=[];
    %return;
  end;
elseif n==0,
  y=[0,0];
  return;
elseif n==1,
  y=[0,1];
  return;
end;

if numel(n)>1
  f=sort(n(n>1));
else
  f = factor(n);
end;
if isvpi,
  % convert to vpi for use with hist
  f=double(f);
  if any(f>=nmax),
    error('sumsqint:largefactor','Prime factors of n are >= 2^53 (too large for current algorithm)');
    %y=[];
    %return;
  end;
end;
fu=unique(f);
if numel(fu)==1
  fk=numel(f);
else
  fk=hist(f,fu);
end;
if isvpi,
  % convert back to vpi
  fu=vpi(fu);
end;

% check which factors are gaussian primes
frem3 = mod(fu,4)==3;
if any(mod(fk(frem3),2)),
  % gaussian prime factors must occur even number of times
  y=[]; % no solutions exist
  return;
else
  if ~any(frem3),
    xy=[0,1];
    if isvpi,
      xy=vpi(xy);
    end;
  else
    xy = [0,prod(fu(frem3).^(fk(frem3)/2))];
  end;

  fu = fu(~frem3);
  fk = fk(~frem3);

  for j=1:numel(fu),
    pj=fu(j);
    kj=fk(j);
    % factor pj as pjf*pjfc and determine all unique powers (pjf^m)*(pjfc^(kj-m))
    if pj==2,
      % powers of 2 yield only one possibility
      if mod(kj,2)==1,
        % sum of identical squares
        pjklist=pj^((kj-1)/2)*[1,1];
      else
        % sum of 0 and a square
        pjklist=[0,pj^(kj/2)];
      end;

    else
      if pj<=pmax && pf(pj,1)>0
        % pj has been factored
        pjf=pf(pj,:);
        if isvpi,
          pjf=vpi(pjf);
        end;
        pjfc=gaussconj(pjf);
      else
        % find a,b such that a^2+b^2=pj
        %
        % one method to consider in future versions:
        % Randomly choose x; half the time it will be a quadratic
        % non-residue.  If it is, have x^((p-1)/2) = -1 (legendre symbol),
        % and let y=x^((p-1)/4).  So y^2+1=(y+i)*(y-i) is a multiple of p,
        % and gcd(y+i,p) is a prime factor of p.
        %
        % for now just use brute force
        a=1;
        if isvpi,
          a=vpi(a);
        end;
        keepgoing=true;
        if isvpi
          while keepgoing,
            [b,rem]=sqrt(pj-a^2);
            if rem==0,
              keepgoing=false;
            else
              a=a+1;
            end;
          end;
        else
          while keepgoing,
            b=sqrt(pj-a^2);
            if b==floor(b),
              keepgoing=false;
            else
              a=a+1;
            end;
          end;
        end;
        pjf=[a,b];
        pjfc=[a,-b];
        if addpf
          % add [a,b] to list of gaussian factors
          pf(pj,:)=pjf;
          pmax=max(pmax,pj);
        end;
      end;
      % now multiply by all (pjf^m)*(pjfc^(k-m))
      pjfpow=gausspowall(pjf,kj);
      pjfcpow=gausspowall(pjfc,kj);
      pjklist=zeros(size(pjfpow));
      if isvpi,
        pjklist=vpi(pjklist);
      end;
      for ii=1:kj+1,
        pjklist(ii,:)=gaussprod(pjfpow(ii,:),pjfcpow(kj+2-ii,:));
      end;
    end;
    % have the list of all pjf^ii*pjf^(k-ii); now multiply it with all solutions so far
    nxy=size(xy,1);
    npjk=size(pjklist,1);
    xyold=xy;
    xy=zeros(nxy*npjk,2);
    if isvpi,
      xy=vpi(xy);
    end;
    for ii=1:nxy
      for jj=1:npjk
        % multiply xy(ii) by pjklist(jj)
        xy((ii-1)*npjk+jj,:)=gaussprod(xyold(ii,:),pjklist(jj,:));
      end;
    end;
    % now sort the unique solutions (check if there is some way of only
    % needing to do this once, while saving on memory)
    xy=sort(abs(xy),2);
    xy=unique(xy,'rows');
  end;
  y=xy;
end;

end % main function sumsqint(...)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y=gaussconj(ab)
% calculates conjugate of ab: [a,b]->[a,-b]

y=ab.*[1,-1];

end % helper function gaussconj(...)


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function y=gausspow(ab,n)
% % calculates ab^n where ab=(a+bi)
% %   use matrix multiplication: [c,d]x[a,b] = [c,d]*[a,b;-b,a];
% 
% if n==0,
%   y=[1,0];
% else
%   y=ab;
%   if n>1,
%     abmat=[ab;-ab(2),ab(1)];
%   end;
%   for k=2:n,
%     y=y*abmat;
%   end;
% end;
% 
% end % helper function gausspow(...)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y=gausspowall(ab,n)
% calculates all powers ab^0,ab,...,ab^n where ab=[a,b]=(a+bi)
%   use matrix multiplication: [c,d]x[a,b] = [c,d]*[a,b;-b,a];

y=repmat(ab,n+1,1); % saves having to do check if ab is vpi
if n>0,
  y(1,:)=[1,0];
  if n>1,
    abmat=[ab;-ab(2),ab(1)];
  end;
  for k=2:n,
    y(k+1,:)=y(k,:)*abmat;
  end;
end;

end % helper function gausspowall(...)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y=gaussprod(ab,cd)
% calculates [a,b]x[c,d]=[ac-bd,bc+ad];

% see if this can be used:
%y=crossproduct(ab,cd);
y=[ab(1)*cd(1)-ab(2)*cd(2),ab(2)*cd(1)+ab(1)*cd(2)];

end % helper function gaussprod(...)
