#V3.30.13.00-trans-beta;_2018_12_26;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.0
#Stock Synthesis (SS) is a work of the U.S. Government and is not subject to copyright protection in the United States.
#Foreign copyrights may apply. See copyright.txt for more information.
#_user_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_user_info_available_at:https://vlab.ncep.noaa.gov/group/stock-synthesis
#C fishing mortality uses the hybrid method
#_data_and_control_files: data.ss // control.ss
0  # 0 means do not read wtatage.ss; 1 means read and use wtatage.ss and also read and use growth parameters
1  #_N_Growth_Patterns
1 #_N_platoons_Within_GrowthPattern 
#_Cond 1 #_Morph_between/within_stdev_ratio (no read if N_morphs=1)
#_Cond  1 #vector_Morphdist_(-1_in_first_val_gives_normal_approx)
#
3 # recr_dist_method for parameters:  2=main effects for GP, Settle timing, Area; 3=each Settle entity; 4=none, only when N_GP*Nsettle*pop==1
1 # not yet implemented; Future usage: Spawner-Recruitment: 1=global; 2=by area
4 #  number of recruitment settlement assignments 
0 # unused option
#GPattern month  area  age (for each settlement assignment)
 1 1 1 0
 1 1 2 0
 1 1 3 0 
 1 1 4 0
#
6 #_N_movement_definitions
2 # first age that moves (real age at begin of season, not integer)
# seas,GP,source_area,dest_area,minage,maxage
 1 1 1 2 8 9
 1 1 1 4 8 9
 1 1 2 1 8 9
 1 1 3 4 8 9
 1 1 4 1 8 9
 1 1 4 3 8 9
#
1 #_Nblock_Patterns
 1 
# begin and end years of blocks
 1 1
#
# controls for all timevary parameters 
1 #_env/block/dev_adjust_method for all time-vary parms (1=warn relative to base parm bounds; 3=no bound check)
#
# AUTOGEN
1 1 1 1 1 # autogen: 1st element for biology, 2nd for SR, 3rd for Q, 4th reserved, 5th for selex
# where: 0 = autogen all time-varying parms; 1 = read each time-varying parm line; 2 = read then autogen if parm min==-12345
#
#_Available timevary codes
#_Block types: 0: Pblock=Pbase*exp(TVP); 1: Pblock=Pbase+TVP; 2: Pblock=TVP; 3: Pblock=Pblock(-1) + TVP
#_Block_trends: -1: trend bounded by base parm min-max and parms in transformed units (beware); -2: endtrend and infl_year direct values; -3: end and infl as fraction of base range
#_EnvLinks:  1: P(y)=Pbase*exp(TVP*env(y));  2: P(y)=Pbase+TVP*env(y);  3: null;  4: P(y)=2.0/(1.0+exp(-TVP1*env(y) - TVP2))
#_DevLinks:  1: P(y)*=exp(dev(y)*dev_se;  2: P(y)+=env(y)*dev_se;  3: random walk;  4: zero-reverting random walk with rho;  21-24 keep last dev for rest of years
#
#
#
# setup for M, growth, maturity, fecundity, recruitment distibution, movement 
#
3 #_natM_type:_0=1Parm; 1=N_breakpoints;_2=Lorenzen;_3=agespecific;_4=agespec_withseasinterpolate
 #_Age_natmort_by sex x growthpattern
 1.3432 1.3432 1.182 1.0208 0.8596 0.6984 0.5372 0.5372 0.5372 0.5372 0.5372 0.564 0.6424 0.712 0.766 0.7976 0.8036 0.7848 0.746 0.6972 0.6492 0.6088 0.5796 0.5604 0.5492 0.5428 0.5396 0.5384 0.5376
#
3 # GrowthModel: 1=vonBert with L1&L2; 2=Richards with L1&L2; 3=age_specific_K_incr; 4=age_specific_K_decr; 5=age_specific_K_each; 6=NA; 7=NA; 8=growth cessation
1 #_Age(post-settlement)_for_L1;linear growth below this
28 #_Growth_Age_for_L2 (999 to use as Linf)
-999 #_exponential decay for growth above maxage (value should approx initial Z; -999 replicates 3.24; -998 to not allow growth above maxage)
0  #_placeholder for future growth feature
12 # number of K multipliers to read
 2 3 4 5 6 7 8 9 10 11 12 13 # ages for K multiplier
#
0 #_SD_add_to_LAA (set to 0.1 for SS2 V1.x compatibility)
0 #_CV_Growth_Pattern:  0 CV=f(LAA); 1 CV=F(A); 2 SD=F(LAA); 3 SD=F(A); 4 logSD=F(A)
#
3 #_maturity_option:  1=length logistic; 2=age logistic; 3=read age-maturity matrix by growth_pattern; 4=read age-fecundity; 5=disabled; 6=read length-maturity
#_Age_Maturity by growth pattern
 0 0 0 0 0 0.1 0.15 0.2 0.3 0.5 0.7 0.9 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
