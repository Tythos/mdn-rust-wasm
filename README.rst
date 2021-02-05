mdn-rust-wasm
=============

Working copy of the Rust/WASM tutorial from MDN:
  https://developer.mozilla.org/en-US/docs/WebAssembly/Rust_to_wasm

Primary entry point is "run.bat", which automates several steps:

#. Uses the Rust project under "hello-wasm" to build a WASM module using
   wasm-pack. At this time, this is pretty much a duplicate of the original MDN
   project, and results in a .WASM file and several .JS/.TS wrappers being
   generated in the "pkg/" folder.

#. Copies .WASM/.JS/.TS files from hello-wasm/pkg to the site/ folder, so we
   can avoid the npm-link steps outlined in the original MDN article (which can
   go haywire if not replicated exactly--or if these contents are cloned from
   Git). This means that the WASM is no longer included from the local
   "node_modules" folder (and hello-wasm is therefore no longer
   cross-referenced from the "package.json" dependencies). Node modules are
   still required for webpack and hosting, however.

#. Installs webpack and hosting dependencies from the package in "site" and
   launches local hosting with webpack. The project can then be accessed by
   browsing to "http://localhost:8080".
