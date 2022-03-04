#' START HERE (YFT): 1 area single representative dataset.
#'
#' A single representative dataset (SRD) aggregated at the 1 area scale. The chosen dataset is simulation #4.
#' List objects include aggregated catch, cpue, length frequencies, and tagging data (along with biological data).
#'
#' @format A data frame 'YFT_SRD_1A_4.RData' with variables:
#' \describe{
#'   \item{dat_1A_X}{Simulated aggregated 1 area datasets for YFT; X=1:100}
#'   \item{biol_dat}{Biological data for YFT}
#' }
#' 
#' @name YFT_SRD_1A_4
#' @docType data
#' @details 
#' 
#' # The key lists in __YFT_SRD_1A_4$__ (e.g., dat_1A_4$lencomp) include: 
#' 
#' ***lencomp***: (list) 1 area dataframe of aggregated length frequencies by length bin with columns corresponding to pseudo-year (Yr), season (Seas), fleet/survey index (FltSvy), sex (Gender),  partition – length data come from all fish encountered (Part=0), number of lengths sampled (Nsamp), and the set of length bins.
#' 
#' ***catch***: (list) 1 area dataframe of catch by fishery, including pseudo-year (year), and    season (seas)
#' 
#' ***CPUE/cpu***: (list) 1 area cpue with columns for pseudo-year (year), season (seas), cpue (cpu), standard deviation associated with lognormal error in cpue (cv), and survey index (index); note that CPUE is for longline only
#' 
#' ***tag_releases***: 1 area tag release data with columns corresponding to generic tag release event number (tg), area of release (reg), pseudo-year (yr), season (season), sex (Gender), age (age), and number of releases (nrel) adjusted for initial tag mortality 
#' 
#' ***tag_recaps***: 1 area tag recapture data with columns corresponding to generic tag release event number (tg), pseudo-year (yr), season (season), fleet index (fleet), and the number of recaptures (recaps)
#' 
#' 
#' # Explanations of list object items in the provided data files that analysts may find additionally useful. 
#' Much of these follow, or closely follow, Stock Synthesis (version SS3.24Z) naming conventions.  The name is the list identifier in each Rdata object (e.g., the name styr is found using dat_1A_4$styr).
#' 
#' ***styr***	Start year (pseudo-year)
#' 
#' ***endyr***	End year (pseudo-year)
#' 
#' ***nseas***	Number of seasons
#' 
#' ***months_per_seas***	Months per season
#' 
#' ***spawn_seas***	Season when spawning occurs
#' 
#' ***Nfleet***	Number of fishing fleets
#' 
#' ***Nsurveys***	Number of surveys (fishery-dependent CPUE)
#' 
#' ***N_areas***	Number of spatial areas
#' 
#' ***fleetnames***	Specific fleet and survey index names
#' 
#' ***surveytiming***	Timing of fleet and surveys
#' 
#' ***areas***	Areas where each fleet or survey operate 
#' 
#' ***units_of_catch***	Specifies units for catch (2=numbers of fish)
#' 
#' ***se_log_catch***	Standard error associated with catch
#' 
#' ***Ngenders***	Number of sexes
#' 
#' ***Nages***	Number of ages
#' 
#' ***lbin_vector_pop***	Vector of length bins in the population (cm)
#' 
#' ***lbin_vector***	Vector of length bins in the data (cm)
#' 
#' ***N_tag_groups***	Number of tag release events
#' 
#' ***N_recap_events***	Number of recapture events
#' 
#' ***mixing_latency_period***	Length of time units (psudo-years) necessary to allow for tag
#' mixing
#' 
#' # The lists in __biol_dat__ include:
#' 
#' ***M:*** age varying natural mortality
#' 
#' ***age***: first age to last age (pseudo-years)
#' 
#' ***maturity***: maturity at age ogive (pseudo-years)
#' 
#' ***k***: age varying growth coefficients
#' 
#' ***L***: length (cm) 
#' 
#' ***Linf***: length infinity (cm)
#' 
#' ***Lmin***: length minimum (cm)
#' 
#' ***a***: length-weight scaling coefficient
#' 
#' ***b***: length-weight shape parameter
#' 
#' ***LenAge_cv***: length-age coefficient of variability
#' 
#' @usage data('YFT_SRD_1A_4')
#' @examples 
#' data('YFT_SRD_1A_4')
#' head(dat_1A_4$catch)
#' head(biol_dat)
#' 
NULL

