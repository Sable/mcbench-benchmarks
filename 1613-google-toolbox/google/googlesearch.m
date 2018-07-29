function struct = googlesearch(q,maxResults,filter)
%GOOGLESEARCH Searches Google and returns the results. 
%   S = GOOGLESEARCH(Q) searches Google with the query string Q.  Q supports
%   the same syntax as the web-form, including "+", "-", "OR", "site:", etc.  S
%   is a structure containing all the results.  The default is "MathWorks".
%
%   S = GOOGLESEARCH(Q,maxResults) returns not just 10, but up to maxResults
%   results.  Note that for each additional 10 results, this function makes an
%   additional query to Google and uses up an other hit out of the maximum
%   daily usage of 1000 querries.  For example, returning 85 results will use up
%   9 hits.  The default is 10.
%
%   S = GOOGLESEARCH(Q,maxResults,filter) activates automatic results filtering.
%   When 1, it filters out similar results and more than two results per host.
%   this closely matches what a user sees through the web interface.  When 0,
%   this filtering is disabled and the results closely match the PageRank.  The
%   default is 0.
%
%   In order to use Google Web APIs you first must register with Google to
%   receive an authentication key. You can do this online at
%   http://www.google.com/apis/.
%
%   Your key will have a limit on the number of requests a day that you can
%   make. The default limit is 1000 queries per day. If you have problems with
%   your key or getting the correct the daily quota of queries, plase contact
%   <api-support@google.com>.

%   Matthew J. Simoneau, April 2002
%   Copyright 2002 The MathWorks, Inc. 
%   $Revision: $  $Date: $

% Set defaults.
if (nargin < 1), q = 'matlab'; end
if (nargin < 2), maxResults = 10; end
if (nargin < 3), filter = 0; end

% Setup.
googleSearch = com.google.soap.search.GoogleSearch;
key = getpref('google','key','');
if isempty(key)
    error(sprintf('%s\n%s', ...
'No key set.  You need to get an access key from Google and set it like this:', ...
'setpref(''google'',''key'',''xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'');'));    
end
googleSearch.setKey(key);
googleSearch.setQueryString(q);
googleSearch.setFilter(filter);

resultElements = [];

start = 0;
while (start == 0 | ...
        ((struct.EndIndex < maxResults) & ...
        length(struct.ResultElements) == start))

    % Query Google.
    googleSearch.setStartResult(start);
    r = googleSearch.doSearch;
        
    % Convert the results into a MATLAB-friendly structure.
    struct.ResultElements = r.getResultElements;
    struct.SearchQuery = char(r.getSearchQuery);
    if (start == 0)
        struct.StartIndex = r.getStartIndex;
    end
    struct.EndIndex = r.getEndIndex;
    struct.DocumentFiltering = r.getDocumentFiltering;
    struct.EstimatedTotalResultsCount = r.getEstimatedTotalResultsCount;
    struct.EstimateIsExact = r.getEstimateIsExact;
    struct.SearchComments = char(r.getSearchComments);
    if (start == 0)
        struct.SearchTime = r.getSearchTime;
    else
        struct.SearchTime = struct.SearchTime + r.getSearchTime;
    end
    struct.SearchTips = char(r.getSearchTips);
    struct.DirectoryCategories = r.getDirectoryCategories;
    
    directoryCategories = [];
    for i = 1:length(struct.DirectoryCategories)
        directoryCategory = struct.DirectoryCategories(i);
        directoryCategories(i).FullViewableName = ...
            char(directoryCategory.getFullViewableName);
        directoryCategories(i).SpecialEncoding = ...
            char(directoryCategory.getSpecialEncoding);
    end
    struct.DirectoryCategories = directoryCategories;
    
    if (struct.StartIndex > 0)
        for i = struct.StartIndex+start : struct.EndIndex
            element = struct.ResultElements(i-start);
            resultElements(i).URL = char(element.getURL);
            resultElements(i).Title = char(element.getTitle);
            resultElements(i).Summary = char(element.getSummary);
            resultElements(i).Snippet = char(element.getSnippet);
            resultElements(i).CachedSize = char(element.getCachedSize);
            resultElements(i).RelatedInformationPresent = ...
                element.getRelatedInformationPresent;
            directoryCategory = element.getDirectoryCategory;
            resultElements(i).DirectoryCategory.FullViewableName = ...
                char(directoryCategory.getFullViewableName);
            resultElements(i).DirectoryCategory.SpecialEncoding = ...
                char(directoryCategory.getSpecialEncoding);
            resultElements(i).DirectoryTitle = char(element.getDirectoryTitle);
            resultElements(i).HostName = char(element.getHostName);
        end
    end
    struct.ResultElements = resultElements;
    
    start = start + 10;
end
