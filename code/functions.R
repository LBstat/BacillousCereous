
load_sheet <- function(path, xl_sheet, label) {

  # ── 1. Assertions ────────────────────────────────────────────────────────
  assertString(path)
  assertString(xl_sheet)
  assertString(label)

  # Layout of each sheet: row 1 = sheet title, row 2 = column names, then the data
  df <- read_excel(path, sheet = xl_sheet, skip = 1)
  stopifnot(names(df)[1:3] == c("Time", "Treatment", "Temperature"), !anyNA(df[, 1:4]))

  df <- as.data.frame(df[, 1:4])
  names(df) <- c("Time", "Treatment", "Temperature", "y") # 4th column: "Count" or "Spores"

  df$Hours       <- df$Time                                # hours as number (plots)
  df$Time        <- factor(df$Time)                       # hours as factor (ANOVA)
  df$Treatment   <- factor(df$Treatment, levels = c("FDA", "WHO"))
  df$Temperature <- factor(df$Temperature, levels = c(4, 10, 20))

  # Sample = position of the row within each triplet (row 1, 2, 3 = sample 1, 2, 3)
  df$Sample <- factor(
    ave(
      seq_len(nrow(df)), df$Time, df$Treatment, df$Temperature, FUN = seq_along
    )
  )

  df$Sheet <- label
  df
}

# Three-way ANOVA (all interactions), type III; Holm over the effect terms
# ANOVA (type III) for any formula; Holm over the effect terms of THIS model if holm = TRUE
anova_table <- function(df, formula = y ~ Time * Treatment * Temperature, holm = TRUE) {

  # ── 1. Assertions ────────────────────────────────────────────────────────
  assertDataFrame(df)

  fit <- lm(formula, data = df)
  a <- Anova(fit, type = 3)
  tab <- data.frame(
    Effect = rownames(a),
    dgf = a$Df,
    `Sum of Sq` = a$`Sum Sq`,
    `F value` = a$`F value`,
    `Pr(>F)` = a$`Pr(>F)`,
    check.names = FALSE
  )

  tab <- tab[tab$Effect != "(Intercept)", ]

  tab$`adj p value` <- NA_real_
  if (holm) {
    eff <- tab$Effect != "Residuals"
    tab$`adj p value`[eff] <- p.adjust(tab$`Pr(>F)`[eff], method = "holm")
  }

  list(
    fit = fit,
    tab = tab
  )
}

residual_data <- function(fit, sheet) {
  r  <- residuals(fit)
  qq <- qqnorm(r / sd(r), plot.it = FALSE)
  data.frame(Sheet = sheet, fitted = fitted(fit), resid = r,
             qx = qq$x, qy = qq$y, Temperature = fit$model$Temperature)
}

# Helper functions -----------------------------------------------------------
fp <- function(p) ifelse(is.na(p), "", ifelse(p < 0.001, "<0.001", sprintf("%.3f", p)))
temp_lab  <- function(x) paste(x, DEG)

save_tab <- function(df, name) {
  if (save_tables) write.csv2(df, file.path("data/results", paste0(name, ".csv")), row.names = FALSE)
}

save_fig <- function(plot, name, w, h) {
  if (save_figures) ggsave(file.path("plot", name), plot, width = w, height = h, dpi = 300, bg = "white")
}

format_anova <- function(tab) {

  # ── 1. Assertions ────────────────────────────────────────────────────────
  assertDataFrame(tab)

  data.frame(
    Effect = tab$Effect,
    dgf = tab$dgf,
    `Sum of Sq` = round(tab$`Sum of Sq`, 3),
    `F value` = ifelse(is.na(tab$`F value`), "", sprintf("%.2f", tab$`F value`)),
    `Pr(>F)` = fp(tab$`Pr(>F)`),
    `adj p value` = fp(tab$`adj p value`),
    check.names = FALSE
    )
}
