formulars = list(
  ss_t = "$$\\text{SS}_\\text{T} =\\sum_{i=1}^N (x_i - \\bar x_\\text{grand})^2$$",
  ss_m = "$$\\text{SS}_\\text{M} = \\sum_{g=1}^k n_g\\, (\\bar x_g-\\bar x_\\text{grand})^2$$",
  ss_r = "$$\\text{SS}_\\text{R} = \\sum_{g=1}^k\\sum_{i=1}^n (x_{ig}-\\bar x_g)^2$$",
  df_t = "$$df_\\text{T} = N-1$$",
  df_m = "$$\\begin{align}df_\\text{M} &= k-1 \\newline &= \\text{n. groups} - 1\\end{align}$$",
  df_r = "$$\\begin{align}df_\\text{R} &= N-k \\newline &= df_\\text{T} - df_\\text{M}\\end{align}$$",
  ms_m = "$$MS_\\text{M} = \\frac{\\text{SS}_\\text{M}}{df_\\text{M}}$$",
  ms_r = "$$MS_\\text{R} = \\frac{\\text{SS}_\\text{R}}{df_\\text{R}}$$",
  f = "$$F = \\frac{MS_\\text{M}}{MS_\\text{R}}$$"
)
