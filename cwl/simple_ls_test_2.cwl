#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand: ls

arguments:
  - "-l"

inputs:
  message:
    type: string
    inputBinding:
      position: 1

outputs: []
