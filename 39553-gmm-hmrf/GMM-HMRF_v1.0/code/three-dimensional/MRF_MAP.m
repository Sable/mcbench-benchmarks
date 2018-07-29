%%  The MAP algorithm
%---input---------------------------------------------------------
%   X: initial 3D labels
%   Y: 3D image
%   GMM: Gaussian mixture model parameters
%   k: number of labels
%   g: number of components of each GMM
%   MAP_iter: maximum number of iterations of the MAP algorithm
%   show_plot: 1 for showing a plot of energy in each iteration
%       and 0 for not showing
%---output--------------------------------------------------------
%   X: final 3D labels
%   sum_U: final energy

%   Copyright by Quan Wang, 2012/12/16
%   Please cite: Quan Wang. GMM-Based Hidden Markov Random Field for 
%   Color Image and 3D Volume Segmentation. arXiv:1212.4527 [cs.CV], 2012.

function [X sum_U]=MRF_MAP(X,Y,GMM,k,g,MAP_iter,beta,show_plot)

[m n z]=size(Y);

sum_U_MAP=zeros(1,MAP_iter);
for it=1:MAP_iter % iterations
    fprintf('  Inner iteration: %d\n',it);
    
    U=zeros(m*n*z,k);
    U1=U;
    U2=U;
    y=Y(:);

    for l=1:k % all labels
        for c=1:g
            mu=GMM{l}.mu(c,:);
            Sigma=GMM{l}.Sigma(:,:,c);
            p=GMM{l}.PComponents(c);
            
            yi=y-mu;
            temp1=yi.*yi/Sigma/2;
            temp1=temp1+log(sqrt(Sigma));
            U1(:,l)=U1(:,l)+temp1*p;
        end
     
        for ind=1:m*n*z % all pixels
            [i j q]=ind2ijq(ind,m,n);
            u2=0;
            if i-1>=1
                u2=u2+(l ~= X(i-1,j,q))/2;
            end
            if i+1<=m
                u2=u2+(l ~= X(i+1,j,q))/2;
            end
            if j-1>=1
                u2=u2+(l ~= X(i,j-1,q))/2;
            end
            if j+1<=n
                u2=u2+(l ~= X(i,j+1,q))/2;
            end
            if q-1>=1
                u2=u2+(l ~= X(i,j,q-1))/2;
            end
            if q+1<=z
                u2=u2+(l ~= X(i,j,q+1))/2;
            end
            U2(ind,l)=u2;
        end
    end
    U=U1+U2*beta;
    [temp x]=min(U,[],2);
    sum_U_MAP(it)=sum(temp(:));
    X=reshape(x,[m n z]);
    
    if it>=3 && std(sum_U_MAP(it-2:it))<0.01
        break;
    end
end

sum_U=0;
for ind=1:m*n*z % all pixels
    sum_U=sum_U+U(ind,x(ind));
end
if show_plot==1
    figure;
    plot(1:it,sum_U_MAP(1:it),'r');
    title('sum U MAP');
    xlabel('MAP iteration');
    ylabel('sum U MAP');
    drawnow;
end
