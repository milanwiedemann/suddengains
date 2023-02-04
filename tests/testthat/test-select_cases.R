df <- tibble::tribble(
  ~id, ~bdi_s1, ~bdi_s2, ~bdi_s3, ~bdi_s4, ~bdi_s5, ~bdi_s6,
  1, NA, 10, 10, 10, 10, NA,
  2, NA, 10, 10, 10, NA, 10,
  3, 10, NA, 10, 10, 10, NA,
  4, 10, NA, 10, 10, 10, 10,
  5, 10, NA, NA, 10, 10, 10,
  6, 10, NA, NA, NA, NA, 10,
  7, 10, 10, 10, 10, 10, 10,
)



test_that("Test select cases pattern works", {
  df_test <- select_cases(
    data = df,
    id_var_name = "id",
    sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3", "bdi_s4", "bdi_s5", "bdi_s6"),
    method = "pattern",
    return_id_lgl = FALSE
  )

  df_test_expect <- tibble::tribble(
    ~id, ~bdi_s1, ~bdi_s2, ~bdi_s3, ~bdi_s4, ~bdi_s5, ~bdi_s6, ~sg_select,
    1, NA, 10, 10, 10, 10, NA, TRUE,
    2, NA, 10, 10, 10, NA, 10, TRUE,
    3, 10, NA, 10, 10, 10, NA, TRUE,
    4, 10, NA, 10, 10, 10, 10, TRUE,
    5, 10, NA, NA, 10, 10, 10, FALSE,
    6, 10, NA, NA, NA, NA, 10, FALSE,
    7, 10, 10, 10, 10, 10, 10, TRUE
  )

  expect_equal(df_test, df_test_expect)
})


test_that("Test select cases min sess works", {
  df_test <- select_cases(
    data = df,
    id_var_name = "id",
    sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3", "bdi_s4", "bdi_s5", "bdi_s6"),
    method = "min_sess",
    min_sess_num = 5,
    return_id_lgl = TRUE
  )

  df_test_expect <- tibble::tribble(
    ~id, ~sg_select,
    1, FALSE,
    2, FALSE,
    3, FALSE,
    4, TRUE,
    5, FALSE,
    6, FALSE,
    7, TRUE
  )



  expect_equal(df_test, df_test_expect)
})
