%%  Hasan Hüseyin Sönmez - 01.10.2018
%   Online ownship motion generator

%   generates ownship states online, can be used with sensor control
%   feature. As sensor control vector is estimated during the target state
%   estimation process, ownship moves and collects bearing angles (or other
%   measurements).

%%  Inputs :
%               Xown        : previous ownship state
%               Ucontrol    : control vector u consisting ownship motion
%                               parameters for the next move.
%               model       : model parameters
%   Output :    OwnState    : New ownship state vector, will be used to collect
%                               measurements.

function OwnState = OnlineOwnship(Xown, Ucontrol, model)

Heading = Ucontrol(1);                  % ownship heading for the next step (deg)
Speed   = Ucontrol(2);                  % ownship speed for the next step (m/s)

vx = Speed*sin(Heading*pi/180);         % ownship velocity in x coordinate
vy = Speed*cos(Heading*pi/180);         % ownship velocity in y coordinate
Xown = [Xown(1), vx, Xown(3), vy]';     % modified ownship state

% new ownship state
OwnState = MarkovTransition(Xown, model, false);


end