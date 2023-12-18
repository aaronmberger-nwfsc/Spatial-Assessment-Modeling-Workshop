#V3.30
#C file created using the SS_writectl function in the R package r4ss
#C file write time: 2022-03-28 09:50:48
#
0 # 0 means do not read wtatage.ss; 1 means read and usewtatage.ss and also read and use growth parameters
1 #_N_Growth_Patterns
1 #_N_platoons_Within_GrowthPattern
3 # recr_dist_method for parameters
1 # not yet implemented; Future usage:Spawner-Recruitment; 1=global; 2=by area
1 # number of recruitment settlement assignments 
0 # unused option
# for each settlement assignment:
#_GPattern	month	area	age
1	1	1	1	#_1
#
#_Cond 0 # N_movement_definitions goes here if N_areas > 1
#_Cond 1.0 # first age that moves (real age at begin of season, not integer) also cond on do_migration>0
#_Cond 1 1 1 2 4 10 # example move definition for seas=1, morph=1, source=1 dest=2, age1=4, age2=10
#
0 #_Nblock_Patterns
#_Cond 0 #_blocks_per_pattern
# begin and end years of blocks
#
# controls for all timevary parameters 
1 #_env/block/dev_adjust_method for all time-vary parms (1=warn relative to base parm bounds; 3=no bound check)
#
# AUTOGEN
1 1 1 1 1 # autogen: 1st element for biology, 2nd for SR, 3rd for Q, 4th reserved, 5th for selex
# where: 0 = autogen all time-varying parms; 1 = read each time-varying parm line; 2 = read then autogen if parm min==-12345
#
# setup for M, growth, maturity, fecundity, recruitment distibution, movement
#
3 #_natM_type:_0=1Parm; 1=N_breakpoints;_2=Lorenzen;_3=agespecific;_4=agespec_withseasinterpolate;_5=Maunder_M;_6=Age-range_Lorenzen
#_ #_Age_natmort_by sex x growthpattern
#_Age_0	Age_1	Age_2	Age_3	Age_4	Age_5	Age_6	Age_7	Age_8	Age_9	Age_10	Age_11	Age_12	Age_13	Age_14	Age_15	Age_16	Age_17	Age_18	Age_19	Age_20	Age_21	Age_22	Age_23	Age_24	Age_25	Age_26	Age_27	Age_28
0.3358	0.3358	0.2955	0.2552	0.2149	0.1746	0.1343	0.1343	0.1343	0.1343	0.1343	0.141	0.1606	0.178	0.1915	0.1994	0.2009	0.1962	0.1865	0.1743	0.1623	0.1522	0.1449	0.1401	0.1373	0.1357	0.1349	0.1346	0.1344	#_natM1
3 # GrowthModel: 1=vonBert with L1&L2; 2=Richards with L1&L2; 3=age_specific_K_incr; 4=age_specific_K_decr;5=age_specific_K_each; 6=NA; 7=NA; 8=growth cessation
0 #_Age(post-settlement)_for_L1;linear growth below this
999 #_Growth_Age_for_L2 (999 to use as Linf)
-999 #_exponential decay for growth above maxage (value should approx initial Z; -999 replicates 3.24; -998 to not allow growth above maxage)
0 #_placeholder for future growth feature
11 # number of K multipliers to read
2 3 4 5 6 7 8 9 10 11 12 # ages for K multiplier
#
0 #_SD_add_to_LAA (set to 0.1 for SS2 V1.x compatibility)
0 #_CV_Growth_Pattern:  0 CV=f(LAA); 1 CV=F(A); 2 SD=F(LAA); 3 SD=F(A); 4 logSD=F(A)
3 #_maturity_option:  1=length logistic; 2=age logistic; 3=read age-maturity matrix by growth_pattern; 4=read age-fecundity; 5=disabled; 6=read length-maturity
# Age Maturity or Age fecundity:
#_Age_0	Age_1	Age_2	Age_3	Age_4	Age_5	Age_6	Age_7	Age_8	Age_9	Age_10	Age_11	Age_12	Age_13	Age_14	Age_15	Age_16	Age_17	Age_18	Age_19	Age_20	Age_21	Age_22	Age_23	Age_24	Age_25	Age_26	Age_27	Age_28
0	0	0	0	0	0.1	0.15	0.2	0.3	0.5	0.7	0.9	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	#_Age_Maturity1
0 #_First_Mature_Age
1 #_fecundity option:(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b; (4)eggs=a+b*L; (5)eggs=a+b*W
0 #_hermaphroditism option:  0=none; 1=female-to-male age-specific fxn; -1=male-to-female age-specific fxn
1 #_parameter_offset_approach (1=none, 2= M, G, CV_G as offset from female-GP1, 3=like SS2 V1.x)
#
#_growth_parms
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env_var&link	dev_link	dev_minyr	dev_maxyr	dev_PH	Block	Block_Fxn
  5	 40	       22	0	0	0	-3	0	0	0	0	0	0	0	#_L_at_Amin_Fem_GP_1          
 90	200	      145	0	0	0	-3	0	0	0	0	0	0	0	#_L_at_Amax_Fem_GP_1          
