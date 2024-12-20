classdef User
    properties
        loc_ID
        longitude 
        latitude 
        LR_loc_size
        LR_loc_ID
        obf_range
        obf_loc_ID
        neighbor_threshold
        distance_matrix_LR                                                  % Distance between locally relevant locations
        distance_matrix_LR2all
        distance_matrix_LR2obf
        cost_matrix_upper
        cost_matrix_lower
        cost_matrix_whole
        obfuscation_matrix
    end

    methods
        %% Constructor 
        function this = User(NODE_IDX, LR_LOC_SIZE, OBF_RANGE, NEIGHBOR_THRESHOLD, env_parameters)
            this.loc_ID = NODE_IDX;
            this.longitude = env_parameters.longitude_selected(NODE_IDX); 
            this.latitude = env_parameters.latitude_selected(NODE_IDX);
            this.LR_loc_size = LR_LOC_SIZE;
            this.LR_loc_ID = [];
            this.obf_range = OBF_RANGE; 
            this.neighbor_threshold = NEIGHBOR_THRESHOLD; 
            this.distance_matrix_LR = zeros(LR_LOC_SIZE, LR_LOC_SIZE);
            this.cost_matrix_upper = [];
            this.cost_matrix_whole = [];
        end

        %% Function: Initialize the users' properties
        function this = initialization(this, env_parameters)
            this = this.LR_identifier(env_parameters);                      % Identify the LR location IDs
            this = this.distance_matrix_LR_cal(env_parameters);             % Calculate the distance between LR locations
            this = this.obf_identifier(env_parameters);                     % Identify the obfuscated location IDs
            this = this.distance_matrix_LR2all_cal(env_parameters);         % Calculate the distance from LR locations to all the locations
            this = this.distance_matrix_LR2obf_cal();                       % Calculate the distance from LR locations to obfuscated locations
            this = this.cost_matrix_whole_cal(env_parameters); 
            % this = this.cost_matrix_cal(env_parameters);                    % Calculate the cost matrix
        end
        
        %% Function: Identify the local relevant location
        function this = LR_identifier(this, env_parameters)                             
            [~, distance] = shortestpathtree(env_parameters.G_mDP, this.loc_ID);            
            LR_ID_range = find(distance < env_parameters.GAMMA);                
            LR_loc_ID_ = randsample(size(LR_ID_range, 2), this.LR_loc_size); % Sample the set of relevant locations
            % LR_loc_ID_ = 1:1:this.LR_loc_size; 
            this.LR_loc_ID = LR_ID_range(LR_loc_ID_); 
        end

        %% Function: Calculate the distance matrix of the local relevant locations
        function this = distance_matrix_LR_cal(this, env_parameters)
            for s = 1:1:this.LR_loc_size
                for t = 1:1:this.LR_loc_size
                    [~, path_distance] = shortestpath(env_parameters.G_mDP, s, t); 
                    this.distance_matrix_LR(s, t) = path_distance; 
                    % loc_i = [env_parameters.longitude_selected(this.LR_loc_ID(1, i), 1), env_parameters.latitude_selected(this.LR_loc_ID(1, i), 1)]; 
                    % loc_j = [env_parameters.longitude_selected(this.LR_loc_ID(1, j), 1), env_parameters.latitude_selected(this.LR_loc_ID(1, j), 1)];
                    % [this.distance_matrix_LR(i,j), ~, ~] = haversine(loc_i, loc_j); % Calculate the Haversine distance between locations
                end
            end
        end

        %% Function: Calculate the distance matrix from the local relevant locations to all the locations
        function this = distance_matrix_LR2all_cal(this, env_parameters)
            this.distance_matrix_LR2all = zeros(this.LR_loc_size, size(env_parameters.longitude_selected, 1)); 
            for i = 1:1:this.LR_loc_size
                for j = 1:1:size(env_parameters.longitude_selected, 1)
                    loc_i = [env_parameters.longitude_selected(this.LR_loc_ID(i), 1), env_parameters.latitude_selected(this.LR_loc_ID(i), 1)]; 
                    loc_j = [env_parameters.longitude_selected(j, 1), env_parameters.latitude_selected(j, 1)];
                    [this.distance_matrix_LR2all(i,j), ~, ~] = haversine(loc_i, loc_j); % Calculate the Haversine distance between locations
                end
            end
        end


        %% Function: Calculate the distance matrix from the local relevant locations to the obfuscated locations
        function this = distance_matrix_LR2obf_cal(this)
            this.distance_matrix_LR2obf = this.distance_matrix_LR2all(:, this.obf_loc_ID); 
        end

        %% Function: Identify the obfuscated locations given the obfuscation range
        function this = obf_identifier(this, env_parameters)
            this.obf_loc_ID = [];
            for i = 1:1:size(env_parameters.longitude_selected, 1)
                loc_i = [env_parameters.longitude_selected(i, 1), env_parameters.latitude_selected(i, 1)];
                [distance_inst, ~, ~] = haversine(loc_i, [this.longitude, this.latitude]);
                if distance_inst < this.obf_range
                    this.obf_loc_ID = [this.obf_loc_ID, i]; 
                end
            end
            % plot(env_parameters.longitude_selected(user.obf_loc_ID, 1), env_parameters.latitude_selected(user.obf_loc_ID, 1), 'o'); 
            % hold on; 
            % plot(user.longitude, user.latitude, '*'); 
        end


        %% Function: Calculate the cost matrix 
        function this = cost_matrix_cal(this, cr_table, env_parameters)
            this.cost_matrix_upper = zeros(this.LR_loc_size, size(this.obf_loc_ID, 2)); 
            
            %%%%%%%%%% This part will need to be modified using the cost reference table
            for i = 1:1:this.LR_loc_size
                for j = 1:1:size(this.obf_loc_ID, 2)
                    real_loc = [env_parameters.longitude_selected(this.LR_loc_ID(i)), env_parameters.latitude_selected(this.LR_loc_ID(i))]; 
                    obf_loc = [env_parameters.longitude_selected(this.obf_loc_ID(j)), env_parameters.latitude_selected(this.obf_loc_ID(j))]; 
                    for l = 1:1:size(cr_table.loc, 1)
                        real_distance(l) = haversine(real_loc, cr_table.loc(l, :)); 
                        obf_distance(l) = haversine(obf_loc, cr_table.loc(l, :));
                    end
                    [real_distance, real_idx] = min(real_distance); 
                    [obf_distance, obf_idx] = min(obf_distance); 
                    this.cost_matrix_upper(i, j) = cr_table.approximated_cost(real_idx, obf_idx)+real_distance+obf_distance; 
                    this.cost_matrix_lower(i, j) = cr_table.approximated_cost(real_idx, obf_idx)-real_distance-obf_distance;
                    this.cost_matrix_upper(i, j) = min([this.cost_matrix_upper(i, j), 999999]); 
                    this.cost_matrix_lower(i, j) = min([this.cost_matrix_lower(i, j), 999999]);
                end
            end
        end

        %% Function: Calculate the cost matrix 
        function this = cost_matrix_whole_cal(this, env_parameters)
            this.cost_matrix_upper = zeros(this.LR_loc_size, size(this.obf_loc_ID, 2)); 
            
            %%%%%%%%%% This part will need to be modified using the cost reference table
            for i = 1:1:this.LR_loc_size
                for j = 1:1:size(this.obf_loc_ID, 1)
                    [~, distance] = shortestpathtree(env_parameters.G, this.LR_loc_ID(i));
                    this.cost_matrix_whole(i, :) = min([999999*ones(size(distance)); distance]);
                end
            end
        end




    end
end