1 #_First_Mature_Age
1 #_fecundity option:(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b; (4)eggs=a+b*L; (5)eggs=a+b*W
0 #_hermaphroditism option:  0=none; 1=female-to-male age-specific fxn; -1=male-to-female age-specific fxn
1 #_parameter_offset_approach (1=none, 2= M, G, CV_G as offset from female-GP1, 3=like SS2 V1.x)
#
#_growth_parms
#_ LO HI INIT PRIOR PR_SD PR_type PHASE env_var&link dev_link dev_minyr dev_maxyr dev_PH Block Block_Fxn
# Sex: 1  BioPattern: 1  NatMort
# Sex: 1  BioPattern: 1  Growth
 1 45 22 22 10 6 -2 0 0 0 0 0.5 0 0 # L_at_Amin_Fem_GP_1
 120 170 145 145 10 6 -4 0 0 0 0 0.5 0 0 # L_at_Amax_Fem_GP_1
 0.05 0.5 0.455 0.455 0.8 6 -4 0 0 0 0 0.5 0 0 # VonBert_K_Fem_GP_1
 -5 5 0.5 1 1 0 -1 0 0 0 0 0 0 0 # Age_K_Fem_GP_1_a_2
 -15 5 0.75 1 1 0 -1 0 0 0 0 0 0 0 # Age_K_Fem_GP_1_a_3
 -15 5 1 1 1 0 -1 0 0 0 0 0 0 0 # Age_K_Fem_GP_1_a_4
 -15 5 1 1 1 0 -1 0 0 0 0 0 0 0 # Age_K_Fem_GP_1_a_5
 -15 5 1 1 1 0 -1 0 0 0 0 0 0 0 # Age_K_Fem_GP_1_a_6
 -15 5 1.8 1 1 0 -1 0 0 0 0 0 0 0 # Age_K_Fem_GP_1_a_7
 -15 5 1.8 1 1 0 -1 0 0 0 0 0 0 0 # Age_K_Fem_GP_1_a_8
 -15 5 1.2 1 1 0 -1 0 0 0 0 0 0 0 # Age_K_Fem_GP_1_a_9
 -15 5 1.2 1 1 0 -1 0 0 0 0 0 0 0 # Age_K_Fem_GP_1_a_10
 -15 5 1 1 1 0 -1 0 0 0 0 0 0 0 # Age_K_Fem_GP_1_a_11
 -15 5 1 1 1 0 -1 0 0 0 0 0 0 0 # Age_K_Fem_GP_1_a_12
 -15 5 1 1 1 0 -1 0 0 0 0 0 0 0 # Age_K_Fem_GP_1_a_13
 0.05 0.25 0.1 0.1 0.1 6 -3 0 0 0 0 0.5 0 0 # CV_young_Fem_GP_1
 0.05 0.25 0.1 0.1 0.1 6 -3 0 0 0 0 0.5 0 0 # CV_old_Fem_GP_1
# Sex: 1  BioPattern: 1  WtLen
 -3 3 2.459e-05 2.459e-05 0.8 6 -3 0 0 0 0 0.5 0 0 # Wtlen_1_Fem
 -3 4 2.9667 2.9667 0.8 6 -3 0 0 0 0 0.5 0 0 # Wtlen_2_Fem
# Sex: 1  BioPattern: 1  Maturity&Fecundity
 -3 3 1 1 0.8 0 -3 0 0 0 0 0 0 0 # Mat50%_Fem
 -3 3 -0.25 -0.25 0.8 6 -3 0 0 0 0 0 0 0 # Mat_slope_Fem
 -3 3 1 1 0.8 6 -3 0 0 0 0 0.5 0 0 # Eggs/kg_inter_Fem
 -3 3 0 0 0.8 6 -3 0 0 0 0 0.5 0 0 # Eggs/kg_slope_wt_Fem
# Hermaphroditism
#  Recruitment Distribution  
 -5 5 0 0 0 0.25 -3 0 0 0 0 0 0 0 # RecrDist_GP_1_area_1_month_1  #area 1 is the base, so parameter=0.0
 -5 5 -0.319268 0.5 0 0.25 1 0 0 0 0 0 0 0 # RecrDist_GP_1_area_2_month_1   
 -5 5 -0.319268 0.5 0 0.25 1 0 0 0 0 0 0 0 # RecrDist_GP_1_area_3_month_1    
 -5 5 -0.319268 0.5 0 0.25 1 0 0 0 0 0 0 0 # RecrDist_GP_1_area_4_month_1  #  Cohort growth dev base
 0.1 10 1 1 1 6 -1 0 0 0 0 0 0 0 # CohortGrowDev
#  Movement
-15 15  -10 0 4 6 3 0 0 0 0 0 0 0 # MoveParm_A_seas_1_GP_1from_1to_2
-15 15  -10 0 4 6 3 0 0 0 0 0 0 0 # MoveParm_B_seas_1_GP_1from_1to_2
-15 15  -10 0 4 6 3 0 0 0 0 0 0 0 # MoveParm_A_seas_1_GP_1from_1to_4
-15 15  -10 0 4 6 3 0 0 0 0 0 0 0 # MoveParm_B_seas_1_GP_1from_1to_4
-15 15  -10 0 4 6 3 0 0 0 0 0 0 0 # MoveParm_A_seas_1_GP_1from_2to_1
-15 15  -10 0 4 6 3 0 0 0 0 0 0 0 # MoveParm_B_seas_1_GP_1from_2to_1
-15 15  -10 0 4 6 3 0 0 0 0 0 0 0 # MoveParm_A_seas_1_GP_1from_3to_4
-15 15  -10 0 4 6 3 0 0 0 0 0 0 0 # MoveParm_B_seas_1_GP_1from_3to_4
-15 15  -10 0 4 6 3 0 0 0 0 0 0 0 # MoveParm_A_seas_1_GP_1from_4to_1
-15 15  -10 0 4 6 3 0 0 0 0 0 0 0 # MoveParm_B_seas_1_GP_1from_4to_1
-15 15  -10 0 4 6 3 0 0 0 0 0 0 0 # MoveParm_A_seas_1_GP_1from_4to_3
-15 15  -10 0 4 6 3 0 0 0 0 0 0 0 # MoveParm_B_seas_1_GP_1from_4to_3
#  Age Error from parameters
#  catch multiplier
#  fraction female, by GP
 0.000001 0.999999 0.5 0.5  0.5 0 -99 0 0 0 0 0 0 0 # FracFemale_GP_1
