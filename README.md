# RFS_filters
This repository will be a home to the RFS based particle filters.

Motion models available:
  * CV, CA or CT motion models.
  * 2-D or 3-D problems.
  * 2-D CV models accounts for the observer motion (observer accelerations).

Measurement models available:
  * linear        : 2-D and 3-D, for CA and CV motion models.
  * nonlinear     : bearings-only (2-D only, for now).

Bootstrap particle filter available (not tested)
  * uniform resampling procedure (SIS). 

To be added:
  * sensor control function (as a control input to the dynamic system model).
  * adaptation to the Bernoulli (after that Multi Bernoulli) filter concept.
  * some evolutionary approach for the resampling procedure.
  * data generation module.
