// this module does the modkit pileup of all reads
// it takes a BAM with MM/ML tags and outputs a bedMethyl file
// https://genome-euro.ucsc.edu/goldenPath/help/bedMethyl.html
// https://nanoporetech.github.io/modkit/intro_pileup_hemi.html


process MODKIT_PILEUP {
    tag "${meta.id}"


    input:
    tuple val(meta), path(bam), path(bai)
    tuple path(fasta), path(fai)

    output:
    tuple val(meta), path("${meta.id}.bedmethyl.bed"), emit: bedmethyl
    path "${meta.id}.modkit_pileup.log",               emit: log

    script:
    def args = task.ext.args ?: ''
    """
    modkit pileup \\
        ${args} \\
        --ref "${fasta}" \\
        --threads ${task.cpus} \\
        --log-filepath ${meta.id}.modkit_pileup.log \\
        "${bam}" \\
        ${meta.id}.bedmethyl.bed
    """

    stub:
    """
    touch ${meta.id}.bedmethyl.bed ${meta.id}.modkit_pileup.log
    """
}
