#V3.30
#C file created using the SS_writectl function in the R package r4ss
#C file write time: 2021-01-27 10:37:57
#
0 # 0 means do not read wtatage.ss; 1 means read and usewtatage.ss and also read and use growth parameters
1 #_N_Growth_Patterns
1 #_N_platoons_Within_GrowthPattern
3 # recr_dist_method for parameters
1 # not yet implemented; Future usage:Spawner-Recruitment; 1=global; 2=by area
3 # number of recruitment settlement assignments 
0 # unused option
# for each settlement assignment:
#_GPattern	month	area	age
1	1	1	0	#_recr_dist_pattern1
1	1	2	0	#_recr_dist_pattern2
1	1	4	0	#_recr_dist_pattern3
#
6 #_N_movement_definitions goes here if N_areas > 1
0.25 #_first age that moves (real age at begin of season, not integer) also cond on do_migration>0
#_move definition for seas, morph, source, dest, age1, age2
1	1	1	2	3	4	#_moveDef1
1	1	2	1	3	4	#_moveDef2
1	1	1	4	3	4	#_moveDef3
1	1	4	1	3	4	#_moveDef4
1	1	4	3	3	4	#_moveDef5
1	1	3	4	3	4	#_moveDef6
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
3 #_natM_type:_0=1Parm; 1=N_breakpoints;_2=Lorenzen;_3=agespecific;_4=agespec_withseasinterpolate
#_ #_Age_natmort_by sex x growthpattern
#_Age_0	Age_1	Age_2	Age_3	Age_4	Age_5	Age_6	Age_7
1.2223	0.6581	0.5439	0.7295	0.7579	0.5995	0.5425	0.5376	#_natM1
1 # GrowthModel: 1=vonBert with L1&L2; 2=Richards with L1&L2; 3=age_specific_K_incr; 4=age_specific_K_decr;5=age_specific_K_each; 6=NA; 7=NA; 8=growth cessation
0.5 #_Age(post-settlement)_for_L1;linear growth below this
999 #_Growth_Age_for_L2 (999 to use as Linf)
-999 #_exponential decay for growth above maxage (value should approx initial Z; -999 replicates 3.24; -998 to not allow growth above maxage)
0 #_placeholder for future growth feature
#
0 #_SD_add_to_LAA (set to 0.1 for SS2 V1.x compatibility)
1 #_CV_Growth_Pattern:  0 CV=f(LAA); 1 CV=F(A); 2 SD=F(LAA); 3 SD=F(A); 4 logSD=F(A)
3 #_maturity_option:  1=length logistic; 2=age logistic; 3=read age-maturity matrix by growth_pattern; 4=read age-fecundity; 5=disabled; 6=read length-maturity
# Age Maturity or Age fecundity:
#_Age_0	Age_1	Age_2	Age_3	Age_4	Age_5	Age_6	Age_7
0	0.1125	0.6	1	1	1	1	1	#_Age_Maturity1
1 #_First_Mature_Age
1 #_fecundity option:(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b; (4)eggs=a+b*L; (5)eggs=a+b*W
0 #_hermaphroditism option:  0=none; 1=female-to-male age-specific fxn; -1=male-to-female age-specific fxn
1 #_parameter_offset_approach (1=none, 2= M, G, CV_G as offset from female-GP1, 3=like SS2 V1.x)
#
#_growth_parms
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env_var&link	dev_link	dev_minyr	dev_maxyr	dev_PH	Block	Block_Fxn
    2	 12	      22	      12	    3	0	-2	0	 0	   0	   0	0	0	0	#_L_at_Amin_Fem_GP_1                
   50	180	     145	  100.17	18.62	6	-3	0	 0	   0	   0	0	0	0	#_L_at_Amax_Fem_GP_1                
