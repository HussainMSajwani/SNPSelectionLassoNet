SHELL:=/bin/bash
#CEU hapmap3: https://mathgen.stats.ox.ac.uk/impute/data_download_1000G_pilot_plus_hapmap3.html
ref_panel_dir=/home/shussain/hapgen2/CEU_impute/
#ref_panel_dir=/l/proj/kuin0009/hussain/simulation/reference_panels/CEU_impute/
n_pheno=1
genVar=0.95
name=`date +'%d%m%Y'`
dir=$(name)/chr_$(chr)/d_$(d)/genVar_$(genVar)/h2s_$(h2s)/sim_$(i)
hapgen2_dir=/home/shussain/hapgen2

threshold: $(dir)/PS/output/Ysim_output.csv
	mkdir -p $(outdir)/$(dir)
	which python
	python train.py $(genVar) $(i) p $(h2s) $(d) $(dir) $(outdir)/$(dir)
	python train.py $(genVar) $(i) ln $(h2s) $(d) $(dir) $(outdir)/$(dir)


threshold_ln:
	mkdir -p $(outdir)/$(dir)
	which python
	python train.py $(genVar) $(i) ln $(h2s) $(d) $(dir) $(outdir)/$(dir)


threshold_p: $(dir)/PS/output/Ysim_output.csv
	mkdir -p $(outdir)/$(dir)
	which python
	python train.py $(genVar) $(i) p $(h2s) $(d) $(dir) $(outdir)/$(dir)

sim: $(dir)/PS/output/Ysim_output.csv
#generate genotype in oxford format. chromosome $chr
$(dir)/prelim/prelim_$(chr):
	d_max=`wc -l < $(ref_panel_dir)data/chr$(chr).legend`; \
	if [ "$$d_max" -lt "$d" ]; then echo "Not enough SNPs in reference panel"; exit 64; fi; \
	rand=`bash get_random.sh $$d_max $$d $$chr $(ref_panel_dir)`; \
	echo $$d_max; \
	first=`cat $(ref_panel_dir)/data/chr$(chr).legend | head -n $$(($$rand+1)) | tail -1 | cut -d' ' -f2`; \
	first_id=`cat $(ref_panel_dir)/data/chr$(chr).legend | head -n $$(($$rand+1)) | tail -1 | cut -d' ' -f1`; \
	dth=`cat $(ref_panel_dir)/data/chr$(chr).legend | head -n $$(($$d+$$rand)) | tail -1 | cut -d' ' -f2`; \
	echo $$dth; \
	$(hapgen2_dir)/hapgen2 -m $(ref_panel_dir)genetic_maps/genetic_map_chr$(chr)_combined_b*.txt\
					  -l $(ref_panel_dir)data/chr$(chr).legend\
					  -h $(ref_panel_dir)data/chr$(chr).haps\
					  -o $(dir)/prelim/prelim_$(chr) \
					  -n $(n) 0 \
					  -int $$first $$dth \
					  -dl $$first 0 0 0 \
					  -no_haps_output

	

#transform from oxford format into plink format
$(dir)/prelim/prelim_plink_chr$(chr): $(dir)/prelim/prelim_$(chr)
	~/plink/plink-1.9/plink --data $(dir)/prelim/prelim_$(chr).controls \
							--oxford-single-chr $(chr) \
							--make-bed \
							--out $(dir)/prelim/prelim_plink_chr$(chr)
	touch $@


$(dir)/PS/output/Ysim_output.csv: $(dir)/prelim/prelim_$(chr)
	mkdir -p $(dir)/PS
	
	Rscript commandlineFunctions.R \
			--NrSamples=$(n) --NrPhenotypes=$(n_pheno) \
			--tNrSNP=$(d) --format="oxgen"\
			--genotypefile=$(dir)/prelim/prelim_$(chr).controls \
			--cNrSNP=$(dc) \
			--genVar=$(genVar) --h2s=$(h2s) --phi=1 \
			--directory=$(dir)/PS \
			--subdirectory=output \
			--showProgress \
			--saveTable \
			--savePLINK \

	rm -rf temp
	mkdir -p ~/Simulated_data/$(dir)
	cp -r $(dir)/* ~/Simulated_data/$(dir)
	echo !!

	touch $@
	
clean:
	rm -rf prelim
	rm -rf temp
	rm -rf final
	rm -rf PS