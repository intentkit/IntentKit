#!/bin/sh
appledoc \
--project-name "OpenInKit" \
--project-company "Mike Walker" \
--company-id "com.lazerwalker" \
--docset-atom-filename "OpenInKit.atom" \
--output "./docs" \
--docset-feed-url "http://lazerwalker.com/OpenInKit/%DOCSETATOMFILENAME" \
--docset-package-url "http://lazerwalker.com/OpenInKit/%DOCSETPACKAGEFILENAME" \
--docset-fallback-url "http://lazerwalker.com/OpenInKit/" \
--publish-docset \
--logformat xcode \
--keep-undocumented-objects \
--keep-undocumented-members \
--keep-intermediate-files \
--no-repeat-first-par \
--no-warn-invalid-crossref \
--ignore "*.m" \
--ignore "Pods" \
--ignore "MWViewController.h" \
--ignore "MWAppDelegate.h" \
--ignore "Helpers" \
--index-desc "./README.md" \
.