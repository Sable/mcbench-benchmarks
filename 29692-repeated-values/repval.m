function [RV,NR,POS,IR]=repval(varargin)
%REPVAL Repeated Values
%   repval(X) finds all repeated values for input X, and their attributes. 
%   The input may be vector, matrix, char string, or cell of strings
%
%   Y=repval(X) returns the repeated values of X
%
%   [RV, NR, POS, IR]=repval(X) returns the following outputs
%      RV  : Repeated Values (sorted)
%      NR  : Number of times each RV was repeated
%      POS : Position vector of X of RV entries
%      IR  : Index of repetition
%
%    Example:
%    X=[1 5 5 9 5 5 1];
%    [RV,NR,POS,IR]=repval(X)
%    Output:
%    RV  = [1 5];         %Numbers '1' and '5' are repeated values
%    NR  = [2 4];         %Respectively repeated 2 and 4 times
%    POS = [1 7 2 3 5 6]; %Position index of X for repeated values
%    IR  = [1 1 2 2 2 2]; %Corresponding to which index of RV
%
%    Vectors
%    [RV,NR,POS,IR]=repval([1 2 2 3 2 2 1])
%
%    Matrix (repeated rows)
%    [RV,NR,POS,IR]=repval([1 2; 3 4; 1 2; 1 3; 3 4])
%
%    Char String
%    [RV,NR,POS,IR]=repval('abracadabra')
%
%    Cell of Strings
%    [RV,NR,POS,IR]=repval({'bat','cat','car','bar','bat','car'})
%

%   Mike Sheppard
%   Last Modified: 13-Dec-2010



%Initialize in case empty set
RV=[]; NR=[]; IR=[]; POS=[];

v=varargin{:};
if ~isempty(v)
    if all(size(v)>1)
        [B,ignore,J]=unique(v,'rows'); %matrix, sort by rows
    else
        [B,ignore,J]=unique(v);
    end
    [Y,I]=sort(J);
    I2=find(diff(Y)==0);
    B2=unique([I2(:)',I2(:)'+1]);
    [B3,ignore,IR]=unique(Y(B2));
    if ~isempty(IR)
        NR=hist(IR,IR(end));
        POS=I(B2);
        if all(size(v)>1)
            RV=B(B3,:); %matrix, sort by rows
        else
            RV=B(B3);
        end
    end
end

%Turn output into column vector
NR=NR(:); IR=IR(:); POS=POS(:);
if ~all(size(v)>1), RV=RV(:); end %Non-matrices

end


%Credit:
%Basic concept of code by J.S. on 7 Dec, 2001 for vectors
%http://www.mathworks.com/matlabcentral/newsreader/view_thread/30051
%Expanded code to include matrices, chars, and cell of strings
