function [TR, TT] = icp(model,data,max_iter,min_iter,fitting,thres,init_flag,tes_flag,refpnt)
% ICP Iterative Closest Point Algorithm. Takes use of
% Delaunay tesselation of points in model.
%
%   Ordinary usage:
%
%   [R, T] = icp(model,data)
%
%   ICP fit points in data to the points in model.
%   Fit with respect to minimize the sum of square
%   errors with the closest model points and data points.
%
%   INPUT:
%
%   model - matrix with model points, [Pm_1 Pm_2 ... Pm_nmod]
%   data - matrix with data points,   [Pd_1 Pd_2 ... Pd_ndat]
%
%   OUTPUT:
%
%   R - rotation matrix and
%   T - translation vector accordingly so
%
%           newdata = R*data + T .
%
%   newdata are transformed data points to fit model
%
%
%   Special usage:
%
%   icp(model)  or icp(model,tes_flag)
%
%   ICP creates a Delaunay tessellation of points in
%   model and save it as global variable Tes. ICP also
%   saves two global variables ir and jc for tes_flag=1 (default) or
%   Tesind and Tesver for tes_flag=2, which
%   makes it easy to find in the tesselation. To use the global variables
%   in icp, put tes_flag to 0.
%
%
%   Other usage:
%
%   [R, T] = icp(model,data,max_iter,min_iter,...
%                         fitting,thres,init_flag,tes_flag)
%
%   INPUT:
%
% 	max_iter - maximum number of iterations. Default=104
%
% 	min_iter - minimum number of iterations. Default=4
%
%   fitting  -  =2 Fit with respect to minimize the sum of square errors. (default)
%                  alt. =[2,w], where w is a weight vector corresponding to data.
%                  w is a vector of same length as data.
%                  Fit with respect to minimize the weighted sum of square errors.
%               =3 Fit with respect to minimize the sum to the amount 0.95
%                  of the closest square errors.
%                  alt. =[3,lambda], 0.0<lambda<=1.0, (lambda=0.95 default)
%                  In each iteration only the amount lambda of the closest
%                  points will affect the translation and rotation.
%                  If 1<lambda<=size(data,2), lambda integer, only the number lambda
%                  of the closest points will affect the translation and
%                  rotation in each iteration.
%
% 	thres - error differens threshold for stop iterations. Default 1e-5
%
% 	init_flag  -  =0 no initial starting transformation
%                 =1 transform data so the mean value of
%                     data is equal to mean value of model.
%                     No rotation. (init_flag=1 default)
%
% 	tes_flag  -  =0 No new tesselation has to be done. There
%                   alredy exists one for the current model points.
%                =1 A new tesselation of the model points will
%                   be done. (default)
%                =2 A new tesselation of the model points will
%                   be done. Another search strategy than tes_flag=1
%                =3 The closest point will be find by testing
%                   all combinations. No Delaunay tesselation will be done.
%
%   refpnt - (optional) (An empty vector is default.) refpnt is a point corresponding to the
%                 set of model points wich correspondig data point has to be find.
%                 How the points are weighted depends on the output from the
%                 function weightfcn found in the end of this m-file. The input in weightfcn is the
%                 distance between the closest model point and refpnt.
%
%   To clear old global tesselation variables run: "clear global Tes ir jc" (tes_flag=1)
%   or run: "clear global Tes Tesind Tesver" (tes_flag=2) in Command Window.
%
%   m-file can be downloaded for free at
%   http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=12627&objectType=FILE
%
%   icp version 1.4
%
%   written by Per Bergström 2007-03-07

if nargin<1

    error('To few input arguments!');

elseif or(nargin==1,nargin==2)

    bol=1;
    refpnt=[];
    if nargin==2
        if isempty(data)
            tes_flag=1;
        elseif isscalar(data)
            tes_flag=data;
            if not(tes_flag==1 | tes_flag==2)
                tes_flag=1;
            end
        else
            bol=0;
        end
    else
        tes_flag=1;
    end

    if bol

        global MODEL

        if isempty(model)
            error('Model can not be an empty matrix.');
        end

        if (size(model,2)<size(model,1))
            MODEL=model';
            TR=eye(size(model,2));
            TT=zeros(size(model,2),1);
        else
            MODEL=model;
            TR=eye(size(model,1));
            TT=zeros(size(model,1),1);
        end

        if (size(MODEL,2)==size(MODEL,1))
            error('This icp method demands the number of MODEL points to be greater then the dimension.');
        end

        icp_struct(tes_flag);

        return
    end
