test_that("Define crit 1 cutoff from data works", {
  crit1_test <- define_crit1_cutoff(
    data_sd = sgdata$bdi_s0,
    reliability = 0.931
  )

  expect_equal(crit1_test$sd, 6.396073, tolerance = 0.001)
  expect_equal(crit1_test$reliability, 0.931, tolerance = 0.001)
  expect_equal(crit1_test$standard_error_measurement, 1.680111, tolerance = 0.001)
  expect_equal(crit1_test$standard_error_difference, 2.376036, tolerance = 0.001)
  expect_equal(crit1_test$reliable_change_value, 4.65703, tolerance = 0.001)
})


test_that("Define crit 1 cutoff specify sd works", {
  crit1_test <- define_crit1_cutoff(
    sd = 10.5,
    reliability = 0.961
  )

  expect_equal(crit1_test$sd, 10.5, tolerance = 0.001)
  expect_equal(crit1_test$reliability, 0.961, tolerance = 0.001)
  expect_equal(crit1_test$standard_error_measurement, 2.073584, tolerance = 0.001)
  expect_equal(crit1_test$standard_error_difference, 2.93249, tolerance = 0.001)
  expect_equal(crit1_test$reliable_change_value, 5.747681, tolerance = 0.001)
})

test_that("Define crit 1 cutoff from data error NULL", {
  expect_error(define_crit1_cutoff(
    data_sd = sgdata$bdi_s0,
    reliability = NULL
  ))
})

test_that("Define crit 1 cutoff from data error invalid reliability", {
  expect_error(define_crit1_cutoff(
    data_sd = 10,
    reliability = 2
  ))
})

test_that("Define crit 1 cutoff from data error no sd", {
  expect_error(define_crit1_cutoff(
    data_sd = NULL,
    sd = NULL,
    reliability = .5
  ))
})

test_that("Define crit 1 cutoff from data error two sd", {
  expect_error(define_crit1_cutoff(
    data_sd = sgdata$bdi_s0,
    sd = 10,
    reliability = .5
  ))
})
