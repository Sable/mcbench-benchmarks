function [nn,l]=Sellmeier(l,varargin)
    % Sellmeier formula for refractive index (BETA)
    %
    % Syntax:
    %      n = Sellmeier(l,offset,lambdas,coeff)
    %      n = Sellmeier(l,offset,lambdas,coeff,temp)
    %      [n,ll] = Sellmeier(l,'datafile.mat')
    %      [n,ll] = Sellmeier(l,'datafile.mat',oc_flag)
    %      [n,ll] = Sellmeier(l,data_struct)
    %      [n,ll] = Sellmeier(l,data_struct,oc_flag)
    %
    % Utility to compute the refractive index of materials as function of
    % wavelength. The refractive index is computed through the Sellmeier-
    % like formula:
    %       n(l)^2 = A + c1*(l^2)/(l^2-L1^2) + c2*(l^2)/(l^2-L2^2) + ...,
    % where l is the operation wavelength, A,c1,c2,...,cN are the N
    % Sellmeier coefficients and L1,L2,...,LN are the n Sellmeier
    % wavelengths.
    % 
    % There are three different input methods for the coefficients: passing
    % the parameters directly, using a data structure, using a .MAT file
    % (sadly, the .MAT file is not implemented yet).
    % 
    % To use the values directly, one must provide the scalar offset, which
    % is the value of constant A in the Sellmeier equation shown above;
    % lambdas is a vector containing the Sellmeier wavelengths and coeff
    % are the coefficients. It is clear that size(lambdas)==size(coeff).
    % The (unknown) variable temp, will be used in future versions to
    % introduce temperature dependence. The operating wavelength can be
    % an scalar or a vector.
    %
    % The data structure is a better approach, given that it contains more
    % information about the expansion. The structure is as follows:
    %
    %       field           type
    %       ---------------------------------------------
    %       validation      fixed string: 'ri_data'
    %       label           string
    %       formula         string
    %       l_min           double scalar
    %       l_max           double scalar
    %       offset          double scalar
    %       lambdas         double vector of length N
    %       coeff           double vector of length N
    %       reference       string
    %
    % The validation field is used as a tag to identify if the data
    % structure is valid (will be deprecated in future versions). The value
    % of label and formula is a string to identify the material (and it is
    % used to label the refractive index plot, see below). The variables
    % l_min and l_max are used to specify the range of validity of the
    % Sellmeier formula. offset, lambdas and coeff are as in the previous
    % case. The reference string is to cite the source material.
    %
    % When using the data structure, it is possible to use the auto axis
    % feature. If l=-1, then the function will return the computed
    % refractive indices and the vector ll, which span in the wavelength
    % range specified by l_min and l_max. If l=[-1 M], then length(ll)==M;
    % if M is omited, then length(ll)==100 by default.
    % The oc_flag is included to allow the computation of refractive
    % indices beyond the range of validity. If oc_flag==true, then the
    % computation is allowed, if oc_flag==false it is not. The default
    % value is false.
    %
    % If no output argument is specified, the function will plot the
    % refractive index whenever the index was computed for a range of
    % wavelengths.
    %
    % (Coded and tested using MATLAB R2009a 32-bits)
    % Code by: M. Sc. D. L. Romero-Antequera
    % The author can be reached at: dromero@susu.inaoep.mx
    %                               dlromero@creol.ucf.edu
    
    if nargin<=1
        error('Wrong input arguments');
    end
    l=l(:);
    
    temp=cell2mat(varargin(1));
    switch class(temp)
        case 'double'       % === Normal operation mode
            if nargin<4
                error('Wrong input arguments: l,offset,lambdas,coeff[,temp]');
            elseif nargin<5
                % Retrieving parameters
                offset=cell2mat(varargin(1));
                lambdas=cell2mat(varargin(2));
                coeff=cell2mat(varargin(3));
                % Consistency checking
                check=(~isnumeric(offset))||(~isscalar(offset));
                check=check||(~isnumeric(lambdas))||(~isvector(lambdas));
                check=check||(~isnumeric(coeff))||(~isvector(coeff));
                if check
                    error('Wrong input argument types');
                end
                if length(lambdas)~=length(coeff)
                    error('coeff and lambdas must have the same length');
                end
            elseif nargin==5
                error('Temperature dependence not implemented (yet)');
            else
                error('Wrong input arguments: l,offset,lambdas,coeff[,temp]');
            end
            temp_title='';
            
        case 'char'
            error('datafile not implemented (yet)');
            
        case 'struct'
            if (~isfield(temp,'validation'))||strcmp(temp.validation,'ri_data')
                error('invalid data structure');
            end
            lmin=temp.l_min;
            lmax=temp.l_max;
            if l(1)==-1         % Autolength
                if ~isscalar(l)
                    npoints=l(2);
                else
                    npoints=100;
                end
                l=linspace(lmin,lmax,npoints);
            else
                oc_flag=false;
                if nargin==3
                    oc_flag=cell2mat(varargin(2));
                end
                if (~oc_flag)&&((min(l)<lmin)||(max(l)>lmax))
                    error('l vector is beyond validity of approximation');
                end
            end
            offset=temp.off;
            lambdas=temp.lambdas;
            coeff=temp.coeff;
            temp_title=[ temp.label ' (' temp.formula ')' ];
    end
            
	% Computing grids
	lambdas=lambdas(:); coeff=coeff(:);
	[foo, Lambdas]=meshgrid(l.^2,lambdas.^2);
	[L Coeff]=meshgrid(l.^2,coeff);
    clear('foo');
    
    % Computation of refractive index
    nni = Coeff.*L./(L-Lambdas);
    nn=sqrt(offset+sum(nni));
    
    % If no output arguments, plot the refractive index
    if (nargout==0)&&(length(ll)>1)
        plot(l,nn,'.-'); title(temp_title);
        xlabel('\lambda (wavelength)'); ylabel('Refractive Index');
    end
end