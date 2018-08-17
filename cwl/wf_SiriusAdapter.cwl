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
  parts:
    type: int
    default: 1

outputs:
  sirius_mzTab:
    type: File
    outputSource: merge_sirius/merge_mzTab_file

steps:
  split:
    run: MzMLSplitter.cwl
    in:
      in: in
      parts: parts
    out: [split_mzML_files]
  
  siriusAdapter:
    run: SiriusAdapter.cwl
    in:
      executable:
        default: "/THIRDPARTY/Linux/64bit/Sirius/sirius"
      in: split/split_mzML_files
      candidates: candidates
      ppm_max: ppm_max
      auto_charge: auto_charge
      no_recalibration: no_recalibration
      fingerid1: fingerid
      fingerid2: fingerid
    scatter: in
    out: [out_sirius, out_fingerid]
  merge_sirius:
    run: merge_mzTab_simple.cwl
    in:
      in: siriusAdapter/out_sirius
      prefix:
        default: SML
      outname:
        default: sirius
    out: [merge_mzTab_file]