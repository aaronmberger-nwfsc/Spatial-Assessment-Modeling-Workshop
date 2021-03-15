![currents](https://user-images.githubusercontent.com/62513493/111212141-79c80780-858c-11eb-8569-5468d74bfa3f.pngv=4&s=200

An Introduction to the Workshop and Experimental Design

# Workshop summary

Many generic assessment platforms utilize common mathematical formulations for single area population models. However, for assessment frameworks capable of incorporating spatial structure, the methods and assumptions associated with spatial dynamics are not as uniform. Variability in spatial capabilities among assessment software likely influence the decision-making process for assessment analysts and may impact the resulting interpretation of population status. Additionally, approaches for identifying model misspecification due to spatial structure within spatially aggregated or spatially explicit models have not been well documented. Exploring and comparing how analysts familiar with spatial assessment platforms develop spatial models given the capabilities and limitations of different assessment packages can help formulate guidance on best practices for spatial stock assessment models. Similarly, discussions among researchers across regions and fisheries agencies will enable identification of critical spatial modeling capabilities that should be incorporated into the next generation of generic spatial stock assessment software. This document provides an overview of the Spatial Stock Assessment Methods Workshop and associated simulation experiment, highlighting the overarching aims, scope, and approach to be utilized. 

# Experiment Overview

The main feature of the workshop will be a spatial simulation experiment, which brings together assessment analysts familiar with developing spatial stock assessment models from across the globe. The simulation experiment is designed to elicit feedback on the existing suite of spatial stock assessment packages, while comparing similarities and differences across platforms (Table 1). By exploring capabilities across spatial assessment models, the study will help summarize existing spatial capabilities, identify existing limitations and research needs, and determine components that need to be incorporated into the next generation of spatial stock assessment models. Additionally, discussions around the model building process undertaken by each analyst will help provide guidance on best practices for developing spatial models, including approaches to identify when spatial models are warranted (e.g., through residual analysis). The main objectives of the simulation experiment are to:

1.	**OBJECTIVE #1: Discuss best practices in spatial model development by exploring the decision-points performed by each analyst, which will highlight how fundamental differences in each platform influence decisions during each stage of development of a spatial stock assessment model, provide insight into why analysts choose certain spatial functionality, and how goodness of fit is determined in a spatial context;** 

2.	**OBJECTIVE #2: Evaluate within platform performance and the impact of ignoring spatial structure by comparing spatial and spatially aggregated model configurations;**  

3.	**OBJECTIVE #3: Explore general performance across different categories of spatial models (e.g., non-spatial, spatially-implicit, spatially-stratified, and fully spatiotemporal) by comparing bias and precision across the broad categories.** 

To achieve these goals, a fine-scale, spatially complex operating model developed with the Spatial Population Model (SPM) and tailored to Indian Ocean yellowfin tuna (YFT; *Thunnus albacares*)[^1] will be utilized. The operating model will provide simulated pseudo-data that reflects patterns of stochasticity and observation error, which mimic realistic real world applications. Each analyst will be provided an identical background document on the operating model from which to begin development of their chosen assessment application, including information on population structure, demographic rates, data sources, and error structure. Similarly, detailed guidance will be provided on how to summarize results and report to the workshop. Stock assessment models developed to fit simulated data will be explored as a research exercise and will not replace or supplement existing operational stock assessments for any species or fisheries management organization.

We envision three primary stages of model development that each analyst will need to document (Figure 1). First, analysts will be provided a representative data set aggregated at two spatial scales: one area (fully aggregated) and four areas (spatially stratified). Each analyst will be expected to then develop a panmictic model (applied to the fully aggregated data) and a spatial model (applied to the four area spatially stratified data). Analysts will then document decision-points made at each stage of model development focusing primarily on development of the spatially explicit model, including why spatial assumptions were utilized, how model fit to the data was assessed, and how/why model tweaks were made during this process (Objective #1). Next, the final panmictic and spatial models will be applied to 100 simulated data sets (at the respective spatial aggregations of the model development stage). The authors will then provide brief comparisons of model estimates and data fits across the two parametrizations of their model, as well as, any alternate spatial parametrizations that they wish to develop and discuss (Objective #2). 

[^1] *Pending participant interest, workshop organizers will be able to provide (at a later date) datasets from a second spatially complex operating model developed with SPM and tailored to Antarctic Toothfish (AT; Dissostichus mawsoni).* 

**Table 1) Spatial stock assessment modeling platforms and models that have confirmed participation in the simulation experiment and workshop. (This is a working list that is subject to change).**

| Stock Assessment platform or model | Acronym |
| ------------- | ------------- |
| Metapopulation Assessment System | MAS |
| Globally Applicable Area-Disaggregated Ecosystem ToolBox | GADGET |
| Stock Synthesis 3 | SS3 |
| C++ Algorithmic Stock Assessment Laboratory |CASAL|
| C++ Algorithmic Stock Assessment Laboratory (2nd generation) | CASAL2 |
| MULTIFAN - CL | MFCL |
| Assessment for All | a4a |
| Spatial Processes And Stock Assessment Methods | SPASAM |
| Spatiotemporal Models | - |
| Recapture Conditioned Models | - |
| Several Other Bespoke Models | - |

Finally, each analyst group will be expected to provide an approximately one hour virtual seminar highlighting their model framework, walking workshop participants through their decision-point model building approach, illustrating model fits (to both the representative and full 100 data sets), and comparing outputs and residual analysis from their panmictic and spatially explicit models. Specific model results (e.g., time series of area-specific SSB, depletion, recruitment, fishing mortality, and residuals) will also be provided to the workshop hosts in a format specified at the outset, which will allow comparisons (by the workshop hosts) to the true population trajectories across categories of spatial models (Objective #3). Upon completion of the series of virtual seminars in late 2021 (Figure 2), an in-person workshop (2022, location and dates TBA) will be held to discuss best practices and salient features of the next generation of spatial models.

![overview_fig_v3](https://user-images.githubusercontent.com/62513493/110732345-e16f0300-81d8-11eb-9b13-8fac3ae7cc64.png)
**Fig. 1) Stages of model development for the simulation experiment conceptual flowchart as applied to each stock assessment platform.**

[^1]: *Pending participant interest, experiment organizers will be able to provide (at a later date) datasets from a second spatially complex operating model developed with SPM and tailored to Antarctic Toothfish (AT; *Dissostichus mawsoni*).* 

# Timeframe
The simulation experiment will occur over a ~12 month period, culminating in a seminar series to share individual and collective results. A follow-up in-person workshop is tentatively planned for 2022 to provide a forum for discussion of spatial modeling best practices and key features of future spatial assessment platforms. An outline of the experimental timeline, including key milestones, is described here and summarized in Figures 1 and 2.

## Key milestones for simulation experiment
1. Background documents distributed to each analyst and an introductory webinar held to describe the process and answer questions (~ May 2021)
1. Simulated YFT pseudo-data (100 datasets) will be provided to analysts, where each simulated data set will be provided at two spatial aggregations (single area and four area; ~ May 2021)
1. Analysts develop and apply their chosen assessment platform to the simulated data (June 2021 - September 2021)
- a.	Using the single representative dataset (for each configuration: aggregated and spatially stratified) as determined by workshop hosts, analysts document their model building decision process at each stage of model development, focusing on key spatial assumptions, diagnostics, and residual analysis (**decision-point analysis, Objective #1**)  
- b.	Analysts iteratively apply their model to the remaining 99 datasets (for each configuration: aggregated and spatially stratified) without making any structural model changes.  
- c.	*(Optional)* Analysts develop alternate spatial model parametrizations (e.g., 2 spatial areas) and iteratively apply it to each of the 100 simulated datasets.
- d.	Analysts summarize the results across all 100 model runs for each model parametrization and develop comparison graphics/metrics to compare performance across their panmictic and spatially explicit models (**within platform comparison, Objective #2**)
- e.	Analysts provide model results (for all 100 runs for each model configuration) to the workshop organizers in a format to be announced, which will allow workshop hosts to compare results to true simulated dynamics (**cross spatial model category performance evaluation, Objective #3**)
1. Analysts develop a 30 minute presentation for a 1 hour discussion-based seminar where workshop participants can interact to discuss each analysts modeling process and decision points (October 2021 – March 2022)
1. Analysts present and participate in the virtual discussion-based seminar series which will highlight the various platforms utilized (October 2021-March 2022)
1. Analysts attend an in-person workshop to continue discussions focused on best practices and key components of the next generation of spatial stock assessment model features (2022)
1. Analysts and workshop organizers collaboratively provide text, feedback, and edits on a manuscript highlighting the key findings of the experiment and workshop (2022)

![gantt_chart_v4](https://user-images.githubusercontent.com/62513493/110732398-f77cc380-81d8-11eb-9385-93ab0f2214d7.png)
**Fig. 2) Overview of key milestones associated with the simulation experiment study design.**

# Next steps

Analysts should expect to receive a “Guidance Document” by May 2021 that describes important background information, details about the YFT operating model, and further guidance for conducting analyses. Shortly thereafter, data sets will be disseminated and a webinar will be held to provide a verbal overview of the experiment and to hold a Q&A session.

We look forward to working with you. Thank you for your participation!

# Contacts
Please contact Caren Barcelo (caren.barcelo@noaa.gov), Aaron Berger (aaron.berger@noaa.gov), Dan Goethel (daniel.goethel@noaa.gov), or Simon Hoyle (simon.hoyle@niwa.co.nz) on behalf of the workshop Working Group and Steering Committee with any questions or inquiries at this time.

| Working Group | WG Affiliation | Steering Committee | SG Affiliation |
| ------------- | ------------- | ------------- | ------------- |
| Caren Barceló | ECS supporting NOAA | Pamela Mace | Fisheries NZ|
| Aaron Berger | NOAA | Mark Maunder | IATTC|
| Daniel Goethel | NOAA | Rick Methot | NOAA|
| Simon Hoyle | NIWA | Rich Little | CSIRO |
| Alistair Dunn | Ocean Environmental | Paul DeBruyn | IOTC/FAO |
| Patrick Lynch | NOAA | Rosemary Hurst| NIWA |
| Jeremy McKenzie | NIWA ||
| Jennifer Devine  | NIWA | |
| Craig Marsh  | U of Aukland ||

