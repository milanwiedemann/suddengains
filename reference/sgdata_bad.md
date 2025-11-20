# Example dataset dataset with repeated measures of depression and rumination (bad variable names)

Same as `sgdata` but with bad variable names to illustrate that the
package can also work with inconsistent names.

## Usage

``` r
data(sgdata_bad)
```

## Format

A longitudinal dataset in wide format, i.e one row per person, one
column per variable.

- id: ID variable, unique identifier for each person

- bdi_intake: BDI value, baseline assessment

- bdi1: BDI value, session 1

- wk2bdi: BDI value, session 2

- bdi.S3: BDI value, session 3

- bdis4: BDI value, session 4

- bdi_session5: BDI value, session 5

- bdi_weekSix: BDI value, session 6

- beck.dep.inv_sess7: BDI value, session 7

- weeeek8bdi: BDI value, session 8

- bdi_nine: BDI value, session 9

- bdii10: BDI value, session 10

- bDi11: BDI value, session 11

- bdi_s12_end: BDI value, session 12

- bdi_fu1: BDI value, follow-up measure 1

- bdi_followup2: BDI value, follow-up measure 2

- rq_intake: RQ value, baseline assessment

- rqi1: RQ value, session 1

- wk2rq: RQ value, session 2

- rq.S3: RQ value, session 3

- rq_s4: RQ value, session 4

- rq_session5: RQ value, session 5

- rq_weekSix: RQ value, session 6

- rq_sess7: RQ value, session 7

- weeeek8rq: RQ value, session 8

- rqnine: RQ value, session 9

- rq10: RQ value, session 10

- rqi11: RQ value, session 11

- rq_s12_end: RQ value, session 12

- prq_fu1: RQ value, follow-up measure 1

- rqq_followup2: RQ value, follow-up measure 2

## Examples

``` r
# Load data into global environment
data(sgdata_bad)
```
