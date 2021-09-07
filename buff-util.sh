tmpdir="./"
defcmd="--help"
DIR=${1:-$tmpdir}   # Defaults to /tmp dir.
CMD=${2:-$defvalue}     
docker run --rm \
  --volume "$(pwd)/$DIR:/workspace" \
  --workdir /workspace \
  bufbuild/buf $CMD