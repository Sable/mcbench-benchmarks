function h=TwoDimEllipsoid(Location,Square_Dispersion,Scale,PlotEigVectors,PlotSquare)
% this function computes the location-dispersion ellipsoid 
% for details see "Risk and Asset Allocation"-Springer (2005), by A. Meucci
% inputs: 
% 2x1 location vector (typically the expected value)
% 2x2 scatter matrix Square_Dispersion (typically the covariance matrix)
% a scalar Scale, that specifies the scale (radius) of the ellipsoid
% if PlotEigVectors is 1 then the eigenvectors (=principal axes) are plotted
% if PlotSquare is 1 then the enshrouding box is plotted. If Square_Dispersion is the covariance
% the sides of the box represent the standard deviations of the marginals

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute the ellipsoid in the r plane, solution to  ((R-Location)' * Square_Dispersion^(-1) * (R-Location) ) = Scale^2                                   
[EigenVectors,EigenValues] = eig(Square_Dispersion);
EigenValues=diag(EigenValues);


Centered_Ellipse=[]; 
Angle = [0 : pi/500 : 2*pi];
NumSteps=length(Angle);
for i=1:NumSteps
    z=[cos(Angle(i))                                   % normalized variables (parametric representation of the ellipsoid)
        sin(Angle(i))];
    Centered_Ellipse=[Centered_Ellipse EigenVectors*diag(sqrt(EigenValues))*z];  
end
R= Location*ones(1,NumSteps) + Scale*Centered_Ellipse;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the ellipsoid
hold on
h=plot(R(1,:),R(2,:));
set(h,'color','b','linewidth',2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if PlotSquare
    % plot a rectangle centered in Location with semisides of lengths the square roots of the diagonal of Square_Dispersion
    Dispersion=sqrt(diag(Square_Dispersion));
    Vertex_LowRight_x=Location(1)+Scale*Dispersion(1); Vertex_LowRight_y=Location(2)-Scale*Dispersion(2);
    Vertex_LowLeft_x=Location(1)-Scale*Dispersion(1); Vertex_LowLeft_y=Location(2)-Scale*Dispersion(2);
    Vertex_UpRight_x=Location(1)+Scale*Dispersion(1); Vertex_UpRight_y=Location(2)+Scale*Dispersion(2);
    Vertex_UpLeft_x=Location(1)-Scale*Dispersion(1); Vertex_UpLeft_y=Location(2)+Scale*Dispersion(2);
    
    Square=[Vertex_LowRight_x            Vertex_LowRight_y 
        Vertex_LowLeft_x             Vertex_LowLeft_y 
        Vertex_UpLeft_x              Vertex_UpLeft_y
        Vertex_UpRight_x             Vertex_UpRight_y
        Vertex_LowRight_x            Vertex_LowRight_y];
        hold on;
        h=plot(Square(:,1),Square(:,2));
        set(h,'color','r','linewidth',2)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if PlotEigVectors
    % plot eigenvectors in the r plane (centered in Location) of length the
    % square root of the eigenvalues (rescaled)

    L_1=Scale*sqrt(EigenValues(1));
    L_2=Scale*sqrt(EigenValues(2));
    
    % deal with reflection: matlab chooses the wrong one
    Sign= sign(EigenVectors(1,1));
    Start_x=Location(1);                               % eigenvector 1
    End_x= Location(1) + Sign*(EigenVectors(1,1)) * L_1;
    Start_y=Location(2);
    End_y= Location(2) + Sign*(EigenVectors(2,1)) * L_1;
    hold on
    h=plot([Start_x End_x],[Start_y End_y]);
    set(h,'color','r','linewidth',2)
    
    Start_x=Location(1);                               % eigenvector 2
    End_x= Location(1) + (EigenVectors(1,2)* L_2);
    Start_y=Location(2);
    End_y= Location(2) + (EigenVectors(2,2)* L_2);
    hold on;
    h=plot([Start_x End_x],[Start_y End_y]);
    set(h,'color','r','linewidth',2)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
grid on
axis equal;
