#!/bin/bash

# Determine the operating system
if [[ "$OSTYPE" == "msys" ]]; then
  GRPCURL="grpcurl.exe"
else
  GRPCURL="grpcurl"
fi

while true; do
  echo "Select an option to test the proto server:"
  echo "1. Ping"
  echo "2. Send"
  echo "3. Receive"
  echo "4. Cleanup"
  echo "5. Exit"
  read -p "Enter your choice: " choice

  case $choice in
    1)
      $GRPCURL -d "{\"from\":\"node1\"}" -import-path $(pwd)/base/ -proto base.proto -plaintext localhost:9000 base.proto.Broker/Ping
      ;;
    2)
      echo "Enter message data:"
      read data
      echo "Enter sender (from):"
      read from
      echo "Enter receiver (to):"
      read to
      base64_data=$(echo -n "$data" | base64)
      $GRPCURL -d "{\"data\":\"$base64_data\", \"queue\":\"true\", \"type\":\"TEXT\", \"from\":\"$from\", \"to\":\"$to\"}" -import-path $(pwd)/base/ -proto base.proto -plaintext  localhost:9000 base.proto.Broker/Send
      ;;
    3)
      echo "Enter sender (from):"
      read from
      $GRPCURL -d "{\"from\":\"$from\"}" -import-path $(pwd)/base/ -proto base.proto -plaintext  localhost:9000 base.proto.Broker/Receive
      ;;
    4)
      echo "Enter sender (from):"
      read from
      $GRPCURL -d "{\"from\":\"$from\"}" -import-path $(pwd)/base/ -proto base.proto -plaintext  localhost:9000 base.proto.Broker/Cleanup
      ;;
    5)
      echo "Exiting..."
      break
      ;;
    *)
      echo "Invalid choice"
      ;;
  esac
done