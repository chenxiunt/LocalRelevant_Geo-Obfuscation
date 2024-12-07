function [z, z_fval, z_fval_l, z_fval_u, nr_LR_loc, nr_constraints, obf_range, obf_nr_dec, running_time] = LRobfmatrix_generator(coordinate, EPSILON, NR_LOC, R, CPR_prior_prob, node_index, Gamma, OBF_THRESHOLD, GRID_SIZE)
    longitude = coordinate(:, 1); 
    latitude = coordinate(:, 2); 
    longitude = longitude';
    latitude = latitude';



    %% Create distance matrix, identify the GeoI neighbors and craete the corresponding GeoI graph
    distance_matrix = zeros(NR_LOC, NR_LOC);                                % Distance between each pair of coordinates 
    GeoI_neighbor = ones(NR_LOC, NR_LOC)*999;                                  % Record the GeoI neighbors
    for i = 1:1:NR_LOC
        for j = 1:1:NR_LOC
            [distance_matrix(i,j), ~, ~] = haversine([longitude(1, i), latitude(1, i)], [longitude(1, j), latitude(1, j)]); % Calculate the Haversine distance between locations
            if distance_matrix(i,j) <= R
                GeoI_neighbor(i, j) = distance_matrix(i,j);
            end
        end
    end
    G_GeoI = digraph(GeoI_neighbor);                                        % Create the GeoI graph using the GeoI_neighbor

    %% Identify the Local Relevant locations
    LR_location = zeros(1, NR_LOC);
    for i = 1:1:NR_LOC
        [~, distance] = shortestpath(G_GeoI, node_index, i);                % Find the path distance from the current node to node i
        if distance <= Gamma                                                % If the path distance from the current node to node i is no larger than Gamma, 
            LR_location(1, i) = 1;                                          % consider node i as a local relevant location
        end
    end 
    nr_LR_loc = sum(LR_location);                                           % Number of local relevant locations
    



    GeoI_matrix = sparse(NR_LOC*(NR_LOC-1)*NR_LOC, NR_LOC*NR_LOC); 
    row_indx = 1;
    for i = 1:1:NR_LOC
        for j = i+1:1:NR_LOC
            if LR_location(1, i) == 1 && LR_location(1, j) == 1
 %               [i j]
                if distance_matrix(i,j) < R
                    for k = 1:1:NR_LOC
                         if distance_matrix(i,j) <= R
                            GeoI_matrix(row_indx, (i-1)*NR_LOC+k) = 1;               
                            GeoI_matrix(row_indx, (j-1)*NR_LOC+k) = -exp(EPSILON*distance_matrix(i,j));
                            row_indx = row_indx + 1;
        
                            GeoI_matrix(row_indx, (j-1)*NR_LOC+k) = 1;
                            GeoI_matrix(row_indx, (i-1)*NR_LOC+k) = -exp(EPSILON*distance_matrix(i,j));
                            row_indx = row_indx + 1;
                         end
                    end
                end
            end
        end
    end
    nr_constraints = row_indx;
    b = zeros(NR_LOC*(NR_LOC-1)*NR_LOC, 1); 
    
    %% Equality constraint Aeq, beq

    % Probablity unit measure
    Aeq = sparse(NR_LOC, NR_LOC*NR_LOC); 
    beq = ones(NR_LOC, 1); 
    
    for k = 1:1:NR_LOC
        for l = 1:1:NR_LOC
            Aeq(k, (k-1)*NR_LOC + l) = 1;
        end
    end
    
    %% Each z is in the range of [0, 1]
	lb = ones(NR_LOC*NR_LOC,1)*0;
    ub = ones(NR_LOC*NR_LOC,1);
    
    %% Objective function: 
    % objective: sum_{k,l} sum_n CPR_prior_prob(k, 1)*abs(distance_{obfuscated location l to destination n} - distance__{real location k to destination n}) z_{k,l}
    % => the coefficint for each z_{k,l} is: sum_n CPR_prior_prob(k, 1)*abs(distance_{obfuscated location l to destination n} - distance__{real location k to destination n})
    f = zeros(NR_LOC*NR_LOC, 1);
	for k = 1:1:NR_LOC
        for l = 1:1:NR_LOC
            f((k-1)*NR_LOC + l, 1) = 0;
            for j = 1:1:NR_LOC
                % calculate the distance from the obfuscated location l to
                % location j
                distance_l = sqrt((longitude(l) - longitude(j))^2 + (latitude(l) - latitude(j))^2);
                % calculate the distance from the real location k to the
                % location j
                distance_k = sqrt((longitude(k) - longitude(j))^2 + (latitude(k) - latitude(j))^2);
                % add the distance error to the coefficient for z_{k, l}
                f((k-1)*NR_LOC + l, 1) = f((k-1)*NR_LOC + l, 1) + abs(distance_l - distance_k); 
            end
            f((k-1)*NR_LOC + l, 1) = max([f((k-1)*NR_LOC + l, 1)*CPR_prior_prob(k, 1), 0]); 
        end     
    end

    %% CRT table



    for i = 1:1:ceil(max(longitude)/GRID_SIZE)
        for j = 1:1:ceil(max(latitude)/GRID_SIZE)
            grid_longitude(i, j) = (i-1)*GRID_SIZE; 
            grid_latitude(i, j) = (j-1)*GRID_SIZE; 
        end
    end
    grid_longitude = reshape(grid_longitude, size(grid_longitude, 1)*size(grid_longitude, 2), 1); 
    grid_latitude = reshape(grid_latitude, size(grid_latitude, 1)*size(grid_latitude, 2), 1); 
