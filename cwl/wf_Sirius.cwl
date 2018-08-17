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
  in: File
  candidates:
    type: int
    default: 5
    doc: "The number of candidates in the output" 
  ppm_max:
    type: int
    default: 5
  auto_charge:
    type: boolean?
    default: false
    doc: Use this option if the charge of your compounds is unknown and you do not want to assume [M+H]+ as default.
#  iontree:
#    type: boolean?
#    default: false
#    doc: Print molecular formulas and node labels with the ion formula instead of the neutral formula
  no_recalibration:
    type: boolean?
    default: false
    doc: No recalibration of the spectrum during the analysis
  fingerid:
    type: boolean?
    default: false
    doc: Fingerid
  profile:
    type:
      name: profile
      type: enum
      symbols:  [qtof, orbitrap, fticr]
    default: qtof
    doc: Specify the used analysis profile
  compound_timeout:
    type: int
    inputBinding:
      prefix: --compound_timeout
    doc: Time out in seconds per compound. To disable the timeout set the value to 0.
    default: 10 
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