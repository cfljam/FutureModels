## Pipeline to fit models w ASREML-R


source('Packages.R')
## load project code
lapply(list.files('./R', full.names = TRUE), source)

## Set up Config for future.batchtools and execution plan
# template <-'./slurm.tmpl'
# ### -- SLURM setup -----#
# library(RLinuxModules)
# module('load Slurm')
# library(future)
# library(future.batchtools)
# future::plan(strategy = batchtools_slurm,
# 			 template=template,
# 			 registry = list("cluster.functions$fs.latency" = 1000,
# 			 				"cluster.functions$scheduler.latency" = 1000))
# ## Set default worker resources
# tar_option_set(
# 	deployment = 'main',
# 	error = "abridge",
# 	storage = "main",
# 	resources = tar_resources(future =
# 							  	tar_resources_future(resources =
# 							  						 	list(ncpus = 1,
# 							  						 		 walltime = 3600,
# 							  						 		 memory=1000)))
#)

models <- read.csv('./DATA/models.csv')

list(
	tar_target(gryphon,
			   readRDS(here::here('DATA','gryphon.RDS'))),
	tar_target(gryphonped,
			   readRDS(here::here('DATA','gryphonped.RDS'))),
	tar_target(ainv,
			   ainverse(gryphonped)),
	tar_map(
		names = name,
		values = models,
		tar_target(
			model,
			run_model(
				data = gryphon,
				trait = trait,
				family = family,
				na.action = na.method(x = 'omit'),
				workspace = "10000mb",
				fixed.RHS = fixed,
				random.RHS = vm(animal , tar_read(ainv)))))
)