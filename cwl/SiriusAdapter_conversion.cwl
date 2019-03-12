#!/usr/bin/env cwl-runner
# Here, used for the conversion of mzML & featureXML to .ms files
cwlVersion: v1.0
class: CommandLineTool
baseCommand: [SiriusAdapter, -out_ms, ./out_ms.ms]

requirements:
- class: ScatterFeatureRequirement
- class:  ResourceRequirement
  ramMin: 1000
  coresMin: 1
  coresMax: 1

inputs:
  executable:
    type: string
    inputBinding:
      prefix: -executable 
  in_mzml:
    type: File?
    inputBinding:
      prefix: -in
  in_featureinfo:
    type: File?
    inputBinding:
      prefix: -in_featureinfo
  filter_by_num_masstraces:
    type: int
    inputBinding:
      prefix: -preprocessing:filter_by_num_masstraces
    default: 1
    doc: Features have to have at least x MassTraces. To use this parameter feature_only is necessary.
  feature_only:
    type: boolean
    inputBinding:
      prefix: -preprocessing:feature_only
    default: false
    doc: Uses the feature information from in_featureinfo to reduce the search space to only MS2 associated with a feature.
  converter_mode:
    type: boolean
    inputBinding:
      prefix: -converter_mode
    default: true 
    doc: Use this flag in combination with the out_ms file to only convert the input mzML and featureXML to an .ms file. Without further SIRIUS processing.
  precursor_mz_tolerance:
    type: float
    inputBinding:
      prefix: -preprocessing:precursor_mz_tolerance
    default: 0.005
    doc: Tolerance window for precursor selection (Feature selection in regard to the precursor).
  precursor_mz_tolerance_unit:
    type: string
    inputBinding:
      prefix: -preprocessing:precursor_mz_tolerance_unit
    default: "Da"
    doc: Unit of the precursor_mz_tolerance (Da, ppm).
  precursor_rt_tolerance:
    type: int
    inputBinding:
      prefix: -preprocessing:precursor_rt_tolerance
    default: 5
    doc: Tolerance window (left and right) for precursor selection [seconds].
  isotope_pattern_iterations:
    type: int
    inputBinding:
      prefix: -preprocessing:isotope_pattern_iterations
    default: 3
    doc: Number of iterations that should be performed to extract the C13 isotope pattern.
  no_masstrace_info_isotope_pattern:
    type: boolean
    inputBinding:
      prefix: -preprocessing:no_masstrace_info_isotope_pattern
    default: false
    doc: Use this flag if the masstrace information from a feature should be discarded and the isotope_pattern_iterations should be used instead.
  debug:
    type: int
    inputBinding:
      prefix: -debug
    default: 0
    
outputs:
  out_ms:
    type: File?
    outputBinding:
      glob: out_ms.ms
