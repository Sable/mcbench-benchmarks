%                               431-400 Year Long Project 
%                               LA1 - Medical Image Processing 2003
% Supervisor     :  Dr Lachlan Andrew
% Group Members  :  Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
%                   Lee Siew Teng   102519  s.lee1@ugrad.unimelb.edu.au
%                   Loh Jien Mei    103650  j.loh1@ugrad.unimelb.edu.au
%
% File and function name : calculate_min_distance
% Version                : 1.0
% Date of completion     : 6 October 2003   
% Written by    :   Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
%
% Input   : 
%           edge1,edge2 -   [X,Y] coordinates to be compared and measured
%           'testing' or 'not testing' (optional) - Default 'not testing'
%
% Output  : 
%           min_distance - Returns the minimum distance between the two 
%                          sets of coordinates.
%           matching_coordinates - [edge1X,edge1Y,edge2X,edge2Y]
%                           Pairs of coordinates of edge1 and edge 2 that 
%                           are of the minimum distance.
%
% Description:
%       Calculates the minimum distance between 2 edges and returns the distance and
%   the matrix linking the coordinates to both edge coordinates.
%     
% Usage >> [min_distance,matching_coordinates] = calculate_min_distance(edge1,edge2)
%                   or
%          [min_distance,matching_coordinates] = calculate_min_distance(edge1,edge2,'testing')
%                   or
%          [min_distance,matching_coordinates] = calculate_min_distance(edge1,edge2,'not testing')
%
% Example >> [min_distance,matching_coordinates] = calculate_min_distance(edge1,edge2)
%                 figure;
%                 plot(edge1(:,1),edge1(:,2),'r+-');
%                 hold on;
%                 plot(edge2(:,1),edge2(:,2),'b+-');
%                 for n = 1:1:length(matching_coordinates(:,1))
%                     plot([matching_coordinates(n,1);matching_coordinates(n,3)],...
%                          [matching_coordinates(n,2);matching_coordinates(n,4)],'g*-');
%                 end        
%                 xlabel(strcat('minimum distance = ',num2str(min_distance)));
%
% WARNING >> In some coordinates there may visually be some overlaping lines that do not register
%            as being of distance 0. This is because the pixels representing these lines
%            do not coincide.

function [min_distance,matching_coordinates] = calculate_min_distance(edge1,edge2,varargin)
% ---------------------------------------------------------------------------------
% Process the input
% ---------------------------------------------------------------------------------
testing = 'not testing';
if ~isempty(varargin)
    for n = 1:1:length(varargin)
        if strcmp(varargin{n},'not testing') | strcmp(varargin{n},'testing')
            testing = varargin{n};            
        end
    end
end
if isempty(edge1) | isempty(edge2)
    error('Input entry is a null matrix');
end
% ---------------------------------------------------------------------------------
% Find the closest edge and calculate the distance
% ---------------------------------------------------------------------------------
temp1 = [];
temp2 = [];
for n = 1:1:length(edge1(:,1))
    temp = edge2;
    temp(:,1) = edge1(n,1);
    temp(:,2) = edge1(n,2);
	temp1 = [temp1;temp];
    temp2 = [temp2;edge2];
    % Distance calculated here to reduce memory usage
    distance = euclidean_distance(temp1,temp2);
    min_distance = min(distance);
    pos = find(distance == min_distance);
    temp1 = temp1(pos,:);
    temp2 = temp2(pos,:);
end
distance = euclidean_distance(temp1,temp2);
pos = find(distance == min_distance);
min_distance = min(distance);

matching_coordinates = [temp1(pos,:),temp2(pos,:)];

% ---------------------------------------------------------------------------------
% Displaying the results for testing
% ---------------------------------------------------------------------------------
if strcmp(testing,'testing')
    figure;
    plot(edge1(:,1),edge1(:,2),'r+');
    hold on;
    plot(edge2(:,1),edge2(:,2),'b+');
    for n = 1:1:length(matching_coordinates(:,1))
        plot([matching_coordinates(n,1);matching_coordinates(n,3)],...
             [matching_coordinates(n,2);matching_coordinates(n,4)],'g*-');
    end        
    title('edge1(red+), edge2(blue+) and selected edges(green*)');
    xlabel(strcat('minimum distance = ',num2str(min_distance)));
end