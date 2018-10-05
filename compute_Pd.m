%%  Hasan Hüseyin Sönmez - 28.09.2018
%   state dependent probability of detection
%   used in measurement generation


function Pd = compute_Pd(x, own, model)

if isempty(x)
    Pd = [];
else
    pd      = model.pD;
    mid     = [own(1); own(3)];
    Cov     = diag([model.MaxRange, model.MaxRange].^2);        % related to target range
    
    Nt = size(x,2);         % number of targets/particles
    point = x([1 3],:);     % position components of target states
    esq = sum( (diag(1./diag(sqrt(Cov)))*(point-repmat(mid,[1 Nt]))).^2 );
    
    Pd = pd*exp(-esq/2);
    Pd = Pd(:);
%     Pd = model.pD;

end