#
# timevary MG parameters 
#_ LO HI INIT PRIOR PR_SD PR_type  PHASE
# info on dev vectors created for MGparms are reported with other devs after tag parameter section 
#
#_seasonal_effects_on_biology_parms
 0 0 0 0 0 0 0 0 0 0 #_femwtlen1,femwtlen2,mat1,mat2,fec1,fec2,Malewtlen1,malewtlen2,L1,K
#_ LO HI INIT PRIOR PR_SD PR_type PHASE
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no seasonal MG parameters
#
3 #_Spawner-Recruitment; Options: 2=Ricker; 3=std_B-H; 4=SCAA; 5=Hockey; 6=B-H_flattop; 7=survival_3Parm; 8=Shepherd_3Parm; 9=RickerPower_3parm
0  # 0/1 to use steepness in initial equ recruitment calculation
0  #  future feature:  0/1 to make realized sigmaR a function of SR curvature
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn #  parm_name
            -2            25            10            10             5             6          1          0          0          0          0          0          0          0 # SR_LN(R0)
           0.2             1           0.8           0.8           0.2             6         -1          0          0          0          0          0          0          0 # SR_BH_steep
             0             2           0.6           0.6           0.8             6         -4          0          0          0          0          0          0          0 # SR_sigmaR
            -5             5             0             0             1             6         -4          0          0          0          0          0          0          0 # SR_regime
             0             0             0             0             0             0        -99          0          0          0          0          0          0          0 # SR_autocorr
1 #do_recdev:  0=none; 1=devvector (R=F(SSB)+dev); 2=deviations (R=F(SSB)+dev); 3=deviations (R=R0*dev; dev2=R-f(SSB)); 4=like 3 with sum(dev2) adding penalty
89 # first year of main recr_devs; early devs can preceed this era
256 # last year of main recr_devs; forecast devs start in following year
3 #_recdev phase 
0 # (0/1) to read 13 advanced options
#_Cond 0 #_recdev_early_start (0=none; neg value makes relative to recdev_start)
#_Cond 0 #_recdev_early_phase
#_Cond 0 #_forecast_recruitment phase (incl. late recr) (0 value resets to maxphase+1)
#_Cond 1 #_lambda for Fcast_recr_like occurring before endyr+1
#_Cond -987 #_last_yr_nobias_adj_in_MPD; begin of ramp
#_Cond -15 #_first_yr_fullbias_adj_in_MPD; begin of plateau
#_Cond 280 #_last_yr_fullbias_adj_in_MPD
#_Cond 285 #_end_yr_for_ramp_in_MPD (can be in forecast to shape ramp, but SS sets bias_adj to 0.0 for fcast yrs)
#_Cond 1 #_max_bias_adj_in_MPD (-1 to override ramp and set biasadj=1.0 for all estimated recdevs)
#_Cond 0 #_period of cycles in recruitment (N parms read below)
#_Cond -5 #min rec_dev
#_Cond 5 #max rec_dev
#_Cond 0 #_read_recdevs
#_end of advanced SR options
#
#_placeholder for full parameter lines for recruitment cycles
# read specified recr devs
#_Yr Input_value
#
# all recruitment deviations
#  101R 102R 103R 104R 105R 106R 107R 108R 109R 110R 111R 112R 113R 114R 115R 116R 117R 118R 119R 120R 121R 122R 123R 124R 125R 126R 127R 128R 129R 130R 131R 132R 133R 134R 135R 136R 137R 138R 139R 140R 141R 142R 143R 144R 145R 146R 147R 148R 149R 150R 151R 152R 153R 154R 155R 156R 157R 158R 159R 160R 161R 162R 163R 164R 165R 166R 167R 168R 169R 170R 171R 172R 173R 174R 175R 176R 177R 178R 179R 180R 181R 182R 183R 184R 185R 186R 187R 188R 189R 190R 191R 192R 193R 194R 195R 196R 197R 198R 199R 200R 201R 202R 203R 204R 205R 206R 207R 208R 209R 210R 211R 212R 213R 214R 215R 216R 217R 218R 219R 220R 221R 222R 223R 224R 225R 226R 227R 228R 229R 230R 231R 232R 233R 234R 235R 236R 237R 238R 239R 240R 241R 242R 243R 244R 245R 246R 247R 248R 249R 250R 251R 252R 253R 254R 255R 256R 257R 258R 259R 260R 261R 262R 263R 264R 265R 266R 267R 268R 269R 270R 271R 272R 273R 274R 275R 276R 277R 278R 279R 280R 281F 282F 283F 284F 285F
#  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
# implementation error by year in forecast:  0
#
#Fishing Mortality info 
0.1 # F ballpark
208 # F ballpark year (neg value to disable)
3 # F_Method:  1=Pope; 2=instan. F; 3=hybrid (hybrid is recommended)
2.9 # max F or harvest rate, depends on F_Method
# no additional F input needed for Fmethod 1
# if Fmethod=2; read overall start F value; overall phase; N detailed inputs to read
# if Fmethod=3; read N iterations for tuning for Fmethod 3
4  # N iterations for tuning F in hybrid method (recommend 3 to 7)
#
#_initial_F_parms; count = 0
#_ LO HI INIT PRIOR PR_SD  PR_type  PHASE
# 285 305
# F rates by fleet
#_Q_setup for fleets with cpue or survey data
#_1:  fleet number
#_2:  link type: (1=simple q, 1 parm; 2=mirror simple q, 1 mirrored parm; 3=q and power, 2 parm; 4=mirror with offset, 2 parm)
#_3:  extra input for link, i.e. mirror fleet# or dev index number
#_4:  0/1 to select extra sd parameter
#_5:  0/1 for biasadj or not
#_6:  0/1 to float
#_   fleet      link link_info  extra_se   biasadj     float  #  fleetname
        17         1         0         0         0         0  #  llcpue1
        18         2        17         0         1         0  #  llcpue2
        19         2        17         0         1         0  #  llcpue3
        20         2        17         0         1         0  #  llcpue4
