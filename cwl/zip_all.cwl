#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
#baseCommand: /scripts/openms/compress_sirius_output_simple.sh
baseCommand: /Users/alka/Documents/work/projects/Cloud/scripts/openms/compress_sirius_output_simple.sh
inputs:
  name_of_output:
    type: File
    inputBinding:
      position: 1
  input_files:
    type: File

outputs:
  output:
    type: File
    outputBinding:
      glob: $(output_file).zip
