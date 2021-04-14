import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
def main():
    """
    Function performing summary statistics on studies found in 
    previous functionality of the program.
    Can perform summary statistics for either a file name or target taxonomy/keyword
    all depends on the naming of folders in the studies. E.g. if files name for their 
    target taxa then "Enterocytozoonbieneusi" could be used to summarise all those studies.
    :Output: .png file containing the average bowtie coverage barplots. 
    Essentially how much the target matches the reference data as a %.
    """
    #Parses for directories relating to the studies previously erformed
    directories=[]
    for file in os.listdir("/program"):
        d = os.path.join("/program/", file)
        if os.path.isdir(d):
            directories.append(d)
    #Reads the stats file to see which studies will be summarised
    f = open("/work/stats.txt", "r")
    a = f.read()

    f.close()
    #list comprehension getting the files needed/matching stats.txt
    search = [x for x in directories if a in x]
    coveragefiles =[]
    coverages=[]
    for i in search:
        for file in os.listdir(i):
            #The 2 on the end relates to this being a study where assembly has been performed
            if file.endswith("BowtieCoverage2.txt"):
                f = open(os.path.join(i,file),"r")
                name = file[:-len('.fastqBowtieCoverage2.txt')]  
                #Because of this an A is added
                name=name+"A" 
                #Append names and numbers for graphs
                coveragefiles.append(name)
                coverages.append(float(f.read().strip()))
                f.close()
            #Regular study with no assembly
            elif file.endswith("BowtieCoverage.txt"):  
                f = open(os.path.join(i,file),"r")
                name = file[:-len('.fastqBowtieCoverage.txt')]
                coveragefiles.append(name)
                coverages.append(float(f.read().strip()))
                f.close()
    #List comprehension to make sure labels on y axis are unique
    coveragefiles = [v + str(coveragefiles[:i].count(v) + 1) if coveragefiles.count(v) > 1 else v for i, v in enumerate(coveragefiles)]
    sns.set(rc={'figure.figsize':(11.7,8.27)})
    #Title for study 1X representing 1 apperence.
    plt.title("Coverage by reference genome at depth of atleast 1X")

    #Bar plot created
    sns_plot = sns.barplot(x=coverages,y=coveragefiles)
    sns_plot.set(xlabel='Coverage %', ylabel='study')
    for i in range(len(coverages)):
        sns_plot.text(coverages[i],i,coverages[i], color='black', ha="center")
    sns_plot.set_yticklabels(sns_plot.get_yticklabels(),rotation=90)
    plt.yticks(size=8)
    #Save figure to the program directory and the 'a' representing the study name
    plt.savefig("/program/"+a+"coverages.png", dpi=400)
    plt.close()
    #Remove file so another stats is not run immediately after.
    if os.path.isfile("/work/stats.txt"):
        os.remove("/work/stats.txt")
if __name__=='__main__':
    main()
