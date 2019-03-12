#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
#baseCommand: /THIRDPARTY/Linux/64bit/Sirius/sirius
baseCommand:  /Users/alka/Desktop/sirius_4.04_test/sirius-osx64-headless-4.0.4-SNAPSHOT/bin/sirius

requirements:
- class:  ResourceRequirement
  ramMin: 1000
  coresMin: 1
  coresMax: 1

inputs:
  in_ms:
    type: File
    inputBinding:
      position: 100
  fingerid:
    type: boolean
    inputBinding:
      prefix: --fingerid
    default: false
  out_dir1:
    type: boolean
    inputBinding:
      position: 3
      prefix: --output
  out_dir2:
    type: boolean
    inputBinding:
      position: 4
      prefix: ~/sirius_out
  workspace1:
    type: boolean
    inputBinding:
      position: 5
      prefix: --workspace
  workspace2:
    type: boolean
    inputBinding:
      position: 6
      prefix: ~/sirius_workspace.sirius
  profile:
    type:
      name: profile
      type: enum
      symbols:  [qtof, orbitrap, fticr]
      inputBinding:
        prefix: --profile
    default: qtof
    doc: Specify the used analysis profile
  candidates:
    type: int
    inputBinding:
      prefix: --candidates
    default: 5
    doc: The number of candidates in the output
  database:
    type:
      name: database
      type: enum
      symbols: [all, chebi, custom, kegg, bio, natural products, pubmed, hmdb, biocyc, hsdb, knapsack, biological, zinc bio, gnps, pubchem, mesh, maconda]
      inputBinding:
        prefix: --database
    default: all
    doc: Search formulas in given database
  ppm_max:
    type: int
    inputBinding:
      prefix: --ppm-max
    default: 10
    doc: Allowed ppm for decomposing masses
  ppm_max_ms2:
    type: int?
    inputBinding:
      prefix: --ppm-max-ms2
    doc: Allowed ppm for decomposing masses
  isotope:
    type:
      name: isotope
      type: enum
      symbols: [score, filter, both, omit]
      inputBinding:
        prefix: --isotope
    default: both
    doc: How to handle isotope pattern data
  elements:
    type: string
    inputBinding:
      prefix: --elements
    default: CHNOP[5]S[8]Cl[1]
    doc: The allowed elements
  compound_timeout:
   type: int
   inputBinding:
     prefix: --compound-timeout
   doc: Time out in seconds per compound. To disable the timeout set the value to 0.
   default: 100
  tree_timeout:
    type: int?
    inputBinding:
      prefix: --tree-timeout
    doc: Time out in seconds per fragmentation tree computation.
  auto_charge:
    type: boolean?
    inputBinding:
      prefix: --auto-charge
    default: false
    doc: Use this option if the charge of your compounds is unknown and you do not want to assume [M+H]+ as default.
  no_recalibration:
    type: boolean?
    inputBinding:
      prefix: --no_recalibration
    default: false
    doc: No recalibration of the spectrum during the analysis
  maxmz:
    type: int?
    inputBinding:
      prefix: --maxmz
    doc: Consider compounds with a precursor mz lower or equal to this maximum mz.
  noise:
    type: int?
    inputBinding:
      prefix: --noise
    doc: Median intensity of noise peaks.
  processors:
    type: int
    inputBinding:
      prefix: --processors
    default: 1
    doc: Median intensity of noise peaks.

outputs:
  sirius_output:
    type: File
    outputBinding:
      glob: sirius_out/analysis_report.mztab
      
  sirius_workspace:
    type: File
    outputBinding:
      glob: sirius_workspace.sirius
