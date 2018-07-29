function [skeleton,time] = loadbvh(fname)
%% LOADBVH  Load a .bvh (Biovision) file.
%
% Loads BVH file specified by FNAME (with or without .bvh extension)
% and parses the file, calculating joint kinematics and storing the
% output in SKELETON.
%
% Some details on the BVH file structure are given in "Motion Capture File
% Formats Explained": http://www.dcs.shef.ac.uk/intranet/research/resmes/CS0111.pdf
% But most of it is fairly self-evident.

%% Load and parse header data
%
% The file is opened for reading, primarily to extract the header data (see
% next section). However, I don't know how to ask Matlab to read only up
% until the line "MOTION", so we're being a bit inefficient here and
% loading the entire file into memory. Oh well.

% add a file extension if necessary:
if ~strncmpi(fliplr(fname),'hvb.',4)
    fname = [fname,'.bvh'];
end

fid = fopen(fname);
C = textscan(fid,'%s');
fclose(fid);
C = C{1};


%% Parse data
%
% This is a cheap tokeniser, not particularly clever.
% Iterate word-by-word, counting braces and extracting data.

% Initialise:
skeleton = [];
ii = 1;
nn = 0;
brace_count = 1;

while ~strcmp( C{ii} , 'MOTION' )
    
    ii = ii+1;
    token = C{ii};
    
    if strcmp( token , '{' )
        
        brace_count = brace_count + 1;
        
    elseif strcmp( token , '}' )
        
        brace_count = brace_count - 1;
        
    elseif strcmp( token , 'OFFSET' )
        
        skeleton(nn).offsetFromParent = [str2double(C(ii+1)) ; str2double(C(ii+2)) ; str2double(C(ii+3))];
        ii = ii+3;
        
    elseif strcmp( token , 'CHANNELS' )
        
        skeleton(nn).Nchannels = str2double(C(ii+1));
        
        % The 'order' field is an index corresponding to the order of 'X' 'Y' 'Z'.
        % Subtract 87 because char numbers "X" == 88, "Y" == 89, "Z" == 90.
        if skeleton(nn).Nchannels == 3
            skeleton(nn).order = [C{ii+2}(1),C{ii+3}(1),C{ii+4}(1)]-87;
        elseif skeleton(nn).Nchannels == 6
            skeleton(nn).order = [C{ii+5}(1),C{ii+6}(1),C{ii+7}(1)]-87;
        else
            error('Not sure how to handle not (3 or 6) number of channels.')
        end
        
        if ~all(sort(skeleton(nn).order)==[1 2 3])
            error('Cannot read channels order correctly. Should be some permutation of [''X'' ''Y'' ''Z''].')
        end
        
        ii = ii + skeleton(nn).Nchannels + 1;
        
    elseif strcmp( token , 'JOINT' ) || strcmp( token , 'ROOT' )
        % Regular joint
        
        nn = nn+1;
        
        skeleton(nn).name = C{ii+1};
        skeleton(nn).nestdepth = brace_count;
        
        if brace_count == 1
            % root node
            skeleton(nn).parent = 0;
        elseif skeleton(nn-1).nestdepth + 1 == brace_count;
            % if I am a child, the previous node is my parent:
            skeleton(nn).parent = nn-1;
        else
            % if not, what is the node corresponding to this brace count?
            prev_parent = skeleton(nn-1).parent;
            while skeleton(prev_parent).nestdepth+1 ~= brace_count
                prev_parent = skeleton(prev_parent).parent;
            end
            skeleton(nn).parent = prev_parent;
        end
        
        ii = ii+1;
        
    elseif strcmp( [C{ii},' ',C{ii+1}] , 'End Site' )
        % End effector; unnamed terminating joint
        %
        % N.B. The "two word" token here is why we don't use a switch statement
        % for this code.
        
        nn = nn+1;
        
        skeleton(nn).name = ' ';
        skeleton(nn).offsetFromParent = [str2double(C(ii+4)) ; str2double(C(ii+5)) ; str2double(C(ii+6))];
        skeleton(nn).parent = nn-1; % always the direct child
        skeleton(nn).nestdepth = brace_count;
        skeleton(nn).Nchannels = 0;
        
    end
    
