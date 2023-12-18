////////////////////////////////////////////////////////
// Spatial Estimation Model based on Operating Model by Daniel Goethel (NMFS SEFSC)  
// started by Dana Hanselman (AFSC) //Further screwed up by Jon Deroba (NEFSC)//Terrorized by Dan Goethel (SEFSC)
// Agonized over again by Dana Hanselman between bloodlettings...
//////////////////////////////////////////////////////////

GLOBALS_SECTION
  #include "admodel.h"
  #include "statsLib.h"
  #include "qfclib.h"
  #include <contrib.h>
  #define EOUT(var) cout <<#var<<" "<<var<<endl;

TOP_OF_MAIN_SECTION
  arrmblsize=500000000;
  gradient_structure::set_MAX_NVAR_OFFSET(5000000);
  gradient_structure::set_NUM_DEPENDENT_VARIABLES(5000000);

DATA_SECTION
////////////////////////////////////////////////////////////////////////////////////
/////MODEL STRUCTURE INPUTS/////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
  init_int nages //number of ages
  init_int nyrs //number of years of catch
  init_int npops //number of populations
///////////// Indices for ragged arrays (can't be type init so need to establish as integer)
  !! int np=npops;
  !! int ny=nyrs;
  !! int na=nages;
//////////////////////////////////////////////////////
  init_ivector nregions(1,np) //number of regions within a population - for metamictic regions = areas, populations = 1
  !! ivector nreg=nregions;
  init_ivector nfleets(1,np) //number of fleets in  each population
  !! ivector nf=nfleets;
  init_ivector nfleets_survey(1,np) //number of fleets in each population
  ivector nfs(1,np)
  !! nfs=nfleets_survey;

/////////////////////////////////////////////////////
//OM MODEL STRUCTURE for reporting true values
///////////////////////////////////////////////////
  init_number npops_OM
  !! int np_om=npops_OM;
  
//////////////////////////////////////////////////////
  init_ivector nregions_OM(1,np_om) //number of regions within a population - for metamictic regions = areas, populations = 1
  !! ivector nreg_om=nregions_OM;
  init_ivector nfleets_OM(1,np_om) //number of fleets in each region by each population
  !! ivector nf_om=nfleets_OM;
  init_ivector nfleets_survey_OM(1,np_om) //number of fleets in each region by each population
  !! ivector nfs_om=nfleets_survey_OM;


////////////////////////////////////////////////////////////////////////////////////
//////////////SWITCHES//////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

  init_matrix tsurvey(1,np,1,nreg) //time of survey in proportion of year (0,1)

  init_number diagnostics_switch
  //#==0 allow OBS data to be used for estimation
  //#==1 allow TRUE data from without error to be used for estimation

  //init_number fleets_as_areas_switch
  //==0 not fleets as areas
  //==1 fleets as areas approach for EM
  
  init_number move_switch
 /////// Sets how movement will be treated (fixed vs. estimated)
 // ***MUST CHANGE PHASES OF T PARAMETERS TO DETERMINE TYPE OF MOVEMENT (constant, Time varying, age-varying, both time and age varying)
 // ***IF PANMICTIC, NO MOVE, INPUT T, THEN  MAKE SURE ALL T PAR PHASES ARE SET TO NEGATIVE NUMBER****
 // ==(-2), no movement because panmictic set T par phases==-1
 // ==(-1) use input movement EM input below (use when want fixed movement that differs from true movement), set T par phases=-1
 // ==0 no movement, set T par phases=-1
 // ==1 use true movement from OM, set T par phases=-1
 // >=2 estimate movement, **IF** one of the movement parameters is a positive phase

  init_number report_rate_switch
  //==(-1), use input_report_rate_EM, reporting rate may differ from TRUE report rate
  //==0, use TRUE reporting rate from OM
  //==1, estimate time-invariant (pop, reg varying) reporting rate, ph_rep_rate_CNST>0
  //==2, estimate a time-, pop-, reg-varying reporting rate ph_rep_rate_YR>0
  
////// Population Structure switches
  init_number natal_homing_switch
  //==0 no natal homing (SSB is sum of SSB in population regardless of natal origin; weight/mat/fecund/ are based on current population not natal population) - Metapopulation/metamictic
  //==1 do natal homing (a fish only adds to SSB if it is in its natal population at spawning time; weight/mat/fecund/ are based on natal population) - Natal homing
  //natal homing  assumes genetic based life history and contribution to SSB (i.e., natal homing and no demographic mixing), natal homing==0 assumes demographic mixing (e.g. metapopulations where life history is more location based)

  init_number spawn_return_switch
   //==0 if natal_homing_switch==1 then only fish that are in natal population add to SSB
   //==1 natal_homing_switch==1 a fraction of fish return to natal population to spawn (inpopsantaneous migration to natal population and back at time of spawning) based spawn_return_prob; weight/mat/fecund/ are based on natal population)
  //////////////////////////////////////////////////////

  init_matrix select_switch(1,np,1,nf)
  //==0 input selectivity
  //==1 logistic selectivity based on input sel_beta1 and sel_beta2
  //==2 double logistic selectivity based on input sel_beta1, sel_beta2, sel_beta3 and sel_beta4
  /////////////////////////////////////////////////////
  init_matrix select_switch_survey(1,np,1,nfs)
  //==0 input selectivity
  //==1 logistic selectivity based on input sel_beta1 and sel_beta2
  //==2 double logistic selectivity based on input sel_beta1, sel_beta2, sel_beta3 and sel_beta4
  init_matrix survey_mirror(1,np,1,nfs)
  //==0 dont mirror to fishery fleet
  //>0 specifies fishery fleet to mirror. Need to set phase of survey selectivity to negative

 //determine how to estimate R0 when there are multiple regions within a population that have different vital rates
  init_number maturity_switch_equil
  //==0 for equal by area or average
  //==1 weighted average using equil_ssb_apportion to determine proportional contribution to equil vital rates by region
  //SSB0 must be calculated to determine stock-recruit function (if only know steepness and R0 for the population)
  //Use equilibrium SPR calcs to get SSB0, but to do so requires vital rates (maturity, weight), which are typically constant across a population
  //With multiple regions within a pop each with different vitals, must make assumption regarding the proportional contribution of each region's demograhics to equil SSB
  //When ==1 just assume equal (average) contributions, when ==1 input a proportional contribution (ie assume one region has higher carrying capacity and contributes more to equil SSB)
  
  init_number SSB_type
  //==1 fecundity based SSB
  //==2 weight based SSB

  init_number catch_num_switch
  //==0 input catch is in biomass
  //==1 input catch is in number
  
  init_number Rec_type
  //==1 stock-recruit relationship assumes an average value based on R_ave
  //==2 Beverton-Holt population-recruit functions based on population-specific input steepness, R0 (R_ave), M, and weight

  init_number apportionment_type //only use if multiple regions in a population
  //==-1 no recruitment apportionment to regions within a population (each region within a population gets full amount of recruits from SR curve)
  //==0 apportionment to each region is based on relative SSB in region compared to population SSB
  //==1 input apportionment
  //==2 recruits are apportioned equally to each region within a population
  //==3 estimate pop/reg apportionment constant over years
  //==4 estimate pop/reg/year apportionment varying by year

  init_number use_stock_comp_info_survey //for likelihood calcs
  //Determines whether it is assumed that info (stock composition data) is available determine natal origin for age composition data
  //==0 calc survey age comps by area (summed across natal population)
  //==1 calc survey age comps by natal population within each area

  init_number use_stock_comp_info_catch //for likelihood calcss
  //Determines whether it is assumed that info (stock composition data) is available determine natal origin for age composition data
  //==0 calc  catch age comps by area (summed across natal population)
  //==1 calc  catch age comps by natal population within each area
   init_number F_switch
  //negative phase == use input_F_TRUE
  //==1 estimate yearly F
  //==2 random walk in F
   init_number M_switch
   //all M types are constant across regions
  //==(-1) use input_M (can differ from TRUE M)
  //==0 use input_M_TRUE
  //==1 estimate constant M (const across pop and age)
  //==2 estimate population-based M (const across ages)
  //==3 estimate age-based M (const across pop)
  //==4 estimate age- and population-varying M
  init_number recruit_devs_switch
  //==0 use stock-recruit relationphip directly (make sure to set ph_rec=0), also assumes initial abund for all ages=R0
  //==1 allow lognormal error around SR curve (i.e., include randomness based on input sigma_recruit)
  init_number recruit_randwalk_switch
  //==0 no random walk recruitment deviations
  //==1 have random walk lognormal recruitment deviations (requirs recruit_devs_switch==1)....NEEDS WORK!!!!!
  init_number init_abund_switch
  //==0 input init_abund_EM
  //==1 decay from R_ave
  init_number est_dist_init_abund
  //==(-2) use input_dist_init_abund specified for EM (can differ from true)
  //==(-1) assume all fish in a pop are equally distributed across regions in that pop (no fish start outside natal pop)
  //==0 use true distribution of init_abundance
  //==1 estimate the spatial distribution of init abundance, need to make ph_non_natal_init OR ph_reg_init non-negative depending on spatial structure used
  
  init_vector tspawn(1,np) //time of spawning in proportion of year (0-1)
  init_number return_age // used if move_swith ==6
  init_vector return_probability(1,np) // used if move_swith==6
  init_vector spawn_return_prob(1,np) // used if natal_homing_swith==2
  init_int do_tag
  init_number fit_tag_age_switch
   //determines whether tags are fit by age cohorts or by region-only cohorts
   //the latter is for situations where age is unknown and so assume no tag age dynamics and that all fish fully selected
   //in this case OM assumes normal tagging age-based dynamics, but EM ignores age structure in tags and assumes just fully selected
   //therefore creates inherent process error in tag dynamics
   //==0, fit by age-based cohorts
   //==1, fit by region-based cohorts
  init_int do_tag_mult //if==0 assume neg binomial, if==1 assume multinomial (same as OM)
  init_number est_tag_mixing_switch
   //determines whether different F or T compared to rest of population in first year of release are estimated  (i.e., estimate F and/or T to account for  incomplete mixing)
   //==0 F and T same as rest of pop (assume complete mixing)
   //==1 F is estimated different from rest of population (incomplete mixing F only) in first year of release
   //==2 T is estimated different from rest of population (incomplete mixing T only) in first year of release
   //==1 F AND T are estimated different from rest of population (incomplete mixing F AND T) in first year of release


  init_vector sigma_recruit(1,np)
  
///////////////////////////////////////////////////////////////////////////////
////////READ IN THE SPECS  //////////////////////////////////
//////////////////////////////////
/////////////////////////////////////////////
//phases and bounds for est parameters

  init_int ph_lmr
  init_number Rave_start
  init_number lb_R_ave
  init_number ub_R_ave
  init_int ph_rec
  init_number lb_rec_devs
  init_number ub_rec_devs
  init_number Rdevs_start

  init_int ph_rec_app_CNST
  init_int ph_rec_app_YR
  init_number lb_rec_app
  init_number ub_rec_app
  init_number Rapp_start

  init_int ph_init_abund
  init_number N_start
  init_number init_dist_start
  init_int ph_reg_init
  init_int ph_non_natal_init
  init_number lb_init_dist
  init_number ub_init_dist
  init_number lb_init_abund
  init_number ub_init_abund
  init_int ph_F
  init_number lb_F
  init_number ub_F
  init_number F_start
  init_int ph_steep
  init_number lb_steep
  init_number ub_steep
  init_number steep_start

  init_int ph_M_CNST
  init_int ph_M_pop_CNST
  init_int ph_M_age_CNST
  init_int ph_M_pop_age
  init_number lb_M
  init_number ub_M
  init_number M_start
  init_int ph_sel_log
  init_number lb_sel_beta1
  init_number ub_sel_beta1
  init_number sel_beta1_start
  init_number lb_sel_beta2
  init_number ub_sel_beta2
  init_number sel_beta2_start
  init_number lb_sel_beta3
  init_number ub_sel_beta3
  init_number sel_beta3_start
  init_number lb_sel_beta4
  init_number ub_sel_beta4
  init_number sel_beta4_start
  init_number lb_sel_beta1_surv
  init_number ub_sel_beta1_surv
  init_number sel_beta1_surv_start
  init_number lb_sel_beta2_surv
  init_number ub_sel_beta2_surv
  init_number sel_beta2_surv_start
  init_number lb_sel_beta3_surv
  init_number ub_sel_beta3_surv
  init_number sel_beta3_surv_start
  init_number lb_sel_beta4_surv
  init_number ub_sel_beta4_surv
  init_number sel_beta4_surv_start
  init_int ph_sel_log_surv
  init_int ph_sel_dubl
  init_int ph_sel_dubl_surv
  init_int ph_q
  init_number lb_q
  init_number ub_q
  init_number q_start
  init_int ph_F_rho // if we want random walk F, not implemented
  init_number lb_F_rho
  init_number ub_F_rho
  init_number Frho_start
  init_int phase_T_YR
  init_int phase_T_YR_ALT_FREQ
  init_int T_est_freq
  init_int phase_T_YR_AGE_ALT_FREQ
  init_int T_est_age_freq
  init_int juv_age
  init_int phase_T_CNST
  init_int phase_T_CNST_AGE
  init_int phase_T_YR_AGE
  init_int phase_T_CNST_AGE_no_AG1
  init_int phase_T_YR_AGE_no_AG1
  init_int phase_T_YR_AGE_ALT_FREQ_no_AG1
  init_number lb_T
  init_number ub_T
  init_number T_start
  init_int phase_rep_rate_YR
  init_int phase_rep_rate_CNST
  init_number lb_B
  init_number ub_B
  init_number B_start
  init_int ph_T_tag
  init_int ph_F_tag
  init_int lb_scalar_T
  init_int ub_scalar_T
  init_int lb_scalar_F
  init_int ub_scalar_F
  init_number scalar_T_start
  init_number scalar_F_start

  init_int ph_dummy
  //number ph_theta
 // !!if(do_tag_mult==0)
 // !! {
 // !!  ph_theta==2
 // !! }
 // !!if(do_tag_mult==2)
//  !! {
//  !!  ph_theta==-2
//  !! }
 // likleihood weights
   init_number wt_srv
   init_number wt_catch
   init_number wt_fish_age
   init_number wt_srv_age 
   init_number wt_rec
   init_number wt_tag
   init_number wt_F_pen
   init_number wt_M_pen
   init_number wt_B_pen
   init_number report_rate_sigma
   init_number report_rate_ave
   init_int abund_pen_switch
   init_number wt_abund_pen
   init_number mean_N
   init_int move_pen_switch
   init_number wt_T_pen
   init_number Tpen
   init_number sigma_Tpen_EM
   init_number Rave_pen_switch
   init_number wt_Rave_pen
   init_number Rave_mean
//###########READ BIO DATA###############################################################################################################################
//#########################################################################################################################################
//##########################################################################################################################################
//#########################################################################################################################################
//######### FOR NATAL HOMING THERE IS NO ACCOUNTING OF REGIONAL DIFFERENCES IN VITAL RATES ACROSS REGIONS WITHIN A POPULATION
//######### IE BECAUSE GENETICS DEFINE VITAL RATES, THEY MUST ALL BE THE SAME
//######### **********DO NOT INPUT REGIONALLY VARYING VITAL RATES, NATAL REGION WILL NOT BE PROPERLY TRACKED IN SSB CALCS #############
//#########################################################################################################################################
  ////////////////BIOLOGICAL PARAMETERS////////////////
  /////////////////////////////////////////////////////
  init_3darray input_weight(1,np,1,nreg,1,na)  
  init_3darray input_catch_weight(1,np,1,nreg,1,na)
  init_3darray fecundity(1,np,1,nreg,1,na)
  init_3darray maturity(1,np,1,nreg,1,na)
  init_matrix prop_fem(1,np,1,nreg) //proportion of population assumed to be female for SSB calcs (typically use 0.5)
  //##########################################################################################################################################
//#########################################################################################################################################
//##########################################################################################################################################
//#########################################################################################################################################

///////////////////////////////////////////////////////////////////////////////////////READ IN THE OBS DATA  //////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

//Recruit indices, I made one up, but didn't fit, would be the same as survey -lnL
  init_3darray OBS_rec_index_BM(1,np,1,nreg,1,ny)
//Survey data and age comps
  init_4darray OBS_survey_fleet_bio(1,np,1,nreg,1,ny,1,nfs)  
  init_4darray OBS_survey_fleet_bio_se(1,np,1,nreg,1,ny,1,nfs) //survey standard erros
  init_5darray OBS_survey_prop(1,np,1,nreg,1,ny,1,nfs,1,na)  
  init_4darray OBS_survey_prop_N(1,np,1,nreg,1,ny,1,nfs)   //sample size

//Catch and age compos
 init_4darray OBS_yield_fleet(1,np,1,nreg,1,ny,1,nf)
 init_4darray OBS_yield_fleet_se(1,np,1,nreg,1,ny,1,nf)  // standard error on catch
 init_5darray OBS_catch_at_age_fleet_prop(1,np,1,nreg,1,ny,1,nf,1,na) 
 init_4darray OBS_catch_at_age_fleet_prop_N(1,np,1,nreg,1,ny,1,nf) //sample size

//Catch Prop
//tagging data parameters
  init_int nyrs_release //number of years with tag release events  
  !! int ny_rel=nyrs_release;
  init_vector yrs_releases(1,ny_rel) //vector containing the model years with releases 
  init_int max_life_tags //number of years that tag recaptures will be tallied for after release (assume proportional to longevity of the species)...use this to avoid calculating tag recaptures for all remaining model years after release since # recaptures are often extremely limited after a few years after release
    !! int tag_age=max_life_tags;
  init_3darray age_full_selection(1,np,1,nreg,1,ny)
  init_matrix input_report_rate(1,np,1,nreg) //input reporting rate, can differ from true
  init_4darray ntags(1,np,1,nreg,1,ny_rel,1,na) //releases
  init_vector ntags_total(1,ny_rel)  
  init_4darray OBS_tag_prop_N(1,np,1,nreg,1,ny_rel,1,na) //eff_N for tag mult tag_prop
    !! int recap_index=np*nreg(1)*ny_rel; // using this to dimension down arrays
   init_5darray input_T(1,np,1,nreg,1,na,1,np,1,nreg)
  
  !! int nyr_rel=nyrs_release;
  !! ivector xy(1,nyr_rel);
  !! ivector nt(1,nyr_rel);
  !! ivector nt_om(1,nyr_rel);

  !!  for(int x=1; x<=nyrs_release; x++)
  !!   {
  !!    xx=yrs_releases(x);
  !!    xy(x)=min(max_life_tags,nyrs-xx+1);
  !!    nt(x)=xy(x)*sum(nregions)+1;
  !!    nt_om(x)=xy(x)*sum(nregions_OM)+1;
  !!   }
   init_5darray OBS_tag_prop_final(1,np,1,nreg,1,nyr_rel,1,na,1,nt)
   init_4darray OBS_tag_prop_final_no_age(1,np,1,nreg,1,nyr_rel,1,nt)

   init_matrix input_M(1,np,1,na); // input M, can differ from True M
   init_3darray input_rec_prop(1,np,1,nreg,1,nyrs);
   init_4darray input_selectivity(1,np,1,nreg,1,na,1,nf)
   init_4darray input_survey_selectivity(1,np,1,nreg,1,na,1,nfs)
   init_3darray input_dist_init_abund(1,np,1,np,1,nreg)
   init_4darray init_abund_EM(1,np,1,np,1,nreg,1,na)

   matrix input_residency_larval(1,np,1,nreg)  //larval residency probability
   3darray input_residency(1,np,1,nreg,1,na) //
   vector frac_total_abund_tagged(1,ny_rel) //proportion of total abundance that is tagged in each
   
//##########################################################################################################################################
//#########################################################################################################################################
//##########################################################################################################################################
 // TRUE VALUES IN OM DIMENSIONS
  //##########################################################################################################################################
//#########################################################################################################################################
//##########################################################################################################################################
  init_3darray frac_natal_true(1,np_om,1,np_om,1,nreg_om)
  init_matrix input_M_TRUE(1,np_om,1,na); 
  init_4darray init_abund_TRUE(1,np_om,1,np_om,1,nreg_om,1,na)  //input true initial abundance; just used for reporting
  init_3darray q_survey_TRUE(1,np_om,1,nreg_om,1,nfs_om) // catchability for different surveys(fleets)operating in different areas
  init_3darray sel_beta1_TRUE(1,np_om,1,nreg_om,1,nf_om)   //selectivity slope parameter 1 for logistic selectivity/double logistic
  init_3darray sel_beta2_TRUE(1,np_om,1,nreg_om,1,nf_om)   //selectivity inflection parameter 1 for logistic selectivity/double logistic
  init_3darray sel_beta3_TRUE(1,np_om,1,nreg_om,1,nf_om)  //selectivity slope parameter 2 for double selectivity
  init_3darray sel_beta4_TRUE(1,np_om,1,nreg_om,1,nf_om)  //selectivity inflection parameter 2 for double logistic selectivity
  init_3darray sel_beta1_survey_TRUE(1,np_om,1,nreg_om,1,nfs_om)   //selectivity slope parameter 1 for logistic selectivity/double logistic
  init_3darray sel_beta2_survey_TRUE(1,np_om,1,nreg_om,1,nfs_om)   //selectivity inflection parameter 1 for logistic selectivity/double logistic
  init_3darray sel_beta3_survey_TRUE(1,np_om,1,nreg_om,1,nfs_om)  //selectivity slope parameter 2 for double selectivity
  init_3darray sel_beta4_survey_TRUE(1,np_om,1,nreg_om,1,nfs_om)  //selectivity inflection parameter 2 for double logistic selectivity
  init_vector steep_TRUE(1,np_om) //B-H steepness
  init_vector R_ave_TRUE(1,np_om) //Average Recruitment or R0 for B-H S-R curve
  init_vector SSB_zero_TRUE(1,np_om)
  init_matrix rec_devs_TRUE(1,np_om,1,ny)
  init_3darray Rec_Prop_TRUE(1,np_om,1,nreg_om,1,ny-1)
  init_3darray recruits_BM_TRUE(1,np_om,1,nreg_om,1,ny)
  init_4darray F_TRUE(1,np_om,1,nreg_om,1,ny,1,na)
  init_4darray F_year_TRUE(1,np_om,1,nreg_om,1,ny,1,nf_om)
  init_3darray biomass_AM_TRUE(1,np_om,1,nreg_om,1,ny)
  init_matrix biomass_population_TRUE(1,np_om,1,ny)

//these are fixed to EM dimensions when doing a diagnostics run
  init_5darray catch_at_age_fleet_prop_TRUE(1,np_om,1,nreg_om,1,ny,1,nf_om,1,na)
  init_4darray yield_fleet_TRUE(1,np_om,1,nreg_om,1,ny,1,nf_om)
  init_5darray survey_fleet_prop_TRUE(1,np_om,1,nreg_om,1,ny,1,nfs_om,1,na)
  init_4darray survey_fleet_bio_TRUE(1,np_om,1,nreg_om,1,ny,1,nfs_om)

//OM dimensions
  init_3darray harvest_rate_region_bio_TRUE(1,np_om,1,nreg_om,1,ny)
  init_3darray depletion_region_TRUE(1,np_om,1,nreg_om,1,ny)
  init_3darray SSB_region_TRUE(1,np_om,1,nreg_om,1,ny)
  init_matrix Bratio_population_TRUE(1,np_om,1,ny)
  init_5darray T_year_TRUE(1,np_om,1,nreg_om,1,ny,1,np_om,1,nreg_om)

  init_4darray selectivity_age_TRUE(1,np_om,1,nreg_om,1,na,1,nf_om)
  init_4darray survey_selectivity_age_TRUE(1,np_om,1,nreg_om,1,na,1,nfs_om)

//need to fix to EM dim when doing diagnostics run
  init_5darray tag_prop_final_TRUE(1,np_om,1,nreg_om,1,nyr_rel,1,na,1,nt_om)//
  init_4darray tag_prop_final_TRUE_no_age(1,np_om,1,nreg_om,1,nyr_rel,1,nt_om)//

  !! int xn=na*ny;
  init_5darray T_TRUE(1,np_om,1,nreg_om,1,xn,1,np_om,1,nreg_om) //can't start array with vector (hence collapsing internal dimensions (age,year) instead of initial (pop,reg)
  init_3darray report_rate_TRUE(1,np,1,ny_rel,1,nreg) //tag reporting rate (assume constant for all recaptures within a given release cohort, but can be variable across populations or regions)...could switch to allow variation across fleets instead
  init_number move_switch_OM
  ///// Sets the type of adult movement pattern (sets age class>1 movements)
  //==0 no movement
  //==1 input movement
  //==2 movement within population only based on input residency (symmetric off diagnol)
  //==3 symmetric movement but only allow movement within a population (ie regions within a population) not across populations
  //==4 symmetric movement across all populations and regions
  //==5 allow movement across all regions and populations, based on population/region specific residency (symmetric off diagnol)
  //==6 natal return, based on age of return and return probability (certain fraction of fish make return migration to natal population eg ontogenetic migration)
  //==7 larvae stay in the population that they move to (i.e., for overlap, do not return to natal population if adult movement==0...otherwise with natal
  //    homing would return to natal population because natal residency is 100% and use natal movement rates (not current population movement rates like with metapopulation/random movement))
  //==8 density dependent movement based on relative biomass among potential destination area/regions, partitions (1-input_residency) based on a logistic function of biomass in current area/region and 'suitability' of destination area/regions
  //// uses use_input_Bstar switch
  //// DD MOVEMENT CAN BE AGE BASED OR CONSTANT ACROSS AGES...FOR AGE BASED MAKE SURE DD_move_age_switch==1, FOR AGE-INVARIANT DD_move_age_switch==0
  //==21 use input T_year to allow T to vary by year
  
  init_number DD_move_age_switch_OM
  /////// Allow age-based movement when using DD movement (Y/N) (1/0)
  //#==0 no age-based DD movement (assumes movement based on total relative biomass after movement, before mortality, in previous year)   ///can't use current year because biomass matrix not filled out at time of DD calcs, bec need T for calc of abund_AM which occurs before moving to next age loop
  //#==1 DD movement is age-based (assumes movement based on age-specfic relative biomass at beginning of current year)

  init_4darray abund_frac_age_region(1,np_om,1,nreg_om,1,ny,1,na)
  init_3darray abund_frac_region_year(1,np_om,1,nreg_om,1,ny)
  init_matrix abund_frac_region(1,np_om,1,nreg_om)

  init_vector sim_F_tag_scalar(1,ny_rel)
  init_vector sim_T_tag_res(1,ny_rel)
  init_number sim_tag_mixing_switch
//##########################################################################################################################################
//#########################################################################################################################################
//##########################################################################################################################################

// end of file marker
   init_int debug;
  
//##########################################################################################################################################
//#########################################################################################################################################
//##########################################################################################################################################
//////////////////////////////////////
// END DATA SECTION /////////////////////
///////////////////////////////////////
  //fill in a vector of years
  // Not sure what this shit does, but doesn't hurt so I left it
  vector years(1,nyrs)
  !!years.fill_seqadd(double(1),1.0);
  
    imatrix nregions_temp(1,np,1,np) //create temp matrix that holds the number of regions that exist in all previous populations (so can sum for use in calcs below)
    //used to fill tag_recap matrices along with dealing with collapsed indices (i.e., dimensions) for larger arrays
  vector nr_temp(1,np)
  !! for(int j=1;j<=np;j++) 
  !! {
  !!  for (int r=1;r<=np;r++) 
  !!  {
  !!    if(j<=r)
  !!     {
  !!     nregions_temp(j,r)=0; ///first row is 0s
  !!     nr_temp(j)=nreg(j)-1;
  !!     }
  !!    if(j>r)
  !!     {
  !!     nregions_temp(j,r)=nreg(r);  //subsequent rows are filled with number of regions in previous population
  !!     nr_temp(j)=nreg(j)-1;
  !!     }
  !!   }
  !!  }
  ivector nreg_temp(1,np)
  int sum_nr_temp
  !! sum_nr_temp=sum(nr_temp);
  !! nreg_temp=rowsum(nregions_temp);

  int a
  int y
  int z
  int k
  int j
  int i
  int s
  int r
  int n
  int w
  int p
  int v
  int x
  int u
  int d
  int xx
  int tag_age_sel
  int T_lgth_YR_AGE_ALT_FREQ2
  int T_lgth2
  int T_lgth_YR2
  int T_lgth_YR_ALT_FREQ2
  int T_lgth_AGE2
  int T_lgth_YR_AGE2
  int T_lgth_AGE2_no_AG1
  int T_lgth_YR_AGE2_no_AG1
  int T_lgth_YR_AGE_ALT_FREQ2_no_AG1

  int region_counter
  number rd_T
 !! cout << "debug = " << debug << endl;
 !! cout << "If debug != 1541 then .dat file is meh" << endl;
 !! cout << "input read" << endl;

 !! cout << "end setup of containers" << endl;

PARAMETER_SECTION
 !! cout << "begin parameter section" << endl;

  !! ivector nr=nregions;
  !! int parpops=npops;
  !! int nps=npops;
  !! int nyr=nyrs;
  !! int nag=nages;
  !! ivector nfl=nfleets;
  !! ivector nfls=nfleets_survey;  
  !! int k;

  //***********************************************************************
  //*************************************************************
  //***problem with ragged arrays for estimated parameters so use these as a stopgap when COULD have ragged arrays
  //***IF HAVE DIFF NUMBER OF REGIONS/FLEETS PER POPULATION/REGION (when mult pops), THEN SOME OF THE ESTIMATION WON'T WORK
  //***MAINLY RECRUIT APPORTIONMENT,  EST DIST OF INIT_ABUND, SELECTIVITY, F
  !! int fishfleet=nfleets(1); 
  !! int survfleet=nfleets_survey(1);
  !! int parreg=nregions(1); 
  //***********************************************************************
  //***********************************************************************
  //***********************************************************************
   !! int T_lgth=sum(nr);
   !! int T_lgth_YR=sum(nr)*nyr;
   !! int T_lgth_YR_ALT_FREQ=sum(nr)*floor(((nyrs-1)/T_est_freq)+1);
   !! int T_lgth_YR_AGE_ALT_FREQ=sum(nr)*floor(((nyrs-1)/T_est_freq)+1)*floor(((nages-1)/T_est_age_freq)+1);
   !! int T_lgth_AGE=sum(nr)*nag;
   !! int T_lgth_YR_AGE=sum(nr)*nag*nyr;
   !! int T_lgth_YR_AGE_ALT_FREQ_no_AG1=sum(nr)*floor(((nyrs-1)/T_est_freq)+1)*floor(((nages-2)/T_est_age_freq)+1);
   !! int T_lgth_AGE_no_AG1=sum(nr)*(nag-1);
   !! int T_lgth_YR_AGE_no_AG1=sum(nr)*(nag-1)*nyr;
   !! int YR_APP=nps*nyr;
   !! int F_lgth=sum(nr)*nyr;
   !! int sel_lgth=sum(nr);
   
 //tagging data indices
  !! int nyr_rel=nyrs_release;
  !! ivector xy(1,nyr_rel);
  !! ivector nt(1,nyr_rel);
  !! ivector nt2(1,nyr_rel);
  !! ivector tag_age(1,nyr_rel);

  !!  for(int x=1; x<=nyrs_release; x++)
  !!   {
  !!    xx=yrs_releases(x);
  !!    xy(x)=min(max_life_tags,nyrs-xx+1);
  !!    nt(x)=xy(x)*sum(nregions)+1;
  !!    nt2(x)=nt(x)-1;
  !!    tag_age(x)=xy(x); 
  !!   }
//ESTIMATED PARAMETERS
  init_bounded_vector steep(1,parpops,lb_steep,ub_steep,ph_steep) //B-H steepness //could be estimated parameter or input value
  init_bounded_vector ln_R_ave(1,parpops,lb_R_ave,ub_R_ave,ph_lmr) //estimated parameter Average Recruitment
  init_bounded_matrix ln_rec_devs(1,nps,1,nyr-1,lb_rec_devs,ub_rec_devs,ph_rec)

//recruit apportionment parameters
  //*****FOLLOWING WILL ONLY WORK PROPERLY IF ONLY 1 POP OR  NUMBER OF REGIONS IS CONSTANT ACROSS POPULATIONS****************
  init_bounded_matrix ln_rec_prop_CNST(1,nps,1,parreg-1,lb_rec_app,ub_rec_app,ph_rec_app_CNST)//needs testing
  init_bounded_matrix ln_rec_prop_YR(1,YR_APP,1,parreg-1,lb_rec_app,ub_rec_app,ph_rec_app_YR) //needs testing
  //*****************************************************************************

  matrix G_app(1,nps,1,nr);//check this
  vector G_app_temp(1,nps);
  
 //movement paramters
   init_bounded_vector ln_T_tag_res(1,nyr_rel,lb_scalar_T,ub_scalar_T,ph_T_tag);
   init_bounded_vector ln_F_tag_scalar(1,nyr_rel,lb_scalar_F,ub_scalar_F,ph_F_tag);

   init_bounded_matrix ln_T_YR(1,T_lgth_YR,1,T_lgth-1,lb_T,ub_T,phase_T_YR);
   init_bounded_matrix ln_T_YR_ALT_FREQ(1,T_lgth_YR_ALT_FREQ,1,T_lgth-1,lb_T,ub_T,phase_T_YR_ALT_FREQ);
   init_bounded_matrix ln_T_YR_AGE_ALT_FREQ(1,T_lgth_YR_AGE_ALT_FREQ,1,T_lgth-1,lb_T,ub_T,phase_T_YR_AGE_ALT_FREQ);
   init_bounded_matrix ln_T_CNST_AGE(1,T_lgth_AGE,1,T_lgth-1,lb_T,ub_T,phase_T_CNST_AGE);
   init_bounded_matrix ln_T_YR_AGE(1,T_lgth_YR_AGE,1,T_lgth-1,lb_T,ub_T,phase_T_YR_AGE);
   init_bounded_matrix ln_T_CNST(1,T_lgth,1,T_lgth-1,lb_T,ub_T,phase_T_CNST);
   init_bounded_matrix ln_T_YR_AGE_ALT_FREQ_no_AG1(1,T_lgth_YR_AGE_ALT_FREQ_no_AG1,1,T_lgth-1,lb_T,ub_T,phase_T_YR_AGE_ALT_FREQ_no_AG1);
   init_bounded_matrix ln_T_CNST_AGE_no_AG1(1,T_lgth_AGE_no_AG1,1,T_lgth-1,lb_T,ub_T,phase_T_CNST_AGE_no_AG1);
   init_bounded_matrix ln_T_YR_AGE_no_AG1(1,T_lgth_YR_AGE_no_AG1,1,T_lgth-1,lb_T,ub_T,phase_T_YR_AGE_no_AG1); 
   matrix G(1,T_lgth,1,T_lgth);
   vector G_temp(1,T_lgth);
   vector T_tag_res(1,nyr_rel);
   vector F_tag_scalar(1,nyr_rel);
//reporting rate
  //*****FOLLOWING WILL ONLY WORK PROPERLY IF ONLY 1 POP OR  NUMBER OF REGIONS IS CONSTANT ACROSS POPULATIONS****************
   init_bounded_matrix ln_rep_rate_YR(1,YR_APP,1,parreg,lb_B,ub_B,phase_rep_rate_YR);
   init_bounded_matrix ln_rep_rate_CNST(1,parpops,1,parreg,lb_B,ub_B,phase_rep_rate_CNST);
  //*****************************************************************************
   3darray report_rate(1,nps,1,nyr_rel,1,nr)
   
