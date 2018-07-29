function jdoric( n,mink,maxk,a,b )
%RIC :
%   Generates restricted and unrestricted integer compositions 
%   n = integer to be partitioned 
%   kmin = min. no. of summands 
%   kmax = max. no. of summands
%   a = min. value of summands
%   b = max.value of summands
%
% from : "A Unified Approach to Algorithms Generating Unrestricted
%           and Restricted Integer Compositions and Integer Partitions"
%   J. D. OPDYKE, J. Math. Modelling and Algorithms (2009) V9 N1, p.53 - 97
% 
% Matlab implementation :
% Theophanes E. Raptis, DAT-NCSRD 2010
% http://cag.dat.demokritos.gr
% rtheo@dat.demokritos.gr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cell = [];
rowdec = 0;
for i=mink:maxk
    in = n/i;
    if a>1 rowdec = i; end
    if a<=in && in <= b N2N(n,i,a,b,n-1-rowdec,i-1,0,0,cell); end
end
end

function N2N(n,i,a,b,row,col,level,cumsum,cell)
if col~=0
    if col==1
        jmax = max(a,n-cumsum-b);
        jmin = min(b,n-cumsum-a);
        for j=jmax : jmin
            cell(i-1) = j; cell(i) = n-cumsum-j;
            disp(cell);
        end
    else
        cell(level+1) = a;
        tmp = cumsum + a;
        ntmp = round((n - tmp)/(i-level-1));
        if a <= ntmp && ntmp <= b && cell(level+1)
            N2N(n,i,a,b,row-a+1,col-1,level+1,tmp,cell);
        else
            for q=1:min((b-a),(row-a)-(col-1))
                cell(level+1) = cell(level+1)+1;
                tmp = tmp + 1;
                ntmp = round((n - tmp)/(i-level-1));
                if a <= ntmp && ntmp <= b && cell(level+1)
                    q2 = q; q = min((b-a),(row-a)-(col-1));
                    N2N(n,i,a,b,row-a-q2+1,col-1,level+1,tmp,cell);
                end
            end
        end
    end
else disp(n)
end
if level>0 && row>1
    cell(level) = cell(level)+1;
    cumsum = cumsum + 1;
    if cell(level)<a
        cumsum = cumsum - cell(level) + a;
        cell(level) = a; 
        row = row + cell(level) - a;
    end
    toploop = min(b-cell(level),row-col-1);
    npart = round((n-cumsum)/(i-level));
    if a<=npart && npart<=b && cell(level)<=b
        N2N(n,i,a,b,row-1,col,level,cumsum,cell);
    else
        for p=1:toploop
            cell(level) = cell(level)+1;
            cumsum = cumsum + 1;
            npart = round((n-cumsum)/(i-level));
            if a<=npart && npart<=b && cell(level)<=b
                p2 = p; p = toploop;
                N2N(n,i,a,b,row-p2,col,level,cumsum,cell);
            end
        end
    end
end
end