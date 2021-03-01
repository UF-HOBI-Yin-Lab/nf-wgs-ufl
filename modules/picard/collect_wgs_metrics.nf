#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process PICARD_COLLECT_WGS_METRICS {

    tag "${sample_id}"
    publishDir "${params.outdir}/${params.run_id}/${sample_id}/wgs_metrics", mode: 'copy'
    label 'picard'
    label 'high_mem'

    input:
    path reference
    path ref_fai
    tuple val(sample_id), file("${sample_id}-sort.bam")
    tuple val(sample_id), file("${sample_id}-sort.bam.bai")

    output:
    file "${sample_id}_gatk_collect_wgs_metrics.txt"

    script:
    """
    java -jar -XX:ParallelGCThreads=${task.cpus} -Xmx32g /picard.jar CollectWgsMetrics \
    -I ${sample_id}-sort.bam \
    -O ${sample_id}_gatk_collect_wgs_metrics.txt \
    -R ${reference}
    """
}