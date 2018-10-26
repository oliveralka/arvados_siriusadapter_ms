#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand: /scripts/openms/compress_sirius_output_simple.sh

inputs:
  name_of_output:
    type: string
    inputBinding:
      position: 1
    default: archive.zip
  files_to_zip:
    type: Directory[]
    inputBinding:
      position: 2

outputs:
  output_zip:
    type: File
    outputBinding:
      glob: "*.zip"
