#!/bin/bash

(
  DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
  . $DIR/$1
)

RESULT=$?

echo "Done with $1"
if [ -n "$CONTAINER_DEBUG" -a $RESULT -ne 0 ]; then
  echo -e "${YELLOW}Container kept alive for debugging. Use Ctrl+C to exit.${NC}"
  # Keep the container running for inspection when test fails
  if [ -n "$CONTAINER_DEBUG" ]; then
    echo -e "${YELLOW}Debug mode active. Enter commands or type 'exit' to quit.${NC}"
    echo -e "${YELLOW}You can connect to it using: docker exec -it \$CONTAINER_ID bash${NC}"
    echo -e "${YELLOW}Press Ctrl+C when done debugging to terminate the container.${NC}"
    sleep infinity
  fi
fi

exit $RESULT
