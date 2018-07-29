function tcprintfDemo()
    % Author: Dan O'Shea dan at djoshea.com (c) 2012
    % Released under the open source BSD license 
    %   opensource.org/licenses/bsd-license.php

    colorList = {'black', 'darkGray', 'lightGray', 'white', 'red', 'green', 'yellow', ...
        'blue', 'purple', 'cyan'};
    supportsBright = [0 0 0 0 1 1 1 1 1 1];
    nColors = length(colorList);

    backColorList = {'onBlack', 'onRed', 'onGreen', 'onYellow', 'onBlue', ...
        'onPurple', 'onCyan', 'onWhite'};
    nBackColors = length(backColorList);

    underline = true;

    for isUnderline = 0:1
        if isUnderline
            underlineStr  = 'underline ';
        else
            underlineStr = '';
        end

        for iBackColor = 1:nBackColors
            backColor = backColorList{iBackColor};

            tcprintf(underlineStr, '%9s : ', backColor);
            cumulChars = 12;

            for iColor = 1:nColors
                color = colorList{iColor};

                for isBright = 0:1
                    if isBright 
                        if supportsBright(iColor)
                            bright = 'bright ';
                        else
                            continue;
                        end
                    else
                        bright = '';
                    end
                    style = sprintf('%s%s%s %s', underlineStr, bright, color, backColor);
                    message = sprintf('%s ', color);

                    cumulChars = cumulChars + length(message);
                    if cumulChars > 80
                        fprintf(['\n' repmat(' ', 1, 12)]);
                        cumulChars = 0;
                    end

                    tcprintf(style, message);
                end
            end

            fprintf('\n');
        end
        fprintf('\n');
    end
end

