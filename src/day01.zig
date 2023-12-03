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

fn getFirstdigit(line: []const u8, firstDigitPos: *usize) !i32 {
    var l = line.len;
    while (l > 0) : (l -= 1) {
        var c: u8 = line[line.len - l];
        if (std.ascii.isDigit(c)) {
            firstDigitPos.* = @min(line.len - l + 1, line.len);
            return c - '0';
        } else {
            for (digitWords, 1..) |word, word_i| {
                if (std.mem.startsWith(u8, line[line.len - l ..], word)) {
                    firstDigitPos.* = @min(line.len - l + 1 + word.len, line.len);
                    return @intCast(word_i);
                }
            }
        }
    }
    return error.UnexpectedEof;
}

fn getLastdigit(line: []const u8) !i32 {
    var l = line.len;
    var found = false;
    var n: i32 = undefined;
    while (l > 0) : (l -= 1) {
        var c: u8 = line[line.len - l];
        if (std.ascii.isDigit(c)) {
            found = true;
            n = c - '0';
        } else {
            for (digitWords, 1..) |word, word_i| {
                if (std.mem.startsWith(u8, line[line.len - l ..], word)) {
                    found = true;
                    n = @intCast(word_i);
                }
            }
        }
    }
    if (found) return n;
    return error.UnexpectedEof;
}

pub fn solve(content: []const u8) !i32 {
    var result: i32 = 0;
    var readIter = std.mem.tokenize(u8, content, "\n");
    while (readIter.next()) |line| {
        var firstDigitPos: usize = 0;
        var start: i32 = try getFirstdigit(line, &firstDigitPos);
        var end: i32 = getLastdigit(line[firstDigitPos - 1 ..]) catch start;
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
