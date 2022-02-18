function average_all(dir_out_sub)

for ii = 1:length(dir_out_sub)
    dir_temp = dir_out_sub{ii};
    Averaging_folder = [dir_temp '\averaging'];
    mkdir(Averaging_folder);
end



