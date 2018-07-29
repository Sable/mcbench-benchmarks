function result = LogLin( VarEndoNames, VarExoNames, Parameters, Equations, SolveMode, EvalMode, EvalString, Digits )
% ------------------------------------------------------------
% PURPOSE:	Performs log-linearisation.
% ------------------------------------------------------------
% SYNTAX:	result = LogLin( VarEndoNames, VarExoNames, Parameters, Equations, SolveMode, EvalMode, EvalString, Digits );
% ------------------------------------------------------------
% EXAMPLE:	result = LogLin( { 'R', 'A' }, { 'EPSILON' }, { 'beta', 'rho' }, { 'beta * R * A / A(+1) = 1', 'A = A(-1) ^ rho * exp( EPSILON )' }, 2, 2 )
% ------------------------------------------------------------
% OUTPUT:	result:		a cell array of log-linearised equations, with __d appended to variable names that are deviations from steady state.
% ------------------------------------------------------------
% INPUT:	VarEndoNames:	a cell array of endogenous variable names
%			VarExoNames:	a cell array of exogenous variable names
%			Parameters:		a cell array of parameter names
%			Equations:		a cell array of equations, in Dynare notation
%			SolveMode:		specifies how the steady state is found
%				SolveMode = 0	---> the steady state is not found, instead __s is appended to the variable names
%				SolveMode = 1	---> the steady state is found analytically
%				SolveMode = 2	---> the steady state is found analytically, allowing all algebraic manipulations
%				SolveMode = 3	---> the steady state is found analytically, assuming real values
%				SolveMode = 4	---> the steady state is found numerically
%			EvalMode:		specifies any processing of the found equations
%				EvalMode = 0	---> no additional processing
%				EvalMode = 1	---> simplification
%				EvalMode = 2	---> simplification, allowing all algebraic manipulations
%				EvalMode = 3	---> numeric evaluation, to Digits precision
%			EvalString:		string of comma delimited equations, useful for	specifying parameters or your own computed steady state values (e.g. 'beta=0.99,rho=1/2', or 'A=1')
%        	Digits:		(optional) the number of digits of accuracy for numerical compuations
% ------------------------------------------------------------
% Copyright © 2011 Tom Holden ( http://www.tholden.org/ )
% All rights reserved.
% ------------------------------------------------------------
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
% 
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%       
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
% ------------------------------------------------------------

if nargin < 6
	error( 'Insufficient arguments provided to LogLin.' );
end

nl = sprintf( '\n' );

ProcessedEquations = cell( size( Equations ) );
SteadyEquations = cell( size( Equations ) );
TempVarNames = [ VarEndoNames VarExoNames ];

SteadyStateEquations = '';
SteadyStateVars = '';
Comma = '';

for VarEndoName = VarEndoNames
	SteadyStateVars = [ SteadyStateVars Comma VarEndoName{1} '__s' ];
	Comma = ', ';
end
for VarExoName = VarExoNames
	SteadyStateEquations = [ SteadyStateEquations VarExoName{1} '__s := 0; ' ];
end
SteadyStateEquations = [ SteadyStateEquations nl ];

AllLagsAndLeads = cell( 1, 0 );
SteadyStateEquationsTmp = cell( 1, 0 );

for i = 1:length( Equations )
	SFEquation = [ ' ' Equations{i} ' ' ];
	for Parameter = Parameters
		SFEquation = regexprep( SFEquation, [ '(?<=\W)' Parameter{1} '(?=\W)' ], [ '__' Parameter{1} '__' ] );
	end
	SFEquation = regexprep( SFEquation, '(?<=\W)log(?=\W)', 'ln' );
	SFEquation = regexprep( SFEquation, '\s', '' );
	SFEquation = regexprep( SFEquation, '=(.*)', '-($1)' );
	LagsAndLeads = unique( cellfun( @cellstr, regexp( SFEquation, '\w\(([+-]?\d+)\)', 'tokens' ) ) );
	AllLagsAndLeads = [ AllLagsAndLeads LagsAndLeads ];
	SteadyEquation = SFEquation;
	ProcessedEquation = SFEquation;
	for LagOrLead = LagsAndLeads
		NLagOrLead = strread( LagOrLead{1} );
		if NLagOrLead > 0
			ReplaceString = [ '__' repmat( 'f', 1, NLagOrLead ) ];
		else
			if NLagOrLead < 0
				ReplaceString = [ '__' repmat( 'b', 1, -NLagOrLead ) ];
			else
				ReplaceString = '';
			end
		end
		TLagOrLead =  regexptranslate( 'escape', LagOrLead{1} );
		ProcessedEquation = regexprep( ProcessedEquation, [ '(\w+)\(' TLagOrLead '\)' ], [ '$1' ReplaceString ] );
		SteadyEquation = regexprep( SteadyEquation, [ '(\w+)\(' TLagOrLead '\)' ], '$1' );
		TempVarNames = unique( [ TempVarNames cellfun( @cellstr, regexp( ProcessedEquation, [ '(\w+' ReplaceString ')' ], 'tokens' ) ) ] );

		for VarEndoName = VarEndoNames
			SteadyStateEquationsTmp = [ SteadyStateEquationsTmp [ VarEndoName{1} ReplaceString '__s := ' VarEndoName{1} '__s;' ] ];
		end
		for VarExoName = VarExoNames
			SteadyStateEquationsTmp = [ SteadyStateEquationsTmp [ VarExoName{1} ReplaceString '__s := 0;' ] ];
		end
	end
	ProcessedEquations{i} = ProcessedEquation;
	SteadyEquations{i} = SteadyEquation;
end

SteadyStateEquationsTmp = unique( SteadyStateEquationsTmp );

for SteadyStateEquationTmp = SteadyStateEquationsTmp
	SteadyStateEquations = [ SteadyStateEquations SteadyStateEquationTmp{1} ' ' ];
end
SteadyStateEquations = [ SteadyStateEquations nl ];

TempVarNamesList = '';
SteadyTempVarNamesList = '';
EvalLoc = '';
Comma = '';

for TempVarName = TempVarNames
	TempVarNamesList = [ TempVarNamesList ' ' TempVarName{1} ];
	SteadyTempVarNamesList = [ SteadyTempVarNamesList ' ' TempVarName{1} '__s' ];
	EvalLoc = [ EvalLoc Comma TempVarName{1} ' = ' TempVarName{1} '__s' ];
	Comma = ', ';
end

if nargin >= 7
	NewEvalString = [ ' ' EvalString ' ' ];
	for Parameter = Parameters
		NewEvalString = regexprep( NewEvalString, [ '(?<=\W)' Parameter{1} '(?=\W)' ], [ '__' Parameter{1} '__' ] );
	end
	for VarEndoName = VarEndoNames
		NewEvalString = regexprep( NewEvalString, [ '(?<=\W)' VarEndoName{1} '(?=\W)' ], [ VarEndoName{1} '__s' ] );
	end
	NewEvalString = regexprep( NewEvalString, '(?<=\W)log(?=\W)', 'ln' );
	NewEvalString = regexprep( NewEvalString, '\s', '' );	
	MuPADString = '';
	MuPADStringPrefix = [ SteadyStateEquations 'EvalLoc := { ' EvalLoc Comma NewEvalString ' };' nl ];
else
	MuPADString = '';
	MuPADStringPrefix = [ SteadyStateEquations 'EvalLoc := { ' EvalLoc ' };' nl ];
end


switch EvalMode
	case 1
		Prefix = 'simplify( ';
		Suffix = ' )';
	case 2
		Prefix = 'simplify( ';
		Suffix = ', IgnoreAnalyticConstraints )';
	case 3
		Prefix = 'float( ';
		Suffix = ' )';
	otherwise
		Prefix = '';
		Suffix = '';
end

if nargin >= 8
	MuPADStringPrefix = [ MuPADStringPrefix 'DIGITS := ' int2str( Digits ) ';' nl ];
end

MuPADStringSuffix = '';
Comma = '';

for i = 1:length( Equations )
	MuPADString = [ MuPADString 'eq__' int2str( i ) ' := ' Prefix 'evalAt( evalAt( ' ProcessedEquations{i} ' , EvalLoc ), EvalLocSteadyState )' Suffix ]; %#ok<*AGROW>
	for TempVarName = TempVarNames
		MuPADString = [ MuPADString ' + ' Prefix 'evalAt( evalAt( ' TempVarName{1} ' * diff( ' ProcessedEquations{i} ' , ' TempVarName{1} ' ), EvalLoc ), EvalLocSteadyState ) * ' lower( TempVarName{1} ) '__d' Suffix ];
	end
	MuPADString = [ MuPADString ';' nl ];
	MuPADStringSuffix = [ MuPADStringSuffix Comma 'eq__' int2str( i ) ];
	Comma = ', ';
end

if SolveMode > 0
	MuPADStringPrefix = [ MuPADStringPrefix 'EvalLocSteadyState := ' ];
	if SolveMode == 4
		MuPADStringPrefix = [ MuPADStringPrefix 'numeric::f' ];
	end
	MuPADStringPrefix = [ MuPADStringPrefix 'solve( evalAt( { ' ];
	Comma = '';
	for i = 1:length( Equations )
		MuPADStringPrefix = [ MuPADStringPrefix Comma SteadyEquations{i} ];
		Comma = ', ';
	end
	switch SolveMode
		case 2
			SolveOption = ', IgnoreAnalyticConstraints';
		case 3
			SolveOption = ', Real';
		otherwise
			SolveOption = '';
	end
	MuPADStringPrefix = [ MuPADStringPrefix ' }, EvalLoc ), { ' SteadyStateVars ' } ' SolveOption ' );' nl ];
else
	MuPADStringPrefix = [ MuPADStringPrefix 'EvalLocSteadyState := { };' nl ];
end
disp( 'MUPAD CODE USED:' );
MuPADString = regexprep( [ MuPADStringPrefix MuPADString '{ ' MuPADStringSuffix ' }' ], '\n+', '\n' );
disp( MuPADString );
eqs = evalin( symengine, MuPADString );
result = cell( size( eqs ) );
for i = 1:length( eqs )
	ResEq = char( eqs( i ) );
	for LagOrLead = AllLagsAndLeads
		NLagOrLead = strread( LagOrLead{1} );
		if NLagOrLead > 0
			ReplaceString = [ '__' repmat( 'f', 1, NLagOrLead ) ];
		else
			if NLagOrLead < 0
				ReplaceString = [ '__' repmat( 'b', 1, -NLagOrLead ) ];
			else
				ReplaceString = '';
			end
		end
		ResEq = regexprep( ResEq, [ '(\w+)' ReplaceString '__d' ], [ '$1__d(' LagOrLead{1} ')' ] );
	end
	for Parameter = Parameters
		ResEq = regexprep( ResEq, [ '__' Parameter{1} '__' ], Parameter{1} );
	end
	ResEq = regexprep( ResEq, '(?<=\W)ln(?=\W)', 'log' );
	result{i} = ResEq;
end
