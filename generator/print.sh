GREEN='\033[0;32m'
BLUE='\033[4;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_success () {
    echo -e "${GREEN}$1 ${NC}"
}

print_info () {
    echo -e "${BLUE}$1 ${NC}"
}

print_error () {
    echo -e "${RED}$1 ${NC}"
}

print_warning () {
    echo -e "${YELLOW}$1 ${NC}"
}