0.006	0.6	   0.455	  -1.272	  2.3	4	-3	0	 0	   0	   0	0	0	0	#_VonBert_K_Fem_GP_1                
0.005	0.5	     0.3	     0.2	  0.8	0	-6	0	 0	   0	   0	0	0	0	#_CV_young_Fem_GP_1                 
0.005	0.5	     0.1	     0.1	  0.8	0	-6	0	 0	   0	   0	0	0	0	#_CV_old_Fem_GP_1                   
   -1	  1	2.46e-05	6.59e-06	 0.05	0	-3	0	 0	   0	   0	0	0	0	#_Wtlen_1_Fem_GP_1                  
    2	  4	   2.966	 3.01221	 0.05	0	-3	0	 0	   0	   0	0	0	0	#_Wtlen_2_Fem_GP_1                  
   30	 55	    36.5	    36.5	    5	0	-3	0	 0	   0	   0	0	0	0	#_Mat50%_Fem_GP_1                   
   -1	  1	    -0.2	    -0.2	  0.5	0	-3	0	 0	   0	   0	0	0	0	#_Mat_slope_Fem_GP_1                
   -3	  3	       1	       1	  0.8	0	-3	0	 0	   0	   0	0	0	0	#_Eggs_scalar_Fem_GP_1              
   -3	  3	       0	       0	  0.8	0	-3	0	 0	   0	   0	0	0	0	#_Eggs_exp_wt_Fem_GP_1              
  -12	 15	       0	       0	    0	0	-4	0	 0	   0	   0	0	0	0	#_RecrDist_GP_1_area_1_month_1      
  -35	 25	0.232637	       0	    1	0	 2	0	23	1982	2015	3	0	0	#_RecrDist_GP_1_area_2_month_1      
  -35	 25	0.232637	       0	    1	0	 2	0	23	1982	2015	3	0	0	#_RecrDist_GP_1_area_4_month_1      
    0	  2	       1	       1	    0	0	-3	0	 0	   0	   0	0	0	0	#_CohortGrowDev                     
  -10	 10	       1	       1	    0	0	 4	0	 0	   0	   0	0	0	0	#_MoveParm_A_seas_1_GP_1_from_1_to_2
  -16	 13	       1	       1	    0	0	 4	0	 0	   0	   0	0	0	0	#_MoveParm_B_seas_1_GP_1_from_1_to_2
  -16	 13	       1	       1	    0	0	 4	0	 0	   0	   0	0	0	0	#_MoveParm_A_seas_1_GP_1_from_2_to_1
  -16	 13	       1	       1	    0	0	 4	0	 0	   0	   0	0	0	0	#_MoveParm_B_seas_1_GP_1_from_2_to_1
  -16	 13	       1	       1	    0	0	 4	0	 0	   0	   0	0	0	0	#_MoveParm_A_seas_1_GP_1_from_1_to_4
  -16	 13	       1	       1	    0	0	 4	0	 0	   0	   0	0	0	0	#_MoveParm_B_seas_1_GP_1_from_1_to_4
  -16	 13	       1	       1	    0	0	 4	0	 0	   0	   0	0	0	0	#_MoveParm_A_seas_1_GP_1_from_4_to_1
  -16	 13	       1	       1	    0	0	 4	0	 0	   0	   0	0	0	0	#_MoveParm_B_seas_1_GP_1_from_4_to_1
  -16	 13	       1	       1	    0	0	 4	0	 0	   0	   0	0	0	0	#_MoveParm_A_seas_1_GP_1_from_4_to_3
  -16	 13	       1	       1	    0	0	 4	0	 0	   0	   0	0	0	0	#_MoveParm_B_seas_1_GP_1_from_4_to_3
  -16	 13	       1	       1	    0	0	 4	0	 0	   0	   0	0	0	0	#_MoveParm_A_seas_1_GP_1_from_3_to_4
  -16	 13	       1	       1	    0	0	 4	0	 0	   0	   0	0	0	0	#_MoveParm_B_seas_1_GP_1_from_3_to_4
  -10	 13	       1	       1	    0	0	 4	0	 0	   0	   0	0	0	0	#_FracFemale_GP_1                   
#_timevary MG parameters
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE
  0.5	   2	1.5	1	0.5	6	-7	#_RecrDist_GP_1_area_2_month_1_dev_se      
