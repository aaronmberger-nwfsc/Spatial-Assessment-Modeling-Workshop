#' 1 area single representative dataset
#'
#' A single representative dataset aggregated at the 1 area scale. The chosen dataset is simulation #4.
#' List objects include aggregated catch, cpue, length frequencies, and tagging data (along with biological data).
#'
#' @format A data frame 'YFT_SRD_1A_4.RData' with variables:
#' \describe{
#'   \item{dat_4A_44}{Simulated aggregated 1 area datasets for YFT; Simulation #4}
#'   \item{biol_dat}{Biological data for YFT}
#' }
#' 
#' @name YFT_SRD_1A_4
#' @docType data
#' @details 
#' The key lists in __YFT_SRD_1A_4$__ (e.g., dat_1A_4$lencomp) include: 
#' 
#' *lencomp*: (list) 1 area dataframe of aggregated length frequencies by length bin with columns corresponding to pseudo-year (Yr), season(Seas), fleet/survey index (FltSvy), gender (Gender),  partition – length data come from all fish encountered (Part=0), number of lengths sampled (Nsamp), and the set of length bins (purse seine only)
#' 
#' *catch*: (list) 1 area dataframe of catch by fishery, including pseudo-year (year), and    season (seas)
#' 
#' *CPUE/cpu*: (list) 1 area cpue with columns for pseudo-year (year), season (seas), cpue (cpu), standard deviation associated with lognormal error in cpue (cv), and survey index (index); note that CPUE is for longline only
#' 
#' *tag_releases*: 1 area tag release data with columns corresponding to generic tag release event number (tg), area of release (reg), pseudo-year (yr), season (season), gender (gender), age (age), and number of releases (nrel) adjusted for initial tag mortality 
#' 
#' *tag_recaps*: 1 area tag recapture data with columns corresponding to generic tag release event number (tg), pseudo-year (yr), season (season), fleet index (fleet), and the number of recaptures (recaps)
#' 
#' 
#' The lists in __biol_dat__ include:
#' 
#' *M:* age varying natural mortality
#' *age*: first age to last age (pseudo-years)
#' *maturity*: maturity at age ogive (pseudo-years)
#' *k*: age varying growth coefficients
#' *L*: length (cm) 
#' *Linf*: length infinity (cm)
#' *Lmin*: length minimum (cm)
#' *a*: length-weight scaling coefficient
#' *b*: length-weight shape parameter

#' @usage data('YFT_SRD_1A_4')
#' @examples 
#' data('YFT_SRD_1A_4')
#' head(dat_1A_4$catch)
NULL

#' 4 area single representative dataset
#'
#' A single representative dataset aggregated at the 4 area scale. The chosen dataset is simulation #4.
#' List objects include aggregated catch, cpue, length frequencies, and tagging data (along with biological data).

#'
#' @format A data frame 'YFT_SRD_1A_4.RData' with variables:
#' \describe{
#'   \item{dat_4A_4}{Simulated aggregated 1 area datasets for YFT; Simulation #4}
#'   \item{biol_dat}{Biological data for YFT}
#' }
#' 
#' @name YFT_SRD_4A_4
#' @docType data
#' @details 
#' The key lists in __YFT_SRD_1A_4$__ (e.g., dat_1A_4$lencomp) include: 
#' 
#' *lencomp*: (list) 1 area dataframe of aggregated length frequencies by length bin with columns corresponding to pseudo-year (Yr), season(Seas), fleet/survey index (FltSvy), gender (Gender),  partition – length data come from all fish encountered (Part=0), number of lengths sampled (Nsamp), and the set of length bins (purse seine only)
#' 
#' *catch*: (list) 1 area dataframe of catch by fishery, including pseudo-year (year), and    season (seas)
#' 
#' *CPUE/cpu*: (list) 1 area cpue with columns for pseudo-year (year), season (seas), cpue (cpu), standard deviation associated with lognormal error in cpue (cv), and survey index (index); note that CPUE is for longline only
#' 
#' *tag_releases*: 1 area tag release data with columns corresponding to generic tag release event number (tg), area of release (reg), pseudo-year (yr), season (season), gender (gender), age (age), and number of releases (nrel) adjusted for initial tag mortality 
#' 
#' *tag_recaps*: 1 area tag recapture data with columns corresponding to generic tag release event number (tg), pseudo-year (yr), season (season), fleet index (fleet), and the number of recaptures (recaps)
#' 
#' 
#' The lists in __biol_dat__ include:
#' 
#' *M:* age varying natural mortality
#' *age*: first age to last age (pseudo-years)
#' *maturity*: maturity at age ogive (pseudo-years)
#' *k*: age varying growth coefficients
#' *L*: length (cm) 
#' *Linf*: length infinity (cm)
#' *Lmin*: length minimum (cm)
#' *a*: length-weight scaling coefficient
#' *b*: length-weight shape parameter
#' 
#' @usage data('YFT_SRD_4A_4')
#' @examples 
#' data('YFT_SRD_4A_4')
#' head(dat_1A_1$catch)
NULL

