
%KERNEL_MATRIX Compute the kernel matrix for several widely used kernels.
%
%   OMEGA = KERNEL_MATRIX(XTR, KTYPE, KPARS) takes an Nxd input matrix XTR,
%   where N is the number of observations and d their dimensionality; a
%   string KTYPE identifying the kernel (rbf, lin, poly, wav), a vector
%   KPARS with the kernel parameters. It returns a NxN matrix OMEGA
%   containing the values of the kernel evaluated on the i-th and j-th
%   point.
%
%   OMEGA = KERNEL_MATRIX(XTR, KTYPE, KPARS, XTS) takes an additional Mxd
%   testing matrix XTS. It returns an MxN kernel matrix OMEGA, where the
%   ij-element is computed on the i-th element of XTS and the j-th element
%   of XTR.
%
%   The kernels are defined as follows:
%
%       rbf [1 parameter]:      k(x,y) = exp(-par(1)*||x-y||^2)
%       lin [no parameters]:    k(x,y) = x'*y
%       poly [1 parameter]:     k(x,y) = (x'*y)^par(1)
%       wav [3 parameters]:     see "Wavelet Support Vector Machine" on
%                               IEEE Trans. on SMC, Part B.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Copyright: Prof. Guang Huang Bin. Modified by Simone Scardapane.

function omega = kernel_matrix(Xtrain,kernel_type, kernel_pars,Xt)

nb_data = size(Xtrain,1);

if(isa(Xtrain, 'gpuArray'))
    gpuEnabled = true;
else
    gpuEnabled = false;
end

if strcmp(kernel_type,'rbf'),
    if nargin<4,
        if(gpuEnabled)
            XXh = sum(Xtrain.^2,2)*gpuArray.ones(1,nb_data);
        else
            XXh = sum(Xtrain.^2,2)*ones(1,nb_data);
        end
        omega = XXh+XXh'-2*(Xtrain*Xtrain');
        omega = exp(-kernel_pars(1)*omega);
    else
        if(gpuEnabled)
            XXh1 = sum(Xtrain.^2,2)*gpuArray.ones(1,size(Xt,1));
            XXh2 = sum(Xt.^2,2)*gpuArray.ones(1,nb_data);
        else
            XXh1 = sum(Xtrain.^2,2)*ones(1,size(Xt,1));
            XXh2 = sum(Xt.^2,2)*ones(1,nb_data); 
        end
        omega = XXh1+XXh2' - 2*Xtrain*Xt';
        omega = exp(-kernel_pars(1)*omega);
    end
    
elseif strcmp(kernel_type,'lin')
    if nargin<4,
        omega = Xtrain*Xtrain';
    else
        omega = Xtrain*Xt';
    end
    
elseif strcmp(kernel_type,'poly')
    if nargin<4,
        omega = (Xtrain*Xtrain').^kernel_pars;
    else
        omega = (Xtrain*Xt').^kernel_pars;
    end
    
elseif strcmp(kernel_type,'wav')
    if nargin<4,
        if(gpuEnabled)
            XXh = sum(Xtrain.^2,2)*gpuArray.ones(1,nb_data);
        else
            XXh = sum(Xtrain.^2,2)*ones(1,nb_data);
        end
        omega = XXh+XXh'-2*(Xtrain*Xtrain');
        
        if(gpuEnabled)
            XXh1 = sum(Xtrain,2)*gpuArray.ones(1,nb_data);
        else
            XXh1 = sum(Xtrain,2)*ones(1,nb_data);
        end
        omega1 = XXh1-XXh1';
        omega = cos(kernel_pars(3)*omega1./kernel_pars(2)).*exp(-omega./kernel_pars(1));
        
    else
        if(gpuEnabled)
            XXh1 = sum(Xtrain.^2,2)*gpuArray.ones(1,size(Xt,1));
            XXh2 = sum(Xt.^2,2)*gpuArray.ones(1,nb_data);
        else
            XXh1 = sum(Xtrain.^2,2)*ones(1,size(Xt,1));
            XXh2 = sum(Xt.^2,2)*ones(1,nb_data);
        end
        
        omega = XXh1+XXh2' - 2*(Xtrain*Xt');
        
        if(gpuEnabled)
            XXh11 = sum(Xtrain,2)*gpuArray.ones(1,size(Xt,1));
            XXh22 = sum(Xt,2)*gpuArray.ones(1,nb_data);
        else
            XXh11 = sum(Xtrain,2)*ones(1,size(Xt,1));
            XXh22 = sum(Xt,2)*ones(1,nb_data);
        end
        omega1 = XXh11-XXh22';
        
        omega = cos(kernel_pars(3)*omega1./kernel_pars(2)).*exp(-omega./kernel_pars(1));
    end
end