// selectivity parameters
  //*****FOLLOWING WILL ONLY WORK PROPERLY IF ONLY 1 POP OR  NUMBER OF fishing FLEETS IS CONSTANT ACROSS POPULATIONS****************
  // selectivity allowed to vary by region and fleet
   init_bounded_matrix log_sel_beta1(1,sel_lgth,1,fishfleet,lb_sel_beta1,ub_sel_beta1,ph_sel_log);   //selectivity slope parameter 1 for logistic selectivity/double logistic
   init_bounded_matrix log_sel_beta2(1,sel_lgth,1,fishfleet,lb_sel_beta2,ub_sel_beta2,ph_sel_log);   //selectivity inflection parameter 1 for logistic selectivity/double logistic
   init_bounded_matrix log_sel_beta3(1,sel_lgth,1,fishfleet,lb_sel_beta3,ub_sel_beta3,ph_sel_dubl);  //selectivity slope parameter 2 for double selectivity
   init_bounded_matrix log_sel_beta4(1,sel_lgth,1,fishfleet,lb_sel_beta4,ub_sel_beta4,ph_sel_dubl);//selectivity inflection parameter 2 for double logistic selectivity

  //*****FOLLOWING WILL ONLY WORK PROPERLY IF ONLY 1 POP OR  NUMBER OF Survey FLEETS IS CONSTANT ACROSS POPULATIONS****************
  // survey selectivity and catchability allowed to vary by population and survey (not by region)
   init_bounded_matrix log_sel_beta1surv(1,parpops,1,survfleet,lb_sel_beta1_surv,ub_sel_beta1_surv,ph_sel_log_surv);   //selectivity slope parameter 1 for logistic selectivity/double logistic
   init_bounded_matrix log_sel_beta2surv(1,parpops,1,survfleet,lb_sel_beta2_surv,ub_sel_beta2_surv,ph_sel_log_surv);  //selectivity inflection parameter 1 for logistic selectivity/double logistic
   init_bounded_matrix log_sel_beta3surv(1,parpops,1,survfleet,lb_sel_beta3_surv,ub_sel_beta3_surv,ph_sel_dubl_surv);   //selectivity slope parameter 1 for logistic selectivity/double logistic
   init_bounded_matrix log_sel_beta4surv(1,parpops,1,survfleet,lb_sel_beta4_surv,ub_sel_beta4_surv,ph_sel_dubl_surv);  //selectivity inflection parameter 1 for logistic selectivity/double logistic
  
  init_bounded_matrix ln_q(1,parpops,1,survfleet,lb_q,ub_q,ph_q) // catchability constant across a population (can't vary by region), but varies by survey
  3darray q_survey(1,parpops,1,nr,1,nfls)  //set by region, but really just using same q across regions
  //*****************************************************************************

//Mortality parameters
  //*****FOLLOWING WILL ONLY WORK PROPERLY IF ONLY 1 POP OR  NUMBER OF FLEETS IS CONSTANT ACROSS POPULATIONS****************
  init_bounded_matrix ln_F(1,F_lgth,1,fishfleet,lb_F,ub_F,ph_F) 
  init_bounded_matrix ln_F_rho(1,parpops,1,fishfleet,lb_F_rho,ub_F_rho,ph_F_rho) //random walk params*
  //*****************************************************************************
  init_bounded_number ln_M_CNST(lb_M,ub_M,ph_M_CNST) //cnst M by age and pop
  init_bounded_vector ln_M_pop_CNST(1,nps,lb_M,ub_M,ph_M_pop_CNST) //cnst M by age vary by pop 
  init_bounded_vector ln_M_age_CNST(1,nag,lb_M,ub_M,ph_M_age_CNST) //cnst M by pop vary by age 
  init_bounded_matrix ln_M_pop_age(1,nps,1,nag,lb_M,ub_M,ph_M_pop_age) //M vary by age and pop 

//init_abund parameters
  init_bounded_matrix ln_init_abund(1,nps,1,nag-1,lb_init_abund,ub_init_abund,ph_init_abund) //for initial abundance
  init_bounded_matrix ln_nat(1,nps,1,T_lgth-1,lb_init_dist,ub_init_dist,ph_non_natal_init) //est init_abund dist for natal homing
  
  //*****FOLLOWING WILL ONLY WORK PROPERLY IF ONLY 1 POP OR  NUMBER OF REGIONS IS CONSTANT ACROSS POPULATIONS****************
  init_bounded_matrix ln_reg(1,nps,1,parreg-1,lb_init_dist,ub_init_dist,ph_reg_init) //est init abund dist for metapop/metamictic
  //*****************************************************************************
  
  matrix G_nat(1,nps,1,T_lgth);
  vector G_nat_temp(1,nps);
  matrix G_reg(1,nps,1,parreg);
  vector G_reg_temp(1,nps);
  3darray frac_natal(1,nps,1,nps,1,nr)

 //###############################################################################################################################
 //###################################################################################################################################
  matrix init_abund_age(1,nps,1,nages)
  matrix rec_devs(1,nps,1,nyr-1) //derived quantity as exp(rec_devs_RN)
  vector R_ave(1,parpops) // switch to log scale
  vector SSB_zero(1,nps) //derived quantity
  vector alpha(1,nps) //derived quantity
  vector beta(1,nps) //derived quantity
  matrix SR(1,nps,1,nyr-1)
  matrix total_recruits(1,nps,1,nyr-1)
 4darray init_abund(1,nps,1,nps,1,nr,1,nag)  //estimated as devs from exponential decline from R_ave

// selectivity parameters
  3darray sel_beta1(1,nps,1,nr,1,nfl)   //selectivity slope parameter 1 for logistic selectivity/double logistic
  3darray sel_beta2(1,nps,1,nr,1,nfl)   //selectivity inflection parameter 1 for logistic selectivity/double logistic
  3darray sel_beta3(1,nps,1,nr,1,nfl)  //selectivity slope parameter 2 for double selectivity
  3darray sel_beta4(1,nps,1,nr,1,nfl)  //selectivity inflection parameter 2 for double logistic selectivity
  3darray sel_beta1surv(1,nps,1,nr,1,nfls)   //selectivity slope parameter 1 for logistic selectivity/double logistic
  3darray sel_beta2surv(1,nps,1,nr,1,nfls)  //selectivity inflection parameter 1 for logistic selectivity/double logistic
  3darray sel_beta3surv(1,nps,1,nr,1,nfls)   //selectivity slope parameter 1 for logistic selectivity/double logistic
  3darray sel_beta4surv(1,nps,1,nr,1,nfls)  //selectivity inflection parameter 1 for logistic selectivity/double logistic

  5darray survey_selectivity(1,nps,1,nr,1,nyr,1,nag,1,nfls)  //param
  5darray selectivity(1,nps,1,nr,1,nyr,1,nag,1,nfl)
  4darray survey_selectivity_age(1,nps,1,nr,1,nag,1,nfls)  //param
  4darray selectivity_age(1,nps,1,nr,1,nag,1,nfl)

  matrix survey_selectivity_temp(1,survfleet,1,nag) //For scaling to one. If dont have same number of fleets per region this formulation wont work
  matrix selectivity_temp(1,fishfleet,1,nag) //For scaling to one. If dont have same number of fleets per region this formulation wont work
  
//F parameters
  5darray F_fleet(1,nps,1,nr,1,nyr,1,nag,1,nfl) //derived quantity in which we likely have interest in precision
  4darray F_year(1,nps,1,nr,1,nyr,1,nfl) //derived quantity in which we likely have interest in precision
  4darray F(1,nps,1,nr,1,nyr,1,nag) //derived quantity in which we likely have interest in precision
  4darray M(1,nps,1,nr,1,nyr,1,nag)

  7darray tags_avail(1,nps,1,nr,1,nyr_rel,1,nag,1,tag_age,1,nps,1,nr) 
  4darray total_rec(1,nps,1,nr,1,nyr_rel,1,nag)
  3darray total_rec_no_age(1,nps,1,nr,1,nyr_rel)
  3darray not_rec_no_age(1,nps,1,nr,1,nyr_rel)
  3darray ntags_no_age(1,nps,1,nr,1,nyr_rel)
  4darray not_rec(1,nps,1,nr,1,nyr_rel,1,nag)
  7darray tag_prop(1,nps,1,nr,1,nyr_rel,1,nag,1,tag_age,1,nps,1,nr)
  4darray tag_prop_not_rec(1,nps,1,nr,1,nyr_rel,1,nag)
  4darray tag_prop_final_no_age(1,nps,1,nr,1,nyr_rel,1,nt)
  6darray tag_prop_no_age(1,nps,1,nr,1,nyr_rel,1,tag_age,1,nps,1,nr)
  3darray tag_prop_not_rec_no_age(1,nps,1,nr,1,nyr_rel)
  5darray tag_prop_final(1,nps,1,nr,1,nyr_rel,1,nag,1,nt)
  6darray T(1,nps,1,nr,1,nyr,1,nag,1,nps,1,nr)
  6darray T_true_report(1,nps,1,nr,1,nyr,1,nag,1,nps,1,nr) 
  5darray T_terminal(1,nps,1,nr,1,nag,1,nps,1,nr) 
  5darray T_year(1,nps,1,nr,1,nyr,1,nps,1,nr) 
  7darray recaps(1,nps,1,nr,1,nyr_rel,1,nag,1,tag_age,1,nps,1,nr) //recaps
  7darray tag_recap_no_age_temp(1,nps,1,nr,1,nyr_rel,1,tag_age,1,nps,1,nr,1,nag) //recaps
  4darray F_tag(1,nps,1,nr,1,nyr_rel,1,nag)
  6darray T_tag(1,nps,1,nr,1,nyr_rel,1,nag,1,nps,1,nr)
  
 // 6-d arrays
 6darray survey_fleet_overlap_age(1,nps,1,nps,1,nr,1,nyr,1,nfls,1,nag) 
 6darray survey_at_age_region_fleet_overlap_prop(1,nps,1,nps,1,nr,1,nfls,1,nyr,1,nag)
 6darray survey_fleet_overlap_age_bio(1,nps,1,nps,1,nr,1,nyr,1,nfls,1,nag)
 6darray catch_at_age_region_fleet_overlap(1,nps,1,nps,1,nr,1,nfl,1,nyr,1,nag)
 6darray catch_at_age_region_fleet_overlap_prop(1,nps,1,nps,1,nr,1,nfl,1,nyr,1,nag)
 6darray yield_region_fleet_temp_overlap(1,nps,1,nps,1,nr,1,nfl,1,nyr,1,nag)

 4darray weight_population(1,nps,1,nr,1,nyr,1,nag)
 4darray weight_catch(1,nps,1,nr,1,nyr,1,nag)
 3darray wt_mat_mult(1,nps,1,nyr,1,nag)
 4darray wt_mat_mult_reg(1,nps,1,nr,1,nyr,1,nag)
 3darray ave_mat_temp(1,nps,1,nag,1,nr) //to calc average maturity 
 matrix ave_mat(1,nps,1,nag) //to calc average maturity
 matrix SPR_N(1,nps,1,nag) 
 matrix SPR_SSB(1,nps,1,nag) 
 vector SPR(1,nps) 
 
//recruitment 
 3darray recruits_BM(1,nps,1,nr,1,nyr) //param
 3darray recruits_AM(1,nps,1,nr,1,nyr) //param
 3darray rec_index_BM(1,nps,1,nr,1,nyr)
 3darray rec_index_AM(1,nps,1,nr,1,nyr)
 3darray rec_index_prop_BM(1,nps,1,nr,1,nyr) //
 3darray rec_index_BM_temp(1,nps,1,nyr,1,nr) //
 3darray rec_index_prop_AM(1,nps,1,nr,1,nyr) //
 3darray rec_index_AM_temp(1,nps,1,nyr,1,nr) //
 matrix rec_devs_randwalk(1,nps,1,nyr-1)

 3darray Rec_Prop(1,nps,1,nr,1,nyr-1)
 vector env_rec(1,nyr)

//abundance 
 4darray abundance_at_age_BM(1,nps,1,nr,1,nyr,1,nag) //param
 4darray abundance_at_age_AM(1,nps,1,nr,1,nyr,1,nag) //param
 4darray abundance_in(1,nps,1,nr,1,nyr,1,nag) //param
 4darray abundance_res(1,nps,1,nr,1,nyr,1,nag) //param
 4darray abundance_leave(1,nps,1,nr,1,nyr,1,nag) //param
 4darray abundance_spawn(1,nps,1,nr,1,nyr,1,nag) //param

//biomass
 4darray biomass_BM_age(1,nps,1,nr,1,nyr,1,nag) //param
 4darray biomass_AM_age(1,nps,1,nr,1,nyr,1,nag) //param
 3darray biomass_BM(1,nps,1,nr,1,nyr) //param
 3darray biomass_AM(1,nps,1,nr,1,nyr) //param
 4darray bio_in(1,nps,1,nr,1,nyr,1,nag) //param
 4darray bio_res(1,nps,1,nr,1,nyr,1,nag) //param
 4darray bio_leave(1,nps,1,nr,1,nyr,1,nag) //param

 //yield & BRP calcs 
 5darray catch_at_age_fleet(1,nps,1,nr,1,nyr,1,nag,1,nfl)
 5darray catch_at_age_fleet_prop(1,nps,1,nr,1,nyr,1,nfl,1,nag) 
 4darray yield_fleet(1,nps,1,nr,1,nyr,1,nfl)
 4darray yieldN_fleet(1,nps,1,nr,1,nyr,1,nfl)
 4darray catch_at_age_region(1,nps,1,nr,1,nyr,1,nag)
 4darray catch_at_age_region_prop(1,nps,1,nr,1,nyr,1,nag)
 3darray yield_region(1,nps,1,nr,1,nyr)
 3darray catch_at_age_population(1,nps,1,nyr,1,nag)
 3darray catch_at_age_population_prop(1,nps,1,nyr,1,nag)
 matrix yield_population(1,nps,1,nyr)
 3darray SSB_region(1,nps,1,nr,1,nyr) //param
 matrix SSB_population(1,nps,1,nyr) //param
 vector SSB_total(1,nyr) //param
 3darray abundance_population(1,nps,1,nyr,1,nag) //param
 matrix abundance_total(1,nyr,1,nag) //param
 matrix biomass_population(1,nps,1,nyr) //param
 vector biomass_total(1,nyr) //param
 matrix catch_at_age_total(1,nyr,1,nag) //
 matrix catch_at_age_total_prop(1,nyr,1,nag) //
 vector yield_total(1,nyr) //
 4darray harvest_rate_region_num(1,nps,1,nr,1,nyr,1,nag) //
 3darray harvest_rate_population_num(1,nps,1,nyr,1,nag) //
 matrix harvest_rate_total_num(1,nyr,1,nag) //
 3darray harvest_rate_region_bio(1,nps,1,nr,1,nyr) //
 matrix harvest_rate_population_bio(1,nps,1,nyr) //
 vector harvest_rate_total_bio(1,nyr) //
 3darray depletion_region(1,nps,1,nr,1,nyr) //
 matrix depletion_population(1,nps,1,nyr) //
 vector depletion_total(1,nyr) //

 5darray abundance_at_age_BM_overlap_region(1,nps,1,nps,1,nyr,1,nag,1,nr)
 4darray abundance_at_age_BM_overlap_population(1,nps,1,nps,1,nyr,1,nag)
 5darray abundance_at_age_AM_overlap_region(1,nps,1,nps,1,nyr,1,nag,1,nr)
 4darray abundance_at_age_AM_overlap_population(1,nps,1,nps,1,nyr,1,nag)
 4darray abundance_AM_overlap_region_all_natal(1,nps,1,nr,1,nyr,1,nag)
 5darray abundance_spawn_overlap(1,nps,1,nps,1,nr,1,nyr,1,nag)
 4darray SSB_region_overlap(1,nps,1,nps,1,nr,1,nyr)
 3darray SSB_population_overlap(1,nps,1,nps,1,nyr)
 matrix SSB_natal_overlap(1,nps,1,nyr)

 5darray biomass_BM_overlap_temp(1,nps,1,nr,1,nyr,1,nag,1,nps)
 4darray init_abund_temp(1,nps,1,nr,1,nag,1,nps)
 5darray survey_fleet_bio_overlap_temp(1,nps,1,nr,1,nyr,1,nfls,1,nps)
 5darray catch_at_age_fleet_prop_temp(1,nps,1,nr,1,nyr,1,nfl,1,nag)
 matrix abundance_move_temp(1,nps,1,nr)
 matrix bio_move_temp(1,nps,1,nr)
 matrix abundance_move_overlap_temp(1,nps,1,nr)
 5darray abundance_AM_overlap_region_all_natal_temp(1,nps,1,nr,1,nyr,1,nag,1,nps)
 5darray biomass_AM_overlap_region_all_natal_temp(1,nps,1,nr,1,nyr,1,nag,1,nps)
 3darray SSB_natal_overlap_temp(1,nps,1,nyr,1,nps)
 4darray abundance_natal_temp_overlap(1,nps,1,nyr,1,nag,1,nps)
 4darray SSB_population_temp_overlap(1,nps,1,nps,1,nyr,1,nr)
 5darray SSB_region_temp_overlap(1,nps,1,nps,1,nr,1,nyr,1,nag)

//survey index
 5darray survey_fleet_bio_overlap(1,nps,1,nps,1,nr,1,nyr,1,nfls)
 4darray survey_region_bio_overlap(1,nps,1,nps,1,nyr,1,nr)
 3darray survey_population_bio_overlap(1,nps,1,nyr,1,nps)
 matrix survey_natal_bio_overlap(1,nyr,1,nps)
 vector survey_total_bio_overlap(1,nyr)
 5darray survey_fleet_age(1,nps,1,nr,1,nyr,1,nfls,1,nag)
 5darray survey_at_age_fleet_prop(1,nps,1,nr,1,nyr,1,nfls,1,nag)
 5darray survey_fleet_age_bio(1,nps,1,nr,1,nyr,1,nfls,1,nag)
 4darray survey_fleet_bio(1,nps,1,nr,1,nyr,1,nfls)
 3darray survey_region_bio(1,nps,1,nyr,1,nr)
 matrix survey_population_bio(1,nyr,1,nps)
 vector survey_total_bio(1,nyr) 
 //caa
 5darray catch_at_age_region_overlap(1,nps,1,nps,1,nr,1,nyr,1,nag)
 5darray catch_at_age_region_overlap_prop(1,nps,1,nps,1,nr,1,nyr,1,nag)
 5darray yield_region_fleet_overlap(1,nps,1,nps,1,nr,1,nfl,1,nyr)
 4darray yield_region_overlap(1,nps,1,nps,1,nr,1,nyr)
 4darray catch_at_age_population_overlap(1,nps,1,nps,1,nyr,1,nag)
 4darray catch_at_age_population_overlap_prop(1,nps,1,nps,1,nyr,1,nag)
 3darray yield_population_overlap(1,nps,1,nps,1,nyr)
 3darray abundance_natal_overlap(1,nps,1,nyr,1,nag)
 5darray biomass_BM_age_overlap(1,nps,1,nps,1,nr,1,nyr,1,nag)
 5darray biomass_AM_age_overlap(1,nps,1,nps,1,nr,1,nyr,1,nag)
 4darray biomass_BM_overlap_region(1,nps,1,nps,1,nr,1,nyr)
 4darray biomass_AM_overlap_region(1,nps,1,nps,1,nr,1,nyr)
 4darray biomass_AM_overlap_age_region_all_natal(1,nps,1,nr,1,nyr,1,nag)
 3darray biomass_AM_overlap_region_all_natal(1,nps,1,nr,1,nyr)
 3darray biomass_population_overlap(1,nps,1,nps,1,nyr)
 matrix biomass_natal_overlap(1,nps,1,nyr)
 3darray catch_at_age_natal_overlap(1,nps,1,nyr,1,nag)
 3darray catch_at_age_natal_overlap_prop(1,nps,1,nyr,1,nag)
 matrix yield_natal_overlap(1,nps,1,nyr)
 5darray harvest_rate_region_fleet_bio_overlap(1,nps,1,nps,1,nr,1,nfl,1,nyr)
 4darray harvest_rate_region_bio_overlap(1,nps,1,nps,1,nr,1,nyr)
 3darray harvest_rate_population_bio_overlap(1,nps,1,nps,1,nyr)
 matrix harvest_rate_natal_bio_overlap(1,nps,1,nyr)
 4darray depletion_region_overlap(1,nps,1,nps,1,nr,1,nyr)
 3darray depletion_population_overlap(1,nps,1,nps,1,nyr)
 matrix depletion_natal_overlap(1,nps,1,nyr)
 3darray Bratio_population_overlap(1,nps,1,nps,1,nyr)
 matrix Bratio_natal_overlap(1,nps,1,nyr)
 matrix Bratio_population(1,nps,1,nyr)
 vector Bratio_total(1,nyr)
 matrix SSB_overlap_natal(1,nps,1,nr)

 5darray yield_region_temp_overlap(1,nps,1,nps,1,nr,1,nyr,1,nag)
 4darray yield_population_temp_overlap(1,nps,1,nps,1,nyr,1,nag)
 3darray yield_natal_temp_overlap(1,nps,1,nyr,1,nps)
 5darray catch_at_age_population_temp_overlap(1,nps,1,nps,1,nyr,1,nag,1,nr)
 4darray catch_at_age_natal_temp_overlap(1,nps,1,nyr,1,nag,1,nps)
 5darray yield_fleet_temp(1,nps,1,nr,1,nyr,1,nfl,1,nag)
 5darray yieldN_fleet_temp(1,nps,1,nr,1,nyr,1,nfl,1,nag)
 4darray yield_region_temp(1,nps,1,nr,1,nyr,1,nag)
 3darray yield_population_temp(1,nps,1,nyr,1,nag)
 3darray catch_at_age_total_temp(1,nyr,1,nag,1,nps)
 4darray catch_at_age_population_temp(1,nps,1,nyr,1,nag,1,nr)
 matrix yield_total_temp(1,nyr,1,nps)
 4darray SSB_region_temp(1,nps,1,nr,1,nyr,1,nag)
 matrix SSB_total_temp(1,nyr,1,nps)
 3darray SSB_population_temp(1,nps,1,nyr,1,nr)
 3darray biomass_population_temp(1,nps,1,nyr,1,nr)
 matrix biomass_total_temp(1,nyr,1,nps)
 4darray biomass_population_temp_overlap(1,nps,1,nps,1,nyr,1,nr)
 3darray biomass_natal_temp_overlap(1,nps,1,nyr,1,nps)
 4darray abundance_population_temp(1,nps,1,nyr,1,nag,1,nr)
 3darray abundance_total_temp(1,nyr,1,nag,1,nps)
 3darray total_recap_temp(1,nps,1,nr,1,tag_age)
 matrix tags_avail_temp(1,nps,1,nr)
 3darray tag_prop_temp(1,nps,1,max_life_tags,1,nr)
 5darray tag_prop_temp2(1,nps,1,nr,1,nyr_rel,1,nag,1,nt2)
 4darray tag_prop_temp2_no_age(1,nps,1,nr,1,nyr_rel,1,nt2)

 // likelihood components
  number survey_age_like
  number fish_age_like
  number rec_like
  number tag_like
  number tag_like_temp
  number catch_like 
  number survey_like
  number Tpen_like
  number F_pen_like
  number F_pen_like_early
  number M_pen_like
  number M_pen_like_early
  number Bpen_like
  number Rave_pen

  number init_abund_pen
 // init_bounded_number  theta(1,100,ph_theta);   // for negbinomial -lnL

 init_number dummy(ph_dummy)


  objective_function_value f;
  
  !! cout << "parameters set" << endl;

INITIALIZATION_SECTION  //set initial values
 steep steep_start;
 ln_R_ave Rave_start;
 ln_rec_devs Rdevs_start;
 ln_rec_prop_CNST Rapp_start;
 ln_rec_prop_YR Rapp_start;

 ln_T_CNST T_start;
 ln_T_CNST_AGE T_start;
 ln_T_CNST_AGE_no_AG1 T_start;
 ln_T_YR T_start;
 ln_T_YR_ALT_FREQ T_start;
 ln_T_YR_AGE T_start;
 ln_T_YR_AGE_no_AG1 T_start;  
 ln_T_YR_AGE_ALT_FREQ T_start;
 ln_T_YR_AGE_ALT_FREQ_no_AG1 T_start;

 ln_F F_start;
 ln_F_rho Frho_start;
 log_sel_beta1 sel_beta1_start;
 log_sel_beta2 sel_beta2_start;
 log_sel_beta3 sel_beta3_start;
 log_sel_beta4 sel_beta4_start; 

 ln_q q_start;
 log_sel_beta1surv sel_beta1_surv_start;
 log_sel_beta2surv sel_beta2_surv_start;
 log_sel_beta3surv sel_beta3_surv_start;
 log_sel_beta4surv sel_beta4_surv_start;

 ln_M_CNST M_start;
 ln_M_pop_CNST M_start;
 ln_M_age_CNST M_start;
 ln_M_pop_age M_start;

 ln_init_abund N_start;
 ln_nat init_dist_start;
 ln_reg init_dist_start;

 ln_rep_rate_CNST B_start;
 ln_rep_rate_YR B_start;
 ln_T_tag_res scalar_T_start;
 ln_F_tag_scalar scalar_F_start;


PROCEDURE_SECTION
 
   get_movement(); 
   get_selectivity();
   get_F_age();
   get_M_age();
   get_report_rate();
   get_vitals();
   get_SPR();
   get_abundance();
   get_survey_CAA_prop();
   get_CAA_prop();
   get_tag_recaptures();
   evaluate_the_objective_function();



///////BUILD MOVEMENT MATRIX////////
FUNCTION get_movement
 if((npops==1 && sum(nregions)==1) || move_switch==(-2)) //if panmictic then movement is 100%
  {

  for (int j=1;j<=npops;j++)
   {
    for (int r=1;r<=nregions(j);r++)
     {
     for(int y=1;y<=nyrs;y++)
       {
        for (int a=1;a<=nages;a++)
         {
          for (int k=1;k<=npops;k++)
           {
            for (int n=1;n<=nregions(k);n++)
             {
              T(j,r,y,a,k,n)=1;            
        }
       } 
      }
     }
    }
   }
  }
 if(move_switch==(-1)) //fix at input T 
  {
  for (int j=1;j<=npops;j++)
   {
    for (int r=1;r<=nregions(j);r++)
     {
     for(int y=1;y<=nyrs;y++)
       {
        for (int a=1;a<=nages;a++)
         {
          for (int k=1;k<=npops;k++)
           {
            for (int n=1;n<=nregions(k);n++)
             {
              T(j,r,y,a,k,n)=input_T(j,r,a,k,n);
        }
       } 
      }
     }
    }
   }
  }
 if(move_switch==0) // no movement
  {
     for (int j=1;j<=npops;j++)
   {
    for (int r=1;r<=nregions(j);r++)
     {
     for(int y=1;y<=nyrs;y++)
       {
        for (int a=1;a<=nages;a++)
         {
          for (int k=1;k<=npops;k++)
           {
            for (int n=1;n<=nregions(k);n++)
             {
              if(j==k && r==n)
              {
               T(j,r,y,a,k,n)=1.0;
              }
              if(j!=k || r!=n)
              {
               T(j,r,y,a,k,n)=0.0;
              }
            }
           } 
          }
         }
        }
       }
      }
 
 if(move_switch==1) //fix at true T from OM
  {
  for (int j=1;j<=npops;j++)
   {
    for (int r=1;r<=nregions(j);r++)
     {
     for(int y=1;y<=nyrs;y++)
       {
        for (int a=1;a<=nages;a++)
         {
          for (int k=1;k<=npops;k++)
           {
            for (int n=1;n<=nregions(k);n++)
             {
              T(j,r,y,a,k,n)=T_TRUE(j,r,a+(y-1)*nages,k,n);
        }
       } 
      }
     }
    }
   }
  }



  if(move_switch>=2) //when movement is nonzero and movement parameters estimated
   {
   if(phase_T_CNST>0) //uses logit transform to ensure movement sums to 1 for a given region 
    {
    G=0;
     G_temp=0;
      for (int j=1;j<=sum(nregions);j++) //from region
       {
        for (int i=1;i<=sum(nregions);i++) //to region
         {
            if(j==i)
            {
            G(j,i)=1;  //residency is 1-sum(movement)
            }
            if(i>j)
            {
            G(j,i)=mfexp(ln_T_CNST(j,i-1)); //estimated T matrix has one less column than sum(regions) so need i-1 to adjust indices to account for not estimating par where j==1
            }
            if(j!=i && i<j)
            {
            G(j,i)=mfexp(ln_T_CNST(j,i));
            }
           }
          }    
      G_temp=rowsum(G);

 for(int y=1;y<=nyrs;y++)
  {
  for (int j=1;j<=npops;j++)
   {
    for (int r=1;r<=nregions(j);r++)
     {
        for (int a=1;a<=nages;a++)
         {
          for (int k=1;k<=npops;k++)
           {
            for (int n=1;n<=nregions(k);n++)
             {
              T(j,r,y,a,k,n)=G(r+nreg_temp(j),n+nreg_temp(k))/G_temp(r+nreg_temp(j)); //nreg_temp gives sum of all regions in all previous populations, ie first entry is 0 (for pop 1), 2nd entry is sum of regions in population 1, etc...
                 // because G has entry for all regions, need to add nreg_temp to index to ensure in correct part of G matrix as region counters reset
                 // G(from region, to region), region indices to not go to all regions so need addition term to ensure moving through whole matrix
             }
            } 
           }
          }
         }
        }
       }
      

    if(phase_T_YR>0)  //est T by year
    {
      for(int y=1;y<=nyrs;y++)
       {
      G=0;
      G_temp=0;
      for (int j=1;j<=sum(nregions);j++)
       {
        for (int i=1;i<=sum(nregions);i++) 
         {
            if(j==i)
            {
            G(j,i)=1;
            }
            if(i>j)
            {
            G(j,i)=mfexp(ln_T_YR(j+sum(nregions)*(y-1),i-1)); //bec indices are collapsed for estimated T matrix, need to bump up past nregions for each successive year hence additional sum(nregions)*(y-1) term
            }
            if(j!=i && i<j)
            {
            G(j,i)=mfexp(ln_T_YR(j+sum(nregions)*(y-1),i));
            }
        }
       }    
        G_temp=rowsum(G);     
   for (int j=1;j<=npops;j++)
    {
     for (int r=1;r<=nregions(j);r++)
      {
       for (int a=1;a<=nages;a++)
        {
         for (int k=1;k<=npops;k++)
          {
           for (int n=1;n<=nregions(k);n++)
            {
             T(j,r,y,a,k,n)=G(r+nreg_temp(j),n+nreg_temp(k))/G_temp(r+nreg_temp(j));
            
            }
           } 
          }
         }
        }
       }
      }

    if(phase_T_YR_ALT_FREQ>0) //estimate a T parameter for every T_est_Freq years
    {
      for(int y=1;y<=floor(((nyrs-1)/T_est_freq)+1);y++)
       {
      G=0;
      G_temp=0;
      for (int j=1;j<=sum(nregions);j++)
       {
        for (int i=1;i<=sum(nregions);i++) 
         {
            if(j==i)
            {
            G(j,i)=1;
            }
            if(i>j)
            {
            G(j,i)=mfexp(ln_T_YR_ALT_FREQ(j+sum(nregions)*(y-1),i-1)); //bec indices are collapsed for estimated T matrix, need to bump up past nregions for each successive year hence additional sum(nregions)*(y-1) term
            }
            if(j!=i && i<j)
            {
            G(j,i)=mfexp(ln_T_YR_ALT_FREQ(j+sum(nregions)*(y-1),i));
            }
        }
       }    
        G_temp=rowsum(G);     
   for (int j=1;j<=npops;j++)
    {
     for (int r=1;r<=nregions(j);r++)
      {
       for (int a=1;a<=nages;a++)
        {
         for (int k=1;k<=npops;k++)
          {
           for (int n=1;n<=nregions(k);n++)
            {
             for (int x=1;x<=T_est_freq;x++)
              {            
               T(j,r,min(x+(y-1)*T_est_freq,nyrs),a,k,n)=G(r+nreg_temp(j),n+nreg_temp(k))/G_temp(r+nreg_temp(j));           
            }
           } 
          }
         }
        }
       }
      }
     }
    if(phase_T_YR_AGE_ALT_FREQ>0) //EST T by for every T_est_freq years and T_est_age_freq ages, with all ages <age_juv getting the first age movement parameter
    {
      for(int y=1;y<=floor(((nyrs-1)/T_est_freq)+1);y++)
       {
      for(int a=1;a<=floor(((nages-1)/T_est_age_freq)+1);a++)
       {
      G=0;
      G_temp=0;

      for (int j=1;j<=sum(nregions);j++)
       {
        for (int i=1;i<=sum(nregions);i++) 
         {
            if(j==i)
            {
            G(j,i)=1;
            }
            if(i>j)
            {
            G(j,i)=mfexp(ln_T_YR_AGE_ALT_FREQ(j+sum(nregions)*(a-1)+sum(nregions)*floor(((nages-1)/T_est_age_freq)+1)*(y-1),i-1));
            }
            if(j!=i && i<j)
            {
            G(j,i)=mfexp(ln_T_YR_AGE_ALT_FREQ(j+sum(nregions)*(a-1)+sum(nregions)*floor(((nages-1)/T_est_age_freq)+1)*(y-1),i));
            }
        }
       }    
        G_temp=rowsum(G);

   for (int j=1;j<=npops;j++)
    {
     for (int r=1;r<=nregions(j);r++)
      {
         for (int k=1;k<=npops;k++)
          {
           for (int n=1;n<=nregions(k);n++)
            {
             for(int x=1;x<=T_est_freq;x++)
             {
              for(int z=1;z<=T_est_age_freq;z++)
               {
                 T(j,r,min(x+(y-1)*T_est_freq,nyrs),min(z+(a-1)*T_est_age_freq,nages),k,n)=G(r+nreg_temp(j),n+nreg_temp(k))/G_temp(r+nreg_temp(j));
               }
              }
             }
            }
           }
          }
         }
        }

  for (int j=1;j<=npops;j++) //adjust T matrix so that all juvenile ages have the same T
   {
    for (int r=1;r<=nregions(j);r++)
     {
     for(int y=1;y<=nyrs;y++)
       {
        for (int a=1;a<=nages;a++)
         {
          for (int k=1;k<=npops;k++)
           {
            for (int n=1;n<=nregions(k);n++)
             {
                if(a<=juv_age && a!=1)
                 {
                  T(j,r,y,a,k,n)=T(j,r,y,1,k,n); //fill all juvenile ages with movement for age-1
                 }
                if(a>juv_age && a<=T_est_age_freq)
                 {
                  T(j,r,y,a,k,n)=T(j,r,y,T_est_age_freq+1,k,n); //fill all ages>juv_age but <freq of est ages (i.e., would otherwise get same T as juv age) with the movement of the next age class
                 }
        }
       } 
      }
     }
    }
   }
   }

    if(phase_T_YR_AGE_ALT_FREQ_no_AG1>0) //EST T by for every T_est_freq years and T_est_age_freq ages, with all ages <age_juv getting the first age movement parameter
    {
      for(int y=1;y<=floor(((nyrs-1)/T_est_freq)+1);y++)
       {
      for(int a=1;a<=floor(((nages-2)/T_est_age_freq)+1);a++)
       {
      G=0;
      G_temp=0;
      for (int j=1;j<=sum(nregions);j++)
       {
        for (int i=1;i<=sum(nregions);i++) 
         {
            if(j==i)
            {
            G(j,i)=1;
            }
            if(i>j)
            {
            G(j,i)=mfexp(ln_T_YR_AGE_ALT_FREQ_no_AG1(j+sum(nregions)*(a-1)+sum(nregions)*floor(((nages-2)/T_est_age_freq)+1)*(y-1),i-1));
            }
            if(j!=i && i<j)
            {
            G(j,i)=mfexp(ln_T_YR_AGE_ALT_FREQ_no_AG1(j+sum(nregions)*(a-1)+sum(nregions)*floor(((nages-2)/T_est_age_freq)+1)*(y-1),i));
            }
        }
       }    
        G_temp=rowsum(G);
     
   for (int j=1;j<=npops;j++)
    {
     for (int r=1;r<=nregions(j);r++)
      {
         for (int k=1;k<=npops;k++)
          {
           for (int n=1;n<=nregions(k);n++)
            {
             for(int x=1;x<=T_est_freq;x++)
             {
              for(int z=1;z<=T_est_age_freq;z++)
               {
                 T(j,r,min(x+(y-1)*T_est_freq,nyrs),min(z+1+(a-1)*T_est_age_freq,nages),k,n)=G(r+nreg_temp(j),n+nreg_temp(k))/G_temp(r+nreg_temp(j));
               }
              }
             }
            }
           }
          }
         }
        }
  for (int j=1;j<=npops;j++) //adjust T matrix so that all juvenile ages have the same T
   {
    for (int r=1;r<=nregions(j);r++)
     {
     for(int y=1;y<=nyrs;y++)
       {
        for (int a=1;a<=nages;a++)
         {
          for (int k=1;k<=npops;k++)
           {
            for (int n=1;n<=nregions(k);n++)
             {
                if(a<=juv_age && a!=1)
                 {
                  T(j,r,y,a,k,n)=T(j,r,y,2,k,n); //fill all juvenile ages with movement for age-2
                 }
                if(a>juv_age && a<=T_est_age_freq)
                 {
                  T(j,r,y,a,k,n)=T(j,r,y,T_est_age_freq+1,k,n); //fill all ages>juv_age but <freq of est ages (i.e., would otherwise get same T as juv age) with the movement of the next age class
                 }
                if(a==1)
                 {
                  if(j==k && r==n)
                   {
                    T(j,r,y,a,k,n)=1.0;
                   }
                   if(j!=k || r!=n)
                   {
                    T(j,r,y,a,k,n)=0.0;
                   }
                 }
        }
       } 
      }
     }
    }
   }
   }

    if(phase_T_YR_AGE>0) //EST T by year and age
    {
      for(int y=1;y<=nyrs;y++)
       {
      for(int a=1;a<=nages;a++)
       {
      G=0;
      G_temp=0;
      for (int j=1;j<=sum(nregions);j++)
       {
        for (int i=1;i<=sum(nregions);i++) 
         {
            if(j==i)
            {
            G(j,i)=1;
            }
            if(i>j)
            {
            G(j,i)=mfexp(ln_T_YR_AGE(j+sum(nregions)*(a-1)+sum(nregions)*nages*(y-1),i-1));
            }
            if(j!=i && i<j)
            {
            G(j,i)=mfexp(ln_T_YR_AGE(j+sum(nregions)*(a-1)+sum(nregions)*nages*(y-1),i));
            }
        }
       }    
        G_temp=rowsum(G);     
   for (int j=1;j<=npops;j++)
    {
     for (int r=1;r<=nregions(j);r++)
      {
         for (int k=1;k<=npops;k++)
          {
           for (int n=1;n<=nregions(k);n++)
            {
             T(j,r,y,a,k,n)=G(r+nreg_temp(j),n+nreg_temp(k))/G_temp(r+nreg_temp(j));
            
            }
           } 
          }
         }
        }
       }
      }
     


    if(phase_T_CNST_AGE>0) //est T by age ONLY
    {
      for(int a=1;a<=nages;a++)
       {
      G=0;
      G_temp=0;
      for (int j=1;j<=sum(nregions);j++)
       {
        for (int i=1;i<=sum(nregions);i++) 
         {
            if(j==i)
            {
            G(j,i)=1;
            }
            if(i>j)
            {
            G(j,i)=mfexp(ln_T_CNST_AGE(j+sum(nregions)*(a-1),i-1));
            }
            if(j!=i && i<j)
            {
            G(j,i)=mfexp(ln_T_CNST_AGE(j+sum(nregions)*(a-1),i));
            }
        }
       }    
        G_temp=rowsum(G);     
   for (int j=1;j<=npops;j++)
    {
     for (int r=1;r<=nregions(j);r++)
      {
       for(int y=1;y<=nyrs;y++)
        {
         for (int k=1;k<=npops;k++)
          {
           for (int n=1;n<=nregions(k);n++)
            {
             T(j,r,y,a,k,n)=G(r+nreg_temp(j),n+nreg_temp(k))/G_temp(r+nreg_temp(j));
            
            }
           } 
          }
         }
        }
       }
      }


    if(phase_T_YR_AGE_no_AG1>0) //EST T by year and age
    {
      for(int y=1;y<=nyrs;y++)
       {
      for(int a=1;a<=nages-1;a++)
       {
      G=0;
      G_temp=0;
      for (int j=1;j<=sum(nregions);j++)
       {
        for (int i=1;i<=sum(nregions);i++) 
         {
            if(j==i)
            {
            G(j,i)=1;
            }
            if(i>j)
            {
            G(j,i)=mfexp(ln_T_YR_AGE(j+sum(nregions)*(a-1)+sum(nregions)*(nages-1)*(y-1),i-1));
            }
            if(j!=i && i<j)
            {
            G(j,i)=mfexp(ln_T_YR_AGE(j+sum(nregions)*(a-1)+sum(nregions)*(nages-1)*(y-1),i));
            }
        }
       }    
        G_temp=rowsum(G);     
   for (int j=1;j<=npops;j++)
    {
     for (int r=1;r<=nregions(j);r++)
      {
         for (int k=1;k<=npops;k++)
          {
           for (int n=1;n<=nregions(k);n++)
            {
             T(j,r,y,a+1,k,n)=G(r+nreg_temp(j),n+nreg_temp(k))/G_temp(r+nreg_temp(j));
             
                if(a==1)
                 {
                  if(j==k && r==n)
                   {
                    T(j,r,y,a,k,n)=1.0;
                   }
                   if(j!=k || r!=n)
                   {
                    T(j,r,y,a,k,n)=0.0;
                   }
                 }            
            }
           } 
          }
         }
        }
       }
      }
     

    if(phase_T_CNST_AGE_no_AG1>0) //est T by age ONLY
    {
      for(int a=1;a<=nages-1;a++)
       {
      G=0;
      G_temp=0;
      for (int j=1;j<=sum(nregions);j++)
       {
        for (int i=1;i<=sum(nregions);i++) 
         {
            if(j==i)
            {
            G(j,i)=1;
            }
            if(i>j)
            {
            G(j,i)=mfexp(ln_T_CNST_AGE(j+sum(nregions)*(a-1),i-1));
            }
            if(j!=i && i<j)
            {
            G(j,i)=mfexp(ln_T_CNST_AGE(j+sum(nregions)*(a-1),i));
            }
        }
       }    
        G_temp=rowsum(G);     
   for (int j=1;j<=npops;j++)
    {
     for (int r=1;r<=nregions(j);r++)
      {
       for(int y=1;y<=nyrs;y++)
        {
         for (int k=1;k<=npops;k++)
          {
           for (int n=1;n<=nregions(k);n++)
            {
             T(j,r,y,a+1,k,n)=G(r+nreg_temp(j),n+nreg_temp(k))/G_temp(r+nreg_temp(j));

                if(a==1)
                 {
                  if(j==k && r==n)
                   {
                    T(j,r,y,a,k,n)=1.0;
                   }
                   if(j!=k || r!=n)
                   {
                    T(j,r,y,a,k,n)=0.0;
                   }
                 }           
            }
           } 
          }
         }
        }
       }
      }
    }
    

  for (int j=1;j<=npops;j++) //output true T for report file
   {
    for (int r=1;r<=nregions(j);r++)
     {
     for(int y=1;y<=nyrs;y++)
       {
        for (int a=1;a<=nages;a++)
         {
          for (int k=1;k<=npops;k++)
           {
            for (int n=1;n<=nregions(k);n++)
             {
              T_true_report(j,r,y,a,k,n)=T_TRUE(j,r,a+(y-1)*nages,k,n);
        }
       } 
      }
     }
    }
   }
   
  for (int j=1;j<=npops;j++)  //output terminal T for report file
   {
    for (int r=1;r<=nregions(j);r++)
     {
        for (int a=1;a<=nages;a++)
         {
          for (int k=1;k<=npops;k++)
           {
            for (int n=1;n<=nregions(k);n++)
             {
              T_terminal(j,r,a,k,n)= T(j,r,nyrs,a,k,n);            
             } 
            }
           }
          }
         }
         
  for (int j=1;j<=npops;j++) ///output yearly T at age 4 for report file ***BE CAREFUL WITH AGE VARYING T
   {
    for (int r=1;r<=nregions(j);r++)
     {
      for(int y=1;y<=nyrs;y++)
       {
          for (int k=1;k<=npops;k++)
           {
            for (int n=1;n<=nregions(k);n++)
             {
              T_year(j,r,y,k,n)=T(j,r,y,4,k,n);            
            } 
           }
          }
         }
        }

