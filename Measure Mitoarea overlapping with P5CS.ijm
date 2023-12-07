//This macro is assuming that images were taken in order of C1-DAPI C2-P5CS C3-Mito-protein#1 C4-Mito-protein#2
//run("ImageJ2...", "scijavaio=true");
run("Set Measurements...", "area integrated area_fraction limit redirect=None decimal=2");
run("Clear Results");
roiManager("Reset");
run("Close All");

Dialog.create("Image Folder");
Dialog.addMessage("Select the folder with the images.");
Dialog.show();
ImagePath=getDirectory("Choose the folder with images");
list = getFileList(ImagePath);
list = Array.sort (list);


print("ImageName	P5CSarea	TOM20area	TOM20wP5CSarea	TOM20woP5CSarea");



setBatchMode(true);					//Comment out to make images pop up.

for (NumImages=0; NumImages<list.length; NumImages++) {
	if (endsWith(list[NumImages],"tif")) {
		run("Bio-Formats Importer", "open=["+ImagePath+list[NumImages]+"] autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
		//open(ImagePath+list[NumImages]);
		ImageName = getTitle();
		run("Set Scale...", "distance=0 known=0 unit=pixel");
		run("Duplicate...", "title=Overlaid duplicate");
		selectWindow(ImageName);
		run("Split Channels");
		selectWindow("C1-"+ImageName);
		rename("DAPI");
		selectWindow("C2-"+ImageName);
		rename("Green");
		selectWindow("C3-"+ImageName);
		rename("Red");
		selectWindow("C4-"+ImageName);
		rename("Farred");
		
						
		selectWindow("DAPI");
		run("Select All");
		roiManager("Add");
		cellCount = roiManager("Count");
		
	
		//Area with P5CS
		selectWindow("Green");
		run("Duplicate...", "title=GMask");
		run("Subtract Background...", "rolling=50");
		run("Convert to Mask");
		//Area without P5CS
		run("Duplicate...", "title=GMaskInv");
		run("Invert");
		//Area with TOM20
		selectWindow("Farred");
		run("Duplicate...", "title=FRMask");
		run("Subtract Background...", "rolling=50");
		run("Convert to Mask");

	
		//Farred area overlapping with P5CS
		imageCalculator("MIN create", "FRMask", "GMask");
		run("Convert to Mask");
		rename("FRMask_GMask_Overlap");
		//Farred area that doesn't overlap with P5CS
		imageCalculator("MIN create", "FRMask", "GMaskInv");
		run("Convert to Mask");
		rename("FRMask_GMaskInv_Overlap");
		
		
		//Measure P5CS area
		selectWindow("GMask");
		roiManager("Measure");

			
		//Measure total Farred area
		selectWindow("FRMask");
		roiManager("Measure");
			
									
		//Measure Farred area ovelaaping with P5CS 
		selectWindow("FRMask_GMask_Overlap");		
		roiManager("Measure");
		
		//Measure Farred area without P5CS
		selectWindow("FRMask_GMaskInv_Overlap");		
		roiManager("Measure");


			for (i = 0; i < cellCount; i++) {
			GreenArea = getResult("Area",i);
			FRedArea = getResult("Area",i+cellCount);
			FredwithGreenArea = getResult("Area",i+2*cellCount);
			FredwoGreenArea = getResult("Area",i+3*cellCount);
			
			
			
			print(ImageName, "	", GreenArea, "	", FRedArea, "	", FredwithGreenArea,"	", FredwoGreenArea);
		}
				
		run("Close All");
		run("Clear Results");
		roiManager("Reset");
		
	}
}