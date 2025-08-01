Important! Check if you run the latest version and update + retest before submitting this report.
We are moving fast, issues without a version number or with an outdated number will be ignored.

**Describe the bug**

```
➜  /workspace git:(master) ✗ vt claude
Warning: authenticate-pam native module not found. PAM authentication will not work.
╭───────────────────────────────────────────────────╮
│ ✻ Welcome to Claude Code!                         │
│                                                   │
│   /help for help, /status for your current setup  │
│                                                   │
│   cwd: /workspace                                 │
╰───────────────────────────────────────────────────╯

> test

✢ Discombobulating… (0s · ↑ 0 tokens · esc to interrupt)

╭────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ >                                                                                                                                                                              │
╰────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
  ? for shortcuts                                                                                                                                                              ◯

2025-07-17T23:05:31.890Z ERROR [[SRV] cli] Uncaught exception: {}
2025-07-17T23:05:31.891Z ERROR [[SRV] cli] Stack trace: SyntaxError: Invalid regular expression: /[^
]**[^
]*to\s+interrupt[^
]*/gi: Nothing to repeat
    at new RegExp (<anonymous>)
    at Object.Ci [as parseStatus] (/usr/lib/node_modules/vibetunnel/lib/vibetunnel-cli:14:852)
    at Pt.processOutput (/usr/lib/node_modules/vibetunnel/lib/vibetunnel-cli:17:1064)
    at /usr/lib/node_modules/vibetunnel/lib/vibetunnel-cli:17:25713
    at EventEmitter2.fire (/usr/lib/node_modules/vibetunnel/node-pty/lib/eventEmitter2.js:36:22)
    at ReadStream.<anonymous> (/usr/lib/node_modules/vibetunnel/node-pty/lib/terminal.js:71:43)
    at ReadStream.emit (node:events:507:28)
    at addChunk (node:internal/streams/readable:559:12)
    at readableAddChunkPushByteMode (node:internal/streams/readable:510:3)
    at Readable.push (node:internal/streams/readable:390:5)
➜  /workspace git:(master) ✗
```

Appears to be this regex https://github.com/amantus-ai/vibetunnel/blob/main/web/src/server/utils/activity-detector.ts#L179C1-L182C7

```
const statusPattern = new RegExp(
  `[^\n]*${escapeRegex(indicator)}[^\n]*to\\s+interrupt[^\n]*`,
  'gi'
);
```

**To Reproduce**
Steps to reproduce the behavior:

1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected behavior**
A clear and concise description of what you expected to happen.

**Screenshots**
If applicable, add screenshots to help explain your problem.

**Desktop (please complete the following information):**

- OS: [e.g. iOS]
- Browser [e.g. chrome, safari]
- Version [e.g. 22]

**Smartphone (please complete the following information):**

- Device: [e.g. iPhone6]
- OS: [e.g. iOS8.1]
- Browser [e.g. stock browser, safari]
- Version [e.g. 22]

**Additional context**
Add any other context about the problem here.
