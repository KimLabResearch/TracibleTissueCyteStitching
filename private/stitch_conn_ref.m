function [reconstruction_ref] = stitch_conn_ref(total_x, total_y)



reconstruction_ref.order = zeros(1,total_x.*total_y);
reconstruction_ref.index = 1:1:total_x.*total_y;
[reconstruction_ref.x, reconstruction_ref.y] = ind2sub([total_x,total_y],reconstruction_ref.index);

center_x = round(total_x./2);
center_y = round(total_y./2);

r2 = (reconstruction_ref.x-center_x).*(reconstruction_ref.x-center_x) + (reconstruction_ref.y-center_y).*(reconstruction_ref.y-center_y);

max_order = 0;

for ii = 1:400
    if nnz(r2 == ii)
        max_order = max_order +1;
        reconstruction_ref.order( r2 == ii ) = max_order;
    end
end





for ii = 1: length( reconstruction_ref.order )
    reconstruction_ref.connect(ii).connected_index = [];
end

% x-1

condition_index = sub2ind([total_x,total_y],reconstruction_ref.x(reconstruction_ref.x ~= 1), reconstruction_ref.y(reconstruction_ref.x ~= 1));
[target_sub_x, target_sub_y] = ind2sub([total_x,total_y],condition_index);
target_index = sub2ind([total_x,total_y], target_sub_x -1 , target_sub_y);

for ii = 1: length( condition_index )
    reconstruction_ref.connect(condition_index(ii)).connected_index = [reconstruction_ref.connect(condition_index(ii)).connected_index, target_index(ii)];
end

% x+1

condition_index = sub2ind([total_x,total_y],reconstruction_ref.x(reconstruction_ref.x ~= total_x), reconstruction_ref.y(reconstruction_ref.x ~= total_x));
[target_sub_x, target_sub_y] = ind2sub([total_x,total_y],condition_index);
target_index = sub2ind([total_x,total_y], target_sub_x + 1 , target_sub_y);

for ii = 1: length( condition_index )
    reconstruction_ref.connect(condition_index(ii)).connected_index = [reconstruction_ref.connect(condition_index(ii)).connected_index, target_index(ii)];
end

% y-1

condition_index = sub2ind([total_x,total_y],reconstruction_ref.x(reconstruction_ref.y ~= 1), reconstruction_ref.y(reconstruction_ref.y ~= 1));
[target_sub_x, target_sub_y] = ind2sub([total_x,total_y],condition_index);
target_index = sub2ind([total_x,total_y], target_sub_x , target_sub_y -1);

for ii = 1: length( condition_index )
    reconstruction_ref.connect(condition_index(ii)).connected_index = [reconstruction_ref.connect(condition_index(ii)).connected_index, target_index(ii)];
end

% y+1

condition_index = sub2ind([total_x,total_y],reconstruction_ref.x(reconstruction_ref.y ~= total_y), reconstruction_ref.y(reconstruction_ref.y ~= total_y));
[target_sub_x, target_sub_y] = ind2sub([total_x,total_y],condition_index);
target_index = sub2ind([total_x,total_y], target_sub_x , target_sub_y +1);

for ii = 1: length( condition_index )
    reconstruction_ref.connect(condition_index(ii)).connected_index = [reconstruction_ref.connect(condition_index(ii)).connected_index, target_index(ii)];
end





for ii = 1: length( reconstruction_ref.connect )
    reconstruction_ref.connect(ii).connected_index = ...
        reconstruction_ref.connect(ii).connected_index(reconstruction_ref.order(reconstruction_ref.connect(ii).connected_index) < reconstruction_ref.order(ii));
end





