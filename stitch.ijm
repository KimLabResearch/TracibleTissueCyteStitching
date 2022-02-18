//runBeanShell("mpicbg.stitching.fusion.BlendingPixelFusion.fractionBlended = 0.5");
//run invisibly? Speeds up processing by about 50%.
setBatchMode(true);
print("\\Clear");
start = getTime(); 

	//path_to_template = File.openDialog("Choose template stitching file (.registered.txt is probably the one you want)"); 
path_to_template = "D:\\20190408_practice\\fiji_auto\\TileConfiguration.registered.txt"; 
	//dir2= getDirectory("Choose an Input Directory (should be your scan base folder");
dir2= "D:\\20190408_practice\\fiji_auto_in";
	//dir_output= getDirectory("Choose an Output Directory");
dir_output= "D:\\20190408_practice\\fiji_auto_out";

Step_3_Directed_Stitch=1; //////////////////////////////////////////////////////////////

	

if (Step_3_Directed_Stitch==1){
	start = getTime(); 
	
	//grab path to stitching file
	//path_to_template = File.openDialog("Choose template stitching file (.registered.txt is probably the one you want)"); 
	template_name=File.getName(path_to_template); 
	template_dir=File.getParent(path_to_template);
	//dir2= getDirectory("Choose an Input Directory (should be your scan base folder");
	//dir_output= getDirectory("Choose an Output Directory");
	//dir2=File.getParent(template_dir); 
	landing_dir=dir_output+"\\stitchedImage_"+template_name+" template";
	File.makeDirectory(landing_dir);
	
	Folder_list = getFileList(dir2);
	print(Folder_list.length);
	//grab actual input folder name so you don't screw up the bottom calls and double append directory names... ImageJ doesn't have a default call for grabbing the folder name of a file.
	previous_folder=split(template_dir,"\\");
	previous_folder=previous_folder[previous_folder.length-1];
	actual_folder_count=0;
	for (k=0; k<Folder_list.length; k++) {
		current_folder=Folder_list[k];
		
		if(File.isDirectory(dir2 +"\\"+current_folder) && indexOf(current_folder, "Z") == 0 ){
			print("Current Folder: "+current_folder);
			print("Previous Folder: "+previous_folder);
			print("template name: "+template_name);
			print("template dir: "+template_dir);
			
	
			if(actual_folder_count>0){
			File.rename(dir2+"\\"+previous_folder+"/"+template_name,dir2+"\\"+current_folder+template_name);
			}
			else{
				File.rename(path_to_template,dir2+"\\"+current_folder+template_name);
			}
			//}
			run("Grid/Collection stitching", "type=[Positions from file] order=[Defined by TileConfiguration] directory=["+dir2+"\\"+current_folder+"] layout_file="+template_name+" fusion_method=[Linear Blending] regression_threshold=0.01 max/avg_displacement_threshold=1 absolute_displacement_threshold=1 ignore_z_stage subpixel_accuracy computation_parameters=[Save computation time (but use more RAM)] image_output=[Write to disk] output_directory=["+landing_dir+"]");
			temp_folder_name_prefix=split(current_folder,"/");
			temp_folder_name_prefix=temp_folder_name_prefix[0];			
			File.rename(landing_dir+"/img_t1_z1_c1" , landing_dir+"/"+temp_folder_name_prefix+".tif");
		
			previous_folder=current_folder;
	
			actual_folder_count++;
	}

}
	File.rename(dir2+"\\"+previous_folder+"\\"+template_name,path_to_template);
	
	print("Directed Stitch Finished");
	print((getTime()-start)/1000); 
