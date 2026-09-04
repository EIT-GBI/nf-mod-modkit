// this module does the modkit pileup of all reads
// it takes a BAM with MM/ML tags and outputs a bedMethyl file
// https://genome-euro.ucsc.edu/goldenPath/help/bedMethyl.html
// https://nanoporetech.github.io/modkit/intro_pileup_hemi.html


process MODKIT_PILEUP {
    tag "${meta.id}"

    publishDir "${params.outdir}/methylation", mode: 'copy'

    input:
    tuple val(meta), path(bam), path(bai)
    tuple path(fasta), path(fai)

    output:
    tuple val(meta), path("${meta.id}.bedmethyl.bed.gz"), emit: bedmethyl
    path "${meta.id}.modkit_pileup.log",                  emit: log

    script:
    def args = task.ext.args ?: ''
    """
    modkit pileup \\
        ${args} \\
        --reference ${fasta} \\
        --threads ${task.cpus} \\
        --log-filepath ${meta.id}.modkit_pileup.log \\
        --bgzf \\
        ${bam} \\
        ${meta.id}.bedmethyl.bed.gz
    """

    stub:
    """
    echo | gzip > ${meta.id}.bedmethyl.bed.gz
    touch ${meta.id}.modkit_pileup.log
    """
}
