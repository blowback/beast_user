import numpy as np
import matplotlib.pyplot as plt

t = np.linspace(0, 3 * 2 * np.pi, 1000)
y = 127 * np.sin(t) + 128

fig, ax = plt.subplots()
ax.plot(t, y)
ax.set_ylim(-10, 265)
ax.set_yticks([0, 127, 255])
ax.set_xlabel("time")
ax.set_ylabel("brightness")
plt.tight_layout()
plt.show()
