#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process CALL_CNV {

    tag "${sample_id}"
    publishDir "${params.outdir}/${params.run_id}/${sample_id}/variants", mode: 'copy'
    label 'panelcn.mops'
    label 'medium_process'

    input:
    path control
    path header
    tuple val(sample_id), file("${sample_id}-sort.bam")
    tuple val(sample_id), file("${sample_id}-sort.bam.bai")

    output:
    tuple val(sample_id), file("${sample_id}_filtered_cnv.vcf"), emit: cnv
    file("${sample_id}_cnv.pdf")

    script:
    """
    callCNV.R ${sample_id} ${control}
    csvToVCF.sh ${sample_id} ${header}
    toGRanges.sh ${sample_id}
    CNVPlot.R ${sample_id}
    """
}