-0.99	0.99	  0	0	0.5	6	-6	#_RecrDist_GP_1_area_2_month_1_dev_autocorr
  0.5	   2	1.5	1	0.5	6	-7	#_RecrDist_GP_1_area_4_month_1_dev_se      
-0.99	0.99	  0	0	0.5	6	-6	#_RecrDist_GP_1_area_4_month_1_dev_autocorr
# info on dev vectors created for MGparms are reported with other devs after tag parameter section
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
8.5	   20	18.392	 13.9	    1	0	  1	0	0	0	0	0	0	0	#_SR_LN(R0)  
0.2	0.999	   0.8	0.777	0.113	2	 -4	0	0	0	0	0	0	0	#_SR_BH_steep
0.1	    2	   0.6	  0.4	  0.2	0	 -1	0	0	0	0	0	0	0	#_SR_sigmaR  
 -5	    6	     0	 -0.7	    2	0	 -1	0	0	0	0	0	0	0	#_SR_regime  
  0	    0	     0	    0	    0	0	-99	0	0	0	0	0	0	0	#_SR_autocorr
#_no timevary SR parameters
1 #do_recdev:  0=none; 1=devvector (R=F(SSB)+dev); 2=deviations (R=F(SSB)+dev); 3=deviations (R=R0*dev; dev2=R-f(SSB)); 4=like 3 with sum(dev2) adding penalty
1972 # first year of main recr_devs; early devs can preceed this era
2014 # last year of main recr_devs; forecast devs start in following year
2 #_recdev phase
1 # (0/1) to read 13 advanced options
-10 #_recdev_early_start (0=none; neg value makes relative to recdev_start)
3 #_recdev_early_phase
-99 #_forecast_recruitment phase (incl. late recr) (0 value resets to maxphase+1)
1 #_lambda for Fcast_recr_like occurring before endyr+1
1970 #_last_yr_nobias_adj_in_MPD; begin of ramp
1990 #_first_yr_fullbias_adj_in_MPD; begin of plateau
2014 #_last_yr_fullbias_adj_in_MPD
2015 #_end_yr_for_ramp_in_MPD (can be in forecast to shape ramp, but SS sets bias_adj to 0.0 for fcast yrs)
0.9618 #_max_bias_adj_in_MPD (-1 to override ramp and set biasadj=1.0 for all estimated recdevs)
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
0.6 # F ballpark
2001 # F ballpark year (neg value to disable)
3 # F_Method:  1=Pope; 2=instan. F; 3=hybrid (hybrid is recommended)
5 # max F or harvest rate, depends on F_Method
5 # N iterations for tuning F in hybrid method (recommend 3 to 7)
#
#_initial_F_parms; count = 0
#
#_Q_setup for fleets with cpue or survey data
#_fleet	link	link_info	extra_se	biasadj	float  #  fleetname
   17	1	 0	0	0	0	#_llcpue1   
   18	2	17	0	0	0	#_llcpue2   
   19	2	17	0	0	0	#_llcpue3   
   20	2	17	0	0	0	#_llcpue4   
-9999	0	 0	0	0	0	#_terminator
#_Q_parms(if_any);Qunits_are_ln(q)
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn  #  parm_name
-15	15	0	0	0	0	3	0	0	0	0	0	0	0	#_LnQ_base_llcpue1(17)
-15	15	0	0	0	0	3	0	0	0	0	0	0	0	#_LnQ_base_llcpue2(18)
-15	15	0	0	0	0	3	0	0	0	0	0	0	0	#_LnQ_base_llcpue3(19)
-15	15	0	0	0	0	3	0	0	0	0	0	0	0	#_LnQ_base_llcpue4(20)
#_no timevary Q parameters
#
#_size_selex_patterns
#_Pattern	Discard	Male	Special
24	0	0	 0	#_1 fishing_gi_1   
15	0	0	 1	#_2 fishing_gi_4   
24	0	0	 0	#_3 fishing_hd_1   
 1	0	0	 0	#_4 fishing_ll_1   
