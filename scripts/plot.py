import matplotlib.pyplot as plt

import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.gridspec as gridspec

df = pd.read_csv("my.csv", header=None, sep="\t", names=["system", "variant", "query", "time", "result"])
#df = df.pivot(index="query", columns=["system"], values=["time"])
df = df.pivot(index="system", columns=["query"], values=["time"])

print(df)

# aggregate multiple results
sns.set_style('whitegrid')
# sns.set(style='ticks', palette='Set2')
# sns.relplot(data=df, x='query', y='time', col='query', row='query', kind='lineplot')

#fig = plt.figure(constrained_layout=True, figsize=[5, 5])

#spec = gridspec.GridSpec(ncols=2, nrows=3, figure=fig)
# for i in range(0, 6):
#     ax = fig.add_subplot(spec[i % 3, i % 2])
#ax=ax, 
df.plot.bar(y="time", rot=0, subplots=True)

#ax.grid()
#plt.legend(loc="best")
plt.legend(loc="upper left")
plt.yscale("log")
plt.ylabel("time [s]")
plt.savefig("/tmp/my.png", dpi=300)
plt.savefig("/tmp/my.pdf", dpi=300)
plt.close()
