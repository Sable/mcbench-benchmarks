%% GENERATE SYNTHETIC MICROSTRUCTURE
% This code was modified so that the user can hard input the aspect ratio
% values, a and b, to keep the particle size consistent with volume
% fraction.

% First, clear all variables.

clear all; clc;

% Initialize variables
Vf = 0; 
nparticles = 0;
reject = 0;
noverlap = 0;

%% Input Microstructure Parameters

exit_loop_flag = 1;
while exit_loop_flag

    % Set Microstructure Parameters
    % ------------------------------------------
    % Enter the microstructure parameters that will be needed for the remainder
    % of the code, i.e., the area fraction of particles, the number of
    % particles, the size of the pixelated image, etc.
    prompt={'Volume fraction of particles: ',...
        'a0: ', 'b0: ', ...
        'Image Size: ' };
    name = 'Synthetic Microstructure Generator';
    numlines=1; defaultanswer={'0.05', '16', '16', '2048'};
    options.Resize='on'; options.WindowStyle='normal'; options.Interpreter='tex';
    answer=inputdlg(prompt,name,numlines,defaultanswer,options);

    Vf_max = str2double(answer(1));
    a0 = str2double(answer(2));
    b0 = str2double(answer(3));
    image_size = str2double(answer(4));

    if a0 < b0, c0 = a0; a0 = b0; b0 = c0; clear c0; end
    
    % Accept/Reject
    % -------------
    % Check to make sure that the particle is sufficiently resolved
    I_ellipse = image_ellipse(a0, b0, 0);
    figure(1), imshow(I_ellipse,[])
    button = questdlg('Is the particle size ok?','Question');
    if length(strfind(button,'Yes')) == 1
        exit_loop_flag1 = 1;
    else
        exit_loop_flag1 = 0;
    end
    close(1)

    % Is number of particles ok?
    if exit_loop_flag1
        N = ceil(image_size^2*Vf_max/sum(I_ellipse(:)));
        ratio = a0/b0; % a/b ratio
        diam = b0;
        button = questdlg({['Number of particles: ', num2str(N)];'Is number of particles ok?'},'Question');
        if length(strfind(button,'Yes')) == 1
            exit_loop_flag = 0;
        end        
    end
end


%% Select Particle Size Distribution

button = questdlg({'Use a lognormal distribution?'},'Question');
if length(strfind(button,'Yes')) == 1
    exit_loop_flag1 = 1;
    while exit_loop_flag1
        prompt={'Mean: ', 'Sigma: ', 'Increments: ' };
        name = 'Lognormal Distribution Parameters';
        numlines=1; defaultanswer={'1', '0.25', '25'};
        options.Resize='on'; options.WindowStyle='normal'; options.Interpreter='tex';
        answer=inputdlg(prompt,name,numlines,defaultanswer,options);
        mean = str2double(answer(1));
        sigma = str2double(answer(2));
        increments = str2double(answer(3));

        [List,f1,x] = find_lognormal_distribution(N,mean,sigma,increments);

        Area = sum(pi/ratio*(List(:,1)).^2);
        List = List * sqrt( Vf_max * image_size^2 / Area);
        x = x * sqrt( Vf_max * image_size^2 / Area);
        
        figure(1), hist(List,x);hold on;plot(x,f1,'-or');
        button = questdlg('Is the distribution ok?','Question');
        if length(strfind(button,'Yes')) == 1
            exit_loop_flag1 = 0;
            Area = sum(pi/ratio*(List(:,1)).^2);
            List = List * sqrt( Vf_max * image_size^2 / Area);
            List(:,2) = List(:,1)/ratio;
            List = ceil(List);
            List = sort(List,1,'descend');
            diam = List(end,2);
        end
        close(1)
    end    
else
    N = round(1.15 * N); % Just in case, 15% cushion in particles
    List(1:N,1) = a0; List(1:N,2) = b0;
end        

%% Select Particle Orientation Distribution

% Construct a questdlg with three options
choice = questdlg('How should particles be oriented:', ...
	'Particle Orientation', ...
	'Aligned','Random','Normal Distribution','Aligned');
% Handle response
switch choice
    case 'Aligned'
        theta_flag = 0;
    case 'Random'
        theta_flag = 1;
    case 'Normal Distribution'
        theta_flag = 2;
end