end

%% Initial processing and error checking

Nnodes = numel(skeleton);
Nchannels = sum([skeleton.Nchannels]);
Nchainends = sum([skeleton.Nchannels]==0);

% Calculate number of header lines:
%  - 5 lines per joint
%  - 4 lines per chain end
%  - 4 additional lines (first one and last three)
Nheaderlines = (Nnodes-Nchainends)*5 + Nchainends*4 + 4;

rawdata = importdata(fname,' ',Nheaderlines);

index = strncmp(rawdata.textdata,'Frames:',7);
Nframes = sscanf(rawdata.textdata{index},'Frames: %f');

index = strncmp(rawdata.textdata,'Frame Time:',10);
frame_time = sscanf(rawdata.textdata{index},'Frame Time: %f');

time = frame_time*(0:Nframes-1);

if size(rawdata.data,2) ~= Nchannels
    error('Error reading BVH file: channels count does not match.')
end

if size(rawdata.data,1) ~= Nframes
    warning('LOADBVH:frames_wrong','Error reading BVH file: frames count does not match; continuing anyway.')
end

%% Load motion data into skeleton structure
%
% We have three possibilities for each node we come across:
% (a) a root node that has displacements already defined,
%     for which the transformation matrix can be directly calculated;
% (b) a joint node, for which the transformation matrix must be calculated
%     from the previous points in the chain; and
% (c) an end effector, which only has displacement to calculate from the
%     previous node's transformation matrix and the offsetFromParent of the end
%     joint.
%
% These are indicated in the skeleton structure, respectively, by having
% six, three, and zero "channels" of data.
% In this section of the code, the channels are read in where appropriate
% and the relevant arrays are pre-initialised for the subsequent calcs.

channel_count = 0;

for nn = 1:Nnodes
    
    if skeleton(nn).parent
        skeleton(nn).head0 = skeleton(nn).offsetFromParent + skeleton(skeleton(nn).parent).head0; 
    else
        skeleton(nn).head0 = skeleton(nn).offsetFromParent; % Root Node has a global position
    end
    
    
    if skeleton(nn).Nchannels == 6 % root node 
        %NOTE: this might be the source of a bug. Although in typical
        %situations the only element that has 6 channels is the root there
        %are in fact cases where other bones also have 6 channels.
        %Specifically cases where the children are offset.
        % None of the code in this file takes this case into account
        % and so the hope is that even if there are offsets that the actual
        % skeleton stays the same throughout which would mean
        % that the xyz part of the 6 channels has no additional meaning and
        % can be ingored (which is what is done in this file...)
        
        
        % assume translational data is always ordered XYZ
        % The following is ONLY relevant for the rootnode and will be
        % overwritten later on for other nodes with 6 channels
        skeleton(nn).t_xyz = repmat(skeleton(nn).offsetFromParent,[1 Nframes]) + rawdata.data(:,channel_count+[1 2 3])';
        
        %This is valid for all 6 channel nodes
        skeleton(nn).R_xyz(skeleton(nn).order,:) = rawdata.data(:,channel_count+[4 5 6])';
        
        % Kinematics of the root element (will be overwritten for other
        % nodes with 6 channels)
        skeleton(nn).T = nan(4,4,Nframes);
        for ff = 1:Nframes
            skeleton(nn).T(:,:,ff) = transformation_matrix(skeleton(nn).t_xyz(:,ff) , skeleton(nn).R_xyz(:,ff) , skeleton(nn).order);
        end
        
    elseif skeleton(nn).Nchannels == 3 % joint node
        
        skeleton(nn).R_xyz(skeleton(nn).order,:) = rawdata.data(:,channel_count+[1 2 3])';
        skeleton(nn).t_xyz  = nan(3,Nframes);
        skeleton(nn).T = nan(4,4,Nframes);
        
    elseif skeleton(nn).Nchannels == 0 % end node
        skeleton(nn).t_xyz  = nan(3,Nframes);
    end
    
    channel_count = channel_count + skeleton(nn).Nchannels;
    
    skeleton(nn).children = [];
