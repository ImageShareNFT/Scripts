#!/bin/bash
solana config get
read -p "Check the Specifies the Solana cluster (e.g., devnet, testnet, mainnet-beta) Are you sure? (Y/N): " choice

case "$choice" in
  [yY] )
    echo "Confirmed."
    # Place your commands here for the 'yes' case
    ;;
  [nN] )
    echo "Cancelled."
    # Place your commands here for the 'no' case or exit
    exit 1
    ;;
  * )
    echo "Invalid input. Please enter Y or N."
    exit 1
    ;;
esac

# Continue with the rest of your script
read -p "Enter Prefix for random Wallet Address 3 char: " Wallet_prefix
export Wallet_prefix="$Wallet_prefix"
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

solana-keygen grind --starts-with $Wallet_prefix:1

sudo chmod 777 *.*

# List JSON files and store in a variable
export JSON_FILES=$(ls $Wallet_prefix*.json)

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
