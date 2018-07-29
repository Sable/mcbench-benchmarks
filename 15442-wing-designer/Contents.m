% CODE
%
% Files
%   DeterminePanelGeometry - find coordinates for horseshoe vortices and control points and plot
%   DetermineProfileDrag   - Determine the wing profile drag from the airfoils' drag polars
%   FinalOutput            - calculate score and other outputs, post to the GUI
%   GetGeometryfromGUI     - Get parameters from the GUI and create geometry structure "geo"
%   InducedDrag            - Calculate far field induced drag
%   InitializeGUI          - Initializes the GUI and establishes callback functions
%   LiftCoeff              - Determine the lift coefficient given the vortex strengths
%   Main                   - Main function to run Wing Designer
%   NacaCoord              - determine airfoil skin and camber coordinates from NACA designation
%   parseNACAairfoildata   - parse the text file NACAdata.txt into a structure
%   PerformRegression      - Relate the coefficients of the drag polar to Re as parabolic functions.
%   SpanLoading            - Determine center of pressure and spanwise loading 
%   StandardAtmosphere     - Read in altitude and output viscosity, density, and speed of sound
%   VortexStrength         - Implement Vortex Lattice Method
%   ZeroOutput             - Null output to GUI when error checking is not satisfied
% Text files
%   NACAdata.txt           - Drag Polar Coefficients from XFoil

