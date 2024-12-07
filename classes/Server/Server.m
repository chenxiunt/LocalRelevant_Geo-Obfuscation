classdef Server
    properties
        nr_destination
        destination_loc_ID
        cost_cell_size
        cost_reference_table
        exp_range
        master_program
        cr_table
        grid_map
    end
    properties
        subproblem = Subproblem();
    end

    methods
        %% Constructor 
        function this = Server(NR_DEST, EXP_RANGE, CRT_GRID_CELL_SIZE)
            this.nr_destination = NR_DEST;
            this.destination_loc_ID = []; 
            this.cost_cell_size = CRT_GRID_CELL_SIZE; 
            this.cost_reference_table = [];
            this.exp_range = EXP_RANGE;
            this.master_program = MasterProgram(); 
            this.subproblem = Subproblem();
            this.cr_table = struct(  'loc', [], ...
                                     'approximated_cost', []); 
            this.grid_map = struct(  'longitude', [], ...
                                     'latitude', [], ...
                                     'approximated_loc', []);
        end


        %% Function: Initialize the server
        function this = initialization(this, user)
            % this = this.destination_identifier(env_parameters);                 % Create the destinations in the target region
            for m = 1:1:size(user, 1)
                inst_subproblem = Subproblem();
                this.subproblem(m, 1) = inst_subproblem;
            end
            this = this.Q_matrix_cal(user);                                 % Calculate the Q matrices of each subproblem
        end

        %% Function: Randomly select a set of destiniation
        function this = destination_identifier(this, env_parameters)
            nr_loc = size(env_parameters.latitude_selected, 1); 
            this.destination_loc_ID = randsample(nr_loc, this.nr_destination);
        end

        %% Function: Calculate the Q matrix for each subproblem
        function this = Q_matrix_cal(this, user)
            for m = 1:1:size(user, 1)
                this.subproblem(m, 1) = this.subproblem(m, 1).Q_matrix_cal(user(m, 1), this.exp_range); 
            end
        end

        %% Function: Create the obfuscation matrix
        function this = geo_obfuscation_initialization(this, user, env_parameters)
            % Initialization
            % Master program
            this.master_program = this.master_program.cost_vector_cal(this.subproblem, user, env_parameters); 
            
            % Subproblems
            for m = 1:1:size(user, 1)
                this.subproblem(m, 1) = this.subproblem(m, 1).geo_matrix_cal(user(m, 1), env_parameters);
                this.subproblem(m, 1) = this.subproblem(m, 1).unit_matrix_cal(user(m, 1));
            end
        end

        %% Function: Create the grid map
        function this = grid_map_cal(this, env_parameters, cell_size)
            NR_LONG = ceil((env_parameters.longitude_raw_max - env_parameters.longitude_raw_min)/cell_size);
            NR_LATI = ceil((env_parameters.latitude_raw_max - env_parameters.latitude_raw_min)/cell_size);
            % this.grid_map = zeros(NR_LONG, NR_LATI); 
            for i = 1:1:NR_LONG
                for j = 1:1:NR_LATI
                    this.grid_map(i,j).longitude = env_parameters.longitude_raw_min + cell_size/2 + cell_size*(i-1); 
                    this.grid_map(i,j).latitude = env_parameters.latitude_raw_min + cell_size/2 + cell_size*(j-1);
                    for l = 1:1:size(env_parameters.latitude, 1)
                        distance(l) = haversine([this.grid_map(i,j).longitude, this.grid_map(i,j).latitude], ...
                            [env_parameters.longitude(l,1), env_parameters.latitude(l,1)]); 
                    end
                    [~, this.grid_map(i,j).approximated_loc] = min(distance); 
                end
            end
        end

        %% Function: Create the cost reference table
        function this = cr_table_cal(this, env_parameters)
            loc_idx = 1;
            for i = 1:1:size(this.grid_map, 1)
                for j = 1:1:size(this.grid_map, 2)
                    this.cr_table.loc = [this.cr_table.loc; [this.grid_map(i, j).longitude, this.grid_map(i, j).latitude]];
                    loc_idx = loc_idx + 1;
                end
            end

            real_idx = 1; 
            for real_i = 1:1:size(this.grid_map, 1)
                for real_j = 1:1:size(this.grid_map, 2)
                    obf_idx = 1;
                    for obf_i = 1:1:size(this.grid_map, 1)
                        for obf_j = 1:1:size(this.grid_map, 2)
                            this.cr_table.approximated_cost(real_idx, obf_idx) = 0; 
                            for l = 1:1:this.nr_destination
                                [~, cost_real] = shortestpath(env_parameters.G, this.grid_map(real_i, real_j).approximated_loc, this.destination_loc_ID(l,1)); 
                                [~, cost_obf] = shortestpath(env_parameters.G, this.grid_map(obf_i, obf_j).approximated_loc, this.destination_loc_ID(l,1)); 
                                this.cr_table.approximated_cost(real_idx, obf_idx) = this.cr_table.approximated_cost(real_idx, obf_idx) + abs(cost_real-cost_obf); 
                            end
                            this.cr_table.approximated_cost(real_idx, obf_idx) = this.cr_table.approximated_cost(real_idx, obf_idx)/this.nr_destination; 
                            obf_idx = obf_idx + 1;
                        end
                    end
                    real_idx = real_idx + 1;
                end
            end

        end
        %% Function: Create the obfuscation matrix
        function [this, user, iter, cost, cost_lower] = geo_obfuscation_generator(this, user, env_parameters)
            % Start the Benders' decomposition here
            iter = 1;
            cost = 999; 
            while iter < 100
                cost_lower = 0;
                iter
                [this.master_program, cost_lowerbound(iter), cost_exp] = this.master_program.calculate(env_parameters); 
                cost_upperbound(iter) = cost_exp;
                for m = 1:1:size(user, 1)
                    [this.subproblem(m, 1), user(m, 1)] = this.subproblem(m, 1).calculate(user(m, 1), m, this.master_program, env_parameters); 
                    this.master_program = this.master_program.add_newcuts(this.subproblem(m, 1), user(m, 1), m, env_parameters); 
                    cost_upperbound(iter) = cost_upperbound(iter) + this.subproblem(m, 1).cost; 
                    cost_lower = cost_lower + this.subproblem(m, 1).cost_lower;
                    cost_upperbound(iter) - cost_lower
                end
                if cost_upperbound(iter) - cost_lowerbound(iter) < 0.01 % 1.0
                    cost = cost_upperbound(iter); 
                    break; 
                end
                [cost_lowerbound(iter) cost_upperbound(iter)]
                iter = iter + 1;
            end
        end

    end
    % methods (Access = public)        
    %     server = creat_destination(server, env_parameters);                  % Identify the local relevant location
    %     create_CRTable(server, env_parameters, LR_loc_ID)                   % Calculate the distance matrix of the local relevant locations
    %     obf_matrix_generator(distance_matrix, cost_matrix)                  % Generate the obfuscation matrix 
    % end
end