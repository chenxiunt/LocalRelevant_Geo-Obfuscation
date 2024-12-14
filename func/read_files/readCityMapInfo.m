function env_parameters = readCityMapInfo(env_parameters)
    
    opts = detectImportOptions('./dataset/city/nodes_rome.csv');
    opts = setvartype(opts, 'osmid', 'int64');
    df_nodes = readtable('./dataset/city/nodes_rome.csv', opts);
    df_edges = readtable('./dataset/city/edges_rome.csv');
                                                                            % Extract the column as an array
    env_parameters.longitude_raw = table2array(df_nodes(:, 'x'));                              % Actual x (longitude) coordinate from the nodes data
    env_parameters.latitude_raw = table2array(df_nodes(:, 'y'));                               % Actual y (latitude) coordinate from the nodes data
    env_parameters.osmid = table2array(df_nodes(:, 'osmid'));


    LONGITUDE_MAX = max(env_parameters.longitude_raw);
    LONGITUDE_MIN = min(env_parameters.longitude_raw);
    LATITUDE_MAX = max(env_parameters.latitude_raw);
    LATITUDE_MIN = min(env_parameters.latitude_raw);

    LONGITUDE_SIZE = LONGITUDE_MAX - LONGITUDE_MIN;
    LATITUDE_SIZE = LATITUDE_MAX - LATITUDE_MIN;

    env_parameters.longitude_raw_min = (LONGITUDE_MIN+LONGITUDE_MAX)/2 - LONGITUDE_SIZE/(2*env_parameters.scale); 
    env_parameters.longitude_raw_max = (LONGITUDE_MIN+LONGITUDE_MAX)/2 + LONGITUDE_SIZE/(2*env_parameters.scale); 
    env_parameters.latitude_raw_min = (LATITUDE_MIN+LATITUDE_MAX)/2 - LATITUDE_SIZE/(2*env_parameters.scale); 
    env_parameters.latitude_raw_max = (LATITUDE_MIN+LATITUDE_MAX)/2 + LATITUDE_SIZE/(2*env_parameters.scale); 

    for i = 1:1:size(env_parameters.longitude_raw, 1)
        if env_parameters.longitude_raw(i) <= env_parameters.longitude_raw_max && env_parameters.longitude_raw(i) >= env_parameters.longitude_raw_min ...
                && env_parameters.latitude_raw(i) <= env_parameters.latitude_raw_max && env_parameters.latitude_raw(i) >= env_parameters.latitude_raw_min
            env_parameters.node_target = [env_parameters.node_target, i]; 
        end
    end

    %% Create the graph of the road map
    fprintf("The map information has been loaded. \n")
    env_parameters.longitude = env_parameters.longitude_raw(env_parameters.node_target); 
    env_parameters.latitude = env_parameters.latitude_raw(env_parameters.node_target); 
    [env_parameters.G, ~, ~, ~] = graph_preparation(df_nodes, df_edges, env_parameters.node_target);    % Given the map information, create the mobility graph

    %% Create the mDP graph
    idx_selected = randperm(size(env_parameters.node_target, 2), env_parameters.nr_loc_selected); 
    env_parameters.longitude_selected = env_parameters.longitude(idx_selected); 
    env_parameters.latitude_selected = env_parameters.latitude(idx_selected);
    env_parameters.node_target_selected = env_parameters.node_target(idx_selected); 
    env_parameters.G_mDP = mDP_graph_creator(env_parameters);
end