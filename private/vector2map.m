function [final_map] = vector2map(ref, ref_center, ref_vector  )


final_map.x(ref.order == 0) = ref_center.x;
final_map.y(ref.order == 0) = ref_center.y;


for ii = 1:max(ref.order)
    for jj = find(ref.order == ii)
        
        src_x = sum(final_map.x(ref.connect(jj).connected_index).*ref.weight(ref.connect(jj).connected_index))./sum(ref.weight(ref.connect(jj).connected_index));
        src_y = sum(final_map.y(ref.connect(jj).connected_index).*ref.weight(ref.connect(jj).connected_index))./sum(ref.weight(ref.connect(jj).connected_index));
        
        
        final_map.x(jj) = src_x + ref_vector.x(jj);
        final_map.y(jj) = src_y + ref_vector.y(jj);
        
        
    end
    
end