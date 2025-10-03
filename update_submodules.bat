@echo off

@echo Updating certificate-grpc submodule...
git submodule update --remote certificate-grpc
@echo Updated certificate-grpc submodule.

@echo Updating encrypter-grpc submodule...
git submodule update --remote encrypter-grpc
@echo Updated encrypter-grpc submodule.

@echo Updating decrypter-grpc submodule...
git submodule update --remote decrypter-grpc
@echo Updated decrypter-grpc submodule.

@echo Updating certificate-app submodule...
git submodule update --remote certificate-app
@echo Updated certificate-app submodule.

@echo Updating bidder-app submodule...
git submodule update --remote bidder-app
@echo Updated bidder-app submodule.

@echo Updating admin-app submodule...
git submodule update --remote admin-app
@echo Updated admin-app submodule.

@echo Git submodules updated.