function [] = merge_all_run(dir_out_sub, dir_out)

total_run = length(dir_out_sub);


for kk = 1:3

jjj = 0;
mkdir([dir_out, '\ch', num2str(kk,'%01i')])

for ii  = 1:total_run
    
    
    list_tif = dir([dir_out_sub{ii}, '\stitched\ch', num2str(kk), '\*.tif' ]);
    %list_tif_ch2 = dir([dir_out_sub, '\ch2\*.tif' ]);
    num_list = zeros(length(list_tif),1);
    for iii  =1:length(list_tif)
        temp_cell = regexp(list_tif(iii).name,'\d*','Match');
        num_list(iii) = str2double(temp_cell{1});
    end
    [~, ranked_index] = sort(num_list);
    for iii = 1:length(ranked_index)
        jjj = jjj+1;
        copyfile([list_tif(ranked_index(iii)).folder, '\' ,list_tif(ranked_index(iii)).name],[dir_out, '\ch', num2str(kk,'%01i'), '/Z', num2str(jjj,'%03i'), '_ch', num2str(kk,'%02i'), '.tif']);
    end
    
    
end


end