15	0	0	 4	#_5 fishing_ll_2   
15	0	0	 4	#_6 fishing_ll_3   
15	0	0	 4	#_7 fishing_ll_4   
24	0	0	 0	#_8 fishing_other_1
15	0	0	 8	#_9 fishing_other_4
24	0	0	 0	#_10 fishing_bb_1  
24	0	0	 0	#_11 fishing_ps_1  
15	0	0	11	#_12 fishing_ps_2  
15	0	0	11	#_13 fishing_ps_4  
24	0	0	 0	#_14 fishing_trol_1
15	0	0	14	#_15 fishing_trol_2
15	0	0	14	#_16 fishing_trol_4
15	0	0	 4	#_17 llcpue1       
15	0	0	 4	#_18 llcpue2       
15	0	0	 4	#_19 llcpue3       
15	0	0	 4	#_20 llcpue4       
#
#_age_selex_patterns
#_Pattern	Discard	Male	Special
0	0	0	0	#_1 fishing_gi_1   
0	0	0	0	#_2 fishing_gi_4   
0	0	0	0	#_3 fishing_hd_1   
0	0	0	0	#_4 fishing_ll_1   
0	0	0	0	#_5 fishing_ll_2   
0	0	0	0	#_6 fishing_ll_3   
0	0	0	0	#_7 fishing_ll_4   
0	0	0	0	#_8 fishing_other_1
0	0	0	0	#_9 fishing_other_4
0	0	0	0	#_10 fishing_bb_1  
0	0	0	0	#_11 fishing_ps_1  
0	0	0	0	#_12 fishing_ps_2  
0	0	0	0	#_13 fishing_ps_4  
0	0	0	0	#_14 fishing_trol_1
0	0	0	0	#_15 fishing_trol_2
0	0	0	0	#_16 fishing_trol_4
0	0	0	0	#_17 llcpue1       
0	0	0	0	#_18 llcpue2       
0	0	0	0	#_19 llcpue3       
0	0	0	0	#_20 llcpue4       
#
#_SizeSelex
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn  #  parm_name
  13	  70	  19	  15	0.01	0	 5	0	0	0	0	  0	0	0	#_SizeSel_P_1_fishing_gi_1(1)   
 -16	   2	 -16	  -2	0.01	0	 6	0	0	0	0	  0	0	0	#_SizeSel_P_2_fishing_gi_1(1)   
  -6	  14	   3	   4	0.01	0	 6	0	0	0	0	  0	0	0	#_SizeSel_P_3_fishing_gi_1(1)   
   1	  40	  40	  10	0.01	0	 6	0	0	0	0	  0	0	0	#_SizeSel_P_4_fishing_gi_1(1)   
-999	-999	-999	-999	0.01	0	-2	0	0	0	0	  0	0	0	#_SizeSel_P_5_fishing_gi_1(1)   
-999	-999	-999	-999	0.01	0	-2	0	0	0	0	  0	0	0	#_SizeSel_P_6_fishing_gi_1(1)   
  13	  70	  19	  15	0.01	0	 5	0	0	0	0	  0	0	0	#_SizeSel_P_1_fishing_hd_1(3)   
 -16	   2	 -16	  -2	0.01	0	 6	0	0	0	0	  0	0	0	#_SizeSel_P_2_fishing_hd_1(3)   
  -6	  14	   3	   4	0.01	0	 6	0	0	0	0	  0	0	0	#_SizeSel_P_3_fishing_hd_1(3)   
   1	  40	  40	  10	0.01	0	 6	0	0	0	0	  0	0	0	#_SizeSel_P_4_fishing_hd_1(3)   
-999	-999	-999	-999	0.01	0	-2	0	0	0	0	  0	0	0	#_SizeSel_P_5_fishing_hd_1(3)   
-999	-999	-999	-999	0.01	0	-2	0	0	0	0	  0	0	0	#_SizeSel_P_6_fishing_hd_1(3)   
  19	  70	  45	  50	  99	0	 5	0	0	0	0	0.5	0	0	#_SizeSel_P_1_fishing_ll_1(4)   
