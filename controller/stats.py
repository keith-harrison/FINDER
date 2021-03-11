import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
def main():
    directories=[]
    for file in os.listdir("program"):
        d = os.path.join("program", file)
        if os.path.isdir(d):
            directories.append(d)
    f = open("website/work/stats.txt", "r")
    a = f.read()
    f.close()
    search = [x for x in directories if a in x]
    coveragefiles =[]
    coverages=[]
    for i in search:
        for file in os.listdir(i):
            if file.endswith("BowtieCoverage2.txt"):
                f = open(os.path.join(i,file),"r")
                name = file.removesuffix('.fastqBowtieCoverage2.txt')   
                name=name+"a" 
                coveragefiles.append(name)
                coverages.append(float(f.read().strip()))
                f.close()
            elif file.endswith("BowtieCoverage.txt"):  
                f = open(os.path.join(i,file),"r")
                name = file[:-len('.fastqBowtieCoverage.txt')]
                               
                coveragefiles.append(name)
                coverages.append(float(f.read().strip()))
                f.close()
    print(coveragefiles)
    print(coverages)
    

    sns.set(rc={'figure.figsize':(11.7,8.27)})

    plt.title("Coverage by reference genome at depth of atleast 1 (if 2 in name represents assembled)")


    sns_plot = sns.barplot(coverages,coveragefiles)
    sns_plot.set(xlabel='Coverage %', ylabel='study')
    for i in range(len(coverages)):
        sns_plot.text(coverages[i]+0.05,i,coverages[i], color='black', ha="center")
    sns_plot.set_yticklabels(sns_plot.get_yticklabels(),rotation=90)
    plt.savefig("program/coverages.png", dpi=400)
    plt.close()
    if os.path.isfile("website/work/stats.txt"):
        os.remove("website/work/stats.txt")
if __name__=='__main__':
    main()