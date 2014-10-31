function [distSq] = point_line_seg_dist(a, b, p)

    % getting projections onto (ab)
    p_status = sum((b-a).* (p-a),2)./normSq(b-a);
    distSq = zeros(size(p_status));

    % finding cases
    id_left = p_status < 0; % indices beyond a
    id_right = p_status > 1; % indices beyond b
    id_mid = logical((p_status > 0) .* (p_status < 1)); % indices in middle

    % filling in
    distSq(id_left) = normSq(p(id_left,:) - a(id_left,:));
    distSq(id_right) = normSq(p(id_right,:) - b(id_right,:));

    p_proj = repmat(p_status,1,2) .* (b-a) + a;
    distSq(id_mid) = normSq(p(id_mid,:) - p_proj(id_mid,:));
end