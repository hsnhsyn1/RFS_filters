%%  Hasan Hüseyin Sönmez - 02.10.2018
%   computes the probability of survival of the particles
%   can be implemented depending on the state


function pS = compute_Ps(x, model)

if isempty(x)
    pS = [];
else
    pS = model.ps*ones(size(x,2),1);
    pS = pS(:);
end
