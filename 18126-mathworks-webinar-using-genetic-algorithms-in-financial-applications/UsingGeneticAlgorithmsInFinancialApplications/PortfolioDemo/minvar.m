function [weights,fval,qpExit] = minvar(covMat,indvRet,targetRet)
    portSize = length(indvRet);
    f = zeros(portSize,1);
    Aeq = [ ones(1,portSize); indvRet' ];
    beq = [ 1; targetRet ];
    lbnds = zeros(portSize,1);
    ubnds = ones(portSize,1);
    qoptions = optimset('Display','off','LargeScale','off');
    [weights,fval,qpExit] = quadprog(covMat,f,[],[],Aeq,beq,lbnds,ubnds,[],qoptions);
    % Double result (quadprog minimizes (1/2)w'Hw)
    fval = 2*fval;
end