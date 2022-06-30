# Fitting asreml Mixed Models via Future.Batchtools 

- to run on slurm use batchtools_slurm plan
- to run as multisession uncomment 

```
plan(multisession)
```
- to run in parallel
```
tar_make_future(workers=4L)

```
- to run without parallelization
```
tar_make()
```
- to customise target resources edit the tar_resources variables. **NB** need to provide _all_ variables required by the template