if theta_flag == 0
    options.Resize='on'; options.WindowStyle='normal'; options.Interpreter='tex';
    answer=inputdlg('Orientation (degrees)','Particle Orientation',1,{'90'},options);
    theta0 = str2double(answer(1))*pi/180;
    Theta_List(1:N) = theta0;
elseif theta_flag == 1
    Theta_List = linspace(0,pi,N+1);
    Theta_List(N+1) = [];
elseif theta_flag == 2
    exit_loop_flag1 = 1;
    while exit_loop_flag1
        prompt={'Mean (degrees): ', 'Sigma (degrees): ', 'Increments: ' };
        name = 'Normal Distribution Parameters';
        numlines=1; defaultanswer={'90', '10', '25'};
        options.Resize='on'; options.WindowStyle='normal'; options.Interpreter='tex';
        answer=inputdlg(prompt,name,numlines,defaultanswer,options);
        mean = str2double(answer(1));
        sigma = str2double(answer(2));
        increments = str2double(answer(3));

        [Theta_List,f1,x] = find_normal_distribution(N,0,1,increments);

        figure(1), hist((Theta_List*sigma+mean),(x*sigma+mean));hold on;plot((x*sigma+mean),f1,'-or');
        Theta_List = Theta_List * sigma * (pi/180) + mean * (pi/180);
        x = x * sigma * (pi/180) + mean * (pi/180);
        
        button = questdlg('Is the distribution ok?','Question');
        if length(strfind(button,'Yes')) == 1
            exit_loop_flag1 = 0;
        end
        close(1)
    end    
end

%% Determine Nearest Neighbor Parameters
% For ease of finding nearest neighbors for ellipse overlap criterion.

dltmp = diam;
nglnk = ceil( image_size / dltmp );
dlnk = image_size / nglnk;
lnk = zeros(nglnk,nglnk);
ndxy = 5 + ceil(2*a0/dlnk);

%% Input Filename

% Save image as filename
string = 'ellipse_vf_ab_theta';
string_path = pwd;
string = strrep(string,'_vf',sprintf('_%dvf',round(Vf_max*100)));
string = strrep(string,'_ab',sprintf('_%dab',ratio));
string = strrep(string,'_theta',sprintf('_theta%d',theta_flag));
filename = sprintf('%s.tif',string);

prompt={'Save image? (0-No, 1-Yes): ','Image filename: '};
name = 'Filename';
numlines = 1; defaultanswer = {'1',filename};
options.Resize='on'; options.WindowStyle='normal'; options.Interpreter='tex';
answer = inputdlg(prompt,name,numlines,defaultanswer,options);

image_save_flag = round(str2double(answer(1)));
filename = answer(2);
pause(0.1)

%% Microstructure Generation Routine

Rej(1:N) = 0;
circles = zeros(N,5);
Image = zeros(image_size,image_size);
Image_elements = numel(Image);
Image_sum = 0;