///////SELECTIVITY CALCULATIONS///////
FUNCTION get_selectivity
 //to define max selectivity at age and rescale to max of 1.0
 dvariable sel_temp;
 //dvariable sel_temp_surv;
 //set q to true if neg phase
   if(ph_q<0)
    {
     q_survey=q_survey_TRUE;
    }
   if(ph_q>0)
   {
    for(int i=1;i<=npops;i++) 
     {
      for(int k=1;k<=nregions(i);k++) 
        {
         for(int j=1;j<=nfleets_survey(i);j++) 
          {
           q_survey(i,k,j) = mfexp(ln_q(i,j));
          }
         }
        }
       }
 if (ph_sel_log<0 && ph_sel_dubl<0)
 {
 sel_beta1=sel_beta1_TRUE;   //selectivity slope parameter 1 for logistic selectivity/double logistic
 sel_beta2=sel_beta2_TRUE;   //selectivity inflection parameter 1 for logistic selectivity/double logistic
 sel_beta3=sel_beta3_TRUE;  //selectivity slope parameter 2 for double selectivity
 sel_beta4=sel_beta4_TRUE;
 }
 else
 {
  for (int j=1;j<=npops;j++)
   {
    for (int r=1;r<=nregions(j);r++)
     {
      for (int z=1;z<=nfleets(j);z++)                    
       {
 // get betas on their arithmetic scale
         sel_beta1(j,r,z)=mfexp(log_sel_beta1(r+nreg_temp(j),z));
         sel_beta2(j,r,z)=mfexp(log_sel_beta2(r+nreg_temp(j),z));
         sel_beta3(j,r,z)=mfexp(log_sel_beta3(r+nreg_temp(j),z));
         sel_beta4(j,r,z)=mfexp(log_sel_beta4(r+nreg_temp(j),z));
        }
      }
     }
 } //close else for positive phase

 if (ph_sel_log_surv<0 && ph_sel_dubl_surv<0)
 {
 sel_beta1surv=sel_beta1_survey_TRUE;
 sel_beta2surv=sel_beta2_survey_TRUE;
 sel_beta3surv=sel_beta3_survey_TRUE;
 sel_beta4surv=sel_beta4_survey_TRUE;
 }
 else
 {
  for (int j=1;j<=npops;j++)
   {
    for (int r=1;r<=nregions(j);r++)
     {
      for (int z=1;z<=nfleets_survey(j);z++)                    
       {
 // get betas on their arithmetic scale
        sel_beta1surv(j,r,z)=mfexp(log_sel_beta1surv(j,z));
        sel_beta2surv(j,r,z)=mfexp(log_sel_beta2surv(j,z));
        sel_beta3surv(j,r,z)=mfexp(log_sel_beta3surv(j,z));
        sel_beta4surv(j,r,z)=mfexp(log_sel_beta4surv(j,z));
       }
    }
  }
 } //close else for survey select positive phase
 
 //fishery selectivity
  for (int j=1;j<=npops;j++)
   {
    for (int r=1;r<=nregions(j);r++)
     {
      for (int y=1;y<=nyrs;y++)
        {
         for (int a=1;a<=nages;a++)
           {
             for (int z=1;z<=nfleets(j);z++)
              {
               if(select_switch(j,z)==2) //4 parameter double logistic selectivity
                {
                selectivity(j,r,y,a,z)=(1/(1+mfexp(-1*sel_beta1(j,r,z)*(a-sel_beta2(j,r,z)))))*(1-(1/(1+mfexp(-1*sel_beta3(j,r,z)*(a-(sel_beta2(j,r,z)+sel_beta4(j,r,z)))))));
                //elem_prod( (1./(1.+mfexp(-1.*slope1*(ages-A501)))),(1.-(1./(1.+mfexp(-1.*slope2*(ages-(A501+A502)))))) );
                //1/((1+mfexp(-sel_beta1(j,r,z)*(a-sel_beta2(j,r,z))))*(1+mfexp(-sel_beta3(j,r,z)*(a-sel_beta4(j,r,z)))));
                }
                if(select_switch(j,z)==1) //two parameter logistic selectivity
                {
                selectivity(j,r,y,a,z)=1/(1+mfexp(-sel_beta1(j,r,z)*(a-sel_beta2(j,r,z)))); 
                }
                if(select_switch(j,z)==0) //input selectivity at age constant by year
                {
                selectivity(j,r,y,a,z)=input_selectivity(j,r,a,z);
                }
                if(select_switch(j,z)==-1) //input selectivity at age constant by year
                {
                selectivity(j,r,y,a,z)=selectivity_age_TRUE(j,r,a,z);
                }
                if(OBS_yield_fleet(j,r,y,z)==0) //if no observed catch then set selectivity to 1
                  {
                    selectivity(j,r,y,a,z)=1;
                  }
                selectivity_temp(z,a) = selectivity(j,r,y,a,z); //temporary vector for rescaling to one for each fleet
                }
              }
              //Rescale to maximum selectivity for each fleet. Have to do this outside the original age loop to get maximum across ages
              for (int a=1;a<=nages;a++)
                {
                  for (int z=1;z<=nfleets(j);z++)
                    {
                      selectivity(j,r,y,a,z) = selectivity(j,r,y,a,z)/max(selectivity_temp(z));
                    }              
                }
            }
          }
        }
      

//survey selectivity
 for (int j=1;j<=npops;j++)
    {
     for (int r=1;r<=nregions(j);r++)
      {
       for (int y=1;y<=nyrs;y++)
         {
          for (int a=1;a<=nages;a++)
            {
             for (int z=1;z<=nfleets_survey(j);z++)
               {
                if(survey_mirror(j,z)==0) //no mirroring of survey fleet to fishery fleet
                {
                  if(select_switch_survey(j,z)==2) //4 parameter double logistic selectivity
                  {
                   survey_selectivity(j,r,y,a,z)=(1/(1+mfexp(-1*sel_beta1surv(j,r,z)*(a-sel_beta2surv(j,r,z)))))*(1-(1/(1+mfexp(-1*sel_beta3surv(j,r,z)*(a-(sel_beta2surv(j,r,z)+sel_beta4surv(j,r,z)))))));
                   //survey_selectivity(j,r,y,a,z)=1/((1+mfexp(-sel_beta1surv(j,r,z)*(a-sel_beta2surv(j,r,z))))*(1+mfexp(-sel_beta3surv(j,r,z)*(a-sel_beta4surv(j,r,z)))));
                  }
                  if(select_switch_survey(j,z)==1) //two parameter logistic selectivity
                  {
                   survey_selectivity(j,r,y,a,z)=1/(1+mfexp(-sel_beta1surv(j,r,z)*(a-sel_beta2surv(j,r,z)))); //
                  }
                  if(select_switch_survey(j,z)==0) //input selectivity at age constant by year
                  {
                  survey_selectivity(j,r,y,a,z)=input_survey_selectivity(j,r,a,z);
                  }
                  if(select_switch_survey(j,z)==-1) //input selectivity at age constant by year
                  {
                  survey_selectivity(j,r,y,a,z)=survey_selectivity_age_TRUE(j,r,a,z);
                  }
                }
                
                if(survey_mirror(j,z)>0) //mirror to fleet
                {
                  survey_selectivity(j,r,y,a,z)=selectivity(j,r,y,a,survey_mirror(j,z));
                }

                survey_selectivity_temp(z,a) = survey_selectivity(j,r,y,a,z); //temporary vector for rescaling to one for each survey fleet
                }
               }
               //Rescale to maximum selectivity for each survey fleet. Have to do this outside the original age loop to get maximum across ages
               for (int a=1;a<=nages;a++)
                {
                  for (int z=1;z<=nfleets_survey(j);z++)
                    {
                      survey_selectivity(j,r,y,a,z) = survey_selectivity(j,r,y,a,z)/max(survey_selectivity_temp(z));
                    }              
                }
             }
           }
          }

   for (int j=1;j<=npops;j++)
   {
    for (int r=1;r<=nregions(j);r++)
     {
          for (int a=1;a<=nages;a++)
            {
            for (int z=1;z<=nfleets(j);z++)
              {
               selectivity_age(j,r,a,z)=selectivity(j,r,nyrs,a,z); 
              }
             for (int z=1;z<=nfleets_survey(j);z++)
               {
                //if(select_switch_survey(j,z)==1) //two parameter logistic selectivity
               // {
                survey_selectivity_age(j,r,a,z)=survey_selectivity(j,r,nyrs,a,z);
               }
              }
             }
            }

///////FISHING MORTALITY CALCULATIONS///////
FUNCTION get_F_age

  for (int j=1;j<=npops;j++)
   {
    for (int r=1;r<=nregions(j);r++)
     {
      for (int y=1;y<=nyrs;y++)
       {
        for (int a=1;a<=nages;a++)
         {
          for (int z=1;z<=nfleets(j);z++)
           {
             if(ph_F<0)
             {
              F_year(j,r,y,z)=F_year_TRUE(j,r,y,z);
             }
             else
             {
             if(F_switch==1) //estimate annual deviations
              {
                if(OBS_yield_fleet(j,r,y,z)==0) //if no observed catch then set F to 0
                {
                  F_year(j,r,y,z)=0.0001;
                }
                if(OBS_yield_fleet(j,r,y,z)>0)
                {
                  F_year(j,r,y,z)=mfexp(ln_F(y+nreg_temp(j)*nyrs+(r-1)*nyrs,z)); //ln_F index is 1 to sum(nreg)*nyr so this setup
                }
               //allows running through index by year, then moves to next region and fills in each year, then moves to next pop and fills in by year for each region, etc...
              }
        //     if(F_switch==2) //random walk or AR1  in F if we ever want to try it.
        //      {
        //       F_year(j,r,y,z)=mfexp(ln_F(y+nreg_temp(j)*nyrs+(r-1)*nyrs,z));  
        //       if(y>1)
        //       {
        //       F_year(j,r,y,z)=F_rho(j,z)*mfexp(((y-1)+nreg_temp(j)*nyrs+(r-1)*nyrs,z));            
        //       }
        //      }
             } //end else for negative F phase
             F_fleet(j,r,y,a,z)=F_year(j,r,y,z)*selectivity(j,r,y,a,z);    
            }
            F(j,r,y,a)=sum(F_fleet(j,r,y,a)); 
           }
         }
        }
       }

FUNCTION get_M_age
  for (int j=1;j<=npops;j++)
   {
    for (int r=1;r<=nregions(j);r++)
     {
      for (int y=1;y<=nyrs;y++)
       {
        for (int a=1;a<=nages;a++)
         {
          if(M_switch==(-1)) //use input M, may differ from TRUE M 
          {
            M(j,r,y,a)=input_M(j,a);
          }
          if(M_switch==0) //use true M
          {
            M(j,r,y,a)=input_M_TRUE(j,a);
          }
          if(M_switch==1) //EST constant M
          {
            M(j,r,y,a)=mfexp(ln_M_CNST);
          }
          if(M_switch==2) //EST pop-based M
          {
            M(j,r,y,a)=mfexp(ln_M_pop_CNST(j));
          }
          if(M_switch==3) //EST age-based M
          {
            M(j,r,y,a)=mfexp(ln_M_age_CNST(a));
          }
          if(M_switch==4) //EST age and pop varying M
          {
            M(j,r,y,a)=mfexp(ln_M_pop_age(j,a));
          }
         }
        }
       }
      }


FUNCTION get_report_rate //reporting rate is assumed to be function of release event and recap location (not a function of recap year...could expand to this, but not priority at momement)
 for(int y=1; y<=nyrs_release; y++)
  {
  for (int j=1;j<=npops;j++)
   {
    for (int r=1;r<=nregions(j);r++)
     {
          if(report_rate_switch==(-1)) //input report rate by pop and region, can differ from TRUE report rate from OM
           {
            report_rate(j,y,r)=input_report_rate(j,r);
           }
          if(report_rate_switch==0) //set report rate to TRUE value from OM
           {
            report_rate(j,y,r)=report_rate_TRUE(j,y,r);
           }
          if(report_rate_switch==1) //EST constant reporting rate that differs by pop and region
           {
            report_rate(j,y,r)=(mfexp(ln_rep_rate_CNST(j,r)))/(mfexp(ln_rep_rate_CNST(j,r))+1);
           }
          if(report_rate_switch==2)
           {
            report_rate(j,y,r)=(mfexp(ln_rep_rate_YR(j+npops*(y-1),r)))/(mfexp(ln_rep_rate_YR(j+npops*(y-1),r))+1);
           }
       }
     }
   }
FUNCTION get_vitals
    if(Rec_type==4 || Rec_type==5)
      {
       steep=steep_TRUE;
      }
       
    for (int j=1;j<=npops;j++)
     {
      if(ph_lmr>0)
       {
        R_ave(j)=mfexp(ln_R_ave(j)+.5*square(sigma_recruit(j))); //Dana's term, need to test if useful
       }
      //if(ph_lmr>0){R_ave(j)=mfexp(ln_R_ave(j));}
     }

    if(Rec_type==5 || Rec_type==6)
    {
     R_ave=R_ave_TRUE;
    }
    
    for (int j=1;j<=npops;j++)
     {    
      for (int r=1;r<=nregions(j);r++)   
       {       
        for (int y=1;y<=nyrs;y++)
         {
          for (int a=1;a<=nages;a++)
           {
            for (int z=1;z<=nfleets(j);z++)
             {           
              weight_population(j,r,y,a)=input_weight(j,r,a);
              weight_catch(j,r,y,a)=input_catch_weight(j,r,a);

              if(maturity_switch_equil==0) // for SPR calculations when maturity across areas is equal or if want a straight average of maturity across areas
               {
                if(SSB_type==1) //fecundity based SSB
                 {
                  ave_mat_temp(j,a,r)=prop_fem(j,r)*fecundity(j,r,a)*maturity(j,r,a);//rearranging for summing
                  ave_mat(j,a) = sum(ave_mat_temp(j,a))/nregions(j); //average maturity across regions
                  wt_mat_mult(j,y,a)=ave_mat(j,a);//for SPR calcs
                 }
               if(SSB_type==2) //weight based SSB
                {
                  ave_mat_temp(j,a,r)=prop_fem(j,r)*weight_population(j,r,y,a)*maturity(j,r,a);//rearranging for summing
                  ave_mat(j,a) = sum(ave_mat_temp(j,a))/nregions(j); //average maturity across regions
                  wt_mat_mult(j,y,a)=ave_mat(j,a);//for SPR calcs
                }
               }              

               if(SSB_type==1) //fecundity based SSB
                {
                 wt_mat_mult_reg(j,r,y,a)=prop_fem(j,r)*fecundity(j,r,a)*maturity(j,r,a);// for yearly SSB calcs
                }
               if(SSB_type==2) //weight based SSB
                {
                 wt_mat_mult_reg(j,r,y,a)=prop_fem(j,r)*weight_population(j,r,y,a)*maturity(j,r,a);
                }
               }   
             }
           }         
         }
       }

 for(int y=1;y<=nyrs-1;y++)
  {
  for (int j=1;j<=npops;j++)
   {
    for (int r=1;r<=nregions(j);r++)
     {
               if(apportionment_type==(-2)) //input TRUE recruitment apportionment directly by population and region
                {
                 Rec_Prop(j,r,y)=Rec_Prop_TRUE(j,r,y); //rec_prop_true is every year
                }
               if(apportionment_type==(-1)) // no apportionment
                {
                 Rec_Prop(j,r,y)=1;
                }           
               if(apportionment_type==1) //input recruitment apportionment directly by population and region (can be different from true apportionment)
                {
                 Rec_Prop(j,r,y)=input_rec_prop(j,r,y);
                }
               if(apportionment_type==2) //equal apportionment by nregions
                {
                 Rec_Prop(j,r,y)=1.0/nregions(j);
                }
        }
      }
     }

  if(apportionment_type==3)
   {
   if(ph_rec_app_CNST>0) 
    {
    G_app=0;
     G_app_temp=0;
  
     for (int j=1;j<=npops;j++)
        {
        for (int i=1;i<=nregions(j);i++) 
         {
            
         if(i==1)
          {
           G_app(j,i)=1;
            }
           if(i>1)
            {
            G_app(j,i)=mfexp(ln_rec_prop_CNST(j,i-1));
            }
           }
          }
       G_app_temp=rowsum(G_app);

 for(int y=1;y<=nyrs-1;y++)
  {
  for (int j=1;j<=npops;j++)
   {
    for (int r=1;r<=nregions(j);r++)
     {
        Rec_Prop(j,r,y)=G_app(j,r)/G_app_temp(j);
      }
     }
    }
   }
  }


 //THIS YEARLY APPORTIONMENT NEEDS TO BE TESTED THOROUGHLY
  if(apportionment_type==4)
   {
  for(int y=1;y<=nyrs-1;y++)
  {
    G_app=0;
     G_app_temp=0;
      for (int j=1;j<=npops;j++)
       {
        for (int i=1;i<=nregions(j);i++) 
         {
            if(i==1)
            {
            G_app(j,i)=1;
            }
            if(i>1)
            {
             G_app(j,i)=mfexp(ln_rec_prop_YR(j+npops*(y-1),i-1));
            }
           }
          }        
      G_app_temp=rowsum(G_app);
  for (int j=1;j<=npops;j++)
   {
    for (int r=1;r<=nregions(j);r++)
     {
        Rec_Prop(j,r,y)=G_app(j,r)/G_app_temp(j); //apportionment not used in first year bec no SR function used
      }
     }
    }
   }
  
      for (int j=1;j<=npops;j++)
       {
        for (int a=1;a<=nages;a++)
         {
          if(a==1)
          {
           init_abund_age(j,a)=R_ave(j); //use R_ave as age-1 abund in year 1 to avoid overparametrization
          }
          if(a>1)
          {
          init_abund_age(j,a)=mfexp(ln_init_abund(j,a-1)); //age based abund devs by population
          }
         }
       }

 if(est_dist_init_abund==(-2)) //use input_dist_init_abund specified for EM (can differ from true)
  {
         for (int j=1;j<=npops;j++)
          {
          for (int k=1;k<=npops;k++)
           {
            for (int n=1;n<=nregions(k);n++)
             {
              frac_natal(j,k,n)=input_dist_init_abund(j,k,n);
             }
            } 
           }
         }

 if(est_dist_init_abund==(-1)) //assume all fish in a pop are equally distributed across regions in that pop (no fish start outside natal pop)
  {
         for (int j=1;j<=npops;j++)
          {
          for (int k=1;k<=npops;k++)
           {
            for (int n=1;n<=nregions(k);n++)
             {
              if(j==k)
               {
                 frac_natal(j,k,n)=1/nregions(k);
               }
              if(j!=k)
               {
                 frac_natal(j,k,n)=0;
               }
             }
            } 
           }
         }
         
 if(est_dist_init_abund==0) //use true distribution of init_abundance
  {
         for (int j=1;j<=npops;j++)
          {
          for (int k=1;k<=npops;k++)
           {
            for (int n=1;n<=nregions(k);n++)
             {
              frac_natal(j,k,n)=frac_natal_true(j,k,n);
             }
            } 
           }
         }

 if(est_dist_init_abund==1) //estimate the spatial distribution of init abundance
  {
   if(natal_homing_switch>0) //estimate parameters to distribute a population across multiple non-natal areas in first year
    {
    G_nat=0;
     G_nat_temp=0;
      for (int j=1;j<=npops;j++)
       {
        for (int i=1;i<=sum(nregions);i++) 
         {
            if(j==i)
            {
            G_nat(j,i)=1;
            }
            if(i>j)
            {
            G_nat(j,i)=mfexp(ln_nat(j,i-1));
            }
            if(j!=i && i<j)
            {
            G_nat(j,i)=mfexp(ln_nat(j,i));
            }
           }
          }    
      G_nat_temp=rowsum(G_nat);

  for (int j=1;j<=npops;j++)
   {
          for (int k=1;k<=npops;k++)
           {
            for (int n=1;n<=nregions(k);n++)
             {
              frac_natal(j,k,n)=G_nat(j,n+nreg_temp(k))/G_nat_temp(j);
             }
            } 
           }
          }
        
   if(natal_homing_switch==0) //estimate parameters to distribute a population across multiple regions
    {
    G_reg=0;
     G_reg_temp=0;
      for (int j=1;j<=npops;j++)
       {
        for (int i=1;i<=nregions(j);i++) 
         {
            if(j==i)
            {
            G_reg(j,i)=1;
            }
            if(i>j)
            {
            G_reg(j,i)=mfexp(ln_reg(j,i-1));
            }
            if(j!=i && i<j)
            {
            G_reg(j,i)=mfexp(ln_reg(j,i));
            }
           }
          }    
      G_reg_temp=rowsum(G_reg);

      for (int j=1;j<=npops;j++)
        {
          for (int k=1;k<=npops;k++)
           {
            for (int n=1;n<=nregions(k);n++)
             {
              if(j==k)
               {
                 frac_natal(j,k,n)=G_reg(k,n)/G_reg_temp(k);
               }
              if(j!=k)
               {
                 frac_natal(j,k,n)=0;
               }
             }
            } 
           }
    }
    }
  
    for (int j=1;j<=npops;j++)
     {              
        for (int y=1;y<=nyrs-1;y++)
              {
               if(recruit_devs_switch==(-1))  //fix at true value
                {
                   rec_devs(j,y)=rec_devs_TRUE(j,y+1); //rec_devs vector in OM has length=nyrs, but only begins being used in year 2
                }
               if(recruit_devs_switch==0)  //use population recruit relationship directly
                {
                 rec_devs(j,y)=1;
                }
               if(recruit_devs_switch==1)  // allow lognormal error around SR curve
                {
                rec_devs(j,y)=mfexp(ln_rec_devs(j,y)-.5*square(sigma_recruit(j)));
                   
             //    if(recruit_randwalk_switch==1)
             //    {
             //     rec_devs_randwalk(j,y)=rec_devs(j,y);
             //     if(y>(nages+1)) //start random walk in year3 based on year 2 devs as starting point (don't use equilibrium devs from year 1)
             //      {
              //      rec_devs(j,y)=rec_devs(j,y-1)*rec_devs_randwalk(j,y);  //is this correct?
              //     }
              //   }
                }
               }
              }
            // }

//SPR calcs are done with eitehr  average maturity/weight across all the regions within a population or assuming an input population fraction at equilibrium
// while the full SSB calcs use the region specific maturity/weight
FUNCTION get_SPR

      for (int k=1;k<=npops;k++)
     {
      for (int n=1;n<=nages;n++)
       {
        if(n==1)
                {
          SPR_N(k,n)=1000;
          SPR_SSB(k,n)=wt_mat_mult(k,1,n)*SPR_N(k,n);
         }
        if(n>1 && n<nages)
         {
          SPR_N(k,n)=SPR_N(k,n-1)*mfexp(-M(k,1,1,n-1));
          SPR_SSB(k,n)=wt_mat_mult(k,1,n)*SPR_N(k,n);
         }
        if(n==nages)
         {
          SPR_N(k,n)=SPR_N(k,n-1)*mfexp(-M(k,1,1,n))*(1/(1-mfexp(-M(k,1,1,n))));
          SPR_SSB(k,n)=wt_mat_mult(k,1,n)*SPR_N(k,n);
         }
       }
     SPR(k)=sum(SPR_SSB(k))/1000;
     SSB_zero(k)=SPR(k)*R_ave(k);
      if(Rec_type==2) //BH recruitment
      {
      alpha(k)=(SSB_zero(k)/R_ave(k))*((1-steep(k))/(4*steep(k)));//alternate parameterization
      beta(k)=(5*steep(k)-1)/(4*steep(k)*R_ave(k));
      }
    }

 
