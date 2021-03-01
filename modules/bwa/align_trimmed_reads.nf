#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process ALIGN_TRIMMED_READS {
    
    tag "${sample_id}"
    label 'bwa'
    label 'alignment'

    input:
    path reference
    path bwa_amb
    path bwa_ann
    path bwa_bwt
    path bwa_pac
    path bwa_sa
    tuple val(sample_id), file("${sample_id}_forward-paired.fastq.gz"), file("${sample_id}_reverse-paired.fastq.gz")

    output:
    tuple val(sample_id), file("${sample_id}.sam"), emit: sam

    script:
    """
    bwa mem -t ${task.cpus} \
    ${reference} \
    ${sample_id}_forward-paired.fastq.gz \
    ${sample_id}_reverse-paired.fastq.gz > \
    ${sample_id}.sam
    """
}