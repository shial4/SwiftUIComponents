#!/usr/bin/env python3
"""Smoke-test an installed debug catalogue using adb and the standard library."""
import argparse
import json
import re
import subprocess
import time
import xml.etree.ElementTree as ET
from pathlib import Path

APP = "com.swiftui.components.catalog"
ACTIVITY = APP + "/component.catalog.MainActivity"
INVENTORY = Path(__file__).resolve().parent.parent / "Documentation" / "Examples.json"
DEMOS = [(entry["name"], entry["image"]) for entry in json.loads(INVENTORY.read_text())]


class Catalogue:
    def __init__(self, serial):
        self.adb = ["adb"] + (["-s", serial] if serial else [])

    def run(self, *args):
        return subprocess.check_output(self.adb + list(args), stderr=subprocess.DEVNULL)

    def nodes(self):
        self.run("shell", "uiautomator", "dump", "/sdcard/components.xml")
        root = ET.fromstring(self.run("shell", "cat", "/sdcard/components.xml"))
        # A launcher icon with the same label must never count as a rendered demo.
        return [n for n in root.iter("node") if n.get("package") == APP]

    @staticmethod
    def bounds(node):
        return tuple(map(int, re.findall(r"\d+", node.get("bounds", ""))))

    def tap_node(self, node):
        x1, y1, x2, y2 = self.bounds(node)
        self.run("shell", "input", "tap", str((x1 + x2) // 2), str((y1 + y2) // 2))
        time.sleep(0.4)

    def tap(self, label):
        for node in self.nodes():
            if (node.get("class") != "android.widget.EditText"
                    and label in (node.get("text"), node.get("content-desc"))):
                self.tap_node(node)
                return
        raise AssertionError("Missing control: " + label)

    def switch(self, label):
        nodes = self.nodes()
        target = next(n for n in nodes if n.get("text") == label)
        _, top, _, bottom = self.bounds(target)
        center = (top + bottom) // 2
        for node in nodes:
            if node.get("checkable") == "true":
                _, top, _, bottom = self.bounds(node)
                if top <= center <= bottom:
                    self.tap_node(node)
                    return
        raise AssertionError("Missing switch: " + label)

    def launch(self):
        self.run("shell", "am", "force-stop", APP)
        self.run("shell", "am", "start", "-f", "0x10008000", "-n", ACTIVITY)
        # Reset the activity task, preserving SharedPreferences for restart checks.
        for _ in range(4):
            nodes = self.nodes()
            if any(n.get("text") == "SwiftUI Components" for n in nodes):
                return nodes
            time.sleep(0.2)
        raise AssertionError("Catalogue root did not render after launch")

    def open(self, demo):
        root = self.launch()
        field = next(n for n in root if n.get("class") == "android.widget.EditText")
        self.tap_node(field)
        self.run("shell", "input", "text", demo.replace(" ", "%s"))
        self.run("shell", "input", "keyevent", "KEYCODE_BACK")
        for _ in range(4):
            target = next((n for n in self.nodes() if n.get("text") == demo
                           and n.get("class") != "android.widget.EditText"), None)
            if target is not None:
                self.tap_node(target)
                return
            time.sleep(0.2)
        raise AssertionError("Missing catalogue route: " + demo)

    def has_text(self, text):
        return any(n.get("text") == text for n in self.nodes())

    def visible_index(self):
        for node in self.nodes():
            text = node.get("text", "")
            if text.startswith("Visible cell:"):
                return int(text.split(":")[1])
            if text == "No visible cell":
                return None
        raise AssertionError("Missing DynamicList position")

    def swipe(self, x1, y1, x2, y2, duration=400):
        self.run("shell", "input", "swipe", str(x1), str(y1), str(x2), str(y2), str(duration))
        time.sleep(0.5)


def check(name, condition):
    if not condition:
        raise AssertionError(name)
    print("PASS: " + name, flush=True)


def verify_search(catalogue):
    catalogue.open("Search Bar")
    for query, result in (("Cal", "Calendar"), ("Muscle", "Muscle Map"), ("", None)):
        field = next(n for n in catalogue.nodes() if n.get("class") == "android.widget.EditText")
        catalogue.tap_node(field)
        if query:
            catalogue.run("shell", "input", "text", query)
            nodes = catalogue.nodes()
            check("search filters " + query, any(n.get("text") == result for n in nodes)
                  and not any(n.get("text") == "DynamicList" for n in nodes))
        # Find the button after filtering: the keyboard changes its screen position.
        catalogue.tap("Clear search")
        nodes = catalogue.nodes()
        field = next(n for n in nodes if n.get("class") == "android.widget.EditText")
        check("clear restores results for " + repr(query), field.get("text", "") == ""
              and any(n.get("text") == "DynamicList" for n in nodes))
        check("clear dismisses focus for " + repr(query), field.get("focused") == "false"
              and not any(n.get("content-desc") == "Clear search" for n in nodes))
        keyboard = catalogue.run("shell", "dumpsys", "input_method").decode()
        check("clear dismisses keyboard for " + repr(query), "mInputShown=false" in keyboard)


def verify_dynamic_list(catalogue):
    catalogue.open("DynamicList")
    for axis in ("Horizontal", "Vertical"):
        catalogue.tap(axis)
        catalogue.tap("Start")
        check(axis + " initial cell-ID position", catalogue.visible_index() == 0)
        catalogue.tap("Advance 3 cells")
        check(axis + " cell-ID command", catalogue.visible_index() == 3 and catalogue.has_text("3"))
        catalogue.tap("End")
        check(axis + " end cell is visible", catalogue.has_text("29"))
        catalogue.tap("Start")
        catalogue.switch("Show more cell content")
        check(axis + " automatic cells resize", catalogue.has_text("Additional cell content"))
        catalogue.tap("Advance 3 cells")
        check(axis + " resized cell-ID command", catalogue.visible_index() == 3)
        catalogue.switch("Show more cell content")
        catalogue.tap("Start")
        nodes = catalogue.nodes()
        top = catalogue.bounds(next(n for n in nodes if n.get("text") == "Cells: 30"))[3] + 30
        bottom = catalogue.bounds(next(n for n in nodes if n.get("text", "").startswith("Visible cell:")))[1] - 30
        if axis == "Horizontal":
            catalogue.swipe(950, (top + bottom) // 2, 150, (top + bottom) // 2)
        else:
            catalogue.swipe(540, bottom - 20, 540, top + 20)
        check(axis + " native gesture updates cell binding", (catalogue.visible_index() or 0) > 0)

    catalogue.tap("End")
    catalogue.tap("Decrement")
    check("shrinking list keeps a valid position", 0 <= catalogue.visible_index() < 20)
    catalogue.tap("End")
    check("shrinking list exposes its last cell", catalogue.has_text("19"))
    catalogue.tap("Decrement")
    catalogue.tap("Decrement")
    check("empty list publishes nil", catalogue.visible_index() is None)
    catalogue.tap("Increment")
    catalogue.tap("Start")
    check("repopulated list scrolls", catalogue.visible_index() == 0)
    for sizing in ("Uniform", "Variable"):
        catalogue.tap(sizing)
        catalogue.tap("Start")
        catalogue.tap("Advance 3 cells")
        check(sizing + " explicit lengths scroll by cell ID", catalogue.visible_index() == 3)


def verify_integrations(catalogue):
    catalogue.open("Key-path Bindings")
    catalogue.switch("Enable dashboard")
    check("key-path binding changes its reference owner", catalogue.has_text("Dashboard disabled"))
    catalogue.open("UserDefaults JSON")
    catalogue.tap("Remove JSON")
    catalogue.tap("Save JSON")
    catalogue.open("UserDefaults JSON")
    catalogue.tap("Load JSON")
    check("JSON selection persists across process restart", catalogue.has_text("biceps, quadriceps"))
    catalogue.tap("Remove JSON")
    catalogue.tap("Load JSON")
    check("JSON nil removes the saved selection", catalogue.has_text("No saved selection"))


def verify_calendar(catalogue):
    def days(nodes=None):
        return [n for n in (catalogue.nodes() if nodes is None else nodes) if re.match(
            r"^(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday), .*\d{4}$",
            n.get("content-desc", ""))]

    def center(node):
        left, top, right, bottom = catalogue.bounds(node)
        return (left + right) // 2, (top + bottom) // 2

    def square_cells(nodes, clipped_edges=()):
        # Android accessibility bounds clip partially visible rows to the scroll viewport.
        return bool(nodes) and all(abs((right - left) - (bottom - top)) <= 1 or
                                   (bottom - top < right - left and
                                    (top in clipped_edges or bottom in clipped_edges))
                                   for left, top, right, bottom in map(catalogue.bounds, nodes))

    catalogue.open("DefaultDayView")
    numbers = [n for n in catalogue.nodes() if re.fullmatch(r"\d{1,2}", n.get("text", ""))]
    check("standalone day and all five range numbers render", len(numbers) == 6)
    density = int(re.findall(r"\d+", catalogue.run("shell", "wm", "density").decode())[-1]) / 160
    first, second = center(numbers[0]), center(numbers[1])
    range_side = center(numbers[2])[0] - second[0]
    gap = second[1] - range_side / 2 - first[1] - 100 * density / 2
    check("standalone day reserves the 24-point gap above the range", abs(gap / density - 24) < 2)

    catalogue.open("CalendarContentView")
    cells = days()
    check("monthly calendar shares square cell dimensions", len(cells) >= 28 and square_cells(cells))
    catalogue.tap_node(cells[7])
    check("calendar tap selects one day", catalogue.has_text("Selected days: 1"))
    catalogue.tap_node(cells[10])
    check("calendar second tap extends an inclusive range", catalogue.has_text("Selected days: 4"))

    catalogue.open("CalendarContentView")
    cells = days()
    catalogue.swipe(*center(cells[7]), *center(cells[10]), duration=900)
    check("calendar drag extends a range using local grid coordinates", catalogue.has_text("Selected days: 4"))
    catalogue.tap("Week")
    cells = days()
    check("weekly calendar retains seven square cells", len(cells) == 7 and square_cells(cells))
    catalogue.tap("Year")
    settled = False
    for _ in range(4):
        nodes = catalogue.nodes()
        cells = days(nodes)
        edges = {edge for n in nodes if n.get("scrollable") == "true"
                 for edge in (catalogue.bounds(n)[1], catalogue.bounds(n)[3])}
        settled = len(cells) >= 28 and square_cells(cells, edges)
        if settled:
            break
        time.sleep(0.2)
    check("year calendar derives square cells for each month column", settled)

    catalogue.open("CalendarContentView")
    catalogue.tap("Year")
    first = last = None
    for _ in range(4):
        cells = days()
        first = next((n for n in cells if re.search(r", 5 January \d{4}$", n.get("content-desc", ""))), None)
        last = next((n for n in cells if re.search(r", 11 February \d{4}$", n.get("content-desc", ""))), None)
        if first is not None and last is not None:
            break
        time.sleep(0.2)
    check("year calendar exposes dates across adjacent months", first is not None and last is not None)
    catalogue.swipe(*center(first), *center(last), duration=900)
    check("calendar drag crosses month boundaries in year mode", catalogue.has_text("Selected days: 38"))


def verify_muscle_map(catalogue, screenshots=None):
    def point(label, x, y):
        target = next(n for n in catalogue.nodes() if n.get("content-desc") == label)
        left, top, right, bottom = catalogue.bounds(target)
        return round(left + x * (right - left)), round(top + y * (bottom - top))

    def tap_point(coordinates):
        catalogue.run("shell", "input", "tap", *map(str, coordinates))
        time.sleep(0.4)

    def selected():
        return next(n.get("text") for n in catalogue.nodes() if n.get("text", "").startswith("Selected:"))

    def painted_count():
        return int(next(n.get("text") for n in catalogue.nodes()
                        if n.get("text", "").startswith("Painted regions:")).split(":")[1])

    catalogue.open("Muscle Map")
    catalogue.tap("Front")
    tap_point(point("Muscle map", .5, .2))
    check("front map tap selects a named region", "neck" in selected())
    selection = selected()
    catalogue.switch("Enable map selection")
    tap_point(point("Muscle map", .5, .2))
    check("disabled map tap preserves selection", selected() == selection)
    catalogue.switch("Enable map selection")
    tap_point(point("Muscle map", .5, .2))
    check("a second map tap removes the region", "neck" not in selected())
    catalogue.tap("Back")
    tap_point(point("Muscle map", .5, .42))
    check("back map tap selects lower back", "lower back" in selected())

    catalogue.open("Muscle Map Drag")
    neck = point("Drag to paint muscle regions", .5, .2)
    leg = point("Drag to paint muscle regions", .46, .66)
    tap_point(neck)
    check("tap-to-paint reports a muscle", painted_count() == 1)
    catalogue.swipe(*neck, *leg, duration=900)
    count = painted_count()
    check("drag painting selects multiple regions", count > 1)
    if screenshots:
        (screenshots / "android-muscle-map-drag.png").write_bytes(catalogue.run("exec-out", "screencap", "-p"))
    catalogue.tap("Erase")
    catalogue.swipe(*neck, *leg, duration=900)
    check("drag erasing removes painted regions", painted_count() < count)
    catalogue.tap("Clear painted regions")
    check("clear painting resets state", painted_count() == 0 and catalogue.has_text("Last region: None"))

    for side, fraction in (("Front", .2), ("Back", .42)):
        catalogue.open("MuscleMap." + side)
        tap_point(point("Standalone " + side.lower() + " muscle map", .5, fraction))
        check("standalone " + side + " tap callback", not catalogue.has_text("Selected region: None"))


def verify(catalogue, screenshots):
    if screenshots:
        screenshots.mkdir(parents=True, exist_ok=True)
    for demo, filename in DEMOS:
        catalogue.open(demo)
        rendered = False
        for _ in range(4):
            nodes = catalogue.nodes()
            rendered = (any(n.get("text") == demo for n in nodes)
                        and any(n.get("content-desc") == "Back" for n in nodes)
                        and sum(bool(n.get("text")) for n in nodes) > 3)
            if rendered:
                break
            time.sleep(0.2)
        check(demo + " renders", rendered)
        if screenshots:
            (screenshots / ("android-" + filename + ".png")).write_bytes(
                catalogue.run("exec-out", "screencap", "-p"))

    catalogue.open("Checkbox")
    catalogue.tap("Filled checkbox")
    check("checkbox binding toggles", catalogue.has_text("Unchecked"))
    catalogue.tap("Outlined checkbox")
    check("checkbox variants share state", catalogue.has_text("Checked"))
    catalogue.tap("Disabled")
    check("disabled checkbox preserves state", catalogue.has_text("Checked"))

    catalogue.open("Rating")
    catalogue.tap("5 of 5 stars")
    check("rating selection updates binding", catalogue.has_text("Rating: 5.0 / 5"))

    verify_search(catalogue)
    verify_dynamic_list(catalogue)
    verify_integrations(catalogue)
    verify_calendar(catalogue)
    verify_muscle_map(catalogue, screenshots)

    catalogue.open("Codable Storage")
    catalogue.tap("Reset")
    catalogue.switch("Show details")
    check("storage readers synchronize", catalogue.has_text("Details disabled"))
    catalogue.open("Codable Storage")
    check("storage survives restart", catalogue.has_text("Details disabled"))
    catalogue.tap("Reset")
    print("Android catalogue checks passed", flush=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--serial", help="adb emulator/device serial")
    parser.add_argument("--screenshots", type=Path, help="optional screenshot output directory")
    args = parser.parse_args()
    verify(Catalogue(args.serial), args.screenshots)
