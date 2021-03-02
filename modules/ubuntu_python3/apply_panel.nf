#!/usr/bin/env nextflow

nextflow.enable.dsl   = 2

process APPLY_PANEL {

    tag "${sample_id}_${panel}"
    publishDir "${params.run_dir}/${sample_id}/${panel}", mode: 'copy'
    label 'ubuntu_python3'
    label 'small_process'
    
    input:
    tuple val(sample_id), val(panel)
    path panel_dir
    path sample_path

    output:
    tuple sample_id, panel, file("${sample_id}_${panel}_OPL.vcf"), emit: panel

    script:
    """
    applyPanel.sh ${sample_id} ${panel} ${panel_dir} ${sample_path}
    """
}