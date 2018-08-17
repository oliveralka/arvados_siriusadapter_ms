#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
requirements:
  - class: ShellCommandRequirement
baseCommand: tar czf
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
  tar_out:
    type: File
    outputBinding:
      glob: $(inputs.outname).tar.gz