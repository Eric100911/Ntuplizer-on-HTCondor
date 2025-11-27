.PHONY: submit dryrun x509up


submit: cmssw_configs.tar wrapper.sh
	mkdir -p logs && condor_submit LHE-to-SKIM.sub
	cp LHE_sources.txt logs/

preplocal: cmssw_configs.tar wrapper.sh
	rm -rf local/
	mkdir -p local/
	cp cmssw_configs.tar local/
	cp wrapper.sh local/
	@echo "Prepared local/ directory with CMSSW configs and wrapper.sh"

cmssw_configs.tar: CMSSW_13_0_20/src/HeavyFlavourAnalysis/TPS-Onia2MuMu/test/runMultiLepPAT_mcRun3_miniAOD_Run2022.py
	tar -cvf cmssw_configs.tar CMSSW_13_0_20/

