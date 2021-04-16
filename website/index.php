<html>
    <head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>

img {
  border: 5px solid #555;
}


    </style>


        <title>FINDER</title>
    </head>

<body>
    <h1>Raw sequence data against Reference comparison</h1>


    <p>
    This program is intended to take in FASTQ data from SRA/ERA/DRA studies which can be initially screened on NCBI using blast to find studies for further analysis.
    FINDER intends to give a better picture of the coverage by performing the steps detailed below and outputting statistics and graphs for researchers to determine whether or not the raw sequence
    data found in metagenomic/microbiome studies matches up with current reference databases, using annotated coding regions from the GenBank database and the coverage of these reference sequences.

    <ul> Tools
    <li>Retrieval of FASTQ files and corresponding metadata and reference genomes from NCBI, using fasterq-dump</li>
    <li>Quality control and trimming with Cutadapt, FastQC and MultiQC. </li>
    <li>Alignment created using Bowtie between the reference and raw data.</li>
    <li>SAMtools to create coverage tables of the reference, then calculating the breadth of coverage found at atleast 1X depth. - Can be changed in bowtiecoverage(2).sh files.</li>
    <li>TOOLS BELOW DISABLED</li>
    <li>RagTag to create an Metagenomic Assembled Genome using the reference as trusted contigs 
    and De Novo methods. Using MiniMap2 as the aligner for the algorithm. Takes a long time on local/low spec machines. </li>
    <li>Quast to look at the quality and accuracy and to compare against the reference.</li>
    Outputting all these results into the folder which can be found at the "currentip"/program/
    </ul>
    Please wait for it to be finished before trying another input, and refresh often to see whether or not the program is finished, evident when all files have been moved into the folder named after the title field.
    </p>
    <h4>Title input</h4>
    <p>
    Please mind for leading and trailing spaces in input.
    Advised to test with turning off assembly first.
    Example of Title: EnterocytozoonbieneusiVSERR2367946 as this will be a folder name do not include spaces or any special characters
    </p>
    <h4>Raw Data (SRA/ERA/DRA)input</h4>
    <p>Input SRA file with SRR accession number. For example for SRA file "ERR2367946" or "SRR13668442". NCBI Sequence Read Archive (SRA) stores sequence and quality data (fastq files) in aligned or unaligned formats from NextGen sequencing platforms.
    'DRA' is also a common file type from the Data bank of Japan and 'EBA' matching 'ERR' files from the European bioinformatics institute.<p>
    <h4>Reference input</h4>
    <p> Meanwhile reference input can take the form of a .fasta file, or if you have knowledge of the genbank files you can put a taxonomy in the taxonomy field or a bioproject id or any other identifiers that the genbank files uses e.g. "Enterocytozoon bieneusi" as the genbank files in my program use coding regions it can be limited in the number of reference sequences used.
     or "Nosema ceranae", do not include quotes in input. </p>
    <p>DO NOT input a taxonomy and .fasta file at the same time.
     </p>
    <h4>Genbank database info</h4>
    <p>
    For the program to find reference genomes and scaffolds we utilise the assembly_summary_genbank.txt file which summarises the databases described below, can be updated automatically if the file is deleted.
    GenBank sequence records are owned by the original submitter and cannot be altered by a third party. RefSeq sequences are not part of the INSDC but are derived from INSDC sequences to provide non-redundant curated data representing our current knowledge of known genes
    </p>
    <h3>Example inputs</h3>
    <img src="websiteimages/input1.png" alt="Example input 1">
    <img src="websiteimages/input2.png" alt="Example input 2">
    <img src="websiteimages/inputstats.png" alt="Example input for stats">


<h2> Link to results folder </h2>
<a href="/program/">
    <button>Results</button>
</a>



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

  <input type="submit" name = "Start" value="Start">
  
</form>
<h2>Summary Statistics of projects created in /program/~</h2>
<p>Button for creating summary statistics for all folders found in folder, maybe make a field 
to input SRR number maybe not (would give a heatmap for multi references against one study.
Will activate a python script running a R file or just plucking up all /*/*bowtiecoverage.txt files putting ones in same folder on one plot/on top of eachother in different colours
and seperate folders being subsequently below in same fashion.
</p>
<form method = "POST"  enctype="multipart/form-data" action="<?php echo htmlspecialchars($_SERVER['PHP_SELF']);?>">
<label for="stats">Aggregrate for:</label>
<input type="text" id="stats" name="stats"><br><br>
<input type="submit" name = "Stat" value="Stat">
</form>
<?php
// If the start button has been pressed
if(isset($_POST['Start'])) {
  // Assigns all necessary variables from inputs in previous form
  $title = $_POST["title"];
  $sra = $_POST["sra"];
  $tax = $_POST["tax"];
  // Also assigns the optional assemble to just contain "y" if assembling against reference
  /* CURRENTLY DISABLED AS ASSEMBLY CAUSES BUGS.
  if(isset($_POST['assemble'])) {
    $assemble = "y";
    $myfile = fopen("./work/assemble.txt", "w") or die("Unable to open file!");
    fwrite($myfile, $assemble);
    fclose($myfile);
 } */
  // Makes work directory if nonexistent to store these files in 
  if (!is_dir("work"))
{
    mkdir("work", 0755, true);
}
  $myfile = fopen("./work/title.txt", "w") or die("Unable to open file!");
  fwrite($myfile,$title);
  fclose($myfile);
  
  $myfile = fopen("./work/SRAFILE.txt", "w") or die("Unable to open file!");
  fwrite($myfile, $sra);
  fclose($myfile);
  // If a taxa such as "Enterocytozoon bieneusi" has been inputted insert that into a file
  if(!empty($_POST["tax"])){
    $myfile = fopen("./work/SPECIES.txt", "w") or die("Unable to open file!");
    fwrite($myfile, $tax);
    fclose($myfile);
  } else {

    $target_dir = '/work/';
    $tempname = $_FILES["fileupload"]["tmp_name"];
    $target_file = $target_dir.basename("mergedreference.fasta");
    move_uploaded_file($tempname, $target_file);

  }
  #Writes to a start file to tell the finder_controller_1 to start the pipeline in finder_program_1
  $myfile = fopen("./work/start.txt", "w") or die("Unable to open file!");
  fwrite($myfile, "y");
  fclose($myfile);
  echo "<script>window.location = '/program/'</script>";
  
}
// Or if the stat button has been pressed
if(isset($_POST['Stat'])) {
  // Write contents of form to stats.txt file
  $stats = $_POST["stats"];
  $myfile = fopen("./work/stats.txt", "w") or die("Unable to open file!");
  fwrite($myfile,$stats);
  fclose($myfile);
  echo "<script>window.location = '/program/'</script>";
}

?>
</body>
</html>

