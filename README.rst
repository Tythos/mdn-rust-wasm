mdn-rust-wasm
=============

Working copy of the Rust/WASM tutorial from MDN:

  https://developer.mozilla.org/en-US/docs/WebAssembly/Rust_to_wasm

MDN
---

Primary entry point for the original tutorial is "run-mdn.bat", which automates
several steps:

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

Standalone
----------

There are several shortcomings and unnecessary complications in the MDN
tutorial. We can greatly streamline the process outlined with several
adjustments:

* Avoid binding JavaScript callbacks so they don't have to be
  embedded/hard-coded within the WASM module. This would help the WASM module
  be completely self-contained because it would no longer require any .JS/.TS
  wrappers.

* A standalone build would also be facilitated by using the following flag by
  invoking "wasm-pack build" with the "--target no-modules" flag.

* We'd love to move away from ES5 modules and use something AMD-compatible,
  like RequireJS.
  
* In fact, RequireJS supports loader extensions we could use to wrap .WASM
  loading and automate in the same manner that we load any other module file.

With this in mind, we have copies of both "wasm" and "site" folders that
accomplish all of the above (and can be invoked by the "run-standalone.bat"
script):

* The "hello-wasm-standalone/" has source code in Rust that defines an
  exportable library. Unlike the MDN tutorial, this is a self-contained library
  that does not depend on any symbols/bindings imported from JavaScript. When
  "wasm-pack build --target no-modules" is invoked from this folder, a .WASM
  file is generated in the "pkg/" folder. This folder also includes a couple of
  .JS and .TS wrappers that are, actually, no longer needed.

* The "site-local-requirejs/" has a basic static file web application (SWFA)
  that uses "hello_wasm_standalone_bg.wasm" copied from the Rust build. The
  "index.html" file launches the web application by using RequireJS to start up
  the entry point in "index.js".

WASM Loader
-----------

There is also a "wasmloader.js" file in the "site-local-requirejs/" folder.
This defines a module loader extension to RequireJS that lets modules
(including the top-level entry point, "index.js") specify .WASM files as a
dependency, just like any other (typically JavaScript) module::

  > const wasm = require("wasm!hello_wasm_standalone_bg.wasm");

The module symbol returned by this (asynchronous) function, at this time,
returns an instance of the WASM module as natively defined by the browser's
interpretation. This means the "exports" property of this object contains
callable functions that can be used to access and invoke behavior defined
within the (stateless) Rust/WASM module.

Expect additional developed (under a separate project, perhaps) of the WASM
Loader extension. This may invoke wrapping the module returned within an object
extension that provides additional support for function bindings, data/types
conversion, stateful representations, memory management, and other behaviors
typically handled by a wrapper (as in the case of Emscripten or full
"wasm-pack" builds.

Performance optimization would also greatly benefit from a WebThread-like
implementation (or wrapping) of WASM modules that perform computation
independently. It is not clear at this time if this is something that could be
supported by additional development of open standards in the near future, or by
some intermediate approach facilitated by an implicit wrapper (perhaps by the
loader extension) that supports a WebThread-based approach.