#' START HERE (YFT): 4 area single representative dataset
#'
#' A single representative dataset aggregated at the 4 area scale. The chosen dataset is simulation #4.
#' List objects include aggregated catch, cpue, length frequencies, and tagging data (along with biological data).
#'
#' @format A data frame 'YFT_SRD_4A_4.RData' with variables:
#' \describe{
#'   \item{dat_4A_X}{Simulated aggregated 4 area datasets for YFT}
#'   \item{biol_dat}{Biological data for YFT}
#' }
#' 
#' @name YFT_SRD_4A_4
#' @docType data
#' @details 
#' 
#' # The key lists in __YFT_SRD_4A_4$__ (e.g., dat_4A_4$lencomp) include: 
#' 
#' ***lencomp***: (list) 4 area dataframe of aggregated length frequencies by length bin with columns corresponding to pseudo-year (Yr), season(Seas), fleet/survey index (FltSvy), sex (Gender),  partition – length data come from all fish encountered (Part=0), number of lengths sampled (Nsamp), and the set of length bins.
#' 
#' ***catch***: (list) 4 area dataframe of catch by fishery, including pseudo-year (year), and    season (seas)
#' 
#' ***CPUE/cpu***: (list) 4 area cpue with columns for pseudo-year (year), season (seas), cpue (cpu), standard deviation associated with lognormal error in cpue (cv), and survey index (index); note that CPUE is for longline only
#' 
#' ***tag_releases***: 4 area tag release data with columns corresponding to generic tag release event number (tg), area of release (reg), pseudo-year (yr), season (season), sex (Gender), age (age), and number of releases (nrel) adjusted for initial tag mortality 
#' 
#' ***tag_recaps***: 4 area tag recapture data with columns corresponding to generic tag release event number (tg), pseudo-year (yr), season (season), fleet index (fleet), and the number of recaptures (recaps)
#' 
#' 
#' # Explanations of list object items in the provided data files that analysts may find additionally useful. 
#' Much of these follow, or closely follow, Stock Synthesis (version SS3.24Z) naming conventions.  The name is the list identifier in each Rdata object (e.g., the name styr is found using dat_1A_4$styr).
#' 
#' ***styr***	Start year (pseudo-year)
#' 
#' ***endyr***	End year (pseudo-year)
#' 
#' ***nseas***	Number of seasons
#' 
#' ***spawn_seas***	Season when spawning occurs
#' 
#' ***Nfleet***	Number of fishing fleets
#' 
#' ***Nsurveys***	Number of surveys (fishery-dependent CPUE)
#' 
#' ***N_areas***	Number of spatial areas
#' 
#' ***fleetnames***	Specific fleet and survey index names
#' 
#' ***surveytiming***	Timing of fleet and surveys
#' 
#' ***areas***	Areas where each fleet or survey operate 
#' 
#' ***units_of_catch***	Specifies units for catch (2=numbers of fish)
#' 
#' ***se_log_catch***	Standard error associated with catch
#' 
#' ***Ngenders***	Number of sexes
#' 
#' ***Nages***	Number of ages
#' 
#' ***lbin_vector_pop***	Vector of length bins in the population (cm)
#' 
#' ***lbin_vector***	Vector of length bins in the data (cm)
#' 
#' ***N_tag_groups***	Number of tag release events
#' 
#' ***N_recap_events***	Number of recapture events
#' 
#' ***mixing_latency_period***	Length of time units (psudo-years) necessary to allow for tag
#' mixing
#' 
#' # The lists in __biol_dat__ include:
#' 
#' ***M:*** age varying natural mortality
#' 
#' ***age***: first age to last age (pseudo-years)
#' 
#' ***maturity***: maturity at age ogive (pseudo-years)
#' 
#' ***k***: age varying growth coefficients
#' 
#' ***L***: length (cm) 
#' 
#' ***Linf***: length infinity (cm)
#' 
#' ***Lmin***: length minimum (cm)
#' 
#' ***a***: length-weight scaling coefficient
#' 
#' ***b***: length-weight shape parameter
#' 
#' ***LenAge_cv***: length-age coefficient of variability
#' 
#' @usage data('YFT_SRD_4A_4')
#' @examples 
#' data('YFT_SRD_4A_4')
#' head(dat_4A_4$catch)
#' head(biol_dat)
#' 
NULL

