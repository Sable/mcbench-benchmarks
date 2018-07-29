% Main file for ternary plot
close all;clear all
warning off MATLAB:griddata:DuplicateDataPoints
% Load the data for limestone
%   File format: 1. column: solid volume fraction
%                2. column: water volume fraction
%                3. column: gas volume fraction
%                4. column: effective dielectric permittivity
%   The data matrix is called A
%   To obtain the velocities (in m/ns): v=0.29./sqrt(A(:,4));
%
load limestone
% Add the 'corner' values (looks better in the surface plot)
l=length(A);
A(l+1,:)=[1 0 0 6];
A(l+2,:)=[0 1 0 30];
A(l+3,:)=[0 0 1 1];
% ... and the GPR velocity
v=0.29./sqrt(A(:,4));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  EXAMPLE CODE FOR THE PSEUDO COLOR PLOT
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
% Plot the data
% First set the colormap (can't be done afterwards)
colormap(jet)
[hg,htick,hcb]=tersurf(A(:,1),A(:,2),A(:,3),v);
% Add the labels
hlabels=terlabel('Limestone','Water','Air');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The following modifications are not serious, just to illustrate how to
% use the handles:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--  Change the color of the grid lines
set(hg(:,3),'color','m')
set(hg(:,2),'color','c')
set(hg(:,1),'color','y')

%--  Modify the labels
set(hlabels,'fontsize',12)
set(hlabels(3),'color','m')
set(hlabels(2),'color','c')
set(hlabels(1),'color','y')
%--  Modify the tick labels
set(htick(:,1),'color','y','linewidth',3)
set(htick(:,2),'color','c','linewidth',3)
set(htick(:,3),'color','m','linewidth',3)

%--  Change the colorbar
set(hcb,'xcolor','w','ycolor','w')
%--  Modify the figure color
set(gcf,'color',[0 0 0.3])
%-- Change some defaults
set(gcf,'paperpositionmode','auto','inverthardcopy','off')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  EXAMPLE CODE FOR THE CONTOUR PLOT
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
% Plot the ternary axis system
[h,hg,htick]=terplot;
% Plot the data
% First set the colormap (can't be done afterwards)
colormap(jet)
[hcont,ccont,hcb]=tercontour(A(:,1),A(:,2),A(:,3),v,linspace(min(v),max(v),10));
clabel(ccont,hcont);
set(hcont,'linewidth',2)
% Add the labels
hlabels=terlabel('Limestone','Water','Air');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The following modifications are not serious, just to illustrate how to
% use the handles:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--  Change the color of the grid lines
set(hg(:,3),'color','m')
set(hg(:,2),'color','c')
set(hg(:,1),'color','y')

%--  Modify the labels
set(hlabels,'fontsize',12)
set(hlabels(3),'color','m')
set(hlabels(2),'color','c')
set(hlabels(1),'color','y')
%--  Modify the tick labels
set(htick(:,1),'color','y','linewidth',3)
set(htick(:,2),'color','c','linewidth',3)
set(htick(:,3),'color','m','linewidth',3)
%--  Change the color of the patch
set(h,'facecolor',[0.7 0.7 0.7],'edgecolor','w')
%--  Change the colorbar
set(hcb,'xcolor','w','ycolor','w')
%--  Modify the figure color
set(gcf,'color',[0 0 0.3])
%-- Change some defaults
set(gcf,'paperpositionmode','auto','inverthardcopy','off')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  EXAMPLE CODE FOR THE COLOR TERNARY PLOT
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
% Plot the ternary axis system
[h,hg,htick]=terplot;
% Plot the data
% First set the colormap (can't be done afterwards)
colormap(jet)
[hd,hcb]=ternaryc(A(:,1),A(:,2),A(:,3),v,'o');
% Add the labels
hlabels=terlabel('Limestone','Water','Air');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The following modifications are not serious, just to illustrate how to
% use the handles:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--  Change the color of the grid lines
set(hg(:,3),'color','m')
set(hg(:,2),'color','c')
set(hg(:,1),'color','y')
%--  Change the marker size
set(hd,'markersize',3)
%--  Modify the labels
set(hlabels,'fontsize',12)
set(hlabels(3),'color','m')
set(hlabels(2),'color','c')
set(hlabels(1),'color','y')
%--  Modify the tick labels
set(htick(:,1),'color','y','linewidth',3)
set(htick(:,2),'color','c','linewidth',3)
set(htick(:,3),'color','m','linewidth',3)
%--  Change the color of the patch
set(h,'facecolor',[0.7 0.7 0.7],'edgecolor','w')
%--  Change the colorbar
set(hcb,'xcolor','w','ycolor','w')
%--  Modify the figure color
set(gcf,'color',[0 0 0.3])
%-- Change some defaults
set(gcf,'paperpositionmode','auto','inverthardcopy','off')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lastly, an example showing the "constant data option" of
% ternaryc().
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
%-- Plot the axis system
[h,hg,htick]=terplot;
%-- Plot the data ...
hter=ternaryc(A(:,1),A(:,2),A(:,3));
%-- ... and modify the symbol:
set(hter,'marker','o','markerfacecolor','none','markersize',4)
hlabels=terlabel('C1','C2','C3');