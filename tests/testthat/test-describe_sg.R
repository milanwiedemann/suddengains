bysg <- create_bysg(
  data = sgdata,
  sg_crit1_cutoff = 7,
  id_var_name = "id",
  tx_start_var_name = "bdi_s1",
  tx_end_var_name = "bdi_s12",
  sg_var_list = c(
    "bdi_s1", "bdi_s2", "bdi_s3",
    "bdi_s4", "bdi_s5", "bdi_s6",
    "bdi_s7", "bdi_s8", "bdi_s9",
    "bdi_s10", "bdi_s11", "bdi_s12"
  ),
  sg_measure_name = "bdi"
)

byperson <- create_byperson(
  data = sgdata,
  sg_crit1_cutoff = 7,
  id_var_name = "id",
  tx_start_var_name = "bdi_s1",
  tx_end_var_name = "bdi_s12",
  sg_var_list = c(
    "bdi_s1", "bdi_s2", "bdi_s3",
    "bdi_s4", "bdi_s5", "bdi_s6",
    "bdi_s7", "bdi_s8", "bdi_s9",
    "bdi_s10", "bdi_s11", "bdi_s12"
  ),
  sg_measure_name = "bdi"
)


test_that("Describe sg by sg works", {
  test_describe_sg <- describe_sg(
    data = bysg,
    sg_data_structure = "bysg"
  )

  expect_equal(test_describe_sg$total_n, 24)
  expect_equal(test_describe_sg$sg_total_n, 24)
  expect_equal(test_describe_sg$sg_pct, 100)
  expect_equal(test_describe_sg$sg_multiple_pct, 70.83)
  expect_equal(test_describe_sg$sg_reversal_n, 4)
  expect_equal(test_describe_sg$sg_reversal_pct, 16.67)
  expect_equal(test_describe_sg$sg_magnitude_m, 11)
  expect_equal(test_describe_sg$sg_magnitude_sd, 3.43)

  names_expect <- c("total_n", "sg_total_n", "sg_pct", "sg_multiple_pct", "sg_reversal_n", "sg_reversal_pct", "sg_magnitude_m", "sg_magnitude_sd")

  names_test <- names(test_describe_sg)

  expect_equal(names_expect, names_test)
})

test_that("Describe sg by person works", {
  test_describe_sg <- describe_sg(
    data = byperson,
    sg_data_structure = "byperson"
  )

  expect_equal(test_describe_sg$total_n, 43)
  expect_equal(test_describe_sg$sg_total_n, 24)

  expect_equal(test_describe_sg$sg_n, 15)
  expect_equal(test_describe_sg$sg_pct, 34.88)

  expect_equal(test_describe_sg$sg_multiple_n, 8)
  expect_equal(test_describe_sg$sg_multiple_pct, 18.6)

  expect_equal(test_describe_sg$sg_reversal_n, 3)
  expect_equal(test_describe_sg$sg_reversal_pct, 20)
  expect_equal(test_describe_sg$sg_magnitude_m, 11.4)
  expect_equal(test_describe_sg$sg_magnitude_sd, 3.98)

  names_expect <- c("total_n", "sg_total_n", "sg_n", "sg_pct", "sg_multiple_n", "sg_multiple_pct", "sg_reversal_n", "sg_reversal_pct", "sg_magnitude_m", "sg_magnitude_sd")

  names_test <- names(test_describe_sg)

  expect_equal(names_expect, names_test)
})
