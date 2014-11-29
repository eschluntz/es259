%function [curve] = find_curve(Segs, Starts, Ends)
% find_curve given a set of segments, return the lowest cost density curve

    %%%%% constants
    A = 10;

    %%%%% data structures
    n_segs = size(Segs,1);
    W = sparse(n_segs,200); % W[s,l] = weight of lightest curve ending at (s,l)
    T = sparse(n_segs,200); % T[s,l] = pred. of s in lightest curve at (s,l)
    key2idx = sparse(n_segs,200); % used to convert keys to idx in queue
    idx2key = zeros(n_segs,2); % go from idx back to key
    Q = pq_create(n_segs*10);
    new_idx = 1; % used for incrementing
    min_seg = [0,0]; % used for termination criteria
    min_cost = inf;

    %{
    mex myqueue_1.1/pq_create.cpp; 
    mex myqueue_1.1/pq_push.cpp; 
    mex myqueue_1.1/pq_pop.cpp; 
    mex myqueue_1.1/pq_size.cpp; 
    mex myqueue_1.1/pq_top.cpp;
    mex myqueue_1.1/pq_delete.cpp;
    %}

    % initialize structures
    for j = 1:size(Segs,1)

        % getting descriptions
        len = Segs(j,6);
        cost = seg_cost(Segs(j,:));
        key2idx(j,len) = new_idx;
        idx2key(new_idx,:) = [j,len];

        % updating min
        if (cost < min_cost)
            min_cost = cost;
            min_seq = [j, len];
        end

        % saving
        W(j,len) = cost; % cost of 1 segment
        if len ~= 0
            disp('pushing');
            pq_push(Q, new_idx, cost/len); % saving in queue
        end
        new_idx = new_idx + 1;
    end

    % repeatedly add items
    while (true)

        % get min
        disp('popping');
        [idx, density] = pq_pop(Q);
        s = idx2key(idx,1);
        l = idx2key(idx,2);
        seg = Segs(s,:);

        % check termination criteria
        if (min_cost + A) / min_seg(2) <= density
            break;
        end

        % add extensions
        s1 = Starts(seg(1),seg(2));
        s2 = Ends(seg(1),seg(2));
        for q = s1:s2
            q_seg = Segs(q,:);
            v = W(s,l) + bend_cost(seg, q_seg) + seg_cost(q_seg); % new cost
            k = l + q_seg(6); % new length

            % better?
            if (v < W(q,k))
                W(q,k) = v;
                T(q,k) = s;

                % best? updating min
                if (v < min_cost)
                    min_cost = v;
                    min_seq = [q, k];
                end

                key2idx(q,k) = new_idx;
                idx2key(new_idx,:) = [q,k];
                pq_push(Q, new_idx, v/k);
                new_idx = new_idx + 1;
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