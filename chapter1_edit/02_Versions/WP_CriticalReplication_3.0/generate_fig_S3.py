import os
import numpy as np
import matplotlib.pyplot as plt
import shutil

def generate_phase_diagram():
    # 1. Parameter setup
    delta = 0.05
    k_init = 0.03
    
    # 2. X domain: net capital growth rate k_hat from -0.08 to 0.15
    k_hat = np.linspace(-0.08, 0.15, 500)
    
    # 3. Y values: d k_hat / dt = (theta - 1) * (k_hat + delta)^2
    # Panel A: theta = 0.8
    y_A = (0.8 - 1) * (k_hat + delta)**2
    # Panel B: theta = 1.2
    y_B = (1.2 - 1) * (k_hat + delta)**2
    
    # Initial conditions
    y_init_A = (0.8 - 1) * (k_init + delta)**2
    y_init_B = (1.2 - 1) * (k_init + delta)**2
    
    # 4. Plot setup (Tufte-inspired, minimalist, 1 row, 2 columns)
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(10, 4.5), dpi=300)
    
    # Colors
    color_A = "#D55E00"  # Vermillion (Okabe-Ito)
    color_B = "#0072B2"  # Blue (Okabe-Ito)
    grey_grid = "#CCCCCC"
    grey_dark = "#333333"
    
    # --- PANEL A: Overaccumulation ---
    ax1.plot(k_hat, y_A, color=color_A, lw=2, label=r"$\theta = 0.8 < 1.0$")
    ax1.axhline(0, color=grey_dark, lw=0.6, ls="-")  # zero axis
    
    # Equilibria guidelines
    ax1.axvline(-delta, color="grey", lw=0.6, ls=":")  # stable stagnation point
    ax1.axvline(0, color="grey", lw=0.4, ls=":")       # reference point
    
    # Initial condition point
    ax1.plot(k_init, y_init_A, 'o', color="red", ms=6)
    
    # Annotation for initial condition
    ax1.annotate(
        r"$\hat{k}_0 = 3\%$"+"\n"+r"$\frac{d\hat{k}}{dt} = -0.128\%$",
        xy=(k_init, y_init_A),
        xytext=(k_init + 0.015, y_init_A - 0.0006),
        fontsize=8,
        color=grey_dark,
        arrowprops=dict(arrowstyle="->", color="grey", lw=0.5, connectionstyle="arc3,rad=-0.1")
    )
    
    # Stagnation equilibrium label
    ax1.text(-delta, 0.0008, r"$\hat{k}^* = -\delta$" + "\n" + "(stagnation)", 
             fontsize=8, color="grey", ha="center")
    
    # Phase flow arrows on horizontal axis
    # For k_hat > -delta, flow is leftward (d k_hat / dt < 0)
    ax1.annotate("", xy=(-0.02, 0), xytext=(0.01, 0), arrowprops=dict(arrowstyle="->", color=color_A, lw=1.2))
    ax1.annotate("", xy=(0.07, 0), xytext=(0.10, 0), arrowprops=dict(arrowstyle="->", color=color_A, lw=1.2))
    # For k_hat < -delta, flow is leftward
    ax1.annotate("", xy=(-0.07, 0), xytext=(-0.06, 0), arrowprops=dict(arrowstyle="->", color=color_A, lw=1.2))
    
    # Panel A Styling
    ax1.set_title("A. Overaccumulation Regime (Stable Stagnation)", fontsize=10, pad=10)
    ax1.set_xlabel(r"Net capital growth rate $\hat{k}$", fontsize=9)
    ax1.set_ylabel(r"Capital acceleration $d\hat{k}/dt$", fontsize=9)
    ax1.set_xlim(-0.08, 0.15)
    ax1.set_ylim(-0.004, 0.004)
    ax1.spines["top"].set_visible(False)
    ax1.spines["right"].set_visible(False)
    ax1.spines["left"].set_color("grey")
    ax1.spines["bottom"].set_color("grey")
    ax1.tick_params(axis="both", colors="grey", labelsize=8)
    
    # --- PANEL B: Explosive Growth ---
    ax2.plot(k_hat, y_B, color=color_B, lw=2, label=r"$\theta = 1.2 > 1.0$")
    ax2.axhline(0, color=grey_dark, lw=0.6, ls="-")  # zero axis
    
    # Equilibria guidelines
    ax2.axvline(-delta, color="grey", lw=0.6, ls=":")  # unstable point
    ax2.axvline(0, color="grey", lw=0.4, ls=":")       # reference point
    
    # Initial condition point
    ax2.plot(k_init, y_init_B, 'o', color="red", ms=6)
    
    # Annotation for initial condition
    ax2.annotate(
        r"$\hat{k}_0 = 3\%$"+"\n"+r"$\frac{d\hat{k}}{dt} = +0.128\%$",
        xy=(k_init, y_init_B),
        xytext=(k_init + 0.015, y_init_B + 0.0006),
        fontsize=8,
        color=grey_dark,
        arrowprops=dict(arrowstyle="->", color="grey", lw=0.5, connectionstyle="arc3,rad=0.1")
    )
    
    # Unstable equilibrium label
    ax2.text(-delta, -0.0012, r"$\hat{k}^* = -\delta$" + "\n" + "(unstable)", 
             fontsize=8, color="grey", ha="center")
    
    # Phase flow arrows on horizontal axis
    # For k_hat > -delta, flow is rightward (d k_hat / dt > 0)
    ax2.annotate("", xy=(0.01, 0), xytext=(-0.02, 0), arrowprops=dict(arrowstyle="->", color=color_B, lw=1.2))
    ax2.annotate("", xy=(0.10, 0), xytext=(0.07, 0), arrowprops=dict(arrowstyle="->", color=color_B, lw=1.2))
    # For k_hat < -delta, flow is leftward
    ax2.annotate("", xy=(-0.07, 0), xytext=(-0.06, 0), arrowprops=dict(arrowstyle="->", color=color_B, lw=1.2))
    
    # Panel B Styling
    ax2.set_title("B. Explosive Growth Regime (Unstable)", fontsize=10, pad=10)
    ax2.set_xlabel(r"Net capital growth rate $\hat{k}$", fontsize=9)
    ax2.set_ylabel(r"Capital acceleration $d\hat{k}/dt$", fontsize=9)
    ax2.set_xlim(-0.08, 0.15)
    ax2.set_ylim(-0.004, 0.004)
    ax2.spines["top"].set_visible(False)
    ax2.spines["right"].set_visible(False)
    ax2.spines["left"].set_color("grey")
    ax2.spines["bottom"].set_color("grey")
    ax2.tick_params(axis="both", colors="grey", labelsize=8)
    
    # Layout adjustments
    plt.tight_layout()
    
    # 5. Output directories creation and saves
    os.makedirs("figures", exist_ok=True)
    pdf_path = os.path.join("figures", "fig_S3_phase_diagram_capital_capacity_dynamics.pdf")
    png_path = os.path.join("figures", "fig_S3_phase_diagram_capital_capacity_dynamics.png")
    
    plt.savefig(pdf_path, format="pdf", bbox_inches="tight")
    plt.savefig(png_path, format="png", bbox_inches="tight", dpi=300)
    plt.close()
    
    print(f"Generated Figure S3 in active folder: {pdf_path} (PDF) and {png_path} (PNG)")
    
    # Synchronize to output/section3_theory/figures/
    sync_dir = os.path.join("..", "..", "output", "section3_theory", "figures")
    os.makedirs(sync_dir, exist_ok=True)
    shutil.copy(pdf_path, os.path.join(sync_dir, "fig_S3_phase_diagram_capital_capacity_dynamics.pdf"))
    shutil.copy(png_path, os.path.join(sync_dir, "fig_S3_phase_diagram_capital_capacity_dynamics.png"))
    print(f"Synchronized Figure S3 to: {sync_dir}")

if __name__ == "__main__":
    generate_phase_diagram()
