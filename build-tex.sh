#!/usr/bin/env bash

usage()
{
  echo ""
  echo "This is a simple script for compiling a latex file (.tex)"
  echo ""
  echo "usage: sh build-tex.sh [-h] <tex-file> (optional: <dep-file1> <dep-file2> ...)"
  echo ""
  echo "\t-h            :  prints usage details"
  echo "\t<tex-file>    :  .tex file to be compiled"
  echo "\t<dep-file#>   :  file that needs to be referenced by .tex file, i.e. png,pdf,etc."
}

setup_dir()
{
  echo "Setting up directory for build"
  rm -r $__tex_out
  mkdir -p $__tex_out
}

copy_deps()
{
  for dep in "${__deps[@]}"
  do
    echo $dep
    depName=$(basename $dep)
    dest=$__tex_out/$depName
    echo $(cp $dep $dest)
  done
}

build_tex() 
{
  echo "Building tex file..."
  echo "Running: $__tex_compiler $__tex_compiler_args $__file"

  # capture output of build
  msg=$($__tex_compiler $__tex_compiler_args $__file)

  outFile="$__tex_out/$__nameOfFile.pdf"

  if [ ! -f "$outFile" ]; then
    echo $msg
    exit
  else
    echo "Build succeeded"
  fi

  echo $(rm "$__tex_out/../$__nameOfFile.aux")
  echo $(cp $__tex_out/$__nameOfFile.aux $__tex_out/../$__nameOfFile.aux)

  # rerun compile with .aux present
  msg=$($__tex_compiler $__tex_compiler_args $__file)

  outFile="$__tex_out/$__nameOfFile.pdf"

  if [ ! -f "$outFile" ]; then
    echo $msg
  else
    echo "Build succeeded"
  fi
}

parse_args()
{
  j=0
  for i
  do
    echo $i
    __args[j]=$i
    j=$((j+1))
  done

  k=1
  while [[ $k < $# ]]
  do
    __deps[k]=${__args[$k]}
    echo ${__deps[k]}
    k=$((k+1))
  done
}

if [ $1 == '-h' ]; then
  usage
  exit
fi

__args=[]

parse_args $@

__file=${__args[0]}
__nameOfFile=$(basename $__file)
__nameOfFile="${__nameOfFile/.tex/}"
__tex_out=$(dirname $__file)
__tex_out="$__tex_out/out"


__tex_compiler="latexmk"
__tex_compiler_args="-pdf"
__tex_compiler_args="$__tex_compiler_args -file-line-error"
__tex_compiler_args="$__tex_compiler_args -output-directory=$__tex_out"

# create output directory for pdf
setup_dir

# copy dependencies
copy_deps

# compile .tex file
build_tex
