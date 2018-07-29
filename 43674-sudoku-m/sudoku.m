%
% Sudolu solver, By Nikolaos Tsagkarakis 
%   
%     This is the implementation of the empirical
% strategy that our brains put to action when solving
% a 9by9 sudoku puzzle.
%
% Step1: figure out all possible values for each cell
% Step2: make final decissions by observing numbers on 
%        parallel horizontal and vertical lines.
% Step3: solve on possibilities in common.
% Step4: if all the above fail, make an (any) assumption and proceed.
%
% HOW to use:
%   sovled_Puzzle=sudoku(Puzzle)
% where Puzzle is a valid 9by9 array of integers with zeros in 
% possitions that the value is yet unknown.
%



function [pzl tbl]=sudoku(pzl,tbl)

%% assertions (LVL 0)
if ~assertions2(pzl),tbl=[];return,end

%% Initialize tbl
[n,m]=size(pzl);
if nargin<2
    tbl = zeros(n,m,n);
    for i=1:n
        for j=1:m
            if pzl(i,j),tbl(i,j,1)=pzl(i,j);
            else        tbl(i,j,:)=1:n;
            end
        end
    end
else
    % Need to check if valid tbl.... too lazy!
end


%% iterate on rules (LVL 1)
[pzl,tbl,~]=lvl1(pzl,tbl);
if isempty(tbl),return,end
if all(pzl(:)),return,end

%% combine rules of neighoring groups (LVL 2)
[pzl,tbl]=lvl2(pzl,tbl);
if isempty(tbl),return,end
if all(pzl(:)),return,end

%% recognize disjoint multi-assignments (LVL 3)
[pzl,tbl]=lvl3(pzl,tbl);
if isempty(tbl),return,end
if all(pzl(:)),return,end

%% Make an assuption and try to solve thereafter (LVL 4)
for i=1:n
    for j=1:m
        if ~pzl(i,j)
            p=find(tbl(i,j,:));p=p(1);
            
            tbl0=tbl;tbl0(i,j,[1:p-1 p+1:n])=0;
            pzl0=pzl;pzl0(i,j)=p;
            
            [pzl0,tbl0]=sudoku(pzl0,tbl0);
            if ~isempty(tbl0),pzl=pzl0;tbl=tbl0;i=n;j=m;end%#ok
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [pzl,tbl]=lvl3(pzl,tbl)
[n,m]=size(pzl);
sqn=sqrt(n);sqm=sqrt(m);
% The following are not equivalent:
%   BOXES: Recognize multi-assgnments is boxes.
%   HORIZONTAL LINES: Recognize multi-assgnments is horizontal lines.
%   VERTICAL LINES: Recognize multi-assgnments is verctical lines.
% I am attempting to implement and capitalize on all of them.

cov=ones(sqn*sqm+m+n,1); % groups ellegible for testing

uncvN=zeros(sqn,sqm);
for i=1:sqn
    for j=1:sqm
        uncvN(i,j)=sum(sum( pzl((i-1)*sqn+(1:sqn),(j-1)*sqm+(1:sqm))==0 ));
    end
end
vlines = sum(pzl==0,1);
hlines = sum(pzl==0,2);

cov(          1:sqn*sqm    ) = double(uncvN (:)>2);
cov(sqn*sqm+  1:sqn*sqm+m  ) = double(vlines(:)>2);
cov(sqn*sqm+m+1:sqn*sqm+m+n) = double(hlines   >2);

