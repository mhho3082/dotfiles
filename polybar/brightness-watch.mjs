import fs from 'fs/promises';
import { exec } from 'child_process';

const backlights = await fs.readdir("/sys/class/backlight");
if (backlights.length === 0) {
  throw new Error("No backlight devices found!");
}

const file_path = `/sys/class/backlight/${backlights[0]}/brightness`;

const output = () => {
  exec(
    "brightnessctl",
    (_err, stdout, _stderr) => {
      const percentage = stdout.trim().match(/(\d+)%/)?.[1];
      const icon = percentage >= 70 ? "󰃠" : percentage > 30 ? "󰃟" : "󰃞";
      console.log(`%{F#83A598}${icon}%{F-} ${percentage}%`);
    }
  );
}

// Run once first
output();

// Watch the brightness file
const watcher = fs.watch(file_path);
for await (const _ of watcher) { output(); }
