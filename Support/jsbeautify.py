#!/usr/bin/env python
import os
import sys

sys.path.append(os.path.join(os.environ["TM_BUNDLE_SUPPORT"], "lib"))

import jsbeautifier

opts = jsbeautifier.default_options()

if os.environ["TM_SOFT_TABS"] == 'NO':
    opts.indent_size = 1
    opts.indent_char = '\t'
else:
    opts.indent_size = int(os.environ["TM_TAB_SIZE"])

print jsbeautifier.beautify_file('-', opts)