#' YFT MAIN DATASET: 100 simulated YFT datasets at the 1 area scale
#'
#' This R data file contains 100 data sets for a one area YFT model.  
#' 100 simulations of the YFT 1 area aggregated catch, cpue, length frequencies, and tagging data (along with biological data).
#'
#' @format A data frame 'YFT_1area_observations_1_100_ESS_05.Rdata' with variables:
#' \describe{
#'   \item{dat_1A_X}{Simulated aggregated 1 area datasets for YFT; X=1:100}
#'   \item{biol_dat}{Biological data for YFT}
#' }
#' 
#' @name YFT_1area_observations_1_100
#' @docType data
#' @details
#' 
#'  # The key lists in __YFT_1area_observations_1_100$__ (e.g., dat_1A_1$lencomp) include: 
#' 
#' ***lencomp***: (list) 1 area dataframe of aggregated length frequencies by length bin with columns corresponding to pseudo-year (Yr), season(Seas), fleet/survey index (FltSvy), sex (Gender),  partition – length data come from all fish encountered (Part=0), number of lengths sampled (Nsamp), and the set of length bins.
#' 
#' ***catch***: (list) 1 area dataframe of catch by fishery, including pseudo-year (year), and    season (seas)
#' 
#' ***CPUE/cpu***: (list) 1 area cpue with columns for pseudo-year (year), season (seas), cpue (cpu), standard deviation associated with lognormal error in cpue (cv), and survey index (index); note that CPUE is for longline only
#' 
#' ***tag_releases***: 1 area tag release data with columns corresponding to generic tag release event number (tg), area of release (reg), pseudo-year (yr), season (season), sex (Gender), age (age), and number of releases (nrel) adjusted for initial tag mortality 
#' 
#' ***tag_recaps***: 1 area tag recapture data with columns corresponding to generic tag release event number (tg), pseudo-year (yr), season (season), fleet index (fleet), and the number of recaptures (recaps)
#' 
#' 
#' # Explanations of list object items in the provided data files that analysts may find additionally useful. 
#' Much of these follow, or closely follow, Stock Synthesis (version SS3.24Z) naming conventions.  The name is the list identifier in each Rdata object (e.g., the name styr is found using dat_1A_4$styr).
#' 
#' ***styr***	Start year (pseudo-year)
#' 
#' ***endyr***	End year (pseudo-year)
#' 
#' ***nseas***	Number of seasons
#' 
#' ***spawn_seas***	Season when spawning occurs
#' 
#' ***Nfleet***	Number of fishing fleets
#' 
#' ***Nsurveys***	Number of surveys (fishery-dependent CPUE)
#' 
#' ***N_areas***	Number of spatial areas
#' 
#' ***fleetnames***	Specific fleet and survey index names
#' 
#' ***surveytiming***	Timing of fleet and surveys
#' 
#' ***areas***	Areas where each fleet or survey operate 
#' 
#' ***units_of_catch***	Specifies units for catch (2=numbers of fish)
#' 
#' ***se_log_catch***	Standard error associated with catch
#' 
#' ***Ngenders***	Number of sexes
#' 
#' ***Nages***	Number of ages
#' 
#' ***lbin_vector_pop***	Vector of length bins in the population (cm)
#' 
#' ***lbin_vector***	Vector of length bins in the data (cm)
#' 
#' ***N_tag_groups***	Number of tag release events
#' 
#' ***N_recap_events***	Number of recapture events
#' 
#' ***mixing_latency_period***	Length of time units (psudo-years) necessary to allow for tag
#' mixing
#' 
#' # The lists in __biol_dat__ include:
#' 
#' ***M:*** age varying natural mortality
#' 
#' ***age***: first age to last age (pseudo-years)
#' 
#' ***maturity***: maturity at age ogive (pseudo-years)
#' 
#' ***k***: age varying growth coefficients
#' 
#' ***L***: length (cm) 
#' 
#' ***Linf***: length infinity (cm)
#' 
#' ***Lmin***: length minimum (cm)
#' 
#' ***a***: length-weight scaling coefficient
#' 
#' ***b***: length-weight shape parameter
#' 
#' ***LenAge_cv***: length-age coefficient of variability
#' 
#' @usage data('YFT_1area_observations_1_100_ESS_05')
#' @examples 
#' data('YFT_1area_observations_1_100_ESS_05')
#' head(dat_1A_1$catch)
#' head(biol_dat)
#' 
NULL