FUNCTION get_abundance

       for (int y=1;y<=nyrs;y++)
        {

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////// Y==1 Overlap Calcs ///////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       if(y==1)
         {
         for (int a=1;a<=nages;a++)
          {
           for (int p=1;p<=npops;p++)
            {
             for (int j=1;j<=npops;j++)
              {             
               for (int r=1;r<=nregions(j);r++)
                {
                 for (int z=1;z<=nfleets(j);z++)
                 {
                 
                if(init_abund_switch==0) //estimate abundance at age
                 {
                   init_abund(p,j,r,a)=init_abund_age(p,a)*frac_natal(p,j,r);
                 }
                if(init_abund_switch==(-1)) //fix abundance at age at true value
                   {
                    init_abund(p,j,r,a)=init_abund_TRUE(p,j,r,a);
                   }
               if(init_abund_switch==(-2)) //fix abundance at age at input value
                   {
                    init_abund(p,j,r,a)=init_abund_EM(p,j,r,a);
                   }        
                   
               if(init_abund_switch==1) //assume an exponential decay from R_ave for init abundance
                  {
                  // if(ph_init_abund<0)
                  // {
                     //init_abund(p,j,r,a)=R_ave(p)*abund_devs(p,a)*pow(mfexp(-(M(p,r,y,a))),a-1)*frac_natal(p,j,r);
                     init_abund(p,j,r,a)=R_ave(p)*pow(mfexp(-(M(p,r,y,a))),a-1)*frac_natal(p,j,r);
                  // }
                  }

                    abundance_at_age_BM_overlap_region(p,j,y,a,r)=init_abund(p,j,r,a);
                    abundance_at_age_BM_overlap_population(p,j,y,a)=sum(abundance_at_age_BM_overlap_region(p,j,y,a));
                    biomass_BM_age_overlap(p,j,r,y,a)=weight_population(p,r,y,a)*abundance_at_age_BM_overlap_region(p,j,y,a,r);
                    biomass_BM_overlap_region(p,j,r,y)=sum(biomass_BM_age_overlap(p,j,r,y));

                   init_abund_temp(j,r,a,p)=init_abund(p,j,r,a); //for non natal homing scenarios abund=0 when j!=p
                   abundance_at_age_BM(j,r,y,a)=sum(init_abund_temp(j,r,a));
                   recruits_BM(j,r,y)=abundance_at_age_BM(j,r,y,1);

////////////////////////////////////////////////////////////////////////////////

                  if(natal_homing_switch==0)
                   {
                    biomass_BM_age(j,r,y,a)=weight_population(j,r,y,a)*abundance_at_age_BM(j,r,y,a);
                    biomass_BM(j,r,y)=sum(biomass_BM_age(j,r,y));
                   }
                  if(natal_homing_switch>0) //if natal homing put abundance summed across natal population by region into abundance at age AM
                   {
                    biomass_BM_overlap_temp(j,r,y,a,p)=biomass_BM_age_overlap(p,j,r,y,a);
                    biomass_BM_age(j,r,y,a)=sum(biomass_BM_overlap_temp(j,r,y,a));
                    biomass_BM(j,r,y)=sum(biomass_BM_age(j,r,y));
                   }
                                      
 ///get year one recruitment index
               rec_index_BM(j,r,y) = recruits_BM(j,r,y);
               rec_index_BM_temp(j,y,r)=rec_index_BM(j,r,y);
               rec_index_prop_BM(j,r,y)=rec_index_BM(j,r,y)/sum(rec_index_BM_temp(j,y));
              }
             }
            }
           }
          } //close loops so have full biomass vectors filled in at start of DD movement calcs

         for (int a=1;a<=nages;a++)
          {
           for (int p=1;p<=npops;p++)
            {
             for (int j=1;j<=npops;j++)
              {
               for (int r=1;r<=nregions(j);r++)
                {
                 for (int z=1;z<=nfleets(j);z++)
                  {

                 abundance_move_overlap_temp=0;

                for (int k=1;k<=npops;k++)
                 {
                  for (int n=1;n<=nregions(k);n++)
                   {              
                    if(move_switch!=6 || move_switch!=7 || a==1)  //if movement is not type=6 or a==1 (and movement type 6)
                     {
                       abundance_move_overlap_temp(k,n)=init_abund(p,k,n,a)*T(p,n,y,a,j,r); //with overlap always use natal population movement rates  (i.e., use p instead of k)
                     }
                    if(move_switch==6 && a>1)
                     {
                      if(a==return_age && p==j && p==k && j==k)
                      {
                       abundance_move_overlap_temp(k,n)=0; //with overlap always use natal population movement rates
                      }
                      if(a==return_age && p==j && j!=k)
                      {
                       abundance_move_overlap_temp(k,n)=init_abund(p,k,n,a)*return_probability(p); //with overlap always use natal population movement rates
                      }
                     }
                   }
                  }
                    if(move_switch!=6 || move_switch!=7  || a==1)
                     {
                        abundance_at_age_AM_overlap_region(p,j,y,a,r)=sum(abundance_move_overlap_temp);
                     }
                    if(move_switch==7)  //all fish stay where they were (i.e., no return migration)
                     {
                        abundance_at_age_AM_overlap_region(p,j,y,a,r)=init_abund(p,j,r,a);
                     }
                    if(move_switch==6 && a>1)
                     {
                      if(a<return_age || a>return_age)
                       {
                        abundance_at_age_AM_overlap_region(p,j,y,a,r)=init_abund(p,j,r,a); //with overlap always use natal population movement rates                     
                       }
                      if(a==return_age && p==j)
                       {
                        abundance_at_age_AM_overlap_region(p,j,y,a,r)=init_abund(p,j,r,a)+(sum(abundance_move_overlap_temp)/nregions(p));
                       }
                      if(a==return_age && p!=j)
                       {
                        abundance_at_age_AM_overlap_region(p,j,y,a,r)=(1-return_probability(p))*init_abund(p,j,r,a);
                       }
                      }
                      
                abundance_AM_overlap_region_all_natal_temp(j,r,y,a,p)=abundance_at_age_AM_overlap_region(p,j,y,a,r);
                biomass_AM_overlap_region_all_natal_temp(j,r,y,a,p)=abundance_at_age_AM_overlap_region(p,j,y,a,r)*weight_population(p,r,y,a);
                abundance_AM_overlap_region_all_natal(j,r,y,a)=sum(abundance_AM_overlap_region_all_natal_temp(j,r,y,a));
                biomass_AM_overlap_age_region_all_natal(j,r,y,a)=sum(biomass_AM_overlap_region_all_natal_temp(j,r,y,a));
                biomass_AM_overlap_region_all_natal(j,r,y)=sum(biomass_AM_overlap_age_region_all_natal(j,r,y));
                abundance_at_age_AM_overlap_population(p,j,y,a)=sum(abundance_at_age_AM_overlap_region(p,j,y,a));
                biomass_AM_age_overlap(p,j,r,y,a)=weight_population(p,r,y,a)*abundance_at_age_AM_overlap_region(p,j,y,a,r);
                biomass_AM_overlap_region(p,j,r,y)=sum(biomass_AM_age_overlap(p,j,r,y));
                biomass_population_temp_overlap(p,j,y,r)=biomass_AM_overlap_region(p,j,r,y);
                biomass_population_overlap(p,j,y)=sum(biomass_population_temp_overlap(p,j,y));
                biomass_natal_temp_overlap(p,y,j)=biomass_population_overlap(p,j,y);
                biomass_natal_overlap(p,y)=sum(biomass_natal_temp_overlap(p,y));

///////////MIGHT WANT TO DO FOLLOWING CALCS FOR NATAL HOMING AS WELL (DO METAPOP TYPE CALCS BELOW)
              //  abundance_in(j,r,y,a)=sum(abundance_move_temp)-abundance_move_temp(j,r);
              //  abundance_res(j,r,y,a)=abundance_move_temp(j,r);
              //  abundance_leave(j,r,y,a)=abundance_at_age_BM(j,r,y,a)-abundance_res(j,r,y,a);
              //  bio_in(j,r,y,a)=sum(bio_move_temp)-bio_move_temp(j,r);
              //  bio_res(j,r,y,a)=bio_move_temp(j,r);
              //  bio_leave(j,r,y,a)=abundance_at_age_BM(j,r,y,a)*weight_population(j,y,a)-bio_res(j,r,y,a);
                
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
///////////////NON-NATAL Homing movement calcs and putting natal homing abundance into area abundance/////////////////////////////////////////////////////////////// //////////////////////////////////////////////////////////////////////////////
    
                abundance_move_temp=0;
                bio_move_temp=0;

                for (int k=1;k<=npops;k++)
                 {
                  for (int n=1;n<=nregions(k);n++)
                   {
                     abundance_move_temp(k,n)=abundance_at_age_BM(k,n,y,a)*T(k,n,y,a,j,r);
                     bio_move_temp(k,n)=abundance_move_temp(k,n)*weight_population(k,n,y,a);                   
                   }
                  }
                  if(natal_homing_switch>0) //if natal homing put abundance summed across natal population by region into abundance at age AM
                   {
                    abundance_at_age_AM(j,r,y,a)=abundance_AM_overlap_region_all_natal(j,r,y,a);
                    biomass_AM(j,r,y)= biomass_AM_overlap_region_all_natal(j,r,y);
                   }
                  if(natal_homing_switch==0)
                   {
                    abundance_at_age_AM(j,r,y,a)=sum(abundance_move_temp);
                    biomass_AM_age(j,r,y,a)=weight_population(j,r,y,a)*abundance_at_age_AM(j,r,y,a);
                    biomass_AM(j,r,y)=sum(biomass_AM_age(j,r,y));
                   }
                   
                abundance_population_temp(j,y,a,r)=abundance_at_age_AM(j,r,y,a);
                abundance_population(j,y,a)=sum(abundance_population_temp(j,y,a));
                abundance_total_temp(y,a,j)=abundance_population(j,y,a);
                abundance_total(y,a)=sum(abundance_total_temp(y,a));
                biomass_population_temp(j,y,r)=biomass_AM(j,r,y);
                biomass_population(j,y)=sum(biomass_population_temp(j,y));
                biomass_total_temp(y,j)=biomass_population(j,y);
                biomass_total(y)=sum(biomass_total_temp(y));

                recruits_AM(j,r,y)=abundance_at_age_AM(j,r,y,a);                
                rec_index_AM(j,r,y)=recruits_AM(j,r,y);
                rec_index_AM_temp(j,y,r)=rec_index_AM(j,r,y);
                rec_index_prop_AM(j,r,y)=rec_index_AM(j,r,y)/sum(rec_index_AM_temp(j,y));

                abundance_in(j,r,y,a)=sum(abundance_move_temp)-abundance_move_temp(j,r);
                abundance_res(j,r,y,a)=abundance_move_temp(j,r);
                abundance_leave(j,r,y,a)=abundance_at_age_BM(j,r,y,a)-abundance_res(j,r,y,a);
                bio_in(j,r,y,a)=sum(bio_move_temp)-bio_move_temp(j,r);
                bio_res(j,r,y,a)=bio_move_temp(j,r);
                bio_leave(j,r,y,a)=abundance_at_age_BM(j,r,y,a)*weight_population(j,r,y,a)-bio_res(j,r,y,a);
    
          } //end fleets loop

             for (int z=1;z<=nfleets_survey(j);z++)    /// survey index  1. Currently set up for more than 1 survey fleet
              {
               if(tsurvey(j,r)==0) //if survey at beggining of year, do calcs without temporal adjustment for mortality
                {
                  survey_fleet_overlap_age(p,j,r,y,z,a)=survey_selectivity(j,r,y,a,z)*abundance_at_age_AM_overlap_region(p,j,y,a,r)*q_survey(j,r,z);
                  survey_fleet_overlap_age_bio(p,j,r,y,z,a)=survey_fleet_overlap_age(p,j,r,y,z,a)*weight_population(p,r,y,a);
                  survey_fleet_bio_overlap(p,j,r,y,z)=sum(survey_fleet_overlap_age_bio(p,j,r,y,z));  
                  survey_fleet_bio_overlap_temp(j,r,y,z,p)=survey_fleet_bio_overlap(p,j,r,y,z);

                if(natal_homing_switch==0)
                 {
                  survey_fleet_age(j,r,y,z,a)=survey_selectivity(j,r,y,a,z)*abundance_at_age_AM(j,r,y,a)*q_survey(j,r,z);
                  survey_fleet_age_bio(j,r,y,z,a)=survey_fleet_age(j,r,y,z,a)*weight_population(j,r,y,a);                  
                  survey_fleet_bio(j,r,y,z)=sum(survey_fleet_age_bio(j,r,y,z));
                 }
                if(natal_homing_switch==1)
                 {
                  survey_fleet_bio(j,r,y,z)=sum(survey_fleet_bio_overlap_temp(j,r,y,z));
                 }
             
                  survey_region_bio_overlap(p,j,y,r)=sum(survey_fleet_bio_overlap(p,j,r,y));               
                  survey_population_bio_overlap(p,y,j)=sum(survey_region_bio_overlap(p,j,y));               
                  survey_natal_bio_overlap(y,p)=sum(survey_population_bio_overlap(p,y));               
                  survey_total_bio_overlap(y)=sum(survey_natal_bio_overlap(y));

                  survey_region_bio(j,y,r)=sum(survey_fleet_bio(j,r,y));
                  survey_population_bio(y,j)=sum(survey_region_bio(j,y));
                  survey_total_bio(y)=sum(survey_population_bio(y));
                  
                }  //tsurvey==0
               } //end survey_fleets
            }
           }
          }
         } //end age loop

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         for (int a=1;a<=nages;a++)
           {
           for (int p=1;p<=npops;p++)
            {
             for (int j=1;j<=npops;j++)
              {
               for (int r=1;r<=nregions(j);r++)
                {
                 for (int z=1;z<=nfleets(j);z++)
                  {
                abundance_spawn_overlap(p,j,r,y,a)=abundance_at_age_AM_overlap_region(p,j,y,a,r)*mfexp(-(M(j,r,y,a)+F(j,r,y,a))*tspawn(p));
                SSB_region_temp_overlap(p,j,r,y,a)=abundance_spawn_overlap(p,j,r,y,a)*wt_mat_mult_reg(p,r,y,a); //changed mat by region
                SSB_region_overlap(p,j,r,y)=sum(SSB_region_temp_overlap(p,j,r,y));

                  SSB_overlap_natal=0;
                  if(natal_homing_switch==1 && spawn_return_switch==1)
                   {
                    for(int k=1;k<=npops;k++)
                     {
                      for (int n=1;n<=nregions(k);n++)
                       {
                        if(p==k && j==k)
                         {
                          SSB_overlap_natal(k,n)=0;  // already account for all fish already in natal population in calc below
                         }   
                        if(p==j && j!=k)
                         {
                          SSB_overlap_natal(k,n)=spawn_return_prob(p)*SSB_region_overlap(p,k,n,y);
                         } 
                       }
                      } 
                      if(p==j)
                      {
                       SSB_region_overlap(p,j,r,y)=SSB_region_overlap(p,j,r,y)+(sum(SSB_overlap_natal)/nregions(p));  //reutrning SSB is split evenly across natal regionp
                       }
                   }
                   
                SSB_population_temp_overlap(p,j,y,r)=SSB_region_overlap(p,j,r,y); 
                SSB_population_overlap(p,j,y)=sum(SSB_population_temp_overlap(p,j,y));
                SSB_natal_overlap_temp(p,y,j)=SSB_population_overlap(p,j,y);
                SSB_natal_overlap(p,y)=sum(SSB_natal_overlap_temp(p,y));
                abundance_natal_temp_overlap(p,y,a,j)=abundance_at_age_AM_overlap_population(p,j,y,a);
                abundance_natal_overlap(p,y,a)=sum(abundance_natal_temp_overlap(p,y,a));
                if(a==1)
                 {
                  catch_at_age_region_overlap(p,j,r,y,a)=abundance_at_age_AM_overlap_region(p,j,y,a,r)*(1.0-mfexp(-(F(j,r,y,a)+M(j,r,y,a))*(1-tspawn(p))))*(F(j,r,y,a)/(F(j,r,y,a)+M(j,r,y,a))); // took out regional M *dh*
                  catch_at_age_region_fleet_overlap(p,j,r,z,y,a)=abundance_at_age_AM_overlap_region(p,j,y,a,r)*(1.0-mfexp(-(F_fleet(j,r,y,a,z)+M(j,r,y,a))*(1-tspawn(p))))*(F_fleet(j,r,y,a,z)/(F_fleet(j,r,y,a,z)+M(j,r,y,a))); // took out regional M *dh*
                 }
                if(a>1)
                 {
                  catch_at_age_region_overlap(p,j,r,y,a)=abundance_at_age_AM_overlap_region(p,j,y,a,r)*(1.0-mfexp(-(F(j,r,y,a)+M(j,r,y,a))))*(F(j,r,y,a)/(F(j,r,y,a)+M(j,r,y,a))); //// took out regional M *dh*
                  catch_at_age_region_fleet_overlap(p,j,r,z,y,a)=abundance_at_age_AM_overlap_region(p,j,y,a,r)*(1.0-mfexp(-(F_fleet(j,r,y,a,z)+M(j,r,y,a))))*(F_fleet(j,r,y,a,z)/(F_fleet(j,r,y,a,z)+M(j,r,y,a))); // took out regional M *dh*            
                 }
                yield_region_fleet_temp_overlap(p,j,r,z,y,a)=weight_catch(p,r,y,a)*catch_at_age_region_fleet_overlap(p,j,r,z,y,a);
                yield_region_fleet_overlap(p,j,r,z,y)=sum(yield_region_fleet_temp_overlap(p,j,r,z,y));
                yield_region_temp_overlap(p,j,r,y,a)=weight_catch(p,r,y,a)*catch_at_age_region_overlap(p,j,r,y,a);
                yield_region_overlap(p,j,r,y)=sum(yield_region_temp_overlap(p,j,r,y));
                catch_at_age_population_temp_overlap(p,j,y,a,r)=catch_at_age_region_overlap(p,j,r,y,a);
                catch_at_age_population_overlap(p,j,y,a)=sum(catch_at_age_population_temp_overlap(p,j,y,a));
                yield_population_temp_overlap(p,j,y,a)=weight_catch(p,r,y,a)*catch_at_age_population_overlap(p,j,y,a);
                yield_population_overlap(p,j,y)=sum(yield_population_temp_overlap(p,j,y));
                catch_at_age_natal_temp_overlap(p,y,a,j)=catch_at_age_population_overlap(p,j,y,a);
                catch_at_age_natal_overlap(p,y,a)=sum(catch_at_age_natal_temp_overlap(p,y,a));
                yield_natal_temp_overlap(p,y,j)=yield_population_overlap(p,j,y);
                yield_natal_overlap(p,y)=sum(yield_natal_temp_overlap(p,y));
                harvest_rate_region_fleet_bio_overlap(p,j,r,z,y)=yield_region_fleet_overlap(p,j,r,z,y)/biomass_AM_overlap_region(p,j,r,y);
                harvest_rate_region_bio_overlap(p,j,r,y)=yield_region_overlap(p,j,r,y)/biomass_AM_overlap_region(p,j,r,y);
                harvest_rate_population_bio_overlap(p,j,y)=yield_population_overlap(p,j,y)/biomass_population_overlap(p,j,y);
                harvest_rate_natal_bio_overlap(p,y)=yield_natal_overlap(p,y)/biomass_natal_overlap(p,y);
                depletion_region_overlap(p,j,r,y)=biomass_AM_overlap_region(p,j,r,y)/biomass_AM_overlap_region(p,j,r,1);
                depletion_population_overlap(p,j,y)=biomass_population_overlap(p,j,y)/biomass_population_overlap(p,j,1);
                depletion_natal_overlap(p,y)=biomass_natal_overlap(p,y)/biomass_natal_overlap(p,1);
                Bratio_population_overlap(p,j,y)=SSB_population_overlap(p,j,y)/SSB_zero(p);
                Bratio_natal_overlap(p,y)=SSB_natal_overlap(p,y)/SSB_zero(p);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////Y==1 Abundance Calcs//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////  CONTINUATION of NON-NATAL HOMING CALCS ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                abundance_spawn(j,r,y,a)=abundance_at_age_AM(j,r,y,a)*mfexp(-(M(j,r,y,a)+F(j,r,y,a))*tspawn(j));
                if(a==1)
                 {
                  catch_at_age_fleet(j,r,y,a,z)=abundance_at_age_AM(j,r,y,a)*(1.0-exp(-(F_fleet(j,r,y,a,z)+M(j,r,y,a))*(1-tspawn(j))))*(F_fleet(j,r,y,a,z))/(F(j,r,y,a)+M(j,r,y,a)); // took out regional M *dh*
                 }
                if(a>1)
                 {
                  catch_at_age_fleet(j,r,y,a,z)=abundance_at_age_AM(j,r,y,a)*(1.0-exp(-(F_fleet(j,r,y,a,z)+M(j,r,y,a))))*(F_fleet(j,r,y,a,z))/(F(j,r,y,a)+M(j,r,y,a)); // took out regional M *dh*
                 }
                yield_fleet_temp(j,r,y,z,a)=weight_catch(j,r,y,a)*catch_at_age_fleet(j,r,y,a,z);
                yield_fleet(j,r,y,z)=sum(yield_fleet_temp(j,r,y,z));
                yieldN_fleet_temp(j,r,y,z,a)=catch_at_age_fleet(j,r,y,a,z);
                yieldN_fleet(j,r,y,z)=sum(yieldN_fleet_temp(j,r,y,z));
                catch_at_age_region(j,r,y,a)=sum(catch_at_age_fleet(j,r,y,a));
                yield_region_temp(j,r,y,a)=weight_catch(j,r,y,a)*catch_at_age_region(j,r,y,a);
                yield_region(j,r,y)=sum(yield_region_temp(j,r,y));
                catch_at_age_population_temp(j,y,a,r)=catch_at_age_region(j,r,y,a);
                catch_at_age_population(j,y,a)=sum(catch_at_age_population_temp(j,y,a));
                yield_population_temp(j,y,a)=weight_catch(j,r,y,a)*catch_at_age_population(j,y,a);
                yield_population(j,y)=sum(yield_population_temp(j,y));
                catch_at_age_total_temp(y,a,j)=catch_at_age_population(j,y,a);
                catch_at_age_total(y,a)=sum(catch_at_age_total_temp(y,a));
                yield_total_temp(y,j)=yield_population(j,y);
                yield_total(y)=sum(yield_total_temp(y));
                harvest_rate_region_num(j,r,y,a)=catch_at_age_region(j,r,y,a)/abundance_at_age_AM(j,r,y,a);
                harvest_rate_population_num(j,y,a)=catch_at_age_population(j,y,a)/abundance_population(j,y,a);
                harvest_rate_total_num(y,a)=catch_at_age_total(y,a)/abundance_total(y,a);
                harvest_rate_region_bio(j,r,y)=yield_region(j,r,y)/biomass_AM(j,r,y);
                harvest_rate_population_bio(j,y)=yield_population(j,y)/biomass_population(j,y);
                harvest_rate_total_bio(y)=yield_total(y)/biomass_total(y);
                depletion_region(j,r,y)=biomass_AM(j,r,y)/biomass_AM(j,r,1);
                depletion_population(j,y)=biomass_population(j,y)/biomass_population(j,1);
                depletion_total(y)=biomass_total(y)/biomass_total(1);

              if(natal_homing_switch>0)
               {
               if(p==j)
               {
                SSB_region(j,r,y)=SSB_region_overlap(p,j,r,y);  //if natal homing only account for SSB that is in its natal populations area, don't sum across natal populations
               }
              }
              if(natal_homing_switch==0)
              {
                SSB_region_temp(j,r,y,a)=abundance_spawn(j,r,y,a)*wt_mat_mult_reg(j,r,y,a); // changed mat by region
                SSB_region(j,r,y)=sum(SSB_region_temp(j,r,y));
              }
                SSB_population_temp(j,y,r)=SSB_region(j,r,y); 
                SSB_population(j,y)=sum(SSB_population_temp(j,y)); 
                SSB_total_temp(y,j)=SSB_population(j,y);
                SSB_total(y)=sum(SSB_total_temp(y));
                Bratio_population(j,y)=SSB_population(j,y)/SSB_zero(j);
                Bratio_total(y)=SSB_total(y)/sum(SSB_zero);

          } //end fleets loop
             for (int z=1;z<=nfleets_survey(j);z++)    /// survey index  1. Currently set up for more than 1 survey fleet
              {
               if(tsurvey(j,r)>0) //if survey at beggining of year, do calcs without temporal adjustment for mortality
                {
                  survey_fleet_overlap_age(p,j,r,y,z,a)=survey_selectivity(j,r,y,a,z)*abundance_at_age_AM_overlap_region(p,j,y,a,r)*mfexp(-(M(j,r,y,a)+F(j,r,y,a))*tsurvey(j,r))*q_survey(j,r,z);
                  survey_fleet_overlap_age_bio(p,j,r,y,z,a)=survey_fleet_overlap_age(p,j,r,y,z,a)*weight_population(p,r,y,a);
                  survey_fleet_bio_overlap(p,j,r,y,z)=sum(survey_fleet_overlap_age_bio(p,j,r,y,z));  
                  survey_fleet_bio_overlap_temp(j,r,y,z,p)=survey_fleet_bio_overlap(p,j,r,y,z);

                if(natal_homing_switch==0)
                 {
                  survey_fleet_age(j,r,y,z,a)=survey_selectivity(j,r,y,a,z)*abundance_at_age_AM(j,r,y,a)*mfexp(-(M(j,r,y,a)+F(j,r,y,a))*tsurvey(j,r))*q_survey(j,r,z);
                  survey_fleet_age_bio(j,r,y,z,a)=survey_fleet_age(j,r,y,z,a)*weight_population(j,r,y,a);                  
                  survey_fleet_bio(j,r,y,z)=sum(survey_fleet_age_bio(j,r,y,z));
                 }
                if(natal_homing_switch==1)
                 {
                  survey_fleet_bio(j,r,y,z)=sum(survey_fleet_bio_overlap_temp(j,r,y,z));
                 }
             
                  survey_region_bio_overlap(p,j,y,r)=sum(survey_fleet_bio_overlap(p,j,r,y));               
                  survey_population_bio_overlap(p,y,j)=sum(survey_region_bio_overlap(p,j,y));               
                  survey_natal_bio_overlap(y,p)=sum(survey_population_bio_overlap(p,y));               
                  survey_total_bio_overlap(y)=sum(survey_natal_bio_overlap(y));

                  survey_region_bio(j,y,r)=sum(survey_fleet_bio(j,r,y));
                  survey_population_bio(y,j)=sum(survey_region_bio(j,y));
                  survey_total_bio(y)=sum(survey_population_bio(y));
                } //tsurvey>0
               }  //end survey_fleets 
             }
            }
           }
          }//end age loop          
        } //end yr 1

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////Recruitment Calcs///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
    if(y>1)
     {
        for (int a=1;a<=nages;a++)
          {
           for (int p=1;p<=npops;p++)
            {
             for (int j=1;j<=npops;j++)
              {
               for (int r=1;r<=nregions(j);r++)
                {
                 for (int z=1;z<=nfleets(j);z++)
                  {
                   if(a==1)
                   {
                 if(natal_homing_switch>0)
                 {
                 if(p==j)
                 {
                 if(Rec_type==1) //average recruitment
                  {
                   if(apportionment_type!=0) //use prespecified Rec_Prop to apportion recruitment among regions within a population
                    {
                     SR(j,y-1)=R_ave(j);
                     total_recruits(j,y-1)=R_ave(j)*rec_devs(j,y-1);
                     recruits_BM(j,r,y)=R_ave(j)*rec_devs(j,y-1)*Rec_Prop(j,r,y-1);
                    }
                   if(apportionment_type==0)  //use relative SSB to apportion recruitment among regionp within a population
                    {
                     SR(j,y-1)=R_ave(j);
                     total_recruits(j,y-1)=R_ave(j)*rec_devs(j,y-1);
                     recruits_BM(j,r,y)=R_ave(j)*rec_devs(j,y-1)*(SSB_region_overlap(p,j,r,y-1)/sum(SSB_region_overlap(p,j,y-1))); //assume with natal homing that fish aren't from a particular region so when apportion them use relative SSB in each region (but don't account for SSB that moves back to the region to spawn ie fish that move back add to population SSB but not region SSB)
                    }
                  }

                 if(Rec_type==2) //BH recruitment
                  {
                   if(apportionment_type!=0)  //use prespecified Rec_Prop to apportion recruitment among regions within a population
                    {
                    SR(j,y-1)=((SSB_population_overlap(p,j,y-1))/(alpha(j)+beta(j)*SSB_population_overlap(p,j,y-1)));
                    total_recruits(j,y-1)=((SSB_population_overlap(p,j,y-1))/(alpha(j)+beta(j)*SSB_population_overlap(p,j,y-1)))*rec_devs(j,y-1);
                    recruits_BM(j,r,y)=((SSB_population_overlap(p,j,y-1))/(alpha(j)+beta(j)*SSB_population_overlap(p,j,y-1)))*rec_devs(j,y-1)*Rec_Prop(j,r,y-1);
                    }
                   if(apportionment_type==0) //use relative SSB to apportion recruitment among regions within a population
                    {
                     SR(j,y-1)=((SSB_population_overlap(p,j,y-1))/(alpha(j)+beta(j)*SSB_population_overlap(p,j,y-1)));
                     total_recruits(j,y-1)=((SSB_population_overlap(p,j,y-1))/(alpha(j)+beta(j)*SSB_population_overlap(p,j,y-1)))*rec_devs(j,y-1);
                     recruits_BM(j,r,y)=((SSB_population_overlap(p,j,y-1))/(alpha(j)+beta(j)*SSB_population_overlap(p,j,y-1)))*rec_devs(j,y-1)*(SSB_region_overlap(p,j,r,y-1)/sum(SSB_region_overlap(p,j,y-1)));
                    }
                  }
                  
                if(Rec_type==3) //environmental recruitment
                  {
                   if(apportionment_type!=0) //use prespecified Rec_Prop to apportion recruitment among regionp within a population
                    {
                     SR(j,y-1)=env_rec(y);
                     total_recruits(j,y-1)=env_rec(y)*rec_devs(j,y-1);
                     recruits_BM(j,r,y)=env_rec(y)*rec_devs(j,y-1)*Rec_Prop(j,r,y-1);
                    }
                   if(apportionment_type==0)  //use relative SSB to apportion recruitment among regions within a population
                    {
                     SR(j,y-1)=env_rec(y);
                     total_recruits(j,y-1)=env_rec(y)*rec_devs(j,y-1);
                     recruits_BM(j,r,y)=env_rec(y)*rec_devs(j,y-1)*(SSB_region_overlap(p,j,r,y-1)/sum(SSB_region_overlap(p,j,y-1))); //assume with natal homing that fish aren't from a particular region so when apportion them use relative SSB in each region (but don't account for SSB that moves back to the region to spawn ie fish that move back add to population SSB but not region SSB)
                    }
                  }
                 }
                 }

             if(natal_homing_switch==0)
              {
                if(Rec_type==1) //average recruitment
                  {
                  if(apportionment_type!=0) //use prespecified Rec_Prop to apportion recruitment among regionp within a population
                    {
                    SR(j,y-1)=R_ave(j);
                    total_recruits(j,y-1)=R_ave(j)*rec_devs(j,y-1);
                    recruits_BM(j,r,y)=R_ave(j)*rec_devs(j,y-1)*Rec_Prop(j,r,y-1);
                    }
                    if(apportionment_type==0)  //use relative SSB to apportion recruitment among regionp within a population
                    {
                    SR(j,y-1)=R_ave(j);
                    total_recruits(j,y-1)=R_ave(j)*rec_devs(j,y-1);
                    recruits_BM(j,r,y)=R_ave(j)*rec_devs(j,y-1)*(SSB_region(j,r,y-1)/SSB_population(j,y-1));
                    }
                  }
                 if(Rec_type==2) //BH recruitment
                  {
                   if(apportionment_type!=0)  //use prespecified Rec_Prop to apportion recruitment among regionp within a population
                    {
                     SR(j,y-1)=((SSB_population(j,y-1))/(alpha(j)+beta(j)*SSB_population(j,y-1)));
                     total_recruits(j,y-1)=((SSB_population(j,y-1))/(alpha(j)+beta(j)*SSB_population(j,y-1)))*rec_devs(j,y-1);
                     recruits_BM(j,r,y)=((SSB_population(j,y-1))/(alpha(j)+beta(j)*SSB_population(j,y-1)))*rec_devs(j,y-1)*Rec_Prop(j,r,y-1);
                    }
                   if(apportionment_type==0) //use relative SSB to apportion recruitment among regionp within a population
                    {
                     SR(j,y-1)=((SSB_population(j,y-1))/(alpha(j)+beta(j)*SSB_population(j,y-1)));
                     total_recruits(j,y-1)=((SSB_population(j,y-1))/(alpha(j)+beta(j)*SSB_population(j,y-1)))*rec_devs(j,y-1);
                     recruits_BM(j,r,y)=((SSB_population(j,y-1))/(alpha(j)+beta(j)*SSB_population(j,y-1)))*rec_devs(j,y-1)*(SSB_region(j,r,y-1)/SSB_population(j,y-1));
                    }
                   }

                if(Rec_type==3) //average recruitment
                  {
                  if(apportionment_type!=0) //use prespecified Rec_Prop to apportion recruitment among regionp within a population
                    {
                     SR(j,y-1)=env_rec(y);
                     total_recruits(j,y-1)=env_rec(y)* rec_devs(j,y-1);
                     recruits_BM(j,r,y)=env_rec(y)* rec_devs(j,y-1)*Rec_Prop(j,r,y-1);
                    }
                   if(apportionment_type==0)  //use relative SSB to apportion recruitment among regionp within a population
                   {
                    SR(j,y-1)=env_rec(y);
                    total_recruits(j,y-1)=env_rec(y)* rec_devs(j,y-1);
                    recruits_BM(j,r,y)=env_rec(y)* R_ave(j)*rec_devs(j,y-1)*(SSB_region(j,r,y-1)/SSB_population(j,y-1));
                   }
                 }
                 }
               rec_index_BM(j,r,y)=recruits_BM(j,r,y);
               rec_index_BM_temp(j,y,r)=rec_index_BM(j,r,y);
               rec_index_prop_BM(j,r,y)=rec_index_BM(j,r,y)/sum(rec_index_BM_temp(j,y));

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////a==1 overlap calcs///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                 if(p==j)
                 {
                   abundance_at_age_BM_overlap_region(p,j,y,a,r)=recruits_BM(j,r,y);
                 }
                 if(p!=j)
                 {
                   abundance_at_age_BM_overlap_region(p,j,y,a,r)=0;
                 }
                abundance_at_age_BM_overlap_population(p,j,y,a)=sum(abundance_at_age_BM_overlap_region(p,j,y,a));

                biomass_BM_age_overlap(p,j,r,y,a)=weight_population(p,r,y,a)*abundance_at_age_BM_overlap_region(p,j,y,a,r);
                biomass_BM_overlap_region(p,j,r,y)=sum(biomass_BM_age_overlap(p,j,r,y));
                
//////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////// metapop calcs /////////////////////////////////////////////////////////////////////////

                 abundance_at_age_BM(j,r,y,a)=recruits_BM(j,r,y);

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

                  if(natal_homing_switch==0)
                   {
                    biomass_BM_age(j,r,y,a)=weight_population(j,r,y,a)*abundance_at_age_BM(j,r,y,a);
                    biomass_BM(j,r,y)=sum(biomass_BM_age(j,r,y));
                   }
                  if(natal_homing_switch>0) //if natal homing put abundance summed across natal population by region into abundance at age AM
                   {
                  if(natal_homing_switch>0) //if natal homing put abundance summed across natal population by region into abundance at age AM
                   {
                    biomass_BM_overlap_temp(j,r,y,a,p)=biomass_BM_age_overlap(p,j,r,y,a);
                    biomass_BM_age(j,r,y,a)=sum(biomass_BM_overlap_temp(j,r,y,a));
                    biomass_BM(j,r,y)=sum(biomass_BM_age(j,r,y));
                   }
                   }
              }
             }
            }
           }
          } //close loops so have full biomass vectors filled in at start of DD movement calcs
        if(a==1)
         {
           for (int p=1;p<=npops;p++)
            {
             for (int j=1;j<=npops;j++)
              {
               for (int r=1;r<=nregions(j);r++)
                {
                 for (int z=1;z<=nfleets(j);z++)
                  {
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

                abundance_move_overlap_temp=0;
               
                for (int k=1;k<=npops;k++)
                 {
                  for (int n=1;n<=nregions(k);n++)
                   {

                 if(natal_homing_switch>0)
                 {
                 if(p==k)
                 {
                 if(Rec_type==1) //average recruitment
                  {
                   if(apportionment_type!=0) //use prespecified Rec_Prop to apportion recruitment among regionp within a population
                    {
                      abundance_move_overlap_temp(k,n)=R_ave(k)*rec_devs(k,y-1)*Rec_Prop(k,n,y-1)*T(p,n,y,a,j,r);
                    }
                   if(apportionment_type==0)  //use relative SSB to apportion recruitment among regionp within a population
                    {
                      abundance_move_overlap_temp(k,n)=R_ave(k)*rec_devs(k,y-1)*(SSB_region_overlap(p,k,n,y-1)/sum(SSB_region_overlap(p,k,y-1)))*T(p,n,y,a,j,r); //assume with natal homing that fish aren't from a particular region so when apportion them use relative SSB in each region (but don't account for SSB that moves back to the region to spawn ie fish that move back add to population SSB but not region SSB)
                    }
                  }

                 if(Rec_type==2) //BH recruitment
                  {
                   if(apportionment_type!=0)  //use prespecified Rec_Prop to apportion recruitment among regionp within a population
                    {
                      abundance_move_overlap_temp(k,n)=((SSB_population_overlap(p,k,y-1))/(alpha(k)+beta(k)*SSB_population_overlap(p,k,y-1)))*rec_devs(k,y-1)*Rec_Prop(k,n,y-1)*T(p,n,y,a,j,r);
                    }
                   if(apportionment_type==0) //use relative SSB to apportion recruitment among regionp within a population
                    {
                      abundance_move_overlap_temp(k,n)=((SSB_population_overlap(p,k,y-1))/(alpha(k)+beta(k)*SSB_population_overlap(p,k,y-1)))*rec_devs(k,y-1)*(SSB_region_overlap(p,k,n,y-1)/sum(SSB_region_overlap(p,k,y-1)))*T(p,n,y,a,j,r);
                    }
                  }

                if(Rec_type==3) //average recruitment
                  {
                   if(apportionment_type!=0) //use prespecified Rec_Prop to apportion recruitment among regionp within a population
                    {
                      abundance_move_overlap_temp(k,n)=env_rec(y)*rec_devs(k,y-1)*Rec_Prop(k,n,y-1)*T(p,n,y,a,j,r);
                    }
                   if(apportionment_type==0)  //use relative SSB to apportion recruitment among regionp within a population
                    {
                      abundance_move_overlap_temp(k,n)=env_rec(y)*rec_devs(k,y-1)*(SSB_region_overlap(p,k,n,y-1)/sum(SSB_region_overlap(p,k,y-1)))*T(p,n,y,a,j,r); //assume with natal homing that fish aren't from a particular region so when apportion them use relative SSB in each region (but don't account for SSB that moves back to the region to spawn ie fish that move back add to population SSB but not region SSB)
                    }
                  }
                 }
                 }
                 
             if(natal_homing_switch==0)
              {
                 if(Rec_type==1) //average recruitment
                  {
                   if(apportionment_type!=0) //use prespecified Rec_Prop to apportion recruitment among regionp within a population
                    {
                    abundance_move_overlap_temp(k,n)=R_ave(k)*rec_devs(k,y-1)*Rec_Prop(k,n,y-1)*T(k,n,y,a,j,r);
                    }
                   if(apportionment_type==0)  //use relative SSB to apportion recruitment among regionp within a population
                    {
                    abundance_move_overlap_temp(k,n)=R_ave(k)*rec_devs(k,y-1)*(SSB_region(k,n,y-1)/SSB_population(k,y-1))*T(k,n,y,a,j,r);
                    }
                    }
                 if(Rec_type==2) //BH recruitment
                  {
                 if(apportionment_type!=0)  //use prespecified Rec_Prop to apportion recruitment among regionp within a population
                    {
                    abundance_move_overlap_temp(k,n)=((SSB_population(k,y-1))/(alpha(k)+beta(k)*SSB_population(k,y-1)))*rec_devs(k,y-1)*Rec_Prop(k,n,y-1)*T(k,n,y,a,j,r);
                    }
                   if(apportionment_type==0) //use relative SSB to apportion recruitment among regionp within a population
                    {
                     abundance_move_overlap_temp(k,n)=((SSB_population(k,y-1))/(alpha(k)+beta(k)*SSB_population(k,y-1)))*rec_devs(k,y-1)*(SSB_region(k,n,y-1)/SSB_population(k,y-1))*T(k,n,y,a,j,r);
                    }
                  }

                if(Rec_type==3) //environmental recruitment
                  {
                   if(apportionment_type!=0) //use prespecified Rec_Prop to apportion recruitment among regionp within a population
                    {
                     abundance_move_overlap_temp(k,n)=env_rec(y)*rec_devs(k,y-1)*Rec_Prop(k,n,y-1)*T(k,n,y,a,j,r);
                    }
                   if(apportionment_type==0)  //use relative SSB to apportion recruitment among regionp within a population
                    {
                     abundance_move_overlap_temp(k,n)=env_rec(y)*rec_devs(k,y-1)*(SSB_region(k,n,y-1)/SSB_population(k,y-1))*T(k,n,y,a,j,r);
                    }
                  }

                }
                   }
                  }

                abundance_at_age_AM_overlap_region(p,j,y,a,r)=sum(abundance_move_overlap_temp);
                abundance_AM_overlap_region_all_natal_temp(j,r,y,a,p)=abundance_at_age_AM_overlap_region(p,j,y,a,r);
                biomass_AM_overlap_region_all_natal_temp(j,r,y,a,p)=abundance_at_age_AM_overlap_region(p,j,y,a,r)*weight_population(p,r,y,a);
                abundance_AM_overlap_region_all_natal(j,r,y,a)=sum(abundance_AM_overlap_region_all_natal_temp(j,r,y,a));
                biomass_AM_overlap_age_region_all_natal(j,r,y,a)=sum(biomass_AM_overlap_region_all_natal_temp(j,r,y,a));
                biomass_AM_overlap_region_all_natal(j,r,y)=sum(biomass_AM_overlap_age_region_all_natal(j,r,y));
                abundance_at_age_AM_overlap_population(p,j,y,a)=sum(abundance_at_age_AM_overlap_region(p,j,y,a));
                biomass_AM_age_overlap(p,j,r,y,a)=weight_population(p,r,y,a)*abundance_at_age_AM_overlap_region(p,j,y,a,r);
                biomass_AM_overlap_region(p,j,r,y)=sum(biomass_AM_age_overlap(p,j,r,y));
                biomass_population_temp_overlap(p,j,y,r)=biomass_AM_overlap_region(p,j,r,y);
                biomass_population_overlap(p,j,y)=sum(biomass_population_temp_overlap(p,j,y));
                biomass_natal_temp_overlap(p,y,j)=biomass_population_overlap(p,j,y);
                biomass_natal_overlap(p,y)=sum(biomass_natal_temp_overlap(p,y));
              
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////y>1, A==1 METAPOP TYPE CALCS (MOVEMENT)//////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  

                    abundance_move_temp=0;
                    bio_move_temp=0;

        for (int k=1;k<=npops;k++)
           {
            for (int n=1;n<=nregions(k);n++)
             {
             if(natal_homing_switch==0)
              {
                 if(Rec_type==1) //average recruitment
                  {
                   if(apportionment_type!=0) //use prespecified Rec_Prop to apportion recruitment among regionp within a population
                    {
                     abundance_move_temp(k,n)=R_ave(k)*rec_devs(k,y-1)*Rec_Prop(k,n,y-1)*T(k,n,y,a,j,r);
                     }
                   if(apportionment_type==0)  //use relative SSB to apportion recruitment among regionp within a population
                    {
                    abundance_move_temp(k,n)=R_ave(k)*rec_devs(k,y-1)*(SSB_region(k,n,y-1)/SSB_population(k,y-1))*T(k,n,y,a,j,r);
                    }
                  }
                 if(Rec_type==2) //BH recruitment
                  {
                   if(apportionment_type!=0)  //use prespecified Rec_Prop to apportion recruitment among regionp within a population
                    {
                    abundance_move_temp(k,n)=((SSB_population(k,y-1))/(alpha(k)+beta(k)*SSB_population(k,y-1)))*rec_devs(k,y-1)*Rec_Prop(k,n,y-1)*T(k,n,y,a,j,r);
                    }
                   if(apportionment_type==0) //use relative SSB to apportion recruitment among regionp within a population
                    {
                     abundance_move_temp(k,n)=((SSB_population(k,y-1))/(alpha(k)+beta(k)*SSB_population(k,y-1)))*rec_devs(k,y-1)*(SSB_region(k,n,y-1)/SSB_population(k,y-1))*T(k,n,y,a,j,r);
                    }
                  }
                if(Rec_type==3) //env recruitment
                  {
                  if(apportionment_type!=0) //use prespecified Rec_Prop to apportion recruitment among regionp within a population
                    {
                     abundance_move_temp(k,n)=env_rec(y)*rec_devs(k,y-1)*Rec_Prop(k,n,y-1)*T(k,n,y,a,j,r);
                    }
                   if(apportionment_type==0)  //use relative SSB to apportion recruitment among regionp within a population
                    {
                     abundance_move_temp(k,n)=env_rec(y)*rec_devs(k,y-1)*(SSB_region(k,n,y-1)/SSB_population(k,y-1))*T(k,n,y,a,j,r);
                    }
                  }
                }
                     bio_move_temp(k,n)=abundance_move_temp(k,n)*weight_population(k,n,y,a);
              }
             }
                  
                  if(natal_homing_switch>0)
                   {                  
                    abundance_at_age_AM(j,r,y,a)=abundance_AM_overlap_region_all_natal(j,r,y,a);
                    biomass_AM(j,r,y)=biomass_AM_overlap_region_all_natal(j,r,y);                   
                   }
                  if(natal_homing_switch==0)
                   {
                    abundance_at_age_AM(j,r,y,a)=sum(abundance_move_temp);
                    biomass_AM_age(j,r,y,a)=weight_population(j,r,y,a)*abundance_at_age_AM(j,r,y,a);
                    biomass_AM(j,r,y)=sum(biomass_AM_age(j,r,y));
                   }

               recruits_AM(j,r,y)=abundance_at_age_AM(j,r,y,a);
               rec_index_AM(j,r,y)=recruits_AM(j,r,y);
               rec_index_AM_temp(j,y,r)=rec_index_AM(j,r,y);
               rec_index_prop_AM(j,r,y)=rec_index_AM(j,r,y)/sum(rec_index_AM_temp(j,y));

                biomass_population_temp(j,y,r)=biomass_AM(j,r,y);
                biomass_population(j,y)=sum(biomass_population_temp(j,y));
                biomass_total_temp(y,j)=biomass_population(j,y);
                biomass_total(y)=sum(biomass_total_temp(y));

               abundance_in(j,r,y,a)=sum(abundance_move_temp)-abundance_move_temp(j,r);
               abundance_res(j,r,y,a)=abundance_move_temp(j,r);
               abundance_leave(j,r,y,a)=abundance_at_age_BM(j,r,y,a)-abundance_res(j,r,y,a);
               bio_in(j,r,y,a)=sum(bio_move_temp)-bio_move_temp(j,r);
               bio_res(j,r,y,a)=bio_move_temp(j,r);
               bio_leave(j,r,y,a)=abundance_at_age_BM(j,r,y,a)*weight_population(j,r,y,a)-bio_res(j,r,y,a);
           }
          }
         }
        }
       } //end a==1 if statement

 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       if(a==2) //account for partial year mortality during spawning year
        {
           for (int p=1;p<=npops;p++)
            {
             for (int j=1;j<=npops;j++)
              {
               for (int r=1;r<=nregions(j);r++)
                {
                 for (int z=1;z<=nfleets(j);z++)
                  {
                  abundance_at_age_BM_overlap_region(p,j,y,a,r)=abundance_at_age_AM_overlap_region(p,j,y-1,a-1,r)*mfexp(-(M(j,r,y-1,a-1)+F(j,r,y-1,a-1))*(1-tspawn(p))); // took out regional M
                  abundance_at_age_BM_overlap_population(p,j,y,a)=sum(abundance_at_age_BM_overlap_region(p,j,y,a));
                  biomass_BM_age_overlap(p,j,r,y,a)=weight_population(p,r,y,a)*abundance_at_age_BM_overlap_region(p,j,y,a,r);
                  biomass_BM_overlap_region(p,j,r,y)=sum(biomass_BM_age_overlap(p,j,r,y));

/////////////////////////metapop/////////////////////////////////////////////////////////
            abundance_at_age_BM(j,r,y,a)=abundance_at_age_AM(j,r,y-1,a-1)*mfexp(-(M(j,r,y-1,a-1)+F(j,r,y-1,a-1))*(1-tspawn(j))); //account for time of spawning (i.e., if born midway only experience a half year of mortality from age-1 to age-2)
/////////////////////////////////////////////////////////////////////////////////////////

                  if(natal_homing_switch==0)
                   {
                    biomass_BM_age(j,r,y,a)=weight_population(j,r,y,a)*abundance_at_age_BM(j,r,y,a);
                    biomass_BM(j,r,y)=sum(biomass_BM_age(j,r,y));
                   }
                  if(natal_homing_switch>0) //if natal homing put abundance summed across natal population by region into abundance at age AM
                   {
                    biomass_BM_overlap_temp(j,r,y,a,p)=biomass_BM_age_overlap(p,j,r,y,a);
                    biomass_BM_age(j,r,y,a)=sum(biomass_BM_overlap_temp(j,r,y,a));
                    biomass_BM(j,r,y)=sum(biomass_BM_age(j,r,y));
                   }
              }
             }
            }
           }
          } //close loops so have full biomass vectors filled in at start of DD movement calcs
          
         if(a==2)
          { 
           for (int p=1;p<=npops;p++)
            {
             for (int j=1;j<=npops;j++)
              {
               for (int r=1;r<=nregions(j);r++)
                {
                 for (int z=1;z<=nfleets(j);z++)
                  {

                abundance_move_overlap_temp=0;

                for (int k=1;k<=npops;k++)
                 {
                  for (int n=1;n<=nregions(k);n++)
                   {
                    if(move_switch!=6  || move_switch!=7  ||a==1)
                     {
                      abundance_move_overlap_temp(k,n)=abundance_at_age_AM_overlap_region(p,k,y-1,a-1,n)*mfexp(-(M(k,r,y-1,a-1)+F(k,n,y-1,a-1))*(1-tspawn(p)))*T(p,n,y,a,j,r); //with overlap always use natal population movement rates
                     }
                    if(move_switch==6 && a>1)
                     {
                      if(a==return_age && p==j && p==k && j==k)
                      {
                       abundance_move_overlap_temp(k,n)=0; //with overlap always use natal population movement rates
                      }
                      if(a==return_age && p==j && j!=k)
                      {
                       abundance_move_overlap_temp(k,n)=abundance_at_age_AM_overlap_region(p,k,y-1,a-1,n)*mfexp(-(M(k,r,y-1,a-1)+F(k,n,y-1,a-1))*(1-tspawn(p)))*return_probability(p); //with overlap always use natal population movement rates
                      }
                     }
                   }
                  }
                    if(move_switch!=6 || move_switch!=7  || a==1)
                     {
                        abundance_at_age_AM_overlap_region(p,j,y,a,r)=sum(abundance_move_overlap_temp);
                     }
                    if(move_switch==7)  //all fish stay where they were (i.e., no return migration)
                     {
                        abundance_at_age_AM_overlap_region(p,j,y,a,r)=abundance_at_age_AM_overlap_region(p,j,y-1,a-1,r)*mfexp(-(M(j,r,y-1,a-1)+F(j,r,y-1,a-1))*(1-tspawn(p)));
                     }
                    if(move_switch==6 && a>1)
                     {
                      if(a<return_age || a>return_age)
                       {
                        abundance_at_age_AM_overlap_region(p,j,y,a,r)=abundance_at_age_AM_overlap_region(p,j,y-1,a-1,r)*mfexp(-(M(j,r,y-1,a-1)+F(j,r,y-1,a-1))*(1-tspawn(p))); //with overlap always use natal population movement rates                     
                       }
                      if(a==return_age && p==j)
                       {
                        abundance_at_age_AM_overlap_region(p,j,y,a,r)=abundance_at_age_AM_overlap_region(p,j,y-1,a-1,r)*mfexp(-(M(j,r,y-1,a-1)+F(j,r,y-1,a-1))*(1-tspawn(p)))+(sum(abundance_move_overlap_temp)/nregions(p));
                       }
                      if(a==return_age && p!=j)
                       {
                        abundance_at_age_AM_overlap_region(p,j,y,a,r)=(1-return_probability(p))*abundance_at_age_AM_overlap_region(p,j,y-1,a-1,r)*mfexp(-(M(j,r,y-1,a-1)+F(j,r,y-1,a-1))*(1-tspawn(p)));
                       }
                      }
                abundance_AM_overlap_region_all_natal_temp(j,r,y,a,p)=abundance_at_age_AM_overlap_region(p,j,y,a,r);
                biomass_AM_overlap_region_all_natal_temp(j,r,y,a,p)=abundance_at_age_AM_overlap_region(p,j,y,a,r)*weight_population(p,r,y,a);
                abundance_AM_overlap_region_all_natal(j,r,y,a)=sum(abundance_AM_overlap_region_all_natal_temp(j,r,y,a));
                biomass_AM_overlap_age_region_all_natal(j,r,y,a)=sum(biomass_AM_overlap_region_all_natal_temp(j,r,y,a));
                biomass_AM_overlap_region_all_natal(j,r,y)=sum(biomass_AM_overlap_age_region_all_natal(j,r,y));
                abundance_at_age_AM_overlap_population(p,j,y,a)=sum(abundance_at_age_AM_overlap_region(p,j,y,a));
                biomass_AM_age_overlap(p,j,r,y,a)=weight_population(p,r,y,a)*abundance_at_age_AM_overlap_region(p,j,y,a,r);
                biomass_AM_overlap_region(p,j,r,y)=sum(biomass_AM_age_overlap(p,j,r,y));
                biomass_population_temp_overlap(p,j,y,r)=biomass_AM_overlap_region(p,j,r,y);
                biomass_population_overlap(p,j,y)=sum(biomass_population_temp_overlap(p,j,y));
                biomass_natal_temp_overlap(p,y,j)=biomass_population_overlap(p,j,y);
                biomass_natal_overlap(p,y)=sum(biomass_natal_temp_overlap(p,y));

 //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
   ///////////////NON-NATAL Homing movement calcs and putting natal homing abundance into area abundance///////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    

                    abundance_move_temp=0;
                     bio_move_temp=0;

                for (int k=1;k<=npops;k++)
                 {
                  for (int n=1;n<=nregions(k);n++)
                   {
                     abundance_move_temp(k,n)=abundance_at_age_AM(k,n,y-1,a-1)*mfexp(-(M(k,n,y-1,a-1)+F(k,n,y-1,a-1))*(1-tspawn(k)))*T(k,n,y,a,j,r);
                     bio_move_temp(k,n)=abundance_move_temp(k,n)*weight_population(k,n,y,a);
                   }
                  }

                  if(natal_homing_switch>0)
                   {                  
                    abundance_at_age_AM(j,r,y,a)=abundance_AM_overlap_region_all_natal(j,r,y,a);
                    biomass_AM(j,r,y)= biomass_AM_overlap_region_all_natal(j,r,y);                  
                   }
                  if(natal_homing_switch==0)
                   {
                    abundance_at_age_AM(j,r,y,a)=sum(abundance_move_temp);
                    biomass_AM_age(j,r,y,a)=weight_population(j,r,y,a)*abundance_at_age_AM(j,r,y,a);
                    biomass_AM(j,r,y)=sum(biomass_AM_age(j,r,y));
                   }

                biomass_population_temp(j,y,r)=biomass_AM(j,r,y);
                biomass_population(j,y)=sum(biomass_population_temp(j,y));
                biomass_total_temp(y,j)=biomass_population(j,y);
                biomass_total(y)=sum(biomass_total_temp(y));

                   abundance_in(j,r,y,a)=sum(abundance_move_temp)-abundance_move_temp(j,r);
                   abundance_res(j,r,y,a)=abundance_move_temp(j,r);
                   abundance_leave(j,r,y,a)=abundance_at_age_BM(j,r,y,a)-abundance_res(j,r,y,a);
                   bio_in(j,r,y,a)=sum(bio_move_temp)-bio_move_temp(j,r);
                   bio_res(j,r,y,a)=bio_move_temp(j,r);
                   bio_leave(j,r,y,a)=abundance_at_age_BM(j,r,y,a)*weight_population(j,r,y,a)-bio_res(j,r,y,a);
             }
            }
           }
          }
         }//end a==2 if statement

 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       if(a>2 && a<nages)
        {
           for (int p=1;p<=npops;p++)
            {
             for (int j=1;j<=npops;j++)
              {
               for (int r=1;r<=nregions(j);r++)
                {
                 for (int z=1;z<=nfleets(j);z++)
                  {
                  abundance_at_age_BM_overlap_region(p,j,y,a,r)=abundance_at_age_AM_overlap_region(p,j,y-1,a-1,r)*mfexp(-(M(j,r,y-1,a-1)+F(j,r,y-1,a-1)));
                  abundance_at_age_BM_overlap_population(p,j,y,a)=sum(abundance_at_age_BM_overlap_region(p,j,y,a));
                  biomass_BM_age_overlap(p,j,r,y,a)=weight_population(p,r,y,a)*abundance_at_age_BM_overlap_region(p,j,y,a,r);
                  biomass_BM_overlap_region(p,j,r,y)=sum(biomass_BM_age_overlap(p,j,r,y));

/////////////////////////metapop/////////////////////////////////////////////////////////
                 abundance_at_age_BM(j,r,y,a)=abundance_at_age_AM(j,r,y-1,a-1)*mfexp(-(M(j,r,y-1,a-1)+F(j,r,y-1,a-1)));
/////////////////////////////////////////////////////////////////////////////////////////

                  if(natal_homing_switch==0)
                   {
                    biomass_BM_age(j,r,y,a)=weight_population(j,r,y,a)*abundance_at_age_BM(j,r,y,a);
                    biomass_BM(j,r,y)=sum(biomass_BM_age(j,r,y));
                   }
                  if(natal_homing_switch>0) //if natal homing put abundance summed across natal population by region into abundance at age AM
                   {
                    biomass_BM_overlap_temp(j,r,y,a,p)=biomass_BM_age_overlap(p,j,r,y,a);
                    biomass_BM_age(j,r,y,a)=sum(biomass_BM_overlap_temp(j,r,y,a));
                    biomass_BM(j,r,y)=sum(biomass_BM_age(j,r,y));
                   }
              }
             }
            }
           }
          } //close loops so have full biomass vectors filled in at start of DD movement calcs


       if(a>2 && a<nages)
        {
           for (int p=1;p<=npops;p++)
            {
             for (int j=1;j<=npops;j++)
              {
               for (int r=1;r<=nregions(j);r++)
                {
                 for (int z=1;z<=nfleets(j);z++)
                  {

                 abundance_move_overlap_temp=0;

                for (int k=1;k<=npops;k++)
                 {
                  for (int n=1;n<=nregions(k);n++)
                   {
                    if(move_switch!=6  || move_switch!=7 || a==1)
                     {
                      abundance_move_overlap_temp(k,n)=abundance_at_age_AM_overlap_region(p,k,y-1,a-1,n)*mfexp(-(M(k,n,y-1,a-1)+F(k,n,y-1,a-1)))*T(p,n,y,a,j,r); //with overlap always use natal population movement rates
                     }
                    if(move_switch==6 && a>1)
                     {
                      if(a==return_age && p==j && p==k && j==k)
                      {
                       abundance_move_overlap_temp(k,n)=0; //with overlap always use natal population movement rates
                      }
                      if(a==return_age && p==j && j!=k)
                      {
                       abundance_move_overlap_temp(k,n)=abundance_at_age_AM_overlap_region(p,k,y-1,a-1,n)*mfexp(-(M(k,n,y-1,a-1)+F(k,n,y-1,a-1)))*return_probability(p); //with overlap always use natal population movement rates
                      }
                     }
                   }
                  }
                    if(move_switch!=6 || move_switch!=7  || a==1)
                     {
                        abundance_at_age_AM_overlap_region(p,j,y,a,r)=sum(abundance_move_overlap_temp);
                     }
                    if(move_switch==7)  //all fish stay where they were (i.e., no return migration)
                     {
                        abundance_at_age_AM_overlap_region(p,j,y,a,r)=abundance_at_age_AM_overlap_region(p,j,y-1,a-1,r)*mfexp(-(M(j,r,y-1,a-1)+F(j,r,y-1,a-1)));
                     }
                    if(move_switch==6 && a>1)
                     {
                      if(a<return_age || a>return_age)
                       {
                        abundance_at_age_AM_overlap_region(p,j,y,a,r)=abundance_at_age_AM_overlap_region(p,j,y-1,a-1,r)*mfexp(-(M(j,r,y-1,a-1)+F(j,r,y-1,a-1))); //with overlap always use natal population movement rates                     
                       }
                      if(a==return_age && p==j)
                       {
                        abundance_at_age_AM_overlap_region(p,j,y,a,r)=abundance_at_age_AM_overlap_region(p,j,y-1,a-1,r)*mfexp(-(M(j,r,y-1,a-1)+F(j,r,y-1,a-1)))+(sum(abundance_move_overlap_temp)/nregions(p));
                       }
                      if(a==return_age && p!=j)
                       {
                        abundance_at_age_AM_overlap_region(p,j,y,a,r)=(1-return_probability(p))*abundance_at_age_AM_overlap_region(p,j,y-1,a-1,r)*mfexp(-(M(j,r,y-1,a-1)+F(j,r,y-1,a-1)));
                       }
                      }
                abundance_AM_overlap_region_all_natal_temp(j,r,y,a,p)=abundance_at_age_AM_overlap_region(p,j,y,a,r);
                biomass_AM_overlap_region_all_natal_temp(j,r,y,a,p)=abundance_at_age_AM_overlap_region(p,j,y,a,r)*weight_population(p,r,y,a);
                abundance_AM_overlap_region_all_natal(j,r,y,a)=sum(abundance_AM_overlap_region_all_natal_temp(j,r,y,a));
                biomass_AM_overlap_age_region_all_natal(j,r,y,a)=sum(biomass_AM_overlap_region_all_natal_temp(j,r,y,a));
                biomass_AM_overlap_region_all_natal(j,r,y)=sum(biomass_AM_overlap_age_region_all_natal(j,r,y));
                abundance_at_age_AM_overlap_population(p,j,y,a)=sum(abundance_at_age_AM_overlap_region(p,j,y,a));
                biomass_AM_age_overlap(p,j,r,y,a)=weight_population(p,r,y,a)*abundance_at_age_AM_overlap_region(p,j,y,a,r);
                biomass_AM_overlap_region(p,j,r,y)=sum(biomass_AM_age_overlap(p,j,r,y));
                biomass_population_temp_overlap(p,j,y,r)=biomass_AM_overlap_region(p,j,r,y);
                biomass_population_overlap(p,j,y)=sum(biomass_population_temp_overlap(p,j,y));
                biomass_natal_temp_overlap(p,y,j)=biomass_population_overlap(p,j,y);
                biomass_natal_overlap(p,y)=sum(biomass_natal_temp_overlap(p,y));


 //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
   ///////////////NON-NATAL Homing movement calcs and putting natal homing abundance into area abundance///////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    

                   abundance_move_temp=0;
                   bio_move_temp=0;

                for (int k=1;k<=npops;k++)
                 {
                  for (int n=1;n<=nregions(k);n++)
                   {
                     abundance_move_temp(k,n)=abundance_at_age_AM(k,n,y-1,a-1)*mfexp(-(M(k,n,y-1,a-1)+F(k,n,y-1,a-1)))*T(k,n,y,a,j,r);
                     bio_move_temp(k,n)=abundance_move_temp(k,n)*weight_population(k,n,y,a);
                   }
                  }
                  
                  if(natal_homing_switch>0)
                   {
                    abundance_at_age_AM(j,r,y,a)=abundance_AM_overlap_region_all_natal(j,r,y,a);
                    biomass_AM(j,r,y)= biomass_AM_overlap_region_all_natal(j,r,y);
                   }
                  if(natal_homing_switch==0)
                   {
                    abundance_at_age_AM(j,r,y,a)=sum(abundance_move_temp);
                    biomass_AM_age(j,r,y,a)=weight_population(j,r,y,a)*abundance_at_age_AM(j,r,y,a);
                    biomass_AM(j,r,y)=sum(biomass_AM_age(j,r,y));
                   }

                biomass_population_temp(j,y,r)=biomass_AM(j,r,y);
                biomass_population(j,y)=sum(biomass_population_temp(j,y));
                biomass_total_temp(y,j)=biomass_population(j,y);
                biomass_total(y)=sum(biomass_total_temp(y));

                abundance_in(j,r,y,a)=sum(abundance_move_temp)-abundance_move_temp(j,r);
                abundance_res(j,r,y,a)=abundance_move_temp(j,r);
                abundance_leave(j,r,y,a)=abundance_at_age_BM(j,r,y,a)-abundance_res(j,r,y,a);
                bio_in(j,r,y,a)=sum(bio_move_temp)-bio_move_temp(j,r);
                bio_res(j,r,y,a)=bio_move_temp(j,r);
                bio_leave(j,r,y,a)=abundance_at_age_BM(j,r,y,a)*weight_population(j,r,y,a)-bio_res(j,r,y,a);
           }
          }
         }
        }
       }//end a>2 <nages if statement

 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   if(a==nages) //account for fish already in plus group
        {
          for (int p=1;p<=npops;p++)
            {
             for (int j=1;j<=npops;j++)
              {
               for (int r=1;r<=nregions(j);r++)
                {
                 for (int z=1;z<=nfleets(j);z++)
                  {
                  abundance_at_age_BM_overlap_region(p,j,y,a,r)=abundance_at_age_AM_overlap_region(p,j,y-1,a-1,r)*mfexp(-(M(j,r,y-1,a-1)+F(j,r,y-1,a-1)))+abundance_at_age_AM_overlap_region(p,j,y-1,a,r)*mfexp(-(M(j,r,y-1,a)+F(j,r,y-1,a)));
                  abundance_at_age_BM_overlap_population(p,j,y,a)=sum(abundance_at_age_BM_overlap_region(p,j,y,a));
                  biomass_BM_age_overlap(p,j,r,y,a)=weight_population(p,r,y,a)*abundance_at_age_BM_overlap_region(p,j,y,a,r);
                  biomass_BM_overlap_region(p,j,r,y)=sum(biomass_BM_age_overlap(p,j,r,y));
                
/////////////////////////metapop/////////////////////////////////////////////////////////
               abundance_at_age_BM(j,r,y,a)=abundance_at_age_AM(j,r,y-1,a-1)*mfexp(-(M(j,r,y-1,a-1)+F(j,r,y-1,a-1)))+abundance_at_age_AM(j,r,y-1,a)*mfexp(-(M(j,r,y-1,a)+F(j,r,y-1,a)));
/////////////////////////////////////////////////////////////////////////////////////////

                  if(natal_homing_switch==0)
                   {
                    biomass_BM_age(j,r,y,a)=weight_population(j,r,y,a)*abundance_at_age_BM(j,r,y,a);
                    biomass_BM(j,r,y)=sum(biomass_BM_age(j,r,y));
                   }
                  if(natal_homing_switch>0) //if natal homing put abundance summed across natal population by region into abundance at age AM
                   {
                    biomass_BM_overlap_temp(j,r,y,a,p)=biomass_BM_age_overlap(p,j,r,y,a);
                    biomass_BM_age(j,r,y,a)=sum(biomass_BM_overlap_temp(j,r,y,a));
                    biomass_BM(j,r,y)=sum(biomass_BM_age(j,r,y));
                   }
              }
             }
            }
           }
          } //close loops so have full biomass vectors filled in at start of DD movement calcs


       if(a==nages) //account for fish already in plus group
        {
           for (int p=1;p<=npops;p++)
            {
             for (int j=1;j<=npops;j++)
              {
               for (int r=1;r<=nregions(j);r++)
                {
                 for (int z=1;z<=nfleets(j);z++)
                  {

                   abundance_move_overlap_temp=0;

                for (int k=1;k<=npops;k++)
                 {
                  for (int n=1;n<=nregions(k);n++)
                   {
                    if(move_switch!=6  || move_switch!=7  || a==1)
                     {
                      abundance_move_overlap_temp(k,n)=abundance_at_age_AM_overlap_region(p,k,y-1,a-1,n)*mfexp(-(M(k,n,y-1,a-1)+F(k,n,y-1,a-1)))*T(p,n,y,a,j,r)+abundance_at_age_AM_overlap_region(p,k,y-1,a,n)*mfexp(-(M(k,n,y-1,a)+F(k,n,y-1,a)))*T(p,n,y,a,j,r); //with overlap always use natal population movement rates
                     }
                    if(move_switch==6 && a>1)
                     {
                      if(a==return_age && p==j && p==k && j==k)
                      {
                       abundance_move_overlap_temp(k,n)=0; //with overlap always use natal population movement rates
                      }
                      if(a==return_age && p==j && j!=k)
                      {
                       abundance_move_overlap_temp(k,n)=abundance_at_age_AM_overlap_region(p,k,y-1,a-1,n)*mfexp(-(M(k,n,y-1,a-1)+F(k,n,y-1,a-1)))*return_probability(p)+abundance_at_age_AM_overlap_region(p,k,y-1,a,n)*mfexp(-(M(k,n,y-1,a)+F(k,n,y-1,a)))*return_probability(p); //with overlap always use natal population movement rates
                      }
                     }
                   }
                  }
                    if(move_switch!=6 || move_switch!=7  || a==1)
                     {
                        abundance_at_age_AM_overlap_region(p,j,y,a,r)=sum(abundance_move_overlap_temp);
                     }
                    if(move_switch==7)  //all fish stay where they were (i.e., no return migration)
                     {
                        abundance_at_age_AM_overlap_region(p,j,y,a,r)=abundance_at_age_AM_overlap_region(p,j,y-1,a-1,r)*mfexp(-(M(j,r,y-1,a-1)+F(j,r,y-1,a-1)))+abundance_at_age_AM_overlap_region(p,j,y-1,a,r)*mfexp(-(M(j,r,y-1,a)+F(j,r,y-1,a)));
                     }
                    if(move_switch==6 && a>1)
                     {
                      if(a<return_age || a>return_age)
                       {
                        abundance_at_age_AM_overlap_region(p,j,y,a,r)=abundance_at_age_AM_overlap_region(p,j,y-1,a-1,r)*mfexp(-(M(j,r,y-1,a-1)+F(j,r,y-1,a-1)))+abundance_at_age_AM_overlap_region(p,j,y-1,a,r)*mfexp(-(M(j,r,y-1,a)+F(j,r,y-1,a))); //with overlap always use natal population movement rates                     
                       }
                      if(a==return_age && p==j)
                       {
                        abundance_at_age_AM_overlap_region(p,j,y,a,r)=abundance_at_age_AM_overlap_region(p,j,y-1,a-1,r)*mfexp(-(M(j,r,y-1,a-1)+F(j,r,y-1,a-1)))+abundance_at_age_AM_overlap_region(p,j,y-1,a,r)*mfexp(-(M(j,r,y-1,a)+F(j,r,y-1,a)))+(sum(abundance_move_overlap_temp)/nregions(p));
                       }
                      if(a==return_age && p!=j)
                       {
                        abundance_at_age_AM_overlap_region(p,j,y,a,r)=(1-return_probability(p))*abundance_at_age_AM_overlap_region(p,j,y-1,a-1,r)*mfexp(-(M(j,r,y-1,a-1)+F(j,r,y-1,a-1)))+(1-return_probability(p))*abundance_at_age_AM_overlap_region(p,j,y-1,a,r)*mfexp(-(M(j,r,y-1,a)+F(j,r,y-1,a)));
                       }
                      }
                abundance_AM_overlap_region_all_natal_temp(j,r,y,a,p)=abundance_at_age_AM_overlap_region(p,j,y,a,r);
                biomass_AM_overlap_region_all_natal_temp(j,r,y,a,p)=abundance_at_age_AM_overlap_region(p,j,y,a,r)*weight_population(p,r,y,a);
                abundance_AM_overlap_region_all_natal(j,r,y,a)=sum(abundance_AM_overlap_region_all_natal_temp(j,r,y,a));
                biomass_AM_overlap_age_region_all_natal(j,r,y,a)=sum(biomass_AM_overlap_region_all_natal_temp(j,r,y,a));
                biomass_AM_overlap_region_all_natal(j,r,y)=sum(biomass_AM_overlap_age_region_all_natal(j,r,y));
                abundance_at_age_AM_overlap_population(p,j,y,a)=sum(abundance_at_age_AM_overlap_region(p,j,y,a));
                biomass_AM_age_overlap(p,j,r,y,a)=weight_population(p,r,y,a)*abundance_at_age_AM_overlap_region(p,j,y,a,r);
                biomass_AM_overlap_region(p,j,r,y)=sum(biomass_AM_age_overlap(p,j,r,y));
                biomass_population_temp_overlap(p,j,y,r)=biomass_AM_overlap_region(p,j,r,y);
                biomass_population_overlap(p,j,y)=sum(biomass_population_temp_overlap(p,j,y));
                biomass_natal_temp_overlap(p,y,j)=biomass_population_overlap(p,j,y);
                biomass_natal_overlap(p,y)=sum(biomass_natal_temp_overlap(p,y));
 //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
   ///////////////NON-NATAL Homing movement calcs and putting natal homing abundance into area abundance///////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    
                   abundance_move_temp=0;
                   bio_move_temp=0;

                for (int k=1;k<=npops;k++)
                 {
                  for (int n=1;n<=nregions(k);n++)
                   {
                     abundance_move_temp(k,n)=abundance_at_age_AM(k,n,y-1,a-1)*mfexp(-(M(k,n,y-1,a-1)+F(k,n,y-1,a-1)))*T(k,n,y,a,j,r)+abundance_at_age_AM(k,n,y-1,a)*mfexp(-(M(k,n,y-1,a)+F(k,n,y-1,a)))*T(k,n,y,a,j,r);;
                     bio_move_temp(k,n)=abundance_move_temp(k,n)*weight_population(k,n,y,a);
                   }
                  }
                  if(natal_homing_switch>0)
                   {
                    abundance_at_age_AM(j,r,y,a)=abundance_AM_overlap_region_all_natal(j,r,y,a);
                    biomass_AM(j,r,y)= biomass_AM_overlap_region_all_natal(j,r,y);
                   }
                  if(natal_homing_switch==0)
                   {
                    abundance_at_age_AM(j,r,y,a)=sum(abundance_move_temp);
                    biomass_AM_age(j,r,y,a)=weight_population(j,r,y,a)*abundance_at_age_AM(j,r,y,a);
                    biomass_AM(j,r,y)=sum(biomass_AM_age(j,r,y));
                   }

                biomass_population_temp(j,y,r)=biomass_AM(j,r,y);
                biomass_population(j,y)=sum(biomass_population_temp(j,y));
                biomass_total_temp(y,j)=biomass_population(j,y);
                biomass_total(y)=sum(biomass_total_temp(y));

                   abundance_in(j,r,y,a)=sum(abundance_move_temp)-abundance_move_temp(j,r);
                   abundance_res(j,r,y,a)=abundance_move_temp(j,r);
                   abundance_leave(j,r,y,a)=abundance_at_age_BM(j,r,y,a)-abundance_res(j,r,y,a);
                   bio_in(j,r,y,a)=sum(bio_move_temp)-bio_move_temp(j,r);
                   bio_res(j,r,y,a)=bio_move_temp(j,r);
                   bio_leave(j,r,y,a)=abundance_at_age_BM(j,r,y,a)*weight_population(j,r,y,a)-bio_res(j,r,y,a);
            }
           }
          }
         }
        } //end nages if statement
        

           for (int p=1;p<=npops;p++)
            {
             for (int j=1;j<=npops;j++)
              {
               for (int r=1;r<=nregions(j);r++)
                {
                 for (int z=1;z<=nfleets_survey(j);z++)    /// survey index  1. Currently set up for more than 1 survey fleet
                  {
                   if(tsurvey(j,r)==0) //if survey at beggining of year, do calcs without temporal adjustment for mortality
                   {
                  survey_fleet_overlap_age(p,j,r,y,z,a)=survey_selectivity(j,r,y,a,z)*abundance_at_age_AM_overlap_region(p,j,y,a,r)*q_survey(j,r,z);
                  survey_fleet_overlap_age_bio(p,j,r,y,z,a)=survey_fleet_overlap_age(p,j,r,y,z,a)*weight_population(p,r,y,a);
                  survey_fleet_bio_overlap(p,j,r,y,z)=sum(survey_fleet_overlap_age_bio(p,j,r,y,z));  
                  survey_fleet_bio_overlap_temp(j,r,y,z,p)=survey_fleet_bio_overlap(p,j,r,y,z);

                if(natal_homing_switch==0)
                 {
                  survey_fleet_age(j,r,y,z,a)=survey_selectivity(j,r,y,a,z)*abundance_at_age_AM(j,r,y,a)*q_survey(j,r,z);
                  survey_fleet_age_bio(j,r,y,z,a)=survey_fleet_age(j,r,y,z,a)*weight_population(j,r,y,a);                  
                  survey_fleet_bio(j,r,y,z)=sum(survey_fleet_age_bio(j,r,y,z));
                 }
                if(natal_homing_switch==1)
                 {
                  survey_fleet_bio(j,r,y,z)=sum(survey_fleet_bio_overlap_temp(j,r,y,z));
                 }
             
                  survey_region_bio_overlap(p,j,y,r)=sum(survey_fleet_bio_overlap(p,j,r,y));               
                  survey_population_bio_overlap(p,y,j)=sum(survey_region_bio_overlap(p,j,y));               
                  survey_natal_bio_overlap(y,p)=sum(survey_population_bio_overlap(p,y));               
                  survey_total_bio_overlap(y)=sum(survey_natal_bio_overlap(y));
                  
                  survey_region_bio(j,y,r)=sum(survey_fleet_bio(j,r,y));
                  survey_population_bio(y,j)=sum(survey_region_bio(j,y));
                  survey_total_bio(y)=sum(survey_population_bio(y));

                } //tsurvey==0
               } //end survey_fleets 
      }
     }
    }
   } //end age loop

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   //a==1 natal homing
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       for (int a=1;a<=nages;a++)
         {
           for (int p=1;p<=npops;p++)
            {
             for (int j=1;j<=npops;j++)
              {
               for (int r=1;r<=nregions(j);r++)
                {
                 for (int z=1;z<=nfleets(j);z++)
                  {
          if(a==1)
            {

                abundance_spawn_overlap(p,j,r,y,a)=abundance_at_age_AM_overlap_region(p,j,y,a,r)*mfexp(-(M(j,r,y,a)+F(j,r,y,a))*tspawn(p));
                abundance_natal_temp_overlap(p,y,a,j)=abundance_at_age_AM_overlap_population(p,j,y,a);
                abundance_natal_overlap(p,y,a)=sum(abundance_natal_temp_overlap(p,y,a));
                catch_at_age_region_fleet_overlap(p,j,r,z,y,a)=abundance_at_age_AM_overlap_region(p,j,y,a,r)*(1.0-mfexp(-(F_fleet(j,r,y,a,z)+M(j,r,y,a))*(1-tspawn(p))))*(F_fleet(j,r,y,a,z)/(F_fleet(j,r,y,a,z)+M(j,r,y,a)));              
                catch_at_age_region_overlap(p,j,r,y,a)=abundance_at_age_AM_overlap_region(p,j,y,a,r)*(1.0-exp(-(F(j,r,y,a)+M(j,r,y,a))*(1-tspawn(j))))*(F(j,r,y,a)/(F(j,r,y,a)+M(j,r,y,a)));
                yield_region_fleet_temp_overlap(p,j,r,z,y,a)=weight_catch(p,r,y,a)*catch_at_age_region_fleet_overlap(p,j,r,z,y,a);
                yield_region_fleet_overlap(p,j,r,z,y)=sum(yield_region_fleet_temp_overlap(p,j,r,z,y));
                yield_region_temp_overlap(p,j,r,y,a)=weight_catch(p,r,y,a)*catch_at_age_region_overlap(p,j,r,y,a);
                yield_region_overlap(p,j,r,y)=sum(yield_region_temp_overlap(p,j,r,y));
                catch_at_age_population_temp_overlap(p,j,y,a,r)=catch_at_age_region_overlap(p,j,r,y,a);
                catch_at_age_population_overlap(p,j,y,a)=sum(catch_at_age_population_temp_overlap(p,j,y,a));
                yield_population_temp_overlap(p,j,y,a)=weight_catch(p,r,y,a)*catch_at_age_population_overlap(p,j,y,a);
                yield_population_overlap(p,j,y)=sum(yield_population_temp_overlap(p,j,y));
                catch_at_age_natal_temp_overlap(p,y,a,j)=catch_at_age_population_overlap(p,j,y,a);
                catch_at_age_natal_overlap(p,y,a)=sum(catch_at_age_natal_temp_overlap(p,y,a));
                yield_natal_temp_overlap(p,y,j)=yield_population_overlap(p,j,y);
                yield_natal_overlap(p,y)=sum(yield_natal_temp_overlap(p,y));
                harvest_rate_region_fleet_bio_overlap(p,j,r,z,y)=yield_region_fleet_overlap(p,j,r,z,y)/biomass_AM_overlap_region(p,j,r,y);
                harvest_rate_region_bio_overlap(p,j,r,y)=yield_region_overlap(p,j,r,y)/biomass_AM_overlap_region(p,j,r,y);
                harvest_rate_population_bio_overlap(p,j,y)=yield_population_overlap(p,j,y)/biomass_population_overlap(p,j,y);
                harvest_rate_natal_bio_overlap(p,y)=yield_natal_overlap(p,y)/biomass_natal_overlap(p,y);
                depletion_region_overlap(p,j,r,y)=biomass_AM_overlap_region(p,j,r,y)/biomass_AM_overlap_region(p,j,r,1);
                depletion_population_overlap(p,j,y)=biomass_population_overlap(p,j,y)/biomass_population_overlap(p,j,1);
                depletion_natal_overlap(p,y)=biomass_natal_overlap(p,y)/biomass_natal_overlap(p,1);
               
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////a==1 metapop type abundance calcs////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
                   abundance_spawn(j,r,y,a)=abundance_at_age_AM(j,r,y,a)*mfexp(-(M(j,r,y,a)+F(j,r,y,a))*tspawn(j));
                   catch_at_age_fleet(j,r,y,a,z)=abundance_at_age_AM(j,r,y,a)*(1.0-exp(-(F_fleet(j,r,y,a,z)+M(j,r,y,a))*(1-tspawn(j))))*(F_fleet(j,r,y,a,z))/(F(j,r,y,a)+M(j,r,y,a)); //account for time of spawning in catch (tspawn divides out in F/(F+M
                 
                   yield_fleet_temp(j,r,y,z,a)=weight_catch(j,r,y,a)*catch_at_age_fleet(j,r,y,a,z);
                   yield_fleet(j,r,y,z)=sum(yield_fleet_temp(j,r,y,z));
                   yieldN_fleet_temp(j,r,y,z,a)=catch_at_age_fleet(j,r,y,a,z);
                   yieldN_fleet(j,r,y,z)=sum(yieldN_fleet_temp(j,r,y,z));
                   catch_at_age_region(j,r,y,a)=sum(catch_at_age_fleet(j,r,y,a));
                   yield_region_temp(j,r,y,a)=weight_catch(j,r,y,a)*catch_at_age_region(j,r,y,a);
                   yield_region(j,r,y)=sum(yield_region_temp(j,r,y));
                   catch_at_age_population_temp(j,y,a,r)=catch_at_age_region(j,r,y,a);
                   catch_at_age_population(j,y,a)=sum(catch_at_age_population_temp(j,y,a));
                   yield_population_temp(j,y,a)=weight_catch(j,r,y,a)*catch_at_age_population(j,y,a);
                   yield_population(j,y)=sum(yield_population_temp(j,y));

                abundance_population_temp(j,y,a,r)=abundance_at_age_AM(j,r,y,a);
                abundance_population(j,y,a)=sum(abundance_population_temp(j,y,a));
                abundance_total_temp(y,a,j)=abundance_population(j,y,a);
                abundance_total(y,a)=sum(abundance_total_temp(y,a));
                catch_at_age_total_temp(y,a,j)=catch_at_age_population(j,y,a);
                catch_at_age_total(y,a)=sum(catch_at_age_total_temp(y,a));
                yield_total_temp(y,j)=yield_population(j,y);
                yield_total(y)=sum(yield_total_temp(y));
                harvest_rate_region_num(j,r,y,a)=catch_at_age_region(j,r,y,a)/abundance_at_age_AM(j,r,y,a);
                harvest_rate_population_num(j,y,a)=catch_at_age_population(j,y,a)/abundance_population(j,y,a);
                harvest_rate_total_num(y,a)=catch_at_age_total(y,a)/abundance_total(y,a);
                harvest_rate_region_bio(j,r,y)=yield_region(j,r,y)/biomass_AM(j,r,y);
                harvest_rate_population_bio(j,y)=yield_population(j,y)/biomass_population(j,y);
                harvest_rate_total_bio(y)=yield_total(y)/biomass_total(y);
                depletion_region(j,r,y)=biomass_AM(j,r,y)/biomass_AM(j,r,1);
                depletion_population(j,y)=biomass_population(j,y)/biomass_population(j,1);
                depletion_total(y)=biomass_total(y)/biomass_total(1);
            } //end a==1 loop

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////a==2 overlap calcs///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   if(a==2)
    {
                abundance_spawn_overlap(p,j,r,y,a)=abundance_at_age_AM_overlap_region(p,j,y,a,r)*mfexp(-(M(j,r,y,a)+F(j,r,y,a))*tspawn(p));
                abundance_natal_temp_overlap(p,y,a,j)=abundance_at_age_AM_overlap_population(p,j,y,a);
                abundance_natal_overlap(p,y,a)=sum(abundance_natal_temp_overlap(p,y,a));
                catch_at_age_region_fleet_overlap(p,j,r,z,y,a)=abundance_at_age_AM_overlap_region(p,j,y,a,r)*(1.0-mfexp(-(F_fleet(j,r,y,a,z)+M(j,r,y,a))))*(F_fleet(j,r,y,a,z)/(F_fleet(j,r,y,a,z)+M(j,r,y,a)));              
                yield_region_fleet_temp_overlap(p,j,r,z,y,a)=weight_catch(p,r,y,a)*catch_at_age_region_fleet_overlap(p,j,r,z,y,a);
                yield_region_fleet_overlap(p,j,r,z,y)=sum(yield_region_fleet_temp_overlap(p,j,r,z,y));
                catch_at_age_region_overlap(p,j,r,y,a)=abundance_at_age_AM_overlap_region(p,j,y,a,r)*(1.0-exp(-(F(j,r,y,a)+M(j,r,y,a))))*(F(j,r,y,a)/(F(j,r,y,a)+M(j,r,y,a)));              
                yield_region_temp_overlap(p,j,r,y,a)=weight_catch(p,r,y,a)*catch_at_age_region_overlap(p,j,r,y,a);
                yield_region_overlap(p,j,r,y)=sum(yield_region_temp_overlap(p,j,r,y));
                catch_at_age_population_temp_overlap(p,j,y,a,r)=catch_at_age_region_overlap(p,j,r,y,a);
                catch_at_age_population_overlap(p,j,y,a)=sum(catch_at_age_population_temp_overlap(p,j,y,a));
                yield_population_temp_overlap(p,j,y,a)=weight_catch(p,r,y,a)*catch_at_age_population_overlap(p,j,y,a);
                yield_population_overlap(p,j,y)=sum(yield_population_temp_overlap(p,j,y));
                catch_at_age_natal_temp_overlap(p,y,a,j)=catch_at_age_population_overlap(p,j,y,a);
                catch_at_age_natal_overlap(p,y,a)=sum(catch_at_age_natal_temp_overlap(p,y,a));
                yield_natal_temp_overlap(p,y,j)=yield_population_overlap(p,j,y);
                yield_natal_overlap(p,y)=sum(yield_natal_temp_overlap(p,y));
                harvest_rate_region_fleet_bio_overlap(p,j,r,z,y)=yield_region_fleet_overlap(p,j,r,z,y)/biomass_AM_overlap_region(p,j,r,y);
                harvest_rate_region_bio_overlap(p,j,r,y)=yield_region_overlap(p,j,r,y)/biomass_AM_overlap_region(p,j,r,y);
                harvest_rate_population_bio_overlap(p,j,y)=yield_population_overlap(p,j,y)/biomass_population_overlap(p,j,y);
                harvest_rate_natal_bio_overlap(p,y)=yield_natal_overlap(p,y)/biomass_natal_overlap(p,y);
                depletion_region_overlap(p,j,r,y)=biomass_AM_overlap_region(p,j,r,y)/biomass_AM_overlap_region(p,j,r,1);
                depletion_population_overlap(p,j,y)=biomass_population_overlap(p,j,y)/biomass_population_overlap(p,j,1);
                depletion_natal_overlap(p,y)=biomass_natal_overlap(p,y)/biomass_natal_overlap(p,1);
                            
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////a==2 metapop type abundance calcs////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                   
                  abundance_spawn(j,r,y,a)=abundance_at_age_AM(j,r,y,a)*mfexp(-(M(j,r,y,a)+F(j,r,y,a))*tspawn(j));
                  catch_at_age_fleet(j,r,y,a,z)=abundance_at_age_AM(j,r,y,a)*(1.0-exp(-(F_fleet(j,r,y,a,z)+M(j,r,y,a))))*(F_fleet(j,r,y,a,z))/(F(j,r,y,a)+M(j,r,y,a));                  
                  yield_fleet_temp(j,r,y,z,a)=weight_catch(j,r,y,a)*catch_at_age_fleet(j,r,y,a,z);
                  yield_fleet(j,r,y,z)=sum(yield_fleet_temp(j,r,y,z));
                  yieldN_fleet_temp(j,r,y,z,a)=catch_at_age_fleet(j,r,y,a,z);
                  yieldN_fleet(j,r,y,z)=sum(yieldN_fleet_temp(j,r,y,z));
                  catch_at_age_region(j,r,y,a)=sum(catch_at_age_fleet(j,r,y,a));
                  yield_region_temp(j,r,y,a)=weight_catch(j,r,y,a)*catch_at_age_region(j,r,y,a);
                  yield_region(j,r,y)=sum(yield_region_temp(j,r,y));
                  catch_at_age_population_temp(j,y,a,r)=catch_at_age_region(j,r,y,a);
                  catch_at_age_population(j,y,a)=sum(catch_at_age_population_temp(j,y,a));
                  yield_population_temp(j,y,a)=weight_catch(j,r,y,a)*catch_at_age_population(j,y,a);
                  yield_population(j,y)=sum(yield_population_temp(j,y));

                abundance_population_temp(j,y,a,r)=abundance_at_age_AM(j,r,y,a);
                abundance_population(j,y,a)=sum(abundance_population_temp(j,y,a));
                abundance_total_temp(y,a,j)=abundance_population(j,y,a);
                abundance_total(y,a)=sum(abundance_total_temp(y,a));
                catch_at_age_total_temp(y,a,j)=catch_at_age_population(j,y,a);
                catch_at_age_total(y,a)=sum(catch_at_age_total_temp(y,a));
                yield_total_temp(y,j)=yield_population(j,y);
                yield_total(y)=sum(yield_total_temp(y));
                harvest_rate_region_num(j,r,y,a)=catch_at_age_region(j,r,y,a)/abundance_at_age_AM(j,r,y,a);
                harvest_rate_population_num(j,y,a)=catch_at_age_population(j,y,a)/abundance_population(j,y,a);
                harvest_rate_total_num(y,a)=catch_at_age_total(y,a)/abundance_total(y,a);
                harvest_rate_region_bio(j,r,y)=yield_region(j,r,y)/biomass_AM(j,r,y);
                harvest_rate_population_bio(j,y)=yield_population(j,y)/biomass_population(j,y);
                harvest_rate_total_bio(y)=yield_total(y)/biomass_total(y);
                depletion_region(j,r,y)=biomass_AM(j,r,y)/biomass_AM(j,r,1);
                depletion_population(j,y)=biomass_population(j,y)/biomass_population(j,1);
                depletion_total(y)=biomass_total(y)/biomass_total(1);
          } //end a==2 loop
  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////a>2 a<nages overlap calcs////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
             if(a>2 && a<nages)
               {
                abundance_spawn_overlap(p,j,r,y,a)=abundance_at_age_AM_overlap_region(p,j,y,a,r)*mfexp(-(M(j,r,y,a)+F(j,r,y,a))*tspawn(p));
                abundance_natal_temp_overlap(p,y,a,j)=abundance_at_age_AM_overlap_population(p,j,y,a);
                abundance_natal_overlap(p,y,a)=sum(abundance_natal_temp_overlap(p,y,a));
                catch_at_age_region_fleet_overlap(p,j,r,z,y,a)=abundance_at_age_AM_overlap_region(p,j,y,a,r)*(1.0-mfexp(-(F_fleet(j,r,y,a,z)+M(j,r,y,a))))*(F_fleet(j,r,y,a,z)/(F_fleet(j,r,y,a,z)+M(j,r,y,a)));              
                yield_region_fleet_temp_overlap(p,j,r,z,y,a)=weight_catch(p,r,y,a)*catch_at_age_region_fleet_overlap(p,j,r,z,y,a);
                yield_region_fleet_overlap(p,j,r,z,y)=sum(yield_region_fleet_temp_overlap(p,j,r,z,y));
                catch_at_age_region_overlap(p,j,r,y,a)=abundance_at_age_AM_overlap_region(p,j,y,a,r)*(1.0-exp(-(F(j,r,y,a)+M(j,r,y,a))))*(F(j,r,y,a)/(F(j,r,y,a)+M(j,r,y,a)));
                yield_region_temp_overlap(p,j,r,y,a)=weight_catch(p,r,y,a)*catch_at_age_region_overlap(p,j,r,y,a);
                yield_region_overlap(p,j,r,y)=sum(yield_region_temp_overlap(p,j,r,y));
                catch_at_age_population_temp_overlap(p,j,y,a,r)=catch_at_age_region_overlap(p,j,r,y,a);
                catch_at_age_population_overlap(p,j,y,a)=sum(catch_at_age_population_temp_overlap(p,j,y,a));
                yield_population_temp_overlap(p,j,y,a)=weight_catch(p,r,y,a)*catch_at_age_population_overlap(p,j,y,a);
                yield_population_overlap(p,j,y)=sum(yield_population_temp_overlap(p,j,y));
                catch_at_age_natal_temp_overlap(p,y,a,j)=catch_at_age_population_overlap(p,j,y,a);
                catch_at_age_natal_overlap(p,y,a)=sum(catch_at_age_natal_temp_overlap(p,y,a));
                yield_natal_temp_overlap(p,y,j)=yield_population_overlap(p,j,y);
                yield_natal_overlap(p,y)=sum(yield_natal_temp_overlap(p,y));
                harvest_rate_region_fleet_bio_overlap(p,j,r,z,y)=yield_region_fleet_overlap(p,j,r,z,y)/biomass_AM_overlap_region(p,j,r,y);
                harvest_rate_region_bio_overlap(p,j,r,y)=yield_region_overlap(p,j,r,y)/biomass_AM_overlap_region(p,j,r,y);
                harvest_rate_population_bio_overlap(p,j,y)=yield_population_overlap(p,j,y)/biomass_population_overlap(p,j,y);
                harvest_rate_natal_bio_overlap(p,y)=yield_natal_overlap(p,y)/biomass_natal_overlap(p,y);
                depletion_region_overlap(p,j,r,y)=biomass_AM_overlap_region(p,j,r,y)/biomass_AM_overlap_region(p,j,r,1);
                depletion_population_overlap(p,j,y)=biomass_population_overlap(p,j,y)/biomass_population_overlap(p,j,1);
                depletion_natal_overlap(p,y)=biomass_natal_overlap(p,y)/biomass_natal_overlap(p,1);
                                
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////a>2 a<nages metapop type abundance calcs///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
                  abundance_spawn(j,r,y,a)=abundance_at_age_AM(j,r,y,a)*mfexp(-(M(j,r,y,a)+F(j,r,y,a))*tspawn(j));
                  catch_at_age_fleet(j,r,y,a,z)=abundance_at_age_AM(j,r,y,a)*(1.0-exp(-(F_fleet(j,r,y,a,z)+M(j,r,y,a))))*(F_fleet(j,r,y,a,z))/(F(j,r,y,a)+M(j,r,y,a));
                  yield_fleet_temp(j,r,y,z,a)=weight_catch(j,r,y,a)*catch_at_age_fleet(j,r,y,a,z);
                  yield_fleet(j,r,y,z)=sum(yield_fleet_temp(j,r,y,z));
                  yieldN_fleet_temp(j,r,y,z,a)=catch_at_age_fleet(j,r,y,a,z);
                  yieldN_fleet(j,r,y,z)=sum(yieldN_fleet_temp(j,r,y,z));
                  catch_at_age_region(j,r,y,a)=sum(catch_at_age_fleet(j,r,y,a));
                  yield_region_temp(j,r,y,a)=weight_catch(j,r,y,a)*catch_at_age_region(j,r,y,a);
                  yield_region(j,r,y)=sum(yield_region_temp(j,r,y));
                  catch_at_age_population_temp(j,y,a,r)=catch_at_age_region(j,r,y,a);
                  catch_at_age_population(j,y,a)=sum(catch_at_age_population_temp(j,y,a));
                  yield_population_temp(j,y,a)=weight_catch(j,r,y,a)*catch_at_age_population(j,y,a);
                  yield_population(j,y)=sum(yield_population_temp(j,y));

                abundance_population_temp(j,y,a,r)=abundance_at_age_AM(j,r,y,a);
                abundance_population(j,y,a)=sum(abundance_population_temp(j,y,a));
                abundance_total_temp(y,a,j)=abundance_population(j,y,a);
                abundance_total(y,a)=sum(abundance_total_temp(y,a));
                catch_at_age_total_temp(y,a,j)=catch_at_age_population(j,y,a);
                catch_at_age_total(y,a)=sum(catch_at_age_total_temp(y,a));
                yield_total_temp(y,j)=yield_population(j,y);
                yield_total(y)=sum(yield_total_temp(y));
                harvest_rate_region_num(j,r,y,a)=catch_at_age_region(j,r,y,a)/abundance_at_age_AM(j,r,y,a);
                harvest_rate_population_num(j,y,a)=catch_at_age_population(j,y,a)/abundance_population(j,y,a);
                harvest_rate_total_num(y,a)=catch_at_age_total(y,a)/abundance_total(y,a);
                harvest_rate_region_bio(j,r,y)=yield_region(j,r,y)/biomass_AM(j,r,y);
                harvest_rate_population_bio(j,y)=yield_population(j,y)/biomass_population(j,y);
                harvest_rate_total_bio(y)=yield_total(y)/biomass_total(y);
                depletion_region(j,r,y)=biomass_AM(j,r,y)/biomass_AM(j,r,1);
                depletion_population(j,y)=biomass_population(j,y)/biomass_population(j,1);
                depletion_total(y)=biomass_total(y)/biomass_total(1);
       } //end a>2 <nages loop

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////a==nages overlap calcs////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
           if(a==nages) //account for fish already in plus group
            {
                abundance_spawn_overlap(p,j,r,y,a)=abundance_at_age_AM_overlap_region(p,j,y,a,r)*mfexp(-(M(j,r,y,a)+F(j,r,y,a))*tspawn(p));
                abundance_natal_temp_overlap(p,y,a,j)=abundance_at_age_AM_overlap_population(p,j,y,a);
                abundance_natal_overlap(p,y,a)=sum(abundance_natal_temp_overlap(p,y,a));
                catch_at_age_region_fleet_overlap(p,j,r,z,y,a)=abundance_at_age_AM_overlap_region(p,j,y,a,r)*(1.0-mfexp(-(F_fleet(j,r,y,a,z)+M(j,r,y,a))))*(F_fleet(j,r,y,a,z)/(F_fleet(j,r,y,a,z)+M(j,r,y,a)));              
                yield_region_fleet_temp_overlap(p,j,r,z,y,a)=weight_catch(p,r,y,a)*catch_at_age_region_fleet_overlap(p,j,r,z,y,a);
                yield_region_fleet_overlap(p,j,r,z,y)=sum(yield_region_fleet_temp_overlap(p,j,r,z,y));
                catch_at_age_region_overlap(p,j,r,y,a)=abundance_at_age_AM_overlap_region(p,j,y,a,r)*(1.0-exp(-(F(j,r,y,a)+M(j,r,y,a))))*(F(j,r,y,a)/(F(j,r,y,a)+M(j,r,y,a)));
                yield_region_temp_overlap(p,j,r,y,a)=weight_catch(p,r,y,a)*catch_at_age_region_overlap(p,j,r,y,a);
                yield_region_overlap(p,j,r,y)=sum(yield_region_temp_overlap(p,j,r,y));
                catch_at_age_population_temp_overlap(p,j,y,a,r)=catch_at_age_region_overlap(p,j,r,y,a);
                catch_at_age_population_overlap(p,j,y,a)=sum(catch_at_age_population_temp_overlap(p,j,y,a));
                yield_population_temp_overlap(p,j,y,a)=weight_catch(p,r,y,a)*catch_at_age_population_overlap(p,j,y,a);
                yield_population_overlap(p,j,y)=sum(yield_population_temp_overlap(p,j,y));
                catch_at_age_natal_temp_overlap(p,y,a,j)=catch_at_age_population_overlap(p,j,y,a);
                catch_at_age_natal_overlap(p,y,a)=sum(catch_at_age_natal_temp_overlap(p,y,a));
                yield_natal_temp_overlap(p,y,j)=yield_population_overlap(p,j,y);
                yield_natal_overlap(p,y)=sum(yield_natal_temp_overlap(p,y));
                harvest_rate_region_fleet_bio_overlap(p,j,r,z,y)=yield_region_fleet_overlap(p,j,r,z,y)/biomass_AM_overlap_region(p,j,r,y);
                harvest_rate_region_bio_overlap(p,j,r,y)=yield_region_overlap(p,j,r,y)/biomass_AM_overlap_region(p,j,r,y);
                harvest_rate_population_bio_overlap(p,j,y)=yield_population_overlap(p,j,y)/biomass_population_overlap(p,j,y);
                harvest_rate_natal_bio_overlap(p,y)=yield_natal_overlap(p,y)/biomass_natal_overlap(p,y);
                depletion_region_overlap(p,j,r,y)=biomass_AM_overlap_region(p,j,r,y)/biomass_AM_overlap_region(p,j,r,1);
                depletion_population_overlap(p,j,y)=biomass_population_overlap(p,j,y)/biomass_population_overlap(p,j,1);
                depletion_natal_overlap(p,y)=biomass_natal_overlap(p,y)/biomass_natal_overlap(p,1);               
                 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////a==nages metapop type abundance calcs///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     
                  abundance_spawn(j,r,y,a)=abundance_at_age_AM(j,r,y,a)*mfexp(-(M(j,r,y,a)+F(j,r,y,a))*tspawn(j));
                  catch_at_age_fleet(j,r,y,a,z)=abundance_at_age_AM(j,r,y,a)*(1.0-exp(-(F_fleet(j,r,y,a,z)+M(j,r,y,a))))*(F_fleet(j,r,y,a,z))/(F(j,r,y,a)+M(j,r,y,a));
                  yield_fleet_temp(j,r,y,z,a)=weight_catch(j,r,y,a)*catch_at_age_fleet(j,r,y,a,z);
                  yield_fleet(j,r,y,z)=sum(yield_fleet_temp(j,r,y,z));
                  yieldN_fleet_temp(j,r,y,z,a)=catch_at_age_fleet(j,r,y,a,z);
                  yieldN_fleet(j,r,y,z)=sum(yieldN_fleet_temp(j,r,y,z));
                  catch_at_age_region(j,r,y,a)=sum(catch_at_age_fleet(j,r,y,a));
                  yield_region_temp(j,r,y,a)=weight_catch(j,r,y,a)*catch_at_age_region(j,r,y,a);
                  yield_region(j,r,y)=sum(yield_region_temp(j,r,y));
                  catch_at_age_population_temp(j,y,a,r)=catch_at_age_region(j,r,y,a);
                  catch_at_age_population(j,y,a)=sum(catch_at_age_population_temp(j,y,a));
                  yield_population_temp(j,y,a)=weight_catch(j,r,y,a)*catch_at_age_population(j,y,a);
                  yield_population(j,y)=sum(yield_population_temp(j,y));

                abundance_population_temp(j,y,a,r)=abundance_at_age_AM(j,r,y,a);
                abundance_population(j,y,a)=sum(abundance_population_temp(j,y,a));
                abundance_total_temp(y,a,j)=abundance_population(j,y,a);
                abundance_total(y,a)=sum(abundance_total_temp(y,a));
                catch_at_age_total_temp(y,a,j)=catch_at_age_population(j,y,a);
                catch_at_age_total(y,a)=sum(catch_at_age_total_temp(y,a));
                yield_total_temp(y,j)=yield_population(j,y);
                yield_total(y)=sum(yield_total_temp(y));
                harvest_rate_region_num(j,r,y,a)=catch_at_age_region(j,r,y,a)/abundance_at_age_AM(j,r,y,a);
                harvest_rate_population_num(j,y,a)=catch_at_age_population(j,y,a)/abundance_population(j,y,a);
                harvest_rate_total_num(y,a)=catch_at_age_total(y,a)/abundance_total(y,a);
                harvest_rate_region_bio(j,r,y)=yield_region(j,r,y)/biomass_AM(j,r,y);
                harvest_rate_population_bio(j,y)=yield_population(j,y)/biomass_population(j,y);
                harvest_rate_total_bio(y)=yield_total(y)/biomass_total(y);
                depletion_region(j,r,y)=biomass_AM(j,r,y)/biomass_AM(j,r,1);
                depletion_population(j,y)=biomass_population(j,y)/biomass_population(j,1);
                depletion_total(y)=biomass_total(y)/biomass_total(1);
        } //end nages if statement

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////SSB calcs////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


   //don't adjust SSB for fish not in natal population area because SR calculationp do this automatically by only using
   //SSB that is in natal population area (i.e., p==j)
   //for spawning migrationp scenarios the SSB is adjusted outside the loop to remove SSB of fish that actually returned
   // to natal population (i.e., remove this SSB from the non-natal areas...doesn't impact SR calcs so can do this outside
   //loops without conpequence to model
   
                SSB_region_temp_overlap(p,j,r,y,a)=abundance_spawn_overlap(p,j,r,y,a)*wt_mat_mult_reg(p,r,y,a); //added region
                SSB_region_overlap(p,j,r,y)=sum(SSB_region_temp_overlap(p,j,r,y));
                 SSB_overlap_natal=0;
                  if(natal_homing_switch==1 && spawn_return_switch==1) //spawning return calculationp
                   {
                    for(int k=1;k<=npops;k++)
                     {
                      for (int n=1;n<=nregions(k);n++)
                       {
                        if(p==k && j==k)
                         {
                          SSB_overlap_natal(k,n)=0;
                         }   
                        if(p==j && j!=k)
                         {
                          SSB_overlap_natal(k,n)=spawn_return_prob(p)*SSB_region_overlap(p,k,n,y);
                         } 
                       }
                      } 
                      if(p==j)
                      {
                       SSB_region_overlap(p,j,r,y)=SSB_region_overlap(p,j,r,y)+(sum(SSB_overlap_natal)/nregions(p));
                       }
                   } 
                SSB_population_temp_overlap(p,j,y,r)=SSB_region_overlap(p,j,r,y); 
                SSB_population_overlap(p,j,y)=sum(SSB_population_temp_overlap(p,j,y));
                SSB_natal_overlap_temp(p,y,j)=SSB_population_overlap(p,j,y);
                SSB_natal_overlap(p,y)=sum(SSB_natal_overlap_temp(p,y));  /// this is adjusted below outside y loop to account for fish not spawning

              if(natal_homing_switch>0)
               {
               if(p==j)  //accounts for not being in natal area
               {
                SSB_region(j,r,y)=SSB_region_overlap(p,j,r,y);
               }
              }
              if(natal_homing_switch==0)
              {
                SSB_region_temp(j,r,y,a)=abundance_spawn(j,r,y,a)*wt_mat_mult_reg(j,r,y,a); 
                SSB_region(j,r,y)=sum(SSB_region_temp(j,r,y));
              }
                SSB_population_temp(j,y,r)=SSB_region(j,r,y);
                SSB_population(j,y)=sum(SSB_population_temp(j,y));
                SSB_total_temp(y,j)=SSB_population(j,y);
                SSB_total(y)=sum(SSB_total_temp(y));

                Bratio_population_overlap(p,j,y)=SSB_population_overlap(p,j,y)/SSB_zero(p);
                Bratio_natal_overlap(p,y)=SSB_natal_overlap(p,y)/SSB_zero(p);
                Bratio_population(j,y)=SSB_population(j,y)/SSB_zero(j);
                Bratio_total(y)=SSB_total(y)/sum(SSB_zero);

          } //end fleets loop
             for (int z=1;z<=nfleets_survey(j);z++)    /// survey index  1. Currently set up for more than 1 survey fleet
              {
               if(tsurvey(j,r)>0) //if survey at beggining of year, do calcs without temporal adjustment for mortality
                {
                  survey_fleet_overlap_age(p,j,r,y,z,a)=survey_selectivity(j,r,y,a,z)*abundance_at_age_AM_overlap_region(p,j,y,a,r)*mfexp(-(M(j,r,y,a)+F(j,r,y,a))*tsurvey(j,r))*q_survey(j,r,z);
                  survey_fleet_overlap_age_bio(p,j,r,y,z,a)=survey_fleet_overlap_age(p,j,r,y,z,a)*weight_population(p,r,y,a);
                  survey_fleet_bio_overlap(p,j,r,y,z)=sum(survey_fleet_overlap_age_bio(p,j,r,y,z));  
                  survey_fleet_bio_overlap_temp(j,r,y,z,p)=survey_fleet_bio_overlap(p,j,r,y,z);

                if(natal_homing_switch==0)
                 {
                  survey_fleet_age(j,r,y,z,a)=survey_selectivity(j,r,y,a,z)*abundance_at_age_AM(j,r,y,a)*mfexp(-(M(j,r,y,a)+F(j,r,y,a))*tsurvey(j,r))*q_survey(j,r,z);
                  survey_fleet_age_bio(j,r,y,z,a)=survey_fleet_age(j,r,y,z,a)*weight_population(j,r,y,a);                  
                  survey_fleet_bio(j,r,y,z)=sum(survey_fleet_age_bio(j,r,y,z));
                 }
                if(natal_homing_switch==1)
                 {
                  survey_fleet_bio(j,r,y,z)=sum(survey_fleet_bio_overlap_temp(j,r,y,z));
                 }
             
                  survey_region_bio_overlap(p,j,y,r)=sum(survey_fleet_bio_overlap(p,j,r,y));               
                  survey_population_bio_overlap(p,y,j)=sum(survey_region_bio_overlap(p,j,y));               
                  survey_natal_bio_overlap(y,p)=sum(survey_population_bio_overlap(p,y));               
                  survey_total_bio_overlap(y)=sum(survey_natal_bio_overlap(y));

                  survey_region_bio(j,y,r)=sum(survey_fleet_bio(j,r,y));
                  survey_population_bio(y,j)=sum(survey_region_bio(j,y));
                  survey_total_bio(y)=sum(survey_population_bio(y));

                }  //tsurvey>0
               } //end survey_fleets
      }
     }
    }
   } // end age loop
  } //end yr>1 loop
 }  //end y loop



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////now adjusting natal homing ssb for spawning migration scenarios where fish left non-natal area
       for (int p=1;p<=npops;p++)
        {
         for (int j=1;j<=npops;j++)
          {
           for (int r=1;r<=nregions(p);r++)
            {
             for (int t=1;t<=nregions(j);t++)
              {
               for (int y=1;y<=nyrs;y++)
                {
                 SSB_overlap_natal=0;
                  if(natal_homing_switch==1 && spawn_return_switch==1)
                    {
                    if(p!=j)  //update SSB that doesn't spawn (ie doesn't return to natal population)
                    {
                     SSB_region_overlap(p,j,r,y)=(1-spawn_return_prob(p))*SSB_region_overlap(p,j,r,y);
                    }
                   SSB_population_temp_overlap(p,j,y,r)=SSB_region_overlap(p,j,r,y); 
                   SSB_population_overlap(p,j,y)=sum(SSB_population_temp_overlap(p,j,y));
                   SSB_natal_overlap_temp(p,y,j)=SSB_population_overlap(p,j,y);
                   SSB_natal_overlap(p,y)=sum(SSB_natal_overlap_temp(p,y));
                Bratio_population_overlap(p,j,y)=SSB_population_overlap(p,j,y)/SSB_zero(p);
                Bratio_natal_overlap(p,y)=SSB_natal_overlap(p,y)/SSB_zero(p);
                Bratio_population(j,y)=SSB_population(j,y)/SSB_zero(j);
                Bratio_total(y)=SSB_total(y)/sum(SSB_zero);
                    }
                   }
                  }
                 }
                }
               }


