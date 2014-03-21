
%RBFFUN Compute the value of the hidden nodes of an RBF network using the
%Gaussian kernel.
%
%   H = RBFFUN(P, IW, BIAS) takes P, an Nxd input matrix, where N is the
%   number of observations and d their dimensionality; IW, an Nhxd matrix
%   of weights, where Nh is the number of hidden nodes; and BIAS, an 1xNh
%   vector of biases for the hidden nodes. It returns an NxNh matrix H of
%   values computed at the hidden nodes. The value Hij is computed as:
%
%       Hij = exp(-bias(j)*sum(p(i,:) - iw(j))^2)
%

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Copyright: Prof. Guang Huang Bin.

function H = rbffun(P,IW,Bias)

%%%%%%%% RBF network using Gaussian kernel
ind=ones(size(P,1),1);
for i=1:size(IW,1)
    Weight=IW(i,:);         
    WeightMatrix=Weight(ind,:);
    V(:,i)=-sum((P-WeightMatrix).^2,2);    
end
BiasMatrix=Bias(ind,:);
V=V.*BiasMatrix;
H=exp(V);