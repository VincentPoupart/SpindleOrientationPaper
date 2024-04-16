setBatchMode(false);
run("Close All");
run("Collect Garbage");
listc= getList("image.titles");
for (m=0; m<listc.length; m++){
        close(listc[m]);
          }	

               
dir = getDirectory("Please choose a source directory.");
close("*");

root = substring(dir, 0, lastIndexOf(dir, "\\"));
bo = "fluo_results";
bob = "Spheres";
bobi = "BINARY";
boba = "MOVIES";
bobu = "Intersection";
boby = "Background";
boby2 = "Bleaching";
boby3 =  "FluoAtSpherePatch";
boby4 = "BackgroundSpheres";
boby6 = "Spheres_at_centrosome";
boby7 = "Spheres_at_Patch_translation";
boby8 = "Non-dividing";
BackgroundSpheresdir = ""+root+"\\"+bo+"\\"+boby4+"\\";
Intersectiondir = ""+root+"\\"+bo+"\\"+bobu+"\\";
Spheresdir = ""+root+"\\"+bo+"\\"+bob+"\\";
BINARYdir = ""+root+"\\"+bobi+"\\";
Moviedir = ""+root+"\\"+boba+"\\";
Backgrounddir = ""+root+"\\"+bo+"\\"+boby+"\\";
Bleachingdir = ""+root+"\\"+bo+"\\"+boby2+"\\";
FluoAtSpherePatchdir = ""+root+"\\"+bo+"\\"+boby3+"\\";
Spheres_at_centrosomedir = ""+root+"\\"+bo+"\\"+boby6+"\\";
Spheres_at_Patchdir = ""+root+"\\"+bo+"\\"+boby7+"\\";
Non_dividingdir = ""+root+"\\"+boby8+"\\";


GetFilesIV(BINARYdir);






function GetFilesIV(BINARYdir) {//////// get tiff binary files and send to gonadeSeg function
	listb = getFileList(BINARYdir);
	Array.sort(listb); 
    for (i=0; i<listb.length; i++) {
    		if ((endsWith(listb[i], ".txt"))){ 
    				path = BINARYdir+listb[i];
    				
    				NonDividingCells(path);
    				run("Close All");
                    run("Collect Garbage");
listc= getList("image.titles");
 
if (isOpen("Log")) {
         selectWindow("Log");
         run("Close" ); 
}
for (m=0; m<listc.length; m++){
        close(listc[m]);
          }	
    		}	
    }
}

function NonDividingCells(path) {
run("Close All");
run("Collect Garbage");
run("Clear Results"); 
if (isOpen("Log")) {
         selectWindow("Log");
         run("Close" ); 
}


E = indexOf(""+listb[i]+"", ".txt");
F = substring(""+listb[i]+"", 0, E); 
Fr = substring(""+listb[i]+"", 2, E); 
SpecificMoviedir = ""+Moviedir+"\\"+Fr+"\\";
open(""+SpecificMoviedir+""+F+".tif");
Stack.setDisplayMode("composite");	
setTool("multipoint");
run("Set Measurements...", "stack redirect=None decimal=3");
waitForUser("SVP, cliquez sur 5 cellules");
run("Clear Results");
run("Measure");
saveAs("Results", ""+Non_dividingdir+"\\"+F+".csv");
}
