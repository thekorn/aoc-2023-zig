const std = @import("std");
const utils = @import("utils.zig");

fn getFirstdigit(line: []const u8) !usize {
    var l = line.len;
    while (l > 0) : (l -= 1) {
        var c: u8 = line[line.len - l];
        if (std.ascii.isDigit(c)) {
            return c;
        }
    }
    return undefined;
}

fn getLastdigit(line: []const u8) !usize {
    var l = line.len;
    var n: usize = undefined;
    while (l > 0) : (l -= 1) {
        var c: u8 = line[line.len - l];
        if (std.ascii.isDigit(c)) {
            n = c;
        }
    }
    return n;
}

pub fn part1(content: []const u8) !usize {
    var result: usize = 0;
    var lines = std.ArrayList([]const u8).init(utils.gpa);
    defer lines.deinit();
    var readIter = std.mem.tokenize(u8, content, "\n");
    while (readIter.next()) |line| {
        var start: usize = try getFirstdigit(line);
        var end: usize = getLastdigit(line) catch start;
        var s = (start - 48) * 10 + end - 48;
        result += s;
        //utils.print("{}\n", .{s});
    }
    return result;
}

pub fn main() !void {
    const content = @embedFile("data/day01/part1.txt");
    const result = try part1(content);
    utils.print("Result part 1: {}\n", .{result});
}

test "part1 test" {
    const content =
        \\1abc2
        \\pqr3stu8vwx
        \\a1b2c3d4e5f
        \\treb7uchet
    ;
    const result = try part1(content);
    try std.testing.expectEqual(@as(usize, 142), result);
}
