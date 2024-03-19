# Changelog

All notable changes to this project will be documented in this file.
For each version important additions, changes and removals are listed here. 

The format is inspired from [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and the versioning aims to respect [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [v2.1.0] Minor and Feature Release - 2024-01-28

### Added
- add MainWindow Function and change icon or title name
- show warning when closing QGIS. Improve popup dialog
- add icon to main window
- add missed improt

### Changed
- simplify the gpkg_popup.py code
- adjust button dimensions based on resolution
- minor change
- change README.md
- change QGIS projects file
- optimize QGIS3.ini to version 3.34
- change QGIS Version to 3.34.1
- improve comments
- move file to the annotation folder
- change zoom to max extent

### Removed
- remove button function zoom out
- remove comment
- remove unuseful codes

### Fixed
- fix leftPanel bug on initialization
- fix macros indipendent from process of saving QLR file
- fix position buttons when monitor scale > 125%
- fix position buttons when page resized
- fix rotation for annotations in print
- fix and change main titel and icon path fix
- fix title of the main window
- fix bug log private geopackages

## [v2.0.2] Fix and Change - 2023-12-29

### Added
- add _initCheckGeopackagesLayer and change gpkg_popup.py to dynamic strings
- add new deployment
- add close qgis windows event to close btn of openSynchTool def
- add marco to gpkg_popup
- add alphabetically layers of a new private gpkg file 

### Changed
- change manifest.txt
- change marco path
- change again height els in layer tree
- minor change
- increase width based on text in layer tree

### Removed
- remove horizontal scrollbar in layer tree
- remove unuseful resources, othe minor changes
- remove red symbol from text annotation
- remove fake geopackage

### Fixed
- fix gpkgPopup
- fix bugs
- fix marco and qgis project: Save automatic layertree to sequence.yml
- fix gpkgPopup.show mit custom text

## [v2.0.0] Minor and Feature Release - 2023-11-08

### Added
- improvement comments of annotations.py

### Changed
- change north-arrow to print templates
- improve print and pdf export
- change splash.png
- change projectfile to qgz basename

### Removed
- remove old qgis ltr version
- remove time info to print templates
- remove unused file
- optimze python code

### Fixed
- fix bug a4_hoch.qpt
- fix backgroundlayer
- fix problem dim frame of text notation
- fix mFeature.attribute id String of search dialog
- fix height of layer page in left panel
- fix extent of luftbilder layer and optimize view

## [v1.3.3] Change and Fix - 2023-10-13

### Added
- add more variable to manifest file

### Fixed
- fix path Server_folder

## [v1.3.2] Change and Fix - 2023-06-22

### Changed
- change and update qgis-ltr to 3.22.16

### Fixed
- fixed run msi installer

## [v1.3.1] Change and Fix - 2023-03-24

### Added

### Changed
- change and update to QGIS 3.28.4

### Removed

### Fixed
- bugfix qgis style

## [v1.3.0] Minor Release - 2022-07-01

### Added

### Changed
- toolbar disable

### Removed

### Fixed
- fix bug if info geopackage is corrupt

## [v1.2.6] Minor Release - 2022-05-31

### Added
- set visibility background image
- improve warning for search
- add empty folder to git

### Changed

### Removed

### Fixed

## [v1.2.5] Minor Release - 2021-11-19

### Added
- Improvement plot

### Changed

### Removed
- remove warning for some gpkgs

### Fixed