0.1	0.7	  0.11375	0	0	0	-3	0	0	0	0	0	0	0	#_VonBert_K_Fem_GP_1          
  0	  2	      0.5	0	0	0	-3	0	0	0	0	0	0	0	#_Age_K_2_Fem_GP_1            
  0	  2	     0.75	0	0	0	-3	0	0	0	0	0	0	0	#_Age_K_3_Fem_GP_1            
  0	  2	        1	0	0	0	-3	0	0	0	0	0	0	0	#_Age_K_4_Fem_GP_1            
  0	  2	        1	0	0	0	-3	0	0	0	0	0	0	0	#_Age_K_5_Fem_GP_1            
  0	  2	        1	0	0	0	-3	0	0	0	0	0	0	0	#_Age_K_6_Fem_GP_1            
  0	  2	      1.8	0	0	0	-3	0	0	0	0	0	0	0	#_Age_K_7_Fem_GP_1            
  0	  2	      1.8	0	0	0	-3	0	0	0	0	0	0	0	#_Age_K_8_Fem_GP_1            
  0	  2	      1.2	0	0	0	-3	0	0	0	0	0	0	0	#_Age_K_9_Fem_GP_1            
  0	  2	      1.2	0	0	0	-3	0	0	0	0	0	0	0	#_Age_K_10_Fem_GP_1           
  0	  2	        1	0	0	0	-3	0	0	0	0	0	0	0	#_Age_K_11_Fem_GP_1           
  0	  2	        1	0	0	0	-3	0	0	0	0	0	0	0	#_Age_K_12_Fem_GP_1           
  0	  2	      0.1	0	0	0	-3	0	0	0	0	0	0	0	#_CV_young_Fem_GP_1           
  0	  2	      0.1	0	0	0	-3	0	0	0	0	0	0	0	#_CV_old_Fem_GP_1             
  0	  1	2.459e-05	0	0	0	-3	0	0	0	0	0	0	0	#_Wtlen_1_Fem_GP_1            
  0	  4	   2.9667	0	0	0	-3	0	0	0	0	0	0	0	#_Wtlen_2_Fem_GP_1            
  0	100	       36	0	0	0	-3	0	0	0	0	0	0	0	#_Mat50%_Fem_GP_1             
 -2	  2	     -0.5	0	0	0	-3	0	0	0	0	0	0	0	#_Mat_slope_Fem_GP_1          
  0	  2	        1	0	0	0	-3	0	0	0	0	0	0	0	#_Eggs_alpha_Fem_GP_1         
  0	  1	        0	0	0	0	-3	0	0	0	0	0	0	0	#_Eggs_beta_Fem_GP_1          
-15	 15	        0	0	0	0	-7	0	0	0	0	0	0	0	#_RecrDist_GP_1_area_1_month_1
  1	  1	        1	0	0	0	-3	0	0	0	0	0	0	0	#_CohortGrowDev               
  0	  1	      0.5	0	0	0	-3	0	0	0	0	0	0	0	#_FracFemale_GP_1             
#_no timevary MG parameters
#
#_seasonal_effects_on_biology_parms
0 0 0 0 0 0 0 0 0 0 #_femwtlen1,femwtlen2,mat1,mat2,fec1,fec2,Malewtlen1,malewtlen2,L1,K
#_ LO HI INIT PRIOR PR_SD PR_type PHASE
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no seasonal MG parameters
#
3 #_Spawner-Recruitment; 2=Ricker; 3=std_B-H; 4=SCAA;5=Hockey; 6=B-H_flattop; 7=survival_3Parm;8=Shepard_3Parm
0 # 0/1 to use steepness in initial equ recruitment calculation
0 # future feature: 0/1 to make realized sigmaR a function of SR curvature
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn # parm_name
  5	25	11.5	0	0	0	 1	0	0	0	0	0	0	0	#_SR_LN(R0)  
