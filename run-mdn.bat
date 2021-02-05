@echo off
ECHO --- BUILDING WASM MODULE FROM RUST SOURCE ---
CD hello-wasm
wasm-pack build
echo --- COPYING BUILD PRODUCTS ---
COPY pkg\hello_wasm* ..\site
CD ..\site
echo --- INSTALLING DEPENDENCIES, SERVING AT LOCALHOST:8080 ---
CALL npm install
CALL npm run serve
