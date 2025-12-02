import os
import json
import shutil

ROOT = os.path.dirname(os.path.dirname(__file__))  # project root
thumbs_dir = os.path.join(ROOT, 'assets', 'images', 'thumbs')
json_path = os.path.join(ROOT, 'assets', 'data', 'skin.json')

# Find an existing png to use as placeholder
existing = [f for f in os.listdir(thumbs_dir) if f.lower().endswith('.png')]
if not existing:
    print('No existing thumbnails found to copy. Aborting.')
    raise SystemExit(1)
source_file = os.path.join(thumbs_dir, existing[0])
print('Using source thumbnail:', existing[0])

with open(json_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

copied = []
for item in data:
    thumb = item.get('thumbnail')
    if not thumb:
        continue
    # Normalize path relative to project root
    target = os.path.join(ROOT, *thumb.split('/'))
    if not os.path.exists(target):
        # Ensure directory exists
        os.makedirs(os.path.dirname(target), exist_ok=True)
        shutil.copyfile(source_file, target)
        copied.append(os.path.relpath(target, ROOT))

print('Copied', len(copied), 'files:')
for c in copied:
    print(' -', c)