-9999 0 0 0 0 0
#
#_Q_parms(if_any);Qunits_are_ln(q)
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn  #  parm_name
           -25            25       4.01817             0             1             0         1          0          0          0          0          0          0          0  #  LnQ_base_SURVEY1(17)
           -25            25       4.01817             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_SURVEY2(18)
           -25            25       4.01817             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_SURVEY3(19)
           -25            25       4.01817             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_SURVEY4(20)
#_no timevary Q parameters
#
#_size_selex_patterns
#Pattern:_0; parm=0; selex=1.0 for all sizes
#Pattern:_1; parm=2; logistic; with 95% width specification
#Pattern:_5; parm=2; mirror another size selex; PARMS pick the min-max bin to mirror
#Pattern:_15; parm=0; mirror another age or length selex
#Pattern:_6; parm=2+special; non-parm len selex
#Pattern:_43; parm=2+special+2;  like 6, with 2 additional param for scaling (average over bin range)
#Pattern:_8; parm=8; New doublelogistic with smooth transitions and constant above Linf option
#Pattern:_9; parm=6; simple 4-parm double logistic with starting length; parm 5 is first length; parm 6=1 does desc as offset
#Pattern:_21; parm=2+special; non-parm len selex, read as pairs of size, then selex
#Pattern:_22; parm=4; double_normal as in CASAL
#Pattern:_23; parm=6; double_normal where final value is directly equal to sp(6) so can be >1.0
#Pattern:_24; parm=6; double_normal with sel(minL) and sel(maxL), using joiners
#Pattern:_25; parm=3; exponential-logistic in size
#Pattern:_27; parm=3+special; cubic spline 
#Pattern:_42; parm=2+special+3; // like 27, with 2 additional param for scaling (average over bin range)
#_discard_options:_0=none;_1=define_retention;_2=retention&mortality;_3=all_discarded_dead;_4=define_dome-shaped_retention
#_Pattern Discard Male Special
 0 0 0 0 # 1 fishing_gi_1
 0 0 0 0 # 2 fishing_gi_4
 0 0 0 0 # 3 fishing_hd_1
 0 0 0 0 # 4 fishing_ll_1
 0 0 0 0 # 5 fishing_ll_2
 0 0 0 0 # 6 fishing_ll_3
 0 0 0 0 # 7 fishing_ll_4
 0 0 0 0 # 8 fishing_other_1
 0 0 0 0 # 9 fishing_other_4
 0 0 0 0 # 10 fishing_bb_1
 0 0 0 0 # 11 fishing_ps_1
 0 0 0 0 # 12 fishing_ps_2
 0 0 0 0 # 13 fishing_ps_4
 0 0 0 0 # 14 fishing_trol_1
 0 0 0 0 # 15 fishing_trol_2
 0 0 0 0 # 16 fishing_trol_4
 0 0 0 0 # 17 llcpue1
 0 0 0 0 # 18 llcpue2
 0 0 0 0 # 19 llcpue3
 0 0 0 0 # 20 llcpue4
#
#_age_selex_patterns
#Pattern:_0; parm=0; selex=1.0 for ages 0 to maxage
#Pattern:_10; parm=0; selex=1.0 for ages 1 to maxage
#Pattern:_11; parm=2; selex=1.0  for specified min-max age
#Pattern:_12; parm=2; age logistic
#Pattern:_13; parm=8; age double logistic
#Pattern:_14; parm=nages+1; age empirical
#Pattern:_15; parm=0; mirror another age or length selex
#Pattern:_16; parm=2; Coleraine - Gaussian
#Pattern:_17; parm=nages+1; empirical as random walk  N parameters to read can be overridden by setting special to non-zero
#Pattern:_41; parm=2+nages+1; // like 17, with 2 additional param for scaling (average over bin range)
#Pattern:_18; parm=8; double logistic - smooth transition
#Pattern:_19; parm=6; simple 4-parm double logistic with starting age
#Pattern:_20; parm=6; double_normal,using joiners
#Pattern:_26; parm=3; exponential-logistic in age
#Pattern:_27; parm=3+special; cubic spline in age
#Pattern:_42; parm=2+nages+1; // cubic spline; with 2 additional param for scaling (average over bin range)
#_Pattern Discard Male Special
 20 0 0 0 # 1 fishing_gi_1
 20 0 0 0 # 2 fishing_gi_4
 12 0 0 0 # 3 fishing_hd_1
 12 0 0 0 # 4 fishing_ll_1
 12 0 0 0 # 5 fishing_ll_2
 12 0 0 0 # 6 fishing_ll_3
 12 0 0 0 # 7 fishing_ll_4
 20 0 0 0 # 8 fishing_other_1
 20 0 0 0 # 9 fishing_other_4
 20 0 0 0 # 10 fishing_bb_1
 20 0 0 0  # 11 fishing_ps_1
 20 0 0 0  # 12 fishing_ps_2
 20 0 0 0  # 13 fishing_ps_3
 20 0 0 0  # 14 fishing_trol_1
 15 0 0 14 # 15 fishing_trol_2
 15 0 0 14 # 16 fishing_trol_4
 15 0 0 4 # 17 llcpue1
 15 0 0 5 # 18 llcpue2
 15 0 0 6 # 19 llcpue3
 15 0 0 7 # 20 llcpue4