#' 100 simulated YFT datasets at the 1 area scale
#'
#' A dataset 100 simulations of the YFT 1 area aggregated catch, cpue, length frequencies, and tagging data (along with biological data).
#'
#' @format A data frame 'YFT_1area_observations_1_100.RData' with variables:
#' \describe{
#'   \item{dat_1A_X}{Simulated aggregated 1 area datasets for YFT; X=1:100}
#'   \item{biol_dat}{Biological data for YFT}
#' }
#' 
#' @name YFT_1area_observations_1_100
#' @docType data
#' @details 
#' The key lists in __YFT_SRD_1A_4$__ (e.g., dat_1A_4$lencomp) include: 
#' 
#' *lencomp*: (list) 1 area dataframe of aggregated length frequencies by length bin with columns corresponding to pseudo-year (Yr), season(Seas), fleet/survey index (FltSvy), gender (Gender),  partition – length data come from all fish encountered (Part=0), number of lengths sampled (Nsamp), and the set of length bins (purse seine only)
#' 
#' *catch*: (list) 1 area dataframe of catch by fishery, including pseudo-year (year), and    season (seas)
#' 
#' *CPUE/cpu*: (list) 1 area cpue with columns for pseudo-year (year), season (seas), cpue (cpu), standard deviation associated with lognormal error in cpue (cv), and survey index (index); note that CPUE is for longline only
#' 
#' *tag_releases*: 1 area tag release data with columns corresponding to generic tag release event number (tg), area of release (reg), pseudo-year (yr), season (season), gender (gender), age (age), and number of releases (nrel) adjusted for initial tag mortality 
#' 
#' *tag_recaps*: 1 area tag recapture data with columns corresponding to generic tag release event number (tg), pseudo-year (yr), season (season), fleet index (fleet), and the number of recaptures (recaps)
#' 
#' 
#' Explanations of list object items in the provided data files that analysts may find additionally useful. Much of these follow, or closely follow, Stock Synthesis (version SS3.24Z) naming conventions.  The name is the list identifier in each Rdata object (e.g., the name styr is found using dat_1A_4$styr).
#' 
#' *styr*	Start year (pseudo-year)
#' 
#' *endyr*	End year (pseudo-year)
#' 
#' *nseas*	Number of seasons
#' 
#' *months_per_seas*	Months per season
#' 
#' *spawn_seas*	Season when spawning occurs
#' 
#' *Nfleet*	Number of fishing fleets
#' 
#' *Nsurveys*	Number of surveys (fishery-dependent CPUE)
#' 
#' *N_areas*	Number of spatial areas
#' 
#' *fleetnames*	Specific fleet and survey index names
#' 
#' *surveytiming*	Timing of fleet and surveys
#' 
#' *areas*	Areas where each fleet or survey operate 
#' 
#' *units_of_catch*	Specifies units for catch (2=numbers of fish)
#' 
#' *se_log_catch*	Standard error associated with catch
#' 
#' *Ngenders*	Number of sexes
#' 
#' *Nages*	Number of ages
#' 
#' *lbin_vector_pop*	Vector of length bins in the population (cm)
#' 
#' *lbin_vector*	Vector of length bins in the data (cm)
#' 
#' *N_tag_groups*	Number of tag release events
#' 
#' *N_recap_events*	Number of recapture events
#' 
#' *mixing_latency_period*	Length of time units (psudo-years) necessary to allow for tag
#' mixing

#' The lists in __biol_dat__ include:
#' 
#' *M:* age varying natural mortality
#' 
#' *age*: first age to last age (pseudo-years)
#' 
#' *maturity*: maturity at age ogive (pseudo-years)
#' 
#' *k*: age varying growth coefficients
#' 
#' *L*: length (cm) 
#' 
#' *Linf*: length infinity (cm)
#' 
#' *Lmin*: length minimum (cm)
#' 
#' *a*: length-weight scaling coefficient
#' 
#' *b*: length-weight shape parameter
#' 
#' @usage data('YFT_1area_observations_1-100')
#' @examples 
#' data('YFT_1area_observations_1_100')
#' head(dat_1A_1$catch)
#' head(biol_dat)
#' 
NULL