%     for k = 1:1:size(grid_longitude, 1)
%         for l = 1:1:size(grid_longitude, 1)
%             CRT((k-1)*size(grid_longitude, 1) + l, 1) = 0;
%             for j = 1:1:NR_LOC
%                 % calculate the distance from the obfuscated location l to
%                 % location j
%                 distance_l = sqrt((grid_longitude(l) - longitude(j))^2 + (grid_latitude(l) - latitude(j))^2);
%                 % calculate the distance from the real location k to the
%                 % location j
%                 distance_k = sqrt((grid_longitude(k) - longitude(j))^2 + (grid_latitude(k) - latitude(j))^2);
%                 % add the distance error to the coefficient for z_{k, l}
%                 CRT((k-1)*size(grid_longitude, 1) + l, 1) = CRT((k-1)*size(grid_longitude, 1) + l, 1) + abs(distance_l - distance_k); 
%             end
%         end     
%     end
%     CRT = CRT/133; 
    %% CRT errors
    z_fval_ = 0;
    f_l = zeros(NR_LOC*NR_LOC, 1); 
    f_u = zeros(NR_LOC*NR_LOC, 1);
	for k = 1:1:NR_LOC
        for l = 1:1:NR_LOC
            longitude_(l) = round(longitude(l)/GRID_SIZE) * GRID_SIZE;
            longitude_(k) = round(longitude(k)/GRID_SIZE) * GRID_SIZE;

            latitude_(l) = round(latitude(l)/GRID_SIZE) * GRID_SIZE;
            latitude_(k) = round(latitude(k)/GRID_SIZE) * GRID_SIZE;
            distance_l_ = sqrt((longitude_(l) - longitude(l))^2 + (latitude_(l) - latitude(l))^2);
            distance_k_ = sqrt((longitude_(k) - longitude(k))^2 + (latitude_(k) - latitude(k))^2);
            for j = 1:1:NR_LOC
                % calculate the distance from the obfuscated location l to
                % location j
                distance_l = sqrt((longitude_(l) - longitude(j))^2 + (latitude_(l) - latitude(j))^2);
                % calculate the distance from the real location k to the
                % location j
                distance_k = sqrt((longitude_(k) - longitude(j))^2 + (latitude_(k) - latitude(j))^2);     
                % add the distance error to the coefficient for z_{k, l}
%                 [abs(distance_l - distance_k) distance_l_ distance_k_]
                f_l((k-1)*NR_LOC + l, 1) = f_l((k-1)*NR_LOC + l, 1) + max([abs(distance_l - distance_k)- distance_l_ - distance_k_, 0])*CPR_prior_prob(k, 1); 
                f_u((k-1)*NR_LOC + l, 1) = f_u((k-1)*NR_LOC + l, 1) + (abs(distance_l - distance_k) + distance_l_ + distance_k_)*CPR_prior_prob(k, 1); 
            end
        end 
    end


    options = optimoptions('linprog','Algorithm','dual-simplex');
%     options.Preprocess = 'none';

    
    z_fval_l = 0;
    z_fval_u = 0;
    tic
    [z, z_fval] = linprog(f, A, b, Aeq, beq, lb, ub, options);                       % Represent obfuscation matrix Z by a vector z, where each z_{i,j} -> z((i-1)*NR_LOC + j)
    running_time = toc; 
    %     [z_l, z_fval_l] = linprog(f_l, A, b, Aeq, beq, lb, ub, options);                       % Represent obfuscation matrix Z by a vector z, where each z_{i,j} -> z((i-1)*NR_LOC + j)
%     z_fval_u = f'*z_l;                       % Represent obfuscation matrix Z by a vector z, where each z_{i,j} -> z((i-1)*NR_LOC + j)    
    %% 
    
    distance_reshape = reshape(distance_matrix, NR_LOC*NR_LOC, 1); 
%     plot(distance_reshape, z, 'o'); 

    [distance_reshape_sort, idx_reshape] = sort(distance_reshape); 
    z_sort = z(idx_reshape); 
    z_sort_acc = cumsum(z_sort);
    z_sort_acc = z_sort_acc/max(z_sort_acc); 
%     plot(distance_reshape_sort, z_sort_acc); 

    for i = 1:1:NR_LOC*NR_LOC
        if z_sort_acc(i) >= 1-OBF_THRESHOLD
            obf_range = distance_reshape_sort(i); 
            obf_nr_LR_loc = i; 
            break; 
        end
    end


    z = reshape(z, NR_LOC, NR_LOC);                                         % reshape the obfuscation vector to matrix
    z = z'; 
    f_ = reshape(f, NR_LOC, NR_LOC); 
    f_ = f_';

end

