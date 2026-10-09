# NYC 311 Service Request Analytics
# Data Preprocessing: Select relevant columns from the original dataset

import csv
from pathlib import Path

downloads = Path.home() / "Downloads"

matches = [
    p for p in downloads.glob("*.csv")
    if "311_Service_Requests" in p.name
]

if not matches:
    print("Couldn't find the NYC 311 CSV in Downloads.")
    raise SystemExit

source = max(matches, key=lambda p: p.stat().st_mtime)
output = downloads / "NYC_311_Six_Columns.csv"

if output.exists():
    print("The smaller CSV already exists. Nothing was overwritten.")
    raise SystemExit

wanted = [
    "Unique Key",
    "Created Date",
    "Closed Date",
    "Problem (formerly Complaint Type)",
    "Status",
    "Borough",
]

with source.open("r", encoding="utf-8-sig", newline="") as infile:
    reader = csv.DictReader(infile)

    missing = [name for name in wanted if name not in reader.fieldnames]

    if missing:
        print("These column names weren't found:", missing)
        print("Actual column names:", reader.fieldnames)
        raise SystemExit

    with output.open("w", encoding="utf-8", newline="") as outfile:
        writer = csv.DictWriter(outfile, fieldnames=wanted)
        writer.writeheader()

        count = 0
        for row in reader:
            writer.writerow({name: row[name] for name in wanted})
            count += 1

print(f"Finished! Copied {count:,} rows.")
print(f"Original file: {source}")
print(f"New file: {output}")
print(f"New file size: {output.stat().st_size / 1_000_000:.1f} MB")