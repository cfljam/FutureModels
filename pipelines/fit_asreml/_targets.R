## Pipeline to fit models w ASREML-R


source('Packages.R')
## load project code
lapply(list.files('./R', full.names = TRUE), source)

## Set up Config for future.batchtools and execution plan
template <-'./slurm.tmpl'
# ### -- SLURM setup -----#
 library(RLinuxModules)
 module('load Slurm')
library(future)
 library(future.batchtools)
future::plan(strategy = batchtools_slurm,
             template=template,
             registry = list("cluster.functions$fs.latency" = 100))

tar_option_set(
  deployment = 'main',
  error = "abridge",
  storage = "main",
  resources = tar_resources(future = 
                              tar_resources_future(resources = 
                                                     list(ncpus = 1,
                                                          walltime = 10,
                                                          memory=2100))),
)


#plan(multisession)
models <- read.csv('./DATA/models.csv')

list(
	tar_target(gryphon,
			   readRDS(here::here('DATA','gryphon.RDS'))),
	tar_target(gryphonped,
			   readRDS(here::here('DATA','gryphonped.RDS'))),
	tar_target(ainv,
			   ainverse(gryphonped),
			   packages=c('asreml')),
	tar_map(
		names = name,
		values = models,
		unlist = T,
		tar_target(
			model,
			{
			run_model(
				data = tar_read(gryphon),
				family = family,
				na.action = na.method(x = 'omit',y='omit'),
				workspace = "1000mb",
				fixed.RHS = fixed,
				random.RHS = randomterm)
				},
				packages=c('asreml'),
				deployment = 'worker'
				# resources = tar_resources(future = 
                #               tar_resources_future(resources = 
                #                                      list(ncpus = 1,
                #                                           walltime = 10,
                #                                           memory=10000))))
	
	))

)
