function h = savehold()
% SAVEHOLD Encapsulated 'hold on' and its state.
% 
% Description:
%   holdon = savehold()
%      Saves the handle to current axes, the 'ishold' result for the
%      current axes, and issues the command 'hold on'. 
%
%   holdon.restore() 
%      Sets the saved state of the 'hold' property for the saved axes
%      object.
%
%   Example:
%
%      Assume we have axes inside a figure with some plots already there.
%      We want to add some plots and then restore the state of hold (if it
%      was 'on' before, we want it to stay 'on' after; if it was 'off'
%      before, we want to set it back to 'off').
%      
%      It can be done by the following commands:
%
%      >> % Commands plotting something and setting 'hold on' or 'hold off'
%      >> washold = ishold;   % Get the 'state of hold' for the current axes
%      >> hold on;            % Set the 'hold' property to 'on'
%      >> plot(something);
%      >> plot(something different);
%      >> if ~washold, hold off; end  % Reset the state of hold if needed
%
%      With SAVEHOLD, the above code can be simplified to:
%
%      >> % Commands plotting something and setting 'hold on' or 'hold off'
%      >> holdon = savehold();
%      >> plot(something);
%      >> plot(something different);
%      >> holdon.restore();
%
% See also HOLD, ISHOLD

% Filename     : savehold.m
% Author       : Petr Posik (posik#labe.felk.cvut.cz, replace # by @ to get email)
% Created      : 03-Feb-2010 11:39:35
% Modified     : $Date: 2010-02-03 12:05:47 +0100 (st, 03 II 2010) $
% Revision     : $Revision: 4718 $
% Developed in : 7.5.0.342 (R2007b)
% $Id: savehold.m 4718 2010-02-03 11:05:47Z posik $

    h.restore = @restore;

    ax = gca;
    washold = ishold;
    hold on;

    function restore()
        if ~washold,
            hold(ax,'off');
        end
    end
end