0.2	 1	 0.8	0	0	0	-1	0	0	0	0	0	0	0	#_SR_BH_steep
  0	 2	 0.6	0	0	0	-2	0	0	0	0	0	0	0	#_SR_sigmaR  
 -5	 5	   0	0	0	0	-1	0	0	0	0	0	0	0	#_SR_regime  
  0	 0	   0	0	0	0	-1	0	0	0	0	0	0	0	#_SR_autocorr
#_no timevary SR parameters
1 #do_recdev:  0=none; 1=devvector (R=F(SSB)+dev); 2=deviations (R=F(SSB)+dev); 3=deviations (R=R0*dev; dev2=R-f(SSB)); 4=like 3 with sum(dev2) adding penalty
1080 # first year of main recr_devs; early devs can preceed this era
1250 # last year of main recr_devs; forecast devs start in following year
2 #_recdev phase
1 # (0/1) to read 13 advanced options
0 #_recdev_early_start (0=none; neg value makes relative to recdev_start)
-2 #_recdev_early_phase
0 #_forecast_recruitment phase (incl. late recr) (0 value resets to maxphase+1)
1 #_lambda for Fcast_recr_like occurring before endyr+1
1046.7 #_last_yr_nobias_adj_in_MPD; begin of ramp
1147 #_first_yr_fullbias_adj_in_MPD; begin of plateau
1216.5 #_last_yr_fullbias_adj_in_MPD
1253.3 #_end_yr_for_ramp_in_MPD (can be in forecast to shape ramp, but SS sets bias_adj to 0.0 for fcast yrs)
0.5487 #_max_bias_adj_in_MPD (-1 to override ramp and set biasadj=1.0 for all estimated recdevs)
0 #_period of cycles in recruitment (N parms read below)
-5 #min rec_dev
5 #max rec_dev
0 #_read_recdevs
#_end of advanced SR options
#
#_placeholder for full parameter lines for recruitment cycles
# read specified recr devs
#_Yr Input_value
#
#Fishing Mortality info
0 # F ballpark
-1002 # F ballpark year (neg value to disable)
3 # F_Method:  1=Pope; 2=instan. F; 3=hybrid (hybrid is recommended)
7 # max F or harvest rate, depends on F_Method
5 # N iterations for tuning F in hybrid method (recommend 3 to 7)
#
#_initial_F_parms; count = 0
#
#_Q_setup for fleets with cpue or survey data
#_fleet	link	link_info	extra_se	biasadj	float  #  fleetname
    8	0	0	0	0	0	#_llcpue    
-9999	0	0	0	0	0	#_terminator
#_Q_parms(if_any);Qunits_are_ln(q)
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn  #  parm_name
-30	15	-3	0	0	0	3	0	0	0	0	0	0	0	#_LnQllcpue
#_no timevary Q parameters
#
#_size_selex_patterns
#_Pattern	Discard	Male	Special
0	0	0	0	#_1 1
0	0	0	0	#_2 2
0	0	0	0	#_3 3
0	0	0	0	#_4 4
0	0	0	0	#_5 5
0	0	0	0	#_6 6
0	0	0	0	#_7 7
0	0	0	0	#_8 8
#
#_age_selex_patterns
#_Pattern	Discard	Male	Special
20	0	0	0	#_1 1
20	0	0	0	#_2 2
12	0	0	0	#_3 3
20	0	0	0	#_4 4
20	0	0	0	#_5 5
20	0	0	0	#_6 6
20	0	0	0	#_7 7
15	0	0	3	#_8 8
#
#_SizeSelex
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn  #  parm_name
  0	25	 5	0	0	0	4	0	0	0	0	0	0	0	#_1 
-40	15	 2	0	0	0	4	0	0	0	0	0	0	0	#_2 
-40	15	-6	0	0	0	5	0	0	0	0	0	0	0	#_3 
-40	15	 2	0	0	0	5	0	0	0	0	0	0	0	#_4 
-40	15	-4	0	0	0	6	0	0	0	0	0	0	0	#_5 
-40	15	-4	0	0	0	6	0	0	0	0	0	0	0	#_6 
  0	25	 5	0	0	0	4	0	0	0	0	0	0	0	#_7 