#' YFT MAIN DATASET: 100 simulated YFT datasets at the 4 area scale
#'
#' This R data file contains 100 data sets for a four area YFT model.  
#' 100 simulations of the YFT 4 area aggregated catch, cpue, length frequencies, and tagging data (along with biological data).
#'
#' @format A data frame 'YFT_4area_observations_1_100_ESS_05.RData' with variables:
#' \describe{
#'   \item{dat_4A_X}{Simulated aggregated 4 area datasets for YFT; X=1:100}
#'   \item{biol_dat}{Biological data for YFT}
#' }
#' 
#' @name YFT_4area_observations_1_100
#' @docType data
#' @details 
#' 
#' # The key lists in __YFT_4area_observations_1_100$__ (e.g., dat_4A_4$lencomp) include: 
#' 
#' # The key lists in __YFT_SRD_1A_4$__ (e.g., dat_4A_4$lencomp) include: 
#' 
#' ***lencomp***: (list) 1 area dataframe of aggregated length frequencies by length bin with columns corresponding to pseudo-year (Yr), season(Seas), fleet/survey index (FltSvy), sex (Gender),  partition – length data come from all fish encountered (Part=0), number of lengths sampled (Nsamp), and the set of length bins.
#' 
#' ***catch***: (list) 1 area dataframe of catch by fishery, including pseudo-year (year), and    season (seas)
#' 
#' ***CPUE/cpu***: (list) 1 area cpue with columns for pseudo-year (year), season (seas), cpue (cpu), standard deviation associated with lognormal error in cpue (cv), and survey index (index); note that CPUE is for longline only
#' 
#' ***tag_releases***: 1 area tag release data with columns corresponding to generic tag release event number (tg), area of release (reg), pseudo-year (yr), season (season), sex (Gender), age (age), and number of releases (nrel) adjusted for initial tag mortality 
#' 
#' ***tag_recaps***: 1 area tag recapture data with columns corresponding to generic tag release event number (tg), pseudo-year (yr), season (season), fleet index (fleet), and the number of recaptures (recaps)
#' 
#' 
#' # Explanations of list object items in the provided data files that analysts may find additionally useful. 
#' Much of these follow, or closely follow, Stock Synthesis (version SS3.24Z) naming conventions.  The name is the list identifier in each Rdata object (e.g., the name styr is found using dat_1A_4$styr).
#' 
#' ***styr***	Start year (pseudo-year)
#' 
#' ***endyr***	End year (pseudo-year)
#' 
#' ***nseas***	Number of seasons
#' 
#' ***spawn_seas***	Season when spawning occurs
#' 
#' ***Nfleet***	Number of fishing fleets
#' 
#' ***Nsurveys***	Number of surveys (fishery-dependent CPUE)
#' 
#' ***N_areas***	Number of spatial areas
#' 
#' ***fleetnames***	Specific fleet and survey index names
#' 
#' ***surveytiming***	Timing of fleet and surveys
#' 
#' ***areas***	Areas where each fleet or survey operate 
#' 
#' ***units_of_catch***	Specifies units for catch (2=numbers of fish)
#' 
#' ***se_log_catch***	Standard error associated with catch
#' 
#' ***Ngenders***	Number of sexes
#' 
#' ***Nages***	Number of ages
#' 
#' ***lbin_vector_pop***	Vector of length bins in the population (cm)
#' 
#' ***lbin_vector***	Vector of length bins in the data (cm)
#' 
#' ***N_tag_groups***	Number of tag release events
#' 
#' ***N_recap_events***	Number of recapture events
#' 
#' ***mixing_latency_period***	Length of time units (psudo-years) necessary to allow for tag
#' mixing
#' 
#' # The lists in __biol_dat__ include:
#' 
#' ***M:*** age varying natural mortality
#' 
#' ***age***: first age to last age (pseudo-years)
#' 
#' ***maturity***: maturity at age ogive (pseudo-years)
#' 
#' ***k***: age varying growth coefficients
#' 
#' ***L***: length (cm) 
#' 
#' ***Linf***: length infinity (cm)
#' 
#' ***Lmin***: length minimum (cm)
#' 
#' ***a***: length-weight scaling coefficient
#' 
#' ***b***: length-weight shape parameter
#' 
#' ***LenAge_cv***: length-age coefficient of variability
#' 
#' @usage data('YFT_4area_observations_1_100_ESS_05')
#' 
#' @examples 
#' data('YFT_4area_observations_1_100_ESS_05')
#' head(dat_4A_1$catch)
#' head(biol_dat)
NULL