FUNCTION get_survey_CAA_prop      
  for (int p=1;p<=npops;p++)
   {
    for (int j=1;j<=npops;j++)
     {
      for (int r=1;r<=nregions(j);r++)
       {
        for (int z=1;z<=nfleets_survey(j);z++)
         {
          for (int y=1;y<=nyrs;y++) //need to alter to fit number of years of catch data
           {
            for (int a=1;a<=nages;a++)
             {
              survey_at_age_region_fleet_overlap_prop(p,j,r,z,y,a)=survey_fleet_overlap_age(p,j,r,y,z,a)/sum(survey_fleet_overlap_age(p,j,r,y,z));              
              survey_at_age_fleet_prop(j,r,y,z,a)=survey_fleet_age(j,r,y,z,a)/sum(survey_fleet_age(j,r,y,z));
             }
            }
           }
          }
         }
        }


FUNCTION get_CAA_prop

    for (int j=1;j<=npops;j++)
     {
      for (int r=1;r<=nregions(j);r++)
       {
        for (int z=1;z<=nfleets(j);z++)
         {
          for (int y=1;y<=nyrs;y++) //need to alter to fit number of years of catch data
           {
            for (int a=1;a<=nages;a++)
             {
                 catch_at_age_fleet_prop_temp(j,r,y,z,a)=catch_at_age_fleet(j,r,y,a,z);
              }
            }
           }
          }
         }

  for (int p=1;p<=npops;p++)
   {
    for (int j=1;j<=npops;j++)
     {
      for (int r=1;r<=nregions(j);r++)
       {
        for (int z=1;z<=nfleets(j);z++)
         {
          for (int y=1;y<=nyrs;y++) //need to alter to fit number of years of catch data
           {
            for (int a=1;a<=nages;a++)
             {
                 catch_at_age_region_fleet_overlap_prop(p,j,r,z,y,a)=catch_at_age_region_fleet_overlap(p,j,r,z,y,a)/sum(catch_at_age_region_fleet_overlap(p,j,r,z,y));              
                 catch_at_age_region_overlap_prop(p,j,r,y,a)=catch_at_age_region_overlap(p,j,r,y,a)/sum(catch_at_age_region_overlap(p,j,r,y));
                 catch_at_age_population_overlap_prop(p,j,y,a)=catch_at_age_population_overlap(p,j,y,a)/sum(catch_at_age_population_overlap(p,j,y));
                 catch_at_age_natal_overlap_prop(p,y,a)=catch_at_age_natal_overlap(p,y,a)/sum(catch_at_age_natal_overlap(p,y));

                 catch_at_age_fleet_prop(j,r,y,z,a)=catch_at_age_fleet_prop_temp(j,r,y,z,a)/sum(catch_at_age_fleet_prop_temp(j,r,y,z));
                 catch_at_age_region_prop(j,r,y,a)=catch_at_age_region(j,r,y,a)/sum(catch_at_age_region(j,r,y));
                 catch_at_age_population_prop(j,y,a)=catch_at_age_population(j,y,a)/sum(catch_at_age_population(j,y));
                 catch_at_age_total_prop(y,a)=catch_at_age_total(y,a)/sum(catch_at_age_total(y));
              }
            }
           }
          }
         }
        }
        
