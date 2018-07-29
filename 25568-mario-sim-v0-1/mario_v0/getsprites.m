%THIS SCRIPT HELPS THE USER IDENTIFY THE SPRITES PRESENT IN A SPRITE SHEET.
%THE SCRIPT IS CURRENTLY CONFIGURED TO SEARCH THE MARIO SHEET.  IN THIS
%CASE, THE STATES OF MARIO IN THE SHEET ARE SMALL, BIG, AND FIREPOWER, AND
%THE SHEET INCLUDES SPRITES FOR LEFT-FACING AND RIGHT-FACING MARIO.  FOR
%EACH COMBINATION OF STATE, DIRECTION, ACTION, AND FRAME WITHIN CURRENT
%ACTION, THE SCRIPT ASKS THE USER TO LOCATE THE MATCHING OBJECT.  WHEN
%PROMPTED, THE USER SIMPLY CLICKS ANYWHERE NEAR THE CENTER OF THE INTENDED
%SPRITE, AND THE SCRIPT THEN MATCHES THE PROPERTIES OF THE SELECTED SPRITE
%TO THE SPECIFIED COMBINATION OF STATE, DIRECTION, ACTION, AND ITERATION.
%IF MULTIPLE FRAMES BELONG TO THE PROMPTED ACTION, THE USER SHOULD CLICK
%EACH OF THE SPRITES BELONGING TO THE ACTION, IN ORDER.

%Open sprite sheet:
[A, map] = imread('smb_mario_sheet.png','BackgroundColor','none');
clf; imshow(A,map); hold on;			%display sprite sheet

%Locate all individual objects:
BW1=A>0;								%Create mask; assumes the space between sprites is 0 (transparent, or color map value = 0 =(?) black)
bdry = bwboundaries(BW1,'noholes');		%Create curves marking boundaries of each object
%Get centers and bounds of all identified objects:
for k=1:length(bdry), 
	b = bdry{k}; plot(b(:,2),b(:,1),'g');
	sprite(k).center = [mean(b(:,2)) mean(b(:,1))];
	sprite(k).lbound = [min(b(:,2))	min(b(:,1))];
	sprite(k).ubound = [max(b(:,2)) max(b(:,1))];
end;

%NOTE: To adapt this script to other sprite sheets, the following must be
%updated.  For example, if a sprite sheet includes both Mario and Luigi,
%the user might manually add a 'characters' array, and add a wrapping
%for-loop.
%ACTION#:	1		2		3		4	  5		 6		7		8		9
actions	= {'stand','walk','jump','duck','skid','climb','swim','shoot','die'};
states	= {'small','big','firepower'};
dxns	= {'right','left'};
iters	= [	 1,		 3,		1,		1,	  1,	  2,	 6,		1,		1]; %specifies the number of frames belonging to each action
%LOOP THROUGH ALL COMBOS OF ABOVE TRAITS:
for state = 1:length(states)
	for dxn = 1:2
		for action = 1:length(actions)
			title([states{state},' ',dxns{dxn},' ',actions{action}]);
			%User clicks each frame belonging to the current action
			[X,Y]=ginput(iters(action));
			
			for i=1:length(X),
				for k=1:length(sprite),
					if dist(sprite(k).center,[X(i);Y(i)])<10
						disp(k);
						mario(state).dxn(dxn).action(action).iter(i).lbound = sprite(k).lbound;
						mario(state).dxn(dxn).action(action).iter(i).ubound = sprite(k).ubound;
						break;
					end;
				end;
			end;
			
		end;
	end;
end;