0.01	  60	  20	  15	  99	0	 5	0	0	0	0	0.5	0	0	#_SizeSel_P_2_fishing_ll_1(4)   
  13	  70	  19	  15	0.01	0	 5	0	0	0	0	  0	0	0	#_SizeSel_P_1_fishing_other_1(8)
 -16	   2	 -16	  -2	0.01	0	 6	0	0	0	0	  0	0	0	#_SizeSel_P_2_fishing_other_1(8)
  -6	  14	   3	   4	0.01	0	 6	0	0	0	0	  0	0	0	#_SizeSel_P_3_fishing_other_1(8)
   1	  40	  40	  10	0.01	0	 6	0	0	0	0	  0	0	0	#_SizeSel_P_4_fishing_other_1(8)
-999	-999	-999	-999	0.01	0	-2	0	0	0	0	  0	0	0	#_SizeSel_P_5_fishing_other_1(8)
-999	-999	-999	-999	0.01	0	-2	0	0	0	0	  0	0	0	#_SizeSel_P_6_fishing_other_1(8)
  13	  70	  19	  15	0.01	0	 5	0	0	0	0	  0	0	0	#_SizeSel_P_1_fishing_bb_1(10)  
 -16	   2	 -16	  -2	0.01	0	 6	0	0	0	0	  0	0	0	#_SizeSel_P_2_fishing_bb_1(10)  
  -6	  14	   3	   4	0.01	0	 6	0	0	0	0	  0	0	0	#_SizeSel_P_3_fishing_bb_1(10)  
   1	  40	  40	  10	0.01	0	 6	0	0	0	0	  0	0	0	#_SizeSel_P_4_fishing_bb_1(10)  
-999	-999	-999	-999	0.01	0	-2	0	0	0	0	  0	0	0	#_SizeSel_P_5_fishing_bb_1(10)  
-999	-999	-999	-999	0.01	0	-2	0	0	0	0	  0	0	0	#_SizeSel_P_6_fishing_bb_1(10)  
  13	  70	  19	  15	0.01	0	 5	0	0	0	0	  0	0	0	#_SizeSel_P_1_fishing_ps_1(11)  
 -16	   2	 -16	  -2	0.01	0	 6	0	0	0	0	  0	0	0	#_SizeSel_P_2_fishing_ps_1(11)  
  -6	  14	   3	   4	0.01	0	 6	0	0	0	0	  0	0	0	#_SizeSel_P_3_fishing_ps_1(11)  
   1	  40	  40	  10	0.01	0	 6	0	0	0	0	  0	0	0	#_SizeSel_P_4_fishing_ps_1(11)  
-999	-999	-999	-999	0.01	0	-2	0	0	0	0	  0	0	0	#_SizeSel_P_5_fishing_ps_1(11)  
-999	-999	-999	-999	0.01	0	-2	0	0	0	0	  0	0	0	#_SizeSel_P_6_fishing_ps_1(11)  
  13	  70	  19	  15	0.01	0	 5	0	0	0	0	  0	0	0	#_SizeSel_P_1_fishing_trol_1(14)
 -16	   2	 -16	  -2	0.01	0	 6	0	0	0	0	  0	0	0	#_SizeSel_P_2_fishing_trol_1(14)
  -6	  14	   3	   4	0.01	0	 6	0	0	0	0	  0	0	0	#_SizeSel_P_3_fishing_trol_1(14)
   1	  40	  40	  10	0.01	0	 6	0	0	0	0	  0	0	0	#_SizeSel_P_4_fishing_trol_1(14)