FUNCTION get_tag_recaptures
  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////
  // In some calcs (mortality and movement) need to account for true age (age+time at large),
  // because multiple cohorts this means need to factor in release year
  // so true age becomes age+year-release year
  // using subscript notation this equals= (a+y-xx)
  // similarly because account for release age, do not need to worry about plus group calcs as carry recaptures out to max_life_tags and never assume plus group (just use plus group mortality and movement values in calcs where a>=max_age)
  /////////////////////////////////////////////////////////////////////////////

    for(int x=1; x<=nyrs_release; x++)
     {
      T_tag_res(x)=(mfexp(ln_T_tag_res(x)))/(mfexp(ln_T_tag_res(x))+1); //bec proportion use logit to bound between 0 and 1
      F_tag_scalar(x)=mfexp(ln_F_tag_scalar(x))/(mfexp(ln_F_tag_scalar(x))+1);
     }
 
 if(do_tag==1)
  {
 //assume tags released in natal population
 for (int i=1;i<=npops;i++)
  {
   for (int n=1;n<=nregions(i);n++)
    {
    for(int x=1; x<=nyrs_release; x++)
     {
      xx=yrs_releases(x);
      for (int a=1;a<=nages;a++) //release age //because accounting for release age, don't need to account for recap age, just adjust mortality and T, to use plus group value if recapture age exceeds max age
        {
         for(int y=1;y<=min(max_life_tags,nyrs-xx+1);y++)  //recap year
          {
           for(int j=1;j<=npops;j++) //recap stock
            {
             for (int r=1;r<=nregions(j);r++)
             {
             tag_age_sel=age_full_selection(j,r,xx);
              if(y==1) //year of release for a cohort
               {              
                if(est_tag_mixing_switch==0) //assume complete mixing of tagged and untagged fish
                 {
                 tags_avail(i,n,x,a,y,j,r)=ntags(i,n,x,a)*T(i,n,xx,a,j,r); 
                 recaps(i,n,x,a,y,j,r)=report_rate(j,x,r)*tags_avail(i,n,x,a,y,j,r)*F(j,r,xx,a)*(1.-mfexp(-(F(j,r,xx,a)+M(j,r,xx,a))))/(F(j,r,xx,a)+(M(j,r,xx,a)));  //recaps=tags available*fraction of fish that die*fraction of mortality due to fishing*tags inspected (reporting)
               if(fit_tag_age_switch==1) //need to determine age of full selectivity for tagging data if assuming don't know age of tags
                {
                 tags_avail(i,n,x,a,y,j,r)=ntags(i,n,x,a)*T(i,n,xx,tag_age_sel,j,r); 
                 recaps(i,n,x,a,y,j,r)=report_rate(j,x,r)*tags_avail(i,n,x,a,y,j,r)*F(j,r,xx,tag_age_sel)*(1.-mfexp(-(F(j,r,xx,tag_age_sel)+M(j,r,xx,tag_age_sel))))/(F(j,r,xx,tag_age_sel)+(M(j,r,xx,tag_age_sel)));  //recaps=tags available*fraction of fish that die*fraction of mortality due to fishing*tags inspected (reporting)                                
                }
                }

                if(est_tag_mixing_switch>0) //assume incomplete mixing of tagged and untagged fish
                 {
                if(est_tag_mixing_switch==1) //assume incomplete mixing of tagged and untagged fish
                 {
                   tags_avail(i,n,x,a,y,j,r)=ntags(i,n,x,a)*T(i,n,xx,a,j,r); 
                 }
                 if(est_tag_mixing_switch==2 || est_tag_mixing_switch==3) //assume incomplete mixing of tagged and untagged fish 
                  {                 
                   if(i==j && n==r)
                    {
                      T_tag(i,n,x,a,j,r)=T_tag_res(x);
                    }
                   if(i!=j || n!=r)
                    {
                      T_tag(i,n,x,a,j,r)=(1-T_tag_res(x))/(sum(nregions)-1); //split movement evenly across remaining regions
                     }
                    
                      if(T_tag(i,n,x,a,j,r)>1)
                       {
                        T_tag(i,n,x,a,j,r)=1;
                       }
                      if(T_tag(i,n,x,a,j,r)<0)
                       {
                        T_tag(i,n,x,a,j,r)=0;
                       }
                      
                    tags_avail(i,n,x,a,y,j,r)=ntags(i,n,x,a)*T_tag(i,n,x,a,j,r);                        
                   }
                 if(est_tag_mixing_switch==2) //assume incomplete mixing of tagged and untagged fish 
                  {
                   recaps(i,n,x,a,y,j,r)=report_rate(j,x,r)*tags_avail(i,n,x,a,y,j,r)*F(j,r,xx,a)*(1.-mfexp(-(F(j,r,xx,a)+M(j,r,xx,a))))/(F(j,r,xx,a)+(M(j,r,xx,a)));  //recaps=tags available*fraction of fish that die*fraction of mortality due to fishing*tags inspected (reporting)
                  }
                 if(est_tag_mixing_switch==1 || est_tag_mixing_switch==3) //assume incomplete mixing of tagged and untagged fish 
                  {                  
                   F_tag(j,r,x,a)=F_tag_scalar(x)*F(j,r,xx,a);
                   recaps(i,n,x,a,y,j,r)=report_rate(j,x,r)*tags_avail(i,n,x,a,y,j,r)*(F_tag_scalar(x)*F(j,r,xx,a))*(1.-mfexp(-((F_tag_scalar(x)*F(j,r,xx,a))+M(j,r,xx,a))))/((F_tag_scalar(x)*F(j,r,xx,a))+(M(j,r,xx,a)));  //recaps=tags available*fraction of fish that die*fraction of mortality due to fishing*tags inspected (reporting)
                  }
           //    if(fit_tag_age_switch==1) //need to determine age of full selectivity for tagging data if assuming don't know age of tags
             //   {
               //  tags_avail(i,n,x,a,y,j,r)=ntags(i,n,x,a)*T(i,n,xx,tag_age_sel,j,r); 
                // recaps(i,n,x,a,y,j,r)=report_rate(j,x,r)*tags_avail(i,n,x,a,y,j,r)*F(j,r,xx,tag_age_sel)*(1.-mfexp(-(F(j,r,xx,tag_age_sel)+M(j,r,xx,tag_age_sel))))/(F(j,r,xx,tag_age_sel)+(M(j,r,xx,tag_age_sel)));  //recaps=tags available*fraction of fish that die*fraction of mortality due to fishing*tags inspected (reporting)                                
               // }
               }
              }

           if((est_tag_mixing_switch==1 || est_tag_mixing_switch==3) && y==2) //assume incomplete mixing of tagged and untagged fish
              {
               tags_avail_temp=0;
               for(int p=1;p<=npops;p++)
               {
                for (int s=1;s<=nregions(p);s++)
                {
                 if(natal_homing_switch==0) //if no natal homing
                 {
                  tags_avail_temp(p,s)=tags_avail(i,n,x,a,y-1,p,s)*T(p,s,(xx+y-1),min((a+y),nages),j,r)*mfexp(-((F_tag_scalar(x)*F(p,s,(xx+y-2),min(((a+y)-1),nages)))+(M(p,s,(xx+y-2),min(((a+y)-1),nages))))); //tags_temp holds all tags moving into population j,region r; min function takes min of true age and max age allowed (plus group)
                 }                        
                //#####################################################################################################
                //  TRUE NATAL HOMING  T(n,x,a,y,j) becomes T(i,x,a,y,j) because need to maintain your natal origin
                //  movement values so T doesn't depend on current population only origin population and destination population
                //########################################################################################################              
                 if(natal_homing_switch==1) //if natal homing 
                 {
                  tags_avail_temp(p,s)=tags_avail(i,n,x,a,y-1,p,s)*T(i,n,(xx+y-1),min((a+y),nages),j,r)*mfexp(-((F_tag_scalar(x)*F(p,s,(xx+y-2),min(((a+y)-1),nages)))+(M(p,s,(xx+y-2),min(((a+y)-1),nages))))); //tags_temp holds all tags moving into population j,region r; min function takes min of true age and max age allowed (plus group)             
                 }               
                }
               }
                 tags_avail(i,n,x,a,y,j,r)=sum(tags_avail_temp); //sum across all pops/regs of tags that moved into pop j reg r
                 recaps(i,n,x,a,y,j,r)=report_rate(j,x,r)*tags_avail(i,n,x,a,y,j,r)*F(j,r,(xx+y-1),min((a+y),nages))*(1.-mfexp(-(F(j,r,(xx+y-1),min((a+y),nages))+(M(j,r,(xx+y-1),min((a+y),nages))))))/(F(j,r,(xx+y-1),min((a+y),nages))+(M(j,r,(xx+y-1),min((a+y),nages))));  //recaps=tags available*fraction of fish that die*fraction of mortality due to fishing*tags inspected (reporting)                 
               }

         if(y>1 && (y>2 || est_tag_mixing_switch==0))
            {
               tags_avail_temp=0;
               for(int p=1;p<=npops;p++)
               {
                for (int s=1;s<=nregions(p);s++)
                {
                tag_age_sel=age_full_selection(p,s,xx);
                 if(natal_homing_switch==0) //if no natal homing
                 {
                  tags_avail_temp(p,s)=tags_avail(i,n,x,a,y-1,p,s)*T(p,s,(xx+y-1),min((a+y),nages),j,r)*mfexp(-(F(p,s,(xx+y-2),min(((a+y)-1),nages))+(M(p,s,(xx+y-2),min(((a+y)-1),nages))))); //tags_temp holds all tags moving into population j,region r; min function takes min of true age and max age allowed (plus group)
                   if(fit_tag_age_switch==1) //need to determine age of full selectivity for tagging data if assuming don't know age of tags
                    {
                     tags_avail_temp(p,s)=tags_avail(i,n,x,a,y-1,p,s)*T(p,s,(xx+y-1),tag_age_sel,j,r)*mfexp(-(F(p,s,(xx+y-2),tag_age_sel)+(M(p,s,(xx+y-2),tag_age_sel)))); //tags_temp holds all tags moving into population j,region r; min function takes min of true age and max age allowed (plus group)
                    }
                 }                        
                //#####################################################################################################
                //  TRUE NATAL HOMING  T(n,x,a,y,j) becomes T(i,x,a,y,j) because need to maintain your natal origin
                //  movement values so T doesn't depend on current population only origin population and destination population
                //########################################################################################################              
                 if(natal_homing_switch==1) //if natal homing 
                 {
                  tags_avail_temp(p,s)=tags_avail(i,n,x,a,y-1,p,s)*T(i,n,(xx+y-1),min((a+y),nages),j,r)*mfexp(-(F(p,s,(xx+y-2),min(((a+y)-1),nages))+(M(p,s,(xx+y-2),min(((a+y)-1),nages))))); //tags_temp holds all tags moving into population j,region r; min function takes min of true age and max age allowed (plus group)
                   if(fit_tag_age_switch==1) //need to determine age of full selectivity for tagging data if assuming don't know age of tags
                    {
                     tags_avail_temp(p,s)=tags_avail(i,n,x,a,y-1,p,s)*T(i,n,(xx+y-1),tag_age_sel,j,r)*mfexp(-(F(p,s,(xx+y-2),tag_age_sel)+(M(p,s,(xx+y-2),tag_age_sel)))); //tags_temp holds all tags moving into population j,region r; min function takes min of true age and max age allowed (plus group)
                    }
                 }               
                }
               }
                 tags_avail(i,n,x,a,y,j,r)=sum(tags_avail_temp); //sum across all pops/regs of tags that moved into pop j reg r
                 //recaps(i,n,x,a,y,j,r)=report_rate(j,x,r)*tags_avail(i,n,x,a,y,j,r)*F(j,r,(xx+y-2),min((a+y),nages))*(1.-mfexp(-(F(j,r,(xx+y-2),min((a+y),nages))+(M(j,r,(xx+y-2),min((a+y),nages))))))/(F(j,r,(xx+y-2),min((a+y),nages))+(M(j,r,(xx+y-2),min((a+y),nages))));  //recaps=tags available*fraction of fish that die*fraction of mortality due to fishing*tags inspected (reporting)                 
                  recaps(i,n,x,a,y,j,r)=report_rate(j,x,r)*tags_avail(i,n,x,a,y,j,r)*F(j,r,(xx+y-1),min((a+y),nages))*(1.-mfexp(-(F(j,r,(xx+y-1),min((a+y),nages))+(M(j,r,(xx+y-1),min((a+y),nages))))))/(F(j,r,(xx+y-1),min((a+y),nages))+(M(j,r,(xx+y-1),min((a+y),nages))));  //recaps=tags available*fraction of fish that die*fraction of mortality due to fishing*tags inspected (reporting)                 
                   if(fit_tag_age_switch==1) //need to determine age of full selectivity for tagging data if assuming don't know age of tags
                    {
                     recaps(i,n,x,a,y,j,r)=report_rate(j,x,r)*tags_avail(i,n,x,a,y,j,r)*F(j,r,(xx+y-1),tag_age_sel)*(1.-mfexp(-(F(j,r,(xx+y-1),tag_age_sel)+(M(j,r,(xx+y-1),tag_age_sel)))))/(F(j,r,(xx+y-1),tag_age_sel)+(M(j,r,(xx+y-1),tag_age_sel)));  //recaps=tags available*fraction of fish that die*fraction of mortality due to fishing*tags inspected (reporting)                 
                    }              
              }
             }
            }
           }
          }
         }
        }
       }
      
 for (int i=1;i<=npops;i++)
  {
   for (int n=1;n<=nregions(i);n++)
    {
    for(int x=1; x<=nyrs_release; x++)
     {
      xx=yrs_releases(x);
      for (int a=1;a<=nages;a++) //release age //because accounting for release age, don't need to account for recap age, just adjust mortality and T, to use plus group value if recapture age exceeds max age
        {
        total_recap_temp.initialize();
         for(int y=1;y<=min(max_life_tags,nyrs-xx+1);y++)  //recap year
          {
           for(int j=1;j<=npops;j++) //recap stock
            {
             for (int r=1;r<=nregions(j);r++)
             {
              total_recap_temp(j,r,y)=recaps(i,n,x,a,y,j,r);
             }
            }
           }
              total_rec(i,n,x,a)=sum(total_recap_temp);
             not_rec(i,n,x,a)=ntags(i,n,x,a)-total_rec(i,n,x,a);  //for ntags  at a given age all entries represent all tags released so can just use any of the entries (hence the i,x,a,1 subscripts)
           }
          }
         }
        }
 for (int i=1;i<=npops;i++)
  {
   for (int n=1;n<=nregions(i);n++)
    {
    for(int x=1; x<=nyrs_release; x++)
     {
      xx=yrs_releases(x);
      for (int a=1;a<=nages;a++) //release age //because accounting for release age, don't need to account for recap age, just adjust mortality and T, to use plus group value if recapture age exceeds max age
        {
         for(int y=1;y<=min(max_life_tags,nyrs-xx+1);y++)  //recap year
          {
           for(int j=1;j<=npops;j++) //recap stock
            {
             for (int r=1;r<=nregions(j);r++)
             {
              if(ntags(i,n,x,a)>0)
               {
                tag_prop(i,n,x,a,y,j,r)=recaps(i,n,x,a,y,j,r)/ntags(i,n,x,a);
                tag_prop_not_rec(i,n,x,a)=not_rec(i,n,x,a)/ntags(i,n,x,a);
               }
              if(ntags(i,n,x,a)==0)
               {                   
                tag_prop(i,n,x,a,y,j,r)=0;
                tag_prop_not_rec(i,n,x,a)=0;
               }
             } 
            }
           }
          }         
         }
        }
       }

 for (int i=1;i<=npops;i++)
  {
   for (int n=1;n<=nregions(i);n++)
    {
    for(int x=1; x<=nyrs_release; x++)
     {
      xx=yrs_releases(x);
       for (int a=1;a<=nages;a++) //release age 
        {
         for(int y=1;y<=min(max_life_tags,nyrs-xx+1);y++)  //recap year
          {
           for(int j=1;j<=npops;j++) //recap stock
            {
             for (int r=1;r<=nregions(j);r++)
             {
              tag_prop_temp(j,y,r)=0; //for whatever reason ADMB won't let a 3darray=double...this is workaround for total_recap_temp=0;, ie setting temp 3darray to 0 after loops through all years 
             }
            }
           }
         for(int y=1;y<=min(max_life_tags,nyrs-xx+1);y++)  //recap year
          {
           for(int j=1;j<=npops;j++) //recap stock
            {
             for (int r=1;r<=nregions(j);r++) //recap region
              {
               tag_prop_temp(j,y,r)=tag_prop(i,n,x,a,y,j,r); //fill temp array with a single release cohort's recapture probabilities (excluding not recaptured)
              }
            }
           }
         //tag_prop_temp2=0;
         for(int y=1;y<=min(max_life_tags,nyrs-xx+1);y++)  //recap year
          {
           for(int j=1;j<=npops;j++) //recap stock
            {
             for (int r=1;r<=nregions(j);r++)
              {
               tag_prop_temp2(i,n,x,a,((y-1)*sum(nregions)+nreg_temp(j)+r))=tag_prop_temp(j,y,r); //stack array into single vector by year, population, region
              }
             }
            }
             for(int s=1;s<=(max_life_tags*sum(nregions)+1);s++) //create temp array that has columns of recap prob for each release cohort and add not recap probability to final entry of temp array
              {
              if(s<(min(max_life_tags,nyrs-xx+1)*sum(nregions)+1))
              {
               tag_prop_final(i,n,x,a,s)=tag_prop_temp2(i,n,x,a,s);
              }
              if(s==(min(max_life_tags,nyrs-xx+1)*sum(nregions)+1) && max_life_tags<=(nyrs-xx+1)) //add not recap probability to final entry of temp array
              {
               tag_prop_final(i,n,x,a,s)=tag_prop_not_rec(i,n,x,a);  //for estimation model will use this version of tag_prop in likelihood
              }
              if(s==(min(max_life_tags,nyrs-xx+1)*sum(nregions)+1) && max_life_tags>(nyrs-xx+1)) //add not recap probability to final entry of temp array with adjustment for release events where model ends before max_life_tags (so NR remains in last state)
              {
               tag_prop_final(i,n,x,a,(max_life_tags*sum(nregions)+1))=tag_prop_not_rec(i,n,x,a);  //for estimation model will use this version of tag_prop in likelihood
              }
            }
           }
          }
         }
        }


 if(fit_tag_age_switch==1) //only fit cohorts by region not age
 {
 for (int i=1;i<=npops;i++)
  {
   for (int n=1;n<=nregions(i);n++)
    {
    for(int x=1; x<=nyrs_release; x++)
     {
      xx=yrs_releases(x);
      for (int a=1;a<=nages;a++) //release age //because accounting for release age, don't need to account for recap age, just adjust mortality and T, to use plus group value if recapture age exceeds max age
        {
         for(int y=1;y<=min(max_life_tags,nyrs-xx+1);y++)  //recap year
          {
           for(int j=1;j<=npops;j++) //recap stock
            {
             for (int r=1;r<=nregions(j);r++)
             {
               tag_recap_no_age_temp(i,n,x,y,j,r,a)=recaps(i,n,x,a,y,j,r);
               total_rec_no_age(i,n,x)=sum(total_rec(i,n,x));
               not_rec_no_age(i,n,x)=sum(not_rec(i,n,x));
             }
            }
           }
          }
        ntags_no_age(i,n,x)=sum(ntags(i,n,x));
       }
      }
     }
 for (int i=1;i<=npops;i++)
  {
   for (int n=1;n<=nregions(i);n++)
    {
    for(int x=1; x<=nyrs_release; x++)
     {
      xx=yrs_releases(x);
      for (int a=1;a<=nages;a++) //release age //because accounting for release age, don't need to account for recap age, just adjust mortality and T, to use plus group value if recapture age exceeds max age
        {
         for(int y=1;y<=min(max_life_tags,nyrs-xx+1);y++)  //recap year
          {
           for(int j=1;j<=npops;j++) //recap stock
            {
             for (int r=1;r<=nregions(j);r++)
             {
              if(ntags_no_age(i,n,x)>0)
               {
                tag_prop_no_age(i,n,x,y,j,r)=sum(tag_recap_no_age_temp(i,n,x,y,j,r))/ntags_no_age(i,n,x);
                tag_prop_not_rec_no_age(i,n,x)=not_rec_no_age(i,n,x)/ntags_no_age(i,n,x);
               }
              if(ntags_no_age(i,n,x)==0)
               {                   
                tag_prop_no_age(i,n,x,y,j,r)=0;
                tag_prop_not_rec_no_age(i,n,x)=0;
               }
             } 
            }
           }
          }
         }
        }
       }

 for (int i=1;i<=npops;i++)
  {
   for (int n=1;n<=nregions(i);n++)
    {
    for(int x=1; x<=nyrs_release; x++)
     {
      xx=yrs_releases(x);
         for(int y=1;y<=min(max_life_tags,nyrs-xx+1);y++)  //recap year
          {
           for(int j=1;j<=npops;j++) //recap stock
            {
             for (int r=1;r<=nregions(j);r++)
             {
              tag_prop_temp(j,y,r)=0; //for whatever reason ADMB won't let a 3darray=double...this is workaround for total_recap_temp=0;, ie setting temp 3darray to 0 after loops through all years 
             }
            }
           }
         for(int y=1;y<=min(max_life_tags,nyrs-xx+1);y++)  //recap year
          {
           for(int j=1;j<=npops;j++) //recap stock
            {
             for (int r=1;r<=nregions(j);r++) //recap region
              {
               tag_prop_temp(j,y,r)=tag_prop_no_age(i,n,x,y,j,r); //fill temp array with a single release cohort's recapture probabilities (excluding not recaptured)
              }
            }
           }
         //tag_prop_temp2=0;
         for(int y=1;y<=min(max_life_tags,nyrs-xx+1);y++)  //recap year
          {
           for(int j=1;j<=npops;j++) //recap stock
            {
             for (int r=1;r<=nregions(j);r++)
              {
               tag_prop_temp2_no_age(i,n,x,((y-1)*sum(nregions)+nreg_temp(j)+r))=tag_prop_temp(j,y,r); //stack array into single vector by year, population, region
              }
             }
            }
             for(int s=1;s<=(max_life_tags*sum(nregions)+1);s++) //create temp array that has columns of recap prob for each release cohort and add not recap probability to final entry of temp array
              {
              if(s<(min(max_life_tags,nyrs-xx+1)*sum(nregions)+1))
              {
               tag_prop_final_no_age(i,n,x,s)=tag_prop_temp2_no_age(i,n,x,s);
              }
              if(s==(min(max_life_tags,nyrs-xx+1)*sum(nregions)+1) && max_life_tags<=(nyrs-xx+1)) //add not recap probability to final entry of temp array
              {
               tag_prop_final_no_age(i,n,x,s)=tag_prop_not_rec_no_age(i,n,x);  //for estimation model will use this version of tag_prop in likelihood
              }
              if(s==(min(max_life_tags,nyrs-xx+1)*sum(nregions)+1) && max_life_tags>(nyrs-xx+1)) //add not recap probability to final entry of temp array with adjustment for release events where model ends before max_life_tags (so NR remains in last state)
              {
               tag_prop_final_no_age(i,n,x,(max_life_tags*sum(nregions)+1))=tag_prop_not_rec_no_age(i,n,x);  //for estimation model will use this version of tag_prop in likelihood
              }
            }
           }
          }
         }
        } //end tag_age_switch_loop
        
    } //end do_tag loop

