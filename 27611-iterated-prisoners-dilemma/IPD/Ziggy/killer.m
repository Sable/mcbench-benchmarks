function res = killer(n,p)

persistent plist rd
plist = [plist p];

switch n
    case 1
        res = 'cooperate';
        plist = p;
        rd = 0;
    case 20
        res = 'defect';
    otherwise
        if any( (plist(n-1:n)==1) + (plist(n-1:n)==5) ) && rd<5
            res = 'defect';
            rd = rd+1;
        else
            res = 'cooperate';
            if ~rd<5, rd=0; end
        end
end