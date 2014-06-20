if [[ $1 == "add" ]]; then
  # LC_ALL: required for tr, for more info: http://unix.stackexchange.com/questions/45404/why-cant-tr-read-from-dev-urandom-on-osx
  export KEYCHAIN_PASSPHRASE="$(cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)"

  # Create the keychain
  security -v create-keychain -p "$KEYCHAIN_PASSPHRASE" "$CONCRETE_KEYCHAIN"

  # Import to keychain
  security -v import "$CERTIFICATE_PATH" -k "$CONCRETE_KEYCHAIN" -P "$CONCRETE_CERTIFICATE_PASSPHRASE" -A

  # Unlock keychain
  security -v set-keychain-settings -lut 72000 "$CONCRETE_KEYCHAIN"
  security -v list-keychains -s "$CONCRETE_KEYCHAIN"
  security -v list-keychains
  security -v default-keychain -s "$CONCRETE_KEYCHAIN"
  security -v unlock-keychain -p "$KEYCHAIN_PASSPHRASE" "$CONCRETE_KEYCHAIN"
elif [[ $1 = "remove" ]]; then
  security -v delete-keychain "$CONCRETE_KEYCHAIN"
  unset KEYCHAIN_PASSPHRASE
fi