FUNCTION evaluate_the_objective_function
   //f=dummy; //in case all the estimated parameters are turned off

   f=0.0;

  Bpen_like.initialize();
  Tpen_like.initialize();
  F_pen_like.initialize();
  M_pen_like.initialize();
  catch_like.initialize();
  fish_age_like.initialize();
  survey_age_like.initialize();
  survey_like.initialize();
  tag_like.initialize();
  tag_like_temp.initialize();
  rec_like.initialize();
  init_abund_pen.initialize();
  Rave_pen.initialize();


 // Calculate multinomial likelihoods for compositions (Fournier style)
//  2nd term (-obs*log(obs) lets the multinomial likelihood equal zero when the observed and
//     predicted are equal as in Fournier (1990) "robustifies"
 //  survey biomass lognormal likelihood
      for (int j=1;j<=npops;j++)
     {
       for (int r=1;r<=nregions(j);r++)
       {
          for (int y=1;y<=nyrs;y++) //need to alter to fit number of years of catch data
           {
             for (int z=1;z<=nfleets_survey(j);z++)
              {
                if(OBS_survey_fleet_bio(j,r,y,z)>0) //only count like for years where CPUE is observed
                {
                  if(diagnostics_switch==1) //use true observations, no measurement error
                  {
                   survey_like +=   square((log(survey_fleet_bio_TRUE(j,r,y,z)+0.0001)-log(survey_fleet_bio(j,r,y,z)+0.0001)))/ (2.*square(OBS_survey_fleet_bio_se(j,r,y,z))); //OBS_survey_fleet_bio(j,r,y,z))));
                   survey_age_like -= OBS_survey_prop_N(j,r,y,z) * (((survey_fleet_prop_TRUE(j,r,y,z)+0.001)*log(survey_at_age_fleet_prop(j,r,y,z)+0.001))-((survey_fleet_prop_TRUE(j,r,y,z)+0.001)*log(survey_fleet_prop_TRUE(j,r,y,z)+0.001)));
                  }
                   
                  if(diagnostics_switch==0) //use observed values with measurement error
                  {
                   survey_like +=  square((log(OBS_survey_fleet_bio(j,r,y,z)+0.0001)-log(survey_fleet_bio(j,r,y,z)+0.0001) ))/ (2.*square(OBS_survey_fleet_bio_se(j,r,y,z))); //OBS_survey_fleet_bio(j,r,y,z))));
                   survey_age_like -= OBS_survey_prop_N(j,r,y,z) * (((OBS_survey_prop(j,r,y,z)+0.001)*log(survey_at_age_fleet_prop(j,r,y,z)+0.001))-((OBS_survey_prop(j,r,y,z)+0.001)*log(OBS_survey_prop(j,r,y,z)+0.001)));
                  }
                }
             }
            }
           }
          }
           
     // catch likelihood and multinomial fishery ages
   for (int j=1;j<=npops;j++)
     {
       for (int r=1;r<=nregions(j);r++)
       {
          for (int y=1;y<=nyrs;y++) //need to alter to fit number of years of catch data
           {
             for (int z=1;z<=nfleets(j);z++)
              {

              if(catch_num_switch==1) //if catch is entered as numbers
              {
                if(diagnostics_switch==1) //use true observations, no measurement error
                {
                 catch_like+= square((log(yield_fleet_TRUE(j,r,y,z)+0.0001)-log(yieldN_fleet(j,r,y,z)+0.0001)) )/ (2.*square(OBS_yield_fleet_se(j,r,y,z))); //OBS_yield_fleet(j,r,y,z))));
                 fish_age_like -= OBS_catch_at_age_fleet_prop_N(j,r,y,z)*(((catch_at_age_fleet_prop_TRUE(j,r,y,z)+0.001)*log(catch_at_age_fleet_prop(j,r,y,z)+0.001))-((catch_at_age_fleet_prop_TRUE(j,r,y,z)+0.001)*log(catch_at_age_fleet_prop_TRUE(j,r,y,z)+0.001)));
                }
                if(diagnostics_switch==0) //use observed values with measurement error
                {
                  if(OBS_yield_fleet(j,r,y,z)>0){
                 catch_like+= square((log(OBS_yield_fleet(j,r,y,z)+0.0001)-log(yieldN_fleet(j,r,y,z)+0.0001) ))/ (2.*square(OBS_yield_fleet_se(j,r,y,z))); //OBS_yield_fleet(j,r,y,z))));
                 fish_age_like -= OBS_catch_at_age_fleet_prop_N(j,r,y,z)*(((OBS_catch_at_age_fleet_prop(j,r,y,z)+0.001)*log(catch_at_age_fleet_prop(j,r,y,z)+0.001))-((OBS_catch_at_age_fleet_prop(j,r,y,z)+0.001)*log(OBS_catch_at_age_fleet_prop(j,r,y,z)+0.001)));
                }
                }
              }
              if(catch_num_switch==0) //if catch is entered as biomass
              {
                if(diagnostics_switch==1) //use true observations, no measurement error
                {
                 catch_like+= square((log(yield_fleet_TRUE(j,r,y,z)+0.0001)-log(yield_fleet(j,r,y,z)+0.0001)) )/ (2.*square(OBS_yield_fleet_se(j,r,y,z))); //OBS_yield_fleet(j,r,y,z))));
                 fish_age_like -= OBS_catch_at_age_fleet_prop_N(j,r,y,z)*(((catch_at_age_fleet_prop_TRUE(j,r,y,z)+0.001)*log(catch_at_age_fleet_prop(j,r,y,z)+0.001))-((catch_at_age_fleet_prop_TRUE(j,r,y,z)+0.001)*log(catch_at_age_fleet_prop_TRUE(j,r,y,z)+0.001)));
                }
                if(diagnostics_switch==0) //use observed values with measurement error
                {
                 catch_like+= square((log(OBS_yield_fleet(j,r,y,z)+0.0001)-log(yield_fleet(j,r,y,z)+0.0001) ))/ (2.*square(OBS_yield_fleet_se(j,r,y,z))); //OBS_yield_fleet(j,r,y,z))));
                 fish_age_like -= OBS_catch_at_age_fleet_prop_N(j,r,y,z)*(((OBS_catch_at_age_fleet_prop(j,r,y,z)+0.001)*log(catch_at_age_fleet_prop(j,r,y,z)+0.001))-((OBS_catch_at_age_fleet_prop(j,r,y,z)+0.001)*log(OBS_catch_at_age_fleet_prop(j,r,y,z)+0.001)));
                }
              }
             }
            }
           }
          }
  
 if(do_tag_mult==1)
  {
  if(fit_tag_age_switch==0) //fit cohorts by age and region
   {
    for (int i=1;i<=npops;i++)
     {
      for (int n=1;n<=nregions(i);n++)
       {
        for(int x=1; x<=nyrs_release; x++)
         {
          xx=yrs_releases(x); //actual release years
          for (int a=1;a<=nages;a++) //release age
           {
            if(ntags(i,n,x,a)==0)
             {
              OBS_tag_prop_N(i,n,x,a)==0; //make tag likelihood==0 if there are no releases in a given cohort (i.e., mainly if no releases at young ages due to selectivity==0)
             }
            if(diagnostics_switch==1) //use true values for diagnostic runs
             {
              OBS_tag_prop_final(i,n,x,a)=tag_prop_final_TRUE(i,n,x,a);
             }
            if(max_life_tags<=(nyrs-xx+1)) //complete cohorts so don't need to adjust to avoid recap entries with no possible recaptures
             {
              tag_like -= OBS_tag_prop_N(i,n,x,a) * ((OBS_tag_prop_final(i,n,x,a)+0.001)*log(tag_prop_final(i,n,x,a)+0.001)-(OBS_tag_prop_final(i,n,x,a)+0.001)*log(OBS_tag_prop_final(i,n,x,a)+0.001)); //doing row multiplication because dropping final 's' subscript
             }
            if(max_life_tags>(nyrs-xx+1)) //need special calcs for incomplete cohorts (ie model ends before end max_life_tags reached)
             {
              tag_like_temp.initialize();
              for(int s=1;s<=(max_life_tags*sum(nregions)+1);s++) 
               {
                if(s<((nyrs-xx+1)*sum(nregions)+1)) //years with recaps get added to likelihood, index<first yr where yr_release+age_tag>nyrs
                 {
                  tag_like_temp +=(OBS_tag_prop_final(i,n,x,a,s)+0.001)*log(tag_prop_final(i,n,x,a,s)+0.001)-(OBS_tag_prop_final(i,n,x,a,s)+0.001)*log(OBS_tag_prop_final(i,n,x,a,s)+0.001);
                 }
                if(s==((nyrs-xx+1)*sum(nregions)+1)) //skip to not recaptured state once you get to first year where age_tag+yr_release>nyrs (i.e. skip years where no possible recaps), 
                 {
                  tag_like_temp += (OBS_tag_prop_final(i,n,x,a,(max_life_tags*sum(nregions)+1))+0.001)*log(tag_prop_final(i,n,x,a,(max_life_tags*sum(nregions)+1))+0.001)-(OBS_tag_prop_final(i,n,x,a,(max_life_tags*sum(nregions)+1))+0.001)*log(OBS_tag_prop_final(i,n,x,a,(max_life_tags*sum(nregions)+1))+0.001);
                 }
               }
              tag_like -= OBS_tag_prop_N(i,n,x,a)*tag_like_temp; //only multiply eff_N by total likelihood for a cohort to avoid over emphasizing data
             }
           }
          }
         }
        }
      }
      
  if(fit_tag_age_switch==1) //only fit cohorts by region not age
   {
    for (int i=1;i<=npops;i++)
    {
     for (int n=1;n<=nregions(i);n++)
      {
       for(int x=1; x<=nyrs_release; x++)
        {
         xx=yrs_releases(x); //actual release years
          if(ntags_no_age(i,n,x)==0)
           {
            OBS_tag_prop_N(i,n,x,1)==0; //make tag likelihood==0 if there are no releases in a given cohort (i.e., mainly if no releases at young ages due to selectivity==0)
           }
          if(diagnostics_switch==1) //use true values for diagnostic runs
           {
            OBS_tag_prop_final_no_age(i,n,x)=tag_prop_final_TRUE_no_age(i,n,x);
           }
          if(max_life_tags<=(nyrs-xx+1)) //complete cohorts so don't need to adjust to avoid recap entries with no possible recaptures
           {
            tag_like -= OBS_tag_prop_N(i,n,x,1) * ((OBS_tag_prop_final_no_age(i,n,x)+0.001)*log(tag_prop_final_no_age(i,n,x)+0.001)-(OBS_tag_prop_final_no_age(i,n,x)+0.001)*log(OBS_tag_prop_final_no_age(i,n,x)+0.001)); //doing row multiplication because dropping final 's' subscript
           }
          if(max_life_tags>(nyrs-xx+1)) //need special calcs for incomplete cohorts (ie model ends before end max_life_tags reached)
           {
            tag_like_temp.initialize();
            for(int s=1;s<=(max_life_tags*sum(nregions)+1);s++) 
             {
              if(s<((nyrs-xx+1)*sum(nregions)+1)) //years with recaps get added to likelihood, index<first yr where yr_release+age_tag>nyrs
               {
                tag_like_temp +=(OBS_tag_prop_final_no_age(i,n,x,s)+0.001)*log(tag_prop_final_no_age(i,n,x,s)+0.001)-(OBS_tag_prop_final_no_age(i,n,x,s)+0.001)*log(OBS_tag_prop_final_no_age(i,n,x,s)+0.001);
               }
              if(s==((nyrs-xx+1)*sum(nregions)+1)) //skip to not recaptured state once you get to first year where age_tag+yr_release>nyrs (i.e. skip years where no possible recaps), 
               {
                tag_like_temp += (OBS_tag_prop_final_no_age(i,n,x,(max_life_tags*sum(nregions)+1))+0.001)*log(tag_prop_final_no_age(i,n,x,(max_life_tags*sum(nregions)+1))+0.001)-(OBS_tag_prop_final_no_age(i,n,x,(max_life_tags*sum(nregions)+1))+0.001)*log(OBS_tag_prop_final_no_age(i,n,x,(max_life_tags*sum(nregions)+1))+0.001);
               }
             }
            tag_like -= OBS_tag_prop_N(i,n,x,1)*tag_like_temp; //only multiply eff_N by total likelihood for a cohort to avoid over emphasizing data
           }
         }
        }
       }
      }

    } //end do_tag_mult loop

