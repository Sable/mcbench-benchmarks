function [Maxima,MaxPos,Minima,MinPos]=MinimaMaxima3D(Input,Robust,LookInBoundaries,numbermax,numbermin)
% V 1.0 Dec 13, 07
% Author Sam Pichardo.
% This  function finds the local minima and maxima in a 3D Cartesian data. 
% It's assumed that the data is uniformly distributed.
% The minima and maxima are calculated using a multi-directional derivation. 
%
% Use:
%  
%  [Maxima,MaxPos,Minima,MinPos]=MinimaMaxima3D(Input,[Robust],[LookInBoundaries],[numbermax],[numbermin])
%  
% where Input is the 3D data and Robust (optional and with a default value
% of 1) indicates if the multi-directional derivation should include the
% diagonal derivations. 
%
% Input has to have a size larger or equal than [3 x 3 x 3]
%  
% If Robust=1, the total number of derivations taken into account are 26: 6
% for all surrounding elements colliding each of the faces of the unit cube; 
% 10 for all the surrounding elements in diagonal.
%  
% If Robust =0, then only the 6 elements of the colliding faces are considered
%  
% The function returns in Maxima and MaxPos, respectively, 
% the values (numbermax) and subindexes (numbermax x 3) of local maxima
% and position in Input. Maxima (and the subindexes) are sorted in
% descending order.
% Similar situation for Minima and MinimaPos witn a numbermin elements but 
% with the execption of being sorted in ascending order.
%  
% IMPORTANT: if numbermin or numbermax are not specified, ALL the minima
% or maxima will be returned. This can be a useless for highly
% oscillating data
%  
% LookInBoundaries (default value of 0) specifies if a search of the minima/maxima should be
% done in the boundaries of the matrix. This situation depends on the
% the desire application. When it is not activated, the algorithm WILL NOT
% FIND ANY MINIMA/MAXIMA on the 6 layers of the boundaries.
% When it is activated, the finding minima and maxima on the boundaries is done by
% replicating the extra layer as the layer 2 (or layer N-1, depending of the boundary)
% By example (and using a 2D matrix for simplicity reasons):
% For the matrix 
% [ 4 1 3 7
%   5 7 8 8
%   9 9 9 9
%   5 6 7 9]
%  
% the calculation of the partial derivate following the -x direction will be done by substrascting
% [ 5 7 8 8
%   4 1 3 7
%   5 7 8 8
%   9 9 9 9]
% to the input. And so on for the other dimensions.
% Like this, the value "1" at the coordinate (1,2) will be detected as a
% minima. Same situation for the value "5" at the coordinate (4,1)


if nargin <1
    test=load('temp.mat');
    pf=test.uresTot(test.EvalLims(2,1):test.EvalLims(2,2));
    pf=reshape(pf,length(test.EvalCoord{2}.Ry),length(test.EvalCoord{2}.Rx),length(test.EvalCoord{2}.Rz));
    Input = abs(pf)*1.5e6;
    clear test;
    clear pf;
    Robust =1;
end

Asize=size(Input);

if length(Asize)<3
    error('MinimaMaxima3D can only works with 3D matrices ');
end
   

if (Asize(1)<3 || Asize(2)<3 || Asize(3)<3)
    error('MinimaMaxima3D can only works with matrices with dimensions equal or larger to [3x3x3]');
end

if ~isreal(Input)
    warning('ATTENTION, complex values detected!!, using abs(Input)');
    Input=abs(Input);
end

if ~exist('Robust','var')
    Robust=1;
end

if ~exist('LookInBoundaries','var')
    LookInBoundaries=0;
end

if ~exist('numbermax','var')
    numbermax=0;
end

if ~exist('numbermin','var')
    numbermin=0;
end

[xx_base,yy_base,zz_base]=ndgrid(1:Asize(1),1:Asize(2),1:Asize(3));


IndBase=sub2ind(Asize,xx_base(:),yy_base(:),zz_base(:));

if Robust ~= 0
    Numbder_dd=26;
else
    Numbder_dd=6;
end

if LookInBoundaries==0
    lx=1:Asize(1);
    lx_p1=[2:Asize(1),Asize(1)];
    lx_m1=[1,1:Asize(1)-1];
    ly=1:Asize(2);
    ly_p1=[2:Asize(2),Asize(2)];
    ly_m1=[1,1:Asize(2)-1];
    lz=1:Asize(3);
    lz_p1=[2:Asize(3),Asize(3)];
    lz_m1=[1,1:Asize(3)-1];
else
    lx=1:Asize(1);
    lx_p1=[2:Asize(1),Asize(1)-1]; %We replicate the layer N-1 as the layer N+1
    lx_m1=[2,1:Asize(1)-1]; %We replicate the layer 2 as the layer -1
    ly=1:Asize(2);
    ly_p1=[2:Asize(2),Asize(2)-1]; %We replicate the layer N-1 as the layer N+1
    ly_m1=[2,1:Asize(2)-1]; %We replicate the layer 2 as the layer -1
    lz=1:Asize(3);
    lz_p1=[2:Asize(3),Asize(3)-1]; %We replicate the layer N-1 as the layer N+1
    lz_m1=[2,1:Asize(3)-1];%We replicate the layer 2 as the layer -1
end

