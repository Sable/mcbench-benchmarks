function NPath=SetNewPath(CDr,N,T) %#ok<INUSD>

NPath=sprintf('%s',cell2mat(N(1)),'\');
if length(N)>1
    for n=2:length(N)
        NPath1=sprintf('%s',cell2mat(N(n)),'\');
        NPath=sprintf('%s',NPath,NPath1);
    end
end
if nargin>2
    NPath=sprintf('%s',CDr,'\',NPath);
end
end