-999	-999	-999	-999	0.01	0	-2	0	0	0	0	  0	0	0	#_SizeSel_P_5_fishing_trol_1(14)
-999	-999	-999	-999	0.01	0	-2	0	0	0	0	  0	0	0	#_SizeSel_P_6_fishing_trol_1(14)
#_AgeSelex
#_No age_selex_parm
#_no timevary selex parameters
#
0 #  use 2D_AR1 selectivity(0/1):  experimental feature
#_no 2D_AR1 selex offset used
# Tag loss and Tag reporting parameters go next
1 # TG_custom:  0=no read; 1=read if tags exist
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env_var&link	dev_link	dev_minyr	dev_maxyr	dev_PH	Block	Block_Fxn
-10	10	-2	-7	0.001	1	   -4	0	0	0	0	0	0	0	#__TG_Loss_init_1  
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_2  
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_3  
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_4  
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_5  
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_6  
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_7  
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_8  
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_9  
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_10 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_11 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_12 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_13 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_14 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_15 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_16 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_17 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_18 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_19 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_20 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_21 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_22 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_23 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_24 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_25 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_26 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_27 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_28 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_29 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_30 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_31 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_32 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_33 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_34 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_35 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_36 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_37 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_38 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_39 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_40 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_41 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_42 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_43 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_44 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_45 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_46 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_47 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_48 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_49 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_50 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_51 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_52 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_53 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_54 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_55 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_56 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_57 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_58 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_59 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_60 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_61 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_62 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_63 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_64 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_65 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_66 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_67 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_68 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_69 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_70 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_71 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_72 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_73 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_74 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_75 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_76 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_77 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_78 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_79 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_80 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_81 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_82 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_83 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_84 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_85 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_86 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_87 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_88 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_89 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_90 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_91 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_92 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_93 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_94 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_95 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_96 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_97 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_98 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_99 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_100
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_101
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_102
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_103
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_104
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_105
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_106
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_107
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_108
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_109
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_110
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_111
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_112
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_113
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_114
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_115
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_116
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_117
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_118
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_119
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_120
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#__TG_Loss_init_121
-10	10	-4	-7	0.001	1	   -4	0	0	0	0	0	0	0	#_TG_Loss_chronic_1  
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_2  
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_3  
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_4  
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_5  
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_6  
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_7  
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_8  
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_9  
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_10 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_11 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_12 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_13 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_14 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_15 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_16 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_17 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_18 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_19 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_20 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_21 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_22 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_23 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_24 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_25 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_26 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_27 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_28 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_29 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_30 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_31 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_32 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_33 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_34 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_35 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_36 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_37 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_38 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_39 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_40 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_41 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_42 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_43 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_44 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_45 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_46 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_47 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_48 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_49 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_50 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_51 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_52 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_53 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_54 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_55 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_56 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_57 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_58 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_59 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_60 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_61 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_62 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_63 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_64 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_65 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_66 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_67 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_68 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_69 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_70 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_71 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_72 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_73 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_74 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_75 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_76 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_77 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_78 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_79 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_80 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_81 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_82 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_83 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_84 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_85 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_86 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_87 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_88 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_89 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_90 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_91 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_92 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_93 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_94 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_95 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_96 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_97 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_98 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_99 
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_100
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_101
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_102
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_103
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_104
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_105
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_106
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_107
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_108
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_109
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_110
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_111
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_112
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_113
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_114
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_115
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_116
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_117
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_118
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_119
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_120
-10	10	-7	-7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_Loss_chronic_121
1	10	2	2	0.001	1	   -4	0	0	0	0	0	0	0	#_TG_overdispersion_1  
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_2  
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_3  
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_4  
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_5  
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_6  
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_7  
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_8  
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_9  
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_10 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_11 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_12 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_13 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_14 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_15 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_16 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_17 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_18 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_19 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_20 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_21 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_22 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_23 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_24 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_25 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_26 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_27 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_28 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_29 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_30 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_31 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_32 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_33 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_34 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_35 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_36 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_37 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_38 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_39 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_40 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_41 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_42 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_43 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_44 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_45 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_46 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_47 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_48 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_49 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_50 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_51 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_52 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_53 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_54 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_55 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_56 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_57 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_58 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_59 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_60 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_61 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_62 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_63 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_64 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_65 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_66 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_67 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_68 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_69 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_70 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_71 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_72 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_73 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_74 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_75 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_76 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_77 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_78 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_79 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_80 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_81 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_82 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_83 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_84 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_85 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_86 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_87 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_88 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_89 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_90 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_91 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_92 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_93 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_94 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_95 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_96 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_97 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_98 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_99 
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_100
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_101
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_102
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_103
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_104
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_105
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_106
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_107
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_108
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_109
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_110
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_111
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_112
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_113
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_114
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_115
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_116
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_117
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_118
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_119
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_120
1	10	2	2	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_overdispersion_121
-10	10	-9	7	0.001	1	   -4	0	0	0	0	0	0	0	#_TG_report_fleet_par_1 
-10	10	-9	7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_report_fleet_par_2 
-10	10	-9	7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_report_fleet_par_3 
-10	10	-9	7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_report_fleet_par_4 
-10	10	-9	7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_report_fleet_par_5 
-10	10	-9	7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_report_fleet_par_6 
-10	10	-9	7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_report_fleet_par_7 
-10	10	-9	7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_report_fleet_par_8 
-10	10	-9	7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_report_fleet_par_9 
-10	10	-9	7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_report_fleet_par_10
-10	10	 7	7	0.001	1	    4	0	0	0	0	0	0	0	#_TG_report_fleet_par_11
-10	10	 7	7	0.001	1	    4	0	0	0	0	0	0	0	#_TG_report_fleet_par_12
-10	10	 7	7	0.001	1	    4	0	0	0	0	0	0	0	#_TG_report_fleet_par_13
-10	10	-9	7	0.001	1	   -4	0	0	0	0	0	0	0	#_TG_report_fleet_par_14
-10	10	-9	7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_report_fleet_par_15
-10	10	-9	7	0.001	1	-1000	0	0	0	0	0	0	0	#_TG_report_fleet_par_16
-4	0	-3	0	2	6	   -4	0	0	0	0	0	0	0	#_TG_report_decay_par_1 
-4	0	-3	0	2	6	-1000	0	0	0	0	0	0	0	#_TG_report_decay_par_2 
-4	0	-3	0	2	6	-1000	0	0	0	0	0	0	0	#_TG_report_decay_par_3 
-4	0	-3	0	2	6	-1000	0	0	0	0	0	0	0	#_TG_report_decay_par_4 
-4	0	-3	0	2	6	-1000	0	0	0	0	0	0	0	#_TG_report_decay_par_5 
-4	0	-3	0	2	6	-1000	0	0	0	0	0	0	0	#_TG_report_decay_par_6 
-4	0	-3	0	2	6	-1000	0	0	0	0	0	0	0	#_TG_report_decay_par_7 
-4	0	-3	0	2	6	-1000	0	0	0	0	0	0	0	#_TG_report_decay_par_8 
-4	0	-3	0	2	6	-1000	0	0	0	0	0	0	0	#_TG_report_decay_par_9 
-4	0	-3	0	2	6	-1000	0	0	0	0	0	0	0	#_TG_report_decay_par_10
-4	0	 0	0	2	6	    4	0	0	0	0	0	0	0	#_TG_report_decay_par_11
-4	0	 0	0	2	6	    4	0	0	0	0	0	0	0	#_TG_report_decay_par_12
-4	0	 0	0	2	6	    4	0	0	0	0	0	0	0	#_TG_report_decay_par_13
-4	0	-3	0	2	6	   -4	0	0	0	0	0	0	0	#_TG_report_decay_par_14
-4	0	-3	0	2	6	-1000	0	0	0	0	0	0	0	#_TG_report_decay_par_15
-4	0	-3	0	2	6	-1000	0	0	0	0	0	0	0	#_TG_report_decay_par_16
# Input variance adjustments factors: 
#_Factor Fleet Value
-9999 1 0 # terminator
#
1 #_maxlambdaphase
1 #_sd_offset; must be 1 if any growthCV, sigmaR, or survey extraSD is an estimated parameter
# read 0 changes to default Lambdas (default value is 1.0)
-9999 0 0 0 0 # terminator
#
0 # 0/1 read specs for more stddev reporting
#
999
