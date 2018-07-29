%Provides MATLAB callbacks called by timer events
%syntax   : RESULT = TIMER ( COMMAND, PARAM, CBSTRING)
%Command  : action code. May be both string and numeric.
%Param    : numeric parameter.
%cbString : MATLAB callback string.
%There are three Commands available:
%1. 'SetTimer'     - defines timer using WINAPI SetTimer function.
%                    Current version allows to create up to 16 timers.
%    Param         - elapse time in milliseconds.
%    cbString      - callback string for eval(), any valid MATLAB expression.
%    Result        - new Windows timer ID if successful (should be kept),
%                    otherwise zero.
%2.  'SetCallBack' - sets new callback for valid timer.
%    Param         - valid timer ID.
%    cnString      - new callback string.
%    Result        - timer ID if successful otherwise zero.
%3.  'KillTimer'   - cancels timer using WINAPI KillTimer function.
%    Param         - timer ID to kill (kills all timers if zero or not present)
%    Result        - one if successful otherwise zero
