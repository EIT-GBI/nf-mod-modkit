// this process identifies the motifs in the bedMethyl file


process MODKIT_MOTIF_SEARCH {
    tag "${meta.id}"

    publishDir "${params.outdir}/methylation/motifs", mode: 'link'

    input:
    tuple val(meta), path(bedmethyl)
    tuple path(fasta), path(fai)

    output:
    tuple val(meta), path("${meta.id}.motifs.tsv"), emit: motifs
    path "${meta.id}.modkit_motif_search.log",      emit: log

    script:
    def args = task.ext.args ?: ''
    """
    modkit motif search \\
        ${args} \\
        -i "${bedmethyl}" \\
        -r "${fasta}" \\
        -o ${meta.id}.motifs.tsv \\
        --threads ${task.cpus} \\
        --log-filepath ${meta.id}.modkit_motif_search.log
    """

    stub:
    """
    touch ${meta.id}.motifs.tsv ${meta.id}.modkit_motif_search.log
    """
}
