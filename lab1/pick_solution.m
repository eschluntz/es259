function [ S, valid ] = pick_solution(limits, slns)
%pick_solution given a set of solutions, validates and picks the best one
% valid is true iff there is at least one valid solution
% limits = [m x 2]
% slns = [m x n]
    n = size(slns,2); % number of solutions to check
    m = size(slns,1); % number of dimensions
    valid = false;
    mag = Inf;
    S = zeros(m,1);
    for i = 1:n
        if (all(slns(:,i) > limits(:,1)) && all(slns(:,i) < limits(:,2)))
            valid = true;
            if norm(slns(:,i)) < mag
                S = slns(:,i);
                mag = norm(slns(:,i));
            end
        end
    end
end

