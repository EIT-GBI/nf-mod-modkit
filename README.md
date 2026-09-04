# nf-mod-modkit


Nextflow module for modkit. Used as a git submodule by pipelines.

Image: `ghcr.io/eit-gbi/nf-mod-modkit:latest`

## Processes

- `MODKIT` — TODO: describe inputs/outputs

## Use as submodule
```bash
git submodule add https://github.com/eit-gbi/nf-mod-modkit.git modules/modkit
```

Then in your pipeline:
```
include { MODKIT } from './modules/modkit/main.nf'
```
