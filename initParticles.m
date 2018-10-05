%%  Hasan Hüseyin Sönmez - 04.10.2018
%   initialize particles

%%  otoher initialization schemes can be implemented, i.e. Metropolis-Hastings algorithm.

function x_init = initParticles(m, Q, own, Np, model)

x_init = zeros(model.xDim, Np);
for i = 1:Np
    x_init(:,i) = MarkovDensity(model, m, Q, own);       % predicted particles
end

end