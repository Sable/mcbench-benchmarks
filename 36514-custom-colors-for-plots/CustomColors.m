function ccol=CustomColors(ct1)
%This is a function to create some easy to differentiate colors, very
%useful when plotting many things in the same graphic
%The RGB coordinates and names where taken from the following page:
%http://web.njit.edu/~kevin/rgb.txt.html
%
%Examples:
%for ccc=1:15
%plot(ccc*ones(1,10),'Linewidth',4,'Color', CustomColors(ccc))
%end
%
%plot(ones(1,10),'Linewidth',4,'Color', CustomColors('Coral'))
%plot(ones(1,10),'Linewidth',4,'Color', CustomColors('DeepSkyBlue4'))
%
%Copyright: Andres Gonzalez. 2012.

CColors={
    [	[0,0.407843137254902,0.545098039215686]	];%	DeepSkyBlue4
    [	[0.545098039215686,0.270588235294118,0.0745098039215686]	];%	SaddleBrown
    [	[0,0.803921568627451,0]	];%	green3
    [	[0,0.498039215686275,1]	];%	SlateBlue
    [	[0.956862745098039,0.643137254901961,0.376470588235294]	];%	SandyBrown
    [	[0.419607843137255,0.556862745098039,0.137254901960784]	];%	OliveDrab
    [	[0.800000000000000,0.196078431372549,0.600000000000000]	];%	Violet,Red
    [	[0.556862745098039,0.419607843137255,0.137254901960784]	];%	Sienna
    [	[0.803921568627451,0.678431372549020,0]	];%	gold3
    [	[0.545098039215686,0,0.545098039215686]	];%	magenta4
    [	[1,0.498039215686275,0]	];%	coral
    [	[1,0.843137254901961,0]	];%	gold1
    [	[0.600000000000000,0.196078431372549,0.800000000000000]	];%	DarkOrchid
    [	[0.941176470588235,0.501960784313726,0.501960784313726]	];%	LightCoral
    [	[0.635294117647059,0.803921568627451,0.352941176470588]	];%	DarkOliveGreen3
    
    };
NColors={
    'DeepSkyBlue4';
    'SaddleBrown';
    'Green3';
    'SlateBlue';
    'SandyBrown';
    'OliveDrab';
    'VioletRed';
    'Sienna';
    'Gold3';
    'Magenta';
    'Coral';
    'Gold1';
    'DarkOrchid';
    'LightCoral';
    'DarkOliveGreen3';
    };

switch class(ct1)
    case 'double'
        if ct1<1
            ct1=1
            disp(sprintf('Color index must be between 1 and %d, taking closest value [%d]',length(CColors),ct1))
        elseif ct1>length(CColors)
            ct1=length(CColors)
            disp(sprintf('Color index must be between 1 and %d, taking closest value [%d]',length(CColors),ct1))
        end
        
        
        
    case 'char'
        ctfound=0
        for ct2=1:length(NColors)
            if (strcmp(NColors{ct2},ct1))
                ctfound=ct2
            end
        end
        if ctfound==0
            disp(sprintf('Color not found taking default value [%d]',1))
        else
            ct1=ctfound
        end
        
    otherwise
        disp(sprintf('Color not valid taking default value [%d]',1))
        
        
end





ccol=CColors{ct1}
end





