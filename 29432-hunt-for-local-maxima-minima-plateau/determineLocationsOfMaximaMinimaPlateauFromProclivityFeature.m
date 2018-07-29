function [locationsOfMaxOrMin, startSitesPlateau, endSitesPlateau ] = determineLocationsOfMaximaMinimaPlateauFromProclivityFeature( proclivityFeatureALL, proclivityFeatureToHunt )
%DETERMINELOCATIONSOFMAXIMAMINIMAPLATEAU 

plateauSitesCount = 0;
startSitesPlateau = [];
endSitesPlateau = [];
locationsOfMaxOrMin = [];

if (strcmp(upper(proclivityFeatureToHunt), 'PLATEAU'))
    startSiteTrackON = 1;
    % track start and end locations of plateau
    for i = 1:length(proclivityFeatureALL)
        % start of plateau found
        if (strcmp(proclivityFeatureALL(i), upper(proclivityFeatureToHunt)) & ...
                startSiteTrackON )
            plateauSitesCount = plateauSitesCount + 1;
            startSitesPlateau(plateauSitesCount) = i;
            startSiteTrackON = 0;
        end
        % end of plateau found
        if (~strcmp(proclivityFeatureALL(i), upper(proclivityFeatureToHunt)) & ...
                ~startSiteTrackON )
            endSitesPlateau(plateauSitesCount) = i + 1;
            startSiteTrackON = 1;
        end        
    end
    
    if (length(startSitesPlateau) ~= length(endSitesPlateau))
        endSitesPlateau(plateauSitesCount) = length(proclivityFeatureALL) + 2;
    end

    return; % End Plateau tracking
end

maxOrMinSitesCount = 0;
% proclivityFeature : cell arrays
for i = 1:length(proclivityFeatureALL)
    if strcmp(proclivityFeatureALL(i), upper(proclivityFeatureToHunt))
        maxOrMinSitesCount = maxOrMinSitesCount + 1;
        locationsOfMaxOrMin(maxOrMinSitesCount) = i + 1;
    end
end

end

%{
3 plateau tags:

-- --       for x-x-x-x-x
 --

thence, start = i, end = i + 3 + 1;


%}