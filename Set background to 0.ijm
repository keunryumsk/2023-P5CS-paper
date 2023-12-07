Dialog.create("Image Folder");
Dialog.addMessage("Select the folder with the images.");
Dialog.show();
ImagePath=getDirectory("Choose the folder with images");
File.makeDirectory(ImagePath + "//background_removed//"); 
list = getFileList(ImagePath);
list = Array.sort (list);


setBatchMode(true);					//Comment out to make images pop up.

for (NumImages=0; NumImages<list.length; NumImages++) {
	if (endsWith(list[NumImages],"tif")) {
		//run("Bio-Formats Importer", "open=["+ImagePath+list[NumImages]+"] color_mode=Default view=Hyperstack stack_order=XYCZT");
		open(ImagePath+list[NumImages]);
		ImageName = getTitle();
		print(ImageName);
		run("Duplicate...", "title=Overlaid duplicate");
		selectWindow(ImageName);
		run("Make Inverse");
		run("Set...", "value=0");
		saveAs("Tiff", ImagePath + "//background_removed//" + ImageName);
		
		
	}
		run("Close All");
}

setBatchMode(false);

