import os
import sys
import time
import hashlib
from pathlib import Path

sys.path.insert(0, os.path.dirname(__file__))
from asc_api import api, find_app_id, get_or_create_version, get_localization_id

APP_VERSION = os.environ.get("APP_VERSION", "1.4")
SCREENSHOT_DIR = Path(os.environ.get("SCREENSHOT_DIR", "AppStoreScreenshots"))

DISPLAY_TYPES = {
    ".": "APP_IPHONE_67",
    "iphone_65": "APP_IPHONE_65",
    "ipad_129": "APP_IPAD_PRO_129",
}


def md5_checksum(path):
    return hashlib.md5(path.read_bytes()).hexdigest()


def upload_screenshot(ss_set_id, file_path):
    file_size = file_path.stat().st_size
    file_name = file_path.name
    checksum = md5_checksum(file_path)

    reservation = api("POST", "/appScreenshots", json={
        "data": {
            "type": "appScreenshots",
            "attributes": {"fileName": file_name, "fileSize": file_size},
            "relationships": {
                "appScreenshotSet": {"data": {"type": "appScreenshotSets", "id": ss_set_id}},
            },
        }
    })

    screenshot_id = reservation["data"]["id"]
    upload_ops = reservation["data"]["attributes"].get("uploadOperations", [])

    import requests
    for op in upload_ops:
        url = op["url"]
        headers = {h["name"]: h["value"] for h in op.get("requestHeaders", [])}
        offset = op["offset"]
        length = op["length"]
        chunk = file_path.read_bytes()[offset:offset + length]
        resp = requests.put(url, headers=headers, data=chunk)
        if not resp.ok:
            raise RuntimeError(f"Upload chunk failed: {resp.status_code} {resp.text}")

    api("PATCH", f"/appScreenshots/{screenshot_id}", json={
        "data": {
            "type": "appScreenshots",
            "id": screenshot_id,
            "attributes": {"uploaded": True, "sourceFileChecksum": checksum},
        }
    })

    for attempt in range(30):
        check = api("GET", f"/appScreenshots/{screenshot_id}")
        state = check["data"]["attributes"].get("assetDeliveryState", {}).get("state", "")
        if state == "COMPLETE":
            print(f"  {file_name} upload complete")
            return screenshot_id
        elif state == "FAILED":
            errors = check["data"]["attributes"].get("assetDeliveryState", {}).get("errors", [])
            raise RuntimeError(f"Screenshot processing failed: {errors}")
        print(f"  {file_name}: {state}, waiting...")
        time.sleep(5)
    raise RuntimeError(f"Screenshot {file_name} processing timed out")


def process_display_type(loc_id, subdir, display_type):
    if subdir == ".":
        ss_path = SCREENSHOT_DIR
    else:
        ss_path = SCREENSHOT_DIR / subdir

    screenshots = sorted(ss_path.glob("*.png"))
    if not screenshots:
        print(f"No screenshots for {display_type} in {ss_path}")
        return

    print(f"\n{display_type}: {len(screenshots)} screenshots from {ss_path}")

    sets_payload = api("GET", f"/appStoreVersionLocalizations/{loc_id}/appScreenshotSets")
    ss_set_id = None
    for item in sets_payload.get("data", []):
        if item["attributes"].get("screenshotDisplayType") == display_type:
            ss_set_id = item["id"]
            break

    if not ss_set_id:
        set_payload = api("POST", "/appScreenshotSets", json={
            "data": {
                "type": "appScreenshotSets",
                "attributes": {"screenshotDisplayType": display_type},
                "relationships": {
                    "appStoreVersionLocalization": {
                        "data": {"type": "appStoreVersionLocalizations", "id": loc_id}
                    },
                },
            }
        })
        ss_set_id = set_payload["data"]["id"]
        print(f"Created screenshot set {ss_set_id}")
    else:
        print(f"Using existing screenshot set {ss_set_id}")
        existing = api("GET", f"/appScreenshotSets/{ss_set_id}/appScreenshots")
        for item in existing.get("data", []):
            try:
                api("DELETE", f"/appScreenshots/{item['id']}")
                print(f"  Deleted existing screenshot {item['id']}")
            except RuntimeError:
                pass

    for ss_file in screenshots:
        print(f"Uploading {ss_file.name}...")
        upload_screenshot(ss_set_id, ss_file)


def main():
    app_id = find_app_id()
    version_id = get_or_create_version(app_id, APP_VERSION)
    loc_id = get_localization_id(version_id)

    for subdir, display_type in DISPLAY_TYPES.items():
        process_display_type(loc_id, subdir, display_type)

    print("\nAll screenshots uploaded")


if __name__ == "__main__":
    main()
