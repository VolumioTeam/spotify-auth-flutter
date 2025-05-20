#!/usr/bin/env bash

if [ -z "${CI+x}" ]; then
    FLUTTER="fvm flutter"
    DART="fvm dart"
else
    FLUTTER="flutter"
    DART="dart"
fi

printf "\e[33;1m%s\e[0m\n" 'Pre-Commit'

# Undo the stash of the files
pop_stash_files() {
  if [ -n "$hasChanges" ]; then
    printf "\e[33;1m%s\e[0m\n" '=== Applying git stash changes ==='
    git stash pop
  fi
}

# Stash unstaged files
hasChanges=$(git diff)
if [ -n "$hasChanges" ]; then
  printf "\e[33;1m%s\e[0m\n" 'Stashing unstaged changes'
  git stash push --keep-index
fi

# Dependencies
printf "\e[33;1m%s\e[0m\n" '=== Running Dependencies checker ==='
$DART pub global run dependency_validator

# Flutter formatter
printf "\e[33;1m%s\e[0m\n" '=== Running Flutter Formatter ==='
$DART format .

hasNewFilesFormatted=$(git diff)
if [ -n "$hasNewFilesFormatted" ]; then
  git add .
  printf "\e[33;1m%s\e[0m\n" 'Formatted files added to git stage'
fi
printf "\e[33;1m%s\e[0m\n" 'Finished running Flutter Formatter'

# Flutter Analyzer
printf "\e[33;1m%s\e[0m\n" '=== Running Flutter analyzer ==='
$FLUTTER analyze
if [ $? -ne 0 ]; then
  printf "\e[31;1m%s\e[0m\n" '=== Flutter analyzer error ==='
  pop_stash_files
  exit 1
fi
printf "\e[33;1m%s\e[0m\n" 'Finished running Flutter analyzer'

pop_stash_files
