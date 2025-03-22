#!/bin/bash

lua -e 'local ok = pcall(require, "tiktoken_core"); os.exit(ok and 0 or 1)' 2>/dev/null
