% RandomVectorFunctionalLink - Random-Vector Functional Link (RVFL)
%   A RVFL model consists of a linear combination of a fixed number of
%   non-linear expansions of its input. Parameters of the non-linear
%   expansions are generated randomly, see:
%
%   [1] Igelnik, B., & Pao, Y. H. (1995). Stochastic choice of basis 
%   functions in adaptive function approximation and the functional-link 
%   net. Neural Networks, IEEE Transactions on, 6(6), 1320-1329.
%
%   Note that, practically, this class serves as an alias for the
%   ExtremeLearningMachine class.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef RandomVectorFunctionalLink < ExtremeLearningMachine
    
    methods
        function obj = RandomVectorFunctionalLink(id, name, varargin)
            obj = obj@ExtremeLearningMachine(id, name, varargin{:});
        end
    end
    
    methods(Static)
        
        function info = getDescription()
            info = ['Random Vector Functional-Link, serves as an alias for the ExtremeLearningMachine class'];
        end
        
    end
    
end

