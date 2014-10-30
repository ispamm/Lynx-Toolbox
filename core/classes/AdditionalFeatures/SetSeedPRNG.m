% SetSeedPRNG - Set the seed of the PRNG of Matlab
%   Add it to the simulation as:
%   add_feature(SetSeedPRNG(s)), where s is the seed.

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
%
% Programmed and Copyright by Simone Scardapane:
% simone.scardapane@uniroma1.it

classdef SetSeedPRNG < AdditionalFeature

    properties
        seed;   % Initial seed to set
    end
    
    methods
        function obj = SetSeedPRNG(s)
            obj.seed = s;
        end
        
        function executeBeforeInitialization(obj)
            rng(obj.seed);
        end

        function s = getDescription(~)
            s = 'Fix the seed of the PRNG';
        end
    end
    
end