#' YFT SUPPLEMENTAL DATASET: Fully spatial simulated datasets 
#' (Simulation #: 1-33)
#'
#'This R data file contains 1-33 simulated data sets at the 221 5x5 gird cell level, which 
#'matches the spatial resolution used in the OM.  These data are provided for your 
#'information and in a usable format if participants wish to develop spatially 
#'structured models beyond the one and four area aggregations already provided.
#'
#' @format A data frame 'YFT_221cell_observations_1-100_ESS_05.RData' with variables:
#' \describe{
#'   \item{sim_1}{Simulated aggregated 1 area datasets for YFT; Simulation #1-100}
#'   \item{biol_dat}{Biological data for YFT}
#' }
#' 
#' @name YFT_221cell_observations_1_100
#' @docType data
#' @details 
#' 
#' # The key lists in __sim_X$__ (e.g., sim_1$) include: 
#' 
#' ***Sim_X*** : Simulated spatial datasets, X: sim # 1-100
#' 
#' ***obs***: Simulated observations
#'          
#' ***simulated_ll_jpn_cpue_YYY***: CPUE data for pseudo-year YYY
#'                
#' ***simulated_XXX_lf_YYY***: Length frequencies for pseudo-year YYY
#'                
#' ***tagrel***: Tag releases
#' 
#' ***process[tag_XXX]***: Tag release in a given pseudo-year
#'                
#' ***tagrecs***: Simulated tag recapture data
#' 
#' ***observation[tag_recapture_XXX_in_YYY]***: tag recapture in a given pseudo-year from release cohort XXX
#'                
#' ***layer*** : Spatial grids defined within 'layer'
#'          
#' ***base***: 1 = on the water, 0 = on land
#'                
#' ***cell***: unique cell row and column numbers
#'                
#' ***constant***: 1
#'                
#' ***latitude***: latitude for each cell center
#'                
#' ***longitude***: longitude for each cell center
#'                
#' ***region***: IOTC YFT regions (R1a, R1b, R2, R3, R4, R5)
#'                
#' ***sst***: Sea Surface Temperature (see Dunn et al. 2020)
#'                
#' ***clo***: Chlorophyll (see Dunn et al. 2020)
#'                
#' ***fishing_ff_YY***: ff: fishery = ps, trol, bb, gill, ll, other, hand, YY = pseudo-year
#' 
#' # The lists in __biol_dat__ include:
#' 
#' ***M:*** age varying natural mortality
#' 
#' ***age***: first age to last age (pseudo-years)
#' 
#' ***maturity***: maturity at age ogive (pseudo-years)
#' 
#' ***k***: age varying growth coefficients
#' 
#' ***L***: length (cm) 
#' 
#' ***Linf***: length infinity (cm)
#' 
#' ***Lmin***: length minimum (cm)
#' 
#' ***a***: length-weight scaling coefficient
#' 
#' ***b***: length-weight shape parameter
#' 
#' ***LenAge_cv***: length-age coefficient of variability
#' 
#' @usage data('YFT_221cell_observations_1-100_ESS_05')
#' @examples 
#' data('YFT_221cell_observations_1-100_ESS_05')
#' head(sim_1$obs$simulated_cpue_ll_jpn_86$data$obs)
NULL

