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

    @staticmethod
    def center(node):
        x1, y1, x2, y2 = Catalogue.bounds(node)
        return (x1 + x2) // 2, (y1 + y2) // 2

    def tap_node(self, node):
        self.run("shell", "input", "tap", *map(str, self.center(node)))
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
        # Back leaves the activity when the software keyboard has not opened.
        keyboard = self.run("shell", "dumpsys", "input_method").decode()
        if "mInputShown=true" in keyboard:
            self.run("shell", "input", "keyevent", "KEYCODE_BACK")
        for _ in range(4):
            target = next((n for n in self.nodes() if n.get("text") == demo
                           and n.get("class") != "android.widget.EditText"), None)
            if target is not None:
                self.tap_node(target)
                for _ in range(4):
                    nodes = self.nodes()
                    if any(n.get("text") == demo for n in nodes) and any(n.get("content-desc") == "Back" for n in nodes):
                        return
                    time.sleep(0.2)
                raise AssertionError("Catalogue route did not render: " + demo)
            time.sleep(0.2)
        raise AssertionError("Missing catalogue route: " + demo)

    def has_text(self, text):
        return any(n.get("text") == text for n in self.nodes())

    def visible_index(self, nodes=None):
        for node in (self.nodes() if nodes is None else nodes):
            text = node.get("text", "")
            if text.startswith("Visible cell:"):
                return int(text.split(":")[1].replace(",", ""))
            if text == "No visible cell":
                return None
        raise AssertionError("Missing DynamicList position")

    def visible_index_matches_cells(self, nodes):
        # UIAutomator clips cell bounds to their scroll viewport. Compare the
        # callback against rendered cells, including a partial leading cell.
        indices = []
        for node in nodes:
            match = re.fullmatch(r"dynamic-list-cell-(\d+)", node.get("resource-id", ""))
            if match:
                left, top, right, bottom = self.bounds(node)
                if right > left and bottom > top:
                    indices.append(int(match.group(1)))
        return bool(indices) and self.visible_index(nodes) == min(indices)

    def wait_for(self, predicate, timeout=5):
        """Wait for rendered state, including native animations, within a deadline."""
        deadline = time.monotonic() + timeout
        while True:
            if predicate(self.nodes()):
                return True
            if time.monotonic() >= deadline:
                return False
            time.sleep(0.1)

    def calendar_days(self, nodes=None):
        return [n for n in (self.nodes() if nodes is None else nodes) if re.match(
            r"^(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday), .*\d{4}$",
            n.get("content-desc", ""))]

    def swipe(self, x1, y1, x2, y2, duration=400):
        self.run("shell", "input", "swipe", str(x1), str(y1), str(x2), str(y2), str(duration))
        time.sleep(0.5)

    def drag(self, x1, y1, x2, y2):
        # Like the iOS UI test, hold the exact endpoint before lifting. `input
        # swipe` can deliver that endpoint only as touch-up, after the last move.
        self.run("shell", "input", "motionevent", "DOWN", str(x1), str(y1))
        try:
            time.sleep(0.2)
            for step in range(1, 13):
                x = round(x1 + (x2 - x1) * step / 12)
                y = round(y1 + (y2 - y1) * step / 12)
                self.run("shell", "input", "motionevent", "MOVE", str(x), str(y))
                time.sleep(0.045)
            time.sleep(0.4)
        finally:
            self.run("shell", "input", "motionevent", "UP", str(x2), str(y2))
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
    def at_index(index):
        # Observe the callback and the actual cell in the same UI snapshot.
        return catalogue.wait_for(lambda nodes: catalogue.visible_index(nodes) == index
                                  and any(n.get("text") == str(index) for n in nodes))

    def shows_cell(index):
        return catalogue.wait_for(lambda nodes: any(n.get("text") == str(index) for n in nodes))

    catalogue.open("DynamicList")
    check("non-empty list reports its initial visible cell", catalogue.visible_index() == 0)
    for axis in ("Horizontal", "Vertical"):
        catalogue.tap(axis)
        catalogue.tap("Start")
        check(axis + " initial cell-ID position", at_index(0))
        catalogue.tap("Advance 3 cells")
        check(axis + " cell-ID command", at_index(3))
        catalogue.tap("End")
        check(axis + " end cell is visible", shows_cell(29))
        catalogue.tap("Start")
        check(axis + " returns to the first cell", at_index(0))
        catalogue.switch("Show more cell content")
        check(axis + " automatic cells resize", catalogue.has_text("Additional cell content"))
        catalogue.tap("Advance 3 cells")
        check(axis + " resized cell-ID command", at_index(3))
        catalogue.switch("Show more cell content")
        catalogue.tap("Start")
        check(axis + " resets before the native drag", at_index(0))
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
    check("shrinking list exposes its last cell", shows_cell(19))
    catalogue.tap("Decrement")
    catalogue.tap("Decrement")
    check("empty list publishes nil", catalogue.wait_for(lambda nodes: catalogue.visible_index(nodes) is None))
    catalogue.tap("Increment")
    check("repopulated list reports its initial cell", at_index(0))
    catalogue.tap("Start")
    check("repopulated list scrolls", at_index(0))
    catalogue.tap("0")
    check("list cell taps reach their content action", catalogue.has_text("Last tapped cell: 0"))
    for sizing in ("Uniform", "Variable"):
        catalogue.tap(sizing)
        check(sizing + " sizing preserves the selected cell", catalogue.has_text("Last tapped cell: 0"))
        catalogue.tap("Start")
        catalogue.tap("Advance 3 cells")
        check(sizing + " explicit lengths scroll by cell ID", at_index(3))


