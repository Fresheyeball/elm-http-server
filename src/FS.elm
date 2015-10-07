module FS where

import Task exposing (Task)
import Native.FS

type ReadError = ReadError

readFile : String -> Task ReadError String
readFile = Native.FS.readFile
