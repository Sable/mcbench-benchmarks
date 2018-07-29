function [geo] = GetGeometryfromGUI(root, tip, wing, cruise, engine, hplot, output, airfoildata)
% Get parameters from the GUI and create geometry structure "geo"
% Gets the user defined parameters from the GUI
% Performs limited error checking and sets boolean to tell ExecCalc to continue or not

%Clear clock
set(output.calctime,'String','----');

%Set wing geometry from values from GUI
geo.t0 = clock; %Start time
geo.b = str2num(get(wing.span,'String'))/3.281;  %Convert to meters
geo.c_r = str2num(get(root.chord,'String'))/3.281;  %Convert to meters
geo.taper = str2num(get(tip.chord,'String'))/str2num(get(root.chord,'String'));
geo.i_r = str2num(get(root.angle,'String'))*pi/180;   %Convert to radians
geo.twist = (str2num(get(tip.angle,'String'))-str2num(get(root.angle,'String')))*pi/180;  %Convert to radians
geo.dih = str2num(get(wing.dihedral,'String'))*pi/180; %Convert to radians
geo.root = airfoildata{1}{get(root.airfoil,'Value')};
geo.tip = airfoildata{1}{get(tip.airfoil,'Value')};
geo.alpha = str2num(get(wing.AOA,'String'))*pi/180; %Convert to radians
geo.V = str2num(get(cruise.velocity,'String'))*0.5144; %Convert knots to m/s
[geo.density, geo.a geo.visc] = StandardAtmosphere(get(cruise.altitude,'String'));
geo.M = geo.V/geo.a;
geo.S_Sref = str2num(get(cruise.wettedarea,'String'));  %Dimensionless
geo.cf = str2num(get(cruise.skinfriction,'String'));  %Dimensionless
geo.ns = str2num(get(wing.ns,'String'));
geo.nc = str2num(get(wing.nc,'String'));
geo.sweep = str2num(get(wing.sweep,'String'))*pi/180;  %Convert to radians
geo.S = 0.5*(geo.c_r + geo.c_r*geo.taper)*geo.b;  %Square meters
geo.c_av = 0.5*(geo.c_r + geo.c_r*geo.taper);  %Meters
geo.Re_r = geo.V*geo.density*geo.c_r/geo.visc; %Reynolds number at root
geo.Re_t = geo.V*geo.density*geo.c_r*geo.taper/geo.visc; %Reynolds number at root
geo.rootindex = get(root.airfoil,'Value');      %index to selected root airfoil
geo.tipindex = get(tip.airfoil,'Value');         %index to selected tip airfoil
geo.propefficiency = str2num(get(engine.propeffic,'String'));  %from Anderson, Aircraft Performance and Design
geo.propSFC = str2num(get(engine.SFC,'String'))*1.657e-6; % convert lb fuel/hp-hr to m^-1 Wikipedia (Specific Fuel Consumption)
geo.jetTSFC = str2num(get(engine.TSFC,'String'))/3600; %convert to lb fuel per lb-s thrust; Anderson, Aircraft Performance and Design pg. 299
geo.emptyweight = str2num(get(cruise.weight,'String'))*4.44;%Convert weight from lbf to N
geo.fueldens = 0.840*1e3; %(kg/m^3) Density of Jet A-1 at 15deg C (Wikipedia)
geo.wingfuel = str2num(get(engine.wingfuel,'String'))/100;  %Percent of wing dedicated to carrying fuel
geo.withinconstraints = 1; % Set boolean flag stating that all geometry is within constraints

%Set the selected type of engine
if get(engine.panel,'SelectedObject')==engine.prop
    geo.engine = 'prop';
elseif get(engine.panel,'SelectedObject')==engine.jet
    geo.engine = 'jet';
else
    geo.engine = 0;
end

%Set initial output
set(wing.taper,'String',num2str(geo.taper));
set(wing.twist,'String',num2str(geo.twist));
set(root.Re,'String',num2str(round(geo.Re_r/1e3)/1e3));
set(tip.Re,'String',num2str(round(geo.Re_t/1e3)/1e3));
set(cruise.density,'String',num2str(round(geo.density*1000)/1000));
set(cruise.viscosity,'String',num2str(round(geo.visc*10000000)/10000000));
set(cruise.mach,'String',num2str(round(geo.M*100)/100));

%Limited error checking
if geo.sweep < 80*pi/180  %If sweep < 80 deg
    set(wing.sweep,'ForegroundColor','black')
else
    set(wing.sweep,'ForegroundColor','red')
    ZeroOutput(output)
    geo.withinconstraints = 0; % User defined geometry is not within constraints
end
if geo.dih < 80*pi/180  %If dihedral < 80 deg
    set(wing.dihedral,'ForegroundColor','black')
else
    set(wing.dihedral,'ForegroundColor','red')
    ZeroOutput(output)
    geo.withinconstraints = 0; % User defined geometry is not within constraints
end
if geo.M < 0.65  %If M < 0.65
    set(cruise.mach,'ForegroundColor','black')
else
    set(cruise.mach,'ForegroundColor','red')
    ZeroOutput(output)
    geo.withinconstraints = 0; % User defined geometry is not within constraints
end

