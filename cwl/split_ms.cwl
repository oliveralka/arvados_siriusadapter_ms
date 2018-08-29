#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
#baseCommand: /scripts/openms/split_ms_simple.sh
baseCommand: /Users/alka/Documents/work/projects/Cloud/scripts/openms/split_ms_simple.sh

inputs:
  input_file:
    type: File
    inputBinding:
      position: 1
  count:
    type: int
    inputBinding:
      position: 2
outputs:
  split_ms_files:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*.ms"
