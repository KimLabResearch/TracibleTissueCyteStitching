
# Tracible TissueCyte Stitcher
This code here is designed to address the image traceability of serial-two-photon-tomography (STPT) by TissueCyte (product of tissue vision). The code take raw TIF files from the TissueCyte  system, deform the image to correct the aberration, adjust the intensity profile to correct the photo bleaching, and finally stitch them together based on the best cross matching coordinates. The code calls ImageJ for image processing.  

## How to use
- Load *RUN_THIS_FILE.m* under Matlab.  Edit the number *total_run* to reflect your data. (total run means the data was imaged during several consecutive sections. They do not have to be the same tile configuration; the code will align them and put them together after the stitching.)  The GUI will guide you to select the raw data location and desired output location. 
- You will need a ImageJ2. The default location is D:\Fiji.app

## Limitations
- The code is designed for TissueCyte with its file structure and its potential artifacts that other scope might not share

## Environment
The code was developed and tested on
- Matlab 2019a
- ImageJ2 win64

## License
Free academic use.
