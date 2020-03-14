# Block merge commits that not synchronized with target branch

## Setup

Create a file in your project named: `.github/workflows/git.yml` Add the
following:

```yaml
name: Git Merge Checks

on: [push]

jobs:
  block-merge-synchronized:
    runs-on: ubuntu-18.04

    steps:
    - uses: actions/checkout@v2.0.0
    - uses: involic/synchronized-target-branch-action@v1
      with: 
        branch: 'master'  
    
```
