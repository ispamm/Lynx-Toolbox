function varargout = get_next_prns( func, sizes )
% get_next_prns - Preview the next pseudo-random numbers
%   This can be used to obtain the next random numbers from a given
%   function, while at the same time keeping the state of the PRNG. Useful
%   for testing purposes.
%
%   NUMBERS = GET_NEXT_PRNS(FUNC, N) returns the next N numbers from the
%   function FUNC, then restores the PRNG state.

state = rng;
varargout = cell(length(sizes), 1);
for ii = 1:length(sizes)
    varargout{ii} = func(sizes{ii});
end
rng(state);


end

