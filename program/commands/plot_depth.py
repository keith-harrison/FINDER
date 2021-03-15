# !/usr/bin/env python3
# -*- coding: utf-8 -*-
 
import seaborn as sns
import numpy as np
import pandas as pd
from matplotlib import (pyplot as plt,
                        lines)
 
  
def plot_depth(depth_report, output_name, plot_title, genome_size):
    """Plot genome Depth across genome.
 
    Args:
        depth_report (str): Path to samtool's depth file.
        output_name (str): Path to output PNG image.
        plot_title (str): Plot title.
        genome_size (int): Genome size.
 
    """
    sns.set(rc={'figure.figsize':(11.7,8.27)})

    df = pd.read_csv(
    'genome.depth',
    sep = '\s+',names = ["Reference", "position", "depth"]
    )
    data = df.iloc[:,-1:]
    y_label = "Depth"
    sns.set(color_codes=True)
    plt.title(plot_title)

    sns_plot = sns.lineplot(data = data,linewidth=0.25)
    sns_plot.set(xlabel='Genome Position (bp)', ylabel=y_label)

    plt.savefig(output_name, dpi=400)
    plt.close()
 