#' YFT SUPPLEMENTAL DATASET: Fully spatial simulated datasets 
#' (Simulation #: 34_66)
#'
#'This R data file contains 34-66 simulated data sets at the 221 5x5 grid cell level, which 
#'matches the spatial resolution used in the OM.  These data are provided for your 
#'information and in a usable format if participants wish to develop spatially 
#'structured models beyond the one and four area aggregations already provided.
#'
#' @format A data frame 'YFT_221cell_observations_34_66_v2' with variables:
#' \describe{
#'   \item{sim_1}{Simulated aggregated 1 area datasets for YFT; Simulation #34-66}
#'   \item{biol_dat}{Biological data for YFT}
#' }
#' 
#' @name YFT_221cell_observations_34_66_v2
#' @docType data
#' @details 
#' 
#' # The key lists in __sim_X$__ (e.g., sim_1$) include: 
#' 
#' ***Sim_X*** : Simulated spatial datasets, X: sim # 1-100
#' 
#' ***obs***: Simulated observations
#'          
#' ***simulated_ll_jpn_cpue_YYY***: CPUE data for pseudo-year YYY
#'                
#' ***simulated_XXX_lf_YYY***: Length frequencies for pseudo-year YYY
#'                
#' ***tagrel***: Tag releases
#' 
#' ***process[tag_XXX]***: Tag release in a given pseudo-year
#'                
#' ***tagrecs***: Simulated tag recapture data
#' 
#' ***observation[tag_recapture_XXX_in_YYY]***: tag recapture in a given pseudo-year from release cohort XXX
#'                
#' ***layer*** : Spatial grids defined within 'layer'
#'          
#' ***base***: 1 = on the water, 0 = on land
#'                
#' ***cell***: unique cell row and column numbers
#'                
#' ***constant***: 1
#'                
#' ***latitude***: latitude for each cell center
#'                
#' ***longitude***: longitude for each cell center
#'                
#' ***region***: IOTC YFT regions (R1a, R1b, R2, R3, R4, R5)
#'                
#' ***sst***: Sea Surface Temperature (see Dunn et al. 2020)
#'                
#' ***clo***: Chlorophyll (see Dunn et al. 2020)
#'                
#' ***fishing_ff_YY***: ff: fishery = ps, trol, bb, gill, ll, other, hand, YY = pseudo-year
#' 
#' # The lists in __biol_dat__ include:
#' 
#' ***M:*** age varying natural mortality
#' 
#' ***age***: first age to last age (pseudo-years)
#' 
#' ***maturity***: maturity at age ogive (pseudo-years)
#' 
#' ***k***: age varying growth coefficients
#' 
#' ***L***: length (cm) 
#' 
#' ***Linf***: length infinity (cm)
#' 
#' ***Lmin***: length minimum (cm)
#' 
#' ***a***: length-weight scaling coefficient
#' 
#' ***b***: length-weight shape parameter
#' 
#' @usage data('YFT_221cell_observations_34_66_v2')
#' @examples 
#' data('YFT_221cell_observations_34_66_v2')
#' head(sim_34$obs$simulated_cpue_ll_jpn_86$data$obs)
NULL

