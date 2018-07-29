function Main()
% This program is a stand-alone toy example of radiation treatment planning
% (RTP) optimization for a brain tumor case.
%     The program generates a toy patient head model using scaled and shifted
% ellipsoids and p-norm sublevel sets to represent all the volumes of
% interest (VOIs), including skin, eyes, optic nerves, brain stem, a tumor
% and artificial "shell" around the tumor. These VOI sublevel sets are then
% discretized into PointClouds, by retaining the points in a discrete 3-D
% grid of volume elements (voxels) that lie in the 1-sublevel set of the 
% VOI's p-norm model.
%     Then we compute candidate beam directions by firing beams at random 
% points on the tumor surface from a set of about 150 nodes, located 
% uniformly in a spherical region of radius 80cm from the patient's head.
%     Then we compute the dose vectors associated with each beam in each of
% the VOIs, by evaluating a dose function in a cylindrical region around each
% beam direction. The dose function is a crude model of the roll-off with
% depth, and radial diffusion or scatter. For each candidate beam, this 
% rolloff/scatter function is evaluated for each voxel in each VOI. Thus
% each beam results in a column of the patient dose matrix.
% Finally, we set the min and max dosages for each VOI.
%     We then pass the dose matrices and min and max specs to one of two
% solvers (CPLEX or ADMM), which find the optimal set of beams and
% intensities (beam weights) for this patient case. This is the optimal
% "plan". The optimization formulation is based on a problem from the
% Stanford EE364b final exam from 2011, by Stephen Boyd and Eric Chu.
%     Then we visualize the optimal plan by plotting the dose levels for 
% all the voxels of each VOI, and the dose volume histograms.
%     The program consists of this Main() function and several "classes":
% (1) Patient: cell array of VOIs, names, etc
% (2) VOI: p-norm model and associated point cloud and boundary, dose specs
% (3) Beams: beam heads,tails,dose vector computation + nodes + collimators
% (4) Model: p-norm models and gradients
% (5) Point Cloud & 3-D geometry functions
% (6) Optimizer functions: CPLEX wrapper and ADMM solver (ala EE364b)
%
% Reference: 
% H. Hindi, "A Tutorial on Optimization Methods for Cancer Radiation
% Treatment Planning," Proc. American Contr. Conf, 2013.
%
% Written by Haitham Hindi, 2012/01/18
%
% DISCLAIMER: This code is intended for algorithm research purposes
% only!! Author makes no claims as to the realism, accuracy, or correctness 
% of ANY part of this code, including (but not limited to): 
% patient anatomy and dimensions; plan safety; beam weights,doses,physics;
% dose units, dose specs; plan quality, evaluation metrics. The author is
% an engineer with no medical training whatsoever! This code is supplied
% as-is, with no guarantee of correctness, and the author accepts no 
% responsibility for any damage or false conclusions from the use of this
% code. Of course, we would appreciate hearing about any bugs you might find.

    clear, clc, close all
    rng('default');
    rng(2);

    %====================================================
    % data for patient and beams
    %====================================================
    % patient specs
    PatientName     = 'Toy Brain Tumor Case';
    PatientThetaxyz = [pi/2;0;0];
    PatientOffset   = [0;0;0];
    PatientAxLims   = [-15 15];

    % VOI specs (VOIs are scaled shifted p-norm sublevel sets)
    Target=1;Shell=2;BrStm=3;EyeL=4;EyeR=5;OptNrvL=6;OptNrvR=7;Skin=8;
    VoxSizeSkin      = 1;
    VoxSizeOrgans    = 0.2;%0.15%0.113;
    SampFactorSkin   = 1;
    SampFactorOrgans = 1;
    VOINames      ={'Target','Shell','BrStm','EyeL','EyeR','OptNrvL','OptNrvR','Skin'};
    dmaxs         =[50      , 25    ,20     , 20   , 20   , 20      , 20      , 30];
    dmins         =[40      , 0     , 0     ,  0   ,  0   ,  0      ,  0      ,  0];
    VOINumbers    =[ 1,       2,      3,      4,     5,     6,        7,        8];
    VOITypes      ={'v',     's',    'v',    'v',   'v',   'v',      'v',      's'};
    VOIColors     ={'k',     'r',    'g',    'b',   'b',   'c',      'c',      'y'};
    VOILineStyles ={'-',     '-',    '-',    '-',   '--',  '-',      '--',     '-'};
    VOIVoxSizes   =[VoxSizeOrgans*ones(7,1);VoxSizeSkin];
    VOISampFactors=[SampFactorOrgans*ones(7,1);SampFactorSkin];
    VOIxyzScales  =[1.2*[1;1;1],1.56*[1;1;1],[1.5;1.5;6],1.7*[1;1;1],1.7*[1;1;1],[0.7;4;0.7],[0.7;4;0.7],[11;11;11]];
    VOIpNorms     =[2;  2;  3;  2;  2;  2;  2;  3];
    VOIThetaxyz   =[[0;0;0],[0;0;0],[-pi/8;0;0],[0;0;0],[0;0;0],[pi/6;-pi/6;0],[pi/6;pi/6;0],[0;0;0]];
    VOIOffsets    =[[3;-3;0],[3;-3;0],[0;-3;-5],[-4;8;4],[4;8;4],[-2;3;2],[2;3;2],[0;0;0]];
    VOIHistBins   = 0:max(dmaxs)/50:1.4*max(dmaxs);

    % beam specs
    NPtsSphereParam = 7%8%18
    NodeLocs = GetPointsOnUnitSphere1000(NPtsSphereParam);
    NodeLocs = NodeLocs(find(NodeLocs(:,3)>=-0.6),:);% remove bottom (can't go under patient)
    NodeLocs = NodeLocs(find(NodeLocs(:,2)<= 0.6),:);% remove front  (can't go through patient)
    NodeLocs = 80*NodeLocs;% scale to 80cm radius
    NNodes = size(NodeLocs,1)
    NodesAxLims = 85*[-1 1 -1 1 -1 1];
    Collimators = [5; 7.5; 10; 12.5; 15; 20; 25];%; 30; 35; 40; 50; 60];
    Collimators = Collimators/10; % scale to cm
    NCollimators= length(Collimators);
    NBeamlets = 5;
    NPtsPerAx = 50;
    AxLength = 15;

    %====================================================
    % create patient and beams, solve optimization problem, visualize results
    %====================================================
    % get patient
    disp(['Computing patient model...'])
    Patient = PatientCreate();
    Patient = PatientInit(Patient,PatientName,PatientAxLims,...
                          VOINames,VOINumbers,VOITypes,VOIColors,VOILineStyles,...
                          VOIVoxSizes,VOISampFactors,VOIHistBins,...
                          VOIxyzScales,VOIpNorms,VOIThetaxyz,VOIOffsets);
    Patient = PatientRotateTranslate(Patient,PatientThetaxyz,PatientOffset);

    figure
    PatientPlot(Patient)

    % get beams
    disp(['Computing beam directions...'])
    Beams = BeamsCreate();
    Beams = BeamsInit(Beams,NodeLocs,NodesAxLims,Collimators,NBeamlets,Patient.VOIs{Skin}.Model.f,Patient.VOIs{Target}.PointCloudBdy);

    PlotDoseMapAxialRolloffAndRadialDiffusion(Collimators);
    PlotPatientBeamDirectionsAndNodes(Patient,Beams);
    %figure,hold on
    %PatientPlot(Patient)
    %[GridPts,AxPts] = GetGridPts(NPtsPerAx,AxLength);
    %PlotFewRandomBeamDoseMaps(Beams.Tails,Beams.Heads,Beams.Widths,3,GridPts)

    % compute dose matrices of all VOIs and set upper and lower bounds
    Patient = PatientPrepareForOptimization(Patient,Beams,dmins,dmaxs);

    % construct the Linear Program matrices and solve for optimal beam
    % weights using CLEX or ADMM
    Patient = PatientApplyOptimization(Patient);

    % plot optimal beam weights, constraints, and dose volume histograms
    PatientEvaluate(Patient);

return

%====================================================
% Patient Class: mainly cell array of VOIs, names, axis limits
%====================================================
function Patient = PatientCreate()
    Patient.Name     = [];
    Patient.VOINames = [];
    Patient.NumVOIs  = [];
    Patient.VOIs     = [];
    Patient.AxLims   = [];
    Patient.xBeamWeights = [];
return

function Patient = PatientInit(Patient,PatientName,PatientAxLims,...
                               VOINames,VOINumbers,VOITypes,VOIColors,VOILineStyles,...
                               VOIVoxSizes,VOISampFactors,VOIHistBins,...
                               VOIxyzScales,VOIpNorms,VOIThetaxyz,VOIOffsets)
    Patient.Name = PatientName;
    Patient.VOINames = VOINames;
    Patient.NumVOIs =length(VOINames);
    Patient.VOIs = {};
    for i=1:Patient.NumVOIs
        Modi            = ModelInit(ModelCreate(),VOIxyzScales(:,i),VOIpNorms(i));
        VOIi            = VOIInit(VOICreate(),VOINames{i},VOINumbers(i),VOITypes{i},VOIColors{i},VOILineStyles{i},VOIVoxSizes(i),VOISampFactors(i),Modi,VOIHistBins);
        Patient.VOIs{i} = VOIRotateTranslate(VOIi,VOIThetaxyz(:,i),VOIOffsets(:,i));
    end
    Patient.AxLims = PatientAxLims;
return

function Patient = PatientPrepareForOptimization(Patient,Beams,dmins,dmaxs)
    for i=1:Patient.NumVOIs
        Patient.VOIs{i} = VOIGetDoseAMatrix(Patient.VOIs{i},Beams);
        Patient.VOIs{i} = VOISetDoseMinMax(Patient.VOIs{i},dmins(i),dmaxs(i));
    end
return

function Patient = PatientApplyOptimization(Patient)
    % construct LP matrices
    A    = [];dmin = [];dmax = [];
    for i=1:Patient.NumVOIs
        A    = [A;Patient.VOIs{i}.ADose];
        dmin = [dmin;Patient.VOIs{i}.DoseMin];
        dmax = [dmax;Patient.VOIs{i}.DoseMax];
    end
    
    % compute optimal beam weights
    %%%Patient.xBeamWeights = OptimizeBeamsCPLEX(A,dmin,dmax);
    Patient.xBeamWeights = OptimizeBeamsADMM(A,dmin,dmax);
    
    % compute resulting dose on each VOI
    for i=1:Patient.NumVOIs
        Patient.VOIs{i} = VOIGetDose(Patient.VOIs{i},Patient.xBeamWeights);
    end
return

function PatientEvaluate(Patient)
    figure,stem(Patient.xBeamWeights),title('Beam Weights')
    figure,PatientPlotConstraints(Patient);
    figure,PatientPlotDVH(Patient);
return

function Patient = PatientRotateTranslate(Patient,Thetaxyz,Offset)
    for i=1:Patient.NumVOIs
        Patient.VOIs{i} = VOIRotateTranslate(Patient.VOIs{i},Thetaxyz,Offset);
    end
return

function Patient = PatientAffineTransform(Patient,A,b)
    for i=1:Patient.NumVOIs
        Patient.VOIs{i} = VOIAffineTransform(Patient.VOIs{i},A,b);
    end
return

function PatientPlot(Patient)
    hold on
    for i=1:Patient.NumVOIs
        VOIPlot(Patient.VOIs{i},Patient.AxLims);
    end
    title(Patient.Name),legend(Patient.VOINames)
    xlabel('x'),ylabel('y'),zlabel('z')
    view(127.5,30)
    %view(3)
return

function PatientPlotConstraints(Patient)
    nPlotsPerCol = ceil(Patient.NumVOIs/2);
    for i=1:Patient.NumVOIs
        subplot(nPlotsPerCol,2,i),VOIPlotMinMaxConstraints(Patient.VOIs{i});
    end
return

function PatientPlotDVH(Patient)
    hold on,title('DVHs'),grid on, axis([0,max(Patient.VOIs{1}.DVHBins),0,1.1])
    for i=1:Patient.NumVOIs
        [DVHi,Histi] = GetDVH(Patient.VOIs{i}.Dose,Patient.VOIs{i}.DVHBins);
        plot(Patient.VOIs{i}.DVHBins,DVHi,Patient.VOIs{i}.Color);
    end
    legend(Patient.VOINames)
return

function PlotPatientBeamDirectionsAndNodes(Patient,Beams)
    figure,hold on
    PatientPlot(Patient)
    PlotNodes(Beams.NodeLocs,Beams.NodesAxLims);
    PlotBeams(Beams.Tails0,Beams.Heads,1);
    figure,hold on
    PatientPlot(Patient)
    PlotBeams(Beams.Tails,Beams.Heads,1);
return

%====================================================
% VOI Class: has name etc, point cloud model, point cloud, dose matrix, dose specs
%====================================================
function VOI = VOICreate()
    VOI.Name          = [];
    VOI.Number        = [];
    VOI.Type          = [];
    VOI.Color         = [];
    VOI.LineStyle     = [];
    VOI.VoxSize       = [];
    VOI.SubSampFactor = [];
    VOI.Model         = [];
    VOI.PointCloud    = [];
    VOI.PointCloudBdy = [];
    VOI.ADose         = [];
    VOI.DoseMin       = [];
    VOI.DoseMax       = [];
    VOI.Dose          = [];
    VOI.DVHBins       = [];
return

function VOI = VOIInit(VOI,Name,Number,Type,Color,LineStyle,VoxSize,SubSampFactor,Model,HistBins)
    VOI.Name          = Name;
    VOI.Number        = Number;
    VOI.Type          = Type;
    VOI.Color         = Color;
    VOI.LineStyle     = LineStyle;
    VOI.VoxSize       = VoxSize;
    VOI.SubSampFactor = SubSampFactor;    
    VOI.Model         = Model;
    VOI.PointCloud    = ModelToPointCloud(Model,VoxSize,SubSampFactor);
    VOI.PointCloudBdy = ModelToPointCloudBdy(Model,VoxSize,SubSampFactor);
    VOI.ADose         = [];
    VOI.DoseMin       = [];
    VOI.DoseMax       = [];
    VOI.Dose          = [];
    VOI.DVHBins       = HistBins;
return

function VOI = VOIAffineTransform(VOI,A,b)
    VOI.Model         = ModelAffineTransform(VOI.Model,A,b);
    VOI.PointCloud    = PointCloudAffineTransform(VOI.PointCloud,A,b);
    VOI.PointCloudBdy = PointCloudAffineTransform(VOI.PointCloudBdy,A,b);
return

function VOI = VOIRotateTranslate(VOI,Thetaxyz,Offset)
    VOI.Model         = ModelRotateTranslate(VOI.Model,Thetaxyz,Offset);
    VOI.PointCloud    = PointCloudRotateTranslate(VOI.PointCloud,Thetaxyz,Offset);
    VOI.PointCloudBdy = PointCloudRotateTranslate(VOI.PointCloudBdy,Thetaxyz,Offset);
return

function VOIPlot(VOI,AxisLimits)
    Symbol = ['.',VOI.Color];
    PlotCloud(VOI.PointCloudBdy,Symbol,AxisLimits);
return

function VOI = VOIGetDoseAMatrix(VOI,Beams)
    if VOI.Type =='v' % full volume
        VOI.ADose = GetBeamDosageVectors8(Beams.Tails,Beams.Heads,Beams.Widths,VOI.PointCloud);
    else              % boundary shell
        VOI.ADose = GetBeamDosageVectors8(Beams.Tails,Beams.Heads,Beams.Widths,VOI.PointCloudBdy);
    end
    disp(['NPts-',VOI.Name,'=',num2str(size(VOI.ADose,1))])
return

function VOI = VOISetDoseMinMax(VOI,dmin,dmax)
    if VOI.Type =='v' % full volume
        NPtsVOI = size(VOI.PointCloud,1);
    else              % boundary shell
        NPtsVOI = size(VOI.PointCloudBdy,1);
    end
    VOI.DoseMin = dmin*ones(NPtsVOI,1);
    VOI.DoseMax = dmax*ones(NPtsVOI,1);
return

function VOI = VOIGetDose(VOI,xBeamWeights)
    VOI.Dose = VOI.ADose*xBeamWeights;
return

function VOIPlotMinMaxConstraints(VOI)
    nVox = length(VOI.DoseMin);
    vox  = 1:nVox;
    plot(vox,VOI.Dose,'*b',...
         vox,VOI.DoseMin,'--r',...
         vox,VOI.DoseMax,'--r')
    axis([0 nVox  0  1.2*max(VOI.DoseMax) ])
    legend(VOI.Name)
    xlabel('voxels'),ylabel('dose')
return

function [DVH,Hist] = GetDVH(DosageProfile,Bins);
    Hist = hist(DosageProfile,Bins);
    Hist = Hist/sum(Hist);
    HistCum = cumsum(Hist);
    DVH = 1-HistCum;
    DVH = [1;DVH(1:(length(DVH)-1))'];
return

%====================================================
% Beam Class: has beams, nodes, collimators, dose computation
%====================================================
function Beams = BeamsCreate()
    Beams.NodeLocs    = [];
    Beams.NodesAxLims = [];
    Beams.Collimators = [];
    Beams.NBeamlets   = [];
    Beams.Tails0= [];
    Beams.Tails = [];
    Beams.Heads = [];
    Beams.Widths= [];
    Beams.Nodes = []; 
return

function Beams = BeamsInit(Beams,NodeLocs,NodesAxLims,Collimators,NBeamlets,SkinModelf,BdyTarget)
    Beams.NodeLocs    = NodeLocs;
    Beams.NodesAxLims = NodesAxLims;
    Beams.Collimators = Collimators;
    Beams.NBeamlets   = NBeamlets;
    [BeamTails,BeamHeads,BeamTails0,BeamWidths,BeamNodes] = GetBeamDirections3(SkinModelf,BdyTarget,NodeLocs,Collimators,NBeamlets);
    Beams.Tails0= BeamTails0;
    Beams.Tails = BeamTails;
    Beams.Heads = BeamHeads;
    Beams.Widths= BeamWidths;
    Beams.Nodes = BeamNodes;     
return

function [BeamTails,BeamHeads,BeamTails0,BeamWidths,BeamNodes] = GetBeamDirections3(SkinModelf,BdyTarget,NodeLocs,Collimators,NBeamlets)
% compute candidate beam directions by firing from each Node, NBeamlets for each collimator size, onto random points on the target boundary
% also calculate the point of entry into the patient (skin) boundary
    NNodes = size(NodeLocs,1);
    NColls = length(Collimators);
    NBdyTar = size(BdyTarget,1);
    NBisections = 10;
    BeamTails0= zeros(NColls*NNodes*NBeamlets,3);
    BeamTails = zeros(NColls*NNodes*NBeamlets,3);
    BeamHeads = zeros(NColls*NNodes*NBeamlets,3);
    BeamWidths= zeros(NColls*NNodes*NBeamlets,1);
    BeamNodes = zeros(NColls*NNodes*NBeamlets,1);
    % for each node
    for i=1:NNodes
        % make that node the tail for all collimators and beamlets
        ii     = (i-1)*NColls*NBeamlets; 
        iiPlus = ii +  NColls*NBeamlets;
        BeamTails0(ii+1:iiPlus,:) = repmat(NodeLocs(i,:),NColls*NBeamlets,1);
        BeamNodes(ii+1:iiPlus,:)  = repmat(i,NColls*NBeamlets,1);
        % for each collimator size
        for j=1:NColls
            % get NBeamlets random heads on target boundary
            jj     = (j-1)*NBeamlets;
            jjPlus = jj  + NBeamlets;
            BeamHeads(ii+jj+1:ii+jjPlus,:) = BdyTarget(GetRandomIndecesNoRepetition(NBeamlets,NBdyTar),:);
            BeamWidths(ii+jj+1:ii+jjPlus,:)= repmat(Collimators(j),NBeamlets,1);
            % for each beamlet
            for k=1:NBeamlets
                % compute intersection with patient surface
                BeamTails(ii+jj+k,:) = IntersectionSegmentLevelset(SkinModelf,BeamTails0(ii+jj+k,:),BeamHeads(ii+jj+k,:),NBisections);
            end
        end
    end
return

function DosageVecs = GetBeamDosageVectors8(Tails,Heads,Widths,PointCloud)%,Collimators)
% compute beam dose matrix on the given PointCloud, and quantizes it to accuracy 1e-3
    NBeams     = size(Tails,1);
    NPts       = size(PointCloud,1);
    DosageVecs = zeros(NPts,NBeams);
    disp(['Computing fake beam dosage vectors...'])
    tic
    for j=1:NBeams
        BeamRadius = Widths(j)/2;
        [DistOnRay,DistToRay]   = ComputeDistancesOnAxisAndToAxis(PointCloud,Tails(j,:)',Heads(j,:)');
        [DistOnRaySelect,DistToRaySelect,SelectIdx] = SelectPositiveOnAxisFiniteOffAxis(DistOnRay,DistToRay);
        DosageVecs(SelectIdx,j) = ComputeFakeBeamRolloffAndDiffusion(DistOnRaySelect,DistToRaySelect,BeamRadius);
    end
    DosageVecs = 1e-3 * round(1e3*DosageVecs); % quantize to 1e-3 accuracy, anything smaller gets set to zero
    toc
return

function DoseVector = ComputeFakeBeamRolloffAndDiffusion(DistOnRay,DistToRay,BeamRadius,BeamDiffusionSigma)
% for single beam, compute fake dose vector as:
% - on-axis build-up then roll-off
% - radial diffusion that broadens a bit with distance along beam direction
    if nargin < 4, BeamDiffusionSigma = 0.2;end
    % [build up then roll off] .* [convolve(rect_aperture,gaussian) = difference of erf's]
    DoseVector =  (DistOnRay+0.02).^(1/8) .* exp(-(DistOnRay+0.02)/15).*... 
                  (  erf( (DistToRay+BeamRadius)./(BeamDiffusionSigma*(1+0.025*DistOnRay)) ) - ... 
                     erf( (DistToRay-BeamRadius)./(BeamDiffusionSigma*(1+0.025*DistOnRay)) )   );
return

function [DistOnRay,DistToRay] = ComputeDistancesOnAxisAndToAxis(PointCloud,tail,head)
% vectorized computation of cylindrical coordinates along beam direction, for all points in VOI PointCloud,
% used for calculation of VOI dose vector
    NPts        = size(PointCloud,1);
    x0              = tail;
    u0              = ComputeUnitVector(head,tail);
    PointCloudShift = PointCloud-repmat(x0',NPts,1);            
    DistOnRay       = PointCloudShift*u0;
    DistToRay       = sqrt( sum(  (PointCloudShift - DistOnRay*u0').^2  ,2)  );
return

function [DistOnRaySelect,DistToRaySelect,SelectIdx] = SelectPositiveOnAxisFiniteOffAxis(DistOnRay,DistToRay)
% keep only points in the positive direction of the beam from the tail0 and
% with distance no more than 5cm from the axis (since largest collimator is 6cm diameter = 3cm radius)
    SelectIdx       = find( (DistOnRay > 0) & (DistToRay <=5) );
    DistOnRaySelect = DistOnRay(SelectIdx);
    DistToRaySelect = DistToRay(SelectIdx);
return

function u = ComputeUnitVector(head,tail)
    u = (head-tail);
    u = u/norm(u);
return

function IndexRand = GetRandomIndecesNoRepetition(NumSamples,NumTotal)
% gets NumSamples random indexes from index set {1,...,NumTotal}, with no repetition
    IndexPerm = randperm(NumTotal);
    IndexRand = IndexPerm(1:NumSamples);
return

function PointOfInt = IntersectionSegmentLevelset(LevelSetf,tail,head,NBisections)
% finds approximate intersection of segment with levelset of f using bisection
% assumes head is inside level set and tail is outside; crashes if not.
    if LevelSetf(tail(:)) <=1, error('tail already inside sublevel set!'),end
    if LevelSetf(head(:)) > 1, error('head is not inside sublevel set!'),end
    for r=1:NBisections
        PointOfInt = 0.5*(tail+head);
        % if PointOfInt inside the 1-level set
        if LevelSetf(PointOfInt(:)) <=1 
            head = PointOfInt; % move away from target
        else
            tail = PointOfInt; % move toward target
        end
    end
return

function PlotDoseMapAxialRolloffAndRadialDiffusion(Collimators)
% plot first the roll off of beam intensity along the center of a beam
% then plot a matrix of plots showing the roll off from the axis for all collimators
    BeamRadius  = 0.75/2;
    DistOnRay=0:0.1:50;
    DistToRay=0;
    DoseVector = ComputeFakeBeamRolloffAndDiffusion(DistOnRay,DistToRay,BeamRadius);
    figure
    plot(DistOnRay,DoseVector),grid
    title('On axis beam roll off')
    xlabel('on axis distance [cm]'),ylabel('normalized intensity')

    DistOnRay=0:5:40;
    DistToRay=0:0.1:8;
    NColl = length(Collimators);
    figure, 
    for j=1:NColl
        Collj = Collimators(j);
        subplot(4,3,j)
        hold on
        for i=1:length(DistOnRay)
            DoseVector = ComputeFakeBeamRolloffAndDiffusion(DistOnRay(i),DistToRay,Collj/2);
            plot(DistToRay,DoseVector), grid on
        end
        title(['Radial roll off ',num2str(Collj/2),'cm radius beam'])
        xlabel('off axis distance [cm]'),ylabel('normalized intensity')
    end
return

function PlotBeams(BeamTails,BeamHeads,LineWidth)
% plots dotted lines as the directions of the beams (not the full dose vectors)
    if nargin<3, LineWidth=4; end
    for i=1:size(BeamTails,1)
        h = plot3([BeamTails(i,1);BeamHeads(i,1)],...
              [BeamTails(i,2);BeamHeads(i,2)],...
              [BeamTails(i,3);BeamHeads(i,3)]);
        %set(h,'LineWidth',4);
        set(h,'LineWidth',LineWidth,'LineStyle',':');
    end
return

function PlotFewRandomBeamDoseMaps(Tails,Heads,Widths,nBeamsToPlot,GridPts)
% plot few random beams over the points GridPts - rarely do more than 3-5 
% beams because can be really slow for a 100x100x100 grid
    NBeams      = length(Widths);
    Select      = GetRandomIndecesNoRepetition(nBeamsToPlot,NBeams);
    TailsSelect = Tails(Select,:);
    HeadsSelect = Heads(Select,:);
    WidthsSelect= Widths(Select,:)
    DosageVecs  = GetBeamDosageVectors8(TailsSelect,HeadsSelect,WidthsSelect,GridPts);
    DosageVecsThresh = 0.01;
    PlotDosageVecs2(DosageVecs,GridPts,DosageVecsThresh);
return

function PlotDosageVecs2(DosageVecs,GridPts,DosageVecsThresh)
% plot the DosageVecs on the grid GridPoints, plotting only values greater
% than DosageVecsThresh
    if nargin < 3, DosageVecsThresh = 0;end
    NDosageVecs = size(DosageVecs,2);
    disp(['Plotting beam dosage vectors...'])
    for j=1:NDosageVecs
        iThresh = find(DosageVecs(:,j) > DosageVecsThresh);
        scatter3(GridPts(iThresh,1),GridPts(iThresh,2),GridPts(iThresh,3),3,DosageVecs(iThresh,j),'filled');
    end
return

function PlotNodes(NodeLocs,NodesAxLims)
    hold on
    plot3(NodeLocs(:,1),NodeLocs(:,2),NodeLocs(:,3),'r.'), grid on
    xlabel('x'),ylabel('y'),zlabel('z')
    axis(NodesAxLims)
    %view(3)
return

%====================================================
% Model Class: for generating point clouds as sublevel sets of scaled/shifted p-norms (1 < p < Inf)
%====================================================
function Model = ModelCreate()
    Model.f = [];
    Model.fGrad    = [];
    Model.AxLims = [];
return

function Model = ModelInit(Model,xyzScale,p)
    A            = diag(1./xyzScale);
    Model.f      = @(x) norm(A*x,p); % scaled p-norm (where 1 < p < Inf)
    Model.fGrad  = @(x) A*(sum((A*x).^p))^((1/p)-1)*(A*x).^(p-1); % grad of scaled p-norm
    Model.AxLims = [xyzScale(1)*[-1 1] xyzScale(2)*[-1 1] xyzScale(3)*[-1 1]]; % range for plotting
return

function PointCloud = ModelToPointCloud(Model,VoxSize,SubSampFactor)
    PointCloud = PointCloudFromf(Model.f,Model.AxLims,VoxSize);
return

function PointCloudBdy = ModelToPointCloudBdy(Model,VoxSize,SubSampFactor)
    PointCloud    = PointCloudFromf(Model.f,Model.AxLims,VoxSize);
    PointCloudBdy = PointCloudBdyFromfAndfGrad(Model.f,Model.fGrad,PointCloud,VoxSize,SubSampFactor);
return

function Model = ModelRotateTranslate(Model,Thetaxyz,Offset)
    RotMtx = AnglesToRotMtx(Thetaxyz);
    Model  = ModelAffineTransform(Model,RotMtx,Offset);
return

function Model = ModelAffineTransform(Model,A,b)
    Model.f      = fAffineTransform(Model.f,A,b);
    Model.fGrad  = fGradAffineTransform(Model.fGrad,A,b);
    Model.AxLims = AxLimsAffineTransform(Model.AxLims,A,b);
return

%====================================================
% Point Cloud 3D geometry stuff
%====================================================
function [GridPts,AxPts] = GetGridPts(NPtsPerAx,AxLength)
    %AxPts = linspace(0,AxLength,NPtsPerAx);
    AxPts = linspace(-AxLength,AxLength,NPtsPerAx);
    [X,Y,Z] = meshgrid(AxPts,AxPts,AxPts);
    GridPts = [X(:),Y(:),Z(:)];
return

function [Cloud,nPtsCloud] = PointCloudFromf(f,AxLim,VoxSize)
% returns point cloud of 1-sublevel set of f, sampled over a box specified
% by AxLim, with granularity VoxSize
    xMin=AxLim(1);xMax=AxLim(2);yMin=AxLim(3);yMax=AxLim(4);zMin=AxLim(5);zMax=AxLim(6);
    [X,Y,Z] = meshgrid([xMin:VoxSize:xMax],[yMin:VoxSize:yMax],[zMin:VoxSize:zMax]);
    GridPts = [X(:),Y(:),Z(:)];
    nPts    = size(GridPts,1);
    InOrOut = zeros(nPts,1);
    for i=1:nPts
        InOrOut(i) = ( f(GridPts(i,:)') <= 1);
    end
    IndexCloudPts = find(InOrOut > 0);
    Cloud         = GridPts(IndexCloudPts,:);
    nPtsCloud     = length(IndexCloudPts);
return

function [CloudBdy,nPtsCloudBdy] = PointCloudBdyFromfAndfGrad(f,fGrad,Cloud,VoxSize,SubSampFactor)
% returns boundary points of point cloud of 1-sublevel set of f, 
% assumed to be differentiable with gradient fGrad, also assumed
% be computed with granularity VoxSize, and will be downsampled by factor SubSampFactor
    if nargin < 4, VoxSize = 0.1;end
    if nargin < 5, SubSampFactor = 1; end
    n       = size(Cloud,1);
    InOrOut = zeros(n,1);
    for i=1:SubSampFactor:n
        xi = Cloud(i,:)';
        InOrOut(i) = ( abs(f(xi)-1)  <=  norm(fGrad(xi))*VoxSize );% point on shell
    end
    IndexBdyPts = find( InOrOut > 0 );
    CloudBdy    = Cloud(IndexBdyPts,:);
    nPtsCloudBdy= size(CloudBdy,1);
return

function f = fAffineTransform(f,A,b)
% update f so that its 1-sublevel set S is transformed to A*S+b
    AInv = inv(A);
    f = @(x) f(AInv*(x-b));
return

function fGrad = fGradAffineTransform(fGrad,A,b)
% update fGrad to correspond to the f whose 1-sublevel set S is transformed to A*S+b
    AInv = inv(A);
    fGrad = @(x) AInv'*fGrad(AInv*(x-b));
return

function AxLims = AxLimsAffineTransform(AxLims,A,b)
    Vertices = AxLimsToVertices(AxLims);
    Vertices = PointCloudAffineTransform(Vertices,A,b);
    AxLims   = AxLimsFromVertices(Vertices);
return

function AxLims = AxLimsFromVertices(Vertices)
% computes box around set of Vertices sorted row-wise [x1';x2';...;xN'];
    Dimensions = size(Vertices,2);
    AxLims = zeros(1,2*Dimensions);
    for i=1:Dimensions
        AxLims(2*i)  = max(Vertices(:,i));
        AxLims(2*i-1)= min(Vertices(:,i));
    end
return

function Vertices = AxLimsToVertices(AxLims)
    Vertices = GenerateVertices([],0,AxLims);
return

function V = GenerateVertices(V,i,AxLims)
% computes Vertices sorted row-wise [x1';x2';...;xN'] from Matlab axis limits AxLims, 
% via recursively doubling up the coordinates matrix, backwards from N to 1,
% adding new coordinate column each step.
    n = length(AxLims)/2;
    i = i+1;
    if i <= n
        V = [AxLims(2*(n-i+1))  *ones(2^(i-1),1),V;
             AxLims(2*(n-i+1)-1)*ones(2^(i-1),1),V];
        V = GenerateVertices(V,i,AxLims);
    else
        V = V;
    end
return

function Cloud = PointCloudAffineTransform(Cloud,A,b)
% Apply A*x+b to each point in Cloud
% Assumes points stored in Cloud row-wise [x1';x2';...;xN'];
    nPtsCloud = size(Cloud,1);
    Cloud     = Cloud*A' + repmat(b(:)',nPtsCloud,1);
return

function Cloud = PointCloudRotateTranslate(Cloud,Thetaxyz,Offset)
% Apply rotation (Thetaxyz) and Offset to each point in Cloud
% Assumes points stored in Cloud row-wise [x1';x2';...;xN'];
    RotMtx = AnglesToRotMtx(Thetaxyz);
    Cloud = PointCloudAffineTransform(Cloud,RotMtx,Offset(:));
return


function [RotMtx,Rx,Ry,Rz] = AnglesToRotMtx(Thetaxyz)
% Rotation about x, y, and z axes - in that order!
    cx = cos(Thetaxyz(1)); sx = sin(Thetaxyz(1));
    cy = cos(Thetaxyz(2)); sy = sin(Thetaxyz(2));
    cz = cos(Thetaxyz(3)); sz = sin(Thetaxyz(3));
    Rx  = [1    0   0;
           0    cx -sx;
           0    sx  cx];
    Ry  = [cy   0   sy;
           0    1   0;
          -sy   0   cy];
    Rz  = [cz  -sz  0;
           sz   cz  0;
           0    0   1];
    RotMtx = Rz*Ry*Rx;
return

function PlotCloud(CloudGridPts,Symbol,AxPts)
    plot3(CloudGridPts(:,1),CloudGridPts(:,2),CloudGridPts(:,3),Symbol);
    AxMin = min(AxPts); AxMax = max(AxPts);
    axis([AxMin,AxMax,AxMin,AxMax,AxMin,AxMax])
    grid on
return

function Points = GetPointsOnUnitSphere1000(N)
% get evenly distributed 1000 points on UNIT sphere
% taken off the web
    if nargin <1
        N=14;
    end
    Beta = 0.5*pi/N;
    Points = [];
    % line segment length
    A = 2*sin(Beta/2);
    % endcap
    Points = [Points;[0 0 1]];
    Points = [Points;[0 0 -1]];
    % rings
    for i=1:N
      R = sin(i*Beta);
      Z = cos(i*Beta);
      M = round(R*2*pi/A);
      for j=0:M-1
          Alpha = j/M * 2 * pi;
          X = cos(Alpha)*R;
          Y = sin(Alpha)*R;
          Points = [Points;[X Y Z]];
          if i~=N
              Points = [Points;[X Y -Z]];
          end
      end
    end
return

%====================================================
% Optimization functions: CPLEX and ADMM
%====================================================
function xBmWtsStar = OptimizeBeamsCPLEX(AAll,dMin,dMax);
% solve using CPLEX
%        minimize   sum pos(d - dmax)  + sum pos(dmin - d)
%        such that  A x =  d
%                     x >= 0
% where pos(x) is the positive part of x, taken componentwise
%         pos(x) = max(x,0) 
%
    NVoxAll  = size(AAll,1)
    NBeams   = size(AAll,2)
    INVoxAll = speye(NVoxAll);
    ZNVoxAll = sparse(NVoxAll,NVoxAll);
    ZNVoxAllNBeams = sparse(NVoxAll,NBeams);
    AEq = [AAll, -INVoxAll, ZNVoxAll];
    AEq = sparse(AEq);
    bEq = [zeros(NVoxAll,1)];
    AIneq = [ZNVoxAllNBeams, -INVoxAll, -INVoxAll; 
             ZNVoxAllNBeams,  INVoxAll, -INVoxAll];
    AIneq = sparse(AIneq);
    bIneq = [-dMin;dMax];
    lb = zeros(NBeams+NVoxAll+NVoxAll,1);
    ub = [300*ones(NBeams,1);1e6*ones(2*NVoxAll,1)];
    cLP = [zeros(NBeams,1);zeros(NVoxAll,1);ones(NVoxAll,1)];
    disp('Solving optimization with CPLEX ...')
    tic
    options = cplexoptimset('Simplex','on');
    [xStar,Obj,exitflag,output,lambda] = ...
    cplexlp(cLP',AIneq,bIneq,AEq,bEq,lb,ub,[],options); %, x0);
    exitflag = exitflag
    xBmWtsStar = xStar(1:NBeams);
    fstar = Obj
    toc
return

function xBmWtsStar = OptimizeBeamsADMM(AAll,dMin,dMax);
% solve using ADMM following Stanford EE364b final exam problem (Boyd&Chu)
%        minimize   sum pos(d - dmax)  + sum pos(dmin - d)
%        such that  A x =  d
%                     x >= 0
% where pos(x) is the positive part of x, taken componentwise
%         pos(x) = max(x,0) 
%
    tic
    disp(' ')
    NVoxAll  = size(AAll,1)
    NBeams   = size(AAll,2)
    disp('doing ADMM as in EE364b 2011 Final (Stephen Boyd, Eric Chu)')
    disp('computing pseudo-inverse of [A;I]...')
    tic
    AAllI    = [AAll;eye(NBeams)];
    %AAllIPinv = pinv(AAllI);
    Delta = pinv(speye(NBeams)+AAll'*AAll);
    save('Delta','Delta');
    %load Delta
    toc
    ud  = zeros(NVoxAll,1);
    ux  = zeros(NBeams,1);
    dose = zeros(NVoxAll,1);
    xBm  = zeros(NBeams,1);
    z    = zeros(NBeams,1);
    zOld = z;
    disp('doing ADMM iterations')
    MaxIters = 300
    rho     = 1.25;%0.5
    mu      = 10;%1.5
    tauIncr = 2;%1.1
    tauDecr = 1/tauIncr;
    rNorm = zeros(MaxIters,1);
    sNorm = zeros(MaxIters,1);
    rhos  = zeros(MaxIters,1);
    for i=1:MaxIters
                
        % do ADMM update
        AAllzOld = AAll*zOld;
        dose = DoubleHingeProx(dMin,dMax,rho,AAllzOld-(ud/rho));
        xBm  = min(max(z-(ux/rho),0),300);
        z    = Delta*(  AAll'*(dose+(ud/rho))  +  (xBm+(ux/rho))  );
        AAllz= AAll*z;
        ux   = ux + rho*(xBm-z);
        ud   = ud + rho*(dose-AAllz);
        
        % compute primal and dual residuals for stopping criterion and rho updating
        r        = [dose;xBm] - [AAllz;z];
        s        = rho*([AAllz-AAllzOld;z-zOld]);
        rNorm(i) = norm(r,2);
        sNorm(i) = norm(s,2);
        
        % update z
        zOld = z;
        
        % "adaptive" rho update (doesn't always work ==> safer to switch off)
        rhos(i) = rho;
%         if     (rNorm(i) > mu*sNorm(i))
%             rho = tauIncr*rho
%         elseif (rNorm(i) < (1/mu)*sNorm(i))
%             rho = tauDecr*rho
%         end

    end
    disp('done!')
    xBmWtsStar = xBm;
    toc

    figure
    subplot(3,1,1),plot(1:MaxIters,log10(rNorm)),grid,ylabel('log10(rNorm)')
    subplot(3,1,2),plot(1:MaxIters,log10(sNorm)),grid,ylabel('log10(sNorm)')
    subplot(3,1,3),plot(1:MaxIters,log10(rhos)),grid,ylabel('log10(rho)')
return

function xProx = DoubleHingeProx(aa,bb,rho,x)
    if min(bb-aa)<0, error('xMin > xMax!'),end
    xProx = 1/rho + x - max(x-(aa-1/rho),0) + max(x-aa,0) - max(x-bb,0) + max(x-(bb+1/rho),0);
return

function xProx = DoubleHingeProx2(aa,bb,rho,x)
    if min(bb-aa)<0, error('xMin > xMax!'),end
    xTemp = SoftThresh(1/2/rho,x-(aa-1/2/rho)) + aa;
    xProx = SoftThresh(1/2/rho,xTemp-(bb+1/2/rho))+bb;
return
    
function xST = SoftThresh(k,x)
    if min(k) <= 0, error('k <=0'),end
    xST = max(x-k,0) - max(-x-k,0);
return

function y = DoubleHinge(xMin,xMax,x)
    if min(xMax-xMin)<0, error('xMin > xMax!'),end
    y = max(xMin-x,0) + max(x-xMax,0);
return