#
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn  #  parm_name
# 1   fishing_gi_1 LenSelex
# 2   fishing_gi_4 LenSelex
# 3   fishing_hd_1 LenSelex
# 4   fishing_ll_1 LenSelex
# 5   fishing_ll_2 LenSelex
# 6   fishing_ll_3 LenSelex
# 7   fishing_ll_4 LenSelex
# 8   fishing_other_1 LenSelex
# 9   fishing_other_4 LenSelex
# 10  fishing_bb_1 LenSelex
# 11  fishing_ps_1 LenSelex
# 12   fishing_ps_2 LenSelex
# 13   fishing_ps_4 LenSelex
# 14   fishing_trol_1 LenSelex
# 15   fishing_trol_2 LenSelex
# 16   fishing_trol_4 LenSelex
# 17   llcpue1 LenSelex
# 18   llcpue2 LenSelex
# 19   llcpue3 LenSelex
# 20   llcpue4 LenSelex
# 1   fishing_gi_1 AgeSelex
             1            12             7             7             3             6          3          0          0          0          0          0          0          0  #  AgeSel_P1_FISHERY1(1)
           -20            -3      -9.70313            -3          1000             6         -5          0          0          0          0          0          0          0  #  AgeSel_P2_FISHERY1(1)
           -10             9            -1            -1             3             6          4          0          0          0          0          0          0          0  #  AgeSel_P3_FISHERY1(1)
            -5             9             3             3             1             6          4          0          0          0          0          0          0          0  #  AgeSel_P4_FISHERY1(1)
           -10             9            -6            -6          1000             6         -5          0          0          0          0          0          0          0  #  AgeSel_P5_FISHERY1(1)
            -9             5            -2            -2             1             6          5          0          0          0          0          0          0          0  #  AgeSel_P6_FISHERY1(1)
# 2   fishing_gi_4 AgeSelex
            1            40            10            10             5             6          3          0          0          0          0          0          0          0  #  AgeSel_P1_FISHERY2(2)
            -20            -3      -9.70313            -3          1000             6         -5          0          0          0          0          0          0          0  #  AgeSel_P2_FISHERY2(2)
            -10             9            -1            -1             3             6          4          0          0          0          0          0          0          0  #  AgeSel_P3_FISHERY2(2)
            -5             9             3             3             1             6          4          0          0          0          0          0          0          0  #  AgeSel_P4_FISHERY2(2)
            -10             9            -6            -6          1000             6         -5          0          0          0          0          0          0          0  #  AgeSel_P5_FISHERY2(2)
            -9             5            -2            -2             1             6          5          0          0          0          0          0          0          0  #  AgeSel_P6_FISHERY2(2)
# 3   fishing_hd_1 AgeSelex
             8            18            14            14             2             6          3          0          0          0          0          0          0          0  #  AgeSel_P1_FISHERY3(3)
             2             6             4             4             1             6          3          0          0          0          0          0          0          0  #  AgeSel_P2_FISHERY3(3)
# 4   fishing_ll_1 AgeSelex
             8            18            14            14             2             6          3          0          0          0          0          0          0          0  #  AgeSel_P1_FISHERY4(4)
             2             6             4             4             1             6          3          0          0          0          0          0          0          0  #  AgeSel_P2_FISHERY4(4)
# 5   fishing_ll_2 AgeSelex
             8            18            14            14             2             6          3          0          0          0          0          0          0          0  #  AgeSel_P1_FISHERY5(5)
             2             6             4             4             1             6          3          0          0          0          0          0          0          0  #  AgeSel_P2_FISHERY5(5)
# 6   fishing_ll_3 AgeSelex
             8            18            14            14             2             6          3          0          0          0          0          0          0          0  #  AgeSel_P1_FISHERY6(6)
             2             6             4             4             1             6          3          0          0          0          0          0          0          0  #  AgeSel_P2_FISHERY6(6)
# 7   fishing_ll_4 AgeSelex
             8            18            14            14             2             6          3          0          0          0          0          0          0          0  #  AgeSel_P1_FISHERY7(7)
             2             6             4             4             1             6          3          0          0          0          0          0          0          0  #  AgeSel_P2_FISHERY7(7)
