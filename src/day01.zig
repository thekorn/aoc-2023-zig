const std = @import("std");
const utils = @import("utils.zig");

const digitWords = [_][]const u8{
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
};

fn getFirstdigit(line: []const u8) !i32 {
    var l = line.len;
    while (l > 0) : (l -= 1) {
        var c: u8 = line[line.len - l];
        if (std.ascii.isDigit(c)) {
            return c - '0';
        } else {
            for (digitWords, 1..) |word, word_i| {
                if (std.mem.startsWith(u8, line[line.len - l ..], word)) {
                    return @intCast(word_i);
                }
            }
        }
    }
    return undefined;
}

fn getLastdigit(line: []const u8) !i32 {
    var l = line.len;
    var n: i32 = undefined;
    while (l > 0) : (l -= 1) {
        var c: u8 = line[line.len - l];
        if (std.ascii.isDigit(c)) {
            n = c - '0';
        } else {
            for (digitWords, 1..) |word, word_i| {
                if (std.mem.startsWith(u8, line[line.len - l ..], word)) {
                    n = @intCast(word_i);
                }
            }
        }
    }
    return n;
}

pub fn solve(content: []const u8) !i32 {
    var result: i32 = 0;
    var lines = std.ArrayList([]const u8).init(utils.gpa);
    defer lines.deinit();
    var readIter = std.mem.tokenize(u8, content, "\n");
    while (readIter.next()) |line| {
        var start: i32 = try getFirstdigit(line);
        var end: i32 = getLastdigit(line) catch start;
        var s = start * 10 + end;
        result += s;
    }
    return result;
}

pub fn main() !void {
    const content = @embedFile("data/day01.txt");
    const result = try solve(content);
    utils.print("Result: {}\n", .{result});
}

test "part1 test" {
    const content =
        \\1abc2
        \\pqr3stu8vwx
        \\a1b2c3d4e5f
        \\treb7uchet
    ;
    const result = try solve(content);
    try std.testing.expectEqual(@as(i32, 142), result);
}

test "part2 test" {
    const content =
        \\two1nine
        \\eightwothree
        \\abcone2threexyz
        \\xtwone3four
        \\4nineeightseven2
        \\zoneight234
        \\7pqrstsixteen
    ;
    const result = try solve(content);
    try std.testing.expectEqual(@as(i32, 281), result);
}
