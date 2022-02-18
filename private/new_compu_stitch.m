
function new_compu_stitch(Normalized_folder, Computational_stitching_folder, Number_of_cores)


dir_list = dir([Normalized_folder]);
bite_size = floor(length(dir_list)./(2.*Number_of_cores)./3);
ind_dir_list = bite_size:bite_size:(2.*Number_of_cores).*bite_size;
for ii = 1:length(ind_dir_list)
    boost_dir_list{ii} = [Computational_stitching_folder, '/boost', num2str(ind_dir_list(ii))];
    out_dir_list{ii} = [Computational_stitching_folder, '/out', num2str(ind_dir_list(ii))];
    mkdir(boost_dir_list{ii});
    mkdir(out_dir_list{ii});
end
parfor  (ii = 1:length(ind_dir_list), Number_of_cores)
    
    boostfolder(Normalized_folder, [2, ind_dir_list(ii)], boost_dir_list{ii});
    computational(boost_dir_list{ii}, out_dir_list{ii});
end

total_slices = length(ind_dir_list);




file_reg = 'TileConfiguration.registered.txt';



for ii = 1:length(ind_dir_list)
    NNNN{ii} = [boost_dir_list{ii} '\' file_reg];
end




ref_map(1) = read_registered(NNNN{1});

max_sub_x = max(ref_map(1).sub_x);
max_sub_y = max(ref_map(1).sub_y);

ref = stitch_conn_ref(max_sub_x,max_sub_y);

ref_center.x = max(ref_map(1).x)./2+500;
ref_center.y = max(ref_map(1).y)./2+500;

for ii = 1: total_slices
    
    pre_ref_map(ii).weight = read_weight(boost_dir_list{ii});
    
end

ref.weight = zeros(size(ref.order));
ref.weight(:) = 0.01;
for ii = 1: total_slices
    
    ref.weight = ref.weight + pre_ref_map(ii).weight;
end

for ii = 1: total_slices
    
    ref_map(ii) = read_registered(NNNN{ii});
    
    [ ref_vector(ii) ] = map2vector(ref,ref_map(ii));
    
end
for ii = 1: total_slices
    ref_map(ii).weight = pre_ref_map(ii).weight;
end
final_vector.x = ref_vector(1).x.*ref_map(1).weight;
final_vector.y = ref_vector(1).y.*ref_map(1).weight;
net_weight = ref_map(1).weight;


for ii = 2: total_slices
    
    final_vector.x = final_vector.x + ref_vector(ii).x.*ref_map(ii).weight;
    final_vector.y = final_vector.y + ref_vector(ii).y.*ref_map(ii).weight;
    net_weight = net_weight + ref_map(ii).weight;
end

final_vector.x = final_vector.x ./ net_weight;
final_vector.y = final_vector.y ./ net_weight;


[final_map] = vector2map(ref, ref_center, final_vector  );
final_map.sub_x = ref_map(1).sub_x;
final_map.sub_y = ref_map(1).sub_y;


NNN = [Computational_stitching_folder ,'/',file_reg];

write_stitch_file(NNN, final_map)