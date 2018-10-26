#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand: /THIRDPARTY/Linux/64bit/Sirius/sirius

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
      prefix: ~/sirius_workspace_directory
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
   default: 10
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
  iontree:
    type: boolean?
    inputBinding:
      prefix: -iontree
    default: false
    doc: Print molecular formulas and node labels with the ion formula instead of the neutral formula
  no_recalibration:
    type: boolean?
    inputBinding:
      prefix: --no_recalibration
    default: false
    doc: No recalibration of the spectrum during the analysis

outputs:
  sirius_output:
    type: Directory
    outputBinding:
      glob: sirius_workspace_directory
