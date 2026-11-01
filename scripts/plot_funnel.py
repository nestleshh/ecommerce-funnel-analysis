from pathlib import Path
import matplotlib.pyplot as plt

stages = [
    "Просмотр товара",
    "Добавление в корзину",
    "Покупка"
]

values = [27783702, 622776, 297755]

conversion = [
    "100%",
    "2,24% от просмотров",
    "1,07% от просмотров"
]

fig, ax = plt.subplots(figsize=(11, 5))

bars = ax.barh(
    stages,
    values,
    color=["blue", "lightblue", "green"]
)

ax.invert_yaxis()

for bar, value, rate in zip(bars, values, conversion):
    ax.text(
        bar.get_width() + 350000,
        bar.get_y() + bar.get_height() / 2,
        f"{value:,}".replace(",", " ") + f"  ({rate})",
        va="center",
        fontsize=10
    )

ax.set_title(
    "Воронка конверсии: от просмотра до покупки",
    fontsize=15,
    pad=20
)

ax.set_xlabel("Количество пар «сессия–товар»")
ax.set_xlim(0, 35000000)
ax.spines[["top", "right"]].set_visible(False)

fig.tight_layout()

output = (
    Path(__file__).resolve().parent.parent
    / "visuals"
    / "product_funnel.png"
)

fig.savefig(output, dpi=200, bbox_inches="tight")
plt.close(fig)