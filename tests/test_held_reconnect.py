"""Exercise the manual reconnect action with and without an authenticated Hold."""
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class HeldReconnectTests(unittest.TestCase):
    def test_manual_reconnect_with_saved_login_unavailable(self):
        with tempfile.TemporaryDirectory(prefix='kakao-held-reconnect-') as temporary:
            binary = Path(temporary) / 'reconnect'
            subprocess.run(
                ['xcrun', 'clang', '-fobjc-arc', '-Wall', '-Wextra', '-Werror',
                 '-framework', 'Cocoa', str(ROOT / 'tests/held_reconnect.m'),
                 str(ROOT / 'reconnect/AppUpdater.m'), '-o', str(binary)],
                check=True,
            )
            subprocess.run([str(binary)], check=True)
