function [ waypoints ] = smaller_steps(wps, max_d)
%smaller_steps takes a list of waypoints and fleshes it out
% so that there are no large gaps between waypoints
    waypoints = [];
    for i = 2:size(wps,1)
        N = ceil(norm(wps(i-1,:) - wps(i,:)) / max_d);
        waypoints = [waypoints; ...
            [linspace(wps(i-1,1),wps(i,1),N)', linspace(wps(i-1,2),wps(i,2),N)']
            ];
    end
end

