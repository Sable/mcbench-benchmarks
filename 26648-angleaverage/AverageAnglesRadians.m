
function AngleAvg = AverageAnglesRadians(InA)
%       Robert Goldstein
%       Schepens Eye Research Institute
%       robert.goldstein@schepens.harvard.edu
    theNumerator = sum(sin(InA));
    theDenominator = sum(cos(InA));
    if(theDenominator ==0)
        AngleAvg = sign(theNumerator)*pi/2;
    else
        AngleAvg = atan2(theNumerator,theDenominator);
    end
    
end