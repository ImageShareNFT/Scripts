#!/bin/bash

read -p "Enter the Token Name: " Token_name
export Token_name="$Token_name"
read -p "Enter the Token Symbol: " Token_Symbol
export Token_Symbol="$Token_Symbol"
read -p "Enter the Token Decimals: " Token_Decimals
export Token_Decimals="$Token_Decimals"
read -p "Enter the Token mint Supply: " Token_mintSupply
export Token_mintSupply="$Token_mintSupply"
read -p "Enter the Token Metadata URI: " Token_Uri
export Token_Uri="$Token_Uri"

echo "Token Name: $Token_name"
echo "Token Symbol: $Token_Symbol"
echo "Token Decimals: $Token_Decimals"
echo "Token mint Supply: $Token_mintSupply"
echo "Token Metadata URI: $Token_Uri"

solana-keygen grind --starts-with ${Token_Symbol:0:3}:1

# List JSON files and store in a variable
export JSON_FILES=$(ls ${Token_Symbol:0:3}*.json)

# Display the list of files
echo "Authority Keypair: $JSON_FILES"

# Extract file names without the .json extension
for file in $JSON_FILES; do
  filename=$(basename "$file" .json)
  echo "Address Authority Owner: $filename"

spl-token create-token \
--program-id TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb \
--enable-metadata \
--decimals $Token_Decimals \
$JSON_FILES

spl-token initialize-metadata \
$filename \
$Token_name \
$Token_Symbol \
$Token_Uri

spl-token create-account $filename

spl-token mint $filename $Token_mintSupply

done
