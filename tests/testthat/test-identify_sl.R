# Specify 2 datasets used for testing
df1 <- tibble::tribble(
  ~id, ~x_2n, ~x_1n, ~x_n, ~x_n1, ~x_n2, ~x_n3,
  1, 28, 19, 23, 12, 13, NA,
  2, 28, 19, 23, 11, 12, NA,
  3, 28, 19, NA, 12, 13, NA,
  4, 28, 19, 23, 12, 13, NA,
  5, 28, 19, 23, 12, 14, NA,
  6, 28, 19, NA, 12, 13, NA,
  7, 28, 19, 23, 11, 12, NA,
  8, 28, 25, 28, 11, 12, NA,
  9, 28, 26, 28, 11, 12, NA,
  10, NA, 26, 28, NA, 12, 11,
)

df2 <- tibble::tribble(
  ~id, ~x_2n, ~x_1n, ~x_n, ~x_n1, ~x_n2, ~x_n3,
  1, 10, 11, 12, 30, 28, 33,
  2, 10, 11, 12, 10, 28, 33,
  3, 10, 11, 30, 30, 28, 33,
  4, 35, 37, 34, 23, 24, 21
)

test_that("test identify sudden losses", {
  df_test <- identify_sl(
    data = df2,
    sg_crit1_cutoff = -7,
    id_var_name = "id",
    sg_var_list = c(
      "x_2n", "x_1n", "x_n",
      "x_n1", "x_n2", "x_n3"
    )
  )

  expect_equal(unlist(df_test[1, c("sl_2to3", "sl_3to4", "sl_4to5")], use.names = FALSE), c(0, 1, 0))
  expect_equal(unlist(df_test[2, c("sl_2to3", "sl_3to4", "sl_4to5")], use.names = FALSE), c(0, 0, 1))
  expect_equal(unlist(df_test[3, c("sl_2to3", "sl_3to4", "sl_4to5")], use.names = FALSE), c(1, 0, 0))
  expect_equal(unlist(df_test[4, c("sl_2to3", "sl_3to4", "sl_4to5")], use.names = FALSE), c(0, 0, 0))
})