end

for nn = 1:Nnodes
    if skeleton(nn).parent
        skeleton(skeleton(nn).parent).children = [skeleton(skeleton(nn).parent).children nn];
    end
end

for nn = 1:Nnodes
    if skeleton(nn).Nchannels % then it has children
        skeleton(nn).tail0 = mean([skeleton(skeleton(nn).children).head0]',1)';
    end
end

for nn=1:Nnodes    

    if skeleton(nn).Nchannels
        yvec = skeleton(nn).tail0' - skeleton(nn).head0';
        zvec = [0 0 1];
        xvec = cross(yvec,zvec);
        zvec = cross(xvec,yvec);
        skeleton(nn).R0 = [xvec'/norm(xvec) yvec'/norm(yvec) zvec'/norm(zvec)];
    else
        skeleton(nn).R0 = eye(3)'
    end
end


%% Calculate kinematics
%
% No calculations are required for the root nodes.

% For each joint, calculate the transformation matrix and for convenience
% extract each position in a separate vector.
for nn = find([skeleton.parent] ~= 0 & [skeleton.Nchannels] ~= 0)
    
    parent = skeleton(nn).parent;
    
    for ff = 1:Nframes
        transM = transformation_matrix( skeleton(nn).offsetFromParent , skeleton(nn).R_xyz(:,ff) , skeleton(nn).order );
        skeleton(nn).T(:,:,ff) = skeleton(parent).T(:,:,ff) * transM;
        skeleton(nn).t_xyz(:,ff) = skeleton(nn).T([1 2 3],4,ff);
    end
    
    % In the above trans calculation the angles are relative to the base
    % rotations which means that if we multiply 
    % Thus the following gives a Rotation matrix whose columns point along the local bone
    % axes : sk(i).T(1:3,1:3,j)*sk(i).R0
    
    
end

% For an end effector we don't have rotation data;
% just need to calculate the final position.
for nn = find([skeleton.Nchannels] == 0)
    
    parent = skeleton(nn).parent;
    
    for ff = 1:Nframes
        transM = skeleton(parent).T(:,:,ff) * [eye(3), skeleton(nn).offsetFromParent; 0 0 0 1];
        skeleton(nn).t_xyz(:,ff) = transM([1 2 3],4);
    end
    
end

end



function transM = transformation_matrix(displ,rxyz,order)
% Constructs the transformation for given displacement, DISPL, and
% rotations RXYZ. The vector RYXZ is of length three corresponding to
% rotations around the X, Y, Z axes.
%
% The third input, ORDER, is a vector indicating which order to apply
% the planar rotations. E.g., [3 1 2] refers applying rotations RXYZ
% around Z first, then X, then Y.
%
% Years ago we benchmarked that multiplying the separate rotation matrices
% was more efficient than pre-calculating the final rotation matrix
% symbolically, so we don't "optimise" by having a hard-coded rotation
% matrix for, say, 'ZXY' which seems more common in BVH files.
% Should revisit this assumption one day.
%
% Precalculating the cosines and sines saves around 38% in execution time.

c = cosd(rxyz);
s = sind(rxyz);

RxRyRz(:,:,1) = [1 0 0; 0 c(1) -s(1); 0 s(1) c(1)];
RxRyRz(:,:,2) = [c(2) 0 s(2); 0 1 0; -s(2) 0 c(2)];
RxRyRz(:,:,3) = [c(3) -s(3) 0; s(3) c(3) 0; 0 0 1];

rotM = RxRyRz(:,:,order(1))*RxRyRz(:,:,order(2))*RxRyRz(:,:,order(3));

transM = [rotM, displ; 0 0 0 1];

end