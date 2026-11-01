from pathlib import Path
import matplotlib.pyplot as plt
import numpy as np


segments = ["До 50", "50–199", "200–499", "500+"]
all_products = [1.27, 2.26, 2.65, 2.69]
smartphones = [1.29, 6.54, 5.03, 4.21]

plt.rcParams["font.family"] = "DejaVu Sans"

x = np.arange(len(segments))
width = 0.35

fig, ax = plt.subplots(figsize=(10, 6))

bars_all = ax.bar(
    x - width / 2,
    all_products,
    width,
    label="Все товары"
)

bars_phones = ax.bar(
    x + width / 2,
    smartphones,
    width,
    label="Смартфоны"
)

for bars in [bars_all, bars_phones]:
    for bar in bars:
        height = bar.get_height()
        ax.annotate(
            f"{height:.2f}%".replace(".", ","),
            (bar.get_x() + bar.get_width() / 2, height),
            xytext=(0, 4),
            textcoords="offset points",
            ha="center",
            va="bottom"
        )

ax.set_title(
    "Конверсия из просмотра в корзину по цене товара",
    fontsize=15,
    pad=20
)

ax.set_xlabel("Ценовой сегмент товара")
ax.set_ylabel("Конверсия, %")
ax.set_xticks(x, segments)
ax.set_ylim(0, 8)

ax.legend()
ax.grid(axis="y", alpha=0.2)
ax.set_axisbelow(True)

fig.tight_layout()

output = (
    Path(__file__).resolve().parent.parent
    / "visuals"
    / "price_conversion.png"
)

output.parent.mkdir(parents=True, exist_ok=True)
fig.savefig(output, dpi=200, bbox_inches="tight")
plt.close(fig)
