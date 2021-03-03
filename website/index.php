<html>
    <head>
    <?php 
    $sra=$assemble=$tax=""
    ?>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
 

    </style>


        <title>Finder</title>
    </head>

<body>
    <h1>SRA file and Taxonomy Input</h1>


    <p>
    This is a front end user interface which triggers a container
    and subsequent backend script that will perform:
    <ul>
    <li>Quality control and trimming with Cutadapt, FastQC and MultiQC. </li>
    <li>Bowtie and SAMtools to create an alignment between the data and reference
    genome and then calculate breadth of coverage found at atleast 1x depth. </li>
    <li>SPAdes to create scaffolds/contigs usable in reference step</li>
    <li>MetaCompass/AMOScmp to create an Metagenomic Assembled Genome using the reference as trusted contigs 
    and De Novo methods. Performing the assembly and binning steps. </li>
    <li>Quast to look at the quality and accuracy and to compare against the reference.
    Outputting all data needed into a zip. </li>
    (Reference-based assembly via MetaCompass or AMOScmp yet to be implemented)
    </ul>
    Please wait for it to be finished before trying another input.
    </p>

    <p>Input SRA file with SRR accession number
    This program will not help with input.
    For example for SRA file "ERR2367946" or "SRR13668442"
    and genome input is entered via taxonomy. This only uses 
    the reference genbank database so can be pretty limited for
    certain species of microsporidia. These are inputted like 
    "Enterocytozoon bieneusi" or "Nosema ceranae", do not include quotes in input. </p>
    <p>In addition to taxonomy the use of the unique keys or study numbers
     that the genbank file can also be used but should be careful. 
     Furthermore if it is limited on the reference genome on the genbank file
     then the user can also input their own sequences in the form of a .fasta file
     DO NOT input a taxonomy and .fasta file at the same time.
     </p>
    <p>
    For the program to find reference genomes and scaffolds we utilise the assembly_summary_genbank.txt file which summarises the databases described below.
    GenBank sequence records are owned by the original submitter and cannot be altered by a third party. RefSeq sequences are not part of the INSDC but are derived from INSDC sequences to provide non-redundant curated data representing our current knowledge of known genes
    </p>
    
    Please mind for leading and trailing spaces in input.
    Advised to test with turning off assembly first.
    Example of Title: EnterocytozoonbieneusiVSERR2367946 as this will be a folder name do not include spaces or any special characters
  
    <ul>
        <?php
           $sra = $tax = $assemble = "";
        ?>
    </ul>

<h2>Input for program</h2>
<form method = "POST"  enctype="multipart/form-data" action="<?php echo htmlspecialchars($_SERVER['PHP_SELF']); ?>">
  <label for="title">Title for study:</label>
  <input type="text" id="title" name="title"><br><br>
  <label for="sra">SRA FILE:</label>
  <input type="text" id="sra" name="sra"><br><br>

  <label for="tax">Taxonomy:</label>
  <input type="text" id="tax" name="tax"><br><br>

  
  <input type="file" name="fileupload" value="fileupload" id="fileupload">
  <label for="fileupload"> Select a file to be the reference [.fasta]</label><br><br>

  <label for = "assemble">Assemble:</label>
  <input type="checkbox" name="assemble" value="Yes" /><br><br>

  <input type="submit" value="Start">
  
</form>
<h2>Summary Statistics of projects created in /program/~</h2>
<p>Button for creating summary statistics for all folders found in folder, maybe make a field 
to input SRR number maybe not (would give a heatmap for multi references against one study.
Will activate a python script running a R file or just plucking up all /*/*bowtiecoverage.txt files putting ones in same folder on one plot/on top of eachother in different colours
and seperate folders being subsequently below in same fashion.
</p>

<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
  $sra = $_POST["sra"];
  $tax = $_POST["tax"];
  if(isset($_POST['assemble'])) {
    $assemble = "y";
    $myfile = fopen("./work/assemble.txt", "w") or die("Unable to open file!");
    fwrite($myfile, $assemble);
    fclose($myfile);
 }
  if (!is_dir("work"))
{
    mkdir("work", 0755, true);
}

  $myfile = fopen("./work/SRAFILE.txt", "w") or die("Unable to open file!");
  fwrite($myfile, $sra);
  fclose($myfile);
  
  if(!empty($_POST["tax"])){
  $myfile = fopen("./work/SPECIES.txt", "w") or die("Unable to open file!");
  fwrite($myfile, $tax);
  fclose($myfile);
  }
  $target_dir = '/work/';
  $tempname = $_FILES["fileupload"]["tmp_name"];
  $target_file = $target_dir.basename("mergedreference.fasta");
  move_uploaded_file($tempname, $target_file);
  $myfile = fopen("./work/start.txt", "w") or die("Unable to open file!");
  fwrite($myfile, "y");
  fclose($myfile);
}


 


echo "<h2>Your Input:</h2>";
echo $sra;
echo "<br>";
echo $tax;
echo "<br>";
echo $assemble;
?>
</body>
</html>
