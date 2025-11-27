#!/bin/bash

# Arguments: <input_MINIAOD_path> <output_NTUPLE_path> <x509 certificate>
INPUT_MINIAOD="$1"
OUTPUT_NTUPLE="$2"
X509_CERT="$3"
HOME_DIR=$(pwd)

# Log prefix for output files: extract from the input LHE file name.
LOG_PREFIX=$(basename "$INPUT_MINIAOD" .root)

# 1. Configure the x509 certificate
export X509_USER_PROXY="$X509_CERT"

# 2. Set SCRAM architecture for CMSSW_12_X_X and CMSSW_13_X_X
export SCRAM_ARCH=el8_amd64_gcc12

# 3. Set up CMSSW environment.
tar -xvf cmssw_configs.tar
cd CMSSW_13_0_20/src
eval `scram runtime -sh`

# 4. Configure input and output files in the ntuplizer config file.
grep INPUTFILE HeavyFlavourAnalysis/TPS-Onia2MuMu/test/runMultiLepPAT_mcRun3_miniAOD_Run2022.py
grep OUTPUTFILE HeavyFlavourAnalysis/TPS-Onia2MuMu/test/runMultiLepPAT_mcRun3_miniAOD_Run2022.py
sed -r -e 's|OUTPUTFILE|'"$OUTPUT_NTUPLE"'|g' \
       -e 's|INPUTFILE|'"$INPUT_MINIAOD"'|g' \
       HeavyFlavourAnalysis/TPS-Onia2MuMu/test/runMultiLepPAT_mcRun3_miniAOD_Run2022.py > runMultiLepPAT_mcRun3_miniAOD_Run2022.py

# For debug, terminate here.
grep inputFiles runMultiLepPAT_mcRun3_miniAOD_Run2022.py
grep outputFile runMultiLepPAT_mcRun3_miniAOD_Run2022.py
# exit 0

# 5. Run ntuplizer steps.
scram b projectrename -j 16
cmsRun runMultiLepPAT_mcRun3_miniAOD_Run2022.py