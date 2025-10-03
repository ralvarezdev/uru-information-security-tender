@echo off

REM Check if OpenSSL is installed
where openssl >nul 2>&1
if errorlevel 1 (
    echo Error: OpenSSL is not installed or not found in PATH.
    exit /b 1
)

REM Generate keys using OpenSSL
echo Generating Certificate Microservice Ed25519 key pair...
openssl genpkey -algorithm ed25519 -out certificate_private_key.pem
openssl pkey -in certificate_private_key.pem -pubout -out certificate_public_key.pem
echo Keys generated: certificate_private_key.pem and certificate_public_key.pem

echo Generating Encrypter Microservice Ed25519 key pair...
openssl genpkey -algorithm ed25519 -out encrypter_private_key.pem
openssl pkey -in encrypter_private_key.pem -pubout -out encrypter_public_key.pem
echo Keys generated: encrypter_private_key.pem and encrypter_public_key.pem

echo Generating Decrypter Microservice RSA key pair...
openssl genpkey -algorithm rsa -out decrypter_private_key.pem
openssl pkey -in decrypter_private_key.pem -pubout -out decrypter_public_key.pem
echo Keys generated: decrypter_private_key.pem and decrypter_public_key.pem

echo All keys generated successfully.