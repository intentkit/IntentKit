#!/bin/sh
appledoc \
--project-name "IntentKit" \
--project-company "Mike Walker" \
--company-id "com.lazerwalker" \
--docset-atom-filename "IntentKit.atom" \
--output "./docs" \
--docset-feed-url "http://intentkit.github.io/%DOCSETATOMFILENAME" \
--docset-package-url "http://intentkit.github.io/%DOCSETPACKAGEFILENAME" \
--docset-fallback-url "http://intentkit.github.io" \
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