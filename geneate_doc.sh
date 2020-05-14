#!/bin/sh

mkdir -p docs

# TODO Add ddoc to the source code
#dub build --build=docs

echo "---" > docs/index.md
echo "layout: default" >> docs/index.md
echo "title: About" >> docs/index.md
echo "---" >> docs/index.md
cat README.md >> docs/index.md


