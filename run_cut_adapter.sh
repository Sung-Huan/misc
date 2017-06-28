for FILE in $(ls READemption_analysis/input/reads)
  do
    /storage2/Sequencing_data/2014/2014-02-25-MiSeq-ID-002066/bin/cutadapt-1.3/bin/cutadapt \
    -g GATCGGAAGAGCACACGTCTGAACTCCAGTCAC \
    -m 1 \
    -o READemption_analysis/input/reads/$FILE"_trim" \
    READemption_analysis/input/reads/$FILE
  done

