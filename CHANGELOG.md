# Changelog

All notable changes to this project will be documented in this file.

The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).
This changelog is generated automatically based on [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

## [1.2.0](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/compare/v1.1.3...v1.2.0) (2025-09-17)


### Features

* **deps:** Update Terraform Google Provider to v7 (major) ([#85](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/issues/85)) ([c1906f9](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/commit/c1906f986802a940b1c639530606ac4bf01f48b4))


### Bug Fixes

* Add UI validation for spanner ([#84](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/issues/84)) ([39d04b9](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/commit/39d04b9c817ada3317ef290edafc4c4eb8a244d5))
* per module requirements configs for cloud-spanner ([#81](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/issues/81)) ([951cfaa](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/commit/951cfaaae8e7aed85f912feb1ccd90cbb0efd5e5))

## [1.1.3](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/compare/v1.1.2...v1.1.3) (2025-03-13)


### Bug Fixes

* improve doc for Spanner instance_config input and update env_vars output ([#75](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/issues/75)) ([820dfa5](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/commit/820dfa5cc826e3c896a10e50fb045120dd1dd02b))

## [1.1.2](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/compare/v1.1.1...v1.1.2) (2025-03-12)


### Bug Fixes

* Changing type for ddl and database_iam in database_config ([#71](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/issues/71)) ([51cb379](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/commit/51cb3798ce89d662bcd3a1697374f4b4d09c38bb))

## [1.1.1](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/compare/v1.1.0...v1.1.1) (2025-02-28)


### Bug Fixes

* fix env_vars metadata ([#67](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/issues/67)) ([63d8d21](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/commit/63d8d2184ac340ef9482da78f09f024b0f739e68))

## [1.1.0](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/compare/v1.0.0...v1.1.0) (2025-02-27)


### Features

* expose spanner connection string as output ([#66](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/issues/66)) ([b3e5093](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/commit/b3e5093c3d4d711f74e300fd5e35f4faad44c6af))
* schedule backup require retention time as string, and regenerate ADC metadata file ([#65](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/issues/65)) ([2bfb8e4](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/commit/2bfb8e4b0fa62e86ca7d17841bdd5e591c24f93e))


### Bug Fixes

* update generate docs command to correctly generate metadata files ([#61](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/issues/61)) ([e144e40](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/commit/e144e400be56472678f21597e010d822f4b9576f))

## [1.0.0](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/compare/v0.3.0...v1.0.0) (2025-01-29)


### ⚠ BREAKING CHANGES

* **TPG>=6.1:** add support of editions, autoscaler and scheduling backup on Spanner ([#54](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/issues/54))

### Features

* **TPG>=6.1:** add support of editions, autoscaler and scheduling backup on Spanner ([#54](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/issues/54)) ([6366f3b](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/commit/6366f3ba4b8b9359c45f0de50434da46301084cd))

## [0.3.0](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/compare/v0.2.0...v0.3.0) (2024-10-08)


### Features

* **deps:** Update Terraform google to v6 ([#45](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/issues/45)) ([1d5d603](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/commit/1d5d60367bd6743e4614fd68b331e19210adcf9d))

## [0.2.0](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/compare/v0.1.0...v0.2.0) (2024-09-13)


### Features

* **deps:** Update Terraform google to v6 ([#39](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/issues/39)) ([66a332f](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/commit/66a332ff6b5b45ee5bb55ce1cc8ac530ae60c9a9))

## 0.1.0 (2023-12-21)


### Miscellaneous Chores

* release 0.1.0 ([4878830](https://github.com/GoogleCloudPlatform/terraform-google-cloud-spanner/commit/487883073cc040db6d35ce59567ffaed22d6d887))

## [0.1.0](https://github.com/terraform-google-modules/terraform-google-cloud-spanner/releases/tag/v0.1.0) - 20XX-YY-ZZ

### Features

- Initial release

[0.1.0]: https://github.com/terraform-google-modules/terraform-google-cloud-spanner/releases/tag/v0.1.0
