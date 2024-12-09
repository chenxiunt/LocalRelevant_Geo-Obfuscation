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
CRT_GRID_CELL_SIZE = 0.04; 

%% Parameters 
parameters; 
env_parameters.nr_loc_selected = 100; 
LR_LOC_SIZE = 20;                                                           % The total number of locations
OBF_RANGE = 4.5;                                                            % The obfuscation range is considered as a circle, and OBF_RANGE is the radius
EXP_RANGE = 4.0;                                                            % The set of location not applying exponential mechanism is within a circle, of which the radius is EXP_RANGE. 
NEIGHBOR_THRESHOLD = 0.5;                                                   % The neighbor threshold eta
NR_DEST = 20;                                                               % The number of destinations (spatial tasks)
NR_USER = 5;                                                                % The number of users (agents)
NR_LOC = 4;
env_parameters.nr_loc_selected = NR_LOC*100; 


%% Initialization
% env_parameters = readCityMapInfo(env_parameters);                         % Create the road map information of the target region: Rome, Italy
env_parameters = readGridMapInfo(env_parameters);                           % Create the road map information of the target region: Rome, Italy
env_parameters.GAMMA = 20; 
env_parameters.NEIGHBOR_THRESHOLD = 1000;
    

%% Create the server
server = Server(NR_DEST, EXP_RANGE, CRT_GRID_CELL_SIZE);                    % Create the server
server = server.destination_identifier(env_parameters); 
server = server.grid_map_cal(env_parameters, CRT_GRID_CELL_SIZE);           % Create a grid map
server = server.cr_table_cal(env_parameters);                               % Create the cost reference table
indist_set(grid_size, :) = threatByCostMatrix(server.cr_table, CRT_GRID_CELL_SIZE, 1); 
server.exp_range = EXP_RANGE; 


%% Create the users        
for m = 1:1:NR_USER
    user(m, 1) = User(m, LR_LOC_SIZE, OBF_RANGE, NEIGHBOR_THRESHOLD, env_parameters);               % Create users
    user(m, 1) = user(m, 1).initialization(env_parameters);                                         % Initialize the properties of the user, including the local relevant locations, distance matrices, obfuscated location IDs, and the cost matrix
end          
server = server.initialization(user);                                       % Create the destinations in the target region
        
for m = 1:1:NR_USER
    user(m, 1) = user(m, 1).cost_matrix_cal(server.cr_table, env_parameters);
end
        
%% Local relevant geo-obfuscation algorithm
tic;
server = server.geo_obfuscation_initialization(user, env_parameters);        
[server, user, nr_iterations, cost, cost_lower] = server.geo_obfuscation_generator(user, env_parameters);    % Generate the geo-obfuscation matrices 
computation_time = toc; 
[nr_violations, violation_mag]= GeoInd_violation_cnt(user, env_parameters); 

