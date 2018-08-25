#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/OpenMS-build/bin/SiriusAdapter, -out_sirius, ./out_sirius.mzTab]

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: arvados/jobs-with-openms:latest

inputs:
  executable:
    type: string
    inputBinding:
      prefix: -executable
  in:
    type: File?
    inputBinding:
      prefix: -in
  in_ms:
    type: File?
    inputBinding:
      prefix: -in_ms
  in_featureinfo:
    type: File?
    inputBinding:
      prefix: -in_featureinfo
  fingerid1:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -out_fingerid
    default: false
  fingerid2:
    type: boolean?
    inputBinding:
      position: 6
      prefix: ./out_fingerid.mzTab
    default: false
  out_ms1:
    type: boolean?
    inputBinding:
      position: 7
      prefix: -out_ms
  out_ms2:
    type: boolean?
    inputBinding:
      position 8:
      prefix: ./out_ms.ms
  filter_by_num_masstraces:
    type: int
    inputBinding:
      prefix: -filter_by_num_masstraces
    default: 1
    doc: Features have to have at least x MassTraces. To use this parameter feature_only is necessary.
  feature_only:
    type: boolean
    inputBinding:
      prefix: -feature_only
    default: false
    doc: Uses the feature information from in_featureinfo to reduce the search space to only MS2 associated with a feature.
  precursor_mz_tolerance:
    type: float
    inputBinding:
      prefix: -precursor_mz_tolerance
  doc: Tolerance window for precursor selection (Feature selection in regard to the precursor).
  precursor_mz_tolerance_unit:
    type: String
    inputBinding:
      prefix: -precursor_mz_tolerance_unit
  doc: Unit of the precursor_mz_tolerance (Da, ppm).
  precursor_rt_tolerance:
   type: int
   inputBinding:
     prefix: -precursor_rt_tolerance
  doc: Tolerance window (left and right) for precursor selection [seconds].
  debug:
    type: int
    inputBinding:
      prefix: -debug
    default: 0
  profile:
    type:
      name: profile
      type: enum
      symbols:  [qtof, orbitrap, fticr]
      inputBinding:
        prefix: -profile
    default: qtof
    doc: Specify the used analysis profile
  candidates:
    type: int
    inputBinding:
      prefix: -candidates
    default: 5
    doc: The number of candidates in the output
  database:
    type:
      name: database
      type: enum
      symbols: [all, chebi, custom, kegg, bio, natural products, pubmed, hmdb, biocyc, hsdb, knapsack, biological, zinc bio, gnps, pubchem, mesh, maconda]
      inputBinding:
        prefix: -database
    default: all
    doc: Search formulas in given database
  ppm_max:
    type: int
    inputBinding:
      prefix: -ppm_max
    default: 10
    doc: Allowed ppm for decomposing masses
  isotope:
    type:
      name: isotope
      type: enum
      symbols: [score, filter, both, omit]
      inputBinding:
        prefix: -isotope
    default: both
    doc: How to handle isotope pattern data
  elements:
    type: string
    inputBinding:
      prefix: -elements
    default: CHNOP[5]S[8]Cl[1]
    doc: The allowed elements
  compount_timeout:
   type: int
   inputBinding:
     prefix: -compound_timeout
   doc: Time out in seconds per compound. To disable the timeout set the value to 0.
   default: 10
  tree_timeout:
    type: int
    inputBinding:
      prefix: -tree_timeout
    doc: Time out in seconds per fragmentation tree computation.
    default: 0
  top_n_hits:
    type: int
    inputBinding:
      prefix: -top_n_hits
    default: 10
    doc: The number of compounds used in the output
  auto_charge:
    type: boolean?
    inputBinding:
      prefix: -auto_charge
    default: false
    doc: Use this option if the charge of your compounds is unknown and you do not want to assume [M+H]+ as default.
  iontree:
    type: boolean?
    inputBinding:
      prefix: -iontree
    default: false
    doc: Print molecular formulas and node labels with the ion formula instead of the neutral formula
  no_recalibration:
    type: boolean?
    inputBinding:
      prefix: -no_recalibration
    default: false
    doc: No recalibration of the spectrum during the analysis

outputs:
  out_sirius:
    type: File?
     outputBinding:
      glob: out_sirius.mzTab

  out_ms:
    type: File?
      outputBindung:
        glob: out_ms.ms

  out_fingerid:
    type: File?
    outputBinding:
      glob: out_fingerid.mzTab
