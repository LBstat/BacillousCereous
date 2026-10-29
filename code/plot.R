
# ── Shared theme ─────────────────────────────────────────────────────────────
base_theme <- function(base_size = 11) {
  theme_minimal(base_size = base_size) +
    theme(
      plot.title = element_text(hjust = 0.5, size = 14, face = "bold", margin = margin(b = 2)),
      plot.subtitle = element_text(hjust = 0.5, size = 10, color = "grey50", margin = margin(b = 10)),
      axis.title = element_text(size = 9,  color = "grey35"),
      axis.text = element_text(size = 8,  color = "grey45"),
      axis.ticks = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.major.y = element_line(color = "grey92", linewidth = 0.3),
      panel.grid.minor = element_blank(),
      strip.text = element_text(size = 9, face = "bold", color = "grey20", margin = margin(b = 4)),
      strip.background = element_rect(fill = "grey96", color = NA),
      legend.position = "top",
      legend.direction = "horizontal",
      legend.title = element_blank(),
      legend.text = element_text(size = 9),
      legend.key.size = unit(0.8, "lines"),
      plot.background = element_rect(fill = "white", color = NA),
      panel.background = element_rect(fill = "white", color = NA),
      plot.margin = margin(12, 16, 10, 16)
    )
}