# 8   fishing_other_1 AgeSelex
             1            10             3             3             1             6          3          0          0          0          0          0          0          0  #  AgeSel_P1_FISHERY8(8)
           -20            -3      -9.70313            -3          1000             6         -5          0          0          0          0          0          0          0  #  AgeSel_P2_FISHERY8(8)
            -7             5            -2            -2             1             6          4          0          0          0          0          0          0          0  #  AgeSel_P3_FISHERY8(8)
            -5             9             3             3             1             6          4          0          0          0          0          0          0          0  #  AgeSel_P4_FISHERY8(8)
           -10             9            -6            -6             1             6         -5          0          0          0          0          0          0          0  #  AgeSel_P5_FISHERY8(8)
            -9             9            -3            -3             1             6          5          0          0          0          0          0          0          0  #  AgeSel_P6_FISHERY8(8)
# 9   fishing_other_4 AgeSelex
             1            10             3             3             1             6          3          0          0          0          0          0          0          0  #  AgeSel_P1_FISHERY9(9)
           -20            -3      -9.70313            -3          1000             6         -5          0          0          0          0          0          0          0  #  AgeSel_P2_FISHERY9(9)
            -7             5            -2            -2             1             6          4          0          0          0          0          0          0          0  #  AgeSel_P3_FISHERY9(9)
            -5             9             3             3             1             6          4          0          0          0          0          0          0          0  #  AgeSel_P4_FISHERY9(9)
           -10             9            -6            -6             1             6         -5          0          0          0          0          0          0          0  #  AgeSel_P5_FISHERY9(9)
            -9             9            -3            -3             1             6          5          0          0          0          0          0          0          0  #  AgeSel_P6_FISHERY9(9)
# 10   fishing_bb_1 AgeSelex
             1            10             3             3             1             6          3          0          0          0          0          0          0          0  #  AgeSel_P1_FISHERY10(10)
           -20            -3      -9.70313            -3          1000             6         -5          0          0          0          0          0          0          0  #  AgeSel_P2_FISHERY10(10)
            -7             5            -2            -2             1             6          4          0          0          0          0          0          0          0  #  AgeSel_P3_FISHERY10(10)
            -5             9             3             3             1             6          4          0          0          0          0          0          0          0  #  AgeSel_P4_FISHERY10(10)
           -10             9            -6            -6             1             6         -5          0          0          0          0          0          0          0  #  AgeSel_P5_FISHERY10(10)
            -9             9            -3            -3             1             6          5          0          0          0          0          0          0          0  #  AgeSel_P6_FISHERY10(10)
# 11   fishing_ps_1 AgeSelex
             1            12             7             7             3             6          3          0          0          0          0          0          0          0  #  AgeSel_P1_FISHERY11(1)
           -20            -3      -9.70313            -3          1000             6         -5          0          0          0          0          0          0          0  #  AgeSel_P2_FISHERY11(1)
           -10             9            -1            -1             3             6          4          0          0          0          0          0          0          0  #  AgeSel_P3_FISHERY11(1)
            -5             9             3             3             1             6          4          0          0          0          0          0          0          0  #  AgeSel_P4_FISHERY11(1)
           -10             9            -6            -6          1000             6         -5          0          0          0          0          0          0          0  #  AgeSel_P5_FISHERY11(1)
            -9             5            -2            -2             1             6          5          0          0          0          0          0          0          0  #  AgeSel_P6_FISHERY11(1)
# 12   fishing_ps_2 AgeSelex
             1            12             7             7             3             6          3          0          0          0          0          0          0          0  #  AgeSel_P1_FISHERY12(1)
           -20            -3      -9.70313            -3          1000             6         -5          0          0          0          0          0          0          0  #  AgeSel_P2_FISHERY12(1)
           -10             9            -1            -1             3             6          4          0          0          0          0          0          0          0  #  AgeSel_P3_FISHERY12(1)
            -5             9             3             3             1             6          4          0          0          0          0          0          0          0  #  AgeSel_P4_FISHERY12(1)
           -10             9            -6            -6          1000             6         -5          0          0          0          0          0          0          0  #  AgeSel_P5_FISHERY12(1)
            -9             5            -2            -2             1             6          5          0          0          0          0          0          0          0  #  AgeSel_P6_FISHERY12(1)
# 13   fishing_ps_4 AgeSelex
             1            12             7             7             3             6          3          0          0          0          0          0          0          0  #  AgeSel_P1_FISHERY13(1)
           -20            -3      -9.70313            -3          1000             6         -5          0          0          0          0          0          0          0  #  AgeSel_P2_FISHERY13(1)
           -10             9            -1            -1             3             6          4          0          0          0          0          0          0          0  #  AgeSel_P3_FISHERY13(1)
            -5             9             3             3             1             6          4          0          0          0          0          0          0          0  #  AgeSel_P4_FISHERY13(1)
           -10             9            -6            -6          1000             6         -5          0          0          0          0          0          0          0  #  AgeSel_P5_FISHERY13(1)
            -9             5            -2            -2             1             6          5          0          0          0          0          0          0          0  #  AgeSel_P6_FISHERY13(1)
