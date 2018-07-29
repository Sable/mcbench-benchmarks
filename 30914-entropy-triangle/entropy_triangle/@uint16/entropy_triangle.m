function [h,H_Pxy, H_Px,H_Py, MI_Pxy]=entropy_triangle(rawcounts,varargin)
%
%[h,H_Pxy, H_Px,H_Py, MI_Pxy]=entropy_triangle(Cxy,options)
%
% A function to draw entropies H_Uxy, H_Pxy, H_Px, H_Py, MI_Pxy vs each
% other for a count or contingency matrix Cxy of integer values following the balance equation:
%
% DeltaH_Pxy + VI_XY + 2*MI_Pxy = H_Uxy
%
% If the entropies are matrices and no h is supplied, it generates a new figure
% plotting in 3d H_Px vs H_Py vs MI_Pxy normalized wrt to H_Pxy.
% If an h is supplied, then the plot is added to the existing graph.
%
% It also returns the constrained variables in the 2-simplex:
% - DeltaH_Pxy, the decrement in entropy from $U_X \cdot U_Y$ to $P_X \cdot P_Y$
% - VI, the variation of information.
% - twoAMI, double the average mutual information.
% - H_Uxy, the maximum joint entropy.
%
%Options controlling behaviour:
% - two types of plots: entropy triangle ('triangle', default) or 2-simplex ('simplex' or '3D') 
% - two types of exploration:  normalized or not. Default is normalized. Control by putting 
%'normalized|unnormalized' into options.
% - Two types of plot building: incremental on true means, "add to preexisting
%plot". Set by putting 'incremental' followed by a figure handle into options
% If the option 'split' is passed, the Marker type is set to 'x' for input
% variable entropies and 'o' for output variable entropies, so only line
% and color specifications will be used from those supplied.
%
%Examples:
%
%Cxy=uint16([
%     15     0     5
%      0    15     5
%      0     0    20]);
%h=entropy_triangle(Cxy,'color','r','linestyle','d') 
%or simply 
%h=entropy_triangle(Cxy,'rd') 
%places a red diamond in the entropy triangle or de Finetti diagram of Pxy in a new figure and returns
%a handle h for the figure.
%
%Cxy=uint16([
%     16     2     2
%      2    16     2
%      1     1    18]);
%entropy_triangle(Cxy,'incremental',h,'color','b','linestyle','o') 
%adds a blue circle in the previous figure.
%
%h=entropy_triangle(Cxy,'split','rp') 
%produces the extended de Finetti diagram.
%h=entropy_triangle(Cxy,'3D','rp') 
%produces a three dimensional 2-simplex diagram.
%
%
%A detailed description of the algorithmia can be found in:
%
% Valverde-Albacete, F. and Peláez-Moreno, C. Two information-theoretic tools to assess the 
%performance of multi-class classifiers. Pattern Recognition Letters (2010) vol. 31 (12) 
%pp. 1665-1671


[n m] = size(rawcounts);

%Compute joint distributions

[kk,Pxy] = pmi(rawcounts);

%Compute entropies
[H_Pxy,H_Px,H_Py,MI_Pxy] = entropies(Pxy);


%Now build the rest of the triangle variables
HmaxX = log2(n);
HmaxY = log2(m);
Hmax = HmaxX + HmaxY;%same size for all
DeltaH_Px = HmaxX - H_Px;
DeltaH_Py = HmaxY - H_Py;
DeltaH_Pxy = DeltaH_Px + DeltaH_Py;
VI_X= H_Px - MI_Pxy;
VI_Y = H_Py - MI_Pxy;
VI_XY = VI_X + VI_Y;

%Check integrity of values
DeltaH_Pxy + VI_XY + 2*MI_Pxy;

if nargin>1
    if strcmp(varargin{1},'incremental')
        h=varargin{2};
        h=explore_entropies(HmaxX,HmaxY,H_Pxy,H_Px,H_Py,MI_Pxy,h,varargin{3:end});
        hold on
    else
        h=explore_entropies(HmaxX,HmaxY,H_Pxy,H_Px,H_Py,MI_Pxy,varargin{:});
        hold on
    end
else
    h=explore_entropies(HmaxX,HmaxY,H_Pxy,H_Px,H_Py,MI_Pxy,varargin{:});
    hold on
end




