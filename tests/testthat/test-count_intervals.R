df <- tibble::tribble(
  ~id, ~bdi_s0, ~bdi_s1, ~bdi_s2, ~bdi_s3, ~bdi_s4, ~bdi_s5, ~bdi_s6, ~bdi_s7, ~bdi_s8,
  1, 33, 35, 37, 34, 10, 10, 11, 35, 35,
  2, 26, 26, NA, 26, NA, 27, 33, 31, 30,
)



test_that("Count intervals works incl 1to2", {
  count_intervals_test <- count_intervals(
    data = df,
    id_var_name = "id",
    sg_var_list = c(
      "bdi_s0", "bdi_s1", "bdi_s2", "bdi_s3", "bdi_s4",
      "bdi_s5", "bdi_s7", "bdi_s7", "bdi_s8"
    ),
    identify_sg_1to2 = TRUE
  )

  expect_equal(count_intervals_test$total_between_sess_intervals, 16)
  expect_equal(count_intervals_test$total_between_sess_intervals_sg, 14)

  expect_equal(count_intervals_test$available_between_sess_intervals_sg, 6)
  expect_equal(count_intervals_test$not_available_between_sess_intervals_sg, 4)
})

test_that("Count intervals works not 1to2", {
  count_intervals_test <- count_intervals(
    data = df,
    id_var_name = "id",
    sg_var_list = c(
      "bdi_s0", "bdi_s1", "bdi_s2", "bdi_s3", "bdi_s4",
      "bdi_s5", "bdi_s7", "bdi_s7", "bdi_s8"
    ),
    identify_sg_1to2 = FALSE
  )

  expect_equal(count_intervals_test$total_between_sess_intervals, 16)
  expect_equal(count_intervals_test$total_between_sess_intervals_sg, 12)

  expect_equal(count_intervals_test$available_between_sess_intervals_sg, 6)
  expect_equal(count_intervals_test$not_available_between_sess_intervals_sg, 4)
})
