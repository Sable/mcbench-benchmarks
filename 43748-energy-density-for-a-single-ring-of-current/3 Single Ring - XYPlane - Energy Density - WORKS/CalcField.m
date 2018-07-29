
%(c) 2013 The Polywell Guy - http://thepolywellblog.blogspot.com/


function SolMats = CalcField(Coordinates, Parameters, Cells)
% The energy density is driven by the magnetic field strength

SolMats = struct('EnergyDensity',zeros(Cells, Cells),'BRadial',zeros(Cells, Cells),'BLinear',zeros(Cells, Cells));



    for yloop = 1:Cells   
    	for xloop = 1:Cells  

        Point = [Coordinates.XCor(xloop,yloop),Coordinates.YCor(xloop,yloop)];        
        Vector = SingleRing(Point, Parameters);
        
        % You need to convert guass into tesla. 
        MagDensity = (1/10000)*sqrt(Vector.Brad^2+Vector.Bline^2);
        MagDensity = (MagDensity*MagDensity)*(1/(2*Parameters.Mu));
        
        SolMats.EnergyDensity(xloop, yloop) = MagDensity;
        SolMats.BRadial(xloop, yloop) = Vector.Brad;
        SolMats.BLinear(xloop, yloop)= Vector.Bline;

        
        end  
    end

end

