function [out]=fcnSensitivityRun_3D(Objfun, BCcoeff, setts, param)
% performes sensitivity corelation check by pairs
% for any function
% Objfun- objective function with one scalar return
% BCcoeff- base case parameter values
% setts -settings e.g. range,step
% param - additional parameters for the Objfun function
% returns X,Y,Z cells for each parameter pair.

% ver. 1.0
% by Levente L. SIMON - ETH Zuerich
% email: l.simon@chem.ethz.ch
% =============================================================

Rangesize = setts.Range;
Step = setts.step;


% ---------------------------------------------------------
Srange = (-1) * Rangesize :Step: Rangesize%  set step
for i =1: size(BCcoeff,2)
    Coeffrange(i,:)  = BCcoeff(i) + (Srange./100 .* BCcoeff(i)) ; % calculate the interval for each coefficient
end

% ---------------------------------------------------------
CoeffComb2 = combnk(1:size(BCcoeff,2), 2); % calculation of combinations based on the parameter number
% sorts matrix from back to front , v 1.1
CoeffComb = CoeffComb2(end:-1:1,:);

% Plot settings
MaxSubPlot = ceil(size(CoeffComb,1) / 3);


for n=1:size(CoeffComb,1)

    % get interval for each data pair
    X = Coeffrange (CoeffComb(n,1), :);
    Y = Coeffrange (CoeffComb(n,2), :);
   clear Z
    for i=1:size(Y,2) % have allways same size, simetric

        for j=1:size(X,2)
            % update vector of BC coefficients
            Scoeff = BCcoeff; Scoeff(CoeffComb(n,1)) = X(j); Scoeff(CoeffComb(n,2)) = Y(i);
           
            Z(j,i)=feval(Objfun, Scoeff, param);
          end
   end


    % -------- normalize the Z  0..100  --
    Zz = fcnNormalize0_1(Z);
    
      Xcell{n} = X; Ycell{n} = Y; Zcell{n} = Zz; 
      xlabel (strcat ('Parameter No. ', num2str(CoeffComb(n,1))));
      ylabel (strcat ('Parameter No. ', num2str(CoeffComb(n,2))));
      XlabelCell{n} = strcat ('Parameter No. ', num2str(CoeffComb(n,1)));
      YlabelCell{n} = strcat ('Parameter No. ', num2str(CoeffComb(n,2)));


      disp(strcat('Z matrix calculated for pair:',num2str(n)));

end   

% Function output structure
out.Xcell = Xcell;
out.Ycell =Ycell;
out.Zcell=Zcell;
out.XlabelCell=XlabelCell;
out.YlabelCell=YlabelCell;
out.MaxSubPlot=MaxSubPlot;
out.setts=setts;



