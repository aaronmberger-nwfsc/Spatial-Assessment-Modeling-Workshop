# Welcome to the Spatial Stock Assessment Simulation Experiment!

# Workshop summary

Many generic assessment platforms use the same mathematical formulations for single area population models. In contrast, assessment frameworks use a range of methods and assumptions to model spatial dynamics. The spatial capabilities of assessment software influence the decision-making process for assessment analysts and may affect how analysts interpret population status. Moreover, there is little guidance on how to identify model misspecification resulting from spatial structure within spatially aggregated or spatially explicit models. Given this diversity of approaches and limited documentation, the Spatial Stock Assessment Methods Workshop will explore and compare how analysts familiar with spatial assessment platforms develop spatial models, and formulate guidance on best practices for spatial stock assessment modeling. Discussions among researchers across regions and fisheries agencies will help to identify critical spatial modeling capabilities that should be incorporated into the next generation of generic spatial stock assessment software. This document provides an overview of the Spatial Stock Assessment Methods Workshop and associated simulation experiment, highlighting the overarching aims, scope, and approach. 

**Spatial simulation experiment event schedule for sharing project-related information and results.**

| Dates* | Time | Location | Presentation 1 | Presentation 2 | Presentation 3 | Wrap-up Discussion |
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| Oct 13, 2022 | 1300 - 1600 | Virtual Webinar 1ᵃ | Introduction (Organizers; 30 min) | Team CASAL YFT (60 min) | Team SS/VAST-IATTC (60 min) | 30 min |
| Nov 21, 2022 | 2100 - 2330 | Virtual Webinar 2ᵇ | Team MFCL (60 min) | Team SS-IOTC (60 min) | -- | 30 min |
| Dec 12, 2022 | 1100 - 1430 | Virtual Webinar 3ᶜ | Team SS-ICES (60 min) | Team Gadget (60 min) | Team CASAL2 TOA (60 min) | 30 min |
| Jan 5, 2023 | 1200 - 1430 | Virtual Webinar 4ᵈ | Team Spatiotemporal (60 min) | Team SPASAM (60 min) | -- | 30 min |
| Mar 5-7, 2023 | 2.5 days | Prefab Hall, Wellington, NZ | Agenda forthcoming -- | -- | -- | 30 min |

(*) Dates and times are listed as U.S. Pacific Time\
ᵃ MS Teams connection details: meeting id - 444 541 045 841, passcode - 6TsAbz (see calender invite for direct links)\
ᵇ MS Teams connection details:  meeting id - 473 427 490 516, passcode - T43jGM (see calender invite for direct links)\
ᶜ MS Teams connection details:  meeting id - 410 348 618 239, passcode - rqCQYq (see calender invite for direct links)\
ᵈ MS Teams connection details:  meeting id - 468 299 151 35, passcode - fGKe8u (see calender invite for direct links)

# Experiment Overview

The main feature of the workshop will be a spatial simulation experiment, which brings together assessment analysts and spatial stock assessment software from across the globe. The simulation experiment is designed to elicit feedback on the existing suite of spatial stock assessment packages, while comparing approaches across platforms (Table 1). By exploring capabilities across spatial assessment models, the study will help summarize existing spatial capabilities, identify limitations and research needs, and determine components to incorporate in the next generation of spatial stock assessment models. Additionally, discussions of each analyst’s model building process will help to create guidance on best practices for developing spatial models, including how to identify when spatial models are warranted (e.g., through residual analysis). The main objectives of the simulation experiment are to:

**1. OBJECTIVE #1: Discuss best practices in spatial model development by exploring the decision-points of each analyst. This will highlight how differences among platforms influence decisions at each stage of development of a spatial stock assessment model, provide insight into why analysts choose certain spatial functionality, and how goodness of fit is determined in a spatial context;** 

**2. OBJECTIVE #2: Evaluate within-platform performance and the impacts of ignoring spatial structure by comparing spatial and spatially aggregated model configurations; and**  

**3. OBJECTIVE #3: Explore general performance across different categories of spatial models (e.g., non-spatial, spatially-implicit, spatially-stratified, and fully spatiotemporal) by comparing bias and precision across the broad model categories.** 

To achieve these goals, we have used the Spatial Population Model (SPM) software to develop two fine-scale, spatially complex operating models. The first is tailored to Indian Ocean yellowfin tuna (YFT; *Thunnus albacares*), with a second (available at a later date) tailored to Antarctic Toothfish (TOA; *Dissostichus mawsoni*). Each operating model will provide simulated pseudo-data that reflects patterns of stochasticity and observation error, which mimic realistic real-world applications. Analysts will receive a background document on the operating model, including information on population structure, demographic rates, data sources, and error structure. Similarly, they will receive detailed guidance on how to summarize results and report to the workshop. **Please note that these stock assessment models, developed to fit simulated data, will be explored as a research exercise and will not replace or supplement existing operational stock assessments for any species or fisheries management organization.**

