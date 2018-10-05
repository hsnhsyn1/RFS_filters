%%  Hasan Hüseyin Sönmez - 29.09.2018
%   Generate measurement data

%%  Inputs:
%               gt      : ground truth data (targets, ownship, birth and
%                           death, etc)
%               model   : model parameters

function Measures = GenMeas(gt, model, Measures, k)

switch nargin
    %%  for online data generation
    case 4
        % if any target is present
        if gt.N(k) > 0
%             Pd = compute_Pd(gt.X{k}, gt.Ownship(:,k), model);
            Pd = model.pD;
            idx = find(rand(gt.N(k),1) <= Pd );         % if a target is detected
            tt = gt.X{k}(:,idx);                        % state of the targets
            o = gt.Ownship(:,k);                        % state of the ownship
            x = tt - o;                                 % relative target state
            Measures.Z{k} = MeasFcn(x, model, true);    % generate measurement using appropriate model
        end
        Nc = poissrnd(model.Lambda);        % number of clutter points
        C = repmat(model.range_cz(:,1), [1 Nc]) + diag(model.range_cz*[-1;1])*rand(model.zDim, Nc);  % generate clutter points
        Measures.Z{k} = [Measures.Z{k}, C]; % measurement set at time k
    case 2
        Measures.Z = cell(model.K,1);       % initialize measurement structure
        %% for batch data generation
        for k = 1:model.K
            % if any target is present
            if gt.N(k) > 0
%                 Pd = compute_Pd(gt.X{k}, gt.Ownship(:,k), model);
                Pd = model.pD;
                idx = find(rand(gt.N(k),1) <= Pd );         % if a target is detected
                tt = gt.X{k}(:,idx);                        % state of the targets
%                 o = gt.Ownship(:,k);                        % state of the ownship
%                 x = tt - o;                                 % relative target state
                Measures.Z{k} = MeasFcn(tt, model, true);    % generate measurement using appropriate model
            end
            Nc = poissrnd(model.Lambda);        % number of clutter points
            C = repmat(model.range_cz(:,1), [1 Nc]) + diag(model.range_cz*[-1;1])*rand(model.zDim, Nc);  % generate clutter points
            Measures.Z{k} = [Measures.Z{k}, C]; % measurement set at time k
        end
end


end