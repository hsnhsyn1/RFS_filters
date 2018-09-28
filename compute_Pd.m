%%  Hasan Hüseyin Sönmez - 28.09.2018
%   state dependent probability of detection
%   used in measurement generation


function Pd = compute_Pd(x, model)

if isempty(x)
    Pd = [];
else
    ps      = model.ps;
    mid     = [0; 0];
    Cov     = diag([2000, 2000].^2);        % related to some "max range or range noise" (?)
    
    Nt = size(x,2);         % number of targets
    point = x([1 3],:);     % position components of target states
    esq = sum( (diag(1./diag(sqrt(Cov)))*(point-repmat(mid,[1 Nt]))).^2 );
    
    Pd = ps*exp(-esq/2);
    Pd = Pd(:);

end