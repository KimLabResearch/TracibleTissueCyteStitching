function [ ref_vector ] = map2vector(ref,ref_map)

for ii = 1:length(ref.order)
    ref_vector.src_x(ii) = sum(ref_map.x(ref.connect(ii).connected_index).*ref.weight(ref.connect(ii).connected_index))./sum(ref.weight(ref.connect(ii).connected_index));
    ref_vector.src_y(ii) = sum(ref_map.y(ref.connect(ii).connected_index).*ref.weight(ref.connect(ii).connected_index))./sum(ref.weight(ref.connect(ii).connected_index));
end

ref_vector.x = ref_map.x - ref_vector.src_x;
ref_vector.y = ref_map.y - ref_vector.src_y;

