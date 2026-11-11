# nf-mod-modkit

Nextflow module for [modkit](https://github.com/nanoporetech/modkit) (modified-base
pileup and motif discovery from modBAMs). Used as a git submodule by pipelines.

Image: `ghcr.io/eit-gbi/nf-mod-modkit:v1.1.0`

Published for `linux/amd64` only — modkit ships no aarch64 build, so an arm64
image would carry an x86_64 binary. On an arm64 host, run with
`docker.runOptions = '--platform=linux/amd64'`.

## Processes

| Process | Path | Inputs | Emits |
| --- | --- | --- | --- |
| `MODKIT_PILEUP` | `pileup/main.nf` | `tuple val(meta), path(bam), path(bai)`, `tuple path(fasta), path(fai)` | `bedmethyl`, `log` |
| `MODKIT_MOTIF_SEARCH` | `motif_search/main.nf` | `tuple val(meta), path(bedmethyl)`, `tuple path(fasta), path(fai)` | `motifs`, `log` |

`MODKIT_PILEUP` needs a coordinate-sorted BAM carrying `MM`/`ML` tags. Those
tags are dropped by `samtools fastq` unless it is given `-T MM,ML`, and by
minimap2 unless it is given `-y`.

## Publishing

These processes do **not** publish their own outputs. Publishing is the
consuming pipeline's job, via a workflow `output {}` block. This keeps the
module reusable across pipelines that want different result layouts.

## Tool arguments

Flags are passed through `task.ext.args` rather than read from pipeline
`params`, so the module never depends on a particular pipeline's parameter
names:

```groovy
process {
    withName: MODKIT_PILEUP {
        ext.args = '--cpg --combine-strands'
    }
}
```

Each process also writes a modkit log, emitted as `log`. The log is stamped with
wall-clock times, so it is not a stable thing to checksum in a test.

## Use as submodule

Pin to a release tag rather than a branch, so pipeline runs stay reproducible:

```bash
git submodule add https://github.com/EIT-GBI/nf-mod-modkit.git modules/modkit
git -C modules/modkit checkout v1.1.0
```

Then include the module's container config from your `nextflow.config`. Nextflow
does not read a submodule's config on its own, so without this line the
processes have no image:

```groovy
includeConfig 'modules/modkit/conf/module.config'
```

`conf/module.config` pins the image to the version built from this same commit,
and carries no `manifest {}` block, so it will not overwrite your pipeline's
own manifest. Override it in your pipeline with a `withName` selector if needed.

And include the processes:

```groovy
include { MODKIT_PILEUP } from './modules/modkit/pileup/main.nf'
include { MODKIT_MOTIF_SEARCH } from './modules/modkit/motif_search/main.nf'
```

## Requirements

Nextflow 26.04.4 or newer.

## Releasing

Merging a PR to `main` with exactly one `bump:patch`, `bump:minor` or
`bump:major` label bumps `manifest.version` in `nextflow.config`, tags the
release and publishes the container image.