tic
while Image_sum/Image_elements < Vf_max;

    % First, randomly select the ellipse center coordinates.  Assign the
    % 'a' and 'b' parameter based on the largest particles first.  The
    % 'theta' parameter is randomly selected.

    x0 = ceil(rand*image_size); 
    y0 = ceil(rand*image_size);
    if (nparticles+1) <= size(List,1)
        a0 = List(nparticles+1,1);
        b0 = List(nparticles+1,2);
    end
    theta_rand = ceil(rand*length(Theta_List));
    theta0 = Theta_List(theta_rand);

    % If this is the first particle, no need to check for overlapping
    % ellipses.  Otherwise, check this potential ellipse against all other
    % ellipses in the neighborhood and return '0' if none overlap & '1' if
    % one overlaps this ellipse.

    if nparticles > 0;
        [overlap] = check_overlap_ellipses(lnk,circles,dlnk,nglnk,ndxy,...
            image_size,x0,y0,a0,b0,theta0);
    end

    % If there is no overlap, then keep the ellipse; otherwise, discard it.

    if nparticles == 0 || overlap == 0;

        % First, advance the number of particles and store all relevant
        % information in the matrix 'circles'.  Then, store the ellipse
        % center in the matrix 'lnk' for easy finding of neighboring
        % ellipses for overlap checks.  Finally, store the rejection
        % numbers and remove the theta from the theta dsitribution list.

        nparticles = nparticles + 1;
        circles(nparticles,1:5) = [x0 y0 a0 b0 theta0];
        [lnk] = store_circle(lnk,x0,y0,dlnk,nparticles);
        Rej(nparticles) = reject;
        reject = 0;
        Theta_List(theta_rand) = [];

        % Create the pixelated ellipse in matrix 'I_ellipse'.  This also
        % entails determining the size of 'I_ellipse' and the low and high 
        % bounds for inserting this ellipse into the main image matrix, 'Image'.

        if theta_flag >= 1 || nparticles == 1;
            I_ellipse = image_ellipse(a0, b0, theta0);
        end
        [nx,ny] = size(I_ellipse);
        if mod(nx,2)==1; xlo = (nx + 1)/2-1; xhi = xlo; end
        if mod(ny,2)==1; ylo = (ny + 1)/2-1; yhi = ylo; end
        if mod(nx,2)==0; xlo = (nx)/2; xhi = xlo-1; end
        if mod(ny,2)==0; ylo = (ny)/2; yhi = ylo-1; end

        % Calculate the correct bounds for inserting 'I_ellipse'.  This
        % includes wrapping the bounds through the periodic boundaries.

        nlo = x0 - xlo; nhi = x0 + xhi;
        ix = mod(nlo:nhi,length(Image));ixt = ix==0; ix(ixt)=length(Image);
        nlo = y0 - ylo; nhi = y0 + yhi;
        iy = mod(nlo:nhi,length(Image));iyt = iy==0; iy(iyt)=length(Image);

        % Now, add 'I_ellipse' to 'Image'.  If this ellipse overlaps with
        % another ellipse, then the binary matrix 'Image' will have a
        % maximum value greater than 1.  If this is the case, then
        % 'I_ellipse' will be moved until it is not overlapping.  This
        % seldom occurs, though, and is mainly dealt with in the symbolic
        % step of this algorithm.

        Image(ix,iy) = Image(ix,iy) + I_ellipse;
        if max(max(Image(ix,iy)))>1
            noverlap = noverlap + 1;
            [Image,x0,y0] = move_circle2(Image,I_ellipse,xlo,xhi,ylo,yhi,ix,iy);
            circles(nparticles,1) = x0; circles(nparticles,2) = y0;
            a = lnk == nparticles; lnk(a) = 0;
            [lnk] = store_circle(lnk,x0,y0,dlnk,nparticles);
        end

        Image_sum = Image_sum + sum(I_ellipse(:));

    else

        % If the ellipse overlaps, then add 1 to the reject counter and
        % start the whole process over again.

        reject = reject + 1;

    end
end
disp(['Symbolic generation of synthetic microstructure (sec): ' num2str(toc)])

%% Create/Save the image

tic
image_filename = filename;
Image = flipud(transpose(Image));
Image = 1 - Image;
figure;
subplot(1,2,1); imshow(Image);
subplot(1,2,2); imshow(Image(1:512,1:512));
if image_save_flag == 1
    Image = Image == 1;
    imwrite(Image,image_filename{1},'tif'); 
end
Image = 1 - Image;
Image = flipud(transpose(Image));
disp(['Image viewing and saving (sec): ' num2str(toc)]);

%% Initial Ellipse Parameters Comparison

% This section compares the initial area fraction, number of particles, and
% a/b ratio with these metrics after pixelating the ellipses.

disp('*** Computed Image Microstructure Metrics ***');
disp(['GOAL - Area fraction: ' num2str(Vf_max)]);
disp(['Actual pixelated area fraction: ' num2str(sum(Image(:))/numel(Image))]);
disp(['GOAL - Number of particles: ' num2str(N)]);
disp(['Actual number of particles: ' num2str(nparticles)]);

%% Save Data to Excel 
% Save the ellipse parameters to Excel for future retrieval and
% postprocessing, including the nearest neighbor distribution.

if image_save_flag == 1
    
    a = circles(:,3)~=0; circles = circles(a,:);    
    Excel_fileName = sprintf('%s\\ellipses.xls',string_path);
    warning off MATLAB:xlswrite:AddSheet;
    ColHeaders = {'x0','y0','a0','b0','theta0'};
    sheet = strrep(string,'_vf',sprintf('_%dvf',Vf_max*100));
    dist = 1:length(circles(:,1));
    xlswrite(Excel_fileName, ColHeaders, sheet, 'A1');
    xlswrite(Excel_fileName, circles, sheet, 'A2');
    xlswrite(Excel_fileName, circles(:,5)/pi*180, sheet, 'E2');
    deleteEmptyExcelSheets(Excel_fileName);
end

% End of the iteration loop for Vf_max