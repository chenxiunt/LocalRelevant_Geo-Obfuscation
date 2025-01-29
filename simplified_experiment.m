addpath('./classes/Server/');
addpath('./classes/User/');
addpath('./classes/MasterProgram/');
addpath('./classes/Subproblem/');
addpath('./func/benchmarks/');
addpath('./func/benchmarks/randl/');
addpath('./func'); 
addpath('./func/read_files'); 
addpath('./func/haversine'); 

grid_size = 3; 
CRT_GRID_CELL_SIZE = 0.0100; 

%% Parameters 
parameters; 
env_parameters.nr_loc_selected = 100; 
LR_LOC_SIZE = 20;                                                           % The total number of locations
OBF_RANGE = 4.5;                                                            % The obfuscation range is considered as a circle, and OBF_RANGE is the radius
EXP_RANGE = 4.0;                                                            % The set of location not applying exponential mechanism is within a circle, of which the radius is EXP_RANGE. 
NEIGHBOR_THRESHOLD = 0.5;                                                   % The neighbor threshold eta
NR_DEST = 20;                                                               % The number of destinations (spatial tasks)
NR_USER = 4;                                                                % The number of users (agents)
load('.\intermediate_results\server.mat')
% load('.\intermediate_results\server.mat')
for NR_LOC = 1:1:4
    NR_LOC  
    env_parameters.nr_loc_selected = NR_LOC*100; 
    
    tic;
    rng(0); 
    %% Initialization
    % env_parameters = readCityMapInfo(env_parameters);                         % Create the road map information of the target region: Rome, Italy
    env_parameters = readGridMapInfo(env_parameters);                           % Create the road map information of the target region: Rome, Italy
    env_parameters.GAMMA = 50; 
    env_parameters.NEIGHBOR_THRESHOLD = 20;
        
    
    %% Create the server
    
    % server(NR_LOC) = Server(NR_DEST, EXP_RANGE, CRT_GRID_CELL_SIZE);                    % Create the server
    % server(NR_LOC) = server(NR_LOC).destination_identifier(env_parameters); 
    % server(NR_LOC) = server(NR_LOC).grid_map_cal(env_parameters, CRT_GRID_CELL_SIZE);           % Create a grid map
    % server(NR_LOC) = server(NR_LOC).cr_table_cal(env_parameters);                               % Create the cost reference table
    % indist_set(grid_size, :) = threatByCostMatrix(server(NR_LOC).cr_table, CRT_GRID_CELL_SIZE, 1); 
    % server(NR_LOC).exp_range = EXP_RANGE; 

    preparation_time = toc; 
    %% Create the users        
    for m = 1:1:NR_USER
        user(m, 1) = User(m, LR_LOC_SIZE, OBF_RANGE, NEIGHBOR_THRESHOLD, env_parameters);               % Create users
        user(m, 1) = user(m, 1).initialization(env_parameters);                                         % Initialize the properties of the user, including the local relevant locations, distance matrices, obfuscated location IDs, and the cost matrix
    end          
    server(NR_LOC) = server(NR_LOC).initialization(user);                                       % Create the destinations in the target region
            
    for m = 1:1:NR_USER
        user(m, 1) = user(m, 1).cost_matrix_cal(server(NR_LOC).cr_table, env_parameters);
    end
            
    %% Local relevant geo-obfuscation algorithm
    tic;
    server(NR_LOC) = server(NR_LOC).geo_obfuscation_initialization(user, env_parameters);        
    [server(NR_LOC), user, nr_iterations(NR_LOC), cost(NR_LOC), cost_lower(NR_LOC)] = server(NR_LOC).geo_obfuscation_generator(user, env_parameters);    % Generate the geo-obfuscation matrices 
    computation_time(NR_LOC) = toc; 
    % clear server; 
    clear user; 
end

save("cost.mat", "cost"); 
save("cost_lower.mat", "cost_lower"); 
save("nr_iterations.mat", "nr_iterations"); 
save("computation_time.mat", "computation_time"); 