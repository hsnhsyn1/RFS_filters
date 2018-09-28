%%  Hasan Hüseyin Sönmez - 29.09.2018
%   Generate measurement data

%%  Inputs:
%               gt      : ground truth data (targets, ownship, birth and
%                           death, etc)
%               model   : model parameters

function Measures = GenMeas(gt, model)

K = model.K;            % total number of scans/cycles
Measures.Z = cell(K,1); % initialize measurement structure

for k = 1:K
    % if any target is present
    if gt.N(k) > 0
        idx = find(rand(gt.N(k),1) <= compute_Pd(gt.X{k}, model) );         % if a target is detected
        tt = gt.X{k};
        o = gt.Ownship(:,k);
        x = tt - o;
        Measures.Z{k} = MeasFcn(x, model, true);      % generate measurement using appropriate model
    end
    Nc = poissrnd(model.Lambda);        % number of clutter points
    C = repmat(model.range_cz(:,1), [1 Nc]) + diag(model.range_cz*[-1;1])*rand(model.zDim, Nc);  % generate clutter points
    Measures.Z{k} = [Measures.Z{k}, C]; % measurement set at time k
end



end