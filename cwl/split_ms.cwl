#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand: /scripts/split_ms_simple.sh
inputs:
  in:
    type: File[]
    inputBinding:
      position: 1
  compound_count:
    type: int
    inputBinding:
      position: 2  
    
outputs:
  split_ms_simple:
    type: File
    outputBinding:
      glob: $(inputs.outname).ms