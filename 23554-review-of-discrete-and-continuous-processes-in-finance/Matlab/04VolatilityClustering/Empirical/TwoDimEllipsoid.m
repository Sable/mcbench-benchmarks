function TwoDimEllipsoid(Location,Square_Dispersion,Scale,PlotEigVectors,PlotSquare)
% this function computes the location-dispersion ellipsoid 
% see "Risk and Asset Allocation"-Springer (2005), by A. Meucci

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute the ellipsoid in the r plane, solution to  ((R-Location)' * Dispersion^-1 * (R-Location) ) = Scale^2                                   
[EigenVectors,EigenValues] = eig(Square_Dispersion);
EigenValues=diag(EigenValues);
Centered_Ellipse=[]; 
Angle = [0 : pi/500 : 2*pi];
NumSteps=length(Angle);
for i=1:NumSteps
    y=[cos(Angle(i))                                   % normalized variables (parametric representation of the ellipsoid)
        sin(Angle(i))];
    Centered_Ellipse=[Centered_Ellipse EigenVectors*diag(sqrt(EigenValues))*y];  
end
R= Location*ones(1,NumSteps) + Scale*Centered_Ellipse;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%draw plots

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the ellipsoid
hold on
h=plot(R(1,:),R(2,:));
set(h,'color','r','linewidth',2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot a rectangle centered in Location with semisides of lengths Dispersion(1) and Dispersion(2), respectively
if PlotSquare
    Dispersion=sqrt(diag(Square_Dispersion));
    Vertex_LowRight_A=Location(1)+Scale*Dispersion(1); Vertex_LowRight_B=Location(2)-Scale*Dispersion(2);
    Vertex_LowLeft_A=Location(1)-Scale*Dispersion(1); Vertex_LowLeft_B=Location(2)-Scale*Dispersion(2);
    Vertex_UpRight_A=Location(1)+Scale*Dispersion(1); Vertex_UpRight_B=Location(2)+Scale*Dispersion(2);
    Vertex_UpLeft_A=Location(1)-Scale*Dispersion(1); Vertex_UpLeft_B=Location(2)+Scale*Dispersion(2);
    
    Square=[Vertex_LowRight_A            Vertex_LowRight_B 
        Vertex_LowLeft_A             Vertex_LowLeft_B 
        Vertex_UpLeft_A              Vertex_UpLeft_B
        Vertex_UpRight_A             Vertex_UpRight_B
        Vertex_LowRight_A            Vertex_LowRight_B];
        hold on;
        h=plot(Square(:,1),Square(:,2));
        set(h,'color','r','linewidth',2)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot eigenvectors in the r plane (centered in Location) of length the
% square root of the eigenvalues (rescaled)
if PlotEigVectors
    L_1=Scale*sqrt(EigenValues(1));
    L_2=Scale*sqrt(EigenValues(2));
    
    % deal with reflection: matlab chooses the wrong one
    Sign= sign(EigenVectors(1,1));
    Start_A=Location(1);                               % eigenvector 1
    End_A= Location(1) + Sign*(EigenVectors(1,1)) * L_1;
    Start_B=Location(2);
    End_B= Location(2) + Sign*(EigenVectors(1,2)) * L_1;
    hold on
    h=plot([Start_A End_A],[Start_B End_B]);
    set(h,'color','r','linewidth',2)
    axis equal;
    
    Start_A=Location(1);                               % eigenvector 2
    End_A= Location(1) + (EigenVectors(2,1)* L_2);
    Start_B=Location(2);
    End_B= Location(2) + (EigenVectors(2,2)* L_2);
    hold on;
    h=plot([Start_A End_A],[Start_B End_B]);
    set(h,'color','r','linewidth',2)
end

grid on

