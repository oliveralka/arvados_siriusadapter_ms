# arvados_siriusadapter_ms

Workflows for Arvados SIRIUS and SiriusAdapter Microservice. 

To test the workflows please update the absolute path in the yml files. 

The cwl reference implementation (cwltool) has to be installed. 

Start the test via

cwltool ./test.cwl /test.yml

If workflows (wf_Sirius,wf_SiriusAdapter) can be parallelized you can use 

cwltool --parallel ./test.cwl /test.yml 

 