while sum(cov)>0
    tmp=[uncvN(:);vlines(:);hlines];tmp(~cov)=inf;
    p=find(tmp==min(tmp));p=p(randi(length(p)));
    if p<=sqn*sqm % look in a box
        tmp=tbl((mod(p-1,sqm)+1-1)*sqn+(1:sqn),(fix((p-1)/sqm))*sqm+(1:sqm),:);
        [v h]=find(pzl((mod(p-1,sqm)+1-1)*sqn+(1:sqn),(fix((p-1)/sqm))*sqm+(1:sqn))==0);
        a=zeros(n,length(v)); % isolate the posibilities of interest
        for i=1:length(v),a(:,i)=reshape(tmp(v(i),h(i),:),n,1);end
        a=reduceA(a); % nil imposible cases
        for i=1:length(v),tbl((mod(p-1,sqm)+1-1)*sqn+v(i),(fix((p-1)/sqm))*sqm+h(i),:)=a(:,i);end % write back to tbl
    elseif p<=sqn*sqm+m % look in a vertical line
        [v,~]=find(pzl(:,p-sqn*sqm)==0);
        a=zeros(n,length(v)); % isolate the posibilities of interest
        for i=1:length(v),a(:,i)=reshape(tbl(v(i),p-sqn*sqm,:),n,1);end
        a=reduceA(a); % nil imposible cases
        for i=1:length(v),tbl(v(i),p-sqn*sqm,:)=a(:,i);end % write back to tbl
    else              % look in a horizontal line
        [~,h]=find(pzl(p-sqn*sqm-m,:)==0);
        a=zeros(n,length(h)); % isolate the posibilities of interest
        for i=1:length(h),a(:,i)=reshape(tbl(p-sqn*sqm-m,h(i),:),n,1);end
        a=reduceA(a); % nil imposible cases
        for i=1:length(h),tbl(p-sqn*sqm-m,h(i),:)=a(:,i);end % write back to tbl
    end
    if isempty(tbl),return,end
    
    
    % use the new tbl to ascend
    pzl_=pzl;[pzl,tbl,~]=lvl1(pzl,tbl);
    if isempty(tbl),return,end
    [pzl,tbl]=lvl2(pzl,tbl);
    if isempty(p),tbl=[];return,end 
    if ~isequal(pzl_,pzl)
        for i=1:sqn,for j=1:sqm,uncvN(i,j) = sum(sum( pzl((i-1)*sqn+(1:sqn),(j-1)*sqm+(1:sqm))==0 ));end,end
        vlines = sum(pzl==0,1);
        hlines = sum(pzl==0,2);
        
        cov = ones(sqn*sqm+m+n,1);
        cov(1:sqn*sqm) = double(uncvN(:)>2);
        cov(sqn*sqm+1:sqn*sqm+m) = double(vlines(:)>2);
        cov(sqn*sqm+m+1:sqn*sqm+m+n) = double(hlines>2);
        
    else
        cov(p)=0;
    end
end

% wrap with a final sweep
[pzl,tbl,~]=lvl1(pzl,tbl);
if isempty(tbl),return,end
[pzl,tbl]=lvl2(pzl,tbl);
if isempty(p),tbl=[];return,end 




function [pzl,tbl]=lvl2(pzl,tbl)
[n,m]=size(pzl);
sqn=sqrt(n);sqm=sqrt(m);
% The following are equivalent:
%   BOXES: Use horizontal and vectical lines to isolate the value of a member on a box.
%   HORIZONTAL LINES: Use the two boxes to isolate the value of a member on a horizontal line.
%   VERTICAL LINES: Use the two boxes to isolate the value of a member on a vertical line.
% My implementation is based on the first.
% keyboard
cov = (pzl==0); % cells ellegible for testing
while ~isequal(cov,zeros(n,m)) % until there are not more cells to test
    tmp = sum(tbl~=0,3)+(1./cov-1);
    [i,j]=find(tmp==min(min(tmp)),1); % find one cell with the minimum remaining possible values
    box=[fix((i-1)/sqn)+1 fix((j-1)/sqm)+1];
    p=find(tbl(i,j,:));
    if isempty(p),tbl=[];return,end
    for k=p.' 
        boxcv=double(pzl((box(1)-1)*sqn+(1:sqn),(box(2)-1)*sqm+(1:sqm))==0); % cells ruled out (idially we want to rule out all the other cells in the box)
                                                % 0: ruled out
        boxcv(mod(i-1,sqn)+1,mod(j-1,sqm)+1)=2; % 1: not ruled out (yet)
                                                % 2: the cell of interest

        % Looking...
        if any(pzl((box(1)-1)*sqn+mod(i+1-1,sqn)+1,setdiff(1:m,(box(2)-1)*sqm+(1:sqm)))==k),boxcv(mod(i+1-1,sqn)+1,:)=0;end
        if any(pzl((box(1)-1)*sqn+mod(i+2-1,sqn)+1,setdiff(1:m,(box(2)-1)*sqm+(1:sqm)))==k),boxcv(mod(i+2-1,sqn)+1,:)=0;end
        if any(pzl(setdiff(1:n,(box(1)-1)*sqn+(1:sqn)),(box(2)-1)*sqm+mod(j+1-1,sqn)+1)==k),boxcv(:,mod(j+1-1,sqm)+1)=0;end
        if any(pzl(setdiff(1:n,(box(1)-1)*sqn+(1:sqn)),(box(2)-1)*sqm+mod(j+2-1,sqn)+1)==k),boxcv(:,mod(j+2-1,sqm)+1)=0;end
        
        % if OK...
        if sum(boxcv(:))==2
            pzl(i,j)=k;
            tbl(i,j,[1:k-1 k+1:n])=0;
            break
        end
    end
    
    
    if pzl(i,j)
        [pzl,tbl,~]=lvl1(pzl,tbl);
        if isempty(tbl),return,end
        cov=(pzl==0);
    else
        cov(i,j) = 0;
    end