-40	15	 2	0	0	0	4	0	0	0	0	0	0	0	#_8 
-40	15	-6	0	0	0	5	0	0	0	0	0	0	0	#_9 
-40	15	 2	0	0	0	5	0	0	0	0	0	0	0	#_10
-40	15	-4	0	0	0	6	0	0	0	0	0	0	0	#_11
-40	15	-4	0	0	0	6	0	0	0	0	0	0	0	#_12
  0	25	10	0	0	0	4	0	0	0	0	0	0	0	#_13
  0	25	 2	0	0	0	5	0	0	0	0	0	0	0	#_14
  0	25	 5	0	0	0	4	0	0	0	0	0	0	0	#_15
-40	15	 2	0	0	0	4	0	0	0	0	0	0	0	#_16
-40	15	-6	0	0	0	5	0	0	0	0	0	0	0	#_17
-40	15	 2	0	0	0	5	0	0	0	0	0	0	0	#_18
-40	15	-4	0	0	0	6	0	0	0	0	0	0	0	#_19
-40	15	-4	0	0	0	6	0	0	0	0	0	0	0	#_20
  0	25	 5	0	0	0	4	0	0	0	0	0	0	0	#_21
-40	15	 2	0	0	0	4	0	0	0	0	0	0	0	#_22
-40	15	-6	0	0	0	5	0	0	0	0	0	0	0	#_23
-40	15	 2	0	0	0	5	0	0	0	0	0	0	0	#_24
-40	15	-4	0	0	0	6	0	0	0	0	0	0	0	#_25
-40	15	-4	0	0	0	6	0	0	0	0	0	0	0	#_26
  0	25	 5	0	0	0	4	0	0	0	0	0	0	0	#_27
-40	15	 2	0	0	0	4	0	0	0	0	0	0	0	#_28
-40	15	-6	0	0	0	5	0	0	0	0	0	0	0	#_29
-40	15	 2	0	0	0	5	0	0	0	0	0	0	0	#_30
-40	15	-4	0	0	0	6	0	0	0	0	0	0	0	#_31
-40	15	-4	0	0	0	6	0	0	0	0	0	0	0	#_32
  0	25	 5	0	0	0	4	0	0	0	0	0	0	0	#_33
