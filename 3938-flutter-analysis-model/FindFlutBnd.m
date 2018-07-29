% Define the Initial Values
mach = .77;
altStart=43000;
altDec=-1000;

% Make sure a variable is in the "Altitude" constant block
altString=get_param('Flutter/Altitude','value');
set_param('Flutter/Altitude','value','alt')

%Start the iterations to find the flutter point
for refineLevel=1:5
    for alt=altStart:altDec:0
        % Run the Simulink Model
        [t,x,y] = sim('Flutter');
        if y(end,2)
            % Display to the screen
            disp(['Unstable at q=',num2str(y(end,1)),' PSF'])
            % Flutter point found, refine altitude decrement
            break;
        else
            % Display to the screen
            disp('Stable')
        end
    end %altitude loop
    altStart = alt-altDec;
    altDec = altDec/2;
end %refinement loop

% Put the "Altitude" block back the way we found it
set_param('Flutter/Altitude','value',altString)
        