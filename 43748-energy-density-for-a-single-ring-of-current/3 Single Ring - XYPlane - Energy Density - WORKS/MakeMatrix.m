
%(c) 2013 The Polywell Guy - http://thepolywellblog.blogspot.com/


function CordMats = MakeMatrix(Bounds, Cells)
%This function deals with the 3D matrices


% Make the X, Y, Z Coordinates
XCor = PlanefillX(zeros(Cells, Cells), Bounds, Cells);
YCor = PlanefillY(zeros(Cells, Cells), Bounds, Cells);


CordMats = struct('XCor',XCor,'YCor',YCor);

end



function mat = PlanefillY(mat, Bounds, Cells)

int = abs(Bounds.XPos - Bounds.XNeg)/(Cells-1);
xStart = Bounds.XPos;

    for loopx = 1:Cells
        for loopy = 1:Cells
            mat(loopx, loopy) = xStart;
        end
        xStart = xStart - int;
    end
end

function mat = PlanefillX(mat, Bounds, Cells)

int = abs(Bounds.YPos - Bounds.YNeg)/(Cells-1);
yStart = Bounds.YNeg;


    for loopy = 1:Cells
        for loopx = 1:Cells
            mat(loopx, loopy) = yStart;
        end
        yStart = yStart + int;
    end

end


