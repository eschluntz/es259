%function [curve] = find_curve(Segs, Starts, Ends)
% find_curve given a set of segments, return the lowest cost density curve

    %%%%% constants
    A = 2;

    %%%%% data structures
    n_segs = size(Segs,1);
    W = DefaultDict(n_segs,200, inf); % W[s,l] = weight of lightest curve ending at (s,l)
    T = sparse(n_segs,200); % T[s,l] = pred. of s in lightest curve at (s,l)
    Q = PriorityQueue(false);
    min_seg = [0,0]; % used for termination criteria
    min_A_density = inf;

    % initialize structures
    for j = 1:size(Segs,1)

        % getting descriptions
        len = Segs(j,6);
        if len == 0
            disp('skipping taken');
            continue;
        end
        cost = seg_cost(Segs(j,:));

        % updating min
        if ((cost + A)/len < min_A_density)
            min_A_density = (cost + A) / len;
            min_seg = [j, len];
        end

        % saving
        insert(W,j,len,cost); % cost of 1 segment
        insert(Q, cost/len, [j, len]); % saving in queue
    end

    disp('done adding');
    % repeatedly add items
    while (true)

        % get min
        [density, key] = pop(Q);
        s = key(1);
        l = key(2);
        seg = Segs(s,:);

        % check termination criteria
        if min_A_density <= density
            break;
        end

        % add extensions
        s1 = Starts(seg(3),seg(4));
        s2 = Ends(seg(3),seg(4));
        for q = s1:s2
            q_seg = Segs(q,:);
            v = get(W,s,l) + bend_cost(seg, q_seg) + seg_cost(q_seg); % new cost
            k = l + q_seg(6); % new length

            % better?
            if (v < get(W,q,k))
                insert(W,q,k,v);
                T(q,k) = s;

                % best? updating min
                if (v + A) / k < min_A_density
                    disp('found best');
                    min_A_density = (v + A) / k;
                    min_seg = [q, k];
                end
                insert(Q, v/k, [q,k]);
            end
        end
    end

    % tracing best curve
    s = min_seg(1);
    curve = [];
    for l = min_seg(2):-1:1
        curve = [curve; Segs(s,:)];
        s = T(s,l);
    end

%end