end

global MODEL DATA TR TT

if isempty(model)
    error('Model can not be an empty matrix.');
end

if (size(model,2)<size(model,1))
    MODEL=model';
else
    MODEL=model;
end

if (size(data,2)<size(data,1))
    data=data';
    DATA=data;
else
    DATA=data;
end

if size(DATA,1)~=size(MODEL,1)
    error('Different dimensions of DATA and MODEL!');
end

if nargin<9
    refpnt=[];
    if nargin<8
        tes_flag=1;
        if nargin<7
            init_flag=1;
            if nargin<6
                thres=1e-5;                     % threshold to icp iterations
                if nargin<5
                    fitting=2;                  % fitting method
                    if nargin<4
                        min_iter=4;             % min number of icp iterations
                        if nargin<3
                            max_iter=104;       % max number of icp iterations
                        end
                    end
                end
            end
        end
    end
elseif nargin>9
    warning('Too many input arguments!');
end

if isempty(tes_flag)
    tes_flag=1;
elseif not(tes_flag==0 | tes_flag==1 | tes_flag==2 | tes_flag==3)
    init_flag=1;
    warning('init_flag has been changed to 1');
end

if and((size(MODEL,2)==size(MODEL,1)),tes_flag~=0)
    error('This icp method demands the number of model points to be greater then the dimension.');
end

if isempty(min_iter)
    min_iter=4;
end

if isempty(max_iter)
    max_iter=100+min_iter;
end

if max_iter<min_iter;
    max_iter=min_iter;
    warning('max_iter<min_iter , max_iter has been changed to be equal min_iter');
end

if min_iter<0;
    min_iter=0;
    warning('min_iter<0 , min_iter has been changed to be equal 0');
end

if isempty(thres)
    thres=1e-5;
elseif thres<0
    thres=abs(thres);
    warning('thres negative , thres have been changed to -thres');
end

if isempty(fitting)

    fitting=2;

elseif fitting(1)==2

    [fi1,fi2]=size(fitting);
    lef=max([fi1,fi2]);
    if lef>1
        if fi1<fi2
            fitting=fitting';
        end

        if lef<(size(data,2)+1)
            warning('Illegeal size of fitting! Unweighted minimization will be used.');
            fitting=2;
        elseif min(fitting(2:(size(data,2)+1)))<0
            warning('Illegeal value of the weights! Unweighted minimization will be used.');
            fitting=2;
        elseif max(fitting(2:(size(data,2)+1)))==0
            warning('Illegeal values of the weights! Unweighted minimization will be used.');
            fitting=2;
        else
            su=sum(fitting(2:(size(data,2)+1)));
            fitting(2:(size(data,2)+1))=fitting(2:(size(data,2)+1))/su;
            thres=thres/su;
        end
    end

elseif fitting(1)==3
    if length(fitting)<2
        fitting=[fitting,round(0.95*size(data,2))];
    elseif fitting(2)>1

        if fitting(2)>floor(fitting(2))
            fitting(2)=floor(fitting(2));
            warning(['lambda has been changed to ',num2str(fitting(2)),'!']);
        end
        if fitting(2)>size(data,2)
            fitting(2)=size(data,2);
            warning(['lambda has been changed to ',num2str(fitting(2)),'!']);
        end

    elseif fitting(2)>0

        if fitting(2)<=0.5
            warning('lambda small. Troubles might occur!');
        end

        fitting(2)=round(fitting(2)*size(data,2));

    elseif fitting(2)<=0
        fitting(2)=round(0.95*size(data,2));
        warning(['lambda has been changed to ',num2str(fitting(2)),'!']);
    end

else
    fitting=2;
    warning('fitting has been changed to 2');
end

if isempty(init_flag)
    init_flag=1;
elseif not(init_flag==0 | init_flag==1)
    init_flag=1;
    warning('init_flag has been changed to 1');
end

if (size(refpnt,2)>size(refpnt,1))
    refpnt=refpnt';
end
if (size(refpnt,1)~=size(DATA,1))
    if not(isempty(refpnt))
        refpnt=[];
        warning('Dimension of refpnt dismatch. refpnt is put to [] (empty matrix).');
    end
