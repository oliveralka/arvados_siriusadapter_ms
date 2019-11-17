#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand: [MetaboliteAdductDecharger]

requirements:
- class: ScatterFeatureRequirement
- class:  ResourceRequirement
  ramMin: 1000
  coresMin: 1
  coresMax: 1
  
inputs:
  in_featureXML:
    type: File?
    inputBinding:
      prefix: -in
  algorithm:MetaboliteFeatureDeconvolution:charge_min:
    type: int
    inputBinding:
      prefix: -algorithm:MetaboliteFeatureDeconvolution:charge_min
    default: 1
    doc: Minimal possible charge.
  algorithm:MetaboliteFeatureDeconvolution:charge_max:
    type: int
    inputBinding:
      prefix: -algorithm:MetaboliteFeatureDeconvolution:charge_max
    default: 3
    doc: Maximal possible charge.
  algorithm:MetaboliteFeatureDeconvolution:charge_span_max: #how to set a minimum of 1 !!
    type: int
    inputBinding:
      prefix: -algorithm:MetaboliteFeatureDeconvolution:charge_span_max
    default: 3
    doc: Maximal range of charges for a single analyte, i.e. observing q1=[5,6,7] implies span=3. Setting this to 1 will only find adduct variants of the same charge.
  algorithm:MetaboliteFeatureDeconvolution:q_try:
    type:
      name: algorithm:MetaboliteFeatureDeconvolution:q_try
      type: enum
      symbols: [feature, heuristic, all]
    inputBinding:
      prefix: -algorithm:MetaboliteFeatureDeconvolution:q_try
    default: feature
    doc: Try different values of charge for each feature according to the above settings ('heuristic' [does not test all charges, just the likely ones] or 'all' ), or leave feature charge untouched ('feature').    
  algorithm:MetaboliteFeatureDeconvolution:retention_max_diff:
    type: float
    inputBinding:
      prefix: -algorithm:MetaboliteFeatureDeconvolution:retention_max_diff
    default: 1.0
    doc: Maximum allowed RT difference between any two features if their relation shall be determined.
  algorithm:MetaboliteFeatureDeconvolution:retention_max_diff_local:
    type: float
    inputBinding:
      prefix: -algorithm:MetaboliteFeatureDeconvolution:retention_max_diff_local
    default: 1.0
    doc: Maximum allowed RT difference between between two co-features, after adduct shifts have been accounted for (if you do not have any adduct shifts, this value should be equal to 'retention_max_diff', otherwise it should be smaller!)
  algorithm:MetaboliteFeatureDeconvolution:mass_max_diff:
    type: float
    inputBinding:
      prefix: -algorithm:MetaboliteFeatureDeconvolution:mass_max_diff
    default: 0.05
    doc: Maximum allowed mass tolerance per feature. Defines a symmetric tolerance window around the feature. When looking at possible feature pairs, the allowed feature-wise errors are combined for consideration of possible adduct shifts. For ppm tolerances, each window is based on the respective observed feature mz (instead of putative experimental mzs causing the observed one)!
  algorithm:MetaboliteFeatureDeconvolution:unit:
    type:
      name: algorithm:MetaboliteFeatureDeconvolution:unit
      type: enum
      symbols: [Da, ppm]
    inputBinding:
      prefix: -algorithm:MetaboliteFeatureDeconvolution:unit
    default: feature
    doc:  Unit of the 'max_difference' parameter.
  algorithm:MetaboliteFeatureDeconvolution:potential_adducts: #anything better for a list? 
    type: string
    inputBinding:
      prefix: -algorithm:MetaboliteFeatureDeconvolution:potential_adducts
    default: "[H:+:0.4 Na:+:0.25 NH4:+:0.25 K:+:0.1 H-2O-1:0:0.05]"
    doc:  Adducts used to explain mass differences in format: 'Elements:Charge(+/-/0):Probability[:RTShift[:Label]]', i.e. the number of '+' or '-' indicate the charge ('0' if neutral adduct), e.g. 'Ca:++:0.5' indicates +2. Probabilites have to be in (0,1]. The optional RTShift param indicates the expected RT shift caused by this adduct, e.g. '(2)H4H-4:0:1:-3' indicates a 4 deuterium label, which causes early elution by 3 seconds. As fifth parameter you can add a label for every feature with this adduct. This also determines the map number in the consensus file. Adduct element losses are written in the form 'H-2'. All provided adducts need to have the same charge sign or be neutral! Mixing of adducts with different charge directions is only allowed as neutral complexes. For example, 'H-1Na:0:0.05' can be used to model Sodium gains (with balancing deprotonation) in negative mode.
  algorithm:MetaboliteFeatureDeconvolution:max_neutralsx: 
    type: int
    inputBinding:
      prefix: -algorithm:MetaboliteFeatureDeconvolution:max_neutrals
    default: 1
    doc: Maximal number of neutral adducts(q=0) allowed. Add them in the 'potential_adducts' section! 
  algorithm:MetaboliteFeatureDeconvolution:use_minority_bound:
    type:
     type: boolean?
    inputBinding:
      prefix: -algorithm:MetaboliteFeatureDeconvolution:use_minority_bound
    default: true
    doc: Prune the considered adduct transitions by transition probabilities.  
  algorithm:MetaboliteFeatureDeconvolution:max_minority_bound: #how to set a minimum of 0 !!
    type: int
    inputBinding:
      prefix: -algorithm:MetaboliteFeatureDeconvolution:max_minority_bound
    default: 3
    doc: Limits allowed adduct compositions and changes between compositions in the underlying graph optimization problem by introducing a probability-based threshold: the minority bound sets the maximum count of the least probable adduct (according to 'potential_adducts' param) within a charge variant with maximum charge only containing the most likely adduct otherwise. E.g., for 'charge_max' 4 and 'max_minority_bound' 2 with most probable adduct being H+ and least probable adduct being Na+, this will allow adduct compositions of '2(H+),2(Na+)' but not of '1(H+),3(Na+)'. Further, adduct compositions/changes less likely than '2(H+),2(Na+)' will be discarded as well. (default: '3' min: '0')
  algorithm:MetaboliteFeatureDeconvolution:min_rt_overlap: #how to set a min 0.0 and max 1.0 ???
    type: float
    inputBinding:
      prefix: -algorithm:MetaboliteFeatureDeconvolution:min_rt_overlap
    default: 0.66
    doc:   Minimum overlap of the convex hull RT intersection measured against the union from two features (if CHs are given).
  algorithm:MetaboliteFeatureDeconvolution:intensity_filter: # has to be a flag!!!! check! 
    type:
     type: boolean?
    inputBinding:
      prefix: -algorithm:MetaboliteFeatureDeconvolution:intensity_filter
    default: false
    doc: Enable the intensity filter, which will only allow edges between two equally charged features if the intensity of the feature with less likely adducts is smaller than that of the other feature. It is not used for features of different charge.  
 algorithm:MetaboliteFeatureDeconvolution:negative_mode:
    type:
     type: boolean?
    inputBinding:
      prefix: -algorithm:MetaboliteFeatureDeconvolution:negative_mode
    default: false
    doc: Enable negative ionization mode.
  algorithm:MetaboliteFeatureDeconvolution:default_map_label: 
    type: string
    inputBinding:
      prefix: -algorithm:MetaboliteFeatureDeconvolution:default_map_label
    default: 'decharged features'
    doc: Label of map in output consensus file where all features are put by default
    
  algorithm:MetaboliteFeatureDeconvolution:verbose_level: #can probably be removed, unless we want to have the possiblity for a logging process?  
    type: int
    inputBinding:
      prefix: -algorithm:MetaboliteFeatureDeconvolution:verbose_level
    default: 0
    doc: Amount of debug information given during processing.
 
outputs: # only allow featureXML output
  out_ams:
    type: File?
    outputBinding:
      glob: output_ams.featureXML
