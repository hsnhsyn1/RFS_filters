%%  Hasan Hüseyin Sönmez - 27.09.2018
%   Sampling particles from a given proposal distribution
%   or different sampling strategies

%%  Inputs:
%           xk_1    : current particles (from the previous cycle)
%           qk      : proposal distribution to sample from in the model
%           model   : parameters (if necessary), specifying sampling
%                       strategy


function Xki = SampleParticles(xk_1, model, varargin)

%%  qk -> Markov density
switch model.Sampling
    case 'bootstrap'
        if length(varargin) == 1
            Uk = varargin{1};
            Xki = MarkovDensity(model, xk_1, Uk);       % predicted particles
        else
            Xki = MarkovDensity(model, xk_1);
        end
end


end