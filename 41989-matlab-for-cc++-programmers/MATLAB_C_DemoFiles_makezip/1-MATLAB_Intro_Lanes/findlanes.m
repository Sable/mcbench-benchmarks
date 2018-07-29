function lanes=find_lanes(B,h, stats)
% Find the regions that look like lanes

% Copyright 2006-2013 MathWorks, Inc.
lanes = {};
l=0;
for k = 1:length(B)
    metric = stats(k).MajorAxisLength/stats(k).MinorAxisLength;
    testlane(k);
end
    function testlane(k)
        if metric > 5 & all(B{k}(:,1)>100)
            l=l+1;
            lanes(l,:)=B(k);
        else
            delete(h(k))
        end
    end
end