for n_dd=1:Numbder_dd
    switch n_dd
        case 1
            %%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(x)-elem(x+1)
            [xx,yy,zz]=ndgrid(lx_p1,ly,lz);

        case 2
            %%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(x)-elem(x-1)
            [xx,yy,zz]=ndgrid(lx_m1,ly,lz);

        case 3
            %%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(y)-elem(y+1)
            [xx,yy,zz]=ndgrid(lx,ly_p1,lz);

        case 4
            %%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(y)-elem(y-1)
            [xx,yy,zz]=ndgrid(lx,ly_m1,lz);

        case 5
            %%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(z)-elem(z+1)
            [xx,yy,zz]=ndgrid(lx,ly,lz_p1);

         case 6
            %%%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(z)-elem(z-1)
            [xx,yy,zz]=ndgrid(lx,ly,lz_m1);
        case 7
           %%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(x)-elem(x+1,y+1)
            [xx,yy,zz]=ndgrid(lx_p1,ly_p1,lz);
        case 8
           %%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(x)-elem(x+1,y-1)
            [xx,yy,zz]=ndgrid(lx_p1,ly_m1,lz);
        case 9
           %%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(x)-elem(x-1,y-1)
            [xx,yy,zz]=ndgrid(lx_m1,ly_m1,lz);
        case 10
           %%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(x)-elem(x-1,y+1)
            [xx,yy,zz]=ndgrid(lx_m1,ly_p1,lz);
        case 11
           %%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(x)-elem(x+1,z+1)
            [xx,yy,zz]=ndgrid(lx_p1,ly,lz_p1);
        case 12
           %%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(x)-elem(x+1,z-1)
            [xx,yy,zz]=ndgrid(lx_p1,ly,lz_m1);
        case 13
           %%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(x)-elem(x-1,z-1)
            [xx,yy,zz]=ndgrid(lx_m1,ly,lz_m1);
        case 14
           %%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(x)-elem(x-1,z+1)
            [xx,yy,zz]=ndgrid(lx_m1,ly,lz_p1);
        case 15
           %%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(x)-elem(y+1,z+1)
            [xx,yy,zz]=ndgrid(lx,ly_p1,lz_p1);
        case 16
           %%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(x)-elem(y+1,z-1)
            [xx,yy,zz]=ndgrid(lx,ly_p1,lz_m1);
        case 17
           %%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(x)-elem(y-1,z-1)
            [xx,yy,zz]=ndgrid(lx,ly_m1,lz_m1);
        case 18
           %%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(x)-elem(y-1,z+1)
            [xx,yy,zz]=ndgrid(lx,ly_m1,lz_p1);
         case 19
           %%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(x)-elem(x+1,y+1,z+1)
            [xx,yy,zz]=ndgrid(lx_p1,ly_p1,lz_p1);
         case 20
           %%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(x)-elem(x+1,y+1,z-1)
            [xx,yy,zz]=ndgrid(lx_p1,ly_p1,lz_m1);
         case 21
           %%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(x)-elem(x+1,y-1,z+1)
            [xx,yy,zz]=ndgrid(lx_p1,ly_m1,lz_p1);
         case 22
           %%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(x)-elem(x+1,y-1,z-1)
            [xx,yy,zz]=ndgrid(lx_p1,ly_m1,lz_m1);
         case 23
           %%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(x)-elem(x-1,y+1,z+1)
            [xx,yy,zz]=ndgrid(lx_m1,ly_p1,lz_p1);
         case 24
           %%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(x)-elem(x-1,y+1,z-1)
            [xx,yy,zz]=ndgrid(lx_m1,ly_p1,lz_m1);
         case 25
           %%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(x)-elem(x-1,y-1,z+1)
            [xx,yy,zz]=ndgrid(lx_m1,ly_m1,lz_p1);
         case 26
           %%%%%%%%%%%%%%%%%% %% This index is used to calculated elem(x)-elem(x-1,y-1,z-1)
            [xx,yy,zz]=ndgrid(lx_m1,ly_m1,lz_m1);   

    end

    Ind_dd=sub2ind(Asize,xx(:),yy(:),zz(:)); 
    
    part_deriv = Input(IndBase)-Input(Ind_dd);
    
    if n_dd >1
        MatMinMax= (sign_Prev_deriv==sign(part_deriv)).*MatMinMax;
    else
        MatMinMax=sign(part_deriv);
    end

    sign_Prev_deriv=sign(part_deriv);
end

%Well , now the easy part, all values MatMinMax ==1 are local maximum and
%the values MatMinMax ==-1 are minimun

AllMaxima=find(MatMinMax==1);
AllMinima=find(MatMinMax==-1);

if numbermax ==0
    nmax=length(AllMaxima);
else
    nmax=numbermax;
end
nmax=min([nmax,length(AllMaxima)]);
smax=1:nmax;

if numbermin ==0
    nmin=length(AllMinima);
else
    nmin=numbermin;
end

nmin=min([nmin,length(AllMinima)]);

smin=1:nmin;

[Maxima,IndMax]=sort(Input(AllMaxima),'descend');
Maxima=Maxima(smax);
IndMax=AllMaxima(IndMax(smax));

MaxPos=zeros(nmax,3);
[MaxPos(:,1),MaxPos(:,2),MaxPos(:,3)]=ind2sub(Asize,IndMax);

[Minima,IndMin]=sort(Input(AllMinima));
Minima=Minima(smin);
IndMin=AllMinima(IndMin(smin));

MinPos=zeros(nmin,3);
[MinPos(:,1),MinPos(:,2),MinPos(:,3)]=ind2sub(Asize,IndMin);

