#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

$namespaces:
  arv: "http://arvados.org/cwl#"
  cwltool: "http://commonwl.org/cwltool#"

requirements:
- class: DockerRequirement
  dockerPull: arvados/jobs-with-openms

baseCommand: [/OpenMS-build/bin/MzMLSplitter, -out, "./out"]
inputs:
  in:
    type: File
    inputBinding:
      prefix: -in
  parts:
    type: int
    inputBinding:
      prefix: -parts
  split:
    type: string
    default: atMS1
    inputBinding:
      prefix: -split
  no_chrom:
    type: boolean
    default: true
    doc: Remove chromatograms from split files

outputs:
  split_mzML_files:
    type:
       type: array
       items: File
    outputBinding:
      glob: "out_*of*.mzML"
