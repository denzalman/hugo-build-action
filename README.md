# Github Action for Hugo and Github Pages

This action make build of Hugo static web pages and then deploy them to defined Github Pages.

## Environment:

- **HUGO_VERSION**: 0.59.1 (used vesion of Hugo)
- **TARGET_REPO**: rtfmdev/rtfmdev.github.io (link of your Github Pages)
- **TOKEN**: ${{ secrets.TOKEN }}

**TOKEN** is [GitHub access token](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line#creating-a-token) which have to be added to your repository secret variables (See **Settings** -> **Secrets** -> **Add new secret** menu inside your repo).

##  My tiny example
```
name: Build and publish Hugo Pages
on:
  push:
    branches:
      - master
    paths:
      - 'content/**'
jobs:
  build:
    name: Deploy
    runs-on: ubuntu-latest
    steps:
    - name: Checkout master
      uses: actions/checkout@v1

    - name: Deploy the Github Pages
      uses: denzalman/hugo-build-action@v1.0.0
      env:
        HUGO_VERSION: 0.59.1
        TARGET_REPO: rtfmdev/rtfmdev.github.io
        TOKEN: ${{ secrets.TOKEN }}
```