end



function [pzl,tbl,cnt]=lvl1(pzl,tbl)
[n,m]=size(pzl);
sqn=sqrt(n);sqm=sqrt(m);
cnt=0;tbl_new=[];pzl_new=[];
while ~isequal(tbl_new,tbl) || ~isequal(pzl_new,pzl) % until convergence
    cnt=cnt+1;tbl_new=tbl;pzl_new=pzl;
    for i=1:n
        for j=1:m
            box=[fix((i-1)/sqn)+1 fix((j-1)/sqm)+1];
            p=find(tbl(i,j,:));
            if isempty(p),tbl=[];return,end
            if length(p)==1,pzl(i,j)=tbl(i,j,p);continue,end % for all non fixed cells
            for k=p.' 
                out=false;
                
                % obay box rules
                for ii=1:sqn
                    for jj=1:sqm
                        if  (i~=(box(1)-1)*sqn+ii || j~=(box(2)-1)*sqm+jj) && pzl((box(1)-1)*sqn+ii,(box(2)-1)*sqm+jj)==tbl(i,j,k)
                            tbl(i,j,k)=0;out=true;ii=sqn;jj=sqm;%#ok
                        end
                    end
                end
                if out,continue,end

                % obay row rules
                for ii=[1:i-1 i+1:n] % this is extra sqn-1 comparisons (its ok)
                    if pzl(ii,j)==tbl(i,j,k),tbl(i,j,k)=0;out=true;break,end
                end
                if out,continue,end
                
                % obay column rules
                for jj=[1:j-1 j+1:m] % this is extra sqm-1 comparisons (its ok)
                    if pzl(i,jj)==tbl(i,j,k),tbl(i,j,k)=0;break,end
                end

            end
        end
    end
    
end





function assertions(pzl)%#ok
[n,m]=size(pzl);
sqn=sqrt(n);
sqm=sqrt(m);

assert(n==9 & m==9)
assert(isequal(pzl,fix(pzl)))
assert(all( pzl(:)<10 & pzl(:)>=0 ))
for i=1:n
    for j=1:m
        if ~pzl(i,j),continue,end
        box=[fix((i-1)/sqn)+1 fix((j-1)/sqm)+1];
        
        for ii=1:sqn
            for jj=1:sqm
                assert((i==(box(1)-1)*sqn+ii && j==(box(2)-1)*sqm+jj) || pzl((box(1)-1)*sqn+ii,(box(2)-1)*sqm+jj)~=pzl(i,j))
            end
        end
        
    end
end


function tf=assertions2(pzl)
tf=false;
[n,m]=size(pzl);
sqn=sqrt(n);
sqm=sqrt(m);

if ~((n==9 && m==9) && (isequal(pzl,fix(pzl))) && (all( pzl(:)<10 & pzl(:)>=0 ))),return,end
for i=1:n
    for j=1:m
        if ~pzl(i,j),continue,end
        box=[fix((i-1)/sqn)+1 fix((j-1)/sqm)+1];
        
        for ii=1:sqn
            for jj=1:sqm
                if ~((i==(box(1)-1)*sqn+ii && j==(box(2)-1)*sqm+jj) || pzl((box(1)-1)*sqn+ii,(box(2)-1)*sqm+jj)~=pzl(i,j)),return,end
            end
        end
        
    end
end
tf=true;




function a=reduceA(a)
activeRows=(sum(a,2)~=0);b=a;
a(sum(a,2)==0,:)=[];
for i=1:min(size(a))-1
    % look for full sub-matrices (all ones) of size i-by-i
    for smv=combnk(1:size(a,1),i).'
        for smh=combnk(1:size(a,2),i).'
            if all(all(a(smv,smh)))
                % when found, look at the (coplementary rows,columns) and
                % (rows,complementary collumns). If anyis clear (all
                % zeros) set the other to zeros.
                if isequal(a(setdiff(1:size(a,1),smv),smh),zeros(size(a,1)-i,i))
                    a(smv,setdiff(1:size(a,2),smh))=0;
                end
                if isequal(a(smv,setdiff(1:size(a,2),smh)),zeros(i,size(a,2)-i))
                    a(setdiff(1:size(a,1),smv),smh)=0;
                end
            end
        end
    end
end
b(activeRows,:)=a;a=b;

