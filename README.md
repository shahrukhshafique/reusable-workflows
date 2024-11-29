# GitHub Reusable Workflows

Welcome to the **GitHub Reusable Workflows** repository! This repository contains a collection of reusable workflows for automating various CI/CD tasks with GitHub Actions. These workflows are designed to be flexible, modular, and easily adaptable to different projects.

## Table of Contents

- [Overview](#overview)
- [Workflows](#workflows)
  - [Workflow 1: `Maven Build and Test`](https://github.com/shahrukhshafique/reusable-workflows/actions/workflows/build.yml)
  - [Workflow 2: `Docker Build and Push`](https://github.com/shahrukhshafique/reusable-workflows/actions/workflows/dockerbuild-and-push.yml)
  - [Workflow 3: `Deploy Application to EKS with Helm`](https://github.com/shahrukhshafique/reusable-workflows/actions/workflows/helm-deploy.yml)
- [How to Use](#how-to-use)


## Overview

GitHub Actions reusable workflows allow you to define workflow templates that can be used across multiple repositories. This repository houses a set of pre-configured workflows that automate common tasks like testing, building, and deployment. The workflows can be imported and customized based on your project’s specific requirements.

## Workflows

Below is a list of the reusable workflows available in this repository:

### Workflow 1: `Maven Build and Test`

This is an example of a simple reusable workflow that runs tests and builds the project.

- **Location**: `.github/workflows/build.yml`
- **Key Features**:
  - create java build using maven
  - upload the artifact , in this case it will upload the application jar file
  - run maven test
 
  
#### Example usage:

```yaml
jobs:
  build:
    uses: shahrukhshafique/reusable-workflows/.github/workflows/build.yml@main
    with:
      CODE_REPO: ${{ github.repository }}


### Workflow 2: `Docker Build and Push`

This is an example of a simple reusable workflow that runs tests and builds the project.

- **Location**: `.github/workflows/dockerbuild-and-push.yml`
- **Key Features**:
  - create docker images using the dockerfile form provided git repo
  - tag the image with ECR info
  - push the image into ECR
 
  
#### Example usage:

```yaml
jobs:
 # dockerfile job: Dockerize with the built JAR and push into ECR
  docker-build-and-push:
    needs: build  
    uses: shahrukhshafique/reusable-workflows/.github/workflows/dockerbuild-and-push.yml@main
    with:
      CODE_REPO: ${{ github.repository }}
    secrets: inherit

### Workflow 3: `Deploy Application to EKS with Helm`

This is an example of a simple reusable workflow that runs tests and builds the project.

- **Location**: `.github/workflows/helm-deploy.yml`
- **Key Features**:
  - checkout with the provided helm-chart repo 
  - run the helm upgrade command to upgrade install the chart into EKS
 
  
#### Example usage:

```yaml
jobs:
  # Deploy job: App deploy to EKS using helm charts
  helm-upgrade:
    needs: docker-build-and-push  
    uses: shahrukhshafique/reusable-workflows/.github/workflows/helm-deploy.yml@main
    with:
      CODE_REPO: "shahrukhshafique/helm-charts"
      path: webapp
    secrets: inherit

