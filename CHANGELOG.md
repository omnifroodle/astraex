# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.1] - 2021-08-25
- fix bad test for non astra stargate url

## [0.4.0] - 2021-08-25
- doc updates for non-astra stargate server
- changed default auth api path

## [0.3.3] - 2021-03-04
### New
- support for directly specifying Stargate URL in place of Astra region and id
- support for static application security tokens in place of username/password
- User agent now specifics project and release version `AstraEx\0.0.0`

## [0.3.2] - 2021-02-15
### New
- Initial GraphQL query support

## [0.3.1] - 2021-02-15
### Fixed
- More fixes for module attributes that should be adjustable at execution time

## [0.3.0] - 2021-02-15
### Fixed
- HttpBase url could not be set after compile time because it was define in a module attribute
### Changed
- Changed license to Apache 2.0


## [0.2.0] - 2021-02-10
### Changed
- Tesults from the document API no loger return atoms for the keys in their maps.  This was a bad practice for schemaless document storage.