# 14   fishing_troll_1 AgeSelex
             1            10             3             3             1             6          3          0          0          0          0          0          0          0  #  AgeSel_P1_FISHERY14(14)
           -20            -3      -9.70313            -3          1000             6         -5          0          0          0          0          0          0          0  #  AgeSel_P2_FISHERY14(14)
            -7             5            -2            -2             1             6          4          0          0          0          0          0          0          0  #  AgeSel_P3_FISHERY14(14)
            -5             9             3             3             1             6          4          0          0          0          0          0          0          0  #  AgeSel_P4_FISHERY14(14)
           -10             9            -6            -6             1             6         -5          0          0          0          0          0          0          0  #  AgeSel_P5_FISHERY14(14)
            -9             9            -3            -3             1             6          5          0          0          0          0          0          0          0  #  AgeSel_P6_FISHERY14(14)
# 15   fishing_troll_2 AgeSelex
# 16   fishing_troll_4 AgeSelex
# 17   llcpue1 AgeSelex
# 18   llcpue2 AgeSelex
# 19   llcpue3 AgeSelex
# 20   llcpue4 AgeSelex
# timevary selex parameters 
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type    PHASE  #  parm_name
# info on dev vectors created for selex parms are reported with other devs after tag parameter section 
#
0   #  use 2D_AR1 selectivity(0/1):  experimental feature
#_no 2D_AR1 selex offset used
#
# Tag loss and Tag reporting parameters go next
1 # TG_custom:  0=no read; 1=read
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_1
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_2
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_3
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_4
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_5
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_6
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_7
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_8
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_9
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_10
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_11
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_12
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_13
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_14
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_15
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_16
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_17
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_18
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_19
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_20
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_21
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_22
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_23
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_24
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_25
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_26
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_27
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_28
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_29
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_30
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_31
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_32
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_33
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_34
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_35
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_36
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_37
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_38
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_39
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_40
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_41
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_42
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_43
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_44
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_45
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_46
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_47
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_48
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_49
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_50
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_51
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_52
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_53
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_54
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_55
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_56
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_57
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_58
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_59
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_60
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_61
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_62
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_63
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_64
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_65
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_66
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_67
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_68
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_69
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_70
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_71
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_72
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_73
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_74
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_75
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_76
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_77
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_78
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_79
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_80
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_81
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_82
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_83
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_84
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_85
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_86
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_87
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_88
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_89
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_90
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_91
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_92
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_93
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_94
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_95
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_96
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_97
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_98
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_99
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_100
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_101
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_102
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_103
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_104
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_105
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_106
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_107
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_108
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_109
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_110
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_111
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_112
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_113
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_114
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_115
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_116
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_117
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_118
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_119
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_120
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_init_121
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_1
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_2
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_3
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_4
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_5
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_6
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_7
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_8
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_9
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_10
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_11
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_12
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_13
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_14
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_15
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_16
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_17
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_18
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_19
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_20
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_21
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_22
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_23
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_24
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_25
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_26
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_27
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_28
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_29
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_30
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_31
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_32
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_33
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_34
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_35
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_36
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_37
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_38
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_39
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_40
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_41
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_42
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_43
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_44
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_45
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_46
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_47
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_48
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_49
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_50
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_51
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_52
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_53
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_54
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_55
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_56
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_57
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_58
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_59
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_60
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_61
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_62
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_63
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_64
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_65
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_66
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_67
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_68
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_69
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_70
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_71
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_72
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_73
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_74
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_75
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_76
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_77
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_78
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_79
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_80
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_81
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_82
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_83
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_84
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_85
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_86
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_87
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_88
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_89
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_90
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_91
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_92
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_93
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_94
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_95
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_96
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_97
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_98
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_99
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_100
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_101
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_102
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_103
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_104
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_105
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_106
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_107
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_108
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_109
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_110
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_111
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_112
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_113
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_114
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_115
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_116
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_117
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_118
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_119
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_120
 -15 10 -10 -10 0.001 1 -4 0 0 0 0 0 0 0 # TG_loss_chronic_121
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_1
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_2
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_3
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_4
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_5
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_6
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_7
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_8
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_9
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_10
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_11
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_12
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_13
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_14
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_15
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_16
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_17
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_18
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_19
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_20
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_21
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_22
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_23
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_24
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_25
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_26
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_27
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_28
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_29
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_30
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_31
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_32
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_33
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_34
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_35
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_36
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_37
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_38
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_39
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_40
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_41
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_42
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_43
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_44
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_45
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_46
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_47
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_48
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_49
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_50
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_51
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_52
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_53
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_54
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_55
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_56
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_57
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_58
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_59
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_60
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_61
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_62
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_63
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_64
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_65
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_66
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_67
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_68
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_69
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_70
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_71
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_72
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_73
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_74
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_75
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_76
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_77
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_78
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_79
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_80
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_81
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_82
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_83
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_84
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_85
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_86
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_87
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_88
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_89
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_90
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_91
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_92
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_93
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_94
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_95
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_96
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_97
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_98
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_99
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_100
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_101
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_102
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_103
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_104
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_105
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_106
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_107
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_108
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_109
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_110
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_111
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_112
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_113
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_114
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_115
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_116
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_117
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_118
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_119
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_120
 1 10 7 7 0.001 1 -4 0 0 0 0 0 0 0 # TG_overdispersion_121
 -20 20 -20 -20 2 6 -6 0 0 0 0 0 0 0  # TG_report_fleet:_1
 -20 20 -20 -20 2 6 -6 0 0 0 0 0 0 0  # TG_report_fleet:_2
 -20 20 -20 -20 2 6 -6 0 0 0 0 0 0 0  # TG_report_fleet:_3
 -20 20 -20 -20 2 6 -6 0 0 0 0 0 0 0  # TG_report_fleet:_4
 -20 20 -20 -20 2 6 -6 0 0 0 0 0 0 0  # TG_report_fleet:_5
 -20 20 -20 -20 2 6 -6 0 0 0 0 0 0 0  # TG_report_fleet:_6
 -20 20 -20 -20 2 6 -6 0 0 0 0 0 0 0  # TG_report_fleet:_7
 -20 20 -20 -20 2 6 -6 0 0 0 0 0 0 0  # TG_report_fleet:_8
 -20 20 -20 -20 2 6 -6 0 0 0 0 0 0 0  # TG_report_fleet:_9
 -20 20 -20 -20 2 6 -6 0 0 0 0 0 0 0  # TG_report_fleet:_10
 -20 20 10 10 2 6 -6 0 0 0 0 0 0 0    # TG_report_fleet:_11
 -20 20 10 10 2 6 -6 0 0 0 0 0 0 0    # TG_report_fleet:_12
 -20 20 10 10 2 6 -6 0 0 0 0 0 0 0    # TG_report_fleet:_13
 -20 20 -20 -20 2 6 -6 0 0 0 0 0 0 0  # TG_report_fleet:_14
 -20 20 -20 -20 2 6 -6 0 0 0 0 0 0 0  # TG_report_fleet:_15
 -20 20 -20 -20 2 6 -6 0 0 0 0 0 0 0  # TG_report_fleet:_16 
 -4 0 0 0 2 6 -4 0 0 0 0 0 0 0 # TG_rpt_decay_fleet:_1
 -4 0 0 0 2 6 -4 0 0 0 0 0 0 0 # TG_rpt_decay_fleet:_2
 -4 0 0 0 2 6 -4 0 0 0 0 0 0 0 # TG_rpt_decay_fleet:_3
 -4 0 0 0 2 6 -4 0 0 0 0 0 0 0 # TG_rpt_decay_fleet:_4
 -4 0 0 0 2 6 -4 0 0 0 0 0 0 0 # TG_rpt_decay_fleet:_5
 -4 0 0 0 2 6 -4 0 0 0 0 0 0 0 # TG_rpt_decay_fleet:_6
 -4 0 0 0 2 6 -4 0 0 0 0 0 0 0 # TG_rpt_decay_fleet:_7
 -4 0 0 0 2 6 -4 0 0 0 0 0 0 0 # TG_rpt_decay_fleet:_8
 -4 0 0 0 2 6 -4 0 0 0 0 0 0 0 # TG_rpt_decay_fleet:_9
 -4 0 0 0 2 6 -4 0 0 0 0 0 0 0 # TG_rpt_decay_fleet:_10
 -4 0 0 0 2 6 -4 0 0 0 0 0 0 0 # TG_rpt_decay_fleet:_11
 -4 0 0 0 2 6 -4 0 0 0 0 0 0 0 # TG_rpt_decay_fleet:_12
 -4 0 0 0 2 6 -4 0 0 0 0 0 0 0 # TG_rpt_decay_fleet:_13
 -4 0 0 0 2 6 -4 0 0 0 0 0 0 0 # TG_rpt_decay_fleet:_14
 -4 0 0 0 2 6 -4 0 0 0 0 0 0 0 # TG_rpt_decay_fleet:_15
 -4 0 0 0 2 6 -4 0 0 0 0 0 0 0 # TG_rpt_decay_fleet:_16 