end
if (size(refpnt,2)>1)
    refpnt=refpnt(:,1);
    warning('Only the first point in refpnt is used.');
end

% Start the ICP algorithm

N = size(DATA,2);

icp_init(init_flag,fitting);                    % initiate a starting rotation matrix and starting translation vector

tes_flag=icp_struct(tes_flag);                  % construct a Delaunay tesselation and two vectors make it easy to find in Tes

ERROR=icp_closest_start(tes_flag,fitting);      % initiate a vector with indices of closest MODEL points

icp_transformation(fitting,[]);                 % find transformation

DATA = TR*data;                                 % apply transformation
DATA=DATA+repmat(TT,1,N);                       %

for iter=1:max_iter
    olderror = ERROR;
    ERROR=icp_closest(tes_flag,fitting);        % find indices of closest MODEL points and total error

    if iter<min_iter
        icp_transformation(fitting,[]);         % find transformation
    else
        icp_transformation(fitting,refpnt);     % find transformation
    end

    DATA = TR*data;                             % apply transformation
    DATA=DATA+repmat(TT,1,N);                   %

    if iter>=min_iter
        if abs(olderror-ERROR) < thres
            break
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function icp_init(init_flag,fitting)
%function icp_init(init_flag)
%ICP_INIT Initial alignment for ICP.

global MODEL DATA TR TT

if init_flag==0

    TR=eye(size(MODEL,1));
    TT=zeros(size(MODEL,1),1);

elseif init_flag==1

    N = size(DATA,2);

    if fitting(1)==2

        if length(fitting)==1
            mem=mean(MODEL,2); med=mean(DATA,2);
        else
            mem=MODEL*fitting(2:(N+1)); med=DATA*fitting(2:(N+1));
        end

    else
        mem=mean(MODEL,2); med=mean(DATA,2);
    end

    TR=eye(size(MODEL,1));
    TT=mem-med;
    DATA=DATA+repmat(TT,1,N);                         % apply transformation

else
    error('Wrong init_flag');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function tes_flag=icp_struct(tes_flag)

if tes_flag==0
    global ir
    if isempty(ir)
        global Tesind
        if isempty(Tesind)
            error('No tesselation system exists');
        else
            tes_flag=2;
        end
    else
        tes_flag=1;
    end
elseif tes_flag==3
    return