// if(do_tag_mult==0)
//  {
//   for (int i=1;i<=npops;i++)
//  {
//   for (int n=1;n<=nregions(i);n++)
//    {
//    for(int x=1; x<=nyrs_release; x++)
//     {
//           xx=yrs_releases(x);
///      for (int a=1;a<=nages;a++) //release age //because accounting for release age, don't need to account for recap age, just adjust mortality and T, to use plus group value if recapture age exceeds max age
 //       {
 ///        for(int y=1;y<=min(max_life_tags,nyrs-xx+1);y++)  //recap year
  //        {  
   //       for(int j=1;j<=npops;j++) //recap stock
    //        {
    //         for (int r=1;r<=nregions(j);r++)
     //        {
      
    //         tag_like -= log_negbinomial_density(OBS_recaps(i,n,x,a,y,j,r),recaps(i,n,x,a,y,j,r)+0.00001,theta);  //negative binomial tag likelihood
     //       }}}}}}} 
  // I have done Poisson and negative-binomial, if you want multinomial than that's up to you
  // Right now this has a 7d array for recaps and a 6d for OBS
 // }





//VARIOUS PENALTY FUNCTIONS
  //

 if(move_pen_switch>0) //penalizes large and small values of estimated T parameter, because can get lost in log space esp at very large or small values of true T
  {
  if(move_pen_switch==1) //penalizes large and small values of estimated T parameter, because can get lost in log space esp at very large or small values of true T
   {
   if (phase_T_YR>0)
    {
     Tpen_like+= (norm2(ln_T_YR-Tpen));
    }
    if (phase_T_YR_ALT_FREQ>0)
     {
      Tpen_like+= (norm2(ln_T_YR_ALT_FREQ-Tpen));
     }
    if (phase_T_YR_AGE_ALT_FREQ>0)
     {
      Tpen_like+= (norm2(ln_T_YR_AGE_ALT_FREQ-Tpen));
     }
    if (phase_T_CNST_AGE>0)
    {
     Tpen_like+= (norm2(ln_T_CNST_AGE-Tpen));
    }
    if (phase_T_YR_AGE>0)
    {
     Tpen_like+= (norm2(ln_T_YR_AGE-Tpen));
    }
    if (phase_T_CNST>0)
    {
     Tpen_like+= (norm2(ln_T_CNST-Tpen));
    }
    if (phase_T_YR_AGE_ALT_FREQ_no_AG1>0)
     {
      Tpen_like+= (norm2(ln_T_YR_AGE_ALT_FREQ_no_AG1-Tpen));
     }
    if (phase_T_CNST_AGE_no_AG1>0)
    {
     Tpen_like+= (norm2(ln_T_CNST_AGE_no_AG1-Tpen));
    }
    if (phase_T_YR_AGE_no_AG1>0)
    {
     Tpen_like+= (norm2(ln_T_YR_AGE_no_AG1-Tpen));
    }
   }

  if(move_pen_switch==2) //penalizes large and small values of estimated T parameter, because can get lost in log space esp at very large or small values of true T
   {

  T_lgth2=sum(nregions);
  T_lgth_YR2=sum(nregions)*nyrs;
  T_lgth_YR_ALT_FREQ2=sum(nregions)*floor(((nyrs-1)/T_est_freq)+1);
  T_lgth_YR_AGE_ALT_FREQ2=sum(nregions)*floor(((nyrs-1)/T_est_freq)+1)*floor(((nages-1)/T_est_age_freq)+1);
  T_lgth_AGE2=sum(nregions)*nages;
  T_lgth_YR_AGE2=sum(nregions)*nages*nyrs;
  T_lgth_YR_AGE_ALT_FREQ2_no_AG1=sum(nregions)*floor(((nyrs-1)/T_est_freq)+1)*floor(((nages-2)/T_est_age_freq)+1);
  T_lgth_AGE2_no_AG1=sum(nregions)*(nages-1);
  T_lgth_YR_AGE2_no_AG1=sum(nregions)*(nages-1)*nyrs;
  
   if (phase_T_YR>0)
    {
     for (int i=1;i<=T_lgth_YR2;i++)
      {
       for (int n=1;n<=T_lgth2-1;n++)
        {   
         Tpen_like+=dnorm(ln_T_YR(i,n),Tpen,sigma_Tpen_EM);
        }
       }
      }
    if (phase_T_YR_ALT_FREQ>0)
     {
      for (int i=1;i<=T_lgth_YR_ALT_FREQ2;i++)
       {
        for (int n=1;n<=T_lgth2-1;n++)
         {   
          Tpen_like+=dnorm(ln_T_YR_ALT_FREQ(i,n),Tpen,sigma_Tpen_EM);
         }
        }
       }
    if (phase_T_YR_AGE_ALT_FREQ>0)
     {
      for (int i=1;i<=T_lgth_YR_AGE_ALT_FREQ2;i++)
       {
        for (int n=1;n<=T_lgth2-1;n++)
         {        
           Tpen_like+=dnorm(ln_T_YR_AGE_ALT_FREQ(i,n),Tpen,sigma_Tpen_EM);
         }
       }
     }
    if (phase_T_CNST_AGE>0)
    {
     for (int i=1;i<=T_lgth_AGE2;i++)
      {
       for (int n=1;n<=T_lgth2-1;n++)
        {   
         Tpen_like+=dnorm(ln_T_CNST_AGE(i,n),Tpen,sigma_Tpen_EM);
        }
       }
      }
    if (phase_T_YR_AGE>0)
    {
     for (int i=1;i<=T_lgth_YR_AGE2;i++)
      {
       for (int n=1;n<=T_lgth2-1;n++)
        {   
         Tpen_like+=dnorm(ln_T_YR_AGE(i,n),Tpen,sigma_Tpen_EM);
        }
       }
      }
    if (phase_T_CNST>0)
    {
     for (int i=1;i<=T_lgth2;i++)
      {
       for (int n=1;n<=T_lgth2-1;n++)
        {   
         Tpen_like+=dnorm(ln_T_CNST(i,n),Tpen,sigma_Tpen_EM);
        }
       }
      }
    if (phase_T_YR_AGE_ALT_FREQ_no_AG1>0)
     {
      for (int i=1;i<=T_lgth_YR_AGE_ALT_FREQ2_no_AG1;i++)
       {
        for (int n=1;n<=T_lgth2-1;n++)
         {        
           Tpen_like+=dnorm(ln_T_YR_AGE_ALT_FREQ_no_AG1(i,n),Tpen,sigma_Tpen_EM);
         }
       }
     }
    if (phase_T_CNST_AGE_no_AG1>0)
    {
     for (int i=1;i<=T_lgth_AGE2_no_AG1;i++)
      {
       for (int n=1;n<=T_lgth2-1;n++)
        {   
         Tpen_like+=dnorm(ln_T_CNST_AGE_no_AG1(i,n),Tpen,sigma_Tpen_EM);
        }
       }
      }
    if (phase_T_YR_AGE_no_AG1>0)
    {
     for (int i=1;i<=T_lgth_YR_AGE2_no_AG1;i++)
      {
       for (int n=1;n<=T_lgth2-1;n++)
        {   
         Tpen_like+=dnorm(ln_T_YR_AGE_no_AG1(i,n),Tpen,sigma_Tpen_EM);
        }
       }
      }

   }
  }
 //if(active(ln_rec_devs_RN))
// {
// for(int j=1;j<=npops;j++) {  //is this correct?  we aren't penalizing against devs from Rave or SR function?  also we do want to do calcs across all years right (since not including year index in rec_devs here)?
// rec_like += (norm2(ln_rec_devs_RN(j)+sigma_recruit(j)*sigma_recruit(j)/2.)/(2.*square(sigma_recruit(j))) + (size_count(ln_rec_devs_RN(j)))*log(sigma_recruit(j))); 
// }}
 if(active(ln_rec_devs))
   {
     for(int j=1;j<=npops;j++)
      {
       rec_like+=dnorm(ln_rec_devs(j),0,sigma_recruit(j));
      }
    }

  
 if(abund_pen_switch==1)
 {
  if (active(ln_init_abund))
  {
      init_abund_pen+= norm2(ln_init_abund-mean_N);
    } 
   }
  
 if(Rave_pen_switch==1)
 {
  if (active(ln_R_ave))
  {
      Rave_pen+= norm2(ln_R_ave-Rave_mean);
    } 
   }
  
 if(active(ln_F))   /// Early penalty to keep F under wraps
  {
    if (last_phase()==0)
    {
     F_pen_like+= (norm2(mfexp(ln_F)));
    }
    if (F_pen_like >= F_pen_like_early) //Add a catch to report early penalty values
    {
     F_pen_like_early = F_pen_like;
    }
  }
  
 if(active(ln_M_CNST))   /// Early penalty to keep M under wraps
  {
    if (last_phase()==0)
    {
     M_pen_like+= (square(mfexp(ln_M_CNST)));
    }
    if (M_pen_like >= M_pen_like_early) //Add a catch to report early penalty values
    {
     M_pen_like_early = M_pen_like;
    }
  }

 if(active(ln_M_pop_CNST))   /// Early penalty to keep M under wraps
  {
    if (last_phase()==0)
    {
     M_pen_like+= (norm2(mfexp(ln_M_pop_CNST)));
    }
    if (M_pen_like >= M_pen_like_early) //Add a catch to report early penalty values
    {
     M_pen_like_early = M_pen_like;
    }    
  }

 if(active(ln_M_age_CNST))   /// Early penalty to keep M under wraps
  {
    if (last_phase()==0)
    {
     M_pen_like+= (norm2(mfexp(ln_M_age_CNST)));
    }
    if (M_pen_like >= M_pen_like_early) //Add a catch to report early penalty values
    {
     M_pen_like_early = M_pen_like;
    }
  }

 if(active(ln_M_pop_age))   /// Early penalty to keep M under wraps
  {
    if (last_phase()==0)
    {
     M_pen_like+= (norm2(mfexp(ln_M_pop_age)));
    }
    if (M_pen_like >= M_pen_like_early) //Add a catch to report early penalty values
    {
     M_pen_like_early = M_pen_like;
    }
  }


    if(active(ln_rep_rate_YR) || active(ln_rep_rate_CNST))
     {
     for (int j=1;j<=npops;j++)
      {
       for (int r=1;r<=nregions(j);r++)
        {
         for(int y=1; y<=nyrs_release; y++)
          {
            Bpen_like+=log(square(report_rate_sigma))+(square(report_rate(j,y,r)-report_rate_ave)/(2*square(report_rate_sigma)));
          }
        }
      }
     }


// Sum objective function
   f           += survey_like*wt_srv;
   f           += catch_like*wt_catch;
   f           += fish_age_like*wt_fish_age;
   f           += survey_age_like*wt_srv_age;
   f           += rec_like*wt_rec;
   f           += tag_like*wt_tag;
   f           += init_abund_pen*wt_abund_pen;
   f           += Tpen_like*wt_T_pen;   
   f           += F_pen_like*wt_F_pen;
   f           += M_pen_like*wt_M_pen;
   f           += Bpen_like*wt_B_pen;
   f           += Rave_pen*wt_Rave_pen;

REPORT_SECTION
    //likelihoods
  report<<"$likelihood components"<<endl;
  report<<"$f"<<endl;
  report<<f<<endl;
  report<<"$tag_like"<<endl;
  report<<tag_like*wt_tag<<endl;
  report<<"$fish_age_like"<<endl;
  report<<fish_age_like*wt_fish_age<<endl;
  report<<"$survey_age_like"<<endl;
  report<<survey_age_like*wt_srv_age<<endl;
  report<<"$survey_like"<<endl;
  report<<survey_like*wt_srv<<endl;
  report<<"$catch_like"<<endl;
  report<<catch_like*wt_catch<<endl;
  report<<"$rec_like"<<endl;
  report<<rec_like*wt_rec<<endl;
  report<<"$Tpen_like"<<endl;
  report<<Tpen_like*wt_T_pen<<endl;
  report<<"$F_pen_like"<<endl;
  report<<F_pen_like*wt_F_pen<<endl;
  report<<"$early_F_pen_like"<<endl;
  report<<F_pen_like_early*wt_F_pen<<endl;
  report<<"$M_pen_like"<<endl;
  report<<M_pen_like*wt_M_pen<<endl;
  report<<"$early_M_pen_like"<<endl;
  report<<M_pen_like_early*wt_M_pen<<endl;
  report<<"$Bpen_like"<<endl;
  report<<Bpen_like*wt_B_pen<<endl;
  report<<"$abund_dev_pen"<<endl;
  report<<init_abund_pen*wt_abund_pen<<endl;
  report<<"$Rave_pen"<<endl;
  report<<Rave_pen*wt_Rave_pen<<endl;

//use these to determine which movement graphs to use in sim wrappers
  report<<"$ph_T_YR"<<endl;
  report<<phase_T_YR<<endl;
  report<<"$ph_T_CNST"<<endl;
  report<<phase_T_CNST<<endl;
  report<<"$ph_T_CNST_AGE"<<endl;
  report<<phase_T_CNST_AGE<<endl;
  report<<"$ph_T_YR_AGE"<<endl;
  report<<phase_T_YR_AGE<<endl;
  report<<"$move_switch_OM"<<endl;
  report<<move_switch_OM<<endl;
  report<<"$DD_move_age_switch_OM"<<endl;
  report<<DD_move_age_switch_OM<<endl;
  
//EM structure
  report<<"$nages"<<endl;
  report<<nages<<endl;
  report<<"$nyrs"<<endl;
  report<<nyrs<<endl;
  report<<"$npops"<<endl;
  report<<npops<<endl;
  report<<"$nregions"<<endl;
  report<<nregions<<endl;
  report<<"$nfleets"<<endl;
  report<<nfleets<<endl;
  report<<"$nfleets_survey"<<endl;
  report<<nfleets_survey<<endl;

///OM structure
  report<<"$npops_OM"<<endl;
  report<<npops_OM<<endl;
  report<<"$nregions_OM"<<endl;
  report<<nregions_OM<<endl;
  report<<"$nfleets_OM"<<endl;
  report<<nfleets_OM<<endl;
  report<<"$nfleets_survey_OM"<<endl;
  report<<nfleets_survey_OM<<endl;

  report<<"$sigma_recruit"<<endl;
  report<<sigma_recruit<<endl;

  report<<"$M"<<endl;
  report<<M<<endl;
  report<<"$M_TRUE"<<endl;
  report<<input_M_TRUE<<endl;
 //EST values
  //report<<"$T_terminal"<<endl; ///need to fix this for reporting out the 6D array
  //report<<T_terminal<<endl;

  report<<"$Init_Abund"<<endl;
  report<<init_abund<<endl;
  report<<"$alpha"<<endl;
  report<<alpha<<endl;
  report<<"$beta"<<endl;
  report<<beta<<endl;
  report<<"$input_T"<<endl;
  report<<input_T<<endl;
  report<<"$q_survey"<<endl;
  report<<q_survey<<endl;
  report<<"$sel_beta1"<<endl;
  report<<sel_beta1<<endl;
  report<<"$sel_beta2"<<endl;
  report<<sel_beta2<<endl;
  report<<"$sel_beta3"<<endl;
  report<<sel_beta3<<endl;
  report<<"$sel_beta4"<<endl;
  report<<sel_beta4<<endl;
  report<<"$sel_beta1_survey"<<endl;
  report<<sel_beta1surv<<endl;
  report<<"$sel_beta2_survey"<<endl;
  report<<sel_beta2surv<<endl;
  report<<"$sel_beta3_survey"<<endl;
  report<<sel_beta3surv<<endl;
  report<<"$sel_beta4_survey"<<endl;
  report<<sel_beta4surv<<endl;
  report<<"$steep"<<endl;
  report<<steep<<endl;
  report<<"$R_ave"<<endl;
  report<<R_ave<<endl;
  report<<"$SSB_zero"<<endl;
  report<<SSB_zero<<endl; 
  report<<"$rec_devs"<<endl;
  report<<rec_devs<<endl;
  report<<"$Rec_Prop"<<endl;
  report<<Rec_Prop<<endl;
  report<<"$recruits_BM"<<endl;
  report<<recruits_BM<<endl;
  report<<"$F"<<endl;
  report<<F<<endl;
  report<<"$F_year"<<endl;
  report<<F_year<<endl;
  
  report<<"$biomass_AM"<<endl;
  report<<biomass_AM<<endl;
  report<<"$biomass_population"<<endl;
  report<<biomass_population<<endl;
  report<<"$harvest_rate_region_bio"<<endl;
  report<<harvest_rate_region_bio<<endl;
  report<<"$depletion_region"<<endl;
  report<<depletion_region<<endl;
  report<<"$SSB_region"<<endl;
  report<<SSB_region<<endl;
  report<<"$Bratio_population"<<endl;
  report<<Bratio_population<<endl;
  report<<"$survey_fleet_bio"<<endl;
  report<<survey_fleet_bio<<endl;
  report<<"$yield_fleet"<<endl;
  report<<yield_fleet<<endl;
  report<<"$yieldN_fleet"<<endl;
  report<<yieldN_fleet<<endl;

  report<<"$total_recruit"<<endl;
  report<<total_recruits<<endl;
  report<<"$SR"<<endl;
  report<<SR<<endl;
  report<<"$frac_natal"<<endl;
  report<<frac_natal<<endl;


 /// TRUE VALUES
  report<<"$input_T"<<endl;
  report<<input_T<<endl;
  report<<"$report_rate_TRUE"<<endl;
  report<<report_rate_TRUE<<endl;
  report<<"$T_year_TRUE"<<endl;
  report<<T_year_TRUE<<endl;
  report<<"$q_survey_TRUE"<<endl;
  report<<q_survey_TRUE<<endl;
  report<<"$sel_beta1_TRUE"<<endl;
  report<<sel_beta1_TRUE<<endl;
  report<<"$sel_beta2_TRUE"<<endl;
  report<<sel_beta2_TRUE<<endl;
  report<<"$sel_beta3_TRUE"<<endl;
  report<<sel_beta3_TRUE<<endl;
  report<<"$sel_beta4_TRUE"<<endl;
  report<<sel_beta4_TRUE<<endl;
  report<<"$sel_beta1_survey_TRUE"<<endl;
  report<<sel_beta1_survey_TRUE<<endl;
  report<<"$sel_beta2_survey_TRUE"<<endl;
  report<<sel_beta2_survey_TRUE<<endl;
  report<<"$sel_beta3_survey_TRUE"<<endl;
  report<<sel_beta3_survey_TRUE<<endl;
  report<<"$sel_beta4_survey_TRUE"<<endl;
  report<<sel_beta4_survey_TRUE<<endl; 
  report<<"$steep_TRUE"<<endl;
  report<<steep_TRUE<<endl;
  report<<"$R_ave_TRUE"<<endl;
  report<<R_ave_TRUE<<endl;
  report<<"$SSB_zero_TRUE"<<endl;
  report<<SSB_zero_TRUE<<endl; 
  report<<"$rec_devs_TRUE"<<endl;
  report<<rec_devs_TRUE<<endl;
  report<<"$Rec_Prop_TRUE"<<endl;
  report<<Rec_Prop_TRUE<<endl;
  report<<"$recruits_BM_TRUE"<<endl;
  report<<recruits_BM_TRUE<<endl;
  report<<"$F_TRUE"<<endl;
  report<<F_TRUE<<endl;
  report<<"$F_year_TRUE"<<endl;
  report<<F_year_TRUE<<endl;
  report<<"$Init_Abund_TRUE"<<endl;
  report<<init_abund_TRUE<<endl;
  report<<"$Init_Abund_Devs"<<endl;
  report<<init_abund_age<<endl;
  report<<"$biomass_AM_TRUE"<<endl;
  report<<biomass_AM_TRUE<<endl;
  report<<"$biomass_population_TRUE"<<endl;
  report<<biomass_population_TRUE<<endl;
  report<<"$harvest_rate_region_bio_TRUE"<<endl;
  report<<harvest_rate_region_bio_TRUE<<endl;
  report<<"$depletion_region_TRUE"<<endl;
  report<<depletion_region_TRUE<<endl;
  report<<"$SSB_region_TRUE"<<endl;
  report<<SSB_region_TRUE<<endl;
  report<<"$Bratio_population_TRUE"<<endl;
  report<<Bratio_population_TRUE<<endl;

//OBS simulated data for lower dimensional arrays
  if(diagnostics_switch==1){
    report<<"$OBS_survey_fleet_bio"<<endl;
    report<<survey_fleet_bio_TRUE<<endl;
    report<<"$OBS_yield_fleet"<<endl;
    report<<yield_fleet_TRUE<<endl;
    }

 if(diagnostics_switch==0){
    report<<"$OBS_survey_fleet_bio"<<endl;
    report<<OBS_survey_fleet_bio<<endl;
    report<<"$OBS_yield_fleet"<<endl;
    report<<OBS_yield_fleet<<endl;
    }

/// TAG INFORMATION
  report<<"$nyrs_release"<<endl;
  report<<nyrs_release<<endl;
  report<<"$years_of_tag_releases "<<endl;
  report<<yrs_releases<<endl;
  report<<"$max_life_tags"<<endl;
  report<<max_life_tags<<endl;
  report<<"$report_rate"<<endl;
  report<<report_rate<<endl;
  report<<"$ntags_total"<<endl;
  report<<ntags_total<<endl;
  report<<"$ntags"<<endl;
  report<<ntags<<endl;


//Additional Params
  report<<"$selectivity_age"<<endl;
  report<<selectivity_age<<endl;
  report<<"$selectivity_age_TRUE"<<endl;
  report<<selectivity_age_TRUE<<endl;
  report<<"$survey_selectivity_age"<<endl;
  report<<survey_selectivity_age<<endl;
  report<<"$survey_selectivity_age_TRUE"<<endl;
  report<<survey_selectivity_age_TRUE<<endl;



////////////////////////////////////////////////////////////////////
//reporting hi dimensional arrays
 if(npops==1)// for panmictic and metamictic population outputs
     {
        report<<"$T_year"<<endl;
        report<<T_year<<endl;

        report<<"$T_est"<<endl;
        report<<T<<endl;
        report<<"$T_true"<<endl;
        report<<T_true_report<<endl;
        report<<"$EST_survey_prop"<<endl;
        report<<survey_at_age_fleet_prop<<endl;
        report<<"$EST_catch_age_fleet_prop"<<endl;
        report<<catch_at_age_fleet_prop<<endl;
        report<<"$EST_tag_prop_final"<<endl;
        report<<tag_prop_final<<endl;

     if(diagnostics_switch==1){
       report<<"$OBS_survey_prop"<<endl;
       report<<survey_fleet_prop_TRUE<<endl;
       report<<"$OBS_catch_prop"<<endl;
       report<<catch_at_age_fleet_prop_TRUE<<endl;
       report<<"$OBS_tag_prop_final"<<endl;
       report<<tag_prop_final_TRUE<<endl;
      }

     if(diagnostics_switch==0){
      report<<"$OBS_survey_prop"<<endl;
      report<<OBS_survey_prop<<endl;
      report<<"$OBS_catch_prop"<<endl;
      report<<OBS_catch_at_age_fleet_prop<<endl;
      report<<"$OBS_tag_prop_final"<<endl;
      report<<OBS_tag_prop_final<<endl;
      }
     }


 ////////////////////////////////////////////////////////////
 //Printing 5D and 6D arrays by population for metapop 

 if(npops>1) //more than one population or if one population, more than 1 region within that population
  {
  region_counter=1;
    for (int p=1;p<=npops;p++)
     {
      // 5D arrays by population go here

        report<<"$alt_T_year"<<p<<endl;
        report<<T_year[p]<<endl;
        report<<"$T_est"<<p<<endl;
        report<<T[p]<<endl;
        report<<"$T_true"<<p<<endl;
        report<<T_true_report[p]<<endl;
        report<<"$EST_survey_age_prop"<<p<<endl;
        report<<survey_at_age_fleet_prop[p]<<endl;
        report<<"$EST_catch_age_fleet_prop"<<p<<endl;
        report<<catch_at_age_fleet_prop[p]<<endl;
        report<<"$EST_tag_prop_final"<<p<<endl;
        report<<tag_prop_final[p]<<endl;

     //OBS Values
     if(diagnostics_switch==1){
       report<<"$OBS_survey_prop"<<p<<endl;
       report<<survey_fleet_prop_TRUE[p]<<endl;
       report<<"$OBS_catch_prop"<<p<<endl;
       report<<catch_at_age_fleet_prop_TRUE[p]<<endl;
       report<<"$OBS_tag_prop_final"<<p<<endl;
       report<<tag_prop_final_TRUE[p]<<endl;
      }

     if(diagnostics_switch==0){
      report<<"$OBS_survey_prop"<<p<<endl;
      report<<OBS_survey_prop[p]<<endl;
      report<<"$OBS_catch_prop"<<p<<endl;
      report<<OBS_catch_at_age_fleet_prop[p]<<endl;
      report<<"$OBS_tag_prop_final"<<p<<endl;
      report<<OBS_tag_prop_final[p]<<endl;
      }

     }
   }


  //report the abundance_frac from OM for later calcs in wrapper if needed
  report<<"$abund_frac_age_region_OM"<<endl;
  report<<abund_frac_age_region<<endl;
  report<<"$abund_frac_year_OM"<<endl;
  report<<abund_frac_region_year<<endl;
  report<<"$abund_frac_region_OM"<<endl;
  report<<abund_frac_region<<endl;
  report<<"$abund_at_age_BM"<<endl;
  report<<abundance_at_age_BM<<endl;
  report<<"$abund_at_age_AM"<<endl;
  report<<abundance_at_age_AM<<endl;

        report<<"$F_tag_scalar"<<endl;
        report<<F_tag_scalar<<endl;
        report<<"$T_tag_res"<<endl;
        report<<T_tag_res<<endl;
        report<<"$sim_F_tag_scalar"<<endl;
        report<<sim_F_tag_scalar<<endl;
        report<<"$sim_T_tag_res"<<endl;
        report<<sim_T_tag_res<<endl;
        report<<"$est_tag_mixing_switch"<<endl;
        report<<est_tag_mixing_switch<<endl;
        report<<"$sim_tag_mixing_switch"<<endl;
        report<<sim_tag_mixing_switch<<endl;
        report<<"$fit_tag_age_switch"<<endl;
        report<<fit_tag_age_switch<<endl;


  report<<"$dummy_run"<<endl;
  report<<ph_dummy<<endl;

 save_gradients(gradients);


RUNTIME_SECTION
 convergence_criteria .001,.0001, 1.0e-4, 1.0e-4
    maximum_function_evaluations 10000
// convergence_criteria .001
//    maximum_function_evaluations 4000
