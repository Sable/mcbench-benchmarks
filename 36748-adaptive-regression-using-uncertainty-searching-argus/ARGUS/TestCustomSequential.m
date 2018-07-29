%Test script for the ARGUS method

clear; %close all;
%path added for regression methods
%Set seed for repeatability 
%s = RandStream('mt19937ar','Seed',1);
%RandStream.setGlobalStream(s);
rand('seed',1)

%Set initial conditions
intialSize =5;
dim = 2;
%Set stop conditions
maxPoints = 1000;
pntsAdd = 10;

%Set function handle for loop (not needed for ARGUS)
stdr = .5;
%fun = @(x)sin(6*x)+stdr*randn(length(x),1);
fun = @(x)sin(6*sum(x,2))+stdr*randn(length(x(:,1)),1);
range = 0:.01:1;
[x1 x2] = meshgrid(range);
y = sin(6*(x1(:)+x2(:)));
subplot(2,2,2)
hold off;
surf(x1,x2,reshape(y,size(x1)),'EdgeColor',[.5 .5 .5],'FaceAlpha',0);
hold on;
subplot(2,2,4)
hold off;
surf(x1,x2,stdr*ones(size(x2)),'EdgeColor',[.5 .5 .5],'FaceAlpha',0);
hold on;
%plot(0:.01:1,sin(6*(0:.01:1)'))


%Initial conditions
x = lhsdesign(intialSize,dim);
y= feval(fun,x);
XYdata = add2XYdata([],x,y);
subplot(2,2,4)
scatter3(x(:,1),x(:,2),zeros(size(x(:,1))),'rs')
subplot(2,2,2)
scatter3(x(:,1),x(:,2),y,'rs')
subplot(2,2,1)
hold off
scatter(x(:,1),x(:,2),'rs')
hold on
%plot(x,y,'rs')

%Work horse
i=intialSize;
[newpoints hist] = ARGUS(XYdata,pntsAdd);
ynew = feval(fun,newpoints);
XYdata = add2XYdata(XYdata,newpoints,ynew);
%plot(newpoints,ynew,'ks')
%text(newpoints,ynew,['\leftarrow' sprintf('%i',i)]);
brk =floor(pntsAdd*hist.ratio(end));
subplot(2,2,1)
scatter(newpoints(1:brk,1),newpoints(1:brk,2),'ko')
scatter(newpoints(brk+1:end,1),newpoints(brk+1:end,2),'bx')
%legend('Initial Deisgn','Replication','Exploration','Location','Best')
%legend('boxoff')
h_oldstErr=surf(x1,x2,reshape(feval(hist.stErrfun,[x1(:),x2(:)]),size(x1)),'Edgecolor','none','FaceAlpha',.2);
colorbar
xlabel('X1')
ylabel('X2')
title('Standard Error')
subplot(2,2,3)
plot(1:hist.itt,floor(pntsAdd*hist.ratio)/pntsAdd,'bs-')
xlabel('Iteration')
ylabel('Replications/Exploration')
subplot(2,2,2)
title('Mean')
scatter3(newpoints(1:brk,1),newpoints(1:brk,2),ynew(1:brk),'ko')
scatter3(newpoints(brk+1:end,1),newpoints(brk+1:end,2),ynew(brk+1:end),'bx')
h_oldmu = surf(x1,x2,reshape(feval(hist.mufun,[x1(:),x2(:)]),size(x1)),'Edgecolor','none','FaceAlpha',.5);
%text(newpoints(:,1),newpoints(:,2),ynew,['\leftarrow' sprintf('%i',i)]);
subplot(2,2,4)
title('Standard Deviation')
scatter3(newpoints(1:brk,1),newpoints(1:brk,2),zeros(size(newpoints(1:brk,1))),'ko')
scatter3(newpoints(brk+1:end,1),newpoints(brk+1:end,2),zeros(size(newpoints(brk+1:end,1))),'bx')
h_oldsig = surf(x1,x2,reshape(feval(hist.stdfun,[x1(:),x2(:)]),size(x1)),'Edgecolor','none','FaceAlpha',.5);
%text(newpoints(:,1),newpoints(:,2),zeros(size(newpoints(:,1))),['\leftarrow' sprintf('%i',i)]);
i=intialSize+pntsAdd;
while maxPoints>i
    [newpoints hist] = ARGUS(XYdata,pntsAdd,hist);
    ynew = feval(fun,newpoints);
    XYdata = add2XYdata(XYdata,newpoints,ynew);
    %plot(newpoints,ynew,'ks')
    brk =floor(pntsAdd*hist.ratio(end));
    subplot(2,2,1)
    scatter(newpoints(1:brk,1),newpoints(1:brk,2),'ko')
    scatter(newpoints(brk+1:end,1),newpoints(brk+1:end,2),'bx')
    h_newstErr=surf(x1,x2,reshape(feval(hist.stErrfun,[x1(:),x2(:)]),size(x1)),'Edgecolor','none','FaceAlpha',.2);
    %colorbar
    delete(h_oldstErr);
    h_oldstErr=h_newstErr;
    subplot(2,2,3)
    plot(1:hist.itt,floor(pntsAdd*hist.ratio)/pntsAdd,'bs-')
    xlabel('Iteration')
    ylabel('Replications/Exploration')
    subplot(2,2,2)
    scatter3(newpoints(1:brk,1),newpoints(1:brk,2),ynew(1:brk),'ko')
    scatter3(newpoints(brk+1:end,1),newpoints(brk+1:end,2),ynew(brk+1:end),'bx')
    h_newmu = surf(x1,x2,reshape(feval(hist.mufun,[x1(:),x2(:)]),size(x1)),'Edgecolor','none','FaceAlpha',.5);
    %text(newpoints(:,1),newpoints(:,2),ynew,['\leftarrow' sprintf('%i',i)]);
    delete(h_oldmu);
    h_oldmu=h_newmu;
    subplot(2,2,4)
    scatter3(newpoints(1:brk,1),newpoints(1:brk,2),zeros(size(newpoints(1:brk,1))),'ko')
    scatter3(newpoints(brk+1:end,1),newpoints(brk+1:end,2),zeros(size(newpoints(brk+1:end,1))),'bx')
    h_newsig = surf(x1,x2,reshape(feval(hist.stdfun,[x1(:),x2(:)]),size(x1)),'Edgecolor','none','FaceAlpha',.5);
    %text(newpoints(:,1),newpoints(:,2),zeros(size(newpoints(:,1))),['\leftarrow' sprintf('%i',i)]);
    delete(h_oldsig);
    h_oldsig=h_newsig;
    %text(newpoints,ynew,['\leftarrow' sprintf('%i',i)]);
    i=i+pntsAdd;
    if mod(i-intialSize,3*pntsAdd)==0
        fprintf('Done with %i\n',i);end
end