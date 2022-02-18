function computational(Boosting_folder, Computational_stitching_folder)


copyfile('comp_stitch.ijm', Computational_stitching_folder); 

 fid = fopen(strcat(Computational_stitching_folder, '\comp_stitch.ijm'),'r');
    i = 1;
    tline = fgetl(fid);
    A{i} = tline;
    while ischar(tline)
        i = i+1;
        tline = fgetl(fid);
        A{i} = tline;
    end
    fclose(fid);

    % Change cell A
length_y = length(dir(strcat(Boosting_folder, '/*x_1_y*')));
length_x = length(dir(strcat(Boosting_folder, '/*y_1.*')));


Boosting_folder_slash = strrep(Boosting_folder, '\' ,'/' );
Computational_stitching_folder_slash = strrep(Computational_stitching_folder, '\' ,'/' );

longLine = ['run("Grid/Collection stitching", "type=[Filename defined position] order=[Defined by filename         ] grid_size_x=', ...
    num2str(length_x), ' grid_size_y=' num2str(length_y) ' tile_overlap=12 first_file_index_x=1 first_file_index_y=1 directory=', ...
    Boosting_folder_slash, ' file_names=x_{x}_y_{y}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.1 max/avg_displacement_threshold=1 absolute_displacement_threshold=10 compute_overlap subpixel_accuracy computation_parameters=[Save computation time (but use more RAM)] image_output=[Write to disk] output_directory=', ... 
    Computational_stitching_folder_slash, '");'];
%longLine = strrep(longLine, '\','\\');
    A{1} = longLine;
    % Write cell A into txt
 fid = fopen(strcat(Computational_stitching_folder, '\comp_stitch.ijm'),'w');
    for i = 1:numel(A)
        if A{i+1} == -1
            fprintf(fid,'%s', A{i});
            break
        else
            fprintf(fid,'%s\n', A{i});
        end
    end 
    fclose(fid);

    why_on_earth = ['D:\Fiji.app\ImageJ-win64 -batch', ' ', Computational_stitching_folder,'\comp_stitch.ijm'];
    [~, ~] = dos( why_on_earth );
    %dos( why_on_earth );
