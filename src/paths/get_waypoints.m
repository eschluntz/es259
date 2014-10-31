function [ waypoints ] = get_waypoints( pred, nodes, s, f)
%get_waypoints turns a predecessor map into a list of waypoints
    waypoints = nodes(f,:);
    while s ~= f
        f = pred(f);
        waypoints = [nodes(f,:); waypoints];
    end
end

