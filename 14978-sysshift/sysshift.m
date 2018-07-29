function S = sysshift(M1,M2,varargin)
% PUPROSE: Determine if there is a systematic shift between two matrices
%          M1 and M2 using correlation coefficients. Useful to check for 
%          systematic misregistration of two digital elevation models (DEM).
% -------------------------------------------------------------------
% USAGE: S = sysshift(M1,M2,varargin)
% where: M1 and M2 are the input matrices of same extent and origin
%        varargin is a vector of optional input parameters
% 
% Output:  S is a vector [x y] of systematic shift of M2 resulting in the best fit; 
%          if both elements are 0, matrices are not misregistered.
%
% OPTIONS: 
%        -'range' is the range of systematic shift to test, e.g. 'range',10
%          will test systematic shifts from -10 to 10 in x and y direction.
%          default is 10
%        -'step' is the stepsize between -range and +range, e.g. 'step',2
%          will test the range of -10 to 10 in steps of 2 (-10:2:10).
%          default is 1
%        -'all' outputs the complete correlation matrix instead of just the best fit
%          vector in the format [2*range+1 2*range+1]
%        -'plotit' plots the correlation matrix S
%
% EXAMPLE:
%        sysshift(peaks(100),peaks(100),'range',10,'step',1,'plotit')
%
% Note: - Border cells are not included in the correlation, eg at shift
%       x-10,y10, a 10 cell border is excluded from calculation.
%       - If correlation matrix is output, subtract range+1 from index to get
%       shift. Eg. index (1,1) in a 9x9 matrix (range 4) represents a
%       (-4,-4) shift.
%
% Felix Hebeler, Dept. of Geography, University Zurich, May 2007.

%% default parameters
srange=10;
sstep=1;
all=0;
plotit=0;
%% parse inputs
if isempty(varargin)~=1     % check if any arguments are given
    [m1,n1]=size(varargin);
    opts={'range';'step';'all';'plotit'};
    for i=1:n1;             % check which parameters are given
        indi=strcmpi(varargin{i},opts);
        ind=find(indi==1);
        if isempty(ind)~=1
            switch ind
                case 1
                    srange=varargin{i+1};
                case 2
                    sstep=varargin{i+1};
                    if rem(sstep,1)~=0
                        error('Step size "step" must be integer')
                    end
                case 3
                    all=1;
                case 4
                    plotit=1;
            end
        end
    end
end

%% systematic shift
S=nan(size(-srange:sstep:srange,2));
for sx=-srange:sstep:srange
    for sy=-srange:sstep:srange
        temp=circshift(M2,[sx,sy]);
        S(sx+srange+1,sy+srange+1)=corr2(M1(1+abs(sx):end-abs(sx),1+abs(sy):end-abs(sy)),temp(1+abs(sx):end-abs(sx),1+abs(sy):end-abs(sy)));
   end
end
%% plot corrmatrix 
if plotit==1
    figure, imagesc(-srange:sstep:srange,-srange:sstep:srange,S)
    title('Systematic shift - correlation matrix')
    xlabel('X-Shift')
    ylabel('Y-Shift')
    colorbar
end
%% reduce to best-fit coordinates
if all~=1
    [a,b]=find(S==max(S(:)));
    S=[a-srange-1,b-srange-1];
end