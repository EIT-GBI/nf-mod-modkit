# nf-mod-modkit


Nextflow module for modkit. Used as a git submodule by pipelines.

Image: `ghcr.io/eit-gbi/nf-mod-modkit:v0.0.0`

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

## Pinning

Pipelines pin a release rather than tracking `main`:

```bash
git -C modules/modkit checkout v0.0.0
```

and pick up the matching image with `includeConfig 'modules/modkit/conf/module.config'`.
