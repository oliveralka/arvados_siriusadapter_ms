#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
#baseCommand: /scripts/merge_mzTab_simple.py
baseCommand: /Users/alka/Documents/work/projects/Cloud/scripts/openms/merge_mzTab_simple.py
inputs:
  in:
    type: File[]
    inputBinding:
      prefix: -i
  prefix:
    type: string
    inputBinding:
      prefix: --prefix

  outname:
    type: string

arguments:
- valueFrom: $(inputs.outname).mzTab
  prefix: -o

outputs:
  merge_mzTab_file:
    type: File
    outputBinding:
      glob: $(inputs.outname).mzTab
