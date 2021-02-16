import matplotlib.pyplot as plt

import numpy as np
import pandas as pd

df = pd.read_csv("my.csv", header=None, sep="\t", names=["system", "variant", "query", "time", "result"])
df = df.pivot(index="query", columns=["system"], values=["time"])

# TODO: subplots
# TODO: put the grid behind plot elements
# TODO: move legends
ax = df.plot.bar(y="time")#, subplots=True
ax.grid()
#plt.legend(loc="lower center")#, bbox_to_anchor=(0.5, -0.3))
plt.yscale("log")
plt.ylabel("time [s]")
plt.savefig("/tmp/my.png", dpi=300)
plt.close()
