% Ot Matlab interface to OmniTRANS.
%
% Commands:
%    OtStart                     Initialize the Ot-interface.
%    OtStop                      Stop using the Ot-interface.
%
%    OtTableNew,OtQueryNew       Create a table/query handle.
%    OtTableFree,OtQueryFree     Release a table handle.
%
%    OtTableSetName              Set the path to a .db file.
%    OtQuerySetSql               Set an SQL statement for a query.
%
%    OtTableOpen,OtQueryOpen     Open an OmniTRANS table/SELECT-query.
%    OtTableClose,OtQueryClose   Close an OmniTRANS table/SELECT-query.
%    OtQueryExecute              Execute a non-SELECT SQL query.
%
%    OtTableFields,OtQueryFields             Get an array field names.
%    OtTableEmpty,OtQueryEmpty               Is the record set empty?
%    OtTableRecordCount,OtQueryRecordCount   Return the number of records.
%
%    OtTableFirst,OtQueryFirst   Move to the first record.
%    OtTableNext,OtQueryNext     Move to the next record.
%    OtTableEof,OtQueryEof       Check whether the last record was read.
%
%    OtTableLast,OtQueryLast     Move to the last record.
%    OtTablePrior,OtQueryPrior   Move to the previous record.
%    OtTableBof,OtQueryBof       Check whether the first record was read.
%
%    OtTableGet,OtQueryGet       Get contents of a field at the current record.
%    OtTableGetAll,OtQueryGetAll Get contents of all fields at the 
%                                current record in a string array.
%
%    OtTableAppend               Put the table into append mode.
%    OtTableEdit                 Put the table into edit mode.
%    OtTableSet                  Modify the current record.
%    OtTableDelete               Delete the current record.
%    OtTablePost                 Post changes to the database table.
%
%    OtPmtu,OtPmturi                      Create a PMTU or PMTURI structure.
%    OtMatrixCubeNew,OtSkimCubeNew        Create a new matrix/skim cube handle.
%    OtMatrixCubeFree,OtSkimCubeFree      Release a matrix/skim cube handle.
%    OtMatrixCubeGet,OtSkimCubeGet        Obtain a matrix from a matrix/skim cube.
%    OtMatrixCubeSet,OtSkimCubeSet        Store a matrix in a matrix/skim cube.
%    OtMatrixCubeDelete,OtSkimCubeDelete  Delete a matrix in a matrix/skim cube.
%
% To be able to use this interface, ensure the OmniTRANS directory
% (with OtInterface.dll and all those BPL files) is on the system path.
%

% OtMatlab: Matlab interface to the Omnitrans transport planning software

% Copyright (c) 2008, VORtech Computing
% Copyright (c) 2010, Omnitrans International

% All rights reserved.

% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:

%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%     * Neither the name of VORtech Computing and Omnitrans International nor the names 
%       of its contributors may be used to endorse or promote products derived 
%       from this software without specific prior written permission.
      
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.

% 2006-02-28 Created (Johan Meijdam, VORtech) 
% 2010-01-22 Updated by Feike Brandt, OmniTRANS International B.V.

% Implementation: Ot.cpp

function [result] = Ot(command, arguments)
    error(['This is Ot.m. In case you read this error message,' ...
           'check whether there is an Ot.dll file in the same directory.']);