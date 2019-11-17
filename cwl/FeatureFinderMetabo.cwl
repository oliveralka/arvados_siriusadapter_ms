#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand: [FeatureFinderMetabo]

requirements:
- class: ScatterFeatureRequirement
- class:  ResourceRequirement
  ramMin: 1000
  coresMin: 1
  coresMax: 1
  
inputs:
  in_mzml:
    type: File?
    inputBinding:
      prefix: -in
  algorithm:common:noise_threshold_int:
    type: float
    inputBinding:
      prefix: -algorithm:common:noise_threshold_int
    default: 10.0
    doc: Intensity threshold below which peaks are regarded as noise.    
  algorithm:common:chrom_peak_snr:
    type: float
    inputBinding:
      prefix: -algorithm:common:chrom_peak_snr
    default: 3.0
    doc: Minimum signal-to-noise a masstrace should have.    
  algorithm:common:chrom_fwhm:
    type: float
    inputBinding:
      prefix: -algorithm:common:chrom_fwhm
    default: 5.0
    doc: Expected chromatographic peak width (in seconds).
  algorithm:mtd:mass_error_ppm:
    type: float
    inputBinding:
      prefix: -algorithm:mtd:mass_error_ppm
    default: 20.0
    doc: Allowed mass deviation (in ppm).  
  algorithm:mtd:reestimate_mt_sd:
    type: boolean?
    inputBinding:
      prefix: -algorithm:mtd:reestimate_mt_sd
    default: 'true'
    doc: Enables dynamic re-estimation of m/z variance during mass trace collection stage.   
  algorithm:mtd:quant_method:
    type:
      name: quant_method
      type: enum
      symbols: [area, median]
    inputBinding:
      prefix: -algorithm:mtd:quant_method
    default: area
    doc:Method of quantification for mass traces. For LC data 'area' is recommended, 'median' for direct injection data.
 algorithm:mtd:trace_termination_criterion:
    type:
      name: trace_termination_criterion
      type: enum
      symbols: [outlier, sample_rate]
    inputBinding:
      prefix: -algorithm:mtd:trace_termination_criterion
    default: outlier
    doc:Termination criterion for the extension of mass traces. In 'outlier' mode, trace extension cancels if a predefined number of consecutive outliers are found (see trace_termination_outliers parameter). In 'sample_rate' mode, trace extension in both directions stops if ratio of found peaks versus visited spectra falls below the 'min_sample_rate' threshold.
  algorithm:mtd:trace_termination_outliers:
    type: int
    inputBinding:
      prefix: -algorithm:mtd:trace_termination_outliers
    default: 5
    doc: Mass trace extension in one direction cancels if this number of consecutive spectra with no detectable peaks is reached. 
  algorithm:mtd:min_sample_rate:
    type: float
    inputBinding:
      prefix: -algorithm:mtd:min_sample_rate 
    default: 0.5
    doc: Minimum fraction of scans along the mass trace that must contain a peak.    
 algorithm:mtd:min_trace_length:
    type: float
    inputBinding:
      prefix: -algorithm:mtd:min_trace_length
    default: 5.0
    doc:  Minimum expected length of a mass trace (in seconds).   
 algorithm:mtd:max_trace_length:
    type: float
    inputBinding:
      prefix: -algorithm:mtd:max_trace_length
    default: -1.0
    doc:  Maximum expected length of a masstrace (in seconds). Set to a negative value to disable maximal length check during mass trace detection.
  algorithm:epd:enabled:
    type: boolean?
    inputBinding:
      prefix: -algorithm:epd:enabled
    default: 'true'
    doc: Enable splitting of isobaric masstraces by chromatographic peak detection. Disable for direct injection.
  algorithm:epd:width_filtering:
    type:
      name: algorithm:epd:width_filtering
      type: enum
      symbols: [off, fixed, auto]
    inputBinding:
      prefix: -algorithm:epd:width_filtering
    default: fixed
    doc: Enable filtering of unlikely peak widths. The fixed setting filters out mass traces outside the [min_fwhm, max_fwhm] interval (set parameters accordingly!). The auto setting filters with the 5 and 95% quantiles of the peak width distribution.   
  algorithm:epd:min_fwhm:
    type: float
    inputBinding:
      prefix: -algorithm:epd:min_fwhm
    default: 3.0
    doc:   Minimum full-width-at-half-maximum of chromatographic peaks (in seconds). Ignored if parameter width_filtering is off or auto.     
  algorithm:epd:max_fwhm:
    type: float
    inputBinding:
      prefix: -algorithm:mtd:max_trace_length
    default: 60.0
    doc:  Maximum full-width-at-half-maximum of chromatographic peaks (in seconds). Ignored if parameter width_filtering is off or auto.    
  algorithm:epd:masstrace_snr_filtering:
    type:
     type: boolean?
    inputBinding:
      prefix: -algorithm:epd:masstrace_snr_filtering
    default: false
    doc: Apply post-filtering by signal-to-noise ratio after smoothing.   
  algorithm:ffm:local_rt_range:
    type: float
    inputBinding:
      prefix: -algorithm:ffm:local_rt_range
    default: 10.0
    doc:  RT range where to look for coeluting mass traces.
  algorithm:ffm:local_mz_range:
    type: float
    inputBinding:
      prefix: -algorithm:ffm:local_mz_range
    default: 6.5
    doc:  MZ range where to look for isotopic mass traces.  
  algorithm:ffm:charge_lower_bound:
    type: int
    inputBinding:
      prefix: -algorithm:ffm:charge_lower_bound
    default: 1
    doc: Lowest charge state to consider.     
  algorithm:ffm:charge_upper_bound:
    type: int
    inputBinding:
      prefix: -algorithm:ffm:charge_upper_bound
    default: 3
    doc: Highest charge state to consider. 
  algorithm:ffm:report_summed_ints:
    type:
     type: boolean?
    inputBinding:
      prefix: -algorithm:ffm:report_summed_ints
    default: false
    doc: Set to true for a feature intensity summed up over all traces rather than using monoisotopic trace intensity alone.  
  algorithm:ffm:enable_RT_filtering:
    type:
     type: boolean?
    inputBinding:
      prefix: -lgorithm:ffm:enable_RT_filtering
    default: false
    doc: Require sufficient overlap in RT while assembling mass traces. Disable for direct injection data.
  algorithm:ffm:isotope_filtering_model:
    type:
      name: algorithm:ffm:isotope_filtering_model
      type: enum
      symbols: [metabolites (2% RMS), metabolites (5% RMS), peptides, none]
    inputBinding:
      prefix: -algorithm:ffm:isotope_filtering_model
    default: metabolites (5% RMS)
    doc: Remove/score candidate assemblies based on isotope intensities. SVM isotope models for metabolites were trained with either 2% or 5% RMS error. For peptides, an averagine cosine scoring is used. Select the appropriate noise model according to the quality of measurement or MS device.   
  algorithm:ffm:mz_scoring_13C:
    type:
     type: boolean?
    inputBinding:
      prefix: -algorithm:ffm:mz_scoring_13C
    default: false
    doc: Use the 13C isotope peak position (~1.003355 Da) as the expected shift in m/z for isotope mass traces (highly recommended for lipidomics!). Disable for general metabolites (as described in Kenar et al. 2014, MCP.).
  algorithm:ffm:use_smoothed_intensities:
    type:
     type: boolean?
    inputBinding:
      prefix: -algorithm:ffm:use_smoothed_intensities
    default: true
    doc: Use LOWESS intensities instead of raw intensities.    
  algorithm:ffm:report_convex_hulls:
    type:
     type: boolean?
    inputBinding:
      prefix: -algorithm:ffm:report_convex_hulls
    default: false
    doc:  Augment each reported feature with the convex hull of the underlying mass traces (increases featureXML file size considerably).
    
  algorithm:ffm:remove_single_traces:
    type:
     type: boolean?
    inputBinding:
      prefix: -algorithm:ffm:remove_single_traces
    default: false
    doc: Remove unassembled traces (single traces). 
  
outputs:
  out:
    type: File?
    outputBinding:
      glob: output_ffm.featureXML
