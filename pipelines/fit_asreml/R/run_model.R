#' Run ASREML
#'
#' @param data a data frame
#' @param trait a trait name from df
#' @param distribution family, gaussian default
#' @param fixed.formula assumes intercept only
#' @param random.formula  default assumes single vine model with Additive rm linking to eBrida Pedigree Item
#'
#' @return model
#' @export
#'
#' @examples
run_model <- function(data,
                      na.action = na.method(x='include'),
                      workspace="500mb",
                      family = asr_gaussian(),
                      fixed.RHS ,
                      random.RHS,
                      residual = ~ idv(units),
                      env = caller_env()){
  require(rlang)
  require(asreml)

  data <- enexpr(data)
  na.action <- enexpr(na.action)
  family <- enexpr(family)
  fixed.RHS <- enexprs(fixed.RHS)
  #fixed.formula <- paste(trait,'~',fixed.RHS)
  fixed.formula <- fixed.RHS
  random.RHS <- enexpr(random.RHS)
  random.formula <- random.RHS
  residual <- enexpr(residual)
  residual.formula <- residual
  model_call <- expr(asreml(data = !!data,
                          fixed= as.formula(!!fixed.formula),
                          na.action= !!na.action,
                          workspace=!!workspace,
                          random = as.formula(!!random.formula),
                          residual = as.formula(!!residual.formula))
                   )
  return(model_call)
  eval(model_call)
 
 

}