def verify_dynamic_list_long_jumps(catalogue):
    catalogue.open("DynamicList")
    catalogue.tap("Use 10,000 cells")

    # Skip currently animates a longer final stretch for distant requests.
    # This deadline verifies arrival, not the separate animation-performance limitation.
    def cell(nodes, index):
        return next((n for n in nodes if n.get("resource-id") == f"dynamic-list-cell-{index}"
                     and catalogue.bounds(n)[2] > catalogue.bounds(n)[0]
                     and catalogue.bounds(n)[3] > catalogue.bounds(n)[1]), None)

    for axis in ("Horizontal", "Vertical"):
        catalogue.tap(axis)
        for sizing in ("Automatic", "Uniform", "Variable"):
            catalogue.tap(sizing)
            for command, target in (("Start", 0), ("End", 9999), ("Middle", 5000), ("End", 9999), ("Start", 0)):
                catalogue.tap(command)
                check(f"{axis} {sizing} long jump to {target}",
                      catalogue.wait_for(lambda nodes: cell(nodes, target) is not None
                                          and catalogue.visible_index_matches_cells(nodes), timeout=20))
                catalogue.tap_node(cell(catalogue.nodes(), target))
                check(f"{axis} {sizing} target {target} remains interactive",
                      catalogue.wait_for(lambda nodes: any(n.get("text", "").replace(",", "")
                                                           == f"Last tapped cell: {target}" for n in nodes)))
            catalogue.tap("Middle")
            check(f"{axis} {sizing} returns to the middle", catalogue.wait_for(lambda nodes: cell(nodes, 5000) is not None, timeout=20))
            nodes = catalogue.nodes()
            before = catalogue.visible_index(nodes)
            top = catalogue.bounds(next(n for n in nodes if n.get("text") == "Use 10,000 cells"))[3] + 20
            bottom = catalogue.bounds(next(n for n in nodes if n.get("text", "").startswith("Visible cell:")))[1] - 20
            if axis == "Horizontal":
                catalogue.swipe(200, (top + bottom) // 2, 850, (top + bottom) // 2)
            else:
                catalogue.swipe(540, top + 30, 540, bottom - 30)
            check(f"{axis} {sizing} native drag after a long jump",
                  catalogue.wait_for(lambda nodes: catalogue.visible_index(nodes) is not None
                                      and catalogue.visible_index(nodes) < before
                                      and catalogue.visible_index_matches_cells(nodes)))


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


def verify_rating(catalogue):
    catalogue.open("Rating")
    density = int(re.findall(r"\d+", catalogue.run("shell", "wm", "density").decode())[-1]) / 160

    def check_cells():
        for _ in range(4):
            cells = [n for n in catalogue.nodes() if re.fullmatch(r"[1-5] of 5 stars", n.get("content-desc", ""))]
            if len(cells) == 15:
                break
            time.sleep(0.2)
        check("rating renders interactive, read-only and compact groups", len(cells) == 15)
        for group, maximum in enumerate((48, 32, 24)):
            bounds = [catalogue.bounds(n) for n in cells[group * 5:(group + 1) * 5]]
            check("rating group " + str(group) + " fits square cell bounds",
                  all(abs((right - left) - (bottom - top)) <= 1
                      and 0 < right - left <= maximum * density + 1
                      for left, top, right, bottom in bounds))
            check("rating group " + str(group) + " cells do not overlap",
                  all(first[2] <= second[0] for first, second in zip(bounds, bounds[1:])))

    check_cells()
    catalogue.tap("5 of 5 stars")
    check("rating selection updates binding", catalogue.has_text("Rating: 5.0 / 5"))
    sliders = [n for n in catalogue.nodes() if n.get("class") == "android.widget.SeekBar"]
    left, top, right, bottom = catalogue.bounds(sliders[1])
    catalogue.run("shell", "input", "tap", str(right - 2), str((top + bottom) // 2))
    check_cells()


def verify_counting(catalogue):
    catalogue.open("Counting Label")

    def settled(target):
        amount = f"{target / 4:.2f}"
        expected = {f"Score: {target}", f"Down {100 - target}, up {target}",
                    f"Paid {amount}, saved {amount}", f"Complete: {target}.0%",
                    f"Target: {target}"}
        deadline = time.monotonic() + 10
        while True:
            texts = {node.get("text") for node in catalogue.nodes()}
            if expected <= texts or time.monotonic() >= deadline:
                break
            time.sleep(0.2)
        check(f"counting target {target} updates integers, both directions, decimals and percentage",
              expected <= texts)

    settled(50)
    catalogue.tap("Increment")
    settled(60)
    catalogue.tap("Decrement")
    settled(50)
    catalogue.tap("Decrement")
    settled(40)


def verify_progress(catalogue):
    catalogue.open("Progress")
    check("progress displays its initial percentage", catalogue.has_text("35%"))
    catalogue.tap("Animate to completion")
    for _ in range(4):
        if catalogue.has_text("100%"):
            break
        time.sleep(0.2)
    check("progress percentage reaches completion", catalogue.has_text("100%"))
    catalogue.tap("Reset")
    check("progress percentage resets", catalogue.has_text("0%"))
    slider = next(n for n in catalogue.nodes() if n.get("class") == "android.widget.SeekBar")
    left, top, right, bottom = catalogue.bounds(slider)
    catalogue.run("shell", "input", "tap", str((left + right) // 2), str((top + bottom) // 2))
    percentages = [n.get("text", "") for n in catalogue.nodes() if re.fullmatch(r"\d+%", n.get("text", ""))]
    check("progress slider updates its percentage", any(40 <= int(p[:-1]) <= 60 for p in percentages))


def verify_calendar(catalogue):
    days = catalogue.calendar_days
    center = catalogue.center

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
    for _ in range(4):
        cells = days()
        if len(cells) >= 28 and square_cells(cells):
            break
        time.sleep(0.2)
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
    for _ in range(8):
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
    for _ in range(8):
        cells = days()
        first = next((n for n in cells if re.search(r", 5 January \d{4}$", n.get("content-desc", ""))), None)
        last = next((n for n in cells if re.search(r", 11 February \d{4}$", n.get("content-desc", ""))), None)
        if first is not None and last is not None:
            break
        time.sleep(0.2)
    check("year calendar exposes dates across adjacent months", first is not None and last is not None)
    # Scroll between month columns so the page moves without starting a range.
    # Drag selection must use the new row positions even when days do not redraw.
    original_top = catalogue.bounds(first)[1]
    scroll = next(n for n in catalogue.nodes() if n.get("scrollable") == "true")
    left, top, right, bottom = catalogue.bounds(scroll)
    middle = (left + right) // 2
    height = bottom - top
    for _ in range(3):
        catalogue.swipe(middle, top + height * 3 // 4, middle, top + height // 4, duration=1000)
        cells = days()
        first = next((n for n in cells if re.search(r", 5 January \d{4}$", n.get("content-desc", ""))), None)
        last = next((n for n in cells if re.search(r", 11 February \d{4}$", n.get("content-desc", ""))), None)
        if first is None or catalogue.bounds(first)[1] < original_top:
            break
    check("year calendar scroll changes day positions", first is not None and last is not None
          and catalogue.bounds(first)[1] < original_top)
    check("scrolling between months preserves the selection", catalogue.has_text("Selected days: 0"))
    catalogue.drag(*center(first), *center(last))
    check("calendar drag crosses month boundaries after scrolling", catalogue.has_text("Selected days: 38"))


def verify_calendar_state(catalogue):
    def summary():
        texts = [n.get("text") for n in catalogue.nodes() if n.get("text")]
        index = next(i for i, text in enumerate(texts) if text.endswith(" selected calendar days"))
        return texts[index - 1], texts[index]

    def drag_days(first, last):
        days = catalogue.calendar_days()
        catalogue.drag(*catalogue.center(days[first]), *catalogue.center(days[last]))

    catalogue.open("Calendar")
    catalogue.tap("Week")
    catalogue.tap_node(catalogue.calendar_days()[1])
    catalogue.tap_node(catalogue.calendar_days()[3])
    selected = summary()
    check("calendar establishes a three-day range", selected[1] == "3 selected calendar days")
    catalogue.switch("Custom day cells")
    check("custom day and header styling preserves the exact selected range", summary() == selected)
    catalogue.tap("Next")
    check("calendar navigation preserves offscreen selected dates", summary() == selected)
    catalogue.tap("Previous")
    catalogue.switch("Monday first")
    check("weekday order changes preserve selected dates", summary() == selected)
    catalogue.switch("Enable selection")
    catalogue.tap_node(catalogue.calendar_days()[0])
    drag_days(0, 4)
    check("disabled custom calendar ignores taps and range drags", summary() == selected)
    catalogue.switch("Enable selection")
    catalogue.switch("Select a date range")
    catalogue.tap_node(catalogue.calendar_days()[0])
    single = summary()
    check("single-selection mode replaces the range", single[1] == "1 selected calendar days")
    drag_days(1, 3)
    check("single-selection mode ignores range drags", summary() == single)
    catalogue.switch("Custom day cells")
    catalogue.tap("Month")
    catalogue.tap("Week")
    check("restoring default style and period preserves selection", summary() == single)
    catalogue.switch("Select a date range")
    catalogue.tap("Clear selection")
    drag_days(1, 3)
    check("range dragging still works after style and mode changes", summary()[1] == "3 selected calendar days")


def verify_muscle_map(catalogue, screenshots=None):
    def point(label, x, y):
        target = next(n for n in catalogue.nodes() if n.get("content-desc") == label)
        left, top, right, bottom = catalogue.bounds(target)
        return round(left + x * (right - left)), round(top + y * (bottom - top))

    def tap_point(coordinates):
        catalogue.run("shell", "input", "tap", *map(str, coordinates))
        time.sleep(0.4)

    def selected():
        for _ in range(3):
            nodes = catalogue.nodes()
            value = next((n.get("text") for n in nodes if n.get("text", "").startswith("Selected:")), None)
            if value is not None:
                return value
            # Shorter viewports place the summary below the map. This tap-only
            # map permits page scrolling without changing the selected regions.
            target = next(n for n in nodes if n.get("content-desc") == "Muscle map")
            left, top, right, bottom = catalogue.bounds(target)
            catalogue.swipe((left + right) // 2, bottom - 50, (left + right) // 2,
                            max(top, bottom - 450))
        raise AssertionError("Missing muscle-map selection summary")

    def painted_count():
        return int(next(n.get("text") for n in catalogue.nodes()
                        if n.get("text", "").startswith("Painted regions:")).split(":")[1])

    catalogue.open("Muscle Map")
    catalogue.tap("Front")
    tap_point(point("Muscle map", .5, .2))
    check("front map tap selects a named region", "neck" in selected())
    selection = selected()
    catalogue.switch("Show region outlines")
    check("map outline styling preserves selected regions", selected() == selection)
    catalogue.tap("Linear")
    catalogue.tap("Radial")
    check("map gradient styling preserves selected regions", selected() == selection)
    catalogue.tap("Both")
    check("map visibility changes preserve selected regions", selected() == selection)
    catalogue.tap("Front")
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

    verify_rating(catalogue)
    verify_counting(catalogue)
    verify_progress(catalogue)

    verify_search(catalogue)
    verify_dynamic_list(catalogue)
    verify_dynamic_list_long_jumps(catalogue)
    verify_integrations(catalogue)
    verify_calendar(catalogue)
    verify_calendar_state(catalogue)
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
