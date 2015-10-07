module VDOMtoHTML where

import VirtualDom exposing (Node)
import Native.VDOMtoHTML

toHTML : Node -> String
toHTML = Native.VDOMtoHTML.toHTML