-40	15	 2	0	0	0	4	0	0	0	0	0	0	0	#_34
-40	15	-6	0	0	0	5	0	0	0	0	0	0	0	#_35
-40	15	 2	0	0	0	5	0	0	0	0	0	0	0	#_36
-40	15	-4	0	0	0	6	0	0	0	0	0	0	0	#_37
-40	15	-4	0	0	0	6	0	0	0	0	0	0	0	#_38
#_AgeSelex
#_No age_selex_parm
#_no timevary selex parameters
#
0 #  use 2D_AR1 selectivity(0/1):  experimental feature
#_no 2D_AR1 selex offset used
# Tag loss and Tag reporting parameters go next
1 # TG_custom:  0=no read; 1=read if tags exist
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env_var	dev_link	dev_minyr	dev_maxyr	dev_PH	Block	Block_Fxn
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_1  
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_2  
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_3  
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_4  
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_5  
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_6  
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_7  
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_8  
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_9  
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_10 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_11 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_12 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_13 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_14 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_15 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_16 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_17 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_18 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_19 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_20 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_21 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_22 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_23 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_24 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_25 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_26 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_27 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_28 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_29 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_30 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_31 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_32 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_33 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_34 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_35 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_36 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_37 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_38 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_39 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_40 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_41 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_42 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_43 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_44 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_45 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_46 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_47 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_48 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_49 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_50 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_51 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_52 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_53 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_54 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_55 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_56 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_57 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_58 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_59 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_60 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_61 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_62 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_63 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_64 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_65 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_66 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_67 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_68 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_69 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_70 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_71 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_72 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_73 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_74 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_75 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_76 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_77 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_78 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_79 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_80 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_81 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_82 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_83 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_84 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_85 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_86 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_87 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_88 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_89 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_90 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_91 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_92 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_93 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_94 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_95 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_96 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_97 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_98 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_99 
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_100
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_101
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_102
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_103
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_104
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_105
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_106
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_107
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_108
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_109
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_110
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_111
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_112
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_113
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_114
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_115
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_116
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_117
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_118
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_119
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_120
-10	10	-2	-7	0.001	1	-4	0	0	0	0	0	0	0	#_121
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_1  
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_2  
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_3  
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_4  
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_5  
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_6  
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_7  
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_8  
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_9  
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_10 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_11 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_12 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_13 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_14 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_15 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_16 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_17 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_18 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_19 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_20 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_21 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_22 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_23 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_24 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_25 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_26 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_27 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_28 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_29 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_30 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_31 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_32 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_33 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_34 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_35 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_36 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_37 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_38 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_39 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_40 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_41 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_42 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_43 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_44 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_45 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_46 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_47 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_48 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_49 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_50 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_51 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_52 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_53 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_54 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_55 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_56 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_57 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_58 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_59 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_60 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_61 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_62 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_63 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_64 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_65 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_66 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_67 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_68 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_69 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_70 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_71 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_72 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_73 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_74 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_75 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_76 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_77 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_78 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_79 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_80 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_81 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_82 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_83 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_84 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_85 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_86 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_87 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_88 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_89 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_90 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_91 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_92 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_93 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_94 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_95 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_96 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_97 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_98 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_99 
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_100
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_101
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_102
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_103
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_104
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_105
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_106
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_107
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_108
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_109
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_110
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_111
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_112
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_113
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_114
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_115
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_116
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_117
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_118
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_119
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_120
-10	10	-4	-7	0.001	1	-4	0	0	0	0	0	0	0	#_121
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_1  
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_2  
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_3  
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_4  
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_5  
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_6  
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_7  
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_8  
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_9  
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_10 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_11 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_12 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_13 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_14 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_15 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_16 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_17 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_18 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_19 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_20 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_21 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_22 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_23 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_24 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_25 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_26 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_27 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_28 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_29 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_30 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_31 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_32 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_33 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_34 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_35 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_36 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_37 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_38 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_39 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_40 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_41 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_42 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_43 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_44 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_45 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_46 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_47 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_48 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_49 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_50 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_51 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_52 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_53 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_54 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_55 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_56 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_57 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_58 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_59 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_60 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_61 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_62 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_63 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_64 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_65 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_66 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_67 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_68 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_69 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_70 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_71 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_72 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_73 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_74 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_75 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_76 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_77 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_78 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_79 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_80 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_81 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_82 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_83 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_84 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_85 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_86 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_87 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_88 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_89 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_90 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_91 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_92 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_93 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_94 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_95 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_96 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_97 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_98 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_99 
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_100
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_101
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_102
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_103
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_104
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_105
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_106
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_107
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_108
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_109
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_110
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_111
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_112
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_113
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_114
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_115
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_116
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_117
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_118
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_119
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_120
1	10	7	2	0.001	1	-4	0	0	0	0	0	0	0	#_121
-10	10	-7	-7	0.001	1	-4	0	0	0	0	0	0	0	#_1
-10	10	-7	-7	0.001	1	-4	0	0	0	0	0	0	0	#_2
-10	10	-7	-7	0.001	1	-4	0	0	0	0	0	0	0	#_3
-10	10	-7	-7	0.001	1	-4	0	0	0	0	0	0	0	#_4
-10	10	-7	-7	0.001	1	-4	0	0	0	0	0	0	0	#_5
-10	10	 7	-7	0.001	1	 7	0	0	0	0	0	0	0	#_6
-10	10	-7	-7	0.001	1	-4	0	0	0	0	0	0	0	#_7
-4	0	-3	0	2	6	-4	0	0	0	0	0	0	0	#_1
-4	0	-3	0	2	6	-4	0	0	0	0	0	0	0	#_2
-4	0	-3	0	2	6	-4	0	0	0	0	0	0	0	#_3
-4	0	-3	0	2	6	-4	0	0	0	0	0	0	0	#_4
-4	0	-3	0	2	6	-4	0	0	0	0	0	0	0	#_5
-4	0	 0	0	2	6	 7	0	0	0	0	0	0	0	#_6
-4	0	-3	0	2	6	-4	0	0	0	0	0	0	0	#_7
# Input variance adjustments factors: 
#_Data_type Fleet Value
-9999 1 0 # terminator
#
10 #_maxlambdaphase
1 #_sd_offset; must be 1 if any growthCV, sigmaR, or survey extraSD is an estimated parameter
# read 0 changes to default Lambdas (default value is 1.0)
-9999 0 0 0 0 # terminator
#
0 # 0/1 read specs for more stddev reporting
#
999