#' 100 simulated YFT datasets at the 4 area scale
#'
#' 100 simulations of the YFT 1 area aggregated catch, cpue, length frequencies, and tagging data (along with biological data).
#'
#' @format A data frame 'YFT_4area_observations_1_100.RData' with variables:
#' \describe{
#'   \item{dat_4A_X}{Simulated aggregated 4 area datasets for YFT; X=1:100}
#'   \item{biol_dat}{Biological data for YFT}
#' }
#' 
#' @name YFT_4area_observations_1_100
#' @docType data
#' @details 
#' The key lists in __YFT_SRD_1A_4$__ (e.g., dat_1A_4$lencomp) include: 
#' 
#' *lencomp*: (list) 1 area dataframe of aggregated length frequencies by length bin with columns corresponding to pseudo-year (Yr), season(Seas), fleet/survey index (FltSvy), gender (Gender),  partition – length data come from all fish encountered (Part=0), number of lengths sampled (Nsamp), and the set of length bins (purse seine only)
#' 
#' *catch*: (list) 1 area dataframe of catch by fishery, including pseudo-year (year), and    season (seas)
#' 
#' *CPUE/cpu*: (list) 1 area cpue with columns for pseudo-year (year), season (seas), cpue (cpu), standard deviation associated with lognormal error in cpue (cv), and survey index (index); note that CPUE is for longline only
#' 
#' *tag_releases*: 1 area tag release data with columns corresponding to generic tag release event number (tg), area of release (reg), pseudo-year (yr), season (season), gender (gender), age (age), and number of releases (nrel) adjusted for initial tag mortality 
#' 
#' *tag_recaps*: 1 area tag recapture data with columns corresponding to generic tag release event number (tg), pseudo-year (yr), season (season), fleet index (fleet), and the number of recaptures (recaps)
#' 
#' 
#' Explanations of list object items in the provided data files that analysts may find additionally useful. Much of these follow, or closely follow, Stock Synthesis (version SS3.24Z) naming conventions.  The name is the list identifier in each Rdata object (e.g., the name styr is found using dat_1A_4$styr).
#' 
#' *styr*	Start year (pseudo-year)
#' 
#' *endyr*	End year (pseudo-year)
#' 
#' *nseas*	Number of seasons
#' 
#' *months_per_seas*	Months per season
#' 
#' *spawn_seas*	Season when spawning occurs
#' 
#' *Nfleet*	Number of fishing fleets
#' 
#' *Nsurveys*	Number of surveys (fishery-dependent CPUE)
#' 
#' *N_areas*	Number of spatial areas
#' 
#' *fleetnames*	Specific fleet and survey index names
#' 
#' *surveytiming*	Timing of fleet and surveys
#' 
#' *areas*	Areas where each fleet or survey operate 
#' 
#' *units_of_catch*	Specifies units for catch (2=numbers of fish)
#' 
#' *se_log_catch*	Standard error associated with catch
#' 
#' *Ngenders*	Number of sexes
#' 
#' *Nages*	Number of ages
#' 
#' *lbin_vector_pop*	Vector of length bins in the population (cm)
#' 
#' *lbin_vector*	Vector of length bins in the data (cm)
#' 
#' *N_tag_groups*	Number of tag release events
#' 
#' *N_recap_events*	Number of recapture events
#' 
#' *mixing_latency_period*	Length of time units (psudo-years) necessary to allow for tag
#' mixing

#' The lists in __biol_dat__ include:
#' 
#' *M:* age varying natural mortality
#' 
#' *age*: first age to last age (pseudo-years)
#' 
#' *maturity*: maturity at age ogive (pseudo-years)
#' 
#' *k*: age varying growth coefficients
#' 
#' *L*: length (cm) 
#' 
#' *Linf*: length infinity (cm)
#' 
#' *Lmin*: length minimum (cm)
#' 
#' *a*: length-weight scaling coefficient
#' 
#' *b*: length-weight shape parameter
#' @usage data('YFT_4area_observations_1-100')
#' 
#' @examples 
#' data('YFT_4area_observations_1_100')
#' head(dat_4A_1$catch)
NULL

