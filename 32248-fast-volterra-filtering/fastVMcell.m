function ys = fastVMcell(u,kernels,memories)
%fastVM   Fast algorithm for computing the response of a discrete Volterra
%         model given a input sequence.
%
%         Implementation based on the paper:
%         Morhac, M., 1991 - A Fast Algorithm of Nonlinear Volterra Filtering
%         See original publication for details.
%
%   kernels is a cell containing tensors that correspond to the model
%   kernels, i.e., kernels{p} corresponds to the p-th order kernel.
%
%   memories is a vector that indicates the memory length of each kernel,
%   i.e., memories(p) is an non-negative integer corresponding to the
%   memory extension (in samples) of the p-th order kernel.
%
%   IMPORTANT: all the kernels must be in the triangular form, that is,
%   they must be so that k(t1,t2,...,tn) ~= 0 only if t1 <= t2 <= ... <= tn
%
%   u is the input fed to the model.
%
%   y is the response computed.
%
%   Author: J. Henrique Goulart (jhgoulart@gmail.com)
%   Version: 1.0 2011 

u = u(:).';

Nu = length(u);
MM = max(memories);
NN = Nu+MM-1;
P = length(kernels);

ys = zeros(P,NN);

ylin = frconv(kernels{1},u);

% First order output
ys(1,:) = [ylin zeros(1,NN-length(ylin))];

if P==1
    return;
end;

inpfeat(MM).feat = zeros(1,Nu);
for m=1:MM                                         
    inpfeat(m).feat = [u(m:end) zeros(1,m-1)]; 
end;


% Higher order outputs
parfor p = 2:P
    
    M = memories(p);
    
    inds = zeros(1,p-1);
    siz = repmat(M,[1 p]);

    ys(p,:) = zeros(1,NN);
    
    while ~isempty(inds)
        
        us = u;
        for ii=inds
            us = us.*inpfeat(ii+1).feat;
        end;

        hinds = [0,inds(1)-inds(2:end),inds(1)];
        hinds = repmat(hinds,[M-hinds(end) 1]);
        incs = repmat((0:1:M-hinds(end)-1)',[1 p]);
        hinds = hinds+incs;
        
        hinds = mysub2ind(siz,hinds+1);
        hs = kernels{p}(hinds);       
        hs = hs(:).';
        compM = M-length(hinds);
        hs = [zeros(1,compM) hs];
        
        yparcial = frconv(hs,us);
        ys(p,:) = ys(p,:) + [yparcial zeros(1,NN-length(yparcial))];
        
        inds = nextinds(inds,M);
    end;
end;