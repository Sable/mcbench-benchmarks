function OutMatrix = IncompleteBellPoly(Nin,Kin,DataList)
%INCOMPLETEBELLPOLY  An iterative method for computing the incomplete (also known as the second kind of) Bell polynomials.
%
%   Purpose:
%   Given a list of input values (x_{1},x_{2},...,x_{N}), the script returns a matrix of Bell polynomials B_{n,k} for 
%   n=0,...,N and k=0,...,K.
%
%   Syntax:
%   OutMatrix = IncompleteBellPoly(Nin,Kin,DataList)
%   where 
%   B_{n,k} = OutMatrix(n+1,k+1)
%   n=0,...,Nin
%   k=0,...,Kin (Kin<=Nin)
%   DataList = (x_{1},x_{2},...,x_{Nin})
%
%   Authors:
%   Patrick Kano and Moysey Brio
%   University of Arizona
%
%   Email:
%   brio@math.arizona.edu
%
%   Latest Modification Date:
%   April 3, 2007
%
%   Discussion:  
%   Given Taylor expansion coefficients of a function g(t) {g_{0},g_{1},g_{2},...} with g_{0}=0, 
%   B_{n,k}(g_{0},g_{1},...,g_{n-k+1}) is the nth Taylor coefficient of the kth derivative of g(t)/(k!) in terms of {g_{0},g_{1},g_{2},...}
%   \frac{1}{k!} g^{k}(t) = \sum_{n=0}^{\infty} B_{n,k} \frac{t^{n}}{n!}
%
%   The Bell polynomials can be computed efficiently by a recursion relation 
%   B_{n,k} = \sum_{m=1}^{n-k+1} \binom{n-1}{m-1} g_{m} B_{n-m,k-1}
%   where
%   B_{0,0} = 1; 
%   B_{n,0} = 0; for n=>1
%   B_{0,k} = 0; for k=>1
%
%   The coefficients can be stored in a lower triangular matrix.  The elements of the kth column are the Taylor coefficients
%   of the kth derivative of g(t)/k!.
%
%   In application, the polynomials arise in multiple contexts in combinatorics.  They also can be found in Riordan's
%   formulation of di Bruno's formula for computing an arbitrary order derivative of the composition of two functions
%   \frac{d^{n}}{dt^{n}} g(f(t)) = \sum_{k=0}^{n} g^{k}(f(t)) B_{n,k}(f^{1}(t),f^{2}(t),...,f^{n-k+1}(t))
%
%   Script Check:
%   If DataList=1 for all entries, B_{n,k} = S(n,k) = Stirling number of the second kind for (n,k)
%
%   Failure Return:
%   OutMatrix is undefined if the code fails.  An error statement is issued and the function exits.
%
%   References:
%   Ferrell S. Wheeler, Bell Polynomials, ACM SIGSAM Bulletin, vol. 21, issue 3, pp.44-53, 1987.
%
%   Warren P. Johnson, The curious history of Faa di Bruno's formula, The American mathematical monthly, vol. 109, no. 3, pp. 217-234, March 2002.
%
%   http://en.wikipedia.org/wiki/Bell_polynomials
% 
%   Supported by: Grant # NSF ITR-0325097

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%n - row index
%k - column index

%Check that sufficient input variables x_{1},x_{2},...,x_{N} have been given.
%Note: To compute B_{n,k} requires (x_{1},x_{2},...,x_{n-k+1}) input terms.  
%However, we want B_{n=1...N,k=1...N), which includes B_{n=N,k=1}.
%To determine B_{N,1}, we thus require (x_{1},x_{2},...,x_{N}) input terms.
 
ListLength = length(DataList);

if(ListLength<Nin) 
 ErrorStatement = sprintf('Insufficient number of user defined input values %d.  Computation requires %d.  Exiting...\n',ListLength,Nin); 
 error(ErrorStatement); 

elseif(Nin<0 || Kin<0)
 ErrorStatement = sprintf('N and K must be non-negative.  Exiting... \n');
 error(ErrorStatement); 

elseif(Nin<Kin)
 ErrorStatement = sprintf('K must be less than or equal to N.  Exiting... \n');
 error(ErrorStatement); 

elseif(Nin==0 && Kin==0)
 OutMatrix = [1];
 return;

elseif(Nin>0 && Kin==0)
 OutMatrix = zeros(Nin+1,1);
 OutMatrix(1,1) = 1;
 return;

else
 %Compute the recursion relationship
 %Note: To keep with Matlab's convention for starting indices at 1 we compute only the non-trivial elements of the matrix.
  
 %Initialize the Triangular Matrix
 Bm = zeros(Nin,Kin);

 %Starting values for the recurrence relations 
 %Bm(0,0) = 1; 
 %Bm(n,0) = 0; for n=>1
 %Bm(0,k) = 0; for k=>1
 %kidx=1
 Bm(1:Nin,1) = DataList(1:Nin);

 %Generate each required row of data
 for(nidx=2:Nin) %row, Note: Row 1 has only 1 non-zero element
     
  for(kidx=2:Kin) %column, Note: Column 1 is the given input array
      
   for(midx=1:nidx-kidx+1) %recursion
    Bm(nidx,kidx) = Bm(nidx,kidx) + nchoosek(nidx-1,midx-1)*DataList(midx)*Bm(nidx-midx,kidx-1); 
   end
  
  end
 end

 %Append [1,0,...] to generate the complete output matrix
 OutMatrix = eye(Nin+1,Kin+1);
 OutMatrix(2:Nin+1,2:Kin+1) = Bm;
end

end %End of the Function
