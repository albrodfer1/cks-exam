## Introduction

This repo was used for personal preparation for the CKS exam. It contains infrastructure to be deployed in AWS to provision a lab environment and some cheatsheets with basic info useful for the exam.

The labs I'm used are documented in here: https://github.com/zealvora/certified-kubernetes-security-specialist/

## Cheatsheets

Cheatsheets are under `chops` folder.

## Calulate the cost of cloud resources

As of the date of writting of this document, the resources have an estimated cost of 35$ a month. It was calculated using the tool `infracost`.

To be run from `infrastructure/terraform/aws` folder:

```shell
infracost breakdown --path .
```

## FAQ

### Why Cheatsheets are under `chops` folder?


I named my cheatsheet folder "chops" because "chuletas" in Spanish translates to cheatsheets in English. The word "chuleta" in Spanish has an interesting origin and a double meaning. Traditionally, "chuleta" means "chop," as in a cut of meat, particularly a pork chop or lamb chop. However, in the context of academics, "chuleta" is colloquially used to refer to a cheatsheet.

This usage likely stems from the visual similarity between a cut of meat with information written on it and a small piece of paper filled with crucial details or answers. Over time, students and others adopted "chuleta" as a playful metaphor for a piece of paper that serves to "nourish" their memory during exams or challenging situations, much like how a chop provides nourishment.

By naming my folder "chops," I created a bilingual pun that reflects both the literal and figurative meanings of "chuleta." It’s a nod to the cleverness and resourcefulness often associated with using a cheatsheet, wrapped up in a term that bridges languages and cultures.