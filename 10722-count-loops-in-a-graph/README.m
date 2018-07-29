function readme()
% 
% I. INTRODUCTION
%     The MATLAB(R) program contained within this directory counts the total
% number of loops (cycles) in a network (graph) that consists of nodes and edges.
%     This file describes the setup/installation proceedures for the code. A
% description of the algorithm and how to use the code is contained in the
% 'DETAILS.m' file.
% 
% 
% II. CONTENTS
%     In the Loops/ directory, you should find the following files:
%         DETAILS.m
%         README.m
%         loops_gui.m
%         run_loops.m
%         nets/**
%         **several sample network files 
% 
% 
% III. SETUP/INSTALLATION
%     1. You must have MATLAB software installed on your computer
%     2. Copy/move the 'Loops' folder to the MATLAB 'work' directory
%     3. Open MATLAB and add the 'Loops' directory to the Path
%         a. Go to: File -> Set Path...
%         b. Click on 'Add with subfolders...'
%         c. Select the 'Loops' directory and click 'Ok'
%         d. Click 'Save'
%         e. Click 'Close'
%     4. To run, open the 'loops_gui.m' file and press F5 or use the
%         command line: >> loops_gui
%     5. Note: this code was written using MATLAB 7R14 through R2006B. It has not 
%         been tested on previous versions
% 
% 
% IV. HELP/REPORT BUGS
%     If you experience difficulties using this program, first make sure that
% the steps in Section III have been completed. Next, make sure your network
% satisfies all the requirements given in the 'DETAILS.m' file.
% 
% Please direct questions/comments to:
% Joe Kirk
% jdkirk630@gmail.com
% 
% 
% V. REVISION NOTES
%     11/2005 Update:
%         1. New file 'loop_gui.m' - GUI file that replaces 'run_loops.m' and
%             displays all of the tools for the user as they are available
%         2. Added ability to save loops in .MAT format
%     10/2005 Update:
%         1. New file 'reduceNet.m' - function which allows networks to be reduced
%             (removes nodes that have only one edge, until no more remain in the net)
%         2. New file 'getStartingNode.m' - function which calculates a (nearly)
%             optimal starting node to make the ILCA more efficient (results in
%             fewer steps to complete the algorithm)
%         3. Removed file 'printNetStats.m' - the basic functionality of this
%             file was separated into two separate files ('calcNumEdges.m'
%             and 'plotHLoops.m')
%         4. New file 'calcNumEdges.m' - function which calculates the number of
%             edges in a network
%         5. New file 'plotHLoops.m' - function which plots the distribution of
%             loops of length 'h'
%         6. Modified file 'generateRandomNet.m' to limit the creation of sparse
%             networks with more nodes than 40 (which are costly to generate with
%             this function)
%     2/2007 Update:
%         1. All of the subfunction files have been deprecated, and their
%             functionality has been combined and added to the end of the
%             'loops_gui.m' and 'run_loops.m' files. The two files 'loops_gui.m'
%             and 'run_loops.m' are now independent, stand-alone m-files
%         2. Added ability to save the network as an edgelist file
%         3. Improved the layout and function of the Loops GUI
% 
clc
help readme