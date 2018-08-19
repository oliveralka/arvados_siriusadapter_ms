cwlVersion: v1.0
class: Workflow

requirements:
- class: ScatterFeatureRequirement
- class: DockerRequirement
  dockerPull: arvados/jobs-with-openms
- class:  ResourceRequirement
  ramMin: 1000
  coresMin: 1
  coresMax: 1

inputs:
  in_ms:
    type: File
    inputBinding:
      position: 6 
  fingerid:
    type: boolean
    inputBinding:
      prefix: --fingerid
    default: false
  out_dir:
    type: Directory
    inputBinding:
      prefix: --output  
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
      prefix: --ppm_max
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
     prefix: --compound_timeout
   doc: Time out in seconds per compound. To disable the timeout set the value to 0.
   default: 10
  tree_timeout:
    type: int
    inputBinding:
      prefix: --tree_timeout
    doc: Time out in seconds per fragmentation tree computation.
  auto_charge:
    type: boolean?
    inputBinding:
      prefix: --auto_charge
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
   parts:
    type: int
    default: 1

outputs:
  zip_all:
    type: File
    outputSource: zip_sirius/zip_all

steps:
  split:
    run: split_ms.cwl
    in:
      in: in
      parts: parts
    out: [split_ms_files]
  
  SIRIUS:
    run: Sirius.cwl
    in:
      in_ms: split/split_ms_files
      candidates: candidates
      ppm_max: ppm_max
      auto_charge: auto_charge
      no_recalibration: no_recalibration
      fingerid: fingerid
      compound_timeout: compound_timeout
    scatter: in
    out: [out_dir] # not sure hot to do this ? zip the zips 
  zip_sirius:
    run: zip_all.cwl
    in:
      in: SIRIUS/out_dir
      prefix:
        default: SML
      outname:
        default: sirius
    out: [zip_all]