#
# deviation vectors for timevary parameters
#  base   base first block   block  env  env   dev   dev   dev   dev   dev
#  type  index  parm trend pattern link  var  vectr link _mnyr  mxyr phase  dev_vector
     #
# Input variance adjustments factors: 
 #_1=add_to_survey_CV
 #_2=add_to_discard_stddev
 #_3=add_to_bodywt_CV
 #_4=mult_by_lencomp_N
 #_5=mult_by_agecomp_N
 #_6=mult_by_size-at-age_N
 #_7=mult_by_generalized_sizecomp
#_Factor  Fleet  Value
 -9999   1    0  # terminator
#
4 #_maxlambdaphase                                                                                                              
1 #_sd_offset; must be 1 if any growthCV, sigmaR, or survey extraSD is an estimated parameter 
# read 0 changes to default Lambdas (default value is 1.0)                                                                      
# Like_comp codes:  1=surv; 2=disc; 3=mnwt; 4=length; 5=age; 6=SizeFreq; 7=sizeage; 8=catch; 9=init_equ_catch;                  
# 10=recrdev; 11=parm_prior; 12=parm_dev; 13=CrashPen; 14=Morphcomp; 15=Tag-comp; 16=Tag-negbin; 17=F_ballpark; 18=initEQregime 
#like_comp fleet  phase  value  sizefreq_method                                                                                 
17 1 1 1 1  # confirms lambda =1 in first phase                                                                                 
17 1 4 .01  1  # reduces lambda to 0.01 beginning in phase 4                                                                    
-9999  1  1  1  1  #  terminator
#  1 #_crashPenLambda
#  1 # F_ballpark_lambda
0 # (0/1) read specs for more stddev reporting 
 # 0 0 0 0 0 0 0 0 0 # placeholder for # selex_fleet, 1=len/2=age/3=both, year, N selex bins, 0 or Growth pattern, N growth ages, 0 or NatAge_area(-1 for all), NatAge_yr, N Natages
 # placeholder for vector of selex bins to be reported
 # placeholder for vector of growth ages to be reported
 # placeholder for vector of NatAges ages to be reported
999

