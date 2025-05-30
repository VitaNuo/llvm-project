import os
from pathlib import Path

from clang.cindex import (
    Config,
    Cursor,
    File,
    SourceLocation,
    SourceRange,
    TranslationUnit,
)

if "CLANG_LIBRARY_PATH" in os.environ:
    Config.set_library_path(os.environ["CLANG_LIBRARY_PATH"])

import unittest

from .util import get_cursor, get_tu

INPUTS_DIR = Path(__file__).parent / "INPUTS"

BASE_INPUT = "int one;\nint two;\n"


class TestLocation(unittest.TestCase):
    def assert_location(self, loc, line, column, offset):
        self.assertEqual(loc.line, line)
        self.assertEqual(loc.column, column)
        self.assertEqual(loc.offset, offset)

    def test_location(self):
        tu = get_tu(BASE_INPUT)
        one = get_cursor(tu, "one")
        two = get_cursor(tu, "two")

        self.assertIsNotNone(one)
        self.assertIsNotNone(two)

        self.assert_location(one.location, line=1, column=5, offset=4)
        self.assert_location(two.location, line=2, column=5, offset=13)

        # adding a linebreak at top should keep columns same
        tu = get_tu("\n" + BASE_INPUT)
        one = get_cursor(tu, "one")
        two = get_cursor(tu, "two")

        self.assertIsNotNone(one)
        self.assertIsNotNone(two)

        self.assert_location(one.location, line=2, column=5, offset=5)
        self.assert_location(two.location, line=3, column=5, offset=14)

        # adding a space should affect column on first line only
        tu = get_tu(" " + BASE_INPUT)
        one = get_cursor(tu, "one")
        two = get_cursor(tu, "two")

        self.assert_location(one.location, line=1, column=6, offset=5)
        self.assert_location(two.location, line=2, column=5, offset=14)

        # define the expected location ourselves and see if it matches
        # the returned location
        tu = get_tu(BASE_INPUT)

        file = File.from_name(tu, "t.c")
        location = SourceLocation.from_position(tu, file, 1, 5)
        cursor = Cursor.from_location(tu, location)

        one = get_cursor(tu, "one")
        self.assertIsNotNone(one)
        self.assertEqual(one, cursor)

        # Ensure locations referring to the same entity are equivalent.
        location2 = SourceLocation.from_position(tu, file, 1, 5)
        self.assertEqual(location, location2)
        location3 = SourceLocation.from_position(tu, file, 1, 4)
        self.assertNotEqual(location2, location3)

        offset_location = SourceLocation.from_offset(tu, file, 5)
        cursor = Cursor.from_location(tu, offset_location)
        verified = False
        for n in [n for n in tu.cursor.get_children() if n.spelling == "one"]:
            self.assertEqual(n, cursor)
            verified = True

        self.assertTrue(verified)

    def test_extent(self):
        tu = get_tu(BASE_INPUT)
        one = get_cursor(tu, "one")
        two = get_cursor(tu, "two")

        self.assert_location(one.extent.start, line=1, column=1, offset=0)
        self.assert_location(one.extent.end, line=1, column=8, offset=7)
        self.assertEqual(
            BASE_INPUT[one.extent.start.offset : one.extent.end.offset], "int one"
        )

        self.assert_location(two.extent.start, line=2, column=1, offset=9)
        self.assert_location(two.extent.end, line=2, column=8, offset=16)
        self.assertEqual(
            BASE_INPUT[two.extent.start.offset : two.extent.end.offset], "int two"
        )

        file = File.from_name(tu, "t.c")
        location1 = SourceLocation.from_position(tu, file, 1, 1)
        location2 = SourceLocation.from_position(tu, file, 1, 8)

        range1 = SourceRange.from_locations(location1, location2)
        range2 = SourceRange.from_locations(location1, location2)
        self.assertEqual(range1, range2)

        location3 = SourceLocation.from_position(tu, file, 1, 6)
        range3 = SourceRange.from_locations(location1, location3)
        self.assertNotEqual(range1, range3)

    def test_is_system_location(self):
        header = os.path.normpath("./fake/fake.h")
        tu = TranslationUnit.from_source(
            "fake.c",
            [f"-isystem{os.path.dirname(header)}"],
            unsaved_files=[
                (
                    "fake.c",
                    """
#include <fake.h>
int one;
""",
                ),
                (header, "int two();"),
            ],
        )
        one = get_cursor(tu, "one")
        two = get_cursor(tu, "two")
        self.assertFalse(one.location.is_in_system_header)
        self.assertTrue(two.location.is_in_system_header)

    def test_operator_lt(self):
        tu = get_tu("aaaaa")
        t1_f = tu.get_file(tu.spelling)
        tu2 = get_tu("aaaaa")

        l_t1_12 = SourceLocation.from_position(tu, t1_f, 1, 2)
        l_t1_13 = SourceLocation.from_position(tu, t1_f, 1, 3)
        l_t1_14 = SourceLocation.from_position(tu, t1_f, 1, 4)

        l_t2_13 = SourceLocation.from_position(tu2, tu2.get_file(tu2.spelling), 1, 3)

        # In same file
        assert l_t1_12 < l_t1_13 < l_t1_14
        assert not l_t1_13 < l_t1_12

        # In same file, different TU
        assert l_t1_12 < l_t2_13 < l_t1_14
        assert not l_t2_13 < l_t1_12
        assert not l_t1_14 < l_t2_13

    def test_equality(self):
        path = INPUTS_DIR / "testfile.c"
        path_a = INPUTS_DIR / "a.inc"
        tu = TranslationUnit.from_source(path)
        main_file = File.from_name(tu, path)
        a_file = File.from_name(tu, path_a)

        location1 = SourceLocation.from_position(tu, main_file, 1, 3)
        location2 = SourceLocation.from_position(tu, main_file, 2, 2)
        location1_2 = SourceLocation.from_position(tu, main_file, 1, 3)
        file2_location1 = SourceLocation.from_position(tu, a_file, 1, 3)

        self.assertEqual(location1, location1)
        self.assertEqual(location1, location1_2)
        self.assertNotEqual(location1, location2)
        self.assertNotEqual(location1, file2_location1)
        self.assertNotEqual(location1, "foo")
