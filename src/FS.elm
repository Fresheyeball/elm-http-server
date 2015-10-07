module FS where

import Native.FS

type ReadErr = ReadErr

readFile : String -> Task ReadErr String
readFile = Native.FS.readFile
