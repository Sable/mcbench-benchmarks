function proclivityFeature = trendFeatureDetector( previousProclivity, currentProclivity )
%TRENDFEATUREDETECTOR 
% for the next round, only the latest proclivity is required for tracking, ie. latestProclivity = currentProclivity;
%stateModes = {'plateau', 'ascent', 'descent'};
proclivityFeatureDetectModes = {'MAXIMA', 'MINIMA', 'NO_DETECT', 'ASCENT', 'DESCENT', 'PLATEAU'};
proclivityFeature = proclivityFeatureDetectModes(3);

if (strcmp(previousProclivity, currentProclivity)) % Proclivity remains unchanged
    % proclivityFeature = proclivityFeatureDetectModes(3);
    proclivityFeature = upper(currentProclivity); % constant trend - no change
    
    return;
end

if ( ... % 'MINIMA'
    ( (strcmp(previousProclivity, 'descent')) & (strcmp(currentProclivity, 'ascent')) ) | ...
    ( (strcmp(previousProclivity, 'plateau')) & (strcmp(currentProclivity, 'ascent')) ) | ...
    ( (strcmp(previousProclivity, 'descent')) & (strcmp(currentProclivity, 'plateau')) ) ...
    )
    proclivityFeature = proclivityFeatureDetectModes(2);
    
    return;
end

if ( ... % 'MAXIMA'
    ( (strcmp(previousProclivity, 'ascent')) & (strcmp(currentProclivity, 'descent')) ) | ...
    ( (strcmp(previousProclivity, 'plateau')) & (strcmp(currentProclivity, 'descent')) ) | ...
    ( (strcmp(previousProclivity, 'ascent')) & (strcmp(currentProclivity, 'plateau')) ) ...
    )
    proclivityFeature = proclivityFeatureDetectModes(1);
    
    return;
end

end

%{

MINIMA
------
[1]
\   /
 \ /
  V                  descend, ascend
[2]
     /
    /
___/                 plateau, ascend

[3]
\         /
 \       /
  \_____/
        \
         \           descend, plateau, (ascend/ descend)

MAXIMA
------
[1]
  ^
 / \
/   \               ascend, descend

[2]  
___ 
   \
    \
     \              plateau, descend

[3]
         /
        /
  _____/
 /     \
/       \           ascend, plateau,
%}