We envision three primary stages of model development that each analyst should document (Figure 1). First, for the YFT case study, analysts will receive a representative data set from the SPM simulation model conditioned on the existing data and known dynamics and including simulated observation error, which will be aggregated at two spatial scales: one area (fully aggregated) and four areas (spatially stratified). Additionally, upon request, workshop organizers can provide the spatially disaggregated data (159 spatial cells at a 5x5 degree resolution) from the SPM operating model. Each analyst will then develop a panmictic model (applied to the fully aggregated data) and a spatial model (applied to the four area spatially stratified data). Analysts should document decision-points at each stage of model development, focusing primarily on development of the spatially explicit model, including why spatial assumptions were used, how the data was assessed, and how/why model tweaks were made during this process (Objective #1). 

**Table 1) Spatial stock assessment modeling platforms and models that have confirmed participation in the simulation experiment and workshop. (This is a working list that is subject to change).**

| Stock Assessment platform or model | Acronym |
| ------------- | ------------- |
| Metapopulation Assessment System | MAS |
| Globally Applicable Area-Disaggregated Ecosystem ToolBox | GADGET |
| Stock Synthesis 3 | SS3 |
| Stock Synthesis 3 with Areas-As-Fisheries | SS3 with AAF|
| C++ Algorithmic Stock Assessment Laboratory |CASAL|
| C++ Algorithmic Stock Assessment Laboratory (2nd generation) | CASAL2 |
| MULTIFAN - CL | MFCL |
| Assessment for All | a4a |
| Spatial Processes And Stock Assessment Methods | SPASAM |
| Spatiotemporal Models | - |
| Recapture Conditioned Models | - |
| Several Other Bespoke Models | - |

