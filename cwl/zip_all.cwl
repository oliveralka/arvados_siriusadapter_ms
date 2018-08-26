#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
#baseCommand: /scripts/openms/compress_sirius_output_simple.sh
baseCommand: /Users/alka/Documents/work/projects/Cloud/scripts/openms/compress_sirius_output_simple.sh

inputs:
  name_of_output:
    type: string
    inputBinding:
      position: 1
  files_to_zip:
    type: string
    inputBinding:
      position: 2

outputs:
  output_zip:
    type: File
    outputBinding:
      glob: "*.zip"
