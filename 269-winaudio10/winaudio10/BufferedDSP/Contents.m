% Buffered DSP Blockset
% Version 1.0  21-May-1998
% Copyright (c) 1998  Steve Mitchell
%
% BufferedDSP is a Simulink library for performing
% audio DSP under Simulink.  It includes frame-based blocks
% like those introduced in Simulink 2.2.  In most cases
% multiple channels are supported in either column major
% or row major storage order.
%
% Warning:  All loops created with these blocks will be
%    algebraic, and usually unresolvable in Simulink.
%
% Buffered DSP Simulink Blocks
% ----------------------------
%
% Counters               -- Event counters with reset, preset, 
%                           and stop count
% Pulse Shapers
%    Edge Detect         -- Outputs during leading edges
%    Min Pulse Width     -- Extends a pulse to a minimum duration
%    Max Pulse Width     -- Shortens a pulse to a maximum duration
%    One-Shot            -- Transforms a pulse to a fixed duration
%    Pulse Extend        -- Delays trailing edges
%
% Filter
%    FIR Filter          -- Overlap-Save FIR filter implementation
%    FIR Filter1         -- Overlap-Add  FIR filter implementation
%    Integrate           -- Finite duration moving average
%    MultiChannel IIR    -- Link to the Mathworks DSP Blockset
%    FIR Rate Conversion -- Link to the Mathworks DSP Blockset
%    
%
% Multichannel
%    Deinterleave        -- Row-major to column-major conversion
%    Interleave          -- Column-major to row-major conversion
%    Select Channel      -- Extract one from many channels
%
% Memory
%    Delay               -- Discrete signal delay
%    FIFO                -- Overlap successive buffers
%    Flip Flop           -- RS flip-flop
%    Pulse Limited
%       Flip Flop        -- RS flip-flop with pulse duration 
%                           control
%
% Other
%    File Exists         -- Outputs a "1" if a specified file 
%                           exists
%
% Demos
%    Detector1           -- Filter, energy detect, and save to 
%                           file
%    TestSignal.m        -- Initialize and run Detector1 demo
%    Detector2           -- WinAudio version of Detector1
%    Detector3           -- RTW-ready version of Detector2
%
% C-MEX S_Functions
%   sclipnsave          -- Cut out samples & save to disk
%   scounter            -- Accumulator with preset, reset, and stopcount
%   sdelay              -- Delay
%   sfifo               -- Circular buffer
%   sfiniteintegrate    -- Moving average
%   splimflipflop       -- RS Flip-flop with pulse length control
%   stranspose          -- Matrix transpose
%
%
% Developed for:
%
% Bill Evans
% Nocturnal Flight Call Monitoring Project
% Cornell Lab of Ornithology
% 159 Sapsucker Woods Rd.
% Ithaca, NY  14850