else
    global MODEL Tes

    [m,n]=size(MODEL);

    if m==1
        [so1,ind1]=sort(MODEL);
        Tes=zeros(n,2);
        Tes(1:(n-1),1)=ind1(2:n)';
        Tes(2:n,2)=ind1(1:(n-1))';
        Tes(1,2)=Tes(1,1);
        Tes(n,1)=Tes(n,2);
        Tes(ind1,:)=Tes(:,:);
    else
        Tes=delaunayn(MODEL');

        if isempty(Tes)

            mem=mean(MODEL,2);
            MODELm=MODEL-repmat(mem,1,n);
            [U,S,V]=svd(MODELm*MODELm');
            onbasT=U(:,diag(S)>1e-8)'
            MODELred=onbasT*MODEL;

            if size(MODELred,1)==1
                [so1,ind1]=sort(MODELred);
                Tes=zeros(n,2);
                Tes(1:(n-1),1)=ind1(2:n)';
                Tes(2:n,2)=ind1(1:(n-1))';
                Tes(1,2)=Tes(1,1);
                Tes(n,1)=Tes(n,2);
                Tes(ind1,:)=Tes(:,:);
            else
                Tes=delaunayn(MODELred');
            end
        end
    end
    Tes=sortrows(sort(Tes,2));
    [mT,nT]=size(Tes);

    if tes_flag==1
        global ir jc

        num=zeros(1,n);

        for i=1:mT
            for j=1:nT
                num(Tes(i,j))=num(Tes(i,j))+1;
            end
        end

        num=cumsum(num);

        jc=ones(1,n+1);
        jc(2:end)=num+jc(2:end);

        ir=zeros(1,num(end));
        ind=jc(1:(end-1));

        %% calculate ir;
        for i=1:mT
            for j=1:nT
                ir(ind(Tes(i,j)))=i;
                ind(Tes(i,j))=ind(Tes(i,j))+1;
            end
        end
    else    % tes_flag==2
        global Tesind Tesver

        Tesind=zeros(mT,nT);
        Tesver=zeros(mT,nT);

        couvec=zeros(mT,1);

        for i=1:(mT-1)
            for j=(i+1):mT

                if couvec(i)==nT
                    break;
                elseif Tes(i,1)==Tes(j,1)

                    if nT==2

                        Tesind(i,2)=j;
                        Tesind(j,2)=i;

                        Tesver(i,2)=2;
                        Tesver(j,2)=2;

                        couvec(i)=couvec(i)+1;
                        couvec(j)=couvec(j)+1;

                    else

                        for k=2:nT
                            for kk=k:nT
                                if all(Tes(i,[2:(k-1),(k+1):nT])==Tes(j,[2:(kk-1),(kk+1):nT]))
                                    Tesind(i,k)=j;
                                    Tesind(j,kk)=i;

                                    Tesver(i,k)=kk;
                                    Tesver(j,kk)=k;

                                    couvec(i)=couvec(i)+1;
                                    couvec(j)=couvec(j)+1;
                                end
                            end

                            if or(couvec(i)==nT,couvec(j)==nT)
                                break
                            end
                        end

                    end

                elseif Tes(i,1)==Tes(j,2)

                    if nT==2

                        Tesind(i,2)=j;
                        Tesind(j,1)=i;

                        Tesver(i,2)=1;
                        Tesver(j,1)=2;

                        couvec(i)=couvec(i)+1;
                        couvec(j)=couvec(j)+1;

                    else
                        for k=2:nT

                            if all(Tes(i,[2:(k-1),(k+1):nT])==Tes(j,3:nT))
                                Tesind(i,k)=j;
                                Tesind(j,1)=i;

                                Tesver(i,k)=1;
                                Tesver(j,1)=k;

                                couvec(i)=couvec(i)+1;
                                couvec(j)=couvec(j)+1;
                            end

                            if or(couvec(i)==nT,couvec(j)==nT)
                                break
                            end
                        end
                    end

                elseif Tes(i,2)==Tes(j,1)

                    if nT==2

                        Tesind(i,1)=j;
                        Tesind(j,2)=i;
                        Tesver(i,1)=2;
                        Tesver(j,2)=1;

                        couvec(i)=couvec(i)+1;
                        couvec(j)=couvec(j)+1;

                    else

                        for k=2:nT

                            if all(Tes(i,3:nT)==Tes(j,[2:(k-1),(k+1):nT]))
                                Tesind(i,1)=j;
                                Tesind(j,k)=i;
                                Tesver(i,1)=k;
                                Tesver(j,k)=1;

                                couvec(i)=couvec(i)+1;
                                couvec(j)=couvec(j)+1;
                            end

                            if or(couvec(i)==nT,couvec(j)==nT)
                                break
                            end

                        end

                    end

                elseif Tes(i,2)==Tes(j,2)

                    if nT==2

                        Tesind(i,1)=j;
                        Tesind(j,1)=i;

                        Tesver(i,1)=1;
                        Tesver(j,1)=1;

                        couvec(i)=couvec(i)+1;
                        couvec(j)=couvec(j)+1;

                        if Tes(j,1)>Tes(i,2)
                            break;
                        end

                    elseif all(Tes(i,3:end)==Tes(j,3:end))

                        Tesind(i,1)=j;
                        Tesind(j,1)=i;

                        Tesver(i,1)=1;
                        Tesver(j,1)=1;

                        couvec(i)=couvec(i)+1;
                        couvec(j)=couvec(j)+1;

                    end

                elseif Tes(j,1)>Tes(i,2)
                    break;
                end
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ERROR=icp_closest_start(tes_flag,fitting)
% Usage:
%           ERROR = icp_closest_start(tes_flag)
%
% ERROR=sum of all errors between points in MODEL and points in DATA.
%
% ICP_CLOSEST_START finds indexes of closest MODEL points for each point in DATA.
% The _start version allocates memory for iclosest and finds the closest MODEL points
% to the DATA points

if tes_flag==3

    global MODEL DATA iclosest
    md=size(DATA,2);
    mm=size(MODEL,2);

    iclosest=zeros(1,md);

    ERROR=0;

    for id=1:md
        dist=Inf;
        for im=1:mm
            dista=norm(MODEL(:,im)-DATA(:,id));
            if dista<dist
                iclosest(id)=im;
                dist=dista;
            end
        end
        ERROR=ERROR+err(dist,fitting,id);
    end

elseif tes_flag==1

    global MODEL DATA Tes ir jc iclosest

    md=size(DATA,2);
    iclosest=zeros(1,md);
    mid=round(md/2);

    iclosest(mid)=round(size(MODEL,2)/2);

    bol=logical(1);
    while bol
        bol=not(bol);
        distc=norm(DATA(:,mid)-MODEL(:,iclosest(mid)));
        distcc=2*distc;
        for in=ir(jc(iclosest(mid)):(jc(iclosest(mid)+1)-1))
            for ind=Tes(in,:)
                distcc=norm(DATA(:,mid)-MODEL(:,ind));
                if distcc<distc
                    distc=distcc;
                    bol=not(bol);
                    iclosest(mid)=ind;
                    break;
                end
            end
            if bol
                break;
            end
        end
    end

    ERROR=err(distc,fitting,mid);

    for id = (mid+1):md
        iclosest(id)=iclosest(id-1);
        bol=not(bol);
        while bol
            bol=not(bol);
            distc=norm(DATA(:,id)-MODEL(:,iclosest(id)));
            distcc=2*distc;
            for in=ir(jc(iclosest(id)):(jc(iclosest(id)+1)-1))
                for ind=Tes(in,:)
                    distcc=norm(DATA(:,id)-MODEL(:,ind));
                    if distcc<distc
                        distc=distcc;
                        bol=not(bol);
                        iclosest(id)=ind;
                        break;
                    end
                end
                if bol
                    break;
                end
            end
        end
        ERROR=ERROR+err(distc,fitting,id);
    end

    for id=(mid-1):-1:1
        iclosest(id)=iclosest(id+1);
        bol=not(bol);
        while bol
            bol=not(bol);
            distc=norm(DATA(:,id)-MODEL(:,iclosest(id)));
            distcc=2*distc;
            for in=ir(jc(iclosest(id)):(jc(iclosest(id)+1)-1))
                for ind=Tes(in,:)
                    distcc=norm(DATA(:,id)-MODEL(:,ind));
                    if distcc<distc
                        distc=distcc;
                        bol=not(bol);
                        iclosest(id)=ind;
                        break;
                    end
                end
                if bol
                    break;
                end
            end
        end
        ERROR=ERROR+err(distc,fitting,id);
    end
else  % tes_flag==2

    global MODEL DATA Tes Tesind Tesver icTesind iclosest

    md=size(DATA,2);
    iclosest=zeros(1,md);
    icTesind=zeros(1,md);

    [mTes,nTes]=size(Tes);

    mid=round(md*0.5);

    icTesind(mid)=round(mTes*0.5);
    iclosest(mid)=max(Tesind(icTesind(mid),:));

    visited=logical(zeros(1,mTes));

    visited(icTesind(mid))=1;

    di2vec=sqrt(sum((repmat(DATA(:,mid),1,nTes)-MODEL(:,Tes(icTesind(mid),:))).^2,1));
    bol=logical(1);

    while bol

        [so,in]=sort(di2vec);

        for ii=nTes:-1:2
            Ti=Tesind(icTesind(mid),in(ii));
            if Ti>0
                if not(visited(Ti))
                    break;
                end
            end
        end

        if Ti==0
            bol=not(bol);
        elseif visited(Ti)
            bol=not(bol);
        else
            Tv=Tesver(icTesind(mid),in(ii));
            visited(Ti)=1;
            icTesind(mid)=Ti;
            di2vec([1:(Tv-1),(Tv+1):nTes])=di2vec([1:(in(ii)-1),(in(ii)+1):nTes]);
            di2vec(Tv)=norm(DATA(:,mid)-MODEL(:,Tes(Ti,Tv)));
        end
    end
    iclosest(mid)=Tes(icTesind(mid),in(1));
    ERROR=err(so(1),fitting,mid);

    for id = (mid+1):md

        iclosest(id)=iclosest(id-1);
        icTesind(id)=icTesind(id-1);

        visited(:)=0;
        visited(icTesind(id))=1;

        di2vec=sqrt(sum((repmat(DATA(:,id),1,nTes)-MODEL(:,Tes(icTesind(id),:))).^2,1));
        bol=not(bol);

        while bol

            [so,in]=sort(di2vec);

            for ii=nTes:-1:2
                Ti=Tesind(icTesind(id),in(ii));
                if Ti>0
                    if not(visited(Ti))
                        break;
                    end
                end
            end

            if Ti==0
                bol=not(bol);
            elseif visited(Ti)
                bol=not(bol);
            else
                Tv=Tesver(icTesind(id),in(ii));
                visited(Ti)=1;
                icTesind(id)=Ti;
                di2vec([1:(Tv-1),(Tv+1):nTes])=di2vec([1:(in(ii)-1),(in(ii)+1):nTes]);
                di2vec(Tv)=norm(DATA(:,id)-MODEL(:,Tes(Ti,Tv)));
            end
        end
        iclosest(id)=Tes(icTesind(id),in(1));
        ERROR=ERROR+err(so(1),fitting,id);
    end

    for id=(mid-1):-1:1

        iclosest(id)=iclosest(id+1);
        icTesind(id)=icTesind(id+1);

        visited(:)=0;
        visited(icTesind(id))=1;

        di2vec=sqrt(sum((repmat(DATA(:,id),1,nTes)-MODEL(:,Tes(icTesind(id),:))).^2,1));
        bol=not(bol);

        while bol

            [so,in]=sort(di2vec);

            for ii=nTes:-1:2
                Ti=Tesind(icTesind(id),in(ii));
                if Ti>0
                    if not(visited(Ti))
                        break;
                    end
                end
            end

            if Ti==0
                bol=not(bol);
            elseif visited(Ti)
                bol=not(bol);
            else
                Tv=Tesver(icTesind(id),in(ii));
                visited(Ti)=1;
                icTesind(id)=Ti;
                di2vec([1:(Tv-1),(Tv+1):nTes])=di2vec([1:(in(ii)-1),(in(ii)+1):nTes]);
                di2vec(Tv)=norm(DATA(:,id)-MODEL(:,Tes(Ti,Tv)));
            end
        end
        iclosest(id)=Tes(icTesind(id),in(1));
        ERROR=ERROR+err(so(1),fitting,id);
    end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ERROR=icp_closest(tes_flag,fitting)
% Usage:
%           ERROR = icp_closest(tes_flag,fitting)
%
% ERROR=sum of all errors between points in model and points in data.
%
% ICP_CLOSEST finds indexes of closest model points for each point in data.

if tes_flag==3

    global MODEL DATA iclosest
    md=size(DATA,2);
    mm=size(MODEL,2);

    ERROR=0;

    for id=1:md
        dist=Inf;
        for im=1:mm
            dista=norm(MODEL(:,im)-DATA(:,id));
            if dista<dist
                iclosest(id)=im;
                dist=dista;
            end
        end
        ERROR=ERROR+err(dist,fitting,id);
    end

elseif tes_flag==1

    global MODEL DATA Tes ir jc iclosest

    [mTes,nTes]=size(Tes);
    ERROR=0;
    bol=logical(0);

    for id=1:size(DATA,2)

        bol=not(bol);
        while bol
            bol=not(bol);
            distc=norm(DATA(:,id)-MODEL(:,iclosest(id)));
            distcc=2*distc;
            for in=ir(jc(iclosest(id)):(jc(iclosest(id)+1)-1))
                for ind=Tes(in,:)
                    distcc=norm(DATA(:,id)-MODEL(:,ind));
                    if distcc<distc
                        distc=distcc;
                        bol=not(bol);
                        iclosest(id)=ind;
                        break;
                    end
                end
                if bol
                    break;
                end
            end
        end
        ERROR=ERROR+err(distc,fitting,id);
    end

else  % tes_flag==2

    global MODEL DATA Tes Tesind Tesver iclosest icTesind

    [mTes,nTes]=size(Tes);
    ERROR=0;
    bol=logical(0);
    visited=logical(zeros(1,mTes));

    for id=1:size(DATA,2)
        visited(:)=0;
        visited(icTesind(id))=1;

        di2vec=sqrt(sum((repmat(DATA(:,id),1,nTes)-MODEL(:,Tes(icTesind(id),:))).^2,1));
        bol=not(bol);

        while bol

            [so,in]=sort(di2vec);

            for ii=nTes:-1:2
                Ti=Tesind(icTesind(id),in(ii));
                if Ti>0
                    if not(visited(Ti))
                        break;
                    end
                end
            end

            if Ti==0
                bol=not(bol);
            elseif visited(Ti)
                bol=not(bol);
            else
                Tv=Tesver(icTesind(id),in(ii));
                visited(Ti)=1;
                icTesind(id)=Ti;
                di2vec([1:(Tv-1),(Tv+1):nTes])=di2vec([1:(in(ii)-1),(in(ii)+1):nTes]);
                di2vec(Tv)=norm(DATA(:,id)-MODEL(:,Tes(Ti,Tv)));
            end
        end
        iclosest(id)=Tes(icTesind(id),in(1));
        ERROR=ERROR+err(so(1),fitting,id);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function icp_transformation(fitting,refpnt)
% Finds the rotation and translation of the DATA points

global MODEL DATA iclosest TR TT

M=size(DATA,1);
N=size(DATA,2);

bol=0;

if not(isempty(refpnt))
    bol=1;
    dis=sqrt(sum((MODEL(:,iclosest)-repmat(refpnt,1,N)).^2,1));
    weights=weightfcn(dis');
end

if bol

    if fitting(1)==2

        if length(fitting)>1
            weights=fitting(2:(N+1)).*weights;
            weights=weights/sum(weights);
        end

        med=DATA*weights; mem=MODEL(:,iclosest)*weights;
        A=DATA-repmat(med,1,N);
        B=MODEL(:,iclosest)-repmat(mem,1,N);

        for i=1:N
            A(:,i)=weights(i)*A(:,i);
        end

    elseif fitting(1)==3

        V=sum((DATA-MODEL(:,iclosest)).^2,1);
        [soV,in]=sort(V);
        ind=in(1:fitting(2));

        weights(ind)=weights(ind)/sum(weights(ind));

        med=DATA(:,ind)*weights(ind); mem=MODEL(:,iclosest(ind))*weights(ind);
        A=DATA(:,ind)-repmat(med,1,fitting(2));
        B=MODEL(:,iclosest(ind))-repmat(mem,1,fitting(2));

        for i=1:fitting(2)
            A(:,i)=weights(ind(i))*A(:,ind(i));
        end

    end

else

    if fitting(1)==2

        if length(fitting)==1

            med=mean(DATA,2); mem=mean(MODEL(:,iclosest),2);
            A=DATA-repmat(med,1,N);
            B=MODEL(:,iclosest)-repmat(mem,1,N);

        else

            med=DATA*fitting(2:(N+1)); mem=MODEL(:,iclosest)*fitting(2:(N+1));
            A=DATA-repmat(med,1,N);
            B=MODEL(:,iclosest)-repmat(mem,1,N);

            for i=1:N
                A(:,i)=fitting(i+1)*A(:,i);
            end

        end

    elseif fitting(1)==3

        V=sum((DATA-MODEL(:,iclosest)).^2,1);
        [soV,in]=sort(V);
        ind=in(1:fitting(2));

        med=mean(DATA(:,ind),2); mem=mean(MODEL(:,iclosest(ind)),2);
        A=DATA(:,ind)-repmat(med,1,fitting(2));
        B=MODEL(:,iclosest(ind))-repmat(mem,1,fitting(2));

    end

end

[U,S,V] = svd(B*A');
U(:,end)=U(:,end)*det(U*V');
R=U*V';

% Compute the translation
T=(mem-R*med);
TR=R*TR;  TT=R*TT+T;

function ERR=err(dist,fitting,ind)

if fitting(1)==2
    if (ind+1)>length(fitting)
        ERR=dist^2;
    else
        ERR=fitting(ind+1)*dist^2;
    end
elseif fitting(1)==3
    ERR=dist^2;
else
    ERR=0;
    warning('Unknown value of fitting!');
end

function weights=weightfcn(distances)

maxdistances=max(distances);
mindistances=min(distances);

if maxdistances>1.1*mindistances
    weights=1+mindistances/(maxdistances-mindistances)-distances/(maxdistances-mindistances);
else
    weights=maxdistances+mindistances-distances;
end

weights=weights/sum(weights);
