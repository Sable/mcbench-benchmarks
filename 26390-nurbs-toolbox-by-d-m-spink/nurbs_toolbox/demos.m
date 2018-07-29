function tbxStruct=Demos 
% Demos   Demo List infomation for NURBS Toolbox 
 
% D.M. Spink 
% Copyright (c) 2000 
 
if nargout == 0; demo toolbox; return; end 
 
tbxStruct.Name='nurbs'; 
tbxStruct.Type='Toolbox'; 
 
tbxStruct.Help= ... 
        {' The NURBS Toolbox provides commands for the construction' 
         ' and use of Non-Uniform Rational B-Splines (NURBS).' 
         ' '}; 
 
tbxStruct.DemoList={ 
                '3D Line','demoline', 
                'Rectangle','demorect', 
                'Circle and Arc','democirc', 
                'Helix','demohelix', 
                'Ellipse', 'demoellip', 
                'Test Curve','democurve', 
                'Test Surface','demosurf', 
                'Bilinear Surface','demo4surf', 
                'Knot Insertion','demokntins', 
                'Degree Elevation','demodegelev', 
                'Curve derivatives','demodercrv', 
                'Surface derivatives','demodersrf' 
                'Cylinderical arc','democylind', 
                'Ruled Surface','demoruled', 
                'Coons Surface','democoons', 
                'Test Extrusion','demoextrude', 
                'Test Revolution - Cup','demorevolve', 
                'Test Revolution - Ball & Torus','demotorus', 
                '2D Geomtery','demogeom'}; 
 
