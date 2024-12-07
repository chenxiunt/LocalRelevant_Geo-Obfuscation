addpath('./classes/Server/');
addpath('./classes/User/');
addpath('./classes/MasterProgram/');
addpath('./classes/Subproblem/');
addpath('./func/benchmarks/');
addpath('./func/benchmarks/randl/');
addpath('./func'); 
addpath('./func/read_files'); 
addpath('./func/haversine'); 

rng(0)

  
grid_size = 3; 
% for grid_size = 1:1:10
% CRT_GRID_CELL_SIZE = grid_size*0.0025 + 0.0025;  
CRT_GRID_CELL_SIZE = 0.04; 
% CRT_GRID_CELL_SIZE = 0.005;

parameters; 
env_parameters.nr_loc_selected = 100; 

% Parameters                    
NODE_IDX = 1;                                                               % The ID of the target node
% default settings          
LR_LOC_SIZE = 20;                                                           % The total number of locations
OBF_RANGE = 4.5;                                                            % The obfuscation range is considered as a circle, and OBF_RANGE is the radius
EXP_RANGE = 4.0;                                                            % The set of location not applying exponential mechanism is within a circle, of which the radius is EXP_RANGE. 
NEIGHBOR_THRESHOLD = 0.5;                                                   % The neighbor threshold eta
NR_DEST = 20;                                                               % The number of destinations (spatial tasks)
NR_USER = 5;                                                                % The number of users (agents)
% CRT_GRID_CELL_SIZE = 0.010; 
% for NR_LOC = 9:1:9 
NR_LOC = 4;
env_parameters.nr_loc_selected = NR_LOC*100; 
%% Initialization
% env_parameters = readCityMapInfo(env_parameters);                         % Create the road map information of the target region: Rome, Italy
env_parameters = readGridMapInfo(env_parameters);                           % Create the road map information of the target region: Rome, Italy
% 

for NR_USER = 2:1:10
    env_parameters.GAMMA = 20; 
% for gamma_idx = 1:1:5
%     env_parameters.GAMMA = gamma_idx*10; 
% for neighbor_thr_idx = 1:1:10
%     env_parameters.NEIGHBOR_THRESHOLD = neighbor_thr_idx*100;
    env_parameters.NEIGHBOR_THRESHOLD = 1000;

    
%% Create the server
server = Server(NR_DEST, EXP_RANGE, CRT_GRID_CELL_SIZE);                    % Create the server
server = server.destination_identifier(env_parameters); 
% load('.\data\intermediate\server.mat'); 
server = server.grid_map_cal(env_parameters, CRT_GRID_CELL_SIZE);           % Create a grid map
server = server.cr_table_cal(env_parameters);                               % Create the cost reference table
indist_set(grid_size, :) = threatByCostMatrix(server.cr_table, CRT_GRID_CELL_SIZE, 1); 

% computation_time = zeros(10, 10); 
% nr_iterations = zeros(10, 10); 
% cost = zeros(10, 10); 
    for idx = 1:1:5
        idx_1 = NR_USER; 
        idx_2 = idx; 
         
        % load('.\data\intermediate\server_lowerbound.mat');                  % Use to calculate the lower bound      
        server.exp_range = EXP_RANGE; 
        %% Create the users        
        for m = 1:1:NR_USER
            user(m, 1) = User(m, LR_LOC_SIZE, OBF_RANGE, NEIGHBOR_THRESHOLD, env_parameters);               % Create users
            user(m, 1) = user(m, 1).initialization(env_parameters);                                         % Initialize the properties of the user, including the local relevant locations, distance matrices, obfuscated location IDs, and the cost matrix
        end          
        server = server.initialization(user);                               % Create the destinations in the target region
        
        for m = 1:1:NR_USER
            user(m, 1) = user(m, 1).cost_matrix_cal(server.cr_table, env_parameters);
        end
        
        %% Benchmarks
        cost(idx_1, idx_2) = 0; 
        % tic;
        % for m = 1:1:NR_USER
        %     % cost(idx_1, idx_2) = cost(idx_1, idx_2) + expMech(user(m, 1), env_parameters); 
        %     % [cost_inst, computation_time(idx_1, idx_2)] = expMech(user(m, 1), env_parameters);
        %     [cost_inst, computation_time(idx_1, idx_2)] = lapMech(user(m, 1), env_parameters);
        %     cost(idx_1, idx_2) = cost(idx_1, idx_2) + cost_inst;
        % end     

        %% LR-Geo
        tic;
        server = server.geo_obfuscation_initialization(user, env_parameters);        
        [server, user, nr_iterations(idx_1, idx_2), cost(idx_1, idx_2), cost_lower(idx_1, idx_2)] = server.geo_obfuscation_generator(user, env_parameters);    % Generate the geo-obfuscation matrices 
        computation_time(idx_1, idx_2) = toc; 
        [nr_violations(idx_1, idx_2) violation_mag(idx_1, idx_2)]= GeoInd_violation_cnt(user, env_parameters); 
        clear user; 
    end
    clear server; 
    % clear env_parameters
end
% end 

% User first report the local relevant locations to the server


