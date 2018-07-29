function map=readContourPlot(imagefile, xaxis, yaxis, zvalues)
% readContourPlot  Read data in from a printed contour plot
% readContourPlot(imagefile, xaxis, yaxis, contourlist) presents the user
% with a figure contianing the image of the contour plot. The user may use
% the mouse to left-click around each contour on the map. The data used to
% create the contour plot will then be recreated.
%
% Inputs:
% imagefile: The image of the contour plot, in any format recognised by
%  imread
% xaxis, yaxis: The values of the x- and y-axis on the contour plot to be
%  read. This defines the display and calibration of the plot, and also the
%  accuracy - for example xaxis=100:10:200 will read inputs to the nearest
%  10, while 100:1:200 will read inputs to the nearest 1
% zvalues: Vector containing the values of the lines on the contour plot,
%  starting at the outer-most contour. Multiple islands may be represented
%  by repeating values in this vector.
%
% Usage:
% During use, left-click to add a point to the current contour, right-click
% to delete the last point (all points in the contour can be deleted, but
% previous contours cannot be changed), and press "Enter" (or middle click)
% to move on to the next contour.
% Contours are automatically closed into polygons - for example to input a
% rectangular contour, it would only be necessary to click 4 times.
%
% Areas of the map not defined are set to zero.
%
% Example usage, with provided engine bsfc map (from Wikipedia)
% bsfc=[450 400 350 300 280 270 260 250 240 230 225 220 215 210 206];
% enginespeed=1000:10:4500;
% bmep=0:0.1:18;
% map=readContourPlot('bsfc_wiki_cropped.png', enginespeed, bmep, bsfc)

% Read in the image of the printed map
img=imread(imagefile);

% Create a plot with the printed map as the background, scaled correctly
figure; imagesc([min(xaxis) max(xaxis)], [max(yaxis) min(yaxis)], img); hold on;
set(gca, 'ydir', 'normal')

% Create a matrix of high values to hold the new SFC map. Each contour
% drawn progressively over-writes the relevant section with a lower number
map=zeros(length(yaxis), length(xaxis));

% handles to the elements in the plot - initialise blank
h=[];

%Start the main loop - iterate once for each contour to be read
for c=1:length(zvalues)
    % Set the title of the plot as an instruction to the user. If the value
    % of this contour is the same as the last, it is an island - add this
    % to the user prompt to save confusion about duplication
    island='';
    if (c>1 && zvalues(c-1)==zvalues(c))
        island=' (island)';
    end
    title(['Select contour at ' num2str(zvalues(c)) island ', middle-click when complete'], 'FontSize', 16);

    % Read data in from the user (clicks on the plot, following a contour)
    x=[]; y=[]; xs=1;
    while ~isempty(xs)
        [xs,ys, button]=ginput(1);
        % button 3 (right click) deletes the last point
        if button==3
            % check there is a previous point to delete
            if ~isempty(x)
                x=x(1:length(x)-1);
                y=y(1:length(y)-1);
                delete(h(length(h)));
                h=h(1:length(h)-1);
            end
        else
            % Check if a point was returned - if enter has been pressed, or
            % if middle click, then the series is complete
            if button==2
                xs=[];  % this is needed to break the while loop
            end
            if ~ isempty(xs)
                % Mouse was left-clicked, add new point to list of points
                x(length(x)+1)=xs;                          %#ok<*SAGROW>
                y(length(y)+1)=ys;
                if (length(x)==1)
                    % if this is the first point in the set, plot a point
                    h(length(h)+1)=plot(xs, ys, 'go', 'LineWidth', 3);
                else
                    % ...otherwise plot a line to the previous point
                    h(length(h)+1)=plot([x(length(x)-1) xs], [y(length(y)-1) ys], 'ro-', 'LineWidth', 2);
                end
            end
        end
    end

    % Create a temporary map to represent this one contour
    mapbit=uint8(zeros(size(map)));

    % Set up the temporary map as a mask, to determine the location of the
    % polygon represented by the selected points on the contour
    for i=1:length(yaxis)
        mapbit(i,:)=inpolygon(xaxis, ones(1,length(xaxis))*yaxis(i), x, y);
    end

    % Superimpose the z-value of this contour onto the map, using the
    % temporary map as a mask (this could be tidied, but works)
    for i=1:length(yaxis)
        for j=1:length(xaxis)
            if mapbit(i, j) > 0
                map(i,j)=zvalues(c);
            end
        end
    end
    delete(h);
    h=[];
    [~,h(1)]=contour(xaxis, yaxis, map, zvalues);
end

title('Printed and recreated contour map', 'FontSize', 16);
colorbar;

end