#' YFT SUPPLEMENTAL DATASET: Fully spatial simulated datasets 
#' (Simulation #: 67-100)
#'
#'This R data file contains 67-100 simulated data sets at the 221 5x5 grid cell level, which 
#'matches the spatial resolution used in the OM.  These data are provided for your 
#'information and in a usable format if participants wish to develop spatially 
#'structured models beyond the one and four area aggregations already provided.
#'
#' @format A data frame 'YFT_221cell_observations_67_100_v2' with variables:
#' \describe{
#'   \item{sim_1}{Simulated aggregated 1 area datasets for YFT; Simulation #67-100}
#'   \item{biol_dat}{Biological data for YFT}
#' }
#' 
#' @name YFT_221cell_observations_67_100_v2
#' @docType data
#' @details 
#' 
#' # The key lists in __sim_X$__ (e.g., sim_1$) include: 
#' ***Sim_X*** : Simulated spatial datasets, X: sim # 1-100
#' 
#' ***obs***: Simulated observations
#'          
#' ***simulated_ll_jpn_cpue_YYY***: CPUE data for pseudo-year YYY
#'                
#' ***simulated_XXX_lf_YYY***: Length frequencies for pseudo-year YYY
#'                
#' ***tagrel***: Tag releases
#' 
#' ***process[tag_XXX]***: Tag release in a given pseudo-year
#'                
#' ***tagrecs***: Simulated tag recapture data
#' 
#' ***observation[tag_recapture_XXX_in_YYY]***: tag recapture in a given pseudo-year from release cohort XXX
#'                
#' ***layer*** : Spatial grids defined within 'layer' (including cells, latitude, longitude for each grid cell, and catch data for each fishery)
#'          
#' ***base***: 1 = on the water, 0 = on land
#'                
#' ***cell***: unique cell row and column numbers
#'                
#' ***constant***: 1
#'                
#' ***latitude***: latitude for each cell center
#'                
#' ***longitude***: longitude for each cell center
#'                
#' ***region***: IOTC YFT regions (R1a, R1b, R2, R3, R4, R5)
#'                
#' ***sst***: Sea Surface Temperature (see Dunn et al. 2020)
#'                
#' ***clo***: Chlorophyll (see Dunn et al. 2020)
#'                
#' ***fishing_ff_YY***: ff: THIS IS THE CATCH DATA: fishery = ps, trol, bb, gill, ll, other, hand, YY = pseudo-year
#' 
#' # The lists in __biol_dat__ include:
#' 
#' ***M:*** age varying natural mortality
#' 
#' ***age***: first age to last age (pseudo-years)
#' 
#' ***maturity***: maturity at age ogive (pseudo-years)
#' 
#' ***k***: age varying growth coefficients
#' 
#' ***L***: length (cm) 
#' 
#' ***Linf***: length infinity (cm)
#' 
#' ***Lmin***: length minimum (cm)
#' 
#' ***a***: length-weight scaling coefficient
#' 
#' ***b***: length-weight shape parameter
#' 
#' ***LenAge_cv***: length-age coefficient of variability
#' 
#' @usage data('YFT_221cell_observations_67_100_v2')
#' @examples 
#' data('YFT_221cell_observations_67_100_v2')
#' head(sim_67$obs$simulated_cpue_ll_jpn_86$data$obs)
NULL

#' TOA SUPPLEMENTAL DATASET: Antarctic Toothfish Spatial Simulations
#'
#' Spatial simulations of TOA from SPM OM.
#'
#' @docType data
#' 
#' @name TOA_simulations_cells
#'
#' @usage data(TOA_simulations_cells)
#'
#' @format A list object.
#'
#' @keywords dataset
#'
#' @examples
#' data(TOA_simulations_cells)
#' head(sim)
NULL

#' TOA MAIN DATASET: Antarctic Toothfish 1 Region Simulations
#'
#' 1 region simulations of TOA from SPM OM.
#'
#' @docType data
#' 
#' @name TOA_simulations_inputs_1region
#'
#' @usage data(TOA_simulations_inputs_1region)
#'
#' @format A list object.
#'
#' @keywords dataset
#'
#' @examples
#' data(TOA_simulations_inputs_1region)
#' head(realised.catches)
#' head(realised.tags)
NULL

#' TOA MAIN DATASET: Antarctic Toothfish 4 Region Simulations
#'
#' 4 region simulations of TOA from SPM OM.
#'
#' @docType data
#' 
#' @name TOA_simulations_inputs_4regions
#'
#' @usage data(TOA_simulations_inputs_4regions)
#'
#' @format A list object.
#'
#' @keywords dataset
#'
#' @examples
#' data(TOA_simulations_inputs_4regions)
#' head(realised.catches)
#' head(realised.tags)
NULL