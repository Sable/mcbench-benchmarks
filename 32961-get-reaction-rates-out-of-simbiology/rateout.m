% rateout.m saves the reaction rates of SimBiology models in a global
%           variable and later on helps exporting the stored data to
%           the Matlab workspace.
%
%           My model has 5 compartments, 299 parameters, 84 species and 76
%           reactions and the simulation time does not increase
%           significantly using this tool.
%
%           It is not the most preferrable code but it does the job!
%           Future-versions of SimBiology will hopefully render this tool
%           obsolete - crossing fingers! :-/
%
%           Emails with questions/comments to: matlab@sommerhage.com
% 
%
% Instructions:
%
% 1. Copy this file (rateout.m) into the same directory as your *.sbproj
%    file.
%
% 2. Create a new parameter (here I used "temp") in your model and make
%    sure to unmark the box for "ConstantValue"!  Its value and unit are
%    not important - feel free to set whatever you want.
%
% 3. Create a rule in your model:
%
%      temp = rateout(-1)
%  
%    Set the rule type to [initialAssignment] and again, make sure that the
%    parameter "temp" is NOT marked as constant.  This part of rateout.m 
%    resets the temporary variables if you run your model again and again.
%
% 4. Create another rule in your model:
% 
%      temp = rateout(time)
% 
%    This time, set the rule type to [rate].  SimBiology seems to handle 
%    rules that are rates last.  Hence, all other rates were already
%    calculated.  This seemed to be the only way to get to the rates.
%
% 5. Run your model.  When Simbiology is done, your should already find the
%    variables t, x, obj and so forth in your workspace (SimBiology puts
%    them there).  Type
%
%      rateout
% 
%    in Matlab's workspace and hit enter.  If rateout.m is called without
%    input parameters, it fetches the final SimBiology time "t" from your
%    workspace, uses it to sort through all the intermediate results and
%    exports only the useful points as variable "v".  It further grabs your
%    model and extracts the reaction names (if defined) and assigns them in
%    the variable "vnames" in your workspace.
% 
% 6. In order to plot the reaction rates you can use
% 
%      plot(t, v)
%
%    or alternatively (I prefer this)
%
%      plot(t, v, 'displayname', vnames)
%      semilogx(t, v, 'displayname', vnames) 
% 
%    The last two options allow you to click on a line and see the
%    corresponding reaction in the property editor (field "displayname").
%
%

function time = rateout(time)
global v
global t

if nargin > 0 % if called by SimBiology
    
    if time < 0  % initialize variables
        t = [];
        v = [];
    else  % save rates
        try % this is necessary as v does not always exist - sorry
            v(:,end+1) = evalin('caller', 'v');
            t(end+1) = time;
        catch, end
    end
    
else  % if you called it from workspace
    
    % extract reaction names from your model
    evalin('base', 'vnames = get(obj.Reactions, ''Name'');');
    % fetch the time line that SimBiology deemed worthy
    basetime = evalin('base', 't');
    % sort through temporary data
    temp = zeros(length(basetime), size(v,1));
    for i = 1:length(basetime)
        p = find(t == basetime(i));
        temp(i,:) = v(:,p(end));
    end
    assignin('base', 'v', temp);
end

