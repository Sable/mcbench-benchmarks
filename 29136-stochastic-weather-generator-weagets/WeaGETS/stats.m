function [avg,std] = stats(F,P,v)
%
% this function calculates the mean and standard deviation of the
% non zeros elements of a matrix F.  The location of the non zeros
% elements are given by 1s in matrix P.  v is a column vector of 1s
% with a length equal to the number of lines in matrix F (or P).
% matrix P (PnP in main) and F (Tminw or Tmaxwis or Rad) are of dimensions [Nyears 365]

% make sure there are no NaN due to a combination of one day over all years
% where there are either missing values or always dry days (or wet),
% resulting in a column of 0  Caron Brissette mai 2004


avg=sum(F)./sum(P);    % if sum(P) = 0, then, by definition, sum(F) = 0, and we get a NaN.


% lorsqu'une valeur de avg est NaN, prendre les valeur des 10 données précédentes
% et des 10 données suivantes, en faire une moyenne et utiliser cette
% nouvelle valeur pour remplasser la valeur NaN.  Brissette juin 2004
% NB: it there are more than 21 consecutive NaN values, this will not work,
% but that would mean that the dataset is worthless anyway !

c=find(isnan(avg)>0);  % identify indices with NaN
if size(c)>=1
     avg2=[avg(356:365) avg avg(1:10)];     % pad matrix before and after to allow for averaging for first 10 and last 10 values
     for x=1:length(c)
         temp=avg2(c(x):c(x)+20);               % values `c`, defined in avg, have their indice increased by 10 in avg2, length(temp)=21
         w=find(isfinite(temp)==1);             % find indices of temp that are finite values
         avg(c(x))=sum(temp(w))/length(w);      % over 21 days (10 before and after), take average over all days that are not NaN.
     end
end

mavg=kron(avg,v);
P.*(F-mavg);
B=sum(P)-1;
a=find(B==0);
B(a)=1;
std=sqrt(sum((P.*(F-mavg)).^2)./B);