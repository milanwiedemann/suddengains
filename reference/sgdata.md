# Example dataset dataset with repeated measures of depression and rumination

Example dataset with a measure of depression symptoms (BDI) and a
secondary process measure (RQ; Rumination Questionnaire) to illustrate
how the package works.

## Usage

``` r
data(sgdata)
```

## Format

A longitudinal dataset in wide format, i.e one row per person, one
column per variable.

- id: ID variable, unique identifier for each person

- bdi_s0: BDI value, baseline assessment

- bdi_s1: BDI value, session 1

- bdi_s2: BDI value, session 2

- bdi_s3: BDI value, session 3

- bdi_s4: BDI value, session 4

- bdi_s5: BDI value, session 5

- bdi_s6: BDI value, session 6

- bdi_s7: BDI value, session 7

- bdi_s8: BDI value, session 8

- bdi_s9: BDI value, session 9

- bdi_s10: BDI value, session 10

- bdi_s11: BDI value, session 11

- bdi_s12: BDI value, session 12

- bdi_fu1: BDI value, follow-up measure 1

- bdi_fu2: BDI value, follow-up measure 2

- rq_s0: RQ value, baseline assessment

- rq_s1: RQ value, session 1

- rq_s2: RQ value, session 2

- rq_s3: RQ value, session 3

- rq_s4: RQ value, session 4

- rq_s5: RQ value, session 5

- rq_s6: RQ value, session 6

- rq_s7: RQ value, session 7

- rq_s8: RQ value, session 8

- rq_s9: RQ value, session 9

- rq_s10: RQ value, session 10

- rq_s11: RQ value, session 11

- rq_s12: RQ value, session 12

- rq_fu1: RQ value, follow-up measure 1

- rq_fu2: RQ value, follow-up measure 2

## Examples

``` r
# Load data into global environment
data(sgdata)
```
