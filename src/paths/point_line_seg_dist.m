%function [distSq] = point_line_seg_dist(a, b, p)
a = [1,1; 1,1; 1,1];
b = [2,1; 2,1; 2,1];
p = [2.5,2; 2.5,2; 2.5,2;];

% getting projections onto (ab)
p_status = dot(b-a, p-a)/normSq(b-a);
distSq = zeros(size(p_status));

% finding cases
id_left = p_status < 0; % indices beyond a
id_right = p_status > 1; % indices beyond b
id_mid = ~id_left && ~id_right; % indices in middle

% filling in
distSq(id_left) = normSq(p(id_left,:) - a(id_left,:));
distSq(id_right) = normSq(p(id_right,:) - b(id_right,:));

p_proj = p_status * (b-a) + a;
distSq(id_mid) = normSq(p(id_mid,:) - p_proj(id_right,:));
%end