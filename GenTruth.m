%%  Hasan H�seyin S�nmez - 29.09.2018
%   Generate Ground truth data

%%  Input   :
%               model   : the model parameters for ground truth data.
%%  Output  :
%               GTData  : ground truth data of target states/trajectory

function GTruth = GenTruth(model)

K = model.K;                                % number of scans

GTruth.X            = cell(K,1);            % ground truth target states
GTruth.L            = cell(K,1);            % labels of targets
GTruth.N            = zeros(K,1);           % number of targets in a cycle
GTruth.TotalTracks  = 0;                    % number of total appearing tracks
GTruth.trackList    = cell(K,1);            % index of track identities (?)
GTruth.Ownship      = zeros(model.xDim, K); % ownship trajectory

%%  target initial state(s)
xinit = cat(2,[8000; 3.6*sin(-130*pi/180); 0; 3.6*cos(-130*pi/180)]);

%%  observer initial state
oinit = [0; 2.57*sin(140*pi/180); 0; 2.57*cos(140*pi/180)];       % 5 knots, 140 deg
% obsvelsec = []
ownstate = oinit;
for k = 1:K
    if k < K/2
        ownstate = MarkovTransition(ownstate, model, false);        % noiseless state transition
    else
        % bodoslama leg �retimi...
        ownstate = MarkovTransition([ownstate(1); 2.57*sin(20*pi/180); ownstate(3); 2.57*cos(20*pi/180)],...
                                        model, false);
    end
        GTruth.Ownship(:,k) = ownstate;
end

%   birth and death times of each target
nbirths     = 1;       % number of total targets
tbirth(:)   = 5;       % birth times of each target
tdeath(:)   = K-10;    % death times of each target

for tnum = 1:nbirths   % for each target
    targetstate = xinit(:,tnum);        % target initial state
    for k = tbirth(tnum):min(tdeath(tnum),K)
        targetstate = MarkovTransition(targetstate, model, false);      % transition of the state
        GTruth.X{k} = [GTruth.X{k}, targetstate];
        GTruth.trackList{k} = [GTruth.trackList{k}, tnum];              % target index
        GTruth.N(k) = GTruth.N(k) + 1;                                  % 
    end
end

%% keep them for measurement generation
GTruth.TotalTracks = nbirths;
GTruth.tdeath = tdeath;
GTruth.tbirth = tbirth;


end