Next, the final panmictic and spatial models will be applied to 100 simulated data sets (at the respective spatial aggregations of the model development stage), which will include stochasticity in recruitment processes along with observation error in each simulation run. The analysts will then provide brief comparisons of model estimates and data fits across the two parametrizations of their model, as well as any alternate spatial parametrizations that they wish to develop and discuss (Objective #2). 

Finally, each analyst group will provide an approximately one hour virtual seminar highlighting their model framework, walking workshop participants through their decision-point model building approach, illustrating model fits (to both the representative and full 100 data sets), and comparing outputs and residual analysis from their panmictic and spatially explicit models. Specific model results (e.g., time series of area-specific SSB, depletion, recruitment, fishing mortality, and residuals) will be provided to the workshop in a format specified at the outset, which will allow comparisons (by the workshop hosts) to the true population trajectories across categories of spatial models (Objective #3). Upon completion of the series of virtual seminars in late 2021 (Figure 2), an in-person workshop (2022, location and dates TBA) will be held to discuss best practices and salient features of the next generation of spatial models.

![analyst process](https://user-images.githubusercontent.com/62513493/114226168-18dfe500-9928-11eb-88ed-1af8eac4f6ec.png)
**Fig. 1) Stages of model development for the YFT simulation experiment conceptual flowchart as applied to each stock assessment platform.**

# Timeframe
The simulation experiment will occur over a ~12-month period, culminating in a seminar series to share individual and collective results. A follow-up in-person workshop is tentatively planned for 2022 to provide a forum for discussion of spatial modeling best practices and key features of future spatial assessment platforms. An outline of the experimental timeline for the YFT study, including key milestones, is described here and summarized in Figures 1 and 2. Dates in 2021 for the AT simulation experiment are expected to be 2 months later, but we aim to maintain 2022 in-person workshop plans to discuss results for both case species.  

## Key milestones for simulation experiment
1. Background documents distributed to each analyst and an introductory webinar held to describe the process and answer questions (May 2021)
1. The single representative simulated YFT pseudo-data set will be provided to analysts at two spatial aggregations (single area and four area; ~ May 2021); soon thereafter the remaining 100 datasets, which include recruitment stochasticity, will be provided (~June 2021) 
1. Analysts develop and apply their chosen assessment platform to the simulated data (June 2021 - September 2021)
- a.	Using the single representative dataset (for each configuration: aggregated and spatially stratified), analysts document their model building decision process at each stage of model development, focusing on key spatial assumptions, diagnostics, and residual analysis (**decision-point analysis, Objective #1**)  
- b.  Analysts iteratively apply their model to the 100 datasets that include recruitment stochasticity (for each configuration: aggregated and spatially stratified) without making any structural model changes.   
- c.	*(Optional)* Analysts develop alternate spatial model parametrizations (e.g., 2 spatial areas, or with different parameterizations of movement or recruitment or selectivity) and apply it to each of the 100 simulated datasets.
- d.	Analysts summarize the results across all 100 model runs for each model parametrization and develop comparison graphics/metrics to compare performance across their panmictic and spatially explicit models  (**within platform comparison, Objective #2**)
- e.	Analysts provide model results (for the representative data set and all 100 simulation runs for each model configuration) to the workshop organizers in a format to be announced, which will allow workshop hosts to compare results to true simulated dynamics (**cross spatial model category performance evaluation, Objective #3**)
1. Analysts develop a 30 minute presentation for a 1 hour discussion-based seminar where workshop participants can interact to discuss each analyst’s modeling process and decision points (October 2021 – March 2022)
1. Analysts present and participate in the virtual discussion-based seminar series which will highlight the various platforms utilized (October 2021-March 2022)
1. Analysts attend an in-person workshop to continue discussions focused on best practices and key components of the next generation of spatial stock assessment model features  (2022)
1. Analysts and workshop organizers collaboratively provide text, feedback, and edits on a manuscript (to be submitted to a peer reviewed journal) highlighting the key findings of the experiment and workshop (2022)

![gantt_v6](https://user-images.githubusercontent.com/62513493/114226269-3c0a9480-9928-11eb-87c7-71442d11b837.png)
**Fig. 2) Overview of key milestones associated with the YFT simulation experiment study design.**

# Next steps

Analysts should expect to receive a “Guidance Document” in the coming weeks just prior to the introductory webinar that describes important background information, details about the YFT operating model, and further guidance for conducting analyses. Shortly thereafter, data sets will be disseminated and a webinar will be held (please add your availability for the webinar to the doodle poll) to provide a verbal overview of the experiment and to hold a Q&A session. A second guidance document will be sent out for the TOA operating model (once available). Background information and associated documents will be added to this GitHub repository, as will datasets once available. Results relative to study objectives will be collated and submitted for peer-reviewed publication, and participation in the simulation experiment will merit an offer to be an author on relevant manuscripts. 

We understand that the time commitment to develop and run models is not trivial. While the scientific rigor and robustness of results will be highest with full participation, the organizers understand that everyone is busy. The experimental timeline was developed with extended milestones to offer enough time-constraint flexibility to accommodate individual needs.  Nonetheless, please contact us regarding your individual situation as needed.

We look forward to working with you. Thank you for your participation!

# Contacts
Please contact Caren Barcelo (caren.barcelo@noaa.gov), Aaron Berger (aaron.berger@noaa.gov), Dan Goethel (daniel.goethel@noaa.gov), Patrick Lynch (patrick.lynch@noaa.gov), or Simon Hoyle (simon.hoyle@niwa.co.nz) on behalf of the workshop Working Group and Steering Committee with any questions or inquiries at this time.

| Working Group | WG Affiliation | Steering Committee | SG Affiliation |
| ------------- | ------------- | ------------- | ------------- |
| Caren Barceló | ECS supporting NOAA | Pamela Mace | Fisheries NZ|
| Aaron Berger | NOAA | Mark Maunder | IATTC|
| Daniel Goethel | NOAA | Rick Methot | NOAA|
| Simon Hoyle | NIWA | Rich Little | CSIRO |
| Alistair Dunn | Ocean Environmental | Paul DeBruyn | IOTC/FAO |
| Patrick Lynch | NOAA | Richard O’Driscoll | NIWA |
| Jeremy McKenzie | NIWA ||
| Jennifer Devine  | NIWA | |
| Craig Marsh  | NIWA ||

## Disclaimer

“The United States Department of Commerce (DOC) GitHub project code is provided on an ‘as is’ basis and the user assumes responsibility for its use. DOC has relinquished control of the information and no longer has responsibility to protect the integrity, confidentiality, or availability of the information. Any claims against the Department of Commerce stemming from the use of its GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.”

<img src="https://raw.githubusercontent.com/nmfs-general-modeling-tools/nmfspalette/main/man/figures/noaa-fisheries-rgb-2line-horizontal-small.png" height="75" alt="NOAA Fisheries"> 

[U.S. Department of Commerce](https://www.commerce.gov/) | [National Oceanographic and Atmospheric Administration](https://www.noaa.gov) | [NOAA Fisheries](https://www.fisheries.noaa.gov/)