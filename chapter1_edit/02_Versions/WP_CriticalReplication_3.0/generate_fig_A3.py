import pandas as pd
import matplotlib.pyplot as plt

# Load data
df = pd.read_csv('shaikh_yearly_growth_rates.csv')
df = df.dropna(subset=['g_real_Y_gro_pct', 'g_real_K_gro_pct', 'g_real_K_net_pct'])

plt.figure(figsize=(10, 5))

# Plot Output: Muted sky blue (#56B4E9)
plt.plot(df['year'], df['g_real_Y_gro_pct'], 
         label=r'Real Output (GVA, $\Delta y_t$)', 
         color='#56B4E9', linewidth=1.2, alpha=0.7)

# Plot Gross Capital (GPIM): Thick dark blue (#0072B2)
plt.plot(df['year'], df['g_real_K_gro_pct'], 
         label=r'Real Gross Capital Stock (GPIM, $\Delta k_t$)', 
         color='#0072B2', linewidth=2.2)

# Plot Net Capital (BEA): Dashed vermillion (#D55E00)
plt.plot(df['year'], df['g_real_K_net_pct'], 
         label=r'Real Net Capital Stock (BEA, $\Delta k^{net}_t$)', 
         color='#D55E00', linewidth=1.8, linestyle='--')

plt.axhline(0, color='grey', linestyle=':', linewidth=0.8)
plt.title('Annual Growth Rates of Output, Gross Capital, and Net Capital (1947–2011)', fontsize=12, pad=15)
plt.xlabel('Year', fontsize=10)
plt.ylabel('Annual Growth Rate (%)', fontsize=10)

# Legend at bottom center
plt.legend(loc='lower center', bbox_to_anchor=(0.5, -0.2), ncol=3, frameon=False, fontsize=9.5)

# Clean grid
plt.grid(True, which='both', linestyle=':', linewidth=0.5, alpha=0.5)

# Remove top/right spines
ax = plt.gca()
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)

# Adjust layout to make room for legend
plt.tight_layout()
plt.subplots_adjust(bottom=0.2)

# Save
plt.savefig('appendixA/figures/fig_A3_growth_rates.pdf', bbox_inches='tight')
plt.savefig('appendixA/figures/fig_A3_growth_rates.png', bbox_inches='tight', dpi=300)
print("Successfully generated fig_A